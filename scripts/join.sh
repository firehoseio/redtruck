#!/bin/bash

if [ "x${SERF_TAG_ROLE}" != "xlb" ]; then
    echo "Not an lb. Ignoring member join."
    exit 0
fi

while read line; do
    ROLE=`echo $line | awk '{print \$3 }'`
    if [ "x${ROLE}" != "xweb" ]; then
        continue
    fi

    echo $line | \
        awk '{ printf "  server %s %s:7474 check\n", $1, $2 }' >>/etc/haproxy/haproxy.cfg
done

haproxy -f /etc/haproxy/haproxy.cfg -p /var/run/haproxy.pid -sf $(cat /var/run/haproxy.pid)

