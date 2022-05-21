#!/bin/bash

function usage(){
  echo "USAGE: $0 -t [test run] -s [server list]"
}

test="true"
serverList=""
while getopts "s:t:" arg #选项后面的冒号表示该选项需要参数
do
        case $arg in
             t)
                test="$OPTARG"
                ;;
             s)
                serverlist="$OPTARG"
             ?)  #当有不认识的选项的时候arg为?
	        usage	
                ;;
        esac
done
service_conf="./test.json"
if [[ "s$test"=="sfalse" ]]; then
  service_conf="/usr/lib/systemd/system/etcd.service"
fi

sudo tee $service_conf <<-'EOF'
[Unit]
Description=Etcd Server
After=network.target

[Service]
EnvironmentFile=/opt/etcd/conf/etcd.conf
# set GOMAXPROCS to number of processors
ExecStart=/bin/bash -c "GOMAXPROCS=$(nproc) /opt/etcd/bin/etcd \
    ${ETCD_NAME}    \
    ${ETCD_DATA_DIR} \
    ${ETCD_LISTEN_CLIENT_URLS} \
    ${ETCD_ADVERTISE_CLIENT_URLS}      \
    ${ETCD_LISTEN_PEER_URLS}               \
    ${ETCD_INITIAL_ADVERTISE_PEER_URLS}    \
    ${ETCD_INITIAL_CLUSTER}                \
    ${ETCD_INITIAL_CLUSTER_STATE}          \
    ${ETCD_INITIAL_CLUSTER_TOKEN}"

Restart=on-failure
KillMode=process

[Install]
WantedBy=multi-user.target
EOF 
