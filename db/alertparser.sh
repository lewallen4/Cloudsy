#!/bin/bash
# This script processes activealerts1.txt and outputs active alerts to activealerts.txt

# Get current epoch time (seconds since 1970-01-01)
now=$(date +%s)

awk -v now="$now" '
  BEGIN {
    # Set record separator to the separator line.
    RS = "-----------------------\n"
    # Set output record separator to re-add the divider after each block.
    ORS = "-----------------------\n"
  }
  {
    # Look for the Expires line. We expect a line like:
    # Expires: 2025-02-07T10:00:00-08:00
    if (match($0, /Expires: ([^ \n]+)/, arr)) {
      expiry = arr[1]
      # Use GNU date to convert the expiry timestamp to epoch seconds.
      cmd = "date -d \"" expiry "\" +%s"
      cmd | getline exp_epoch
      close(cmd)
      # If the expiry time is later than now, print the alert block.
      if (exp_epoch > now)
        print $0
    }
  }
' db/activealerts1.json > db/activealerts.txt
