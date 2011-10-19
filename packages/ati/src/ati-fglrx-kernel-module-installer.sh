#!/bin/sh
#
#  AMD/ATI Linux Drivers fglrx kernel module installer for Tiny Core Linux
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License along
#  with this program; if not, write to the Free Software Foundation, Inc.,
#  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
#  Copyright (c) 2010 Sercan Arslan <arslanserc@gmail.com>
#

THIS=`basename $0`

if [ `id -u` -ne 0 ] ; then
     echo "You need to run $THIS as root!"
     exit 1
fi

LOG=/tmp/${THIS}.log
TCUSER=$(cat /etc/sysconfig/tcuser)
TCEDIR=$(cat /opt/.tce_dir)
KERNEL=$(uname -r)

if [ -z "$(echo $KERNEL | grep 64)" ]
then
        ARCH=x86
        CC=gcc
        LD=ld
else
        ARCH=x86_64
        CROSS_COMPILE=x86_64-unknown-linux-gnu-
        CC=${CROSS_COMPILE}gcc
        LD=${CROSS_COMPILE}ld
        export PATH="/usr/local/x64/bin:$PATH"
fi

EXTNAM="ati-fglrx-module-$KERNEL"
TMPDIR="/usr/local/src/fglrx-build"
INSTALL_ROOT="$TMPDIR/$EXTNAM"
WRKDIR="fglrx/build_mod"
SOURCE="/usr/local/src/fglrx-kernel-source.tar.xz"
LICENSE="/usr/local/share/doc/ati-fglrx-kernel-source/ATI_LICENSE.TXT"

clear

echo ""
echo "========================================================================"
echo ""
echo "AMD/ATI Linux Drivers fglrx kernel module installer for Tiny Core Linux"
echo "by Sercan Arslan <arslanserc@gmail.com>"
echo ""
echo "========================================================================"
echo ""
echo "Before proceeding You must agree with the terms of ATI LICENSE."
echo "Press enter to read the license"
read key

cat "$LICENSE"
echo ""
echo "Do you accept the license ? (y)es or (n)o, then press enter"
read answer

case "$answer" in
        "y" | "Y") LICENSE_ACCEPTED=1;;
        "yes" | "Yes") LICENSE_ACCEPTED=1;;
        "YES") LICENSE_ACCEPTED=1;;
        "n" | "N") LICENSE_ACCEPTED=0;;
        "no" | "No") LICENSE_ACCEPTED=0;;
        "NO") LICENSE_ACCEPTED=0;;
        *) LICENSE_ACCEPTED=0;;		
esac

if [ "$LICENSE_ACCEPTED" = 0 ]
then
     echo "You must accept the license to continue !"
     exit 1
fi

build_clean() {

   [ -d $TMPDIR ] && sudo rm -r $TMPDIR

   return 0
}

build_unpack() {

   [ -d $TMPDIR ] && rm -rf $TMPDIR
   mkdir -p $TMPDIR

   tar xf $SOURCE -C $TMPDIR || return 1

   return 0
}

build_compile() {

   cd $TMPDIR/$WRKDIR

   cp libfglrx_ip.a.${ARCH} libfglrx_ip.a

   if [ "$ARCH" = x86_64 ]; then
        make CC=$CC LD=$LD GCC_VER_MAJ=4 SMP=1 PAGE_ATTR_FIX=0 COMPAT_ALLOC_USER_SPACE=compat_alloc_user_space || return 1
   else
        ./make.sh || return 1
   fi

   return 0
}

build_create() {

   cd $TMPDIR/$WRKDIR

   mkdir -p $INSTALL_ROOT/usr/local/lib/modules/${KERNEL}/kernel/drivers/video
   mkdir -p $INSTALL_ROOT/usr/local/share/doc/$EXTNAM

   if [ "$ARCH" = x86_64 ]; then
        cp fglrx.ko $INSTALL_ROOT/usr/local/lib/modules/${KERNEL}/kernel/drivers/video || return 1
   else
        cp 2.6.x/fglrx.ko $INSTALL_ROOT/usr/local/lib/modules/${KERNEL}/kernel/drivers/video || return 1
   fi

   gzip $INSTALL_ROOT/usr/local/lib/modules/${KERNEL}/kernel/drivers/video/fglrx.ko

   cp $LICENSE $INSTALL_ROOT/usr/local/share/doc/$EXTNAM

   cd $TMPDIR

   find $EXTNAM -type d | xargs chmod 755

   mksquashfs $EXTNAM $EXTNAM.tcz || return 1

   md5sum $EXTNAM.tcz > $EXTNAM.tcz.md5.txt

   echo "graphics-${KERNEL}.tcz" > $EXTNAM.tcz.dep

   return 0
}

build_install() {

   cd $TMPDIR

   if [ -e "$TCEDIR/optional/$EXTNAM.tcz" ]
   then
        [ -d "$TCEDIR/optional/upgrade" ] || mkdir -p "$TCEDIR/optional/upgrade"
        cp -f $EXTNAM.tcz* $TCEDIR/optional/upgrade
   else
        cp -f $EXTNAM.tcz* $TCEDIR/optional
   fi

   if [ ! -e "/usr/local/tce.installed/$EXTNAM" ]
   then
        mv -f $TCEDIR/optional/upgrade/$EXTNAM.tcz* $TCEDIR/optional
        su $TCUSER -c "tce-load -w graphics-${KERNEL}.tcz"
        su $TCUSER -c "tce-load -i $EXTNAM.tcz" || return 1
   else
        echo "$EXTNAM is already installed !"
        echo "You must reboot to use your new extensions !"
        return 1
   fi

   return 0
}

echo -e "Cleaning ... \c"
build_clean > $LOG 2>&1
if [ "$?" -gt 0 ]
then
     echo "failed !"
     echo "See $LOG for details"
     exit 1
else
    echo "successful ! "
fi

echo -e "Unpacking ... \c"
build_unpack > $LOG 2>&1
if [ "$?" -gt 0 ]
then
     echo "failed !"
     echo "See $LOG for details"
     exit 1
else
    echo "successful ! "
fi

echo -e "Compiling ... \c"
build_compile > $LOG 2>&1
if [ "$?" -gt 0 ]
then
     echo "failed !"
     echo "See $LOG for details"
     exit 1
else
    echo "successful ! "
fi

echo -e "Creating ... \c"
build_create > $LOG 2>&1
if [ "$?" -gt 0 ]
then
     echo "failed !"
     echo "See $LOG for details"
     exit 1
else
    echo "successful ! "
fi

echo -e "Installing ... \c"
build_install > $LOG 2>&1
if [ "$?" -gt 0 ]
then
     echo "failed !"
     echo "See $LOG for details"
     exit 1
else
    echo "successful ! "
fi

echo "Congratulations, All Done !"
