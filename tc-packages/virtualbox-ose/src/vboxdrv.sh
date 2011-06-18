#!/bin/sh

TCUSER=$(cat /etc/sysconfig/tcuser)
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:$PATH
DEVICE=/dev/vboxdrv

[ -f /usr/local/etc/vbox/vbox.cfg ] && . /usr/local/etc/vbox/vbox.cfg

if [ -n "$INSTALL_DIR" ]; then
    VBOXMANAGE="$INSTALL_DIR/VBoxManage"
else
    VBOXMANAGE="/usr/local/lib/virtualbox/VBoxManage"
fi

start(){
   echo "Starting VirtualBox kernel modules"
   if [ "$(lsmod | grep vboxnetadp)" ]; then
      echo "vboxnetadp already loaded"
   else
      if [ "$(lsmod | grep vboxnetflt)" ]; then
         echo "vboxnetflt already loaded"
      else
         if [ "$(lsmod | grep vboxdrv)" ]; then
            echo "vboxdrv already loaded"
         else
            modprobe vboxdrv || { echo "vboxdrv failed"; exit 1; }
         fi
         modprobe vboxnetflt || echo "vboxnetflt failed"
      fi
      modprobe vboxnetadp || echo "vboxnetadp failed"
   fi

   if ! chown :root $DEVICE 2>/dev/null; then
       rmmod vboxnetadp 2>/dev/null
       rmmod vboxnetflt 2>/dev/null
       rmmod vboxdrv 2>/dev/null
       echo "Cannot change group root for device $DEVICE"
   fi

   if grep -q usb_device /proc/devices; then
       mkdir -p -m 0750 /dev/vboxusb 2>/dev/null
       chown root:vboxusers /dev/vboxusb 2>/dev/null
   fi

}

stop(){
   echo "Stopping VirtualBox kernel modules"
   rmmod vboxnetadp && rmmod vboxnetflt && rmmod vboxdrv
   if [ $? != 0 ]; then
      echo "Could not remove modules. Is there a VM still running?"
      exit 1
   else
      exit 0
   fi
}

status(){
   if [ "$(lsmod | grep vboxdrv)" ]; then
      if [ "$(lsmod | grep vboxnetflt)" ]; then
         if [ "$(lsmod | grep vboxnetadp)" ]; then
            echo "All kernel modules loaded"
         else
            echo "vboxdrv and vboxnetflt loaded"
         fi
      else
         echo "vboxdrv loaded"
      fi
      if [ -d /tmp/.vbox-${TCUSER}-ipc ]; then
         export VBOX_IPC_SOCKETID="${TCUSER}"
         VMS=$($VBOXMANAGE --nologo list runningvms | sed -e 's/^".*".*{\(.*\)}/\1/' 2>/dev/null)
         if [ -n "${VMS}" ]; then
            echo "These VMs are currently running:"
            for each in ${VMS}; do
               echo "  ${each}"
            done
         fi
      fi
   else
      echo "VBox modules not loaded"
   fi
}

case $1 in
start)
   start
   ;;
stop)
   stop
   ;;
restart)
   stop
   sleep 1
   start
   ;;
force-reload)
   stop
   start
   ;;
setup)
   setup
   ;;
status)
   status
   ;;
*)
   echo "Usage: $0 {start:stop:restart:force-reload:status}"
   exit 1
esac
exit 0
