#!/usr/bin/env bash

CRON_ENABLED="${CRON_ENABLED:=false}"
CRON_SCHEDULE="${CRON_SCHEDULE:="0 */12 * * *"}"
LOG_TIMESTAMP="${LOG_TIMESTAMP:=true}"

log() {
  gum_opts=(
    "--structured"
  )

  if [[ "${LOG_TIMESTAMP}" = "true" ]]; then
    gum_opts+=(
      "--time" "rfc3339"
    )
  fi

  gum log "${gum_opts[@]}" "$@"
}

if [[ -z "${SCRIPT_NAME}" ]]; then
  log --level error "SCRIPT_NAME variable is not set."
  exit 1
fi

if [[ ! -f "/app/${SCRIPT_NAME}" ]]; then
  log --level error "Script not found in /app" "script" "${SCRIPT_NAME}"
  exit 1
fi

case "${SCRIPT_NAME}" in
  *.sh)
    if [[ "${CRON_ENABLED}" = "true" ]]; then
      echo "${CRON_SCHEDULE} export LOG_TIMESTAMP=\"false\"; /bin/bash /app/${SCRIPT_NAME} $*" > /config/crontab
      supercronic /config/crontab
    else
      log --level info "Running shell script" "script" "${SCRIPT_NAME}"
      /bin/bash "/app/${SCRIPT_NAME}" "$@"
    fi
    ;;
  *)
    log --level error "Unsupported script type" "script" "${SCRIPT_NAME}"
    exit 1
    ;;
esac
