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
```

## Setup static ip

```
sudo netplan generate
sudo nano /etc/netplan/eth0.yaml

```

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      addresses: [192.168.1.12/24]
      gateway4: 192.168.1.1
      nameservers:
        addresses: [192.168.1.1]
      dhcp4: no
```
