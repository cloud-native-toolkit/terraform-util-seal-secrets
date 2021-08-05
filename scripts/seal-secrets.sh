#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)
MODULE_DIR=$(cd "${SCRIPT_DIR}/.."; pwd -P)

SOURCE_DIR="$1"
DEST_DIR="$2"
SEALED_SECRETS_FILE="$3"

if [[ -z "${TMP_DIR}" ]]; then
  TMP_DIR=".tmp"
fi

SEALED_SECRETS_DIR=$(dirname "${SEALED_SECRETS_FILE}"; pwd -P)

mkdir -p "${TMP_DIR}"
mkdir -p "${DEST_DIR}"
mkdir -p "./bin"
mkdir -p "${SEALED_SECRETS_DIR}"

if [[ -z "${KUBESEAL_CERT}" ]]; then
  echo "KUBESEAL_CERT not provided as an environment variable"
  exit 1
fi

KUBESEAL_CERT_FILE="${TMP_DIR}/kubeseal.cert"
echo "${KUBESEAL_CERT}" > "${KUBESEAL_CERT_FILE}"

KUBESEAL=$(command -v kubeseal | command -v ./bin/kubeseal)
if [[ -z "${KUBESEAL}" ]]; then
  BIN_DIR=$(cd ./bin; pwd -P)
  mkdir -p "${BIN_DIR}" && curl -Lo "${BIN_DIR}/kubeseal" https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.16.0/kubeseal-linux-amd64
  chmod +x "${BIN_DIR}/kubeseal"
  KUBESEAL="${BIN_DIR}/kubeseal"
fi

echo "Kubeseal cert"
cat "${KUBESEAL_CERT_FILE}"

# Create an empty file for the sealed secrets
echo -n "" > "${SEALED_SECRETS_FILE}"

find "${SOURCE_DIR}" -name "*.yaml" | while read -r file; do
  filename=$(basename "${file}")

  ${KUBESEAL} --cert "${KUBESEAL_CERT_FILE}" --format yaml < "${file}" > "${DEST_DIR}/${filename}"
  echo "- ${DEST_DIR}/${filename}" >> "${SEALED_SECRETS_FILE}"
done

echo "Generated sealed secrets"
cat "${SEALED_SECRETS_FILE}"
