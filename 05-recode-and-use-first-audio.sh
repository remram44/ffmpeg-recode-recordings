#!/bin/sh

set -eu

if [ $# != 1 ]; then
    echo "Usage: $(basename "$0") <video>"
    exit 2
fi

logrun(){
    echo "$@" >&2
    "$@"
}

logrun ionice nice ffmpeg -i "$1" -map 0:v:0 -map 0:a:0 -c:v h264 -c:a copy -crf 28 -tune stillimage "$(echo "$1" | sed 's/\.[a-z0-9]\{3\}$//').mp4"
