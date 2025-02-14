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

https://www.reddit.com/r/DataHoarder/comments/5cq60b/zfs_array_sizes_im_really_confused/
Set 1M for dataset where large files are stored and performance isn't needed:
```
 zfs set recordsize=1M mediastorage/new-movies
```

Can be done on creation:
```
zfs create -o recordsize=1M -o sharenfs=true mediastorage/new-tvshows
```


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

```
# Allow more usage on OSD's to rebalance
ceph osd set-backfillfull-ratio

# Reweight and rebalance cluster
ceph osd reweight-by-utilization

# Check status
ceph osd status

# Check progress
ceph -w

# Remove disks
https://docs.ceph.com/docs/mimic/rados/operations/add-or-rm-osds/

ceph osd out 1
sudo systemctl stop ceph-osd@1
ceph osd purge {id} --yes-i-really-mean-it
pveceph createosd /dev/sdx
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

# OR untested
sudo tcpdump -i any host <Application pod IP or Ingress controller pod IP> -C 20 -W 200 -w /tmp/ingress.pcap
```

## Namespace stuck on terminating

List resource stuck in the namespace
```
kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind --ignore-not-found -n <terminating-namespace>
```

Remove stuck finalizers:
```
kubectl -n flux-system patch -p '{"metadata":{"finalizers":null}}' --type=merge <resource> <name>
kubectl -n flux-system patch -p '{"metadata":{"finalizers":null}}' --type=merge helmchart flux-system-cert-manager 
```

Putting all together for a one fix all:
```
kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get -o name --ignore-not-found -n flux-system | xargs -n1 kubectl -n flux-system patch -p '{"metadata":{"finalizers":null}}' --type=merge
```

## Delete secrets older then the latest matching by regex

Sort json by creationTimestamp, reverse this and remove the first element (most recent one). Delete the rest:
```
kubectl get secrets -n <namespace> -o json | \
jq -r '[.items[] | select(.metadata.name | test("secretname.*"))] | sort_by(.metdata.creationTimestamp) | reverse | del(.[0]) | .[].metadata.name' | \
xargs -n1 kubectl -n <namespace> delete secret 
```

## flux resume suspend

```
flux get hr --no-header --status-selector ready=false | tr -s ' ' | cut -d ' ' -f1 | xargs -n1 sh -c 'flux suspend hr $0 && flux resume hr $0'
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

## Ceph

Cleanup inconsitancies in one time

```
sudo ceph health detail | grep pg | tail +3 | cut -d' ' -f6 | xargs -n1 sudo ceph pg repair
```

## Static compile

staticx, pyinstaller --onefile --add-data=/usr/bin/dist/python3.7

## Ansible
```
UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh: Control socket connect(/c/Users/wilmaro/.ansible/cp/d9e3be2aa2): Permission denied\r\nFailed to connect to new control master", "unreachable": true}
```
`export ANSIBLE_SSH_CONTROL_PATH_DIR=/dev/shm`

```
# create list in loop
register: "{{ list | default([]) + [ item ] }}"

# create dict in loop
register: "{{ dict | default({}) | combine({'key': item}) }}"
```

## Zigbee2mqtt

### Reset router
CC2531 can be re-paired pressing S2 for 5 seconds.
СС2530 (the latest version) can be re-paired if you power on/power off it three times (power on, wait 2 seconds, power off, repeat this cycle three times).
source: https://github.com/Koenkk/zigbee2mqtt/issues/1086#issuecomment-463601551

### Create networkmap
`mosquitto_sub -h 192.168.1.10 -p 31883 -u <> -P <> -v -t 'zigbee2mqtt/bridge/networkmap/#'`
`mosquitto_pub -h 192.168.1.10 -p 31883 -u <> -P <> -t 'zigbee2mqtt/bridge/networkmap/routes' -m 'graphviz'`
Paste into http://www.webgraphviz.com/


## VMware

### Shrink template Linux
```
yum clean all
e4defrag /
dd if=/dev/zero of=wipefile bs=1M; sync; rm -f wipefile
```

### Shrink template Windows
```
    Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase
    Run disk cleanup as admin
    defrag c:
    defrag c: /X
    sdelete -z c:
