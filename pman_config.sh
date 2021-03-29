#!/usr/bin/env sh

source "$(pwd)/utils.sh"

PMAN="pacman"
PMAN_CMD="$PMAN --needed --noconfirm -Sq"
PMAN_SEARCH_CMD="$PMAN -Ssq"
PMAN_CHECK_CMD="$PMAN -Qq"

PMAN_EXTRA="yay"
PMAN_CMD_EXTRA="$PMAN_EXTRA --needed --noconfirm -Sq"
PMAN_SEARCH_CMD_EXTRA="$PMAN_EXTRA -Ssq"
PMAN_CHECK_CMD_EXTRA="$PMAN_EXTRA -Qq"

check_pkg() { eval "$PMAN_CHECK_CMD $1 2>/dev/null"; }

install_pkg() {
  [ -z "$PMAN_CMD" ] && _echo_red "$prog: 'PMAN_CMD' not defined\n" && exit 1
  [ -z "$1" ] && _echo_red "$prog: package not specified\n" && return 1

  _echo_green "$prog: installing package '$1'\n"

  if [ $UID -eq 0 ]; then
    eval "$PMAN_CMD $1"
  else
    eval "sudo $PMAN_CMD $1"
  fi
}

install_pkgs_extra(){
  [ -z "$1" ] && return 1 # script root
  [ -z "$2" ] && return 1 # user

  if [ $UID -eq 0 ]; then
	  grep -vxf <(sudo -u $2 $PMAN_CHECK_CMD_EXTRA) $1 | sudo -u "$2" $PMAN_CMD_EXTRA -
  else
	  grep -vxf <(eval $PMAN_CHECK_CMD_EXTRA) $1 | eval $PMAN_CMD_EXTRA -
  fi
}

install_pkgs() {
  [ -z "$1" ] && return 1 # package list file
    
  if [ $UID -eq 0 ]; then
    eval "$PMAN_CMD - < $1"
  else
    eval "sudo $PMAN_CMD - < $1"
  fi
}

configure_pman(){
	eval $PMAN -Syy
	eval $PMAN_CMD pacman-contrib
	curl "https://archlinux.org/mirrorlist/all/" > /etc/pacman.d/mirrorlist
	sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist
	if [ ! -e /etc/pacman.d/mirrorlist.backup ]; then
		cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
		rankmirrors -n 10 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
	fi
	sed -i 's/^#Color/Color/' /etc/pacman.conf
	pacman -Syy
}

install_pman_extra(){
  # since you can't run 'makepkg' as root this is the
  # only way I can think of installing a aur wrapper
  [ -z "$1" ] && _echo_red "$0 no user specified\n"
  if is_installed "yay"; then 
    _echo_yellow "'yay' already installed\n"
    return 0
  fi

  TMP_DIR="/tmp/yay"
  export GOPATH="$TMP_DIR/src"
  mkdir "$GOPATH"
  git -C "/tmp" clone "https://aur.archlinux.org/yay"
  chown -R "$1:$1" "$TMP_DIR"
  cd "$TMP_DIR" &&
    sudo -u "$1" makepkg --noconfirm --needed -sic
  cd -
  rm -rf "$TMP_DIR"
  unset GOPATH
}

update_pkgs(){
	pacman -Sqyyu --noconfirm
}

update_pkglist(){
	pacman -Sqyy --noconfirm
}
