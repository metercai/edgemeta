#!/bin/sh

DISK="/dev/mmcblk1"
PART="$((${DISK##*[^0-9]}+1))"
ROOT="${DISK}p${PART}"
OFFS="$(fdisk ${DISK} -l -o device,start | sed -n -e "\|^${ROOT}\s*|s///p")"
echo -e "p\nd\n${PART}\nn\np\n${PART}\n${OFFS}\n\nn\np\nw" | fdisk ${DISK}

LOOP="$(losetup -n -O NAME | sort | sed -n -e "1p")"
ROOT="$(losetup -n -O BACK-FILE ${LOOP} | sed -e "s|^|/dev|")"
OFFS="$(losetup -n -O OFFSET ${LOOP})"
LOOP="$(losetup -f)"
losetup -o ${OFFS} ${LOOP} ${ROOT}
fsck.f2fs -f ${LOOP}
mount ${LOOP} /mnt
umount ${LOOP}
resize.f2fs ${LOOP}
sleep 2
reboot