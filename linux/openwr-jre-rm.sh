#!/bin/sh
JRE_HOME=/userdisk/data/software/jre  
rm -rf     $JRE_HOME/lib/plugin.jar \
           $JRE_HOME/lib/ext/jfxrt.jar \
           $JRE_HOME/bin/javaws \
           $JRE_HOME/lib/javaws.jar \
           $JRE_HOME/lib/desktop \
           $JRE_HOME/plugin \
           $JRE_HOME/lib/deploy* \
           $JRE_HOME/lib/*javafx* \
           $JRE_HOME/lib/*jfx* \
           $JRE_HOME/lib/amd64/libdecora_sse.so \
           $JRE_HOME/lib/amd64/libprism_*.so \
           $JRE_HOME/lib/amd64/libfxplugins.so \
           $JRE_HOME/lib/amd64/libglass.so \
           $JRE_HOME/lib/amd64/libgstreamer-lite.so \
           $JRE_HOME/lib/amd64/libjavafx*.so \
           $JRE_HOME/lib/amd64/libjfx*.so
