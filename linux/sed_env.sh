#!/usr/bin/env bash

cur_script_dir="$(cd $(dirname "$0") && pwd)"

debug="false"
file=""
dir=""

function usage(){
        echo "Usage: args -f [file] -d [dir]"
        echo "-f mean file"
        echo "-d mean dir"
        echo "-v debug scripts"
        exit 1
}

while getopts "d:f:v" option
do
        case "$option" in
                d)
                  dir="$OPTARG"
                  ;;
                v)
                  debug="true"
                  ;;
                f)
                  file="$OPTARG"
                  ;;
                \?)
                  usage
                ;;
        esac
done

if [[ "x$debug" == "xtrue" ]]; then
  set -x
fi

if [[ ! -f "$file" ]] && [[ ! -d "$dir" ]]; then
  echo "file is illegal!"
  exit 1
fi

function gen_file(){
  file="$1"
  env | awk -F '=' '{print $1" "$2}' | while read e v; do
    #echo "$e = $v"
    echo "cat <<- 'EOF'" >  env_temp.sh
    cat "$file" | sed "s/{{${e}}}/\${$e}/g"                 >> env_temp.sh
    echo "" >> env_temp.sh
    echo 'EOF'       >> env_temp.sh
    bash env_temp.sh > "$file"
    rm env_temp.sh
    #cat "$1"
  done
}

if [[ -n "$file" ]]; then
  gen_file "$file" "$file"
elif [ -n "$dir" ]; then
  find "$dir" -type f | while read f; do
    gen_file "$f" "$f"
  done
fi



