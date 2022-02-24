#! /bin/bash

#export TERM=vt100

DATA_SUP=`date '+%Y%m%d'`

cd /admcom/work
/usr/dlc/bin/mpro -b -pf /admcom/bases/integra-cyber.pf -p /admcom/progr/finct/frsalcart_rodaresumo.p >> /admcom/tmp/automatiza_frsalcart_rodaresumo$DATA_SUP.log  

# Sincronia diario                                                                                                                                   

