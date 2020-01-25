#!/usr/bin/env sh

# TOOLCHAINS AND COMPILERS
#yes '' | sudo pacman -S jdk8-openjdk --needed
#yes '' | sudo pacman -S java8-openjfx --needed
yes '' | sudo pacman -S jdk-openjdk --needed
yes '' | sudo pacman -S java-openjfx --needed
yes '' | sudo pacman -S nodejs --needed
yes '' | sudo pacman -S npm --needed
yes '' | sudo pacman -S go --needed
yes '' | sudo pacman -S python --needed
yes '' | sudo pacman -S python-pip --needed
yes '' | sudo pacman -S rustup --needed

# PROGRAMMING UTILITES
yes '' | sudo pacman -S valgrind --needed
yes '' | sudo pacman -S shellcheck --needed
yes '' | yay -S postman --needed
yes '' | yay -S mongodb-compass --needed

# IDE'S AND EDITORS
yes '' | yay -S jetbrains-toolbox --needed
yes '' | yay -S vscodium-bin --needed

# DATABASES
yes '' | yay -S mongodb-bin --needed
yes '' | sudo pacman -S mariadb --needed
