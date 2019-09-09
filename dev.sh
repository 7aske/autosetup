if [[ $EUID -ne 0 ]]; then
    echo "Run as root"
    exit 1
fi

yes | pacman -S jdk8-openjdk
yes | pacman -S java8-openjfx
yes | pacman -S nodejs
yes | pacman -S npm
yes | pacman -S go
