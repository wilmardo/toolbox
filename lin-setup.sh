#!/bin/bash

sudo add-apt-repository ppa:noobslab/icons
sudo apt-get install curl fonts-powerline chrome-gnome-shell gnome-tweak-tool build-essential ultra-flat-icons


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
