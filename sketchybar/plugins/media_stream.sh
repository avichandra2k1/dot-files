#!/bin/bash

title=""
artist=""
playing="false"

media-control stream | \
    while IFS= read -r line; do
        # Detect empty payload (no media)
        empty=$(echo "$line" | jq -r 'if (.payload | length) == 0 then "true" else "false" end')
        if [ "$empty" = "true" ]; then
            title=""
            artist=""
            playing="false"
        else
            new_title=$(echo "$line" | jq -r '.payload.title // empty')
            new_artist=$(echo "$line" | jq -r '.payload.artist // empty')
            new_playing=$(echo "$line" | jq -r '.payload.playing // empty')

            if [ -n "$new_title" ]; then
                title="$new_title"
            fi

            if [ -n "$new_artist" ]; then
                artist="$new_artist"
            fi

            if [ -n "$new_playing" ]; then
                playing="$new_playing"
            fi
        fi

        sketchybar --trigger media_stream_changed title="$title" artist="$artist" playing="$playing"
    done

