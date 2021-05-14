#!/bin/sh

FREEBSD_CDROM=/cdrom/13.0-RELEASE-amd64

echo '==> Installing FreeBSD with ZFS root...'
mount_cd9660 /dev/cd0 /cdrom

if [ "$PACKER_BUILDER_TYPE" = 'vmware-iso' ]; then
  echo '==> VMware detected, installing FreeBSD on da0.'
  zfsinstall -d da0 -s 2G -u "$FREEBSD_CDROM"
elif [ "$PACKER_BUILDER_TYPE" = 'virtualbox-iso' ]; then
  echo '==> VirtualBox detected, installing FreeBSD on ada0.'
  zfsinstall -d ada0 -s 2G -u "$FREEBSD_CDROM"
elif [ "$PACKER_BUILDER_TYPE" = 'qemu' ]; then
  echo '==> QEMU detected, installing FreeBSD on vtbd0.'
  zfsinstall -d vtbd0 -s 2G -u "$FREEBSD_CDROM"
else
  echo "==> Unknown type of VM, aborting."
  exit 1
fi

echo '==> Preparing machine for first boot via setup script...'
mount -t devfs devfs /mnt/dev
chroot /mnt sh < setup.sh
