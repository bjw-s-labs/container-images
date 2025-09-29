#!/usr/bin/env sh
if [ ! -f "${RADICALE_CONFIG_FILE}" ]; then
  echo "[INFO] Copying default configuration to ${RADICALE_CONFIG_FILE}"
  cp "/app/config.default" "${RADICALE_CONFIG_FILE}"
fi

#shellcheck disable=SC2086
exec \
  radicale --config "${RADICALE_CONFIG_FILE}" \
    "$@"
