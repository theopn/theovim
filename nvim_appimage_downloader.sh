#!/bin/bash

mkdir -p ~/apps/
cd ~/apps/ && { curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage ; chmod u+x nvim.appimage ; cd -; }

echo "theovim) Would you like to add nvim alias to your bashrc (Please don't do it if you have done it already)? -> Type y/Y."
read -n1 alias_input
echo
case $alias_input in
  y|Y)
    echo -e "\n#Alias for those who prefer nvim appimage - Theovim" >> ~/.bashrc
    echo -e "alias nvim=~/apps/nvim.appimage\n" >> ~/.bashrc
    source ~/.bashrc
    echo "Bashrc has been modified and reloaded"
  ;;
  *)
    echo "Bye!"
  ;;
esac

