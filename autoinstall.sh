#!/usr/bin/env bash
cat <<EOF
      _      _____         _                             
  ___| |__  |___  |_ _ ___| | _____   ___ ___  _ __ ___  
 / __| '_ \    / / _' / __| |/ / _ \ / __/ _ \| '_ ' _ \ 
 \__ \ | | |_ / / (_| \__ \   <  __/| (_| (_) | | | | | |
 |___/_| |_(_)_/ \__,_|___/_|\_\___(_)___\___/|_| |_| |_|
 ========================================================
EOF

config_package_manager() {
    if [ -f "/etc/os-release" ]; then
        source "/etc/os-release"
    else
        echo -e "\e[1;31mUnable to get os distribution\e[0m"
        exit 1
    fi

    if [ -n "$ID_LIKE" ]; then
        case $ID_LIKE in
        "arch")
            PKG_MAN="pacman"
            config_arch
            ;;
        "debian")
            PKG_MAN="apt"
            config_deb
            ;;
        esac
        DISTRO="$ID_LIKE"

    elif [ -n "$ID" ]; then
        case $ID in
        "arch")
            PKG_MAN="pacman"
            config_arch
            ;;
        "debian")
            PKG_MAN="apt"
            config_deb
            ;;
        "void")
            PKG_MAN="xbps"
            config_void
            ;;
        esac
        DISTRO="$ID"
    else
        echo -e "\e[1;31mUnable to get os distribution\e[0m"
        exit 1
    fi

    case "$PKG_MAN" in
    "apt")
        PKG_INST="apt -qq install"
        PKG_INST_EXTRA="snap install --classic"
        ;;
    "pacman")
        PKG_INST="pacman --noconfirm -Sq"
        PKG_INST_EXTRA="yay -Sq"
        ;;
    "xbps")
        PKG_INST="xbps-install"
        PKG_INST_EXTRA=""
        ;;
    esac
}

check_pkg() {
    case "$DISTRO" in
    "arch")
        yay -Qq "$1" 2>/dev/null
        ;;
    "debian")
        dpkg --get-selections | grep -q "$1"
        ;;
    "void")
        xbps-query -S "$1" >/dev/null 2>&1
        ;;
    esac
}

install_pkg() {
    if [ -z "$PKG_INST" ]; then
        echo -e "\e[1;31mNo package manager specified\e[0m"
        exit 1
    fi
    if [ -z "$1" ]; then
        echo -e "\e[1;31mNo package specified\e[0m"
        return
    fi
    if check_pkg "$1"; then
        echo -e "\e[33mPackage '$1' already installed\e[0m"
    else
        echo -e "\e[32mInstalling package '$1'\e[0m"
        yes | sudo $PKG_INST "$1"
    fi
}

service_enable() {
    if [ -z "$1" ]; then
        echo -e "\e[1;31mNo service specified\e[0m"
        return
    fi
    case "$DISTRO" in
    "arch")
        sudo systemctl enable "$1"
        sudo systemctl start "$1"
        ;;
    "debian")
        sudo systemctl enable "$1"
        sudo systemctl start "$1"
        ;;
    "void")
        [ ! -e "/var/service/$1" ] && sudo ln -s /etc/sv/"$1" /var/service/
        sudo sv up "$1"
        ;;
    esac
}

install_pkg_extra() {
    if [ -z "$PKG_INST" ]; then
        echo "\e[1;31No package manager specified\e[0"
        exit 1
    fi
    if [ -z "$1" ]; then
        echo -e "\e[1;31mNo package specified\e[0m"
        return
    fi
    if check_pkg "$1"; then
        echo -e "\e[33mPackage '$1' already installed\e[0m"
    else
        echo -e "\e[32mInstalling package '$1'\e[0m"
        if [ "$DISTRO" = "arch" ]; then
            yes | $PKG_INST_EXTRA "$1"
        elif [ "$DISTRO" = "debian" ]; then
            yes | sudo $PKG_INST_EXTRA "$1"
        fi
    fi
}

