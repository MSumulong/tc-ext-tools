#!/bin/sh

############################################################################
#                                                                          #
#             install.sh: Installs tc-ext-tools to your system             #
#                                                                          #
############################################################################

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
#  (C) Copyright 2011 Sercan Arslan
#

if [ ! -e .config ]; then
     echo "You need to create a user config file!"
     echo "See INSTALL for details."
     exit 1
else
     . .config
fi

TCUSER=$(cat /etc/sysconfig/tcuser)

[ -z "$DESTDIR" ] && DESTDIR="$HOME/.local"

BINDIR="$DESTDIR/bin"
SYSCONFDIR="$DESTDIR/etc"
DATADIR="$DESTDIR/share"

[ -d "$BINDIR" ] || install -m 755 -d "$BINDIR"

for tool in tools/*
do
    install -m 755 "$tool" "$BINDIR"
done

install -D -m 644 default/config "$SYSCONFDIR/conf.d/tc-ext-tools.conf"
install -D -m 755 default/functions "$SYSCONFDIR/init.d/tc-ext-tools.sh"

[ -d "$DATADIR/tc-ext-tools" ] && sudo rm -rf "$DATADIR/tc-ext-tools"
install -m 755 -d "$DATADIR/tc-ext-tools"

install -m 644 default/build "$DATADIR/tc-ext-tools"

install -D -m 644 -o "$TCUSER" -g staff .config "$HOME/.config/tc-ext-tools.conf"

