# Well
This script automatically installs new kernel version debian.  
If you want to use it, run it from debian 11 bullseye(tested, works).  
Working on 10(buster) version of debian is not guaranteed

## How to use
Just put consequentially commands below into your terminal 
1. `git clone https://github.com/FlareXF/debian_newkernel_installer`
2. `cd debian_newkernel_installer`
3. `su`
4. `[write your password]`
5. `chmod +x new_kernel.sh`
6. `./new_kernel.sh`
7. `reboot `
  
After you did reboot and get into grub menu, select something called "Advanced options for Debian Gnu/Linux" and select new kernel version.  
That's it!
