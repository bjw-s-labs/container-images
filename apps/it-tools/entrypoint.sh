#!/bin/sh

HTTP_WORKERS=${HTTP_WORKERS:="auto"}
HTTP_PORT=${HTTP_PORT:="8080"}

if [ -n "${HTTP_WORKERS}" ]; then
    sed -i "s/worker_processes  auto;/worker_processes  ${HTTP_WORKERS};/g" /etc/nginx/nginx.conf
fi

if [ -n "${HTTP_PORT}" ]; then
    sed -i "s/80;/${HTTP_PORT};/g" /etc/nginx/conf.d/default.conf
fi

nginx -g "daemon off;"
