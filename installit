#!/bin/sh
#
#  install.sh: install tc-ext-tools to your system
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
#  (C) Copyright 2010 Sercan Arslan
#

if [ ! -e .config ]; then
     echo "You need to create a user config file!"
     echo "See INSTALL for details."
     exit 1
else
     . .config
fi

USER=$(cat /etc/sysconfig/tcuser)

[ -z "$DESTDIR" ] && DESTDIR="$HOME"/.local

BINDIR="$DESTDIR"/bin
SYSCONFDIR="$DESTDIR"/etc
DATADIR="$DESTDIR"/share

[ -d "$BINDIR" ] || install -m 755 -d $BINDIR

for tool in tools/*
do
    install -m 755 $tool $BINDIR
done

[ -d "$SYSCONFDIR"/tc-ext-tools ] && sudo rm -rf "$SYSCONFDIR"/tc-ext-tools
install -m 755 -d "$SYSCONFDIR"/tc-ext-tools

for f in default/config default/functions
do
    install -m 644 $f "$SYSCONFDIR"/tc-ext-tools
done

[ -d "$DATADIR"/tc-ext-tools ] && sudo rm -rf "$DATADIR"/tc-ext-tools
install -m 755 -d "$DATADIR"/tc-ext-tools

install -m 644 default/build "$DATADIR"/tc-ext-tools

[ -d "$HOME"/.tc-ext-tools ] || install -m 755 -d -o $USER -g staff "$HOME"/.tc-ext-tools
install -m 644 -o $USER -g staff .config "$HOME"/.tc-ext-tools/config

[ -d "$TCEXTTOOLS_STORAGE" ] || sudo install -m 755 -d -o $USER -g staff "$TCEXTTOOLS_STORAGE"
