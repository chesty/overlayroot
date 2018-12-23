#!/bin/sh

# Error out if anything fails.
set -e

# Make sure script is run as root.
if [ "$(id -u)" != "0" ]; then
  echo "Must be run as root with sudo! Try: sudo ./install.sh"
  exit 1
fi

mkinitramfs -o /boot/init.gz

if ! grep -q "^initramfs " /boot/config.txt; then
    echo initramfs init.gz >> /boot/config.txt
fi

if ! grep -q "^overlay" /etc/initramfs-tools/modules; then
    echo overlay >> /etc/initramfs-tools/modules
fi

cp hooks-overlay /etc/initramfs-tools/hooks/

cp init-bottom-overlay /etc/initramfs-tools/scripts/init-bottom/

apt-get install busybox

mkinitramfs -o /boot/init.gz
