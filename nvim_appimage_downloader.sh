#!/bin/bash

mkdir -p ~/Applications/
cd ~/Applications/ && { curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage ; chmod u+x nvim.appimage ; cd -; }

echo "theovim) Would you like to add nvim alias to your bashrc (Please don't do it if you have done it already)? -> Type yes/y/Y."
read -n1 alias_input
case $alias_input in
  yes|y|Y)
    echo "alias nvim ~/Applications//nvim.appimage" >> ~/.bashrc
esac

