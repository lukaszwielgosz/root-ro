

# Change a few things in /etc/initramfs-tools so that overlayfs is used on startup to mount a ready-only root
echo overlay >> /etc/initramfs-tools/modules
#wget https://raw.githubusercontent.com/JasperE84/root-ro/master/etc/initramfs-tools/hooks/root-ro -O /etc/initramfs-tools/hooks/root-ro
#wget https://raw.githubusercontent.com/JasperE84/root-ro/master/etc/initramfs-tools/scripts/init-bottom/root-ro -O /etc/initramfs-tools/scripts/init-bottom/root-ro
cp etc/initramfs-tools/hooks/root-ro /etc/initramfs-tools/hooks/root-ro
cp etc/initramfs-tools/scripts/init-bottom/root-ro /etc/initramfs-tools/scripts/init-bottom/root-ro
chmod +x /etc/initramfs-tools/hooks/root-ro
chmod +x /etc/initramfs-tools/scripts/init-bottom/root-ro

# Update the initrd file
#update-initramfs -u

# Generate new initrd file
update-initramfs -c -k `uname -r`

# Now, the file /boot/initrd.img-4.9.140-tegra contains the above modifications.
# There is also the symbolic link in /boot/initrd.img pointing to it, but this doesn't
# actually get loaded on startup. By default /boot/initrd (without extension) is loaded.
# So change /boot/extlinux/extlinux.conf so that it actually gets loaded:
# Search for `INITRD /boot/initrd` and replace it with `INITRD /boot/initrd.img`:
if ! grep -q "INITRD /boot/initrd.img" /boot/extlinux/extlinux.conf; then sed -i "s/INITRD \/boot\/initrd/INITRD \/boot\/initrd.img/" /boot/extlinux/extlinux.conf; fi

rm /boot/initrd.img
ln -rs /boot/initrd.img-`uname -r` /boot/initrd.img

# Before rebooting, also add the helper scripts from JasperE84/root-ro:
#wget https://raw.githubusercontent.com/JasperE84/root-ro/master/reboot-to-readonly-mode.sh -O /root/reboot-ro
#wget https://raw.githubusercontent.com/JasperE84/root-ro/master/reboot-to-writable-mode.sh -O /root/reboot-rw
cp reboot-to-readonly-mode.sh /root/
cp reboot-to-writable-mode.sh /root/
chmod +x /root/reboot-to-readonly-mode.sh
chmod +x /root/reboot-to-writable-mode.sh
