#!/bin/bash
START_HAPROXY="/etc/rc.d/init.d/haproxy start"
STOP_HAPROXY="/etc/rc.d/init.d/haproxy stop"
LOG_FILE="/usr/local/keepalived/log/haproxy-check.log"
HAPS=`ps -C haproxy --no-header |wc -l`
date "+%Y-%m-%d %H:%M:%S" >> $LOG_FILE
echo "check haproxy status" >> $LOG_FILE
if [ $HAPS -eq 0 ];then
 echo $START_HAPROXY >> $LOG_FILE
 $START_HAPROXY >> $LOG_FILE 2>&1
 sleep 3
 if [ `ps -C haproxy --no-header |wc -l` -eq 0 ];then
 echo "start haproxy failed, killall keepalived" >> $LOG_FILE
 killall keepalived
 fi
fi
