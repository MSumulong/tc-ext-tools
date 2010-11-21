if [ $LIBGL_DRIVERS_PATH ] 
then 
  if ! set | grep LIBGL_DRIVERS_PATH | grep /usr/local/lib/X11/modules/dri/ > /dev/null 
  then 
    LIBGL_DRIVERS_PATH=$LIBGL_DRIVERS_PATH:/usr/local/lib/X11/modules/dri/ 
    export LIBGL_DRIVERS_PATH 
  fi  
else 
  LIBGL_DRIVERS_PATH=/usr/local/lib/X11/modules/dri/ 
  export LIBGL_DRIVERS_PATH 
fi 
