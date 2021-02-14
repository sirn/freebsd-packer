#!/bin/sh

echo '==> Make network accessible...'
echo 'nameserver 8.8.8.8' > /etc/resolv.conf
echo 'nameserver 8.8.4.4' >> /etc/resolv.conf

echo '==> Configuring system...'
sysrc hostname=vagrant
sysrc ifconfig_em0=DHCP

echo '==> Configuring SSH...'
sysrc sshd_enable=YES
sed -i '' -e 's/#PermitRootLogin no/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i '' -e 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config

echo '==> Setting up pkg...'
if [ ! -f /usr/local/sbin/pkg ]; then
    env ASSUME_ALWAYS_YES=yes pkg bootstrap
fi

if [ "$PACKER_BUILDER_TYPE" = 'vmware-iso' ]; then
    echo '==> Setting up VMware tools...'
    pkg install -y open-vm-tools-nox11
    {
        echo 'vmware_guest_vmblock_enable="YES"'
        echo 'vmware_guest_vmhgfs_enable="YES"'
        echo 'vmware_guest_vmmemctl_enable="YES"'
        echo 'vmware_guest_vmxnet_enable="YES"'
	echo 'vmware_guestd_enable="YES"'
    } >> /etc/rc.conf
elif [ "$PACKER_BUILDER_TYPE" = 'virtualbox-iso' ]; then
    echo '==> Setting up VirtualBox tools...'
    pkg install -y virtualbox-ose-additions
    {
        echo 'ifconfig_em1="inet 10.6.66.42 netmask 255.255.255.0"'
        echo 'vboxguest_enable="YES"'
        echo 'vboxservice_enable="YES"'
    } >> /etc/rc.conf
elif [ "$PACKER_BUILDER_TYPE" = 'qemu' ]; then
    echo '==> Setting up QEMU...'
    {
        echo 'ifconfig_vtnet0="SYNCDHCP"'
        echo 'if_vtnet_load="YES"'
        echo 'virtio_load="YES"'
        echo 'virtio_pci_load="YES"'
        echo 'virtio_blk_load="YES"'
        echo 'virtio_scsi_load="YES"'
        echo 'virtio_console_load="YES"'
        echo 'virtio_balloon_load="YES"'
        echo 'virtio_random_load="YES"'
    } >> /etc/rc.conf
else
    echo '==> Unknown type of VM, skipping tools installation.'
fi

echo '==> Setting up user...'
sh -c "echo vagrant |pw mod user root -h 0"
pw user add vagrant -m -G wheel
mkdir ~vagrant/.ssh
chmod 700 ~vagrant/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key" > ~vagrant/.ssh/authorized_keys
chown -R vagrant ~vagrant/.ssh
chmod 600 ~vagrant/.ssh/authorized_keys

echo '==> Setting up sudo..'
pkg install -y sudo
echo 'vagrant ALL=(ALL) NOPASSWD: ALL' > /usr/local/etc/sudoers.d/vagrant

echo '==> Finalizing...'
rm /etc/resolv.conf

echo '==> Done.'
