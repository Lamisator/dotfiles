#!/bin/bash
STATE="$(cat /proc/acpi/bbswitch | grep -o "ON\|OFF")"
if [ "$STATE" == "ON" ];
    then
        LOAD="$(~/.xmonad/scripts/getdGPULoad.py)"
        echo "${STATE} (${LOAD}%)"
    else
        echo "OFF"
    fi

