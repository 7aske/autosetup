#!/bin/sh

if [ "$(id -u)" -eq 0 ]; then
    echo "Do not run as root"
    exit 1
fi

# X
yes '' | sudo pacman -S xorg --needed
yes '' | sudo pacman -S xorg-xinit --needed
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
yes '' | sudo pacman -S dmenu --needed
yes '' | sudo pacman -S fzf --needed
yes '' | sudo pacman -S xautolock --needed
yes '' | sudo pacman -S compton --needed
yes '' | sudo pacman -S nitrogen --needed
yes '' | sudo pacman -S network-manager-applet --needed
yes '' | sudo pacman -S xfce4-power-manager --needed
yes '' | sudo pacman -S playerctl --needed
yes '' | sudo pacman -S spotify --needed
yes '' | sudo pacman -S pulseaudio --needed
yes '' | sudo pacman -S pavucontrol --needed
yes '' | sudo pacman -S chromium --needed
yes '' | sudo pacman -S python-pywal --needed
yes '' | sudo pacman -S pa-applet --needed
yes '' | yay -S pa-applet-git --needed
yes '' | yay -S pamac-aur --needed

# i3_alternating layout
TMP_DIR=/tmp/i3-alternating-layout
AL_DIR="$HOME"/.local/bin
[ -d "$AL_DIR" ] || mkdir -p "$AL_DIR"
git -C /tmp clone "https://github.com/olemartinorg/i3-alternating-layout" && cp "$TMP_DIR"/alternating_layouts.py "$AL_DIR"/alternating_layouts && rm -rf "$TMP_DIR"
yes '' | yay -S python-i3-py --needed
yes '' | sudo pacman -S xorg-util-macros --needed

# NETWORK
yes '' | sudo pacman -S tigervnc --needed

# Setup .xinitrc
XINITRC="$HOME"/.xinitrc
PROFILE_SRC="[ -f \"\$HOME\"/.profile ] && . \"\$HOME\"/.profile"
XRESOURCES="[ -f \"\$HOME\"/.Xresources] && xrdb -merge \"\$HOME\"/.Xresources"
EXEC_I3="pgrep i3 || exec i3"

if ! grep -q "$PROFILE_SRC" "$XINITRC"; then echo "$PROFILE_SRC" >"$XINITRC"; fi
if ! grep -q "$XRESOURCES" "$XINITRC"; then echo "$XRESOURCES" >>"$XINITRC"; fi
if ! grep -q "$EXEC_I3" "$XINITRC"; then echo "$EXEC_I3" >>"$XINITRC"; fi

# FONTS
yes '' | sudo pacman -S ttf-ubuntu-font-family --needed
yes '' | sudo pacman -S ttf-fira-code --needed
yes '' | sudo pacman -S ttf-liberation --needed
yes '' | sudo pacman -S noto-fonts --needed
yes '' | sudo pacman -S noto-fonts-emoji --needed

# ICONS AND THEMES
# yes '' | yay -S nordic-theme-git --needed
# yes '' | sudo pacman -S materia-gtk-theme --needed
yes '' | yay -S xcursor-breeze --needed
yes '' | sudo pacman -S lxappearance --needed
yes '' | sudo pacman -S papirus-icon-theme --needed
curl https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-folders/master/install.sh | sh

# UTILITY
yes '' | sudo pacman -S baobab --needed
yes '' | sudo pacman -S pandoc --needed
yes '' | sudo pacman -S xclip --needed
yes '' | sudo pacman -S feh --needed
yes '' | sudo pacman -S zathura --needed
yes '' | sudo pacman -S gnome-disk-utility --needed
# yes '' | yay -S barrier --needed
# yes '' | sudo pacman -S conky --needed
# yes '' | sudo pacman -S plank --needed

# FILE BROWSER
yes '' | sudo pacman -S thunar --needed
yes '' | sudo pacman -S nautilus --needed
yes '' | sudo pacman -S gvfs --needed
yes '' | sudo pacman -S gvfs-smb --needed
#yes '' | sudo pacman -S pcmanfm --needed
