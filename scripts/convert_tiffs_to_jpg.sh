#!/usr/bin/env bash
set -euo pipefail

source_dir="${1:-facsimiles/tiff}"
destination="${2:-facsimiles/jpg}"
jpeg_quality="${JPEG_QUALITY:-88}"
max_files="${MAX_FILES:-0}"
pause_file="${PAUSE_FILE:-$destination/.pause}"
pause_poll_seconds="${PAUSE_POLL_SECONDS:-30}"

if [[ ! -d "$source_dir" ]]; then
  echo "TIFF source directory not found: $source_dir" >&2
  exit 1
fi

if ! command -v magick >/dev/null 2>&1; then
  echo "ImageMagick not found. Install it with: brew install imagemagick" >&2
  exit 1
fi

mkdir -p "$destination"

wait_while_paused() {
  if [[ ! -e "$pause_file" ]]; then
    return
  fi

  printf 'Paused because %s exists. Remove it to continue.\n' "$pause_file"
  while [[ -e "$pause_file" ]]; do
    sleep "$pause_poll_seconds"
  done
}

shopt -s nullglob
tiffs=("$source_dir"/*.tif "$source_dir"/*.tiff)
total="${#tiffs[@]}"

if [[ "$total" -eq 0 ]]; then
  echo "No TIFF files found in $source_dir."
  exit 0
fi

count=0
for tiff in "${tiffs[@]}"; do
  count=$((count + 1))
  if [[ "$max_files" -gt 0 && "$count" -gt "$max_files" ]]; then
    break
  fi

  filename="$(basename "$tiff")"
  stem="${filename%.*}"
  output="$destination/$stem.jpg"
  temporary="$output.tmp.jpg"

  wait_while_paused

  if [[ -s "$output" && "$output" -nt "$tiff" ]]; then
    printf '[%s/%s] %s already converted\n' "$count" "$total" "$filename"
    continue
  fi

  printf '[%s/%s] %s -> %s (quality %s)\n' \
    "$count" "$total" "$filename" "$(basename "$output")" "$jpeg_quality"

  magick -quiet "$tiff" \
    -auto-orient \
    -strip \
    -colorspace sRGB \
    -sampling-factor 4:4:4 \
    -quality "$jpeg_quality" \
    "$temporary"

  mv "$temporary" "$output"
done
