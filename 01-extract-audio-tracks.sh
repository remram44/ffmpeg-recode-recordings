#!/bin/sh

set -eu

if [ $# != 1 ] || [ ! -e "$1" ]; then
    echo "Usage: $(basename "$0") <video.mkv>" >&2
    exit 2
fi

logrun(){
    echo "$@" >&2
    "$@"
}

AUDIO_STREAMS="$(logrun ffprobe -v quiet -of json -show_streams "$1" | jq '.streams[] | select(.codec_type=="audio") | .index')"
BASE_NAME="$(echo "$1" | sed 's/\.[a-z0-9]\{3\}$//')"
for STREAM in $AUDIO_STREAMS; do
    logrun ionice nice ffmpeg -v quiet -i "$1" -map 0:$STREAM -c:a copy "$BASE_NAME.$STREAM.aac"
done
