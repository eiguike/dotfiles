#!/bin/bash

sudo apt-get update
sudo apt-get install -y \
  vim-gnome build-essential git curl zsh tmux arandr cmake \
  virtualbox ctags ack-grep

# Configuring vim
mkdir ~/Documents/git
mkdir ~/Documents/git/go
git clone https://github.com/eiguike/dotfiles.git ~/Documents/git/dotfiles
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

cp -r ~/Documents/git/dotfiles/.vim ~
cp ~/Documents/git/dotfiles/.vimrc ~/.vimrc
cp ~/Documents/git/dotfiles/.ctags ~/.ctags
cp ~/Documents/git/dotfiles/.git* ~/

vim -c ":PluginInstall" -c ":q" -c ":q"

curl -fsSL https://get.docker.com | bash 

# Rvm fingerprint
gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y \
  yarn nodejs

# Installing golang
wget https://dl.google.com/go/go1.12.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.12.5.linux-amd64.tar.gz
rm go1.12.5.linux-amd64.tar.gz

# Set shortcuts
cp ~/Documents/git/dotfiles/xfce4-keyboard-shortcuts.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/

# Installing oh-my-zshell
curl -sSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash

# Installing RVM
curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -sSL https://get.rvm.io | bash -s stable --ruby
source /home/$USER/.rvm/scripts/rvm

# Installing NodeJs
curl -sSL https://deb.nodesource.com/setup_11.x | sudo -E bash -

# Installing docker-compose
sudo curl -L "https://github.com/dovker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Create permission to use docker
sudo groupadd docker
sudo gpasswd -a $USER docker

echo "export GOPATH=\$HOME/Documents/git/go" >> ~/.bashrc
echo "export GOROOT=/usr/local/go" >> ~/.bashrc
echo "export PATH=\$PATH:\$GOPATH/bin" >> ~/.bashrc
echo "export PATH=\$PATH:\$GOROOT/bin" >> ~/.bashrc
echo "zsh" >> ~/.bashrc

clear
echo "Please reboot your machine..."
