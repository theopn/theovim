#!/bin/bash

# Function for backing up existing config and copying the new configuration
# $1 = File to create a symlink for, $2 = target directory, $3 backup directory
safe_symlink() {
  if [[ -e "$2" ]]; then
    mkdir -p "$3/"
    mv "$2" "$3"
    echo "$2" already exists. Moving to "$3"
  fi
  if [[ ! -e "$1" ]]; then
    echo "$1" not found!
  else
    ln -sf "$1" "$2"
    echo symlink for "$1" created at "$2"
  fi
}

# Copying the files
current_files=("init.lua" "lua")
mkdir -p ~/.config/nvim/
for v in ${current_files[@]}; do
safe_symlink ~/.theovim/src/"$v" ~/.config/nvim/"$v" ~/theovim-install-backup
done

# Copying the template user configuration file
mv ~/.theovim/src/lua/user-config/config.lua ~/.config/nvim/lua/

