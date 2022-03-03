#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)
MODULE_DIR=$(cd "${SCRIPT_DIR}/.."; pwd -P)

SOURCE_DIR="$1"
DEST_DIR="$2"

if [[ -z "${TMP_DIR}" ]]; then
  TMP_DIR=".tmp"
fi

mkdir -p "${TMP_DIR}"
mkdir -p "${DEST_DIR}"

if [[ -z "${KUBESEAL_CERT}" ]]; then
  echo "KUBESEAL_CERT not provided as an environment variable"
  exit 1
fi

KUBESEAL_CERT_FILE="${TMP_DIR}/kubeseal.cert"
echo "${KUBESEAL_CERT}" > "${KUBESEAL_CERT_FILE}"

KUBESEAL=$(command -v kubeseal | command -v "${BIN_DIR}/kubeseal")

if [[ -z "${KUBESEAL}" ]]; then
  echo "kubeseal cli not found"
  exit 1
fi

echo "Kubeseal cert"
cat "${KUBESEAL_CERT_FILE}"

find "${SOURCE_DIR}" -name "*.yaml" | while read -r file; do
  filename=$(basename "${file}")

  ${KUBESEAL} --cert "${KUBESEAL_CERT_FILE}" --format yaml < "${file}" > "${DEST_DIR}/${filename}"
done
