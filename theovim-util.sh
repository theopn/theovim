#!/bin/bash

# Global vars
THEOVIM_DIR=~/.theovim/src
NEOVIM_DIR=~/.config/nvim


function verify_theovim_dir() {
  script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
  if [[ "$script_dir" != ~/.theovim || ! -d ~/.theovim ]]; then
    red_echo "$HOME/.theovim is not found. Please follow the Git Clone direction in the README.md"
    exit 1
  fi
}

# From https://github.com/vsbuffalo/dotfiles/blob/master/setup.sh
# For regular messages
function green_echo() {
  echo -e "\033[0;32m[Theovim] $1\033[0m"
}

# For prompts requiring user attention
function yellow_echo() {
  echo
  echo -e "\033[0;33m[Attention] $1\033[0m"
  echo
}

# For error prompts
function red_echo() {
  echo
  echo -e "\033[0;31m[Fatal] $1\033[0m"
  echo
}

function clean() {
  if [[ -d ~/.theovim.bu  ]]; then
    yellow_echo "Removing previous Neovim configuration backup"
    rm -rf ~/.theovim.bu
  fi
  if [[ -d ~/.config/nvim ]]; then
    mkdir -p ~/.theovim.bu/
    mv ~/.config/nvim $HOME/.theovim.bu/config
    yellow_echo "Previous Neovim configuration has been moved to ~/.theovim.bu"
  else
    green_echo "No previous Neovim installation found! Skipping backup..."
  fi
}

function install() {
  verify_theovim_dir
  clean
  green_echo "Installing Theovim..."
  ln -s $THEOVIM_DIR $NEOVIM_DIR
  cp ~/.theovim/config_template.lua ~/.config/nvim/lua/user_config.lua
  green_echo "Installation completed!"
}

function update() {
  verify_theovim_dir
  if [[ ! -d ~/.theovim ]]; then
    red_echo "Theovim folder is not found. Please clone the repository at the home directory again"
    exit 1
  fi

  if [[ ! -L $HOME/.config/nvim ]]; then
    red_echo "Neovim configuration folder is not found. Running install..."
    install
  else
    cd ~/.theovim
    git pull
    cd - &> /dev/null
  fi
}

function help() {
  green_echo "
                    Theovim Utility Script Usage

  ===================================================================

  Syntax: ./theovim-util.sh <arg>
  -------------------------------------------------------------------

  args:
    insall: Install Theovim at $HOME/.config/nvim
    update: Pull the latest changes and install any missing file
    clean: Move the current Neovim configuration to $HOME/.theovim.bu
  "
}

function main() {
  case $1 in
    clean)
      clean
    ;;
    install)
     install
    ;;
    update)
      update
    ;;
    help)
      help
    ;;
    *) # Invalid option
     red_echo "Invalid option"
     help
    ;;
  esac

  exit 0
}

########### MAIN CALL HERE ##########
main $1
########### MAIN CALL HERE ##########
