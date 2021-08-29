#!/bin/bash

apt-get -y install build-essential linux-source bc kmod cpio flex libncurses5-dev libelf-dev libssl-dev rsync wget curl dwarves bison git &&
cd /usr/src && wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.13.13.tar.xz &&
tar -xvf /usr/src/linux-5.13.13.tar.xz -C /usr/src/ &&
cp /boot/config-* /usr/src/linux-5.13.13/ &&
mv /usr/src/linux-5.13.13/config-* /usr/src/.config &&
export PATH="/usr/bin:/usr/sbin:$PATH"

install_ker () {
	yes "" | make oldconfig &&
	sed -i "s/CONFIG_SYSTEM_TRUSTED_KEYS.*$/CONFIG_SYSTEM_TRUSTED_KEYS=\"\"/g; s/^.*CONFIG_MT7921E.*$/CONFIG_MT7921E=y/g" .config &&
	make clean && nice make -j`nproc` bindeb-pkg && cd ..
	[ -e linux-image-5.13.13_5.13.13-1_amd64.deb ] && dpkg -i linux-image-5.13.13_5.13.13-1_amd64.deb && update-grub &&
	rm -rf /usr/src/linux-5.13.13/
	#rm linux-image-*-dbg*
}

if [ `pwd` = "/usr/src/linux-5.13.13" ]; then
	install_ker
else
	cd /usr/src/linux-5.13.13 && install_ker
fi