```

### Shrink disk
```
cd /vmfs/volumes/FreeNAS/<vm name>/
vmkfstools --punchzero <diskname>.vmdk
```

# Kubernetes

Remove all non running containers (Evicted, Failed, Completed etc)
```
kubectl get po --all-namespaces --field-selector 'status.phase!=Running' -o json | kubectl delete -f -
```

Remove only Failed containers:
```
kubectl get po --all-namespaces --field-selector 'status.phase==Failed' -o json | kubectl delete -f -
```

# Rsync

Fast local data copy:

```
rsync -ahW --no-compress --info=progress2 /src /dst
```

```
-a is for archive, which preserves ownership, permissions etc.
-h is for human-readable, so the transfer rate and file sizes are easier to read (optional)
-W is for copying whole files only, without delta-xfer algorithm which should reduce CPU load
--no-compress as there's no lack of bandwidth between local devices
--info=progress2 so I can see the progress
```

Fast local move:
```
rsync -avzh --remove-source-files --progress /source/ user@server:/target \
&&  find /source -type d -empty -delete
```


# LVM

Resize lvm to max available size and resize filesystem:

```
sudo lvextend -l 100%FREE --resizefs /dev/ubuntu-vg/ubuntu-lv
```

# Get version from packages.json

```
version=$(sed -nE 's/"serialport": "([0-9]*\.[0-9]*\.[0-9]*)".*/v\1/p' /zigbee-herdsman/package.json
```

# Strace

```
strace -fff -e trace=open,close,read,write,connect,accept,stat ./zwave2mqtt
```

# Hyper-V

Setup internal network:

Add internal switch, set ip addresss of interface in configuration manager. To for example 10.0.0.1
Add new adapter to guest, set internal switch as connect, set static ip to for example 10.0.0.10, set gateway to ip address of adapter(10.0.0.1)

# SSH hostke hack

Switching hosts on same ip often, disable hostkey checking for all local ranges:

`~/.ssh/config`
```
# Do not keep HostKeys for internal networks.
Host 10.*.*.* 192.168.*.* 172.16.*.* 172.17.*.* 172.18.*.* 172.19.*.* 172.2?.*.* 172.30.*.* 172.31.*.*
    UserKnownHostsFile /dev/null
    StrictHostKeyChecking no
```

### FreeBSD arm64 on Proxmox

Download memstick image
http://ftp4.freebsd.org/pub/FreeBSD/releases/ISO-IMAGES/

Add a local disk to the VM and run

```
sudo dd if=FreeBSD-11.2-RELEASE-arm64-aarch64-memstick.img of=/var/lib/vz/images/105/vm-105-disk-0.raw
```

### Find larger directories
```
du -sh /* | sort -hr | head
```

### OpenSCAD

Find coordinates after rotate and translate
https://forum.openscad.org/How-to-find-the-current-x-y-z-location-tp25722p25731.html


### Syncthing

Windows ignore patterns
```
!/Desktop
!/Documents
!/Pictures
!/Videos
*
```


### PHP quote variables 

```
(\$.*?\[)([\w+]+[\w]+)(\])


(\[)([a-zA-Z+]+[a-zA-Z_]+)(\])


(\$\w+\s*\[(?![A-Z]+\]))([a-zA-Z_]+[\w]+)(\])

(\$\w+\]?\[(?!\w*\(|\w*:)(?=[^\]]*[a-z])(\K[a-zA-Z_]+[\w]+)


regex:
(\[)([a-zA-Z0-9+]+[a-zA-Z_0-9]+)(\])

replace:
$1'$2'$3
```

### Shell pipeline see whats inbetween

```console
# echo foobar | tee /dev/tty | grep oo
foobar
foobar
```

### Only run somethign when regex is done

```bash
if perl -i -pe '$M += s/: {{/": |\n" . " " x 50 . "\@\{\{"/e;END{exit 1 unless $M>0}' "$file"; then
   echo changed
fi
```
