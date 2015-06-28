#!/bin/sh

echo 'Disabling sshd...'
service sshd stop

echo 'Installing FreeBSD with ZFS root...'
mount_cd9660 /dev/cd0 /cdrom
zfsinstall -d da0 -s 2G -u /cdrom/10.1-RELEASE-amd64

echo 'Preparing machine for first boot via chroot...'
chroot /mnt sed -i '' -e 's/#PermitRootLogin no/PermitRootLogin yes/' /etc/ssh/sshd_config
chroot /mnt sed -i '' -e 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
chroot /mnt chsh -s sh root
chroot /mnt sh -c "echo vagrant |pw mod user root -h 0"
chroot /mnt sysrc hostname=vagrant
chroot /mnt sysrc ifconfig_em0=DHCP
chroot /mnt sysrc sshd_enable=YES

echo 'Reboot!'
reboot
