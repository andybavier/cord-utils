#!/bin/sh

AGG=$1    # I.e., wisconsin-clab
SLICE=$2  # I.e., single

OMNI=/Applications/omniTools-2.10/omni.app/Contents/MacOS/omni
READY=/Applications/omniTools-2.10/readyToLogin.app/Contents/MacOS/readyToLogin
HOURS=8

function get_status {
    $OMNI --error -a $AGG --project XOS SliverStatus $SLICE --tostdout | jq -r '.pg_status'
}

#set -x

echo "*** Start: $( date )"
echo "*** Creating slice $SLICE"
$OMNI --error --project XOS createslice $SLICE

echo "*** Creating experiment on $AGG"
$OMNI --error -a $AGG --ssltimeout=900 --project XOS createsliver $SLICE ./OnePC-Ubuntu14.04.5.xml

STATUS=$( get_status )
until [ "$STATUS" == "ready" ]
do
    echo "Waiting for experiment to be ready (status: $STATUS)"
    sleep 10
    STATUS=$( get_status )
done

# Renew experiment for 8 hours (default is 4)
echo "*** Renewing experiment for $HOURS hours"
RENEW=$( date -v +${HOURS}H -u )
$OMNI --error -a $AGG --project XOS renewsliver $SLICE "$RENEW"

HOSTS=hosts.$AGG.$SLICE
echo "*** Creating Ansible hosts file: $HOSTS"
$READY --project XOS -a $AGG $SLICE --readyonly --ansible-inventory > $HOSTS

echo "*** Running Ansible playbook"
mkdir -p logs
ansible-playbook -i $HOSTS launch.yaml --extra-vars="aggregate=$AGG slice=$SLICE"
