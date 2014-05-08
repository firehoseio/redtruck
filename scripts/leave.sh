#!/bin/bash

if [ "x${SERF_TAG_ROLE}" != "xlb" ]; then
    echo "Not an lb. Ignoring member leave"
    exit 0
fi

while read line; do
    NAME=`echo $line | awk '{print \$1 }'`
    sed -i'' "/${NAME} /d" /etc/haproxy/haproxy.cfg
done

haproxy -f /etc/haproxy/haproxy.cfg -p /var/run/haproxy.pid -sf $(cat /var/run/haproxy.pid)

