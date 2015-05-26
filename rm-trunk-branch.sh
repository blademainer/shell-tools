#!/bin/sh
#执行方法：
#如果在当前目录执行，则必须带'.'号，如：
# . ./rm-branch-trunk.sh
ORIGIN_FOLDER=./
ORIGIN_PATH=`cd $ORIGIN_FOLDER & pwd`
list_alldir(){ 
	echo "ORIGIN_PATH=$ORIGIN_PATH" 
    for file2 in `ls -A $1`  
    do  
            if [ -d "$1/$file2" ];then 
		CUR_PATH=$ORIGIN_PATH/$file2 
		echo `cd $CUR_PATH && git push origin --delete trunk`
		echo "pwd=============`pwd`"
               # list_alldir "$1/$file2"  
            fi   
    done  
}  
  
list_alldir $ORIGIN_FOLDER

