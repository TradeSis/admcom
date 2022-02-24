#! /bin/bash

#export TERM=vt100

DATA_SUP=`date '+%Y%m%d'`

cd /admcom/work
/usr/dlc/bin/mpro -b -pf /admcom/bases/baseslin.pf -p /admcom/progr/iep/bautomatiza_iep.p >> /admcom/tmp/iep/logs/automatiza_iep$DATA_SUP.log  

# Sincronia diario

