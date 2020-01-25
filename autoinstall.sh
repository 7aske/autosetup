#!/bin/sh

if [ "$(id -u)" -eq 0 ]; then
    echo "Do not run as root"
    exit 1
fi

if ! [ -x "$(command -v git)" ]; then
    echo "Git not found - installing"
    sudo pacman -S git
fi

YAY_DIR="/tmp/yay"

git -C /tmp clone https://aur.archlinux.org/yay.git && cd "$YAY_DIR" && yes | makepkg -sir
rm -rf $YAY_DIR

mkdir -p "$HOME"/Code/sh
mkdir -p "$HOME"/.config

# Clone all personal repositories
git -C "$HOME"/Code/sh clone https://github.com/7aske/utils-sh
git -C "$HOME"/Code/sh clone https://github.com/7aske/bashrc
git -C "$HOME"/Code/sh clone https://github.com/7aske/dotfiles
[ ! -e "$HOME"/Code/sh/utils-sh ] && ln -sf "$HOME"/.scripts "$HOME"/Code/sh/utils-sh

# Set ~/.bashrc to source ~/Code/sh/bashrc/.bashrc
bash "$HOME"/Code/sh/bashrc/update_bashrc.sh &

# Setup links to respective dotfiles into .config
mkdir -p "$HOME"/.config/VSCodium/User
mkdir -p "$HOME"/.config/VSCode/User
[ ! -e "$HOME"/.config/VSCodium/User/settings.json ] && ln -sf "$HOME"/Code/sh/dotfiles/VSCodium/User/settings.json "$HOME"/.config/VSCodium/User/settings.json
[ ! -e "$HOME"/.config/VSCode/User/settings.json ] && ln -sf "$HOME"/Code/sh/dotfiles/VSCode/User/settings.json "$HOME"/.config/VSCode/User/settings.json
[ ! -e "$HOME"/.config/VSCodium/User/keybindings.json ] && ln -sf "$HOME"/Code/sh/dotfiles/VSCodium/User/keybindings.json "$HOME"/.config/VSCodium/User/keybindings.json
[ ! -e "$HOME"/.config/VSCode/User/keybindings.json ] && ln -sf "$HOME"/Code/sh/dotfiles/VSCode/User/keybindings.json "$HOME"/.config/VSCode/User/keybindings.json
[ ! -e "$HOME"/.config/albert ] && ln -sf "$HOME"/Code/sh/dotfiles/albert "$HOME"/.config/albert
[ ! -e "$HOME"/.config/neofetch ] && ln -sf "$HOME"/Code/sh/dotfiles/neofetch "$HOME"/.config/neofetch
[ ! -e "$HOME"/.config/kitty ] && ln -sf "$HOME"/Code/sh/dotfiles/kitty "$HOME"/.config/kitty
[ ! -e "$HOME"/.config/nvim ] && ln -sf "$HOME"/Code/sh/dotfiles/nvim "$HOME"/.config/nvim
[ ! -e "$HOME"/.config/rofi ] && ln -sf "$HOME"/Code/sh/dotfiles/rofi "$HOME"/.config/rofi
[ ! -e "$HOME"/.config/tmux ] && ln -sf "$HOME"/Code/sh/dotfiles/tmux "$HOME"/.config/tmux
[ ! -e "$HOME"/.config/i3 ] && ln -sf "$HOME"/Code/sh/dotfiles/i3 "$HOME"/.config/i3
[ ! -e "$HOME"/.config/i3blocks ] && ln -sf "$HOME"/Code/sh/dotfiles/i3blocks "$HOME"/.config/i3blocks
[ ! -e "$HOME"/.config/i3status ] && ln -sf "$HOME"/Code/sh/dotfiles/i3status "$HOME"/.config/i3status
[ ! -e "$HOME"/.config/dunst ] && ln -sf "$HOME"/Code/sh/dotfiles/dunst "$HOME"/.config/dunst
[ ! -e "$HOME"/.config/conky ] && ln -sf "$HOME"/Code/sh/dotfiles/conky "$HOME"/.config/conky

# Setup PATH and other .profile variables
echo "export EDITOR=/usr/bin/nvim" >>"$HOME"/.profile
echo "export BROWSER=/usr/bin/chromium" >>"$HOME"/.profile
echo "export FILE=/usr/bin/thunar" >>"$HOME"/.profile
echo "export READER=/usr/bin/zathura" >>"$HOME"/.profile

echo "export PATH=\"\$PATH\":\"\$HOME\"/.scripts" >>"$HOME"/.profile
echo "export PATH=\"\$PATH\":\"\$HOME\"/Code/py/utils-py" >>"$HOME"/.profile
echo "export PATH=\"\$PATH\":\"\$HOME\"/.local/bin" >>"$HOME"/.profile
echo "export PATH=\"\$PATH\":\"\$HOME\"/.cargo/bin" >>"$HOME"/.profile
echo "export GOPATH=\"\$HOME\"/.go" >>"$HOME"/.profile

# Set terminal colors from ~/.Xresources
cp "$HOME"/Code/sh/dotfiles/.Xresources "$HOME"/
xrdb -merge ~/.Xresources

# Enable pacman colors in terminal and enable multilib and comunity repositories
sudo sed -i "s/^#Color/Color" /etc/pacman.conf
sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
sudo sed -i "/\[cummunity\]/,/Include/"'s/^#//' /etc/pacman.conf

# Update packages
yes '' | sudo pacman -Syyu

# VIM
yes '' | sudo pacman -S neovim --needed
sudo ln -sf /usr/bin/nvim /usr/bin/vim

# NETWORK
yes '' | sudo pacman -S net-tools --needed
yes '' | sudo pacman -S nmap --needed
yes '' | sudo pacman -S curl --needed
yes '' | sudo pacman -S wget --needed
yes '' | sudo pacman -S samba --needed
yes '' | sudo pacman -S networkmanager --needed
sudo systemctl enable NetworkManager
yes '' | sudo pacman -S openssh --needed
sudo systemctl enable sshd

# TERMINAL
yes '' | sudo pacman -S rxvt-unicode --needed
yes '' | sudo pacman -S xterm --needed

# UTILITY
yes '' | sudo pacman -S neofetch --needed
yes '' | sudo pacman -S tree --needed
yes '' | sudo pacman -S cronie --needed
yes '' | sudo pacman -S bat --needed
yes '' | sudo pacman -S screen --needed
yes '' | sudo pacman -S rsync --needed
yes '' | sudo pacman -S htop --needed
yes '' | sudo pacman -S sysstat --needed

# FILE BROWSER
yes '' | sudo pacman -S ranger --needed

