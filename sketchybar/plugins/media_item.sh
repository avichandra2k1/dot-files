#!/bin/bash

# Fetch metadata using media-control
DATA=$(media-control get 2>/dev/null)

# Handle no media
if [[ "$DATA" == "null" || -z "$DATA" ]]; then
  sketchybar --set media.label label="" icon=""
  exit 0
fi

# Parse JSON with jq
TITLE=$(echo "$DATA"  | jq -r '.title // empty')
ARTIST=$(echo "$DATA" | jq -r '.artist // empty')
PLAYING=$(echo "$DATA" | jq -r '.playing')

# Build label text
if [[ -n "$ARTIST" ]]; then
  LABEL="$TITLE - $ARTIST"
else
  LABEL="$TITLE"
fi

# Choose icon
if [[ "$PLAYING" == "true" ]]; then
  ICON="⏸"
else
  ICON="▶"
fi

# Update SketchyBar item
sketchybar --set media_item label="$LABEL" icon="$ICON"

