#!/bin/sh

tcuser=$(cat /etc/sysconfig/tcuser)

start(){
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
}

stop(){
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
      if [ -d /tmp/.vbox-${tcuser}-ipc ]; then
         export VBOX_IPC_SOCKETID="${tcuser}"
         VMS=$(VBoxManage --nologo list runningvms | sed -e 's/^".*".*{\(.*\)}/\1/' 2>/dev/null)
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
   stop && start
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
