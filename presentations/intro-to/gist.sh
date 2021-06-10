#!/usr/bin/env sh

gist_list=$(gh gist list)
gist_to_find=$(echo "$gist_list" | awk '{print $2}' | fzf --layout=reverse)

gh gist edit $(echo "$gist_list" | grep $gist_to_find | awk '{print $1}')
