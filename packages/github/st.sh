#!/usr/bin/env bash

source "$(pwd)/utils.sh"

function install_st(){
    if is_installed "st"; then 
        _echo_yellow "'st' already installed\n"
        return 0
    fi

    _echo_green "installing st\n"
    TMP_DIR="/tmp/st"
    git -C /tmp clone "https://github.com/7aske/st" && 
        cd "$TMP_DIR" &&
        make &&
        make install
    cd -
    rm -rf "$TMP_DIR"
}
