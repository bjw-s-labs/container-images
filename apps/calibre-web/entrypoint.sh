#!/usr/bin/env bash

#shellcheck disable=SC1091
test -f "/scripts/umask.sh" && source "/scripts/umask.sh"

if [ -f "${CALIBRE_DBPATH}/calibre-web.log" ]; then
  rm "${CALIBRE_DBPATH}/calibre-web.log"
fi

ln -s /dev/stdout "${CALIBRE_DBPATH}/calibre-web.log"

#shellcheck disable=SC2086
exec \
  /usr/bin/python3  \
    /app/cps.py \
    "$@"
