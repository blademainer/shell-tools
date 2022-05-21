#!/usr/bin/env bash

path=""

function isNil() {
    name=${1}
    eval value='$'${name}
    if [[ -z "${value}" ]]; then
      echo "${name} is null"
      exit 1
    fi
}

function help() {
    echo "-f [from namespace] -n [namespace] -debug"
    echo "args: "
    echo "-f from namespace"
    echo "-n apply to namespace"
    echo "example: './copy_to_namespaces.sh -f midas-pay -n midas-pay-canary'"
}

while getopts 'h:f:d' OPT; do
    case $OPT in
        f)
          path="$OPTARG"
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

function debug() {
  if [ "x${debug}" == "xtrue" ]; then
    return 1
  fi
  return 0
}

isNil "path"

find "${path}" -name ".git" -type d | while read f; do
  dir="${f%/*}"
  echo "processing git dir: ${dir}"
  git_repo="$(echo $dir| awk -F "/" '{if(NF>1){print $(NF-1)"-"$(NF)}else{print $1}}')"
  echo "git repo: ${git_repo}"
  gh repo create "${git_repo}" --source "$dir" --private --push --remote gh
done