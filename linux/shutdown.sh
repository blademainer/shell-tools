#!/bin/sh

PROCESS='tomcat'
export PROCESS

if [ -z "$PROCESS" ]; then
    echo "YOU SHOULD SET PROCESS ID"
    exit 1;
else
    echo "SHUTTING DOWN                    ["$PROCESS"]"
    echo `ps aux |grep "$PROCESS"`

    PROCESSLINE_CMD=`ps aux|grep "$PROCESS"|awk '{if($11!~/grep/) print $2}'|wc -l`
    if [ "${PROCESSLINE_CMD}" -gt 0 ]; then
      pid=`ps aux|grep "$PROCESS"|awk '{if($11!~/grep/) print $2}'`      
      
      echo "kill -9 "$pid
      echo "------[Y/N]?--------"  
      read answer
      if [ "$answer" = "Y" ] ; then
         kill -9 $pid
      else
        echo "EXIT,DO NOTHING"
        exit 0;
      fi      
      
    else
      echo "NOT ANY PROCESS FOUND"
    fi

    echo ""
    echo ""
fi
