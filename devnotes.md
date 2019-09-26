# Toolbox

## Git

Enable correct windows file tracking when cloned in WSL
```bash
# .git/config

filemode = false
```

Enable .gitignore after file has been tracked:
```bash
git rm -r --cached .
git add .
git commit -m "fixed untracked files"
```

Recover files lost by a git reset --hard or git clean
```
for blob in $(git fsck --full --unreachable --no-reflog | awk '$2 == "blob" { print $3 }'); do git cat-file -p $blob > $blob.txt; done
```

Squash all commits to one without interactive rebasing a shitload of commits:
Sauce: https://stackoverflow.com/a/25357146
```
 git checkout yourBranch
 git reset $(git merge-base master yourBranch)
 git add -A
 git commit -m "one commit on yourBranch"
```

## Docker
For file sharing this is needed (https://stackoverflow.com/questions/42203488/settings-to-windows-firewall-to-allow-docker-for-windows-to-share-drive):

`Set-NetConnectionProfile -interfacealias "vEthernet (DockerNAT)" -NetworkCategory Private`

### Docker daemon listen

<https://docs.docker.com/install/linux/linux-postinstall/#configuring-remote-access-with-systemd-unit-file>

```bash
sudo systemctl edit docker
```
```ini
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H tcp://127.0.0.1:2375 -H unix:///var/run/docker.sock
```

## VS Code
Set VS Code to end of line /n in settings

https://blogs.msdn.microsoft.com/stevelasker/2016/06/14/configuring-docker-for-windows-volumes/
Add a new user. I use DockerHost > Pass never expire, not change pass
Add to Administator group & add to docker-users group
Login is user and open C:\users
Enable C:\ sharing in Docker

Compose not working:
https://github.com/docker/compose/issues/1339


## WSL

### Change /mnt/c to /c/
```ini
# /etc/wsl.conf

[automount]
root = /
options = "metadata"
```

### Change homedir to windows dir
`sudo sed -i 's,/home/wilmardo,/c/Users/wilmaro,g' /etc/passwd`

### WSL oh my zsh
`sudo apt-get install zsh`
`sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"`

### Setup zsh on launch
```bash
# ~/.bashrc

# Launch Zsh
if [ -t 1 ]; then
exec zsh
fi
```

### Download and set font
Install to windows and set in wsl properties
https://github.com/powerline/fonts/tree/master/DejaVuSansMono

### Download dir theme
Clone this somewhere
https://github.com/seebi/dircolors-solarized

### Setup zsh
```bash
# ~/.zshrc

ZSH_THEME="agnoster"
eval `dircolors ~/term-config/dircolors-solarized/dircolors.256dark`
export DEFAULT_USER="$(whoami)"
```

### Docker host
```bash
# ~/.zshrc

export DOCKER_HOST=tcp://127.0.0.1:2375
```

### Docker client only install
```bash
curl https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz | \
sudo tar -zxC "/usr/bin/" --strip-components=1 docker/docker
```

## Tmux

### Setup tmux

```bash
# ~/.tmux.conf

### Tmux scrolling copy pasting
set -g mouse on
bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'select-pane -t=; copy-mode -e; send-keys -M'"
bind -n WheelDownPane select-pane -t= \; send-keys -M
bind -n C-WheelUpPane select-pane -t= \; copy-mode -e \; send-keys -M
bind -T copy-mode-vi    C-WheelUpPane   send-keys -X halfpage-up
bind -T copy-mode-vi    C-WheelDownPane send-keys -X halfpage-down
bind -T copy-mode-emacs C-WheelUpPane   send-keys -X halfpage-up
bind -T copy-mode-emacs C-WheelDownPane send-keys -X halfpage-down

# To copy, left click and drag to highlight text in yellow,
# once you release left click yellow text will disappear and will automatically be available in clibboard
# # Use vim keybindings in copy mode
setw -g mode-keys vi
# Release of left mouse to copy
bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "clip.exe"
```

## Gitlab

```yaml
# Trick to able to clone repo's from CI see: https://stackoverflow.com/a/44702187
- export BASE_URL=`echo ${CI_REPOSITORY_URL} | sed "s;\/*${CI_PROJECT_PATH}.*;;"`

# Login to Intermax docker registry
- echo "${DOCKER_REGISTRY_PASSWORD}" | docker login -u awx --password-stdin docker-registry.intermax.nl
```

## ZFS

Enable NFS share
`zfs set sharenfs=on mediastorage/downloads`

## Raspberry pi

```
# /etc/network/interfaces.d/wlan0
auto wlan0
allow-hotplug wlan0
iface wlan0 inet dhcp
        wpa-ssid "SSID"
        wpa-psk "PASS"
```

# Ceph Promox one node
```
ceph osd getcrushmap -o crush_map_compressed
crushtool -d crush_map_compressed -o crush_map_decompressed
vi crush_map_decompressed
```

Edit line `step chooseleaf firstn 0 type host` to `step chooseleaf firstn 0 type osd`

Upload to ceph
```
crushtool -c crush_map_decompressed -o new_crush_map_compressed
ceph osd setcrushmap -i new_crush_map_compressed
```

# Kubernetes 

## Ceph CSI troubleshoot
```
kubectl -n storing logs -f csi-rbdplugin-provisioner-0 csi-provisioner
kubectl -n storing logs -f csi-rbdplugin-attacher-0
kubectl -n storing logs --selector app=csi-rbdplugin -c csi-rbdplugin
```

## Tcpdump one container

Rougly based on https://community.pivotal.io/s/article/How-to-get-tcpdump-for-containers-inside-Kubernetes-pods
```
# Find network interface attached to container
kubectl exec -it -n automating shell -- /bin/sh -c 'cat /sys/class/net/eth0/iflink'
# Find node where container is running on
kubectl get pods --all-namespaces -o wide

# SSH to host

# Find interface on worker node
for i in /sys/class/net/veth*/ifindex; do grep -l 16 $i; done

# Run tcpdump on the veth returned
sudo tcpdump -i vethdd0877ff -w test2.pcap
```


# Windows

## Fix component store corruption
On a normal laptop
```
dism.exe /Online /Cleanup-Image /RestoreHealth
``` 
On something with WSUS
```
dism.exe /Online /Cleanup-Image /RestoreHealth /LimitAccess
``` 

## Cleanup WinSxS 
```
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase
```

## Proxmox

Import vmdk from untarred ova file
```
qm importdisk 125 photon-ova-disk1.vmdk virtualmachines --format vmdk
```

Disable pve-ha-lrm when running in singlenode to reduce writes to disk [source](https://forum.proxmox.com/threads/pmxcfs-writing-to-disk-all-the-time.35828/#post-175642)
```
systemctl stop pve-ha-lrm
systemctl disbale pve-ha-lrm
systemctl mask pve-ha-lrm
```

Set cpu governer to powersave to allow clocking back to save trees
Setup as @reboot cronjob on the node
```
crontab -e

add this line:

@reboot echo "powersave" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
```

## Static compile

staticx, pyinstaller --onefile --add-data=/usr/bin/dist/python3.7

## Ansible
```
UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh: Control socket connect(/c/Users/wilmaro/.ansible/cp/d9e3be2aa2): Permission denied\r\nFailed to connect to new control master", "unreachable": true}
```
`export ANSIBLE_SSH_CONTROL_PATH_DIR=/dev/shm`
