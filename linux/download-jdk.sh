#!/bin/bash
url="${1:-http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz}"
fileName="${url##*/}"
echo "url====$url"
echo "fileName====$fileName"
curl -v -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" ${url} -o ${fileName}
