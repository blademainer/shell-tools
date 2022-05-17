#!/usr/bin/env bash

#set -x

function gen_deploy_file() {
	echo 'cat <<END_OF_TEXT' >  sql_temp.sh
	cat $1                 >> sql_temp.sh
	echo 'END_OF_TEXT'       >> sql_temp.sh
	bash sql_temp.sh > "$2"
	rm sql_temp.sh
	cat $2
}

function help() {
    echo "-f [template file] -a [arg1=value1] -a [arg2=value2] -o [output file] -d"
    echo "args: "
    echo "-f template file"
    echo "-a template arg value, allow multiple definitions"
    echo "-o output file to be render"
    echo "example: './render_tmpl.sh -f ./test.tpl  -a aa=astring -a bb=bstring -o test.sql'"
}

file=""
declare args
argsIndex=0
output=""
debug="false"

while getopts 'h:f:a:o:d' OPT; do
    case $OPT in
        f)
          file="$OPTARG"
          ;;
        a)
          arg="$OPTARG"
#          echo  "argsIndex: ${argsIndex}"
          args[$argsIndex]=$arg
          argsIndex=$((argsIndex+1))
          ;;
        o)
          output="$OPTARG"
          ;;
        h)
          help
          exit 0
          ;;
        d)
          debug="true"
          ;;
        ?)
          help
          exit 0
          ;;
    esac
done


echo "args: ${args[@]} len: ${#args[@]}"

if [ -z "${file}" ]; then
  echo "file is null!"
  exit 1
elif [ -z "${output}" ]; then
  echo "output file is null!"
  exit 1
elif [ ! -f "${file}" ]; then
  echo "file: ${file} is not exists!"
  exit 1
fi

#set -x
#echo "file=${file}"
variables=$(grep -oE "\{\{\w+\}\}" $file | sort | uniq | tr -d '{' | tr -d '}')
echo "variables=$(echo $variables | xargs | tr ' ' ',')"
#echo "$variables" | while read v; do
#  echo -n "template variable: ${v}"
#done


file_tmp="__${output}__.tmp"
cat "${file}" > $file_tmp
for i in `seq 0 $((${#args[@]}-1))` ; do
  name=$(echo ${args[i]} | awk -F '=' '{print $1}')
  value=$(echo ${args[i]} | awk -F '=' '{print $2}')
  if [[ "${debug}" == "true" ]]; then
    echo "replacing args[$i]: ${args[i]}"
  fi
  echo "replace: [$name] to: [$value]"
  if [[ "${debug}" == "true" ]]; then
    echo "before: $(cat $file_tmp)"
  fi
  content=$(cat "$file_tmp" | sed "s/{{${name}}}/${value}/g")
  echo "$content" > "$file_tmp"
  if [[ "${debug}" == "true" ]]; then
    echo "after: $(cat $file_tmp)"
  fi
done

mv "${file_tmp}" "${output}"

