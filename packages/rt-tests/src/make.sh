#!/bin/sh

#
# rt-tests backfire kernel module build script
#
# by Sercan Arslan <arslanserc@gmail.com>
#

if [ -z "$KERNEL" ]; then
   KERNEL=`uname -r`
fi

if [ -z "$ARCH" ]; then
   if [ "$KERNEL" = "${KERNEL%64}" ]; then
      ARCH=x86
   else
      ARCH=x86_64
   fi
fi

if [ -z "$CROSS_COMPILE" ]; then
     CROSS_COMPILE="x86_64-unknown-linux-gnu-"
fi

if [ -z "$LINUX_BUILD" ]; then
   LINUX_BUILD="/lib/modules/`uname -r`/build"
fi

if [ "$ARCH" = "x86_64" ]; then
   make ARCH=x86_64 CROSS_COMPILE="$CROSS_COMPILE" -C "$LINUX_BUILD" M="$PWD" modules
elif [ "$ARCH" = "x86" ]; then
   make -C "$LINUX_BUILD" M="$PWD" modules
else
   make ARCH="$ARCH" CROSS_COMPILE="$CROSS_COMPILE" -C "$LINUX_BUILD" M="$PWD" modules
fi

[ -f backfire.ko ] || echo "Build failed"

echo "Now creating the extension"
install -Dm755 backfire.ko "pkg/usr/local/lib/modules/${KERNEL}/kernel/extra/backfire.ko"
mksquashfs pkg "rt-tests-backfire-${KERNEL}.tcz"

if [ "$KERNEL" = "$(uname -r)" ]; then
   TCE_DIR=`cat /opt/.tce_dir`
   if [ -f "${TCE_DIR}/optional/rt-tests-backfire-${KERNEL}.tcz" ]; then
      mkdir "${TCE_DIR}/optional/upgrade"
      cp "rt-tests-backfire-${KERNEL}.tcz" "${TCE_DIR}/optional/upgrade"
      echo "Reboot to use your new extension"
   else
      cp "rt-tests-backfire-${KERNEL}.tcz" "${TCE_DIR}/optional"
      echo "Copied to your tce dir, to load it execute:"
      echo "tce-load -i rt-tests-backfire-${KERNEL}.tcz"
   fi
else
   echo "Here is your extension: rt-tests-backfire-${KERNEL}.tcz"
fi

