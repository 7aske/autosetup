#!/usr/bin/env sh

source "$(pwd)/utils.sh"

function install_neovim(){
    if is_installed "nvim"; then 
        _echo_yellow "'nvim' already installed\n"
        return 0
    fi

    _echo_green "installing neovim\n"
    TMP_DIR="/tmp/neovim"
    git -C /tmp clone "https://github.com/neovim/neovim" && 
        cd "$TMP_DIR/" &&
        make &&
        make install
    cd -
    rm -rf "$TMP_DIR"
    /usr/local/bin/nvim +"PlugInstall" +qa
}
