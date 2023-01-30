#!/bin/sh

# Global vars
THEOVIM_DIR=~/.theovim/src
THEOVIM_FILES=("/theovim-help-doc.md" "/init.lua" "/lua/theo_init.lua" "/lua/theovim.lua" "/lua/plugins.lua" "/lua/look.lua" "/lua/file_et_search.lua" "/lua/lsp.lua")
NEOVIM_DIR=~/.config/nvim
NEOVIM_DESTINATIONS=("/" "/" "/lua/" "/lua/" "/lua/" "/lua/" "/lua/" "/lua/")


clean() {
  if [[ -d ~/.config/nvim ]]; then
    mkdir -p ~/.theovim.bu/
    mv ~/.config/nvim/ ~/.theovim.bu/nvim-bu/
    echo "Previous Theovim installation has been moved to ~/.theovim.bu"
  else
    echo "No previous Neovim installation found!"
  fi
}


install() {
  clean
  mkdir -p ~/.config/nvim/
  mkdir -p ~/.config/nvim/lua/
  for i in "${!THEOVIM_FILES[@]}"; do
    ln -s "$THEOVIM_DIR${THEOVIM_FILES[i]}" "$NEOVIM_DIR${NEOVIM_DESTINATIONS[i]}"
    printf "%s deployed in %s\n" "${THEOVIM_FILES[i]}" "$NEOVIM_DIR${NEOVIM_DESTINATIONS[i]}"
  done
}


update() {
  if [[ ! -d ~/.config/nvim ]]; then
    echo "Theovim installation is not found. Please run ./theovim.sh/install"
  else
    for i in "${!THEOVIM_FILES[@]}"; do
      if [[ ! -e "$NEOVIM_DIR${THEOVIM_FILES[i]}" ]]; then
        ln -s "$THEOVIM_DIR${THEOVIM_FILES[i]}" "$NEOVIM_DIR${NEOVIM_DESTINATIONS[i]}"
        printf "%s deployed in %s\n" "${THEOVIM_FILES[i]}" "$NEOVIM_DIR${NEOVIM_DESTINATIONS[i]}"
      fi
    done
  fi
}


help() {
  echo
  echo "Theovim Utility Script Usage"
  echo
  echo "============================"
  echo
  echo "Synax: theovim-util.sh <arg>"
  echo "----------------------------"
  echo "args:"
  echo "  install: Install Theovim"
  echo "  update: Pull the latest changes from the main branch and install any missing files"
  echo "  clean: Move Neovim the current Neovim configuration to ~/.theovim.bu"
  echo
}


main() {
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
     echo "Error: Invalid option"
     help
    ;;
  esac

  exit 0
}

########### MAIN CALL HERE ##########
main $1
########### MAIN CALL HERE ##########
