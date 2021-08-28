#!/bin/bash

apt-get install build-essential linux-source bc kmod cpio flex libncurses5-dev libelf-dev libssl-dev rsync wget curl dwarves bison
cd /usr/src && wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.13.13.tar.xz
tar xavf /usr/src/linux-5.13.13.tar.xz
cp /boot/config-* /usr/src/linux-5.13.13/
mv /usr/src/linux-5.13.13 /usr/src/.config

if [ `pwd` = "/usr/src/linux-5.13.13" ]; then
	install_ker
else
	cd /usr/src/linux-5.13.13 && install_ker
fi

install_ker () {
	yes "" | make oldconfig
	sed "s/CONFIG_SYSTEM_TRUSTED_KEYS.*$/CONFIG_SYSTEM_TRUSTED_KEYS=\"\"/g" .config
	make clean && nice make -j`nproc` bindeb-pkg && cd ..
	[ -e linux-image-5.13.13_5.13.13-1_amd64.deb ] && dpkg -i linux-image-5.13.13_5.13.13-1_amd64.deb && update-grub
}

