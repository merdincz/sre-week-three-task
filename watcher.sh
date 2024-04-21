#!/bin/bash
NAMESPACE="sre"
DEPLOYMENT="swype-app"
MAX_RESTARTS=5

while true
do
    RESTARTS=$(kubectl get pods -n $NAMESPACE -l app=$DEPLOYMENT -o jsonpath='{.items[*].status.containerStatuses[*].restartCount}' | awk '{s+=$1} END {print s}')
    echo "Current restart count: $RESTARTS"
    if [ "$RESTARTS" -gt "$MAX_RESTARTS" ]; then
        echo "Maximum restarts exceeded, scaling down $DEPLOYMENT"
        kubectl scale deployment/$DEPLOYMENT --replicas=0 -n $NAMESPACE
        break
    else
        sleep 60
    fi
done
