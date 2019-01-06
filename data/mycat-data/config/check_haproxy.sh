#!/bin/bash
STARTHAPROXY="/usr/sbin/haproxy -f /etc/haproxy/haproxy.cfg"
#STOPKEEPALIVED="/etc/init.d/keepalived stop"
STOPKEEPALIVED="/usr/bin/systemctl stop keepalived"
LOGFILE="/var/log/keepalived-haproxy-state.log"
echo "[check_haproxy status]" >> $LOGFILE
A=`ps -C haproxy --no-header |wc -l`
echo "[check_haproxy status]" >> $LOGFILE
date >> $LOGFILE
if [ $A -eq 0 ];then
   echo $STARTHAPROXY >> $LOGFILE
   $STARTHAPROXY >> $LOGFILE 2>&1
   sleep 5
fi
if [ `ps -C haproxy --no-header |wc -l` -eq 0 ];then
   exit 0
else
   exit 1
fi
