#!/usr/bin/env bash

tmux display-message "tmux-newsidebar plugin loaded"

# Path to the plugin directory
PLUGIN_DIR="$HOME/.config/tmux/plugins/tmux-dir-sidebar"

# Key binding to toggle the sidebar (prefix + s)
tmux bind-key a run-shell "tmux split-window -h -l 30 'bash ~/.config/dotfiles/tmux/plugins/tmux-newsidebar/scripts/sidebar.sh'"

# Key binding to open the selected file (prefix + o)
tmux bind-key o run-shell "bash $PLUGIN_DIR/open_file.sh"

# tmux bind-key a run-shell "$CURRENT_DIR/scripts/sidebar.sh"
# CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

#tmux bind-key a run-shell "tmux split-window -h -l 30 'bash $PLUGIN_DIR/scripts/sidebar.sh'"

#tmux bind-key a run-shell "tmux split-window -h -l 30 'bash $PLUGIN_DIR/scripts/sidebar.sh'"

#tmux bind-key o run-shell "bash $PLUGIN_DIR/scripts/open_file.sh"
