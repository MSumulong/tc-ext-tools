#!/bin/sh

#
# Prepares kernel source for building kernel modules
#
# Sercan Arslan <arslanserc@gmail.com>
#

set -e

if [ ! -e /usr/local/tce.installed/compiletc ]; then
   echo "Loading missing dependency: compiletc"
   tce-load -w compiletc
   tce-load -i compiletc
fi

if [ ! -e /usr/local/tce.installed/toolchain64 ]; then
   echo "Loading missing dependency: toolchain64"
   tce-load -w toolchain64
   tce-load -i toolchain64
fi

VERSION=2.6.33.3
LINUX_DIR=linux-${VERSION}
LINUX_SOURCE=linux-${VERSION}-patched.tbz2
MIRROR=http://distro.ibiblio.org/pub/linux/distributions/tinycorelinux/3.x/release/src/kernel
KERNEL=2.6.33.3-tinycore64
CONFIG=config-${KERNEL}

ARCH=x86_64
CROSS_COMPILE=x86_64-unknown-linux-gnu-

export PATH=/usr/local/x64/bin:$PATH

if [ ! -f "$LINUX_SOURCE" ]; then
   wget ${MIRROR}/${LINUX_SOURCE}
fi

if [ ! -f "$CONFIG" ]; then
   wget ${MIRROR}/${CONFIG}
fi

[ -d "$LINUX_DIR" ] && sudo rm -rf $LINUX_DIR

tar -xf $LINUX_SOURCE

cd $LINUX_DIR

cp ../${CONFIG} .config

make ARCH=$ARCH CROSS_COMPILE=$CROSS_COMPILE oldconfig

make ARCH=$ARCH CROSS_COMPILE=$CROSS_COMPILE modules_prepare



