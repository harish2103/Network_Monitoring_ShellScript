#!/bin/bash

# Set default options
log_file="network_monitor.log"
email_notifications=false

# Parse options
while getopts ":e:l:" opt; do
  case $opt in
    e) email_notifications=true ;;
    l) log_file="$OPTARG" ;;
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
  esac
done

# Shift arguments to remove processed options
shift $((OPTIND-1))

# Check for required arguments
if [[ $# -eq 0 ]]; then
  echo "Error: Please provide node addresses or hostnames." >&2
  exit 1
fi

# Function to ping a node and log results
ping_node() {
  local node="$1"
  local status=$(ping -c 1 -W 2 "$node" >/dev/null 2>&1 && echo "Reachable" || echo "Unreachable")
  local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  echo "$timestamp - $node: $status" >> "$log_file"
  echo "$timestamp - $node: $status"
}

# Loop through nodes and ping
for node in "$@"; do
  ping_node "$node"

  # Send email notification for unreachable nodes (if enabled)
  if [[ "$status" == "Unreachable" && "$email_notifications" == true ]]; then
    
    mail -s "Network Monitor Alert: Node $node Unreachable" harikunchapu4958@gmail.com < "$log_file"

  fi
done

echo "Network monitoring completed. Results logged to $log_file."
