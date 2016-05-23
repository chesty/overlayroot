# overlayroot
mounts an overlay filesystem over root

I use this for my raspberry pi, but it should work on any debian or derivative
It uses initramfs, stock raspbian doesn't use one, so step one would be to
get initramfs working. Something like

`sudo mkinitramfs -o /boot/init.gz`

then add to /boot/config.txt

```
initramfs init.gz
```

then reboot, it should reboot as normal

then add the following line to /etc/initramfs-tools/modules

```
overlay
```

copy the following files

- hooks-overlay to /etc/initramfs-tools/hooks/
- init-bottom-overlay to /etc/initramfs-tools/scripts/init-bottom/

install busybox

`sudo apt-get install busybox`

then rerun

`sudo mkinitramfs -o /boot/init.gz`

add to .bashrc

```
if [ ! -z "${IMCHROOTED}" ]; then
        PS1="chroot(${IMCHROOTED})\w:# "
fi
```

I used rootwork to work on the real root filesystem 
I put it in ~/bin and add ~/bin to my path

there are comments in some of the files you might want to read
and that's about it.

