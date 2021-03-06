#!/bin/bash

# fail on all the things
set -euo pipefail

# Use to override lsb-release
UBUNTU_VERSION=bionic

if [ $EUID != 0 ]; then
    echo 'Script must be run as root, trying sudo...'
    sudo "$0" "$@"
    exit $?
fi

# Setup mount to /c/ instead of /mnt/c/
cat <<EOF > /etc/wsl.conf
[network]
generateResolvConf = false
EOF

echo "nameserver 9.9.9.9" > /etc/resolv.conf

# Update all
sudo apt-get update
sudo apt-get dist-upgrade

# Install nessacry packages
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    zsh \
    git \
    tmux \
    build-essential
    
# Install python3.8 from deadsnakes
# sudo add-apt-repository "deb http://ppa.launchpad.net/deadsnakes/ppa/ubuntu ${UBUNTU_VERSION} main"
sudo apt-get install -y \
    python3.8-dev \
    python3.8-venv

# Install ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Setup nice dir colors in WSL
if uname -r | grep -i -q Microsoft; then
    mkdir -p term-config/dircolors-solarized
    git clone https://github.com/seebi/dircolors-solarized term-config/dircolors-solarized
fi

# Setup docker
# https://docs.docker.com/install/linux/docker-ce/ubuntu/
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu ${UBUNTU_VERSION} stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
# Add myself to dockergroup
usermod -aG docker $(whoami)


# Setup kubectl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

# Setup dotfiles (clone over https to convert later)
git clone --bare https://github.com/wilmardo/dotfiles.git $HOME/.cfg
git --git-dir=$HOME/.cfg/ --work-tree=$HOME reset --hard

# Source new zsh config and delete old history
source $HOME/.zshrc
rm -rf $HOME/.zsh_history

# Install docker-compose (https://github.com/docker/compose/releases/)
install_bin https://github.com/docker/compose/releases/download/1.25.4/docker-compose-Linux-x86_64 docker-compose

# Instal kind https://github.com/kubernetes-sigs/kind/releases
install_bin https://github.com/kubernetes-sigs/kind/releases/download/v0.7.0/kind-linux-amd64 kind

# Install helm
install_bin https://get.helm.sh/helm-v3.0.3-linux-amd64.tar.gz helm
