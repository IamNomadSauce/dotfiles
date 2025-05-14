#!/usr/bin/env bash

tmux display-message "tmux-newsidebar plugin loaded"
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tmux bind-key T run-shell "$CURRENT_DIR/scripts/sidebar.sh"

#tmux bind-key a run-shell "tmux split-window -h -l 30 'bash $PLUGIN_DIR/scripts/sidebar.sh'"

#tmux bind-key a run-shell "tmux split-window -h -l 30 'bash $PLUGIN_DIR/scripts/sidebar.sh #{pane_current_path}'"

#tmux bind-key o run-shell "bash $PLUGIN_DIR/scripts/open_file.sh"
