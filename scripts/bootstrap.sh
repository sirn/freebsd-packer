#!/bin/sh

echo '==> Installing FreeBSD with ZFS root...'
mount_cd9660 /dev/cd0 /cdrom
zfsinstall -d da0 -s 2G -u /cdrom/10.1-RELEASE-amd64

echo '==> Preparing machine for first boot via setup script...'
mount -t devfs devfs /mnt/dev
cat setup.sh | chroot /mnt sh -
