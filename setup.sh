#!/usr/bin/env bash

filename="$(basename "$0")"
prog="${filename##*.}"

ROOT_DIR="${ROOT_DIR:-"$(pwd)"}"

source "$ROOT_DIR/utils.sh"
source "$ROOT_DIR/pman_config.sh"
source "$ROOT_DIR/packages/github/neovim.sh"
source "$ROOT_DIR/packages/github/i3-alternating-layouts.sh"
source "$ROOT_DIR/packages/github/st.sh"
source "$ROOT_DIR/packages/github/rgs.sh"

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

export CODE="$USERHOME/.local/src"

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
	cp -r $ROOT_DIR/config/* "$USERHOME/.config/"
}

configure_xinitrc() {
  _echo_green "$prog: configuring .xinitrc\n"
  cp "$ROOT_DIR/xinitrc" "$USERHOME/.xinitrc"
  chown "$USER:$USER" "$USERHOME/.xinitrc"
  chmod 775 "$USERHOME/.xinitrc"
  chmod 775 "$USERHOME/.xprofile"
}

configure_misc(){
  cp $ROOT_DIR/locale.conf /etc/locale.conf
  localectl set-locale LANG=en_US.UTF-8
  [ -x '/usr/bin/zsh' ] && usermod -s /usr/bin/zsh "$USER"
  [ -x '/usr/bin/zsh' ] && usermod -s /usr/bin/zsh "root"
  systemctl enable sshd
  systemctl enable gdm
  systemctl enable cronie
  systemctl enable NetworkManager
  sudo -u "$USER" mkdir -p "$USERHOME/"{Downloads,Documents,Music,Pictures}
  sudo -u "$USER" mkdir -p "$USERHOME/Pictures/wallpaper"
}

if [ -f "/etc/os-release" ]; then
  source "/etc/os-release"
  DISTRO="${ID_LIKE:-"$ID"}"
  [ "$DISTRO" != "arch" ] && _echo_red "Only Arch linux and its distributions are supported\n"
else
  _echo_red "$prog: unable to get os distribution\n"; exit 1
fi

configure_pman
install_pman_extra
update_pkglist
update_pkgs

for p in "${prereq[@]}"; do
  if ! is_installed "$p"; then
	  install_pkg "$p" || ( _echo_red "$prog: failed installing package '$p'" && exit 1)
  fi

done

configure_dotfiles "root"  "/root/.local/src" "/root" 
configure_dotfiles "$USER" "$CODE"            "$USERHOME" 
configure_xinitrc

install_pkgs "${ROOT_DIR}/packages/${DISTRO}_packages"
install_neovim
install_pkgs "${ROOT_DIR}/packages/${DISTRO}_gui_packages"
install_st
install_i3_alternating_layouts
install_rgs "$USER"
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | gpg --import -
install_pkgs_extra "${ROOT_DIR}/packages/${DISTRO}_extra_packages" "$USER"
install_pkgs_extra "${ROOT_DIR}/packages/${DISTRO}_font_packages"  "$USER"

configure_misc

