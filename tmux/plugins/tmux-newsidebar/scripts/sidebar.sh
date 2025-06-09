#!/bin/bash

# tmux-dir-sidebar: Simple directory listing sidebar for local and remote sessions

# Function to determine the current directory (local or remote)
get_current_dir() {
  local active_pane=$1
  # Get the pane title, which may include the remote directory
  local pane_title=$(tmux display-message -p -t "$active_pane" -F "#{pane_title}")

  # Check if the title matches the pattern "user@host: /path"
  if [[ $pane_title =~ ^[^@]+@[^:]+:(.*) ]]; then
    # Extract the path after the colon (remote directory)
    local remote_dir="${BASH_REMATCH[1]}"
    # Trim whitespace and prefix with "remote:" to indicate type
    echo "remote:$(echo "$remote_dir" | xargs)"
  else
    # Fall back to local pane path
    local local_dir=$(tmux display-message -p -t "$active_pane" -F "#{pane_current_path}")
    echo "local:$local_dir"
  fi
}

# Main loop to update the sidebar
while true; do
  # Get the active pane's ID
  active_pane=$(tmux list-panes -F "#{pane_id} #{pane_active}" | grep " 1$" | cut -d' ' -f1)
  if [ -z "$active_pane" ]; then
    echo "Error: No active pane found."
    sleep 1
    continue
  fi

  # Get the current directory info
  dir_info=$(get_current_dir "$active_pane")
  if [ -z "$dir_info" ]; then
    echo "Error: Cannot determine current directory."
    sleep 1
    continue
  fi

  # Split dir_info into type and path
  dir_type="${dir_info%%:*}"
  current_dir="${dir_info#*:}"

  # Display directory contents
  clear
  echo "Directory: $current_dir"
  if [ "$dir_type" = "local" ]; then
    # For local directories, list contents
    ls -1 "$current_dir" 2>/dev/null || echo "Error: Cannot list directory."
  else
    # For remote directories, just show the path
    echo "Remote directory: $current_dir"
  fi

  if [ "$dir_type" = "remote" ]; then
    # Extract host from pane_title (e.g., "user@host: /path" -> "user@host")
    remote_host=$(echo "$pane_title" | sed 's/:.*$//')
    # Run ls -1 via SSH
    ssh "$remote_host" "ls -1 '$current_dir'" 2>/dev/null || echo "Error: Cannot list remote directory."
  fi

  # Wait for changes or timeout
  if [ "$dir_type" = "local" ] && command -v inotifywait >/dev/null 2>&1; then
    # Monitor local directory changes if inotifywait is available
    inotifywait -e modify,create,delete "$current_dir" --timeout 1 2>/dev/null
  else
    # Otherwise, sleep for 1 second
    sleep 1
  fi
done
