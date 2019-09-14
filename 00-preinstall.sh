#!/bin/sh

if [ "$(id -u)" -eq 0 ]; then
    echo "Do not run as root"; exit 1;
fi

sudo pacman -S git || exit 1

mkdir -p "$HOME"/Downloads

git -C "$HOME"/Downloads clone https://aur.archlinux.org/yay.git && "$HOME"/Downloads/yay && yes | makepkg -sir

mkdir -p "$HOME"/Code/sh

git -C "$HOME"/Code/sh clone https://github.com/7aske/utils-sh
ln -sf "$HOME"/.scripts "$HOME"/sh/utils-sh
git -C "$HOME"/Code/sh clone https://github.com/7aske/bashrc
git -C "$HOME"/Code/sh clone https://github.com/7aske/dotfiles
git -C "$HOME"/Code/sh/dotfiles checkout nik-mjr
git -C "$HOME"/Code/sh/dotfiles checkout pull

bash "$HOME"/Code/sh/bashrc/update_bashrc.sh &

ln -sf "$HOME"/Code/sh/dotfiles/conky/.conkyrc "$HOME"/.conkyrc

cp -rf "$HOME"/Code/sh/dotfiles/xfce4 "$HOME"/.config/
cp -rf "$HOME"/Code/sh/dotfiles/albert "$HOME"/.config/
cp -rf "$HOME"/Code/sh/dotfiles/VSCodium "$HOME"/.config/
ln -sf "$HOME"/Code/sh/dotfiles/neofetch "$HOME"/.config/neofetch
cp -rf "$HOME"/Code/sh/dotfiles/kitty "$HOME"/.config/
ln -sf "$HOME"/Code/sh/dotfiles/vim/.vim "$HOME"/.vim/
ln -sf "$HOME"/Code/sh/dotfiles/vim/.vimrc "$HOME"/.vimrc

ln -sf "$HOME"/Code/sh/dotfiles/tmux/.tmux.conf "$HOME"/.tmux.conf
