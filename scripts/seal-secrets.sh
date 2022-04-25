#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)
MODULE_DIR=$(cd "${SCRIPT_DIR}/.."; pwd -P)

SOURCE_DIR="$1"
DEST_DIR="$2"

if [[ -n "${BIN_DIR}" ]]; then
  export PATH="${BIN_DIR}:${PATH}"
fi

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

if ! command -v kubeseal 1> /dev/null 2> /dev/null; then
  echo "kubeseal cli not found" >&2
  exit 1
fi

echo "Kubeseal cert"
cat "${KUBESEAL_CERT_FILE}"

find "${SOURCE_DIR}" -name "*.yaml" | while read -r file; do
  filename=$(basename "${file}")

  if [[ -n "${ANNOTATIONS}" ]]; then
    kubeseal --cert "${KUBESEAL_CERT_FILE}" --format yaml < "${file}" | \
      kubectl annotate -f - ${ANNOTATIONS} \
      --local=true \
      --dry-run=client \
      --output=json \
      > "${DEST_DIR}/${filename}"
  else
    kubeseal --cert "${KUBESEAL_CERT_FILE}" --format yaml < "${file}" > "${DEST_DIR}/${filename}"
  fi
done
