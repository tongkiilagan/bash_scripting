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

mem=$(free | grep Mem | awk '{print $3/$2 * 100.0}')

if (( $(echo "$mem >= $crit" | bc -l) )); then
    exit 2
elif (( $(echo "$mem >= $warn" | bc -l) )); then
    exit 1
else
    exit 0
fi
