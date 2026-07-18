#!/bin/zsh
set -euo pipefail

PROJECT_ROOT="${0:A:h:h}"
SOURCE_DIR="${1:-${PROJECT_ROOT:h}/01-建築基準法令3D図解}"
OUTPUT_DIR="$PROJECT_ROOT/BuildingCode3D/Resources/Generated/diagrams"

mkdir -p "$OUTPUT_DIR"

source_count=$(find "$SOURCE_DIR" -maxdepth 1 -type f -name 'image-[0-9][0-9][0-9].png' ! -name '._*' | wc -l | tr -d ' ')
if [[ "$source_count" != "250" ]]; then
  print -u2 "Expected 250 source PNG files, found $source_count"
  exit 2
fi

for number in {001..250}; do
  source_file="$SOURCE_DIR/image-$number.png"
  output_file="$OUTPUT_DIR/image-$number.heic"
  if [[ ! -s "$output_file" || "$source_file" -nt "$output_file" ]]; then
    sips -s format heic -s formatOptions 82 "$source_file" --out "$output_file" >/dev/null
  fi
done

output_count=$(find "$OUTPUT_DIR" -maxdepth 1 -type f -name 'image-[0-9][0-9][0-9].heic' ! -name '._*' | wc -l | tr -d ' ')
if [[ "$output_count" != "250" ]]; then
  print -u2 "Expected 250 HEIC outputs, found $output_count"
  exit 3
fi

find "$OUTPUT_DIR" -name '._*' -delete
du -sh "$OUTPUT_DIR"
print "Converted and verified 250 HEIC diagrams."

