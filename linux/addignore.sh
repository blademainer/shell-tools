#!/bin/bash
ORIGIN_FOLDER=./
ORIGIN_PATH=`cd $ORIGIN_FOLDER & pwd`
appends=(
"#eclipse配置文件"
".project"
".settings"
"#idea配置文件"
".idea/"
"*.iml"
".svn/"
"target/"
"gradle/"
"*.class"
"bin"
)

list_alldir(){ 
	echo "ORIGIN_PATH===========$ORIGIN_PATH" 
	for file2 in `ls -A $1`  
	do  
            if [ -d "$1/$file2" ];then 
		CUR_PATH=$ORIGIN_PATH/$file2 
		#export CUR_PATH	
		#echo `cd $CUR_PATH & pwd`	
		if [ -d "$CUR_PATH/.git" ]; then
			echo "CUR_PATH ================= $CUR_PATH"
			#添加gitignore文件
			find_file_and_appendStr $CUR_PATH/.gitignore $appends
			#&& git status
			echo `cd $CUR_PATH  && git add ./ -A && git commit -m "add gitignore" && git push origin master`
			echo "CUR_PATH&pwd ===================== `cd $CUR_PATH & pwd`"
#			echo "pwd=============`pwd`"
#			echo `git status`
               # list_alldir "$1/$file2"  
		fi
            fi   
	done  
}



#第一个参数为文件路径，第二个参数为要加入的内容数组，回车为分隔符
find_file_and_appendStr(){
	#ARR=$2;
	#echo "${#ARR}"
	if [ ! -w "$1" ]; then
		echo `touch $1`
	fi

	if [ -w "$1" ]; then
		#filename=(`ls`)
		for var in ${appends[@]};do
			#echo "found ========== `find_line_exists_in_file $var $1`"
			echo "var ============= $var"
			echo "exists ============== `find_line_exists_in_file $var $1`"
			if [ `find_line_exists_in_file $var $1` == "0" ]; then
				echo "$var" >> $1
			fi
		done
	fi
}  

#第一个参数是字符串，第二个参数文件
find_line_exists_in_file(){
	#echo "file ========== $2"
	#echo "str ========== $1"
	if [ ! -w "$2" ]; then
		echo "0"
		return 0;
	fi

	while read LINE
		do
		#echo "line ====== $LINE"
		if [ "$LINE" = "$1" ]; then
			echo "1"
			return 1;
		fi
	done < $2
	#i=1
	#SUM=`sed -n '$=' $2` #计算文件的总行数
	#echo "$i"
	#i=1
	#for i in `seq $SUM` ;do 
	#	echo "${arr[$i]}"
	#done
	echo "0"
	return 0;
}

find_file_and_read_line(){
	i=1
	SUM=`sed -n '$=' $1` #计算文件的总行数
	echo "$SUM"
	while read line
	do
	    arr[$i]="$line"
	    i=`expr $i + 1`
	done < tmp.txt
	echo "$i"
	i=1
	for i in `seq $SUM` ;do 
	    echo "${arr[$i]}"
	done
	return arr
}



  
list_alldir $ORIGIN_FOLDER
#find_file_and_appendStr $ORIGIN_FOLDER/.gitignore $appends

