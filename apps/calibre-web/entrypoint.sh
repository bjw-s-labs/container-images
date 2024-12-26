#!/usr/bin/env bash

#shellcheck disable=SC2086
exec \
  python3  \
    /app/cps.py \
    -o /dev/stdout \
    "$@"
