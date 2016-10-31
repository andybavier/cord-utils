#!/bin/sh

AGG=$1    # I.e., wisconsin-clab
SLICE=$2  # I.e., single

OMNI=/Applications/omniTools-2.10/omni.app/Contents/MacOS/omni
HOURS=16

# Renew experiment for 16 hours (default is 4)
echo "*** Renewing experiment for $HOURS hours"
RENEW=$( date -v +${HOURS}H -u )
$OMNI --error -a $AGG --project XOS renewsliver $SLICE "$RENEW"
