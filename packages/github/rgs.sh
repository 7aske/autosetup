#!/usr/bin/env bash

source "$(pwd)/utils.sh"

function install_rgs(){
	# $1 USER
    if is_installed "cgs"; then 
        _echo_yellow "'cgs' already installed\n"
        return 0
    fi
	
	rustup toolchain install stable
	rustup default stable
    _echo_green "installing rgs\n"
    TMP_DIR="/tmp/rgs"
	git -C /tmp clone "https://github.com/7aske/rgs" && 
		chown -R "$1:$1" "$TMP_DIR" &&
		cd "$TMP_DIR" &&
		make release &&
		make install
    cd -
    rm -rf "$TMP_DIR"
}
