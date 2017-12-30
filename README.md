# overlayroot
mounts an overlay filesystem over the root filesystem

I use this for my Raspberry Pi, but it should work on any Debian or derivative.
It uses initramfs. Stock Raspbian doesn't use one so step one would be to get initramfs working. Something like:

```bash
sudo mkinitramfs -o /boot/init.gz
```

Add to /boot/config.txt
```bash
initramfs init.gz
```

Test the initramfs works by rebooting. It should boot as normal.

Add the following line to /etc/initramfs-tools/modules
```
overlay
```

Copy the following files
- hooks-overlay to /etc/initramfs-tools/hooks/
- init-bottom-overlay to /etc/initramfs-tools/scripts/init-bottom/

install busybox
```bash
sudo apt-get install busybox
```

then rerun

```bash
sudo mkinitramfs -o /boot/init.gz
```

add to .bashrc

```bash
if [ ! -z "${IMCHROOTED}" ]; then
        PS1="chroot(${IMCHROOTED})\w:# "
fi
```
I use rootwork to work on the real root filesystem. 
I put it in ~/bin and add ~/bin to my path

After rebooting, the root filesystem should be an overlay. If it's on tmpfs any changes made will be lost after a reboot. If you want to upgrade packages, for example, run `rootwork`, the prompt should change to

```bash
chroot(/overlay/lower)/:#
```
You're now making changes to the sdcard, and changes will be permanent. 

After you've finished working on the sdcard run `exit`. rootwork tries to clean up by umounting all the mounts it mounted, but often it can't umount a filesystem due to a lock file or something else causing the filesystem to be busy. It's probably a good idea to reboot now for 2 reasons, 1 to clear the mounts that couldn't be umounted, and also to test it still boots ok after the changes you've just made. 

There are comments in some of the files you might want to read
and that's about it.
