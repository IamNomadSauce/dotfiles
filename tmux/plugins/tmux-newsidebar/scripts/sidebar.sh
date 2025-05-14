#!/bin/bash

tmux display-message "TESTING IT WORKING"
# Check if a directory argument was provided
if [ $# -eq 0 ]; then
  echo "Error: No directory provided."
  exit 1
fi

current_dir=$1

# Display the directory and wait for user input
echo "Current working directory: $current_dir"
echo "Press Enter to close this pane."
read
