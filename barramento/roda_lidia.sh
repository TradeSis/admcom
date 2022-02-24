
SERVIDOR=`uname -n`

PF="/admcom/bases/bases-testeP2K.pf"
PF="/admcom/bases/baseslin.pf"

if [ "$SERVIDOR" = "SV-CA-DBE" ]; then
                PF="/admcom/bases/barramento.pf"        
fi 

echo "usando pf: " $PF

HOJE=`date +"%y%m%d"`

TMP="/work-vnx/integracao-work/log/$HOJE"

mkdir -p $TMP

LOG="$TMP/lidia_$SERVIDOR-$HOJE.log"

echo "LOG " $1 $HOJE $LOG

DLC=/usr/dlc export DLC
PROPATH=/admcom/barramento/,/admcom/verus/,/admcom/bs/,/admcom/progr/ export PROPATH
cd /admcom/barramento/works/
/usr/dlc/bin/mbpro -pf $PF  -p /admcom/barramento/lidiaserver.p -param "15" >>$LOG



