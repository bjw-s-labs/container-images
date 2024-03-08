#!/usr/bin/env bash

if [[ ! -f "$BEPASTY_CONFIG" ]]; then
  echo "Please please mount a configuration file to '${BEPASTY_CONFIG}'."
  exit 1
fi

if ! python "${BEPASTY_CONFIG}"; then
  exit 1
fi

#shellcheck disable=SC2086
exec \
  gunicorn \
    -b "${LISTEN}" \
    --workers="${WORKERS}" \
    bepasty.wsgi:application \
    "$@"
