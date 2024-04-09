#!/usr/bin/env bash

if [ -f "${CALIBRE_DBPATH}/calibre-web.log" ]; then
  rm "${CALIBRE_DBPATH}/calibre-web.log"
fi

ln -s /dev/stdout "${CALIBRE_DBPATH}/calibre-web.log"

#shellcheck disable=SC2086
exec \
  python3  \
    /app/cps.py \
    "$@"
