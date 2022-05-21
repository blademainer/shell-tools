#!/usr/bin/env bash

path=""
remote="gh"
team=""
prefix=""
args=""

function isNil() {
    name=${1}
    eval value='$'${name}
    if [[ -z "${value}" ]]; then
      echo "${name} is null"
      exit 1
    fi
}

function help() {
    echo "-f [path] -r [remote] -debug"
    echo "args: "
    echo "-f git repo path"
    echo "-r remote name"
    echo "example: './backup-to-gh.sh -f ./ -r gh'"
}

while getopts 'a:p:h:r:t:f:d' OPT; do
    case $OPT in
        f)
          path="$OPTARG"
          ;;
        r)
          remote="$OPTARG"
          ;;
        a)
          args="$OPTARG"
          ;;
        t)
          team="$OPTARG"
          ;;
        p)
          prefix="$OPTARG"
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
  git_repo="${prefix}$(echo $dir| awk -F "/" '{if(NF>1){print $(NF-1)"-"$(NF)}else{print $1}}')"
#  git_repo="${prefix}$(echo $dir| awk -F "/" '{if(NF>1){print $(NF-1)"-"$(NF)}else{print $1}}')"
  echo "git repo: ${git_repo}"
  gh repo create "${git_repo}" --source "$dir" --private --push --remote "${remote}" --team "${team}" ${args}
done