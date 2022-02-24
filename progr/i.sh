
echo $1

if   [ "$1" = "" ]; then
 DATA_PROC=`date '+%d%m%Y'`
fi
if ! [ "$1" = "" ]; then
 DATA_PROC=$1
fi

echo $DATA_PROC
