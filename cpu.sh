#!/bin/bash

usage() {
    echo "Usage: $0 -c <crit> -w <warn>"
    exit 1
}

while getopts ":c:w:" opt; do
    case $opt in
        c) crit=$OPTARG ;;
        w) warn=$OPTARG ;;
        \?) usage ;;
    esac
done

if [ -z "$crit" ] || [ -z "$warn" ]; then
    usage
fi

if [ "$crit" -le "$warn" ]; then
    echo "Critical threshold must be greater than warning threshold"
    usage
fi

cpu=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}' | sed 's/%//')

if (( $(echo "$cpu >= $crit" | bc -l) )); then
    exit 2
elif (( $(echo "$cpu >= $warn" | bc -l) )); then
    exit 1
else
    exit 0
fi
