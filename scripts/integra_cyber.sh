#! /bin/bash

#export TERM=vt100

if   [ "$1" = "" ]; then
 DATA_PROC=`date '+%d%m%Y'`
fi
if ! [ "$1" = "" ]; then
 DATA_PROC=$1
fi

DATA_SUP=`date '+%Y%m%d%H%M'`

cd /admcom/work
/usr/dlc/bin/mpro -b -pf /admcom/bases/baseslin.pf -p /admcom/progr/cyb/cyber_integra.p -param $DATA_PROC,188>> /admcom/relat/integra_cyber$DATA_SUP.log  

# Sincronia diario