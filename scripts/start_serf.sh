#!/usr/bin/env bash

: ${SERF_CLUSTER:="redtruck"}
: ${SERF_ROLE:="lb"}

/usr/local/bin/serf agent -tag role=$SERF_ROLE -discover $SERF_CLUSTER -event-handler member-join=join.sh -event-handler member-failed,member-leave=leave.sh

