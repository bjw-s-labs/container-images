#!/bin/bash
# This script will go over all the feeds to fetch the latest vidoes
# Original source: https://github.com/TeamPiped/Piped/issues/707#issuecomment-1936169391

PIPED_BACKEND="${PIPED_BACKEND:=http://localhost}"
PGHOST="${PGHOST:=localhost}"
PGUSER="${PGUSER:=piped}"
PGPASSWORD="${PGPASSWORD:=}"
PGDATABASE="${PGDATABASE:=piped}"
UPDATE_VIDEOS="${UPDATE_VIDEOS:=true}"
UPDATE_STREAMS="${UPDATE_STREAMS:=true}"
LOG_TIMESTAMP="${LOG_TIMESTAMP:=true}"
MIN_SLEEP_BETWEEN_FEEDS="${MIN_SLEEP_BETWEEN_FEEDS:=1}"
MAX_SLEEP_BETWEEN_FEEDS="${MAX_SLEEP_BETWEEN_FEEDS:=5}"

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

if [[ ${MIN_SLEEP_BETWEEN_FEEDS} -lt 1 ]]; then
  log --level error "MIN_SLEEP_BETWEEN_FEEDS has to be >= 1" "MIN_SLEEP_BETWEEN_FEEDS" "${MIN_SLEEP_BETWEEN_FEEDS}"
  exit 4
fi

if [[ ${MAX_SLEEP_BETWEEN_FEEDS} -lt 1 ]]; then
  log --level error "MAX_SLEEP_BETWEEN_FEEDS has to be >= 1" "MAX_SLEEP_BETWEEN_FEEDS" "${MAX_SLEEP_BETWEEN_FEEDS}"
  exit 4
fi

if [[ ! ${MIN_SLEEP_BETWEEN_FEEDS} -le ${MAX_SLEEP_BETWEEN_FEEDS} ]]; then
  log --level error "MIN_SLEEP_BETWEEN_FEEDS is not less than MAX_SLEEP_BETWEEN_FEEDS" "MIN_SLEEP_BETWEEN_FEEDS" "${MIN_SLEEP_BETWEEN_FEEDS}" "MAX_SLEEP_BETWEEN_FEEDS" "${MAX_SLEEP_BETWEEN_FEEDS}"
  exit 4
fi

if ! curl -s --output /dev/null "${PIPED_BACKEND}"; then
  log --level error "Could not connect to Piped backend" "url" "${PIPED_BACKEND}"
  exit 2
fi

if ! subscriptions=$(psql -qtAX -c 'select id from public.pubsub;'); then
  log --level error "Failed to get subscriptions from database"
  exit 3
fi

# Function to update streams
update_streams() {
  channel=$1
  url=$(jq -nr --arg channel "${channel}" --arg backend "${PIPED_BACKEND}" '
  {
    originalUrl: "https://www.youtube.com/\($channel)/streams",
    url: "https://www.youtube.com/\($channel)/streams",
    id: $channel,
    contentFilters: ["livestreams"],
    sortFilter: "",
    baseUrl: "https://www.youtube.com"
  }
  | tojson | @uri | $backend + "/channels/tabs?data=" + .')
  curl -sSk "${url}" >/dev/null
  return $?
}

# Function to update videos
update_videos() {
  channel=$1
  url="${PIPED_BACKEND}/channel/${channel}"
  curl -sSk "${url}" >/dev/null
  return $?
}

i=1
failures=0
total_subscriptions=$(wc -l <<<"${subscriptions}")

while IFS= read -r channel; do
  if ! channel_name=$(psql -qtAX -c "select uploader from public.channels where uploader_id = '${channel}';"); then
    log --level error "Failed to get channel name from DB" "id" "${channel}"
    exit 3
  fi

  log --level info "Processing channel" "channel" "${channel_name}" "progress" "${i}/${total_subscriptions}"
  if [[ "${UPDATE_VIDEOS}" == "true" ]]; then
    log "Updating videos..."
    if ! update_videos "${channel}"; then
      ((failures++))
    fi
  fi
  if [[ "${UPDATE_STREAMS}" == "true" ]]; then
    log "Updating streams..."
    if ! update_streams "${channel}"; then
      ((failures++))
    fi
  fi

  if [[ ${i} -ne "${total_subscriptions}" ]]; then
    # Sleep randomly if not at the end of the subscription list
    sleep_duration=$((MIN_SLEEP_BETWEEN_FEEDS+RANDOM % (MAX_SLEEP_BETWEEN_FEEDS-MIN_SLEEP_BETWEEN_FEEDS+1)))
    log "Sleeping..." "duration" "${sleep_duration}s"
    sleep "${sleep_duration}"
    ((i++))
  fi
done <<<"${subscriptions}"

# Report any failures
if [[ ${failures} -ne 0 ]]; then
  log --level error "Failed ${failures} time(s)"
  exit 4
else
  log --level info "All done!"
fi
