#!/bin/sh

if [ "$(id -u)" -eq 0 ]; then
    echo "Do not run as root"
    exit 1
fi

if ! [ -x "$(command -v git)" ]; then
    sudo pacman -S git
fi

YAY_DIR="/tmp/yay"
mkdir -p "$YAY_DIR"

git -C "$YAY_DIR" clone https://aur.archlinux.org/yay.git && cd "$YAY_DIR" && yes | makepkg -sir

mkdir -p "$HOME"/Code/sh
mkdir -p "$HOME"/.config


git -C "$HOME"/Code/sh clone https://github.com/7aske/utils-sh
git -C "$HOME"/Code/sh clone https://github.com/7aske/bashrc
git -C "$HOME"/Code/sh clone https://github.com/7aske/dotfiles
ln -sf "$HOME"/.scripts "$HOME"/Code/sh/utils-sh

bash "$HOME"/Code/sh/bashrc/update_bashrc.sh &

mkdir -p "$HOME"/.config/VSCodium/User
mkdir -p "$HOME"/.config/VSCode/User
ln -sf "$HOME"/Code/sh/dotfiles/VSCodium/User/settings.json "$HOME"/.config/VSCodium/User/settings.json
ln -sf "$HOME"/Code/sh/dotfiles/VSCode/User/settings.json "$HOME"/.config/VSCode/User/settings.json
ln -sf "$HOME"/Code/sh/dotfiles/VSCodium/User/keybindings.json "$HOME"/.config/VSCodium/User/keybindings.json
ln -sf "$HOME"/Code/sh/dotfiles/VSCode/User/keybindings.json "$HOME"/.config/VSCode/User/keybindings.json

ln -sf "$HOME"/Code/sh/dotfiles/albert "$HOME"/.config/albert
ln -sf "$HOME"/Code/sh/dotfiles/neofetch "$HOME"/.config/neofetch
ln -sf "$HOME"/Code/sh/dotfiles/kitty "$HOME"/.config/kitty
ln -sf "$HOME"/Code/sh/dotfiles/nvim "$HOME"/.config/nvim
ln -sf "$HOME"/Code/sh/dotfiles/rofi "$HOME"/.config/rofi
ln -sf "$HOME"/Code/sh/dotfiles/tmux "$HOME"/.config/tmux
ln -sf "$HOME"/Code/sh/dotfiles/i3 "$HOME"/.config/i3
ln -sf "$HOME"/Code/sh/dotfiles/i3blocks "$HOME"/.config/i3blocks
ln -sf "$HOME"/Code/sh/dotfiles/i3status "$HOME"/.config/i3status
ln -sf "$HOME"/Code/sh/dotfiles/dunst "$HOME"/.config/dunst
ln -sf "$HOME"/Code/sh/dotfiles/conky "$HOME"/.config/conky

cp "$HOME"/Code/sh/dotfiles/.Xresources "$HOME"/

# PROGRAMS

yes | pacman -Syyu
yes | pacman -S git --needed

sed -i "s/^#Color/Color" /etc/pacman.conf
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
sed -i "/\[cummunity\]/,/Include/"'s/^#//' /etc/pacman.conf

yes | sudo pacman -S ttf-ubuntu-font-family --needed
yes | sudo pacman -S ttf-fira-code --needed
yes | sudo pacman -S ttf-ms-font --needed
yes | sudo pacman -S ttf-liberation --needed
yes | sudo pacman -S noto-fonts --needed
yes | sudo pacman -S noto-fonts-emoji --needed


yes | sudo pacman -S dunst --needed
yes | sudo pacman -S scrot --needed
yes | sudo pacman -S rofi --needed
yes | sudo pacman -S dmenu --needed
yes | sudo pacman -S fzf --needed
yes | sudo pacman -S nvim --needed
yes | sudo pacman -S tigervnc --needed
yes | sudo pacman -S neofetch --needed
yes | sudo pacman -S tree --needed
yes | sudo pacman -S conky --needed
yes | sudo pacman -S net-tools --needed
yes | sudo pacman -S nmap --needed
yes | sudo pacman -S curl --needed
yes | sudo pacman -S wget --needed
yes | sudo pacman -S plank --needed
yes | sudo pacman -S baobab --needed
yes | sudo pacman -S python-pywal --needed
yes | sudo pacman -S xclip --needed
yes | sudo pacman -S samba --needed
yes | sudo pacman -S thunar --needed
yes | sudo pacman -S nautilus --needed
yes | sudo pacman -S openssh --needed
yes | sudo pacman -S cronie --needed
yes | sudo pacman -S gvfs --needed
yes | sudo pacman -S gvfs-smb --needed
yes | sudo pacman -S pulseaudio --needed
yes | sudo pacman -S pavucontrol --needed
yes | sudo pacman -S zathura --needed
yes | sudo pacman -S xfce4-power-manager --needed
yes | sudo pacman -S rxvt-unicode --needed
yes | sudo pacman -S xautolock --needed
yes | sudo pacman -S screen --needed
yes | sudo pacman -S samba --needed
yes | sudo pacman -S rsync --needed
yes | sudo pacman -S playerctl --needed
yes | sudo pacman -S network-manager-applet --needed
yes | sudo pacman -S bat --needed
yes | sudo pacman -S chromium --needed
yes | sudo pacman -S feh --needed
yes | sudo pacman -S i3-gaps --needed
yes | sudo pacman -S i3blocks --needed
yes | sudo pacman -S i3lock --needed
yes | sudo pacman -S i3status --needed
yes | sudo pacman -S compton --needed
yes | sudo pacman -S nitrogen --needed
yes | sudo pacman -S pamac --needed
yes | sudo pacman -S pamac-tray --needed
yes | sudo pacman -S pa-applet --needed
yes | sudo pacman -S maim --needed
yes | sudo pacman -S gnome-disks --needed

yes | sudo pacman -s xorg
yes | sudo pacman -s lightdm-gtk-greeter
yes | sudo pacman -s lightdm-gtk-greeter-settings

sudo systemctl enable sshd

yes | sudo pacman -S papirus-icon-theme --needed

curl https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-folders/master/install.sh | sh

yes | pacman -S jdk8-openjdk --needed
yes | pacman -S java8-openjfx --needed
yes | pacman -S nodejs --needed
yes | pacman -S npm --needed
yes | pacman -S go --needed
yes | pacman -S python --needed
yes | pacman -S rustup --needed

yes | pacman -S valgrind --needed

yes '' | yay -S barrier --needed
yes '' | yay -S xcursor-breeze --needed
yes '' | yay -S jetbrains-toolbox --needed
yes '' | yay -S vscodium-bin --needed
