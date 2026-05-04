#!/usr/bin/env bash
set -euo pipefail

url_file="${1:-metadata/tiff_urls.txt}"
destination="${2:-facsimiles/tiff}"
retries="${RETRIES:-12}"
retry_delay="${RETRY_DELAY:-15}"
connect_timeout="${CONNECT_TIMEOUT:-30}"
speed_time="${SPEED_TIME:-60}"
speed_limit="${SPEED_LIMIT:-1024}"

if [[ ! -f "$url_file" ]]; then
  echo "URL list not found: $url_file" >&2
  echo "Regenerate it from metadata/loc_79218337.json or pass a URL file path." >&2
  exit 1
fi

mkdir -p "$destination"

total="$(wc -l < "$url_file" | tr -d ' ')"
count=0

while IFS= read -r url; do
  [[ -z "$url" ]] && continue
  count=$((count + 1))
  filename="${url##*/}"
  output="$destination/$filename"

  printf '[%s/%s] %s\n' "$count" "$total" "$filename"
  curl \
    --location \
    --fail \
    --http1.1 \
    --continue-at - \
    --retry "$retries" \
    --retry-delay "$retry_delay" \
    --retry-all-errors \
    --connect-timeout "$connect_timeout" \
    --speed-time "$speed_time" \
    --speed-limit "$speed_limit" \
    --output "$output" \
    "$url"
done < "$url_file"
