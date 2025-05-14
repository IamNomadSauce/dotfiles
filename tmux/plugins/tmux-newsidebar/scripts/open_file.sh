#!/bin/bash

file_path=$(tmux show-buffer 2>/dev/null)
if [ -z "$file_path" ]; then
  tmux display-message "Error: No file selected."
  exit 1
fi

if [ -f "$file_path" ]; then
  tmux split-window -h "vim $file_path"
elif [ -d "$file_path" ]; then
  tmux display-message "Selected path is a directory: $file_path"
else
  tmux display-message "Invalid path: $file_path"
