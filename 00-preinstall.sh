if [[ $EUID -eq 0 ]]; then
    echo "Do not run as root"
    exit 1
fi

user=$SUDO_USER
home=$(getent passwd $user | cut -d: -f6)

git -C $home/Downloads clone https://aur.archlinux.org/yay.git && $home/Downloads/yay && yes | makepkg -sir
