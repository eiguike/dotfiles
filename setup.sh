#!/bin/bash

sudo apt update
sudo apt install -y \
  vim-gnome build-essential git curl zsh tmux arandr cmake virtualbox # my programs

# Configuring vim
mkdir ~/Documents/git
git clone https://github.com/eiguike/dotfiles.git ~/Documents/git/dotfiles
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

cp -r ~/Documents/git/dotfiles/.vim ~
cp ~/Documents/git/dotfiles/.vimrc ~/.vimrc
cp ~/Documents/git/dotfiles/.ctags ~/.ctags
cp ~/Documents/git/dotfiles/.git* ~/

vim -c ":PluginInstall" -c ":q" -c ":q"

# Docker fingerprint
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Rvm fingerprint
gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

sudo apt update
sudo apt upgrade -y
sudo apt install -y \
  apt-transport-https ca-certificates gnupg-agent software-properties-common \ #docker
  docker-ce docker-ce-cli containerd.io \ # docker
  yarn nodejs # node js

# Set shortcuts
cp ~/Documents/git/dotfiles/xfce4-keyboard-shortcuts.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/

# Installing oh-my-zshell
curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash

# Installing RVM
curl -sSL https://get.rvm.io | bash -s stable --ruby

# Installing NodeJs
curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -

# Installing docker-compose
sudo curl -L "https://github.com/dovker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

clear
echo "Please reboot your machine..."
