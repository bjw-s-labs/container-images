#!/usr/bin/env bash
set -e

DEFAULT_REDIS_URL="redis://localhost:6379"

# Set some application defaults
export PORT=${PORT:-"3214"}
export REDIS_URL=${REDIS_URL:-${DEFAULT_REDIS_URL}}
export RUN_BUILTIN_REDIS=${RUN_BUILTIN_REDIS:-"false"}

# Hack to work around foreman errors during CI tests
if [[ -d /goss ]]; then
  export SECRET_KEY_BASE="placeholder"
  export DATABASE_URL="sqlite3:/data/manyfold.sqlite3"
  export RUN_BUILTIN_REDIS="true"
fi

cd /usr/src/app

echo "Preparing database..."
bundle exec rails db:prepare:with_data

echo "Cleaning up old cache files..."
bundle exec rake tmp:cache:clear

if [[ "${RUN_BUILTIN_REDIS}" == "true" ]] && [[ "${REDIS_URL}" == "${DEFAULT_REDIS_URL}" ]]; then
  valkey-server --save "" --appendonly no &
  export DEFAULT_WORKER_CONCURRENCY=1
fi

exec \
  foreman start