config_arch() {
    # Enable pacman colors in terminal and enable multilib and comunity repositories
    sudo sed -i "s/^#Color/Color/" /etc/pacman.conf
    sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
    sudo sed -i "/\[cummunity\]/,/Include/"'s/^#//' /etc/pacman.conf

    # Update packages
    yes '' | sudo pacman -Syyu

    if [ ! -x "$(command -v yay)" ] && [ "$PKG_MAN" = "pacman" ]; then
        git -C /tmp clone https://aur.archlinux.org/yay.git && cd /tmp/yay && yes | makepkg -sir && rm -rf /tmp/yay
    fi
}

config_deb() {
    yes | sudo apt -qq update
    yes | sudo apt -qq upgrade

    yes | sudo apt -qq install snapd
}

config_void() {
    yes | sudo xbps-install -Su
}

config_dotfiles() {
    echo -e "\e[32mSetting up dotfiles\e[0m"
    [ ! -d "$HOME/Code/sh" ] && mkdir -p "$HOME/Code/sh"
    [ ! -d "$HOME/.config" ] && mkdir -p "$HOME/.config"

    # Clone all personal repositories
    [ ! -e "$HOME/Code/sh/utils-sh" ] && git -C "$HOME/Code/sh" clone "https://github.com/7aske/utils-sh"
    [ ! -e "$HOME/Code/py/utils-py" ] && git -C "$HOME/Code/py" clone "https://github.com/7aske/utils-py"
    [ ! -e "$HOME/.pyscripts" ] && [ -d "$HOME/Code/py/utils-py" ] && ln -sf "$HOME/Code/py/utils-py" "$HOME/.pyscripts"
    [ ! -e "$HOME/.scripts" ] && [ -d "$HOME/Code/sh/utils-sh" ] && ln -sf "$HOME/Code/sh/utils-sh" "$HOME/.scripts"
    [ ! -e "$HOME/Code/sh/bashrc" ] && git -C "$HOME/Code/sh" clone "https://github.com/7aske/bashrc"
    [ ! -e "$HOME/Code/sh/dotfiles" ] && git -C "$HOME/Code/sh" clone "https://github.com/7aske/dotfiles"

    # Set ~/.bashrc to source ~/Code/sh/bashrc/.bashrc
    bash "$HOME/Code/sh/bashrc/bashrc.sh"

    # Setup links to respective dotfiles into .config
    mkdir -p "$HOME/.config/VSCodium/User"
    mkdir -p "$HOME/.config/VSCode/User"
    [ ! -e "$HOME/.config/VSCodium/User/settings.json" ] && ln -sf "$HOME/Code/sh/dotfiles/VSCodium/User/settings.json" "$HOME/.config/VSCodium/User/settings.json"
    [ ! -e "$HOME/.config/VSCode/User/settings.json" ] && ln -sf "$HOME/Code/sh/dotfiles/VSCode/User/settings.json" "$HOME/.config/VSCode/User/settings.json"
    [ ! -e "$HOME/.config/VSCodium/User/keybindings.json" ] && ln -sf "$HOME/Code/sh/dotfiles/VSCodium/User/keybindings.json" "$HOME/.config/VSCodium/User/keybindings.json"
    [ ! -e "$HOME/.config/VSCode/User/keybindings.json" ] && ln -sf "$HOME/Code/sh/dotfiles/VSCode/User/keybindings.json" "$HOME/.config/VSCode/User/keybindings.json"
    [ ! -e "$HOME/.config/albert" ] && ln -sf "$HOME/Code/sh/dotfiles/albert" "$HOME/.config/albert"
    [ ! -e "$HOME/.config/neofetch" ] && ln -sf "$HOME/Code/sh/dotfiles/neofetch" "$HOME/.config/neofetch"
    [ ! -e "$HOME/.config/kitty" ] && ln -sf "$HOME/Code/sh/dotfiles/kitty" "$HOME/.config/kitty"
    [ ! -e "$HOME/.config/nvim" ] && ln -sf "$HOME/Code/sh/dotfiles/nvim" "$HOME/.config/nvim"
    [ ! -e "$HOME/.config/rofi" ] && ln -sf "$HOME/Code/sh/dotfiles/rofi" "$HOME/.config/rofi"
    [ ! -e "$HOME/.config/wal" ] && ln -sf "$HOME/Code/sh/dotfiles/wal" "$HOME/.config/wal"
    [ ! -e "$HOME/.config/tmux" ] && ln -sf "$HOME/Code/sh/dotfiles/tmux" "$HOME/.config/tmux"
    [ ! -e "$HOME/.config/i3" ] && ln -sf "$HOME/Code/sh/dotfiles/i3" "$HOME/.config/i3"
    [ ! -e "$HOME/.config/i3blocks" ] && ln -sf "$HOME/Code/sh/dotfiles/i3blocks" "$HOME/.config/i3blocks"
    [ ! -e "$HOME/.config/i3status" ] && ln -sf "$HOME/Code/sh/dotfiles/i3status" "$HOME/.config/i3status"
    [ ! -e "$HOME/.config/dunst" ] && ln -sf "$HOME/Code/sh/dotfiles/dunst" "$HOME/.config/dunst"
    [ ! -e "$HOME/.config/conky" ] && ln -sf "$HOME/Code/sh/dotfiles/conky" "$HOME/.config/conky"
}

