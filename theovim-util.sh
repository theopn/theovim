#!/bin/bash

# Global vars
THEOVIM_DIR=$HOME/.theovim/src
THEOVIM_FILES=("/theovim-help-doc.md" "/theovim-info.txt" "/init.lua" "/lua/theo_init.lua" "/lua/theovim.lua" "/lua/plugins.lua" "/lua/look.lua" "/lua/file_et_search.lua" "/lua/lsp.lua")
NEOVIM_DIR=$HOME/.config/nvim
NEOVIM_DESTINATIONS=("/" "/" "/" "/lua/" "/lua/" "/lua/" "/lua/" "/lua/" "/lua/")


function verify_theovim_dir() {
  script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
  if [[ "$script_dir" != "$HOME/.theovim" || ! -d $HOME/.theovim ]]; then
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
  echo -e "\033[0;33m[Attention] $1\033[0m"
}

# For prompts requiring user attention
function red_echo() {
  echo -e "\033[0;31m[Fatal] $1\033[0m"
}

function clean() {
  if [[ -d $HOME/.config/nvim ]]; then
    mkdir -p $HOME/.theovim.bu/
    mv $HOME/.config/nvim/ $HOME/.theovim.bu/config/
    mv $HOME/.local/share/nvim/ $HOME/.theovim.bu/share/
    mv $HOME/.local/state/nvim/ $HOME/.theovim.bu/state
    yellow_echo "Previous Neovim configuration has been moved to $HOME/.theovim.bu"
  else
    green_echo "No previous Neovim installation found!"
  fi
}

function install() {
  verify_theovim_dir
  clean
  mkdir -p $HOME/.config/nvim/
  mkdir -p $HOME/.config/nvim/lua/
  for i in ${!THEOVIM_FILES[@]}; do
    ln -sf $THEOVIM_DIR${THEOVIM_FILES[i]} $NEOVIM_DIR${NEOVIM_DESTINATIONS[i]}
    green_echo "$THEOVIM_DIR${THEOVIM_FILES[i]} deployed at $NEOVIM_DIR${NEOVIM_DESTINATIONS[i]}"
  done
}

function update() {
  verify_theovim_dir
  if [[ ! -d $HOME/.config/nvim ]]; then
    red_echo "Neovim configuration folder is not found. Please run ./theovim.sh/install"
    exit 1
  else
    for i in ${!THEOVIM_FILES[@]}; do
      if [[ ! -e "$NEOVIM_DIR${THEOVIM_FILES[i]}" ]]; then
        ln -sf $THEOVIM_DIR${THEOVIM_FILES[i]} $NEOVIM_DIR${NEOVIM_DESTINATIONS[i]}
        green_echo "${THEOVIM_FILES[i]} deployed at $NEOVIM_DIR${NEOVIM_DESTINATIONS[i]}"
      fi
    done
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
