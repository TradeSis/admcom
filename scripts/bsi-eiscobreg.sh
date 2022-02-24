#! /bin/bash

#--- 


TERM=vt100 export term
/usr/dlc/bin/mbpro -pf /admcom/bases/baseslin.pf -p /admcom/progr/bsi-eiscobreg.p  -Wa -wpp >> /admcom/tmp/bsi-eiscobreg_cron.log