config_profile() {
    echo -e "\e[32mConfiguring .profile variables\e[0m"
    # Setup PATH and other .profile variables
    PROFILE="$HOME/.profile"

    EDITOR_VAR="export EDITOR=/usr/bin/nvim"
    BROWSER_VAR="export BROWSER=/usr/bin/chromium"
    FILE_VAR="export FILE=/usr/bin/thunar"
    READER_VAR="export READER=/usr/bin/zathura"

    SCRIPTS="export PATH=\"\$PATH\":\"\$HOME\"/.scripts"
    UTILS_PY="export PATH=\"\$PATH\":\"\$HOME\"/Code/py/utils-py"
    LOCAL_BIN="export PATH=\"\$PATH\":\"\$HOME\"/.local/bin"
    CARGO_BIN="export PATH=\"\$PATH\":\"\$HOME\"/.cargo/bin"
    GO_PATH="export GOPATH=\"\$HOME\"/.go"

    if ! grep -q "$EDITOR_VAR" "$PROFILE"; then echo "$EDITOR_VAR" >>"$PROFILE"; fi
    if ! grep -q "$BROWSER_VAR" "$PROFILE"; then echo "$BROWSER_VAR" >>"$PROFILE"; fi
    if ! grep -q "$FILE_VAR" "$PROFILE"; then echo "$FILE_VAR" >>"$PROFILE"; fi
    if ! grep -q "$READER_VAR" "$PROFILE"; then echo "$READER_VAR" >>"$PROFILE"; fi

    if ! grep -q "$SCRIPTS" "$PROFILE"; then echo "$SCRIPTS" >>"$PROFILE"; fi
    if ! grep -q "$UTILS_PY" "$PROFILE"; then echo "$UTILS_PY" >>"$PROFILE"; fi
    if ! grep -q "$LOCAL_BIN" "$PROFILE"; then echo "$LOCAL_BIN" >>"$PROFILE"; fi
    if ! grep -q "$CARGO_BIN" "$PROFILE"; then echo "$CARGO_BIN" >>"$PROFILE"; fi
    if ! grep -q "$GO_PATH" "$PROFILE"; then echo "$GO_PATH" >>"$PROFILE"; fi

    # Set terminal colors from ~/.Xresources
    cp "$HOME"/Code/sh/dotfiles/.Xresources "$HOME/"
}

