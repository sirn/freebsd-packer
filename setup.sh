#!/bin/sh

echo 'Setting up pkg...'
if [ ! -f /usr/local/sbin/pkg ]; then
    ASSUME_ALWAYS_YES=yes pkg bootstrap
fi

if [ "$PACKER_BUILDER_TYPE" = 'vmware-iso' ]; then
    echo 'Setting up VMware tools...'
    pkg install -y open-vm-tools-nox11
    echo 'vmware_guest_vmblock_enable="YES"' >> /etc/rc.conf
    echo 'vmware_guest_vmhgfs_enable="YES"' >> /etc/rc.conf
    echo 'vmware_guest_vmmemctl_enable="YES"' >> /etc/rc.conf
    echo 'vmware_guest_vmxnet_enable="YES"' >> /etc/rc.conf
	echo 'vmware_guestd_enable="YES"' >> /etc/rc.conf
else
    echo 'Unknown type of VM, skipping tools installation.'
fi

echo 'Setting up vagrant user...'
pw user add vagrant -m -G wheel
mkdir ~vagrant/.ssh
chmod 700 ~vagrant/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key" > ~vagrant/.ssh/authorized_keys
chown -R vagrant ~vagrant/.ssh
chmod 600 ~vagrant/.ssh/authorized_keys

echo 'Setting up sudo..'
pkg install -y sudo
echo 'vagrant ALL=(ALL) NOPASSWD: ALL' > /usr/local/etc/sudoers.d/vagrant

echo 'Finalizaing...'
chsh -s tcsh root

echo 'Done.'
