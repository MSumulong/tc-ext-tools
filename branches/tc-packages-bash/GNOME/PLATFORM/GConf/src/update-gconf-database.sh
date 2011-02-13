#!/bin/sh
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
#  Update GConf Database for Tiny Core Linux
#
#  Sercan Arslan <arslanserc@gmail.com>
#

. /etc/init.d/tc-functions

check_for_root() {
   if [ "$(id -u)" -ne 0 ] ; then
	echo "${RED}You need to run me as root!${NORMAL}"
	exit 1
   fi
}

SYS_CONF_DIR=/usr/local/etc
SCHEMAS_DIR=${SYS_CONF_DIR}/gconf/schemas
GCONFTOOL=/usr/local/bin/gconftool-2
GCONF_CONFIG_SOURCE=$(gconftool-2 --get-default-source)

export GCONF_CONFIG_SOURCE

INPUT="$2"

print_usage() {
cat << _EOF
Usage:
	sudo update-gconf-database register-extension name (if the extension "name" is mounted)
	sudo update-gconf-database register /full/path/to/name.schemas
	sudo update-gconf-database register name (if the name.schemas is in in /usr/local/etc/gconf/schemas)
	sudo update-gconf-database register-list "/full/path/to/name1.schemas /full/path/to/name2.schemas"
	sudo update-gconf-database register-list "name1 name2" (if the name1.schemas and name2.schemas are in in /usr/local/etc/gconf/schemas)
	sudo update-gconf-database register-all (all schemas in /usr/local/etc/gconf/schemas)

	And the same for unregister.

_EOF
}

register() {
   if [ -z "$INPUT" ]; then
           print_usage
	   exit 1
   fi

   if [ -f "${INPUT}" ]; then
           echo -e "${BLUE}Registering $INPUT ... \c${NORMAL}"
	   $GCONFTOOL --makefile-install-rule $INPUT > /dev/null 2>&1 || return 1
	   echo -e "${YELLOW}done!${NORMAL}"
   elif [ -f ${SCHEMAS_DIR}/${INPUT}.schemas ]; then
           echo -e "${BLUE}Registering $INPUT ... \c${NORMAL}"
	   $GCONFTOOL --makefile-install-rule ${SCHEMAS_DIR}/${INPUT}.schemas > /dev/null 2>&1 || return 1
	   echo -e "${YELLOW}done!${NORMAL}"
   else
           print_usage
   fi

   return 0
}

unregister() {
   if [ -z "$INPUT" ]; then
           print_usage
           exit 1
   fi

   if [ -f "${INPUT}" ]; then
           echo -e "${BLUE}Unregistering $INPUT ... \c${NORMAL}"
	   $GCONFTOOL --makefile-uninstall-rule $INPUT > /dev/null 2>&1 || return 1
	   echo -e "${YELLOW}done!${NORMAL}"
   elif [ -f ${SCHEMAS_DIR}/${INPUT}.schemas ]; then
           echo -e "${BLUE}Unregistering ${SCHEMAS_DIR}/${INPUT}.schemas ... \c${NORMAL}"
	   $GCONFTOOL --makefile-uninstall-rule $INPUT > /dev/null 2>&1 || return 1
	   echo -e "${YELLOW}done!${NORMAL}"
   else
           print_usage
   fi

   return 0
}

register_list() {
	if [ -z "$INPUT" ]; then
	     print_usage
	     exit 1
	fi

	for i in ${INPUT}
	do
	    if [ -f "${i}" ]; then
	         echo -e "${BLUE}Registering $i ... \c${NORMAL}"
	         $GCONFTOOL --makefile-install-rule $i > /dev/null 2>&1 || return 1
	         echo -e "${YELLOW}done!${NORMAL}"
	    elif [ -f "${SCHEMAS_DIR}/${i}.schemas" ]; then
	           echo -e "${BLUE}Registering $i ... \c${NORMAL}"
	           $GCONFTOOL --makefile-install-rule ${SCHEMAS_DIR}/${i}.schemas > /dev/null 2>&1 || return 1
	           echo -e "${YELLOW}done!${NORMAL}"
	    fi
	done

   return 0
}

unregister_list() {
	if [ -z "$INPUT" ]; then
	     print_usage
	     exit 1
	fi

	for i in ${INPUT}
	do
	    if [ -f "${i}" ]; then
	         echo -e "${BLUE}Unregistering $i ... \c${NORMAL}"
	         $GCONFTOOL --makefile-uninstall-rule $i > /dev/null 2>&1 || return 1
	         echo -e "${YELLOW}done!${NORMAL}"
	    elif [ -f ${SCHEMAS_DIR}/${i}.schemas ]; then
	           echo -e "${BLUE}Unregistering $i ... \c${NORMAL}"
	           $GCONFTOOL --makefile-uninstall-rule ${SCHEMAS_DIR}/${i}.schemas > /dev/null 2>&1 || return 1
	           echo -e "${YELLOW}done!${NORMAL}"
	    fi
	done
   return 0
}

