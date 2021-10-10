#!/bin/bash

MACS=(
    "A4:C1:38:00:00:00"
    "A4:C1:38:FF:FF:FF"
)

POLL_INTERVAL=60;
export REQUEST_TIMEOUT=20;

get_stats() {
    mac=$1;
    
    response=$(timeout $REQUEST_TIMEOUT gatttool -b "$mac" --char-write-req --handle=0x38 -n 0100 --listen 2>/dev/null)

    if [[ "$response" == *"value: "* ]] 
    then
        temperature_hex=$(echo $response | sed 's/^.*value: \(\w\w\) \(\w\w\).*$/\U\2\U\1/');
        humidity_hex=$(echo $response | sed 's/^.*value: \w\w \w\w \(\w\w\).*$/\U\1/');

        temperature=$(echo "ibase=16; $temperature_hex" | bc);
        temperature=$(echo "scale=2; $temperature/100" | bc);

        humidity=$(echo "ibase=16; $humidity_hex" | bc);

        jo mac=$mac temperature=$temperature humidity=$humidity timestamp=$(date +%s);
    fi
}

while true; do

    export -f get_stats;

    printf '%s\n' ${MACS[@]} | xargs -I"{}" -P10 bash -c 'get_stats {} &';

    sleep $POLL_INTERVAL;

done
