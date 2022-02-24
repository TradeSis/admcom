
SERVIDOR=`uname -n`

PF="/admcom/bases/baseslin.pf"

if [ "$SERVIDOR" = "sv-ca-dbe" ]; then
                PF="/admcom/bases/barramento.pf"        
fi 

echo "usando pf: " $PF

HOJE=`date +"%y%m%d"`

TMP="/work-vnx/integracao-work/log/$HOJE"

mkdir -p $TMP

LOG="$TMP/$SERVIDOR.log"

echo "LOG " $1 $HOJE $LOG

DLC=/usr/dlc export DLC
PROPATH=/admcom/barramento/,/admcom/bs/,/admcom/progr/ export PROPATH
cd /admcom/barramento/works/
/usr/dlc/bin/roda_async -pf $PF  -p /admcom/barramento/asyncServer2.p -param "15" >>$LOG



