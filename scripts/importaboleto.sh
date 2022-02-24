#! /bin/bash


#export TERM=vt100
DATA_SUP=`date '+%Y%m%d%H%M'`


cd /admcom/work
/usr/dlc/bin/_progres -b -pf /admcom/bases/baseslin.pf -p /admcom/progr/bol/importaboleto.p >>/admcom/tmp/boleto/importaboleto$DATA_SUP.log
