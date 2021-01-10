#!/usr/bin/env bash

filename="$(basename "$0")"
prog="${filename##*.}"

source "$(pwd)/packages.sh"
source "$(pwd)/utils.sh"
source "$(pwd)/pman_config.sh"
source "$(pwd)/packages/github/neovim.sh"
source "$(pwd)/packages/github/i3-alternating-layouts.sh"
source "$(pwd)/packages/github/st.sh"

if [ ! $UID -eq 0 ]; then
  _echo_red "$prog: run as root\n" && exit 2
fi


function _usage(){
  echo "usage: $prog [-u user]"
}

# commands required to complete the setup
prereq=(git sed grep curl pacman)

USER="root"
USERHOME="/$USER"
while getopts "u:h" arg; do
  case $arg in
    h) 
      _usage && exit ;;
    u) 
      USER="$OPTARG"
      USERHOME="/home/$OPTARG"
      ;;
  esac
done
shift $((OPTIND-1))

CODE="$USERHOME/.local/src"

configure_dotfiles() {
  # $1 USER
  # $2 CODE
  # $3 USERHOME
  _echo_green "$prog: installing dotfiles\n"

  [ ! -e "$2/sh" ] && mkdir -p "$2/sh"
  [ ! -e "$3/.config" ] && mkdir -p "$3/.config"
  [ ! -e "$3/.local/bin" ] && mkdir -p "$3/.local/bin"
  chown -R "$1:$1" "$3/.config"
  chown -R "$1:$1" "$3/.local"

    # Clone all personal repositories
    [ ! -e "$2/sh/scripts" ] && sudo -u "$1" git -C "$2/sh" clone "https://github.com/7aske/scripts"
    [ ! -e "$2/sh/dotfiles" ] && sudo -u "$1" git -C "$2/sh" clone "https://github.com/7aske/dotfiles"

    cd "$2/sh/dotfiles" && sudo -u "$1" make; cd -
    cd "$2/sh/scripts" && sudo -u "$1" make; cd -
}

configure_xinitrc() {
  _echo_green "$prog: configuring .xinitrc\n"
  cp "$(pwd)/xinitrc" "$USERHOME/.xinitrc"
  chown "$USER:$USER" "$USERHOME/.xinitrc"
  chmod 775 "$USERHOME/.xinitrc"
  chmod 775 "$USERHOME/.xprofile"
}

configure_misc(){
  cp $(pwd)/locale.conf /etc/locale.conf
  localectl set-locale LANG=en_US.UTF-8
  usermod -s /usr/bin/zsh "$USER"
  usermod -s /usr/bin/zsh "root"
  systemctl enable sshd
  systemctl enable gdm
  systemctl enable cronie
  systemctl enable NetworkManager
  sudo -u "$USER" mkdir "$USERHOME/"{Downloads,Documents,Music,Pictures}
  sudo -u "$USER" mkdir "$USERHOME/Pictures/wallpaper"
  #sudo -u "$USER" curl -o "$USERHOME/Pictures/wallpaper/nord-peeks.png" "https://cdn.7aske.com/wall/nord-peeks.png"
  sudo -u "$USER" rustup toolchain install stable
  sudo -u "$USER" rustup default stable
  yes | sudo -u "$USER" yay -S libxft-bgra-git
}

if [ -f "/etc/os-release" ]; then
  source "/etc/os-release"
  DISTRO="${ID_LIKE:-"$ID"}"
  [ "$DISTRO" != "arch" ] && _echo_red "Only Arch linux and its distributions are supported\n"
else
  _echo_red "$prog: unable to get os distribution\n"; exit 1
fi

if ! id "$USER" 2>&1>/dev/null; then
  _echo_red "$prog: user '$USER' does not exist\n"
fi

configure_pman

for p in "${prereq[@]}"; do
  if ! is_installed "$p"; then
    install_pkg "$p" || _echo_red "$prog: failed installing package '$p'"
  fi
done

configure_dotfiles "root"  "/root/.local/src" "/root" 
configure_dotfiles "$USER" "$CODE"            "$USERHOME" 
configure_xinitrc

update_pkglist
install_pkgs "${DISTRO}_packages"
install_neovim
install_pkgs "${DISTRO}_gui_packages"
install_pkgs "${DISTRO}_font_packages"
install_st
install_i3_alternating_layouts
update_pkgs
install_pman_extra "$USER"
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | gpg --import -
install_pkgs_extra "${DISTRO}_extra_packages" "$USER"

configure_misc

