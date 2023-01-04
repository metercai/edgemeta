#!/bin/sh

. edgemeta/r4s.common.sh
. edgemeta/dist.common.sh

mkdir -p $ROOT_DIST
cp $IMGDIR/$IMG_EXT4 $ROOT_DIST/$IMG_EXT4_DIST
cp $IMGDIR/$IMG_SQUASHFS $ROOT_DIST/$IMG_SQUASHFS_DIST

mkdir -p $VROOT_DIST/targets/$DEVICE_CHIPDIR
cp -r $TOPDIR/bin/targets/$DEVICE_CHIPDIR/packages $VROOT_DIST/targets/$DEVICE_CHIPDIR/
cp -r $TOPDIR/bin/packages $VROOT_DIST/

echo "$VROOT_DIST over!"