#   __  ____   _    ____ _  __    _    ____ _____ ____   __
#  / / |  _ \ / \  / ___| |/ /   / \  / ___| ____/ ___|  \ \
# / /  | |_) / _ \| |   | ' /   / _ \| |  _|  _| \___ \   \ \
# \ \  |  __/ ___ \ |___| . \  / ___ \ |_| | |___ ___) |  / /
#  \_\ |_| /_/   \_\____|_|\_\/_/   \_\____|_____|____/  /_/

install_packages() {
    echo -e "\e[32mInstalling packages\e[0m"

    # VIM
    install_pkg neovim
    [ ! -f "/usr/bin/vim" ] && sudo ln -sf /usr/bin/nvim /usr/bin/vim

    # NETWORK
    install_pkg net-tools
    install_pkg nmap
    install_pkg curl
    install_pkg wget
    install_pkg samba
    install_pkg vsftpd

    # TERMINAL
    install_pkg rxvt-unicode
    install_pkg xterm

    # UTILITY
    install_pkg neofetch
    install_pkg tree

    install_pkg bat
    install_pkg screen
    install_pkg rsync
    install_pkg htop
    install_pkg sysstat

    case "$DISTRO" in
    "arch")
        install_pkg cronie
        install_pkg openssh
        install_pkg networkmanager
        install_pkg python
        install_pkg python-pip
        install_pkg python-pipenv
        ;;
    "void")
        install_pkg cronie
        install_pkg openssh
        install_pkg NetworkManager
        install_pkg python3
        install_pkg python3-pip
        ;;
    "debian")
        install_pkg cron
        install_pkg openssh-client
        install_pkg openssh-server
        install_pkg network-manager
        install_pkg python3
        install_pkg python3-pip
        ;;
    esac

    # FILE BROWSER
    install_pkg ranger

    # services
    service_enable NetworkManager
    service_enable sshd
}

#   __    __  ____   _    ____ _  __    _    ____ _____ ____   __
#  / /   / / |  _ \ / \  / ___| |/ /   / \  / ___| ____/ ___|  \ \
# / /   / /  | |_) / _ \| |   | ' /   / _ \| |  _|  _| \___ \   \ \
# \ \  / /   |  __/ ___ \ |___| . \  / ___ \ |_| | |___ ___) |  / /
#  \_\/_/    |_| /_/   \_\____|_|\_\/_/   \_\____|_____|____/  /_/

#   __   ____ _   _ ___  __
#  / /  / ___| | | |_ _| \ \
# / /  | |  _| | | || |   \ \
# \ \  | |_| | |_| || |   / /
#  \_\  \____|\___/|___| /_/

install_i3_deb() {
    if [ ! -x "$(command -v git)" ]; then
        install_pkg git
    fi

    if [ -x "$(command -v i3)" ]; then
        echo -e "\e[1;33mi3 is already installed\e[0m"
    fi

    sudo apt install -y libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf libxcb-xrm0 libxcb-xrm-dev automake

    cd /tmp || echo -e "\e[1;31mUnable to chdir to /tmp\e[0m" && exit 1

    git clone https://www.github.com/Airblader/i3 i3-gaps
    cd i3-gaps || echo -e "\e[1;31mUnable to chdir to /tmp/i3-gaps\e[0m" && exit 1

    autoreconf --force --install
    rm -rf build/
    mkdir -p build && cd build/ || echo -e "\e[1;31mUnable to chdir to /tmp/i3-gaps/build\e[0m" && exit 1

    ../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
    make
    sudo make install
}

install_i3_al() {
    # i3_alternating layout
    sudo /usr/bin/env python3 -m pip install i3-py
    install_pkg xorg-util-macros
    TMP_DIR=/tmp/i3-alternating-layout
    AL_DIR="$HOME/.local/bin"
    [ -f "$AL_DIR/alternating_layouts" ] && echo -e "\e[33m'alternating-layouts' already installe\e[0m" && return
    [ -d "$AL_DIR" ] || mkdir -p "$AL_DIR"
    git -C /tmp clone "https://github.com/olemartinorg/i3-alternating-layout" && cp "$TMP_DIR/alternating_layouts.py" "$AL_DIR/alternating_layouts" && rm -rf "$TMP_DIR"
}

