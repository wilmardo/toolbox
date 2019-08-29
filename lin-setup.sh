#!/bin/bash

sudo add-apt-repository ppa:noobslab/icons
sudo apt-get install curl fonts-powerline chrome-gnome-shell gnome-tweak-tool build-essential ultra-flat-icons

# https://docs.docker.com/install/linux/docker-ce/ubuntu/
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get install docker-ce docker-ce-cli containerd.io

# https://code.visualstudio.com/docs/setup/linux
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
 sudo apt-get install code-insiders



/org/gnome/desktop/interface/gtk-theme
  'Adwaita-dark'

/org/gnome/desktop/interface/icon-theme
  'Ultra-Flat'

/org/gnome/shell/extensions/dash-to-dock/preferred-monitor
  0

/org/gnome/shell/extensions/dash-to-dock/multi-monitor
  true

/org/gnome/shell/extensions/dash-to-dock/dock-position
  'BOTTOM'

/org/gnome/shell/extensions/dash-to-dock/intellihide-mode
  'FOCUS_APPLICATION_WINDOWS'

/org/gnome/shell/extensions/dash-to-dock/intellihide
  false

/org/gnome/shell/extensions/dash-to-dock/require-pressure-to-show
  false

/org/gnome/shell/extensions/dash-to-dock/dash-max-icon-size
  32

/org/gnome/shell/extensions/dash-to-dock/apply-custom-theme
  true

/org/gnome/settings-daemon/plugins/xsettings/overrides
  {'Gtk/ShellShowsAppMenu': <0>}

/org/gnome/desktop/wm/preferences/button-layout
  ':appmenu,minimize,maximize,close'
