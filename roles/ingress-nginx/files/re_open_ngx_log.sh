#!/bin/bash

CID=$(/usr/local/bin/crictl ps | grep controller | awk '{print $1}')

# https://www.nginx.com/resources/wiki/start/topics/examples/logrotation/

if [ -n "$CID" ];then
  /usr/local/bin/crictl exec $CID nginx -s reopen
fi
