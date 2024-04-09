#!/usr/bin/env bash

: "${CRON_ENABLED:=false}"
: "${CRON_SCHEDULE:="*/5 * * * *"}"

if [[ "${CRON_ENABLED}" = "true" ]]; then
  export LOG_TIMESTAMP="false"
  echo "${CRON_SCHEDULE} /app/script.sh $*" > /config/crontab
  supercronic /config/crontab
else
  exec \
    /app/script.sh \
      "$@"
fi
