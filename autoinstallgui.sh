#!/bin/sh

if [ "$(id -u)" -eq 0 ]; then
    echo "Do not run as root"
    exit 1
fi

# X
yes '' | sudo pacman -S xorg --needed
yes '' | sudo pacman -S xorg-xinit --neededs
yes '' | sudo pacman -S lightdm-gtk-greeter --needed
yes '' | sudo pacman -S lightdm-gtk-greeter-settings --needed

# WINDOW MANAGER
yes '' | sudo pacman -S i3-gaps --needed
yes '' | sudo pacman -S i3blocks --needed
yes '' | sudo pacman -S i3lock --needed
yes '' | sudo pacman -S i3status --needed
yes '' | sudo pacman -S dunst --needed
yes '' | sudo pacman -S scrot --needed
yes '' | sudo pacman -S maim --needed
yes '' | sudo pacman -S rofi --needed
git -C /tmp clone https://github.com/davatorium/rofi-themes && sudo cp /tmp/rofi-themes/User\ Themes/onedark.rasi /home/nik/Documents && rm -rf /tmp/rofi-themes
yes '' | sudo pacman -S dmenu --needed
yes '' | sudo pacman -S fzf --needed
yes '' | sudo pacman -S xautolock --needed
yes '' | sudo pacman -S compton --needed
yes '' | sudo pacman -S nitrogen --needed
yes '' | sudo pacman -S network-manager-applet --needed
yes '' | sudo pacman -S xfce4-power-manager --needed
yes '' | sudo pacman -S playerctl --needed
yes '' | sudo pacman -S pulseaudio --needed
yes '' | sudo pacman -S pavucontrol --needed
yes '' | sudo pacman -S chromium --needed
yes '' | sudo pacman -S python-pywal --needed
yes '' | sudo pacman -S pa-applet --needed
yes '' | yay -S pa-applet-git --needed
yes '' | yay -S pamac-aur --needed

# NETOWORK
yes '' | sudo pacman -S tigervnc --needed

# Setup .xinitrc
echo "[ -f \"\$HOME\"/.profile ] && . \"\$HOME\"/.profile" >"$HOME"/.xinitrc
echo "[ -f \"\$HOME\"/.Xresources] && xrdb -merge \"\$HOME\"/.Xresources" >>"$HOME"/.xinitrc
echo "pgrep i3 || exec i3" >>"$HOME"/.xinitrc

# FONTS
yes '' | sudo pacman -S ttf-ubuntu-font-family --needed
yes '' | sudo pacman -S ttf-fira-code --needed
yes '' | sudo pacman -S ttf-liberation --needed
yes '' | sudo pacman -S noto-fonts --needed
yes '' | sudo pacman -S noto-fonts-emoji --needed

# ICONS AND THEMES
yes '' | yay -S nordic-theme-git --needed
yes '' | yay -S xcursor-breeze --needed
yes '' | sudo pacman -S lxappearance --needed
yes '' | sudo pacman -S materia-gtk-theme --needed
yes '' | sudo pacman -S papirus-icon-theme --needed
curl https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-folders/master/install.sh | sh

# UTILITY
yes '' | sudo pacman -S baobab --needed
yes '' | sudo pacman -S pandoc --needed
yes '' | sudo pacman -S xclip --needed
yes '' | sudo pacman -S feh --needed
yes '' | sudo pacman -S zathura --needed
yes '' | sudo pacman -S gnome-disk-utility --needed
yes '' | yay -S barrier --needed
# yes '' | sudo pacman -S conky --needed
# yes '' | sudo pacman -S plank --needed

# FILE BROWSER
yes '' | sudo pacman -S thunar --needed
yes '' | sudo pacman -S nautilus --needed
yes '' | sudo pacman -S gvfs --needed
yes '' | sudo pacman -S gvfs-smb --needed
#yes '' | sudo pacman -S pcmanfm --needed