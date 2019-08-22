#!/bin/bash

if [ $EUID != 0 ]; then
    echo 'Script must be run as root, trying sudo...'
    sudo "$0" "$@"
    exit $?
fi

# Setup mount to /c/ instead of /mnt/c/
cat <<EOF > /etc/wsl.conf
[automount]
root = /
options = "metadata"
EOF

# Change homedir to windows user folder
HOME_DIR=~
USERNAME=$(whoami) # we assume here that windows and linux username match
sed -i "s,$HOME_DIR,/c/Users/$USERNAME,g" /etc/passwd

# Update all
sudo apt-get update
sudo apt-get dist-upgrade

# Install nessacry packages
sudo apt-get install -y zsh git tmux python3-venv

# Install ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Setup zsh on launch
chsh -s $(which zsh)

# Setup nice dir colors in WSL
mkdir -p term-config/dircolors-solarized
git clone https://github.com/seebi/dircolors-solarized term-config/dircolors-solarized

# Setup dotfiles
git clone --bare git@github.com:wilmardo/dotfiles.git $HOME/.cfg

source $HOME/.zshrc

# Setup docker client only
# https://docs.docker.com/install/linux/docker-ce/binaries/
curl -sL https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz | \
sudo tar -zvxC "/usr/local/bin" --strip-components=1 docker/docker

# Install docker-compose (https://github.com/docker/compose/releases/)
curl -sL https://github.com/docker/compose/releases/download/1.24.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Instal kind https://github.com/kubernetes-sigs/kind/releases
curl -Lo kind https://github.com/kubernetes-sigs/kind/releases/download/v0.4.0/kind-linux-amd64 && chmod +x kind && sudo mv kind /usr/local/bin/

#TODO: fix this
# Install hugo https://github.com/gohugoio/hugo/releases
curl -sL https://github.com/gohugoio/hugo/releases/download/v0.55.6/hugo_extended_0.55.6_Linux-64bit.tar.gz | \
sudo tar -zvxC "/usr/local/bin" hugo

# Install helm
curl -sL https://get.helm.sh/helm-v2.14.2-linux-amd64.tar.gz | \
sudo tar -zvxC "/usr/local/bin" --strip-components=1 linux-amd64/helm
