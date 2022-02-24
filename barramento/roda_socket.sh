
SERVIDOR=`uname -n`

#PF="/admcom/bases/baseslin.pf"
PF="/admcom/bases/baseslin.pf"


if [ "$SERVIDOR" = "SV-CA-DBE" ]; then
		PF="/admcom/bases/barramento.pf"        
fi 

echo "usando pf: " $PF

if [ "$1" = "" ]; then
        echo "Informe a PORTA"
        exit 0
fi

if [ "$1" = "0" ]; then
        echo "Nao usar mais ZERO"
        exit 0
fi


HOJE=`date +"%y%m%d"`

TMP="/tmp/integracao-work/log/$HOJE"
mkdir -p $TMP
LOG="$TMP/$SERVIDOR_SOCKETSERVER_$1_$HOJE.log"

echo "PORTA " $1 $HOJE $LOG

DLC=/usr/dlc export DLC
PROPATH=/admcom/barramento/,/admcom/bs/,/admcom/progr/ export PROPATH
cd /admcom/barramento/works/
/usr/dlc/bin/mbpro -pf $PF  -p /admcom/barramento/socketServer2.p -param "$1" >>$LOG



