if [[ $EUID -eq 0 ]]; then
    echo "Do not run as root"
    exit 1
fi

yes '' | yay -S xcursor-breeze --needed
yes '' | yay -S jetbrains-toolbox --needed
yes '' | yay -S google-chrome --needed
yes '' | yay -S albert-lite --needed
yes '' | yay -S vscodium-bin --needed
yes '' | yay -S matcha-gtk-theme --needed