register_all() {
	echo "${RED}Updating GConf database, this may take a few minutes please wait ...${NORMAL}"

	SCHEMAS_FILES=$(find $SYS_CONF_DIR/gconf -name *.schemas 2> /dev/null)
	if [ -n "$SCHEMAS_FILES" ] ; then
	     for SCHEMAS_FILE in $SCHEMAS_FILES
	     do
		 echo -e "${BLUE}Registering $SCHEMAS_FILE ... \c${NORMAL}"
		 $GCONFTOOL --makefile-install-rule $SCHEMAS_FILE > /dev/null 2>&1 || return 1
		 echo -e "${YELLOW}done!${NORMAL}"
	     done
	fi

	ENTRIES_FILES=$(find $SYS_CONF_DIR/gconf -name *.entries 2> /dev/null)
	if [ -n "$ENTRIES_FILES" ] ; then
	     for ENTRIES_FILE in $ENTRIES_FILES
	     do
		 echo -e "${CYAN}Registering $ENTRIES_FILE ... \c${NORMAL}"
		 $GCONFTOOL --config-source=xml:readwrite:$SYS_CONF_DIR/gconf/gconf.xml.defaults --direct --load $ENTRIES_FILE > /dev/null 2>&1 || return 1
		 echo -e "${YELLOW}done!${NORMAL}"
	     done
	fi

	echo -e "${RED}All done!${NORMAL}"

   return 0
}

unregister_all() {
	echo "${RED}Updating GConf database, this may take a few minutes please wait ...${NORMAL}"
	
	SCHEMAS_FILES=$(find $SYS_CONF_DIR/gconf -name *.schemas 2> /dev/null)
	if [ -n "$SCHEMAS_FILES" ] ; then
	     for SCHEMAS_FILE in $SCHEMAS_FILES
	     do
		 echo -e "${BLUE}Unregistering $SCHEMAS_FILE ... \c${NORMAL}"
		 $GCONFTOOL --makefile-uninstall-rule $SCHEMAS_FILE > /dev/null 2>&1 || return 1
		 echo "${YELLOW}done!${NORMAL}"
	     done
	fi

	echo -e "${RED}All done!${NORMAL}"

   return 0
}

register_extension() {
	if [ -z "$INPUT" ]; then
	     print_usage
	     exit 1
	fi

	if [ ! -d "/tmp/tcloop/${INPUT}" ]; then
	     echo -e "${RED}The extenion ${INPUT} must be mounted to use this feature.${NORMAL}"
	     exit 1
	fi

	echo -e "${RED}Registering the extension ${INPUT} ...${NORMAL}"

	SCHEMAS_FILES=$(find /tmp/tcloop/${INPUT}${SYS_CONF_DIR}/gconf -name *.schemas 2> /dev/null)
	if [ -n "$SCHEMAS_FILES" ] ; then
	     for SCHEMAS_FILE in $SCHEMAS_FILES
	     do
		 echo -e "${BLUE}Registering $SCHEMAS_FILE ... \c${NORMAL}"
		 $GCONFTOOL --makefile-install-rule $SCHEMAS_FILE > /dev/null 2>&1 || return 1
		 echo "${YELLOW}done!${NORMAL}"
	     done
	fi

	echo -e "${RED}All done!${NORMAL}"

   return 0	
}

unregister_extension() {
	if [ -z "$INPUT" ]; then
	     print_usage
	     exit 1
	fi

	if [ ! -d "/tmp/tcloop/${INPUT}" ]; then
	     echo -e "${RED}The extenion ${INPUT} must be mounted to use this feature.${NORMAL}"
	     exit 1
	fi

	echo -e "${RED}Unregistering the extension ${INPUT} ...${NORMAL}"

	SCHEMAS_FILES=$(find /tmp/tcloop/${INPUT}${SYS_CONF_DIR}/gconf -name *.schemas 2> /dev/null)
	if [ -n "$SCHEMAS_FILES" ] ; then
	     for SCHEMAS_FILE in $SCHEMAS_FILES
	     do
		 echo -e "${BLUE}Unregistering $SCHEMAS_FILE ... \c${NORMAL}"
		 $GCONFTOOL --makefile-uninstall-rule $SCHEMAS_FILE > /dev/null 2>&1 || return 1
		 echo "${YELLOW}done!${NORMAL}"
	     done
	fi

	echo -e "${RED}All done!${NORMAL}"

   return 0
}

adjust_backup_list() {
   if [ "X$(grep 'usr/local/etc/gconf/gconf.xml.defaults' /opt/.filetool.lst)" = "X" ]
   then
        echo -e "${RED}It seems you do not have gconf.xml.defaults directory listed in your backup.${NORMAL}"
        echo -e "${GREEN}Do you wish to add it to your backup list ? [y][n]${NORMAL}"
        read ans
        case $ans in
               y|Y|yes|YES)
                          echo -e "usr/local/etc/gconf/gconf.xml.defaults" >> /opt/.filetool.lst
                          ;;
               n|N|No|NO)
                          echo -e "{RED}As you wish!${NORMAL}"
                          ;;
               *)
                          ;;
        esac
   fi
}

case "$1" in
	register)
		check_for_root
		register
		;;
	register-list)
		check_for_root
		register_list
		;;
	register-all)
		check_for_root
		register_all
		;;
	unregister)
		check_for_root
		unregister
		;;
	unregister-list)
		check_for_root
		unregister_list
		;;
	unregister-all)
		check_for_root
		unregister_all
		;;
	register-extension)
		check_for_root
		register_extension
		;;
	unregister-extension)
		check_for_root
		unregister_extension
		;;
	*)
		print_usage
		;;
esac

exit 0

