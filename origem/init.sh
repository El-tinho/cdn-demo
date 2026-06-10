#!/bin/sh
apk add --quiet iproute2
tc qdisc add dev eth0 root netem delay 200ms
nginx -g "daemon off;"