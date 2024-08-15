# Win2Linux

## Image
![alt text](https://github.com/duckpdev/win2linux/blob/main/image.png?raw=true)

## Description 
### Win2Linux - is a tool which can install arch linux without any external usb/cd rom

## Instructions

### Instructions for mbr
- Mbr is old so there is no mbr

### Instructions for efi
- Disable any antivirus (Windows defender,avast and etc)
- Run win2linux.bat with admin rights
- Done

### Issues
- Question: Arch linux don`t booting
- Answer: Boot to windows and retry win2linux script
- Question: lsblk error
- Just type command lsblk and boot to archinstall

### Notes
- Don`t delete C:\temp directory
- Don`t delete C:\grub\grub2auto.label
- Don`t create file with path /grub/grub2auto.label (This file need for search where lies C:\ partition)

### Enjoy
