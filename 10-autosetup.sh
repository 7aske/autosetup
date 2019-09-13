if [[ $EUID -ne 0 ]]; then
    echo "Run as root"
    exit 1
fi

user=$SUDO_USER
home=$(getent passwd $user | cut -d: -f6)

yes | pacman -Syyu
yes | pacman -S git --needed

mkdir -p $home/Code/sh

git -C $home/Code/sh clone https://github.com/7aske/utils-sh
ln -sf $home/.scripts $home/sh/utils-sh
git -C $home/Code/sh clone https://github.com/7aske/bashrc
git -C $home/Code/sh clone https://github.com/7aske/dotfiles
git -C $home/Code/sh/dotfiles checkout nik-mjr
git -C $home/Code/sh/dotfiles checkout pull

bash $home/Code/sh/bashrc/update_bashrc.sh &

mkdir -p $home/Downloads

sed -i "s/^#Color/Color" /etc/pacman.conf

yes | pacman -S ttf-ubuntu-font-family --needed
yes | pacman -S ttf-fira-code --needed
yes | pacman -S noto-fonts --needed
yes | pacman -S ttf-liberation --needed

ln -sf $home/Code/sh/dotfiles/conky/.conkyrc $home/.conkyrc
ln -sf $home/Code/sh/dotfiles/conky/.conkycolors $home/.conkycolors

cp -rf $home/Code/sh/dotfiles/xfce4 $home/.config/
cp -rf $home/Code/sh/dotfiles/VSCodium $home/.config/
cp -rf $home/Code/sh/dotfiles/neofetch $home/.config/
cp -rf $home/Code/sh/dotfiles/kitty $home/.config/

cp -rf $home/Code/sh/dotfiles/vim/.vim $home/
cp -rf $home/Code/sh/dotfiles/vim/.vimrc $home/

cp -rf $home/Code/sh/dotfiles/tmux/.tmux.conf $home/

yes | pacman -S vim --needed
yes | pacman -S neofetch --needed
yes | pacman -S tree --needed
yes | pacman -S conky --needed
yes | pacman -S curl --needed
yes | pacman -S wget --needed
yes | pacman -S plank --needed
yes | pacman -S python-pywal --needed
yes | pacman -S xclip --needed
yes | pacman -S samba --needed
yes | pacman -S nautilus --needed

yes | pacman -S papirus-icon-theme --needed
yes | pacman -Rcns manjaro-hello

curl https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-folders/master/install.sh | sh

