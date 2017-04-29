#!/bin/sh

echo '==> Installing FreeBSD with ZFS root...'
mount_cd9660 /dev/cd0 /cdrom

if [ "$PACKER_BUILDER_TYPE" = 'vmware-iso' ]; then
  echo '==> VMware detected, installing FreeBSD on da0.'
  zfsinstall -d da0 -s 2G -u /cdrom/11.0-RELEASE-amd64
elif [ "$PACKER_BUILDER_TYPE" = 'virtualbox-iso' ]; then
  echo '==> VirtualBox detected, installing FreeBSD on ada0.'
  zfsinstall -d ada0 -s 2G -u /cdrom/11.0-RELEASE-amd64
else
  echo "==> Unknown type of VM, aborting."
  exit 1
fi

echo '==> Preparing machine for first boot via setup script...'
mount -t devfs devfs /mnt/dev
cat setup.sh | chroot /mnt sh -
