echo ""
echo ""
echo ""
echo ""
echo "Aguarde..."
echo ""
echo "Gerando " $2
echo ""
echo ""
echo ""
#on "1.1"

# This host side script demonstrates how to send a binary file
# from the host to the PC running AniTa Terminal. 
#
# Command line format:
#
# anitaft.sh unixfilename [pcfilename]

#
# ========== S Y S T E M   P A R A M E T E R S ==========
#

#
# BLOCKSIZE: The size of the block sent
#
BLOCKSIZE=2048

#
# DOACK: Set to 1 on systems that have flow control problems
# and sometimes loose data.
#
DOACK=0

#
# BLOCK2: Set to "[" for all terminals except HP which is "%"
#
BLOCK2="["

#
# ECHO: Set to "echo" for all systems except linux which is "echo -e"
# BACK: Set to "\0134" for all systems except linux which is "\134"
# Here we are trying to determine the system automatically.
#
MYPORT=`uname -s`
if [ "$MYPORT" = "linux" ] || [ "$MYPORT" = "Linux" ]
then
	ECHO="echo -e"
        BACK="\134"
else
	ECHO="echo"
        BACK="\0134"
fi

#
# =============== P R O G R A M   C O D E ===============
#

#
# UNIXFILE is the file name to send
#
case $1 in                        
	'')	echo "Error: parameter 1 must be the file name to send." 1>&2
		exit 5 ;;                            
esac ;                                   
UNIXFILE=$1

#
# check that the host file exists
#
if [ ! -f ${UNIXFILE} ] 
then
	echo "Error: $UNIXFILE does not exist!." 1>&2
	exit 3 
fi

#
# get the size of the original file on host system
#
UNIXSIZE=`ls -l ${UNIXFILE} | awk ' { print $5 }'` 

#
# PCFILE is the file name to copy to on the PC
#
case $2 in
	?*) PCFILE="${2}" ;;
	'') PCFILE="`basename ${UNIXFILE}`" ;;
esac
PCFILE="C:/temp/$PCFILE"

#
# Now do the send !
#
REMAINDER=$UNIXSIZE
$ECHO "\033${BLOCK2}13;${UNIXSIZE}y${PCFILE}\033${BACK}\c"
stty -opost
stty -echo
$ECHO "\033${BLOCK2}34;-1;1y\c"
read RESPONSE
if [ "$RESPONSE" != "OK" ]
then
	stty opost
	stty echo
	echo "Could not open output file: ${RESPONSE}"
	exit
fi
SKIP=0
while [ $REMAINDER != 0 ]
do
	if [ $REMAINDER -lt $BLOCKSIZE ]
	then
		SEND=$REMAINDER
	else
		SEND=$BLOCKSIZE
	fi
	$ECHO "\033${BLOCK2}34;${SEND};${DOACK}y\c"
	dd bs=$BLOCKSIZE skip=$SKIP count=1 if=$UNIXFILE 2>/dev/null
	if [ $DOACK != 0 ]
	then
		read RESPONSE
	fi
	SKIP=`expr $SKIP + 1`
	REMAINDER=`expr $REMAINDER - $SEND`
done
stty opost
$ECHO "\033${BLOCK2}34;0;${DOACK}y\c"
if [ $DOACK != 0 ]
then
	read RESPONSE
fi
stty echo
echo -e "\033[4i\c"
echo -e "\033[1ycmd /Q /C $PCFILE \033\0134"
