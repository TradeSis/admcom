#! /bin/bash

#export TERM=vt100

DATA_SUP=`date '+%Y%m%d'`

cd /admcom/work
/usr/dlc/bin/mpro -b -pf /admcom/bases/baseslin.pf -p /admcom/progr/fin/automatiza_financeira.p >> /admcom/tmp/automatiza_financeira$DATA_SUP.log  

# Sincronia diario

