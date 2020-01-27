#!/bin/sh

if [ "$(id -u)" -eq 0 ]; then
    echo "Do not run as root"
    exit 1
fi

if [ ! -x "$(command -v git)" ]; then
    echo "Git not found - installing"
    sudo apt install git
fi


[ ! -d "$HOME/Code/sh" ] && mkdir -p "$HOME"/Code/sh
[ ! -d "$HOME/.config" ] && mkdir -p "$HOME"/.config

# Clone all personal repositories
git -C "$HOME/Code/sh" clone https://github.com/7aske/utils-sh
git -C "$HOME/Code/sh" clone https://github.com/7aske/bashrc
git -C "$HOME/Code/sh" clone https://github.com/7aske/dotfiles
[ ! -e "$HOME/.scripts" ] && ln -sf "$HOME/Code/sh/utils-sh" "$HOME/.scripts"

# Set ~/.bashrc to source ~/Code/sh/bashrc/.bashrc
bash "$HOME"/Code/sh/bashrc/bashrc.sh &

# Setup links to respective dotfiles into .config
[ ! -e "$HOME/.config/neofetch" ] && ln -sf "$HOME/Code/sh/dotfiles/neofetch" "$HOME/.config/neofetch"
[ ! -e "$HOME/.config/nvim" ] && ln -sf "$HOME/Code/sh/dotfiles/nvim" "$HOME/.config/nvim"
[ ! -e "$HOME/.config/tmux" ] && ln -sf "$HOME/Code/sh/dotfiles/tmux" "$HOME/.config/tmux"

# Setup PATH and other .profile variables
PROFILE="$HOME"/.profile

EDITOR_VAR="export EDITOR=/usr/bin/nvim"
BROWSER_VAR="export BROWSER=/usr/bin/chromium"
FILE_VAR="export FILE=/usr/bin/thunar"
READER_VAR="export READER=/usr/bin/zathura"

SCRIPTS="export PATH=\"\$PATH\":\"\$HOME\"/.scripts"
UTILS_PY="export PATH=\"\$PATH\":\"\$HOME\"/Code/py/utils-py"
LOCAL_BIN="export PATH=\"\$PATH\":\"\$HOME\"/.local/bin"
CARGO_BIN="export PATH=\"\$PATH\":\"\$HOME\"/.cargo/bin"
GO_PATH="export GOPATH=\"\$HOME\"/.go"

if ! grep -q "$EDITOR_VAR" "$PROFILE"; then echo "$EDITOR_VAR" >>"$PROFILE"; fi
if ! grep -q "$BROWSER_VAR" "$PROFILE"; then echo "$BROWSER_VAR" >>"$PROFILE"; fi
if ! grep -q "$FILE_VAR" "$PROFILE"; then echo "$FILE_VAR" >>"$PROFILE"; fi
if ! grep -q "$READER_VAR" "$PROFILE"; then echo "$READER_VAR" >>"$PROFILE"; fi

if ! grep -q "$SCRIPTS" "$PROFILE"; then echo "$SCRIPTS" >>"$PROFILE"; fi
if ! grep -q "$UTILS_PY" "$PROFILE"; then echo "$UTILS_PY" >>"$PROFILE"; fi
if ! grep -q "$LOCAL_BIN" "$PROFILE"; then echo "$LOCAL_BIN" >>"$PROFILE"; fi
if ! grep -q "$CARGO_BIN" "$PROFILE"; then echo "$CARGO_BIN" >>"$PROFILE"; fi
if ! grep -q "$GO_PATH" "$PROFILE"; then echo "$GO_PATH" >>"$PROFILE"; fi

# Set terminal colors from ~/.Xresources
cp "$HOME/Code/sh/dotfiles/.Xresources" "$HOME/"

# Update packages
yes | sudo apt update
yes | sudo apt upgrade

# VIM
yes | sudo apt install neovim
sudo ln -sf /usr/bin/nvim /usr/bin/vim

# NETWORK
yes | sudo apt install curl
yes | sudo apt install wget
yes | sudo apt install samba
yes | sudo apt install vsftpd

# UTILITY
yes | sudo apt install neofetch
yes | sudo apt install tree
yes | sudo apt install cronie
yes | sudo apt install bat
yes | sudo apt install screen
yes | sudo apt install rsync
yes | sudo apt install htop
yes | sudo apt install sysstat

# FILE BROWSER
yes | sudo apt install ranger

# TOOLCHAINS

yes | sudo apt install nodejs
yes | sudo apt install npm
yes | sudo apt install python3
yes | sudo apt install mariadb-client
yes | sudo apt install mariadb-server
yes | sudo apt install mongodb
