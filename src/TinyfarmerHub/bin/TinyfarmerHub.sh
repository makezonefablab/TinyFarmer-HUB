#!/bin/bash

########################################################
# author : kim myung soo
# create : 2016.04.26
# desc   : TinyfarmerHub  startup / shutdown
# Usage  : TinyfarmerHub.sh start/stop
# daemon.ServerDaemon start >> ${LOG_HOME}/Service_${TODAY}.log 2>&1 &
# daemon.ServerDaemon shutdown >> ${LOG_HOME}/Service_${TODAY}.log 2>&1 &
# daemon.ServerDaemon start 2>&1 | tee -a ${LOG_HOME}/Service_${TODAY}.log &
# daemon.ServerDaemon shutdown 2>&1 | tee -a ${LOG_HOME}/Service_${TODAY}.log &
########################################################

TODAY=`date "+%Y-%m-%d"`

JAVA_HOME=/usr/lib/jvm/jdk-8-oracle-arm32-vfp-hflt
USER_NAME=root
SERVICE_NAME=TinyfarmerHub
SERVICE_HOME=/home/mediaflow/$SERVICE_NAME
LOG_HOME=$SERVICE_HOME/logs

ID=`whoami | awk '{print $1}'`

if [ $USER_NAME != $ID ]
then
echo "TinyfarmerHub $1 Error : User Validateion is failed. This instance \
has been started as \"$ID\", actual script owner is \"$USER_NAME\"." 
exit
fi

if [ $# != 1 ]
then
echo "TinyfarmerHub StartUp/Shutdown Error : Please input 'start/stop' \
Usage TinyfarmerHub.sh start/stop."
exit
fi

PID=`ps -ef|grep java|grep ${SERVICE_NAME}|awk '{print $2}'`

if [ "$PID" != "" -a $1 = "start" ]
then
echo "TinyfarmerHub StartUp  Error : \"${SERVICE_NAME}\" is already StartUp !"
exit
fi

if [ "$PID" = "" -a $1 = "stop" ]
then
echo "TinyfarmerHub Shutdown Error : \"${SERVICE_NAME}\" is yet to StartUp !"
exit
fi

CLASSPATH=\
$SERVICE_HOME/classes:\
$SERVICE_HOME/classes/config:\
$SERVICE_HOME/libs/commons-beanutils-1.8.0.jar:\
$SERVICE_HOME/libs/commons-collections-3.2.1.jar:\
$SERVICE_HOME/libs/commons-configuration-1.6.jar:\
$SERVICE_HOME/libs/commons-digester-2.0.jar:\
$SERVICE_HOME/libs/commons-io-1.4.jar:\
$SERVICE_HOME/libs/commons-lang-2.4.jar:\
$SERVICE_HOME/libs/commons-logging-1.1.1.jar:\
$SERVICE_HOME/libs/httpclient-4.4.1.jar:\
$SERVICE_HOME/libs/httpcore-4.4.1.jar:\
$SERVICE_HOME/libs/jackson-annotations-2.7.0.jar:\
$SERVICE_HOME/libs/jackson-core-2.7.0.jar:\
$SERVICE_HOME/libs/jackson-databind-2.7.0.jar:\
$SERVICE_HOME/libs/java-json.jar:\
$SERVICE_HOME/libs/json-simple-1.1.1.jar:\
$SERVICE_HOME/libs/log4j-1.2.14.jar:\
$SERVICE_HOME/libs/quartz-1.7.3.jar:\
$SERVICE_HOME/libs/slf4j-api-1.7.7.jar:\
$SERVICE_HOME/libs/slf4j-log4j12-1.7.7.jar:\

PROPERTY=\
-Dlog4j.configuration=file:$SERVICE_HOME/classes/config/log4j.properties

cd $SERVICE_HOME/classes;

case "$1" in

    start)
    nohup \
    $JAVA_HOME/bin/java \
    -cp $CLASSPATH \
    $PROPERTY \
    daemon.ServerDaemon start 2>&1 | tee -a ${LOG_HOME}/Service_${TODAY}.log &
    exit $?
    ;;

    stop)
    $JAVA_HOME/bin/java \
    -cp $CLASSPATH \
    $PROPERTY \
    daemon.ServerDaemon shutdown 2>&1 | tee -a ${LOG_HOME}/Service_${TODAY}.log &
    exit $?
    ;;

   *)
    echo "TinyfarmerHub.sh start/stop"
    exit 1
    ;;
esac