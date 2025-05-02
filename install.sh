#!/bin/bash

# Dotfiles installation script
# Sets up symlinks for bash, tmux, and vim configurations

# Define the dotfiles directory
DOTFILES_DIR="$HOME/.config/dotfiles"

# Ensure the dotfiles directory exists
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Error: Dotfiles directory $DOTFILES_DIR does not exist."
  echo "Please clone the repository first (e.g., git clone <your-repo-url> $DOTFILES_DIR)."
  exit 1
fi

# Function to create a symlink
create_symlink() {
  local src="$1"
  local dest="$2"
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    echo "Backing up existing $dest to $dest.bak"
    mv "$dest" "$dest.bak"
  fi
  ln -sf "$src" "$dest"
  echo "Created symlink: $dest -> $src"
}

# Create symlinks for configuration files
create_symlink "$DOTFILES_DIR/bash/bashrc" "$HOME/.bashrc"
create_symlink "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
create_symlink "$DOTFILES_DIR/vim/vimrc" "$HOME/.vimrc"

# Source the new bashrc to apply changes in the current session
if [ -n "$BASH_VERSION" ]; then
  echo "Sourcing ~/.bashrc to apply changes"
  source "$HOME/.bashrc"
fi

echo "Dotfiles installation complete!"
