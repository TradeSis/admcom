#! /bin/bash

#export TERM=vt100

DATA_SUP=`date '+%Y%m%d'`

cd /admcom/work
/usr/dlc/bin/mpro -b -pf /admcom/bases/integra-cyber.pf -p /admcom/progr/finct/przmroda.p >> /admcom/tmp/automatiza_przmed$DATA_SUP.log  

# Sincronia diario

