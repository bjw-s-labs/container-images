#!/usr/bin/env bash

if [ ! -f "${CTRLD_CONFIG_FILE}" ]; then
  echo "[ERROR] ${CTRLD_CONFIG_FILE} not found"
  exit 1
fi

#shellcheck disable=SC2086
exec \
  /app/ctrld run \
    --config ${CTRLD_CONFIG_FILE} \
    "$@"
