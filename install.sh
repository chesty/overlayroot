#!/bin/sh

# Error out if anything fails.
set -e

# Make sure script is run as root.
if [ "$(id -u)" != "0" ]; then
  echo "Must be run as root with sudo! Try: sudo ./install.sh"
  exit 1
fi


mkinitramfs -o /boot/init.gz

echo initramfs init.gz >> /boot/config.txt

echo overlay >> /etc/initramfs-tools/modules

cp hooks-overlay /etc/initramfs-tools/hooks/

cp init-bottom-overlay /etc/initramfs-tools/scripts/init-bottom/

apt-get install busybox

mkinitramfs -o /boot/init.gz
