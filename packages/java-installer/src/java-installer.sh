#!/bin/sh
#
#  Java installer for Tiny Core Linux
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
#  Copyright (c) 2012 Sercan Arslan <arslanserc@gmail.com>
#

THIS=`basename $0`

if [ `id -u` -ne 0 ] ; then
     echo "You need to run $THIS as root!"
     exit 1
fi

HERE="$PWD"
LOG=/tmp/${THIS}.log
TCUSER=$(cat /etc/sysconfig/tcuser)
TCEDIR=/etc/sysconfig/tcedir

JAVA_INSTALLER_SRC=/usr/local/java-installer

# java architecture
ARCH=i586
# java version
VER=7
[ -z "$UPD" ] && UPD=7
# extensions to be created
JRE="jre7"
JDK="jdk7"

TMPDIR="/usr/local/src/java"
if [ "$UPD" -lt 10 ]; then
  WRKDIR="jdk1.7.0_0${UPD}"
else
  WRKDIR="jdk1.7.0_${UPD}"
fi
SOURCE="jdk-${VER}u${UPD}-linux-${ARCH}.tar.gz"
SITE=http://www.oracle.com/technetwork/java/javase/downloads/index.html

JRE_ROOT="$TMPDIR/$JRE"
JDK_ROOT="$TMPDIR/$JDK"

clear

echo ""
echo "========================================================================"
echo ""
echo "Java installer for Tiny Core Linux"
echo "by Sercan Arslan <arslanserc@gmail.com>"
echo ""
echo "========================================================================"
echo ""
echo "Before proceeding You must download $SOURCE"
echo "from $SITE"
echo "to $HERE"
echo ""
read key

if [ ! -e "$HERE/$SOURCE" ]; then
  echo "$SOURCE not found! exiting ..."
  exit 1
fi

build_clean() {

   [ -d $TMPDIR ] && sudo rm -r $TMPDIR

   return 0
}

build_unpack() {

   [ -d $TMPDIR ] && rm -rf $TMPDIR
   mkdir -p $TMPDIR

   tar xf $HERE/$SOURCE -C $TMPDIR || return 1

   return 0
}

build_create() {

  cd $TMPDIR/$WRKDIR

  # main files for jre
  mkdir -p ${JRE_ROOT}/usr/local/java
  cp -R jre ${JRE_ROOT}/usr/local/java || return 1

  # profiles
  install -D ${JAVA_INSTALLER_SRC}/jre.profile ${JRE_ROOT}/etc/profile.d/jre.sh

  # java mozilla plugin
  mkdir -p ${JRE_ROOT}/usr/local/lib/mozilla/plugins
  ln -s /usr/local/java/jre/lib/i386/libnpjp2.so ${JRE_ROOT}/usr/local/lib/mozilla/plugins

  # install icons and desktop entries
  install -d -m 755 ${JRE_ROOT}/usr/local/share
  cp -r jre/lib/desktop/icons ${JRE_ROOT}/usr/local/share
  cp -r jre/lib/desktop/applications ${JRE_ROOT}/usr/local/share
  cp -r jre/lib/desktop/mime ${JRE_ROOT}/usr/local/share
  install -m644 ${JAVA_INSTALLER_SRC}/java-policy-settings.desktop ${INSTALL_ROOT}/usr/local/share/applications/java-policy-settings.desktop

  install -m 755 ${JAVA_INSTALLER_SRC}/javaws-launcher ${JRE_ROOT}/usr/local/java/jre/bin
  sed -e 's/Exec=javaws/&-launcher %f/' \
      -e '/NoDisplay=true/d' \
      -i ${INSTALL_ROOT}/usr/local/share/applications/sun-javaws.desktop

  # remove unneccessary files
  rm -r $JRE_ROOT/usr/local/java/jre/lib/desktop
  rm -r $JRE_ROOT/usr/local/java/jre/plugin/desktop

  # tce install script
  install -Dm 775 $JAVA_INSTALLER_SRC/tce.installed.jre $JRE_ROOT/usr/local/tce.installed/$JRE
  chmod -R 775 $JRE_ROOT/usr/local/tce.installed
  chown -R root:staff $JRE_ROOT/usr/local/tce.installed

  # main files for jdk
  mkdir -p ${JDK_ROOT}/usr/local/java
  cp -R . ${JDK_ROOT}/usr/local/java || return 1

  install -Dm644 jre/lib/desktop/icons/hicolor/48x48/apps/sun-java.png ${JDK_ROOT}/usr/local/share/pixmaps/java.png
  install -Dm644 ${JAVA_INSTALLER_SRC}/java-monitoring-and-management-console.desktop ${JDK_ROOT}/usr/local/share/applications/java-monitoring-and-management-console.desktop
  install -Dm644 ${JAVA_INSTALLER_SRC}/java-visualvm.desktop ${JDK_ROOT}/usr/local/share/applications/java-visualvm.desktop

  # profiles
  install -D ${JAVA_INSTALLER_SRC}/jdk.profile ${JDK_ROOT}/etc/profile.d/jdk.sh

  # javadb (apache derby) daemon files
  install -D ${JAVA_INSTALLER_SRC}/derby-network-server.sh ${JDK_ROOT}/usr/local/etc/init.d/derby-network-server
  install -D -m644 ${JAVA_INSTALLER_SRC}/derby-network-server.conf ${JDK_ROOT}/usr/local/etc/conf.d/derby-network-server

  # remove unneccessary files
  rm -r $JDK_ROOT/usr/local/java/jre
  rm -r $JDK_ROOT/usr/local/java/lib/desktop
  rm -r $JDK_ROOT/usr/local/java/src.zip
  find $JDK_ROOT/usr/local/java -name '*\.bat' -delete

  # tce install script
  install -Dm 775 $JAVA_INSTALLER_SRC/tce.installed.jdk $JDK_ROOT/usr/local/tce.installed/$JDK
  chmod -R 775 $JDK_ROOT/usr/local/tce.installed
  chown -R root:staff $JDK_ROOT/usr/local/tce.installed

  cd $TMPDIR
  mksquashfs $JRE $JRE.tcz || return 1
  md5sum $JRE.tcz > $JRE.tcz.md5.txt
  cd $JRE
  find -not -type d > ../$JRE.tcz.list
  cd ..

  mksquashfs $JDK $JDK.tcz || return 1
  md5sum $JDK.tcz > $JDK.tcz.md5.txt
  echo "$JRE.tcz" > $JDK.tcz.dep
  cd $JDK
  find -not -type d > ../$JDK.tcz.list
  cd ..

  return 0
}

build_install() {

 cd $TMPDIR

 for EXTNAM in $JRE $JDK
 do
   if [ -e "$TCEDIR/optional/$EXTNAM.tcz" -a -e "/usr/local/tce.installed/$EXTNAM" ]
   then
        [ -d "$TCEDIR/optional/upgrade" ] || mkdir -p "$TCEDIR/optional/upgrade"
        cp -f $EXTNAM.tcz* $TCEDIR/optional/upgrade || return 1
   else
        cp -f $EXTNAM.tcz* $TCEDIR/optional || return 1
   fi
 done

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

echo ""
echo "For JAVA to be in PATH You must relogin or reboot after adding it to your onboot list."
echo ""

exit 0
