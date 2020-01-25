## Description

Automated script to install all my preferred applications and copy over configurations and dotfiles from other repositories to a blank Arch based installation.

## Scripts

`autoinstall.sh` installs everything that doesn't require a GUI to run and also creates symlinks for all required config and dotfiles.

`autoinstallgui.sh` installs i3 window manager and rest of the programs that require GUI to run, like a web browser and file manager.

`autoinstallcode.sh` installs programming related stuff like different languages and their toolchains, IDE's, code editors

`autoinstallvbox.sh` installs required VirtualBox packages if the installation is running in a VM