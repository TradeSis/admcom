#! /bin/bash

#export TERM=vt100

cd /admcom/work
DATA_SUP=`date '+%Y%m%d'`

/usr/dlc/bin/_progres -b -pf  /admcom/scripts/hmlprd.pf -p /admcom/progr/expcontext.p >> /admcom/tmp/context/enviacontext$DATA_SUP.log 2>&1

