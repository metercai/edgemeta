#!/bin/sh

TOPDIR="/home/ubuntu/edgemeta"

./scripts/feeds update -a
./scripts/feeds install -a
cp $TOPDIR/package/edgemeta/patch/base-files/files/bin/config_generate.r4s $TOPDIR/package/base-files/files/bin/config_generate
##rm -r $TOPDIR/package/network/services/dnsmasq/patches
##cp -r $TOPDIR/package/edgemeta/patch/network/services/dnsmasq $TOPDIR/package/network/services/

. $TOPDIR/edgemeta/r4s.common.sh 
. $TOPDIR/edgemeta/dist.common.sh

cp $DEVICE_CONFIG $TOPDIR/.config
sed -i "s/VERSION_NUMBER=\"\"/VERSION_NUMBER=\"$VERSION_NUMBER\"/" $TOPDIR/.config
sed -i "s|VERSION_REPO=\"\"|VERSION_REPO=\"$VERSION_REPO\"|" $TOPDIR/.config

cd $TOPDIR

make defconfig

#make download
