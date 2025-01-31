#!/usr/bin/env bash

: "${GLUETUN_CONTROL_SERVER_HOST:=localhost}"
: "${GLUETUN_CONTROL_SERVER_PROTOCOL:=http}"
: "${GLUETUN_CONTROL_SERVER_PORT:=8000}"
: "${QBITTORRENT_PROTOCOL:=http}"
: "${QBITTORRENT_HOST:=localhost}"
: "${QBITTORRENT_WEBUI_PORT:=8080}"
: "${LOG_TIMESTAMP:=true}"

gluetun_origin="${GLUETUN_CONTROL_SERVER_PROTOCOL}://${GLUETUN_CONTROL_SERVER_HOST}:${GLUETUN_CONTROL_SERVER_PORT}"
qb_origin="${QBITTORRENT_PROTOCOL}://${QBITTORRENT_HOST}:${QBITTORRENT_WEBUI_PORT}"

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

query_gluetun_control_server() {
  local endpoint="$1"
  local curl_opts=()

  if [[ -n "${GLUETUN_CONTROL_SERVER_API_KEY}" ]]; then
    curl_opts+=(
      "-H" "X-API-Key: ${GLUETUN_CONTROL_SERVER_API_KEY}"
    )
  fi

  curl -s "${curl_opts[@]}" "${gluetun_origin}${endpoint}"
}

get_gluetun_external_ip() {
  local output
  output=$(query_gluetun_control_server "/v1/publicip/ip")
  echo "${output}" | jq -r .'public_ip'
}

get_gluetun_forwarded_port() {
  local output
  output=$(query_gluetun_control_server "/v1/openvpn/portforwarded")
  echo "${output}" | jq -r .'port'
}

query_qb_settings() {
  curl -s "${qb_origin}/api/v2/app/preferences"
}

post_qb_settings() {
  local payload="$1"
  curl -s -X POST -d json="${payload}" "${qb_origin}/api/v2/app/setPreferences"
}

get_qb_listen_port() {
  local output
  output=$(query_qb_settings)
  echo "${output}" | jq -r .'listen_port'
}

set_qb_listen_port() {
  local new_port="$1"
  local payload="{\"listen_port\":${new_port}}"

  output=$(post_qb_settings "${payload}")
}

main() {
  log --level info "Starting check" \
    "gluetun_url" "${gluetun_origin}" \
    "qBittorrent_url" "${qb_origin}"

  external_ip=$(get_gluetun_external_ip)

  if [[ -z "${external_ip}" ]]; then
    log --level error "External IP is empty. Potential VPN or internet connection issue."
    exit 1
  fi

  gluetun_port=$(get_gluetun_forwarded_port)
  qbittorrent_port=$(get_qb_listen_port)

  log --level info "Fetched configuration" \
    "external_ip" "${external_ip}" \
    "gluetun_forwarded_port" "${gluetun_port}" \
    "qBittorrent_listen_port" "${qbittorrent_port}"

  if [[ "${gluetun_port}" -eq "${qbittorrent_port}" ]]; then
    log --level info "qBittorrent listen port is already set to ${qbittorrent_port}. No need to change."
  else
    log --level info "Updating qBittorrent listen port to ${gluetun_port}."
    set_qb_listen_port "${gluetun_port}"
  fi

  # Try to connect to the forwarded port
  nc -z "${external_ip}" "${gluetun_port}" &>/dev/null
}

main
