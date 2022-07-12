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

logrun ionice nice ffmpeg -v quiet -i "$1" -map 0:v:0 -map 0:a:0 -c:v copy -c:a copy "$(echo "$1" | sed 's/\.[a-z0-9]\{3\}$//').mp4"
