
SERVIDOR=`uname -n`

PF="/admcom/bases/bases-testeP2K.pf"

if [ "$SERVIDOR" = "sv-ca-dbe" ]; then
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

TMP="/work-vnx/integracao-work/log/$HOJE"
mkdir -p $TMP
LOG="$TMP/$SERVIDOR_SOCKETSERVER_$1_$HOJE.log"

echo "PORTA " $1 $HOJE $LOG

DLC=/usr/dlc export DLC
PROPATH=/admcom/barramento/,/admcom/bs/,/admcom/progr/ export PROPATH
cd /admcom/barramento/works/
/usr/dlc/bin/barramento -pf $PF  -p /admcom/barramento/socketServer2.p -param "$1" >>$LOG



