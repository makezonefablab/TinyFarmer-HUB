#!/bin/bash
argc=$#
argv1=$1

#Log=/home/mediaflow/TinyfarmerMaster/bin/log/log.out#
DATE=`date +%Y%m%d-%H%M%S`
Work_DIR=/home/mediaflow/TinyfarmerMaster/bin/log
FILE_DIR=/`date +%Y`/`date +%m`
FILE_NAME=/TinyfarmerMaster_`date +%Y-%m-%d`.log
#USER_NAME=root

#LogDir=/home/mediaflow/TinyfarmerMaster/bin/log/`date +%Y`/`date +%m`/TinyfarmerMaster_`date +%Y-%m-%d`#
#echo $LogDir#

work_file=${Work_DIR}/${FILE_NAME}
file=${Work_DIR}/${FILE_DIR}/${FILE_NAME}

WORK_FULL=${Work_DIR}/${FILE_DIR}

:<<'END'
if [ -f "$LogDir" ]
then
   :
else
   mv -f "$Log" "log/`date +%Y`/`date +%m`/TinyfarmerMaster_`date +%Y-%m-%d`"
fi
   :
END


if [ ! -d "$WORK_FULL" ]
then
   mkdir -p ${WORK_FULL}
else
   :
fi



if [ ! -f "$FILE_NAME" ]
then
   :
else
   cp ${Work_DIR} ${file}
fi

#ID=`whoami | awk '{print $1}'`

#if [ $USER_NAME != $ID ]
#then
#echo "Master Execute Error : User Validateion is failed. This instance \
#has been started as \"$ID\", actual script owner is \"$USER_NAME\"."
#exit
#fi
# HC12
if [ $1 = 0 ]
then
   echo "============================================================" >> $file
   Cnt_HC12=`ps -ex|grep "Master_HC12.py"|grep -v grep|wc -l`
   Cnt_RFM69=`ps -ex|grep "Master_RFM69.py"|grep -v grep|wc -l`
   if [ $Cnt_HC12 -ne 0 -o $Cnt_RFM69 -ne 0 ]
   then
      if [ $Cnt_HC12 -ne 0 ]
         then
         PROCESS=`ps -ef|grep 'Master_HC12.py'|grep -v grep|awk '{print $2}'`
         kill -9 $PROCESS
      elif [ $Cnt_RFM69 -ne 0 ]
         then
         PROCESS=`ps -ef|grep 'Master_RFM69.py'|grep -v grep|awk '{print $2}'`
         kill -9 $PROCESS
      fi
      echo "$DATE : TinyfarmerMaster HC12 Stop" >> $file
      echo "$DATE : TinyfarmerMaster RFM69 Stop" >> $file
      python /home/mediaflow/TinyfarmerMaster/Master_HC12.py &
      echo "$DATE : TinyfarmerMaster HC12 Start" >> $file

   else
      python /home/mediaflow/TinyfarmerMaster/Master_HC12.py &
      echo "$DATE : TinyfarmerMaster HC12 Start" >> $file
   fi
# RFM69
elif [ $1 = 1 ]
   then
   echo "============================================================" >> $file
   Cnt_HC12=`ps -ex|grep "Master_HC12.py"|grep -v grep|wc -l`
   Cnt_RFM69=`ps -ex|grep "Master_RFM69.py"|grep -v grep|wc -l`

   if [ $Cnt_HC12 -ne 0 -o $Cnt_RFM69 -ne 0 ]
   then
      if [ $Cnt_HC12 -ne 0 ]
         then
         PROCESS=`ps -ef|grep 'Master_HC12.py'|grep -v grep|awk '{print $2}'`
         kill -9 $PROCESS
      elif [ $Cnt_RFM69 -ne 0 ]
         then
         PROCESS=`ps -ef|grep 'Master_RFM69.py'|grep -v grep|awk '{print $2}'`
         kill -9 $PROCESS
      fi
      echo "$DATE : TinyfarmerMaster RFM69 Stop" >> $file
      echo "$DATE : TinyfarmerMaster HC12 Stop" >> $file
      sudo python /home/mediaflow/TinyfarmerMaster/Master_RFM69.py &
      echo "$DATE : TinyfarmerMaster RFM69 Start" >> $file

   else
      sudo python /home/mediaflow/TinyfarmerMaster/Master_RFM69.py &
      echo "$DATE : TinyfarmerMaster RFM69 Start" >> $file
   fi

fi