config_xinitrc() {
    # Setup .xinitrc
    XINITRC="$HOME/.xinitrc"
    PROFILE_SRC="[ -f \"\$HOME\"/.profile ] && . \"\$HOME\"/.profile"
    XRESOURCES="[ -f \"\$HOME\"/.Xresources ] && xrdb -merge \"\$HOME\"/.Xresources"
    EXEC_I3="pgrep i3 || exec i3"

    if ! grep -q "$PROFILE_SRC" "$XINITRC"; then echo "$PROFILE_SRC" >"$XINITRC"; fi
    if ! grep -q "$XRESOURCES" "$XINITRC"; then echo "$XRESOURCES" >>"$XINITRC"; fi
    if ! grep -q "$EXEC_I3" "$XINITRC"; then echo "$EXEC_I3" >>"$XINITRC"; fi
    [ ! -x "$XINITRC" ] && chmod u+x "$XINITRC"
}

install_gui() {

    # X
    install_pkg xorg
    if [ "$DISTRO" = "arch" ]; then
        install_pkg xorg-xinit
    fi
    install_pkg lightdm-gtk-greeter
    install_pkg lightdm-gtk-greeter-settings

    # WINDOW MANAGER
    case "$DISTRO" in
    "arch")
        install_pkg i3-gaps
        install_pkg chromium
        install_pkg python-pywal
        install_pkg network-manager-applet
        install_pkg_extra pamac-aur

        # NETWORK
        install_pkg tigervnc
        ;;
    "void")
        install_pkg i3-gaps
        install_pkg chromium
        install_pkg pywal
        install_pkg network-manager-applet

        # NETWORK
        install_pkg tigervnc
        ;;
    "debian")
        install_pkg i3
        install_pkg chromium-browser
        install_pkg chromium
        [ ! -f "/usr/bin/chromium" ] && sudo ln -sf "/usr/bin/chromium-browser" "/usr/bin/chromium"
        sudo /usr/bin/env python3 -m pip install pywal
        # NETWORK
        install_pkg tigervnc-viewer
        install_pkg network-manager-gnome
        ;;
    esac

    if [ "$DISTRO" = "void" ]; then
        install_pkg ImageMagick
    else
        install_pkg imagemagick
    fi
    install_pkg i3blocks
    install_pkg i3lock
    install_pkg i3status
    install_i3_al

    install_pkg dunst
    install_pkg scrot
    install_pkg maim
    install_pkg rofi
    install_pkg dmenu
    install_pkg fzf
    install_pkg xautolock
    install_pkg compton
    install_pkg nitrogen
    install_pkg xfce4-power-manager
    install_pkg playerctl
    install_pkg pulseaudio
    install_pkg pavucontrol
    install_pkg pasystray

    case "$DISTRO" in
    "arch")
        # FONTS
        install_pkg ttf-ubuntu-font-family
        install_pkg ttf-fira-code
        install_pkg ttf-liberation
        install_pkg noto-fonts
        install_pkg noto-fonts-emoji
        install_pkg arc-gtk-theme
        install_pkg_extra xcursor-breeze
        ;;
    "void")
        # FONTS
        install_pkg ttf-ubuntu-font-family
        install_pkg font-firacode
        install_pkg liberation-fonts-ttf
        install_pkg noto-fonts-ttf
        install_pkg noto-fonts-emoji

        install_pkg arc-theme
        install_pkg breeze-cursor
        ;;
    "debian")
        install_pkg fonts-firacode
        install_pkg fonts-ubuntu
        install_pkg fonts-liberation
        install_pkg fonts-noto
        install_pkg fonts-noto-color-emoji
        install_pkg arc-theme
        install_pkg breeze-cursor-theme
        ;;
    esac

    # install_pkg papirus-icon-theme
    install_pkg lxappearance
    if [ ! -x "$(command -v papirus-folders)" ]; then
        curl https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-folders/master/install.sh | sh
    fi

    # UTILITY
    install_pkg baobab
    install_pkg pandoc
    install_pkg xclip
    install_pkg feh
    install_pkg zathura
    install_pkg gnome-disk-utility
    # yes '' | yay -S barrier
    # install_pkg conky
    # install_pkg plank

    # FILE MANAGER
    if [ "$DISTRO" = "void" ]; then
        install_pkg Thunar
    else
        install_pkg thunar
    fi
    install_pkg nautilus
    # install_pkg gvfs
    # install_pkg gvfs-smb
    # install_pkg pcmanfm

    # CONFIGURE XINITRC TO RUN i3
    config_xinitrc
}
#   __    __   ____ _   _ ___  __
#  / /   / /  / ___| | | |_ _| \ \
# / /   / /  | |  _| | | || |   \ \
# \ \  / /   | |_| | |_| || |   / /
#  \_\/_/     \____|\___/|___| /_/

