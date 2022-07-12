#!/bin/sh

set -eu

if [ $# != 2 ]; then
    echo "Usage: $(basename "$0") <video> <audio>"
    exit 2
fi

logrun(){
    echo "$@" >&2
    "$@"
}

if echo "$2" | grep -q '\.aac$'; then
    ENC_AUDIO=copy
elif echo "$2" | grep -q '\.m4a$'; then
    ENC_AUDIO=copy
else
    ENC_AUDIO=aac
fi
logrun ionice nice ffmpeg -v quiet -i "$1" -i "$2" -map 0:v:0 -map 1:a:0 -c:v copy -c:a $ENC_AUDIO "$(echo "$1" | sed 's/\.[a-z0-9]\{3\}$//').mp4"
