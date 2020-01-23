#!/bin/sh

if [ "$(id -u)" -eq 0 ]; then
    echo "Do not run as root"
    exit 1
fi

if ! [ -x "$(command -v git)" ]; then
    sudo pacman -S git
fi

YAY_DIR="/tmp/yay"

git -C /tmp clone https://aur.archlinux.org/yay.git && cd "$YAY_DIR" && yes | makepkg -sir

mkdir -p "$HOME"/Code/sh
mkdir -p "$HOME"/.config

git -C "$HOME"/Code/sh clone https://github.com/7aske/utils-sh
git -C "$HOME"/Code/sh clone https://github.com/7aske/bashrc
git -C "$HOME"/Code/sh clone https://github.com/7aske/dotfiles
[ ! -e "$HOME"/Code/sh/utils-sh ] && ln -sf "$HOME"/.scripts "$HOME"/Code/sh/utils-sh

bash "$HOME"/Code/sh/bashrc/update_bashrc.sh &

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


echo "export EDITOR=/usr/bin/nvim" >> "$HOME"/.profile
echo "export BROWSER=/usr/bin/chromium" >> "$HOME"/.profile
echo "export FILE=/usr/bin/thunar" >> "$HOME"/.profile
echo "export READER=/usr/bin/zathura" >> "$HOME"/.profile

echo "export PATH="\$PATH":"\$HOME"/.scripts" >> "$HOME"/.profile
echo "export PATH="\$PATH":"\$HOME"/Code/py/utils-py" >> "$HOME"/.profile
echo "export PATH="\$PATH":"\$HOME"/.local/bin" >> "$HOME"/.profile
echo "export PATH="\$PATH":"\$HOME"/.cargo/bin" >> "$HOME"/.profile
echo "export GOPATH="\$HOME"/.go" >> "$HOME"/.profile

cp "$HOME"/Code/sh/dotfiles/.Xresources "$HOME"/
xrdb -merge ~/.Xresources

sudo sed -i "s/^#Color/Color" /etc/pacman.conf
sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
sudo sed -i "/\[cummunity\]/,/Include/"'s/^#//' /etc/pacman.conf

yes | sudo pacman -Syyu

yes | sudo pacman -S ttf-ubuntu-font-family --needed
yes | sudo pacman -S ttf-fira-code --needed
yes | sudo pacman -S ttf-liberation --needed
yes | sudo pacman -S noto-fonts --needed
yes | sudo pacman -S noto-fonts-emoji --needed

yes | sudo pacman -S dunst --needed
yes | sudo pacman -S scrot --needed
yes | sudo pacman -S rofi --needed
yes | sudo pacman -S dmenu --needed
yes | sudo pacman -S fzf --needed
yes | sudo pacman -S neovim --needed
sudo ln -sf /usr/bin/nvim /usr/bin/vim
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
yes | sudo pacman -S xterm --needed
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
yes | sudo pacman -S pa-applet --needed
yes | sudo pacman -S maim --needed
yes | sudo pacman -S gnome-disk-utility --needed
yes | sudo pacman -S lxappearance --needed
yes | sudo pacman -S htop --needed
yes | sudo pacman -S iostat --needed
yes | sudo pacman -S materia-gtk-theme --needed
yes | sudo pacman -S mariadb --needed

yes '' | sudo pacman -S xorg --needed
yes '' | sudo pacman -S xorg-xinit --needed
yes '' | sudo pacman -S lightdm-gtk-greeter --needed
yes '' | sudo pacman -S lightdm-gtk-greeter-settings --needed

echo "[ -f "\$HOME"/.profile ] && . "\$HOME"/.profile" >"$HOME"/.xinitrc
echo "[ -f "\$HOME"/.Xresources] && xrdb -merge "\$HOME"/.Xresources" >>"$HOME"/.xinitrc
echo "pgrep i3 || exec i3" >>"$HOME"/.xinitrc

sudo systemctl enable sshd

yes | sudo pacman -S papirus-icon-theme --needed

curl https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-folders/master/install.sh | sh

yes | sudo pacman -S jdk8-openjdk --needed
yes | sudo pacman -S java8-openjfx --needed
yes | sudo pacman -S nodejs --needed
yes | sudo pacman -S npm --needed
yes | sudo pacman -S go --needed
yes | sudo pacman -S python --needed
yes | sudo pacman -S rustup --needed

yes | sudo pacman -S valgrind --needed

yes | sudo pacman -S linux-headers --needed
yes | sudo pacman -S virtualbox-guest-iso --needed
yes | sudo pacman -S virtualbox-guest-utils --needed
yes | sudo pacman -S virtualbox-guest-dkms --needed

if ! [ -x "$(lsmod | grep vboxguest)" ]; then
    sudo mount /usr/lib/virtualbox/additions/VBoxGuestAdditions.iso /mnt/
    yes 'yes' | sudo /mnt/VBoxLinuxAdditions.run
    sudo umount /mnt
fi
git -C /tmp clone https://github.com/davatorium/rofi-themes && sudo cp /tmp/rofi-themes/User\ Themes/onedark.rasi /usr/share/rofi/themes/ && rm -rf /tmp/rofi-themes

yes '' | yay -S barrier --needed
yes '' | yay -S xcursor-breeze --needed
yes '' | yay -S jetbrains-toolbox --needed
yes '' | yay -S vscodium-bin --needed
yes '' | yay -S pa-applet-git --needed
yes '' | yay -S pamac-aur --needed
yes '' | yay -S nordic-theme-git --needed
yes '' | yay -S mongodb-bin --needed
yes '' | yay -S mongodb-compass --needed
yes '' | yay -S postman --needed
