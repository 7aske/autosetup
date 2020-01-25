#!/usr/bin/env sh

if [ "$(id -u)" -eq 0 ]; then
    echo "Do not run as root"
    exit 1
fi

# VIRTUAL BOX
yes '' | sudo pacman -S linux-headers --needed
yes '' | sudo pacman -S virtualbox-guest-iso --needed
yes '' | sudo pacman -S virtualbox-guest-utils --needed
yes '' | sudo pacman -S virtualbox-guest-dkms --needed

if ! [ -x "$(lsmod | grep vboxguest)" ]; then
    sudo mount /usr/lib/virtualbox/additions/VBoxGuestAdditions.iso /mnt/
    yes 'yes' | sudo /mnt/VBoxLinuxAdditions.run
    sudo umount /mnt
fi