#   __   ____ ___  ____  _____  __
#  / /  / ___/ _ \|  _ \| ____| \ \
# / /  | |  | | | | | | |  _|    \ \
# \ \  | |__| |_| | |_| | |___   / /
#  \_\  \____\___/|____/|_____| /_/

install_code() {
    # TOOLCHAINS AND COMPILERS
    case "$DISTRO" in
    "arch")
        install_pkg jdk-openjdk
        install_pkg java-openjfx
        install_pkg go
        ;;
    "debian")
        install_pkg default-jdk
        install_pkg openjfx
        install_pkg golang
        ;;
    esac
    install_pkg nodejs
    if [ ! "$DISTRO" = "void" ]; then
        install_pkg npm
    fi
    install_pkg python
    install_pkg python-pip
    if [ ! -x "$(command -v rustup)" ]; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs >/tmp/rustup.sh
        yes '' | bash /tmp/rustup.sh
        rm /tmp/rustup.sh
    fi

    # PROGRAMMING UTILITES
    install_pkg valgrind
    install_pkg shellcheck
    # yes '' | yay -S postman
    # yes '' | yay -S mongodb-compass

    # IDE'S AND EDITORS
    case "$DISTRO" in
    "arch")
        install_pkg_extra vscodium-bin
        install_pkg_extra jetbrains-toolbox
        ;;
    "debian")
        install_pkg_extra code-insiders
        ;;
    "void")
        install_pkg vscode
        ;;
    esac

    # DATABASES
    # yes '' | yay -S mongodb-bin
    case "$DISTRO" in
    "arch")
        # install_pkg mariadb
        ;;
    "debian")
        # install_pkg mariadb-client
        # install_pkg mariadb-server
        ;;

    "void")
        # install_pkg mariadb
        # install_pkg mariadb-client
        ;;

    esac

}

#   __    __   ____ ___  ____  _____  __
#  / /   / /  / ___/ _ \|  _ \| ____| \ \
# / /   / /  | |  | | | | | | |  _|    \ \
# \ \  / /   | |__| |_| | |_| | |___   / /
#  \_\/_/     \____\___/|____/|_____| /_/

if [ "$(id -u)" -eq 0 ]; then
    echo "\e[31mDo not run as root\e[0m"
    exit 1
fi

# Get distro info and setup package manager variable
config_package_manager

# Install git if not installed
if [ ! -x "$(command -v git)" ]; then
    install_pkg git
fi

# Setup config and clone repos
config_dotfiles

# Add defaults like editor, browser and path to profile
config_profile

# Install all packages specified for this script
install_packages

read -r -p "Do you want to install i3-gaps (Y/N)?: " CHOICE

if [ -z "$CHOICE" ] || [ "$CHOICE" = "Y" ] || [ "$CHOICE" = "y" ]; then
    install_gui
fi

read -r -p "Do you want to install coding toolchains (Y/N)?: " CHOICE

if [ -z "$CHOICE" ] || [ "$CHOICE" = "Y" ] || [ "$CHOICE" = "y" ]; then
    install_code
fi
