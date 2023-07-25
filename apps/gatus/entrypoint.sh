#!/usr/bin/env bash

if [[ -n "${GATUS_CONFIG_FILE_URL}" ]]; then
  echo "[INFO] Trying to download remote configuration from ${GATUS_CONFIG_FILE_URL}"
  CURL_RESPONSE=$(curl -s -o "${GATUS_CONFIG_PATH}" -w "%{http_code}" -L "${GATUS_CONFIG_FILE_URL}")
  if [ ! "${CURL_RESPONSE}" == "200" ]; then
    echo "[ERROR] Failed to download remote configuration (HTTP error ${CURL_RESPONSE})"
    exit 1
  fi
fi

if [[ -n "${GATUS_CONFIG_BASE64}" ]]; then
  echo "[INFO] Converting base64 config to ${GATUS_CONFIG_PATH}"
  echo "${GATUS_CONFIG_BASE64}" | base64 -d > "${GATUS_CONFIG_PATH}"
fi

if [[ ! -f "${GATUS_CONFIG_PATH}" ]]; then
  echo "[INFO] Copying default configuration to ${GATUS_CONFIG_PATH}"
  cp "/app/config.default.yaml" "${GATUS_CONFIG_PATH}"
fi

#shellcheck disable=SC2086
exec \
  /app/gatus \
    "$@"
