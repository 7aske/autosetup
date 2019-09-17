#!/bin/sh

if [ "$(id -u)" -eq 0 ]; then
    echo "Do not run as root"; exit 1;
fi

curl https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-folders/master/install.sh | sh

xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "Breeze_Snow"
xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus-Dark"
xfconf-query -c xsettings -p /Net/ThemeName -s "Matcha-dark-azul"
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path --set /usr/share/backgrounds/xfce/default-adapta-lockscreen.jpg
papirus-folders -C black