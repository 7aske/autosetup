#!/usr/bin/env bash

declare distro
declare pman
declare pman_extra
declare pman_cmd
declare pman_search_cmd
declare pman_cmd_extra
declare pman_search_cmd_extra
declare pman_check_cmd

prereq=(git sed grep curl)

prog="$(basename "$0")"

declare -a arch_packages=(
    "neovim"
    "net-tools"
    "nmap"
    "curl"
    "wget"
    "vsftpd"
    "rxvt-unicode"
    "xterm"
    "neofetch"
    "tree"
    "bat"
    "screen"
    "tmux"
    "rsync"
    "htop"
    "sysstat"
    "cronie"
    "openssh"
    "networkmanager"
    "python"
    "python-pip"
    "python-virtualenv"
    "ranger"
)
declare -a debian_packages=(
    "neovim"
    "net-tools"
    "nmap"
    "curl"
    "wget"
    "vsftpd"
    "rxvt-unicode"
    "xterm"
    "neofetch"
    "tree"
    "bat"
    "screen"
    "tmux"
    "rsync"
    "htop"
    "sysstat"
    "cron"
    "openssh-client"
    "openssh-server"
    "network-manager"
    "python3"
    "python3-pip"
    "python3-virtualenv"
    "ranger"
)

# pamac-aur
declare -a arch_gui_packages=(
    "xorg"
    "xorg-xinit"
    "lightdm-gtk-greeter"
    "lightdm-gtk-greeter-settings"
    "i3-gaps"
    "chromium"
    "python-pywal"
    "sxiv"
    "network-manager-applet"
    "kitty"
    "tigervnc"
    "clipmenu"
    "imagemagick"
    "i3blocks"
    "i3lock"
    "i3status"
    "dunst"
    "scrot"
    "rofi"
    "dmenu"
    "fzf"
    "xautolock"
    "compton"
    "xfce4-power-manager"
    "playerctl"
    "pulseaudio"
    "pavucontrol"
    "pasystray"
    "lxappearance"
    "baobab"
    # "pandoc"
    "xclip"
    "feh"
    "zathura"
    "gnome-disk-utility"
    "nautilus"
)
# pywal
declare -a debian_gui_packages=(
    "xorg"
    "xorg-xinit"
    "lightdm-gtk-greeter"
    "lightdm-gtk-greeter-settings"
    "i3"
    "chromium"
    "tigervnc-viewer"
    "kitty"
    "network-manager-gnome"
    "imagemagick"
    "sxiv."
    "i3blocks"
    "i3lock"
    "i3status"
    "dunst"
    "scrot"
    "rofi"
    "dmenu"
    "fzf"
    "xautolock"
    "compton"
    "xfce4-power-manager"
    "playerctl"
    "pulseaudio"
    "pavucontrol"
    "pasystray"
    "lxappearance"
    "baobab"
    # "pandoc"
    "xclip"
    "feh"
    "zathura"
    "gnome-disk-utility"
    "nautilus"
)

#FONTS
# case "$DISTRO" in
# "arch")
#     # FONTS
#     install_pkg ttf-ubuntu-font-family
#     install_pkg ttf-fira-code
#     install_pkg ttf-liberation
#     install_pkg noto-fonts
#     install_pkg noto-fonts-emoji
#     install_pkg arc-gtk-theme
#     install_pkg_extra xcursor-breeze
#     install_pkg clipmenu
#     install_pkg clipnotify
#     ;;
# "void")
#     # FONTS
#     install_pkg ttf-ubuntu-font-family
#     install_pkg font-firacode
#     install_pkg liberation-fonts-ttf
#     install_pkg noto-fonts-ttf
#     install_pkg noto-fonts-emoji

#     install_pkg arc-theme
#     install_pkg breeze-cursor
#     ;;
# "debian")
#     install_pkg fonts-firacode
#     install_pkg fonts-ubuntu
#     install_pkg fonts-liberation
#     install_pkg fonts-noto
#     install_pkg fonts-noto-color-emoji
#     install_pkg arc-theme
#     install_pkg breeze-cursor-theme
#     ;;
# esac

# set package manager command depending on OS distribution
configure_pman() {
    if [ -f "/etc/os-release" ]; then
        source "/etc/os-release"
    else
        echo -e "\e[1;31m$prog: unable to get os distribution\e[0m"
        exit 1
    fi

    if [ -n "$ID_LIKE" ]; then
        case $ID_LIKE in
        "arch")
            distro="$ID_LIKE"
            pman="pacman"
            pman_extra="yay"
            ;;
        "debian")
            distro="$ID_LIKE"
            pman="apt"
            pman_extra="snap"
            ;;
        esac
    fi
    if [ -n "$ID" ]; then
        case $ID in
        "arch")
            distro="$ID"
            pman="pacman"
            pman_extra="yay"
            ;;
        "debian")
            distro="$ID"
            pman="apt"
            pman_extra="snap"
            ;;
        esac
    fi

    case "$distro" in
    "debian")
        pman_cmd="$pman -qq install"
        pman_search_cmd="$pman search"
        pman_check_cmd="dpkg --get-selections | grep -q"
        pman_search_cmd_extra="$pman_extra search"
        pman_cmd_extra="$pman_extra install --classic"
        ;;
    "arch")
        pman_cmd="$pman --noconfirm -Sq"
        pman_search_cmd="$pman -Ssq"
        pman_search_cmd_extra="$pman_extra -Ssq"
        pman_check_cmd="$pman -Qq"
        pman_cmd_extra="$pman_extra -Sq"
        ;;
    *)
        echo -e "\e[1;31m$prog: unable to get os distribution\e[0m"
        exit 1
        ;;
    esac
}

check_pkg() {
    case "$distro" in
    "arch")
        eval "$pman_check_cmd $1 2>/dev/null"
        ;;
    "debian")
        eval "$pman_check_cmd $1 2>/dev/null"
        ;;
    esac
}

install_dotfile() {
    [ ! $# -eq 2 ] && return 2
    [ ! -e "$1" ] && return 2
    echo -e "\e[32m$prog: installing '$(basename "$1")' config\e[0m"
    if [ -e "$2" ] && [ ! -L "$2" ]; then
        mv "$2" "$2.bak"
        ln -s "$1" "$2"
    elif [ ! -e "$2" ]; then
        ln -s "$1" "$2"
    fi
}

configure_dotfiles() {
    echo -e "\e[32m$prog: installing dotfiles\e[0m"
    dotfiles_dir="$HOME/Code/sh/dotfiles"
    config_dir="$HOME/.config"
    [ ! -e "$HOME/Code/sh" ] && mkdir -p "$HOME/Code/sh"
    [ ! -e "$config_dir" ] && mkdir -p "$config_dir"

    # Clone all personal repositories
    [ ! -e "$HOME/Code/sh/utils-sh" ] && git -C "$HOME/Code/sh" clone "https://github.com/7aske/utils-sh"
    [ ! -e "$HOME/Code/sh/scripts" ] && git -C "$HOME/Code/sh" clone "https://github.com/7aske/scripts"
    [ ! -e "$HOME/Code/sh/bashrc" ] && git -C "$HOME/Code/sh" clone "https://github.com/7aske/bashrc"
    [ ! -e "$HOME/Code/sh/dotfiles" ] && git -C "$HOME/Code/sh" clone "https://github.com/7aske/dotfiles"

    # Set ~/.bashrc to source ~/Code/sh/bashrc/.bashrc
    bash "$HOME/Code/sh/bashrc/bashrc.sh"

    # Setup links to respective dotfiles into .config
    mkdir -p "$config_dir/VSCodium/User"
    mkdir -p "$config_dir/VSCode/User"

    install_dotfile "$dotfiles_dir/VSCodium/User/settings.json" "$config_dir/VSCodium/User/settings.json"
    install_dotfile "$dotfiles_dir/VSCode/User/settings.json" "$config_dir/VSCode/User/settings.json"
    install_dotfile "$dotfiles_dir/VSCodium/User/keybindings.json" "$config_dir/VSCodium/User/keybindings.json"
    install_dotfile "$dotfiles_dir/VSCode/User/keybindings.json" "$config_dir/VSCode/User/keybindings.json"
    install_dotfile "$dotfiles_dir/albert" "$config_dir/albert"
    install_dotfile "$dotfiles_dir/neofetch" "$config_dir/neofetch"
    install_dotfile "$dotfiles_dir/kitty" "$config_dir/kitty"
    install_dotfile "$dotfiles_dir/nvim" "$config_dir/nvim"
    install_dotfile "$dotfiles_dir/rofi" "$config_dir/rofi"
    install_dotfile "$dotfiles_dir/wal" "$config_dir/wal"
    install_dotfile "$dotfiles_dir/tmux" "$config_dir/tmux"
    install_dotfile "$dotfiles_dir/i3" "$config_dir/i3"
    install_dotfile "$dotfiles_dir/i3blocks" "$config_dir/i3blocks"
    install_dotfile "$dotfiles_dir/i3status" "$config_dir/i3status"
    install_dotfile "$dotfiles_dir/dunst" "$config_dir/dunst"
    install_dotfile "$dotfiles_dir/conky" "$config_dir/conky"

    [ ! -e "$HOME/.local/bin" ] && mkdir -p "$HOME/.local/bin"
    cd "$HOME/Code/sh/scripts" && make
}

configure_profile() {
    echo -e "\e[32m$prog: configuring .profile\e[0m"
    profile="$HOME/.profile"
    profile_source="[ -f \"\$HOME/Code/sh/dotfiles/.profile\" ] && . \"\$HOME/Code/sh/dotfiles/.profile\""

    if [ ! -e "$profile" ]; then
        echo "$home_profile_source" >"$profile"
    else
        if ! grep -q "$home_profile_source" "$profile"; then echo "$home_profile_source" >>"$profile"; fi
    fi
}

configure_xprofile() {
    echo -e "\e[32m$prog: configuring .xprofile\e[0m"
    xprofile="$HOME/.xprofile"
    home_profile_source="[ -f \"\$HOME/.profile\" ] && . \"\$HOME/.profile\""
    profile_source="[ -f \"\$HOME/Code/sh/dotfiles/.profile\" ] && . \"\$HOME/Code/sh/dotfiles/.profile\""
    xprofile_source="[ -f \"\$HOME/Code/sh/dotfiles/.xprofile\" ] && . \"\$HOME/Code/sh/dotfiles/.xprofile\""

    if [ ! -e "$profile" ]; then
        echo -e "$home_profile_source\n$profile_source\n$xprofile_source" >"$profile"
    else
        if ! grep -q "$home_profile_source" "$xprofile"; then echo "$home_profile_source" >>"$xprofile"; fi
        if ! grep -q "$profile_source" "$xprofile"; then echo "$profile_source" >>"$xprofile"; fi
        if ! grep -q "$xprofile_source" "$xprofile"; then echo "$xprofile_source" >>"$xprofile"; fi
    fi
}
configure_xinitrc() {
    echo -e "\e[32m$prog: configuring .xinitrc\e[0m"
    xinitrc="
#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

userresources=\$HOME/.Xresources
usermodmap=\$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

DEFAULT_SESSION='i3 --shmlog-size 0'

# merge in defaults and keymaps
if [ -f \"\$sysresources\" ]; then
    xrdb -merge \"\$sysresources\"
fi

if [ -f \"\$sysmodmap\" ]; then
    xmodmap \"\$sysmodmap\"
fi

if [ -f \"\$userresources\" ]; then
    xrdb -merge \"\$userresources\"
fi

if [ -f \"\$usermodmap\" ]; then
    xmodmap \"\$usermodmap\"
fi

get_session(){
	local dbus_args=(--sh-syntax --exit-with-session)
	case \$1 in
		awesome) dbus_args+=(awesome) ;;
		bspwm) dbus_args+=(bspwm-session) ;;
		budgie) dbus_args+=(budgie-desktop) ;;
		cinnamon) dbus_args+=(cinnamon-session) ;;
		deepin) dbus_args+=(startdde) ;;
		enlightenment) dbus_args+=(enlightenment_start) ;;
		fluxbox) dbus_args+=(startfluxbox) ;;
		gnome) dbus_args+=(gnome-session) ;;
		i3|i3wm) dbus_args+=(i3 --shmlog-size 0) ;;
		jwm) dbus_args+=(jwm) ;;
		kde) dbus_args+=(startkde) ;;
		lxde) dbus_args+=(startlxde) ;;
		lxqt) dbus_args+=(lxqt-session) ;;
		mate) dbus_args+=(mate-session) ;;
		xfce) dbus_args+=(xfce4-session) ;;
		openbox) dbus_args+=(openbox-session) ;;
		*) dbus_args+=(\$DEFAULT_SESSION) ;;
	esac

	echo \"dbus-launch \${dbus_args[*]}\"
}

