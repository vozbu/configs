#!/bin/bash

for i in *.png; do
    if [ -e  "${i%png}jpg" ]; then
        echo "File ${i%png}jpg already exists, abort"
        exit 1
    fi
    convert "$i" "${i%png}jpg"
    touch "${i%png}jpg" -r "$i"
done
