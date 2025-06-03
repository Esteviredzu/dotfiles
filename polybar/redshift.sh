#!/bin/bash

CONFIG_FILE="/tmp/.redshift_toggle"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "off" > "$CONFIG_FILE"
fi

STATE=$(cat "$CONFIG_FILE")

if [ "$STATE" == "on" ]; then
    redshift -x
    echo "off" > "$CONFIG_FILE"
else
    redshift -O 4500
    echo "on" > "$CONFIG_FILE"
fi
