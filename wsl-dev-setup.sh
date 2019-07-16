#!/bin/bash

# Setup mount to /c/ instead of /mnt/c/
cat <<EOF > /etc/wsl.conf
[automount]
root = /
options = "metadata"
EOF

# Change homedir to windows user folder
sed -i 's,/home/wilmardo,/c/Users/wilmaro,g' /etc/passwd

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

# Setup zsh
wget -O ~/.zshrc https://gist.githubusercontent.com/wilmardo/0f2fdebf79cd6b4dc79d5ca06c79e1f4/raw/8de41e438f341cc2123d40f7aa8f23bc6534291b/.zshrc

# Setup tmux
wget -O ~/.tmux.conf https://gist.githubusercontent.com/wilmardo/77007a3f760b52ae053d7d4687fa59ab/raw/68176030a6503bc46d004912f4f742ea592c0212/.tmux.conf

# Setup docker client only
curl https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz | \
sudo tar -zxC "/usr/bin/" --strip-components=1 docker/docker

# Install docker-compose (https://github.com/docker/compose/releases/)
curl -L https://github.com/docker/compose/releases/download/1.24.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Instal minikube https://github.com/kubernetes/minikube/releases/tag/v1.2.0
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v1.2.0/minikube-linux-amd64 && chmod +x minikube && sudo cp minikube /usr/local/bin/ && rm minikube
