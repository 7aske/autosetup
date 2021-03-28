#!/usr/bin/env bash

source "$(pwd)/utils.sh"

function install_rgs(){
    if is_installed "cgs"; then 
        _echo_yellow "'cgs' already installed\n"
        return 0
    fi
	
	su -u $USER rustup toolchain install stable
    _echo_green "installing rgs\n"
    TMP_DIR="/tmp/st"
    git -C /tmp clone "https://github.com/7aske/rgs" && 
        cd "$TMP_DIR" &&
        make install
    cd -
    rm -rf "$TMP_DIR"
}
