# Rock64

## Reinstall

Create sd with ayfan image:
```
xzcat bionic-minimal-rock64-0.8.0rc9-1120-arm64.img.xz | sudo dd of=/dev/sdc status=progress bs=30M
```
Copy the image to /home/rock64

Plug in Rock64, add jumper on sd/emmc pins and boot.
Remove jumper after comlete boot.

```
sudo rock64_reset_emmc.sh
xzcat bionic-minimal-rock64-0.8.0rc9-1120-arm64.img.xz | sudo dd of=/dev/mmcblk0 status=progress bs=4M
# Or with armbian
7z x Armbian_20.02.1_Rock64_buster_current_5.4.20.7z -so | sudo dd of=/dev/mmcblk0 status=progress bs=4M
```

## Setup static on debian

```
# /etc/network/interfaces.d/eth0
auto eth0
iface eth0 inet static
   address 192.168.1.11/24
   gateway 192.168.1.1
```

## Setup static ip on ubuntu

Disable cloud-init network when ` /etc/netplan/50-cloud-init.yaml` is present:
```
echo "network: {config: disabled}" | sudo tee /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
sudo nano /etc/netplan/eth0.yaml
```

https://github.com/canonical/netplan/blob/main/examples/static.yaml
```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      addresses: [192.168.1.12/24]
      routes:
        - to: default
          via: 192.168.1.1
      nameservers:
        addresses: [192.168.1.1]
```

```
sudo netplan apply
```

# Overclock to max frequency

```
sudo sed -i "s/MAX_SPEED=.*/MAX_SPEED=1512000/" /etc/default/cpufrequtils 
sudo systemctl restart cpufrequtils
```

Restore to default:

```
sudo sed -i "s/MAX_SPEED=.*/MAX_SPEED=1296000/" /etc/default/cpufrequtils 
sudo systemctl restart cpufrequtils
```

# Raspberry PI 4

Install ubuntu from here:
https://ubuntu.com/download/raspberry-pi

Extend the root partition before plugging the SD in:
```
xzcat ubuntu-18.04.4-preinstalled-server-arm64+raspi3.img.xz | sudo dd of=/dev/mmcblk0 status=progress bs=30M
sudo resize2fs /dev/mmcblk0p2
```

Setup ZFS
```
sudo apt install zfs-dkms nfs-kernel-server
zpool create data /dev/sda /dev/sdb
zfs create data/anthillmob
zfs set sharenfs=on data/anthillmob
# Since NFS provisioner runs as user 1000
sudo chown 1000:1000 /data/anthillmob
# Disable spindown
sudo sed -i "s/APMD_SPINDOWN=.*/APMD_SPINDOWN=240/" /etc/apm/event.d/20hdparm
```

Disable disk spindown, hdparm wasn't working
```
wget https://github.com/adelolmo/hd-idle/releases/download/v1.9/hd-idle_1.9_arm64.deb
sudo dpkg -i hd-idle_1.9_arm64.deb
sudo sed -i "s/START_HD_IDLE=.*/START_HD_IDLE=true/" /etc/default/hd-idle
systemctl start hd-idle 
systemctl enable hd-idle 
```
