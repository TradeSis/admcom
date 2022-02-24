#! /bin/bash

#--- Atualizacao BI


#TERM=vt100 export term
/usr/dlc/bin/mbpro -pf /admcom/bases/baseslin.pf -p /admcom/progr/calculabalanco-antes1.p  -Wa -wpp >> /admcom/tmp/calculabalanco-antes1_cron.log
