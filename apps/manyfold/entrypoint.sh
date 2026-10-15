#!/usr/bin/env bash
set -e

DEFAULT_REDIS_URL="redis://localhost:6379"

# Set some application defaults
export PORT=${PORT:-"3214"}
export REDIS_URL=${REDIS_URL:-${DEFAULT_REDIS_URL}}
export RUN_BUILTIN_REDIS=${RUN_BUILTIN_REDIS:-"false"}

cd /app

# Manyfold uses Redis during Rails initialization (including db:prepare), so
# the built-in Redis instance must be available before running any Rails task.
if [[ "${RUN_BUILTIN_REDIS}" == "true" ]] && [[ "${REDIS_URL}" == "${DEFAULT_REDIS_URL}" ]]; then
  valkey-server --save "" --appendonly no &
  export DEFAULT_WORKER_CONCURRENCY=1

  until (echo > /dev/tcp/127.0.0.1/6379) 2>/dev/null; do
    sleep 0.1
  done
fi

echo "Preparing database..."
bundle exec rails db:prepare:with_data

echo "Cleaning up old cache files..."
bundle exec rake tmp:cache:clear

exec \
  foreman start
