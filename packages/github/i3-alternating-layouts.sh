#!/usr/bin/env sh

source "$(pwd)/utils.sh"

install_i3_alternating_layouts() {
    if is_installed "alternating_layouts"; then 
        _echo_yellow "'alternating_layouts' already installed\n"
        return 0
    fi
    _echo_green "installing i3-alternating-layouts\n"
    python -m pip install i3-py
    TMP_DIR=/tmp/i3-alternating-layout
    git -C /tmp clone "https://github.com/olemartinorg/i3-alternating-layout" && 
        cp "$TMP_DIR/alternating_layouts.py" "/usr/bin/alternating_layouts"
		rm -rf "$TMP_DIR"
}
