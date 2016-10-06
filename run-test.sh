#!/bin/sh

AGG=$1    # I.e., wisconsin-clab
SLICE=$2  # I.e., single

OMNI=/Applications/omniTools-2.10/omni.app/Contents/MacOS/omni
READY=/Applications/omniTools-2.10/readyToLogin.app/Contents/MacOS/readyToLogin

set -x
echo "Start: $( date )"
$OMNI --error --project XOS createslice $SLICE
$OMNI --error -a $AGG --ssltimeout=900 --project XOS createsliver $SLICE ./OnePC-Ubuntu14.04.5.xml

until [ "$( $OMNI --error -a $AGG --project XOS SliverStatus $SLICE --tostdout | jq -r '.pg_status' )" == "ready" ]
do
    echo "Waiting for experiment to be ready"
    sleep 10
done

# Renew experiment for 8 hours (default is 4)
RENEW=$( date -v +8H -u )
$OMNI --error -a $AGG --project XOS renewsliver $SLICE "$RENEW"

HOSTS=hosts.$AGG.$SLICE
$READY --project XOS $SLICE --useSliceAggregates --readyonly --ansible-inventory > $HOSTS

mkdir -p logs
ansible-playbook -i $HOSTS launch.yaml --extra-vars="aggregate=$AGG slice=$SLICE"