exec \$(get_session)
"

    echo "$xinitrc" >~/.xinitrc

    if [ -e "$HOME/.Xresources" ]; then
        mv "$HOME/.Xresources" "$HOME/.Xresources.bak"
        cp "$HOME/Code/sh/dotfiles/.Xresources" "$HOME/"
    else
        cp "$HOME/Code/sh/dotfiles/.Xresources" "$HOME/"
    fi
}

is_installed() {
    test -n "$(command -v "$1")" # || check_pkg "$1" >/dev/null 2>&1
}

install_pkg() {
    [ -z "$pman_cmd" ] && echo -e "\e[31m$prog: 'pman_cmd' not defined\e[0m" && exit 1
    [ -z "$1" ] && echo "\e[31m$prog: package not specified\e[0m" && return 1
    echo -e "\e[32m$prog: installing package '$1'\e[0m"
    if [ $UID -eq 0 ]; then
        eval "$pman_cmd $1"
    else
        eval "sudo $pman_cmd $1"
    fi
}

install_pkgs() {
    [ -z "$1" ] && return
    # shellcheck disable=SC1087
    for pkg in $(eval "echo \${$1[@]}"); do
        if ! is_installed "$pkg"; then
            install_pkg "$pkg" && echo -e "\e[32m$prog: installed package '$pkg'\e[0m" || echo -e "\e[31m$prog: failed installing package '$pkg'\e[0m"
        else
            echo -e "\e[33m$prog: package '$pkg' already installed\e[0m"
        fi
    done
}

verify_prereq() {
    for p in "${prereq[@]}"; do
        is_installed "$p" || install_pkg "$p" || echo -e "\e[31m$prog: failed installing package '$p'\e[0m"
    done
}
configure_pman

# verify_prereq
# configure_dotfiles
# configure_profile
# configure_xprofile
# configure_xinitrc

read -r -p "Do you want to install packages (y\n)? " answ

case "$answ" in

"y"|"Y") install_pkgs "${distro}_packages" ;;

esac

read -r -p "Do you want to install a GUI(i3) (y\n)? " answ

case "$answ" in

"y"|"Y") install_pkgs "${distro}_gui_packages" ;;

esac