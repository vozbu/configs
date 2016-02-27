#!/bin/bash

# Names each file after it's modification date.

if [ $# -eq 0 ]; then
    echo "Usage: $0 <filenames>"
fi

while [ $# -gt 0 ]; do
    ts=$(stat $1 | grep Modify | grep -Eo "[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}" | tr -d ':-' | tr ' ' '_')
    ext="${1##*.}"
    mv "$1" "$ts.$ext"
    shift
done
