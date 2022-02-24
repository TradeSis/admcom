#! /bin/bash

#--- Atualizacao BI


#TERM=vt100 export term
/usr/dlc/bin/mbpro -pf /admcom/bases/baseslin.pf -p /admcom/progr/pre-bsi-qvexp.p  -Wa -wpp >> /admcom/tmp/bsi-qvexp_cron.log
