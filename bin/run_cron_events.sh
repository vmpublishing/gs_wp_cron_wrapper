#!/bin/bash


EXCLUDES_STRING=$1
excludes=(`echo $EXCLUDES_STRING | cut -d "," --output-delimiter=" " -f 1-`)

function in_array() {
    local haystack=${1}[@]
    local needle=${2}
    for i in ${!haystack}; do
        if [[ ${i} == ${needle} ]]; then
            return 0
        fi
    done
    return 1
}


for i in $(/usr/local/bin/wp cron event list --fields=hook --format=ids); do
  if (! $(in_array excludes $i)); then
    /usr/local/bin/wp cron event run $i
  fi
done

