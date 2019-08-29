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

# https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | sudo apt-key add -

echo 'deb https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/debs/ vscodium main' | sudo tee --append /etc/apt/sources.list.d/vscodium.list

sudo apt install codium


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
