#!/bin/bash

# Check if a URL parameter is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <URL>"
    exit 1
fi

# URL to curl
url="$1"

# Curl the URL and grep for the mp4 source URL
mp4_url=$(curl -s "$url" | grep -o 'sources: \["[^"]*' | grep -o 'https:[^"]*\.mp4')

# Extract the text inside the <h1> tags
title=$(curl -s "$url" | sed -n '/<h1>/,/<\/h1>/ {/<h1>/d; /<\/h1>/q; p;}' | awk 'NF{sub(/^ +| +$/,""); print; exit}')

# Curl the extracted mp4 URL with Referer header
if [ -n "$mp4_url" ]; then
    # Create the "videos" folder if it doesn't exist
    if [ ! -d "videos" ]; then
        mkdir "videos"
    fi
    # Use the extracted title in the output filename
    output_filename="videos/${title}.mp4"
    curl -e "$url" -o "$output_filename" "$mp4_url"
    echo "Downloaded MP4 to $output_filename"
else
    echo "Failed to extract MP4 URL."
fi
