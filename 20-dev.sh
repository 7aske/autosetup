#!/bin/sh

if [ "$(id -u)" -ne 0 ]; then
    echo "Run as root"; exit 1;
fi

yes | pacman -S jdk8-openjdk --needed
yes | pacman -S java8-openjfx --needed
yes | pacman -S nodejs --needed
yes | pacman -S npm --needed
yes | pacman -S go --needed
yes | pacman -S python --needed