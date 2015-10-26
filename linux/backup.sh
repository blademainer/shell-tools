#!/bin/sh
#---------------------------------------------------------------------
#	shell自动备份文件夹同时检查一定日期前的文件夹并删除
#	部署好本脚本后应当在linux中设置cron自动执行：
#	1、在linux的/etc/cron.d/目录下新建空文件
#	2、使用"crontab -e"编辑新的定时任务并保存
#	3、chkconfig crond on
#	（注意：在cron模式下文件操作必须使用绝对路径）
#														--by: Blademainer
#---------------------------------------------------------------------
#设置要备份的目录，多个文件夹以逗号分隔
ORIGIN_FOLDER=test,testlog
#设置备份文件的存储目录，可以是绝对路径
DES_FOLDER=bak
#设置删除多少天之前的备份
DAYS_AGO=10


#定义日期变量，时间戳的单位以秒为单位
SECOND=1
MINUTE=$((60*$SECOND))
HOUR=$((60*$MINUTE))
DAY=$((24*$HOUR))
WEEK=$((7*$DAY))

#time1=$(($(date +%s -d '2010-01-01') - $(date +%s -d '2009-01-01')));# 计算时间戳，以秒为单位
#time2=$(($(date +%s -d '2013-12-30 11:57:39')));# 计算时间戳，以秒为单位
#time3=$(($(date +%s -d "$(date +'%Y-%m-%d %H:%M:%S')")));# 计算时间戳，以秒为单位
#echo $time3
#echo $time2
#echo $(($time1/$DAY))

#当前日期的字符串表达形式
NOW=$(date +'%Y-%m-%d_%H%M%S')
#echo $NOW
#TEN_DAYS_AGO=$(($(date -d '-10 day' "+%Y%m%d%H%M%S")))
#echo 十天之前$TEN_DAYS_AGO

#计算当前时间的时间戳表达方法
TIME_NOW=$(($(date +%s -d "$(date +'%Y-%m-%d %H:%M:%S')")))

SECONDS_OF_DAYS_AGO=$(($DAYS_AGO * $DAY))
#计算指定天数前的时间戳表达方法
TIME_AGO=$(($TIME_NOW - $SECONDS_OF_DAYS_AGO))
#echo $TIME_NOW
#echo TIME_AGO============$TIME_AGO



#判断传入的日期是否在设置的日期之前
function isDaysBefore()
{
	DATE=$(($(date +%s -d $1)))
	if [[ $DATE < $TIME_AGO ]] 
	then
		echo 1
	else
		echo 0
	fi
}

#检验文件夹
if [ ! -d "$DES_FOLDER" ]; then  
	echo `mkdir $DES_FOLDER`
fi

DES_PATH=$DES_FOLDER/$NOW/
if [ ! -d "$DES_PATH" ]; then  
	echo `mkdir $DES_PATH`
fi

if [ ! -f "$DES_FOLDER/$NOW/$NOW.log" ]; then  
	echo `touch $DES_FOLDER/$NOW/$NOW.log`
fi

#拷贝文件夹
var=`echo "$ORIGIN_FOLDER"|awk -F ',' '{print $0}' | sed "s/,/ /g"`
for VAR_ORIGIN_FOLDER in $var; do
	command=`cp -rf $VAR_ORIGIN_FOLDER $DES_PATH`
done


#删除备份文件夹
for FOLDER in `ls $DES_FOLDER`; do
	#截取年月日
	folder_date=`expr substr $FOLDER 1 10`
	if [[ $(isDaysBefore $folder_date) == 1 ]]
	then
		echo `rm -fr $DES_FOLDER/$FOLDER`
	fi
done
