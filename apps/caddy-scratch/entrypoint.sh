#!/bin/sh

if [ -n "${HTTP_WORKERS}" ]; then
    sed -i "s/worker_processes  2;/worker_processes  ${HTTP_WORKERS};/g" /etc/nginx/nginx.conf
fi

if [ -n "${HTTP_PORT}" ]; then
    sed -i "s/8080;/${HTTP_PORT};/g" /etc/nginx/conf.d/default.conf
fi

nginx -g "daemon off;"
