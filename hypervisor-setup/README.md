# README
The folder has components for setting up my home lab hypervisors.

## Initial hypervisor setup
The hypervisor server is prepared using the [Ubuntu Server](https://ubuntu.com/download/server) minimal install.  

### Notes from the past
I've found the generic USB install method to be the simplest for small scale deployments.  If an automated OS install method is really needed, I would lean towards automating the USB install method further before setting up a network install environment.  The network install method has many more infrastructure dependencies (dhcp, tftp, ipxe, http server) and bootstrapping from almost nothing is more challenging.

#### A potential way to automate the USB install method
Though flashing the USB with the ISO works, it is very dependent on the OS and its interactive installer.  A more generic method could be to utilize the iPXE on a USB stick.  The iPXE would be bootable via the USB in both UEFI and Legacy BIOS systems, for instance see: <https://ipxe.org/download#using_a_boot_cd-rom_or_usb_key>.  The iPXE would then drop down into a shell environment, or runs an iPXE scrip that fetches the ISO and boots the kernel.  This method would be customizable for a variety of OSes for automated installation.
