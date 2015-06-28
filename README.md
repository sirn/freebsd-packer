mfsBSD Packer Template
======================

This repository provides a Packer template for building FreeBSD image with ZFS root. The repository is based on [brd/packer-freebsd](https://github.com/brd/packer-freebsd) but use [mfsBSD](http://mfsbsd.vx.sk/) to bootstrap the installation instead of FreeBSD ISO.

### Prerequisites

* [Vagrant](https://www.vagrantup.com/) with [VMware Provider](https://www.vagrantup.com/vmware).
* [Packer](https://www.packer.io/).

### Usage

1. Build the Vagrant box with `packer build template.json`.
2. Add the Vagrant box with `vagrant box add --name freebsd-10.1 freebsd-10.1-vmware.box`.

The default Vagrantfile comes with NFS mount on `/vagrant` and 1GB of RAM with 20GB of disk.
