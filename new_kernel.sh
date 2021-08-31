#!/bin/bash

link_ker="https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.13.13.tar.xz"


[[ "`echo $link_ker | sed "s/.*\(.$\)/\1/g"`" = "/" ]] &&
link_ker="`echo $link_ker | sed "s/.$//g"`"
name_ver_ext="`echo "$link_ker" | awk -F '/' '{print $NF}'`" 
name_ver="`echo "$name_ver_ext" | sed "s/.tar.xz//g"`"
ver="`echo "$name_ver_ext" | sed "s/^.*linux-\(.*\)\.tar.*$/\1/g"`"
key_path="`sed "/CONFIG_SYSTEM_TRUSTED_KEYS.*/"\!"d" /boot/config-5.10* | awk -F '[\"\"]' '{print $2}'`"

apt-get -y install build-essential linux-source bc kmod cpio flex libncurses5-dev libelf-dev libssl-dev rsync wget curl dwarves bison git &&
cd /usr/src && wget $link_ker &&
tar -xvf /usr/src/$name_ver_ext* -C /usr/src/ &&
###############################select_menu###############################
cnt=0
cfg_list="`echo "$(ls /boot/)" | sed "/config.*/"\!"d" `"
cfg_list=($cfg_list)
for i in "${cfg_list[@]}"; do
	echo "[$cnt]$i"
	((cnt++))
done
echo -n "Please select config file to copy (choose your main kernel version):"
read cfg_num
old_conf="${cfg_list[$cfg_num]}"
cp /boot/$old_conf* /usr/src/linux-$ver/ &&
mv /usr/src/linux-$ver/config-* /usr/src/linux-$ver/.config &&
###############################select_menu###############################

export PATH="/usr/bin:/usr/sbin:$PATH"


install_ker () {
	yes "" | make oldconfig &&
	sed -i "s/CONFIG_SYSTEM_TRUSTED_KEYS.*$/CONFIG_SYSTEM_TRUSTED_KEYS=\"\"/g; s/^.*CONFIG_MT7921E.*$/CONFIG_MT7921E=m/g" .config &&
	make clean && nice make -j`nproc` bindeb-pkg && cd ..
	[ -e linux-image-$ver_$ver* ] && dpkg -i linux-image-$ver_$ver* && update-grub &&
	rm -rf /usr/src/linux-$ver/ &&
	sed -i "s/CONFIG_SYSTEM_TRUSTED_KEYS.*$/CONFIG_SYSTEM_TRUSTED_KEYS=\"$key_path\"" /boot/config-$ver*
	rm linux-image-*-dbg*
	return 0
}

if [[ "`pwd`" = "/usr/src/linux-$ver" ]]; then
	install_ker
else
	cd /usr/src/linux-$ver && install_ker 
fi
