#!/usr/bin/env bash

fromnamespace=""
namespace=""
debug="false"

set -x

function help() {
    echo "-f [from namespace] -n [namespace] -debug"
    echo "args: "
    echo "-f from namespace"
    echo "-n apply to namespace"
    echo "example: './copy_to_namespaces.sh -f midas-pay -n midas-pay-canary'"
}

while getopts 'h:n:f:d' OPT; do
    case $OPT in
        f)
          fromnamespace="$OPTARG"
          ;;
        n)
          namespace="$OPTARG"
#          echo  "argsIndex: ${argsIndex}"
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

if [ $(debug) ]; then
  set -x
fi

if [ -z "${fromnamespace}" ]; then
  echo "fromnamespace is null"
  exit 1
elif [ -z "${namespace}" ]; then
  echo "namespace is null"
  exit 1
fi

file="resource_export.yaml"
rsfile="resource_export.result.yaml"

echo "" > ${file}

# deploy
kubectl -n ${fromnamespace} get deploy | awk 'NR!=1 {print $1}' | xargs kubectl -n ${fromnamespace} get deploy -o yaml --export  >> ${file}
echo "---" >> ${file}


# configmap
kubectl -n ${fromnamespace} get configmap | awk 'NR!=1 {print $1}' | xargs kubectl -n ${fromnamespace} get configmap -o yaml --export  >> ${file}
echo "---" >> ${file}

# svc
# 忽略LoadBalancer类型svc
kubectl -n ${fromnamespace} get svc | grep -vE ".*\s+LoadBalancer" | awk 'NR!=1 {print $1}' | xargs kubectl -n ${fromnamespace} get svc -o yaml --export | grep -vE "^\s*clusterIP:\s*" >> ${file}
echo "---" >> ${file}

# secret
# 忽略 default service-account
kubectl -n ${fromnamespace} get secrets | grep -v "default-token" | awk 'NR!=1 {print $1}' | xargs kubectl -n ${fromnamespace} get secrets -o yaml --export >> ${file}
echo "---" >> ${file}

#kubectl create namespace mpay-hs-canary
#kubectl -n ${fromnamespace} get deploy,configmap,secrets --export -o yaml | grep -vE "^\s*clusterIP:\s*"  | sed "s/namespace: ${fromnamespace}/namespace: ${namespace}/g" >> ${file}
cat "$file"| sed "s/namespace: ${fromnamespace}/namespace: ${namespace}/g" > ${rsfile}

if [ $(debug) ]; then
  cat resource_export.yaml
fi
#kubectl -n ${namespace} apply -f ${rsfile}