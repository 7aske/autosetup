#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    echo "Run as root"
    exit 1
fi

yes | pacman -Syyu
yes | pacman -S git --needed

sed -i "s/^#Color/Color" /etc/pacman.conf
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
sed -i "/\[cummunity\]/,/Include/"'s/^#//' /etc/pacman.conf

yes | pacman -S ttf-ubuntu-font-family --needed
yes | pacman -S ttf-fira-code --needed
yes | pacman -S noto-fonts --needed
yes | pacman -S ttf-liberation --needed

yes | pacman -S vim --needed
yes | pacman -S tigervnc --needed
yes | pacman -S neofetch --needed
yes | pacman -S tree --needed
yes | pacman -S conky --needed
yes | pacman -S net-tools --needed
yes | pacman -S nmap --needed
yes | pacman -S curl --needed
yes | pacman -S wget --needed
yes | pacman -S plank --needed
yes | pacman -S baobab --needed
yes | pacman -S python-pywal --needed
yes | pacman -S xclip --needed
yes | pacman -S samba --needed
yes | pacman -S nautilus --needed
yes | pacman -S openssh --needed
yes | pacman -S gvfs --needed
yes | pacman -S gvfs-smb --needed
yes | pacman -S pulseaudio --needed
yes | pacman -S pavucontrol --needed

systemctl enable sshd

yes | pacman -S papirus-icon-theme --needed
yes | pacman -Rcns manjaro-hello

curl https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-folders/master/install.sh | sh

