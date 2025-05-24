#!/bin/bash

insert_git_email() {
  echo "enter your email for git: "
  read git_config_user_email
}

install_essential_programs() {
  sudo apt-get update
  sudo apt-get install -y \
    build-essential git curl zsh tmux arandr \
    cmake ack-grep libssl-dev libreadline-dev \
    zlib1g-dev xclip ripgrep exuberant-ctags libbz2-dev \
    libsqlite3-dev libffi-dev liblzma-dev libtk-img-dev
}

setup_git() {
  git config --global user.email $git_config_user_email
  git config --global user.name "rick"
  git config --global core.excludesFile '~/.gitignore'
}

install_oh_my_zshell() {
  curl -sSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash
  echo "zsh" >> ~/.bashrc
}

export_paths() {
  echo "export GOPATH=\$HOME/Documents/git/go" >> ~/.zshrc
  echo "export GOROOT=/usr/local/go" >> ~/.zshrc
  echo "export PATH=\$PATH:\$GOPATH/bin" >> ~/.zshrc
  echo "export PATH=\$PATH:\$GOROOT/bin" >> ~/.zshrc
  echo "export FZF_DEFAULT_COMMAND='rg --files --follow --hidden'" >> ~/.zshrc
}

setup_cedilla_key() {
  echo "GTK_IM_MODULE=cedilla" | sudo tee -a /etc/environment
  echo "Q_IM_MODULE=cedilla" | sudo tee -a /etc/environment

cat > ~/.XCompose << EOF
  # UTF-8 (Unicode) compose sequences

  # Overrides C acute with Ccedilla:
  <dead_acute> <C> : "Ç" "Ccedilla"
  <dead_acute> <c> : "ç" "ccedilla"
EOF
}

install_asdf() {
  ASDF_LATEST_VERSION=$(curl -s https://api.github.com/repos/asdf-vm/asdf/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
  ASDF_FILE_DOWNLOAD="asdf-${ASDF_LATEST_VERSION}-linux-amd64.tar.gz"
  ASDF_URL_DOWNLOAD="https://github.com/asdf-vm/asdf/releases/download/${ASDF_LATEST_VERSION}/${ASDF_FILE_DOWNLOAD}"
  
  wget $ASDF_URL_DOWNLOAD -P /tmp
  sudo tar -xf /tmp/$ASDF_FILE_DOWNLOAD -C /usr/local/bin
  
  mkdir -p "${HOME}/.asdf/completions"
  echo "export PATH=\"${HOME}/.asdf/shims:$PATH\"" >> ~/.zshrc

  export PATH="${HOME}/.asdf/shims:$PATH"
  asdf completion zsh > "${HOME}/.asdf/completions/_asdf"

tee -a ~/.zsh << END
  fpath=(${HOME}/.asdf}/completions $fpath)
  autoload -Uz compinit && compinit
END
}

install_asdf_ruby() {
  asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
  asdf install ruby 3.1.4
  asdf reshim ruby 3.1.4
  asdf set ruby 3.1.4
}

install_asdf_nodejs() {
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
  asdf install nodejs 16.20.0
  asdf reshim nodejs 16.20.0
  asdf set nodejs 16.20.0

  yes | npm install nodemon ts-node -g
  yes | npm install nodemon yarn -g
}

install_asdf_python() {
  asdf plugin add python
  asdf install python 2.7.18
  
  asdf plugin add python
  asdf install python 3.12.0
  asdf set python 3.12.0
}

setup_xubuntu_configuration() {
  # Linking and Moving configuration files
  cd ~
  rm $(pwd)/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml

  # XFCE4 Configuration files
  ln -s $(pwd)/Documents/git/dotfiles/keyboards.xml $(pwd)/.config/xfce4/xfconf/xfce-perchannel-xml/keyboards.xml
  ln -s $(pwd)/Documents/git/dotfiles/xfce4-keyboard-shortcuts.xml $(pwd)/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml
}

clone_dotfiles_repository() {
  mkdir ~/Documents/git
  git clone https://github.com/eiguike/dotfiles.git ~/Documents/git/dotfiles
}

setup_nvim() {
  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

  mkdir $(pwd)/.config/nvim
  ln -s $(pwd)/Documents/git/dotfiles/.vimrc $(pwd)/.config/nvim/init.vim
  ln -s $(pwd)/Documents/git/dotfiles/.ctags $(pwd)/.ctags
  ln -s $(pwd)/Documents/git/dotfiles/.gitconfig $(pwd)/.gitconfig
  ln -s $(pwd)/Documents/git/dotfiles/.gitignore $(pwd)/.gitignore
  ln -s $(pwd)/Documents/git/dotfiles/.tmux.conf $(pwd)/.tmux.conf

  # Installing fzf
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install <<< \n\n

  nvim --headless -c "PlugInstall" -c "qall"
  nvim --headless -c "CocInstall -sync coc-tsserver coc-json" -c "qall"

  cat ~/Documents/git/dotfiles/.vim/.cocnvim_conf >> ~/Documents/git/dotfiles/.vimrc
}

install_and_setup_docker() {
  curl -fsSL https://get.docker.com | bash 

  sudo groupadd docker
  sudo usermod -aG docker $USER

  DC_LATEST_VERSION=$(curl --silent \
    "https://api.github.com/repos/docker/compose/releases/latest" \
    | grep '"tag_name":' \
    | sed -E 's/.*"([^"]+)".*/\1/')

  sudo curl -L "https://github.com/docker/compose/releases/download/$DC_LATEST_VERSION/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
}

generate_asymmetric_keys() {
  ssh-keygen -t rsa -b 4096 -C $git_config_user_email -N '' -f ~/.ssh/id_rsa <<< y 
  ssh-add ~/.ssh/id_rsa
  cat ~/.ssh/id_rsa.pub | xclip -selection clipboard
}

install_nvim() {
  NEOVIM_FILE="nvim-linux-x86_64.tar.gz"
  NEOVIM_VERSION="v0.11.1"
  NEOVIM_DOWNLOAD="https://github.com/neovim/neovim/releases/download/${NEOVIM_VERSION}/${NEOVIM_FILE}"
  
  wget $NEOVIM_DOWNLOAD -P /tmp
  sudo tar -xf /tmp/$NEOVIM_FILE -C /opt/
  echo "export PATH=\"$PATH:/opt/nvim-linux-x86_64/bin\"" >> ~/.zshrc
  export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
  
  # Set vim as default editor
  sudo update-alternatives --set editor /opt/nvim-linux-x86_64/bin/nvim
}

install_nvim_requirements() {
  pip install pynvim --upgrade
  
  gem install --no-user-install neovim
  gem environment
  
  npm install -g neovim
}

steps_to_setup=(
  insert_git_email
  install_essential_programs
  install_oh_my_zshell
  install_asdf
    install_asdf_ruby
    install_asdf_nodejs
    install_asdf_python
  install_and_setup_docker
  export_paths
  setup_git
  clone_dotfiles_repository
    setup_xubuntu_configuration
    setup_cedilla_key
    install_nvim
      install_nvim_requirements
      setup_nvim
  generate_asymmetric_keys
)

for i in "${steps_to_setup[@]}"; do
  echo "Executing ${i}"
  if ${i}; then
    echo "Finished executing ${i}"
  else
    echo "Failed to execute ${i}"
    break
  fi
done
