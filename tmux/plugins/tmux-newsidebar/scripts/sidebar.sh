#!/bin/bash

# tmux-dir-sidebar: Simple directory listing sidebar

tmux display-message "tmux-newsidebar plugin loaded"
# Get the initial directory (will update dynamically)
current_dir=$(tmux display-message -p -F "#{pane_current_path}")

while true; do
  # Update directory from active pane
  active_pane=$(tmux list-panes -F "#{pane_id} #{pane_active}" | grep " 1$" | cut -d' ' -f1)
  if [ -n "$active_pane" ]; then
    new_dir=$(tmux display-message -p -t "$active_pane" -F "#{pane_current_path}")
    if [ "$new_dir" != "$current_dir" ]; then
      current_dir="$new_dir"
    fi
  fi

  # Display directory contents
  clear
  echo "Directory: $current_dir"
  ls -1 "$current_dir"

  # Wait for changes or timeout to check directory
  if command -v inotifywait >/dev/null 2>&1; then
    inotifywait -e modify,create,delete "$current_dir" --timeout 1 2>/dev/null
  else
    sleep 1
  fi
done
