#!/bin/sh
#执行方法：
#如果在当前目录执行，则必须带'.'号，如：
# . ./rm-branch-trunk.sh
ORIGIN_PATH=/etc/hosts
#当前日期的字符串表达形式
NOW=$(date +'%Y-%m-%d_%H%M%S')
do_cp(){ 
	echo "ORIGIN_PATH=$ORIGIN_PATH" 
	echo "$1"
	target="${ORIGIN_PATH}.$1"
	echo "target = ${target}"
	if [ ! -f "$target" ];then 
		echo "not exists!"
	fi
	if [ -f "$target" ];then 
		echo "copy $ORIGIN_PATH to ${ORIGIN_PATH}.$NOW"
		cp $ORIGIN_PATH ${ORIGIN_PATH}.$NOW
		echo "copy ${target} to ${ORIGIN_PATH}"
		cp ${target} ${ORIGIN_PATH}
	fi
}  
  
do_cp $1

