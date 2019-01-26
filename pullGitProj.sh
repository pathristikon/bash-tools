#!/usr/bin/env bash

#Pull git projects from basepath folder
basepath="$HOME/path/to/dir" #basepath to directory

for f in *; do
    if [[ -d "$f" ]]; then
        path=$basepath/$f
        (cd "$path" && git pull origin master)
    fi
done

echo "Time: $(date). Pulling done!" >> info.log
