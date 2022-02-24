#!/bin/bash

USERNAME=tp_dsa_ctrl;
PASS=tp_dsa_ctrl;

result=""


executesql() {
        local code=${1##*/}
        echo -e "set head off\nset define off\n $code ; \nquit" > a.sql
        result=`sqlplus -S $USERNAME/$PASS@$ORACLE_SID @a.sql | sed '/^$/d' | sed 's/\t//g' | sed 's/\ //g' `
        rm a.sql
}


case "$#" in   
 "2")
	FILENAME=$1
	STATUS=$2
	;;
   *)
        echo "PARAMETROS EM FALTA: $1  $2"
        echo "Formato: $0 <FILENAME> <STATUS>"
        exit -1
esac


#Check Parameters
param2_len=`echo $STATUS | awk '{ print length }'`

if [ $param2_len -lt 1 ] || [ $param2_len -gt 1 ] ; then

    echo "Codigo de Status errado (1 caracter): $2 "
    echo "Formato: $0 [FILENAME] [S]"
    exit -1
fi;


#Set the status

executesql $"select pck_interface_mng.set_processed('$FILENAME','$STATUS') from dual"

if [ "$result" == "" ]; then
        echo "Erro ao mudar o status"
        exit -2
else
		echo $result
		exit 0
fi;