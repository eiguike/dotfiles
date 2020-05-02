#!/bin/bash

echo "your email for git: "
read git_config_user_email

########################################
# Installing essentials programs
sudo apt-get update
sudo apt-get install -y \
  vim-gtk build-essential git curl zsh tmux arandr \
  cmake virtualbox ctags ack-grep libssl-dev libreadline-dev \
  zlib1g-dev xclip ripgrep
########################################

########################################
# Configuiring git
git config --global user.email $git_config_user_email
git config --global user.name "rick"
########################################

########################################
# Linking and Moving configuration files
cd ~
rm $(pwd)/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml
rm $(pwd)/.config/xfce4/terminal/terminalrc

ln -s $(pwd)/Documents/git/dotfiles/xfce4-keyboard-shortcuts.xml $(pwd)/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml
ln -s $(pwd)/Documents/git/dotfiles/terminalrc $(pwd)/.config/xfce4/terminal/terminalrc

# Configuring vim
mkdir ~/Documents/git
git clone https://github.com/eiguike/dotfiles.git ~/Documents/git/dotfiles
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

cp -r ~/Documents/git/dotfiles/.vim ~
ln -s $(pwd)/Documents/git/dotfiles/.vimrc $(pwd)/.vimrc
ln -s $(pwd)/Documents/git/dotfiles/.ctags $(pwd)/.ctags
ln -s $(pwd)/Documents/git/dotfiles/.gitconfig $(pwd)/.gitconfig
ln -s $(pwd)/Documents/git/dotfiles/.gitignore $(pwd)/.gitignore
ln -s $(pwd)/Documents/git/dotfiles/.tmux.conf $(pwd)/.tmux.conf

# Installing fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

vim -c ":PluginInstall" -c ":q" -c ":q"
vim -c ":call coc#util#install()" -c ":q"
vim -c ":CocInstall coc-tsserver coc-json" -c ":q"
########################################

########################################
# Installing Docker
curl -fsSL https://get.docker.com | bash 

# Create permission to use docker
sudo groupadd docker
sudo gpasswd -a $USER docker
sudo usermod -aG docker $(whoami)
########################################

########################################
# Installing Docker-Compose

DC_LATEST_VERSION=$(curl --silent \
  "https://api.github.com/repos/docker/compose/releases/latest" \
  | grep '"tag_name":' \
  | sed -E 's/.*"([^"]+)".*/\1/')

sudo curl -L "https://github.com/docker/compose/releases/download/$(DC_LATEST_VERSION)/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
########################################

########################################
# Installing oh-my-zshell
curl -sSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash
echo "zsh" >> ~/.bashrc
########################################

#######################################
# Installing asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
cd ~/.asdf
git checkout "$(git describe --abbrev=0 --tags)"

echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.zshrc
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.zshrc

. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# Installing asdf-ruby
asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf install ruby 2.6.3
asdf global ruby 2.6.3
#######################################

echo "export GOPATH=\$HOME/Documents/git/go" >> ~/.zshrc
echo "export GOROOT=/usr/local/go" >> ~/.zshrc
echo "export PATH=\$PATH:\$GOPATH/bin" >> ~/.zshrc
echo "export PATH=\$PATH:\$GOROOT/bin" >> ~/.zshrc
echo "export FZF_DEFAULT_COMMAND='rg --files --follow --hidden'" >> ~/.zshrc


########################################
# Generating asymmetric keys
echo "Generating a SSH Key..."
ssh-keygen -t rsa -b 4096 -C $git_config_user_email
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub | xclip -selection clipboard
########################################

clear
echo "Please reboot your machine..."
