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
	INTERFACE_ID=$1	
	DESTINATION_ID=$2
	;;
   *)
        echo "PARAMETROS EM FALTA: $1 $2"
        echo "Formato: $0 <INTERFACE ID> <DESTINATION_ID>"
        exit -1
esac


#Check Parameters
param1_len=`echo $INTERFACE_ID | awk '{ print length }'`

if [ $param1_len -lt 3 ] || [ $param1_len -gt 4 ] ; then

    echo "Codigo de Interface errado (3 ou 4 digitos): $1 "
    echo "Formato: $0 [INTF] [DESTINATION_ID]"
    exit -1
fi;


#Check Interface
executesql $"select max(idst.destination_id) from interfaces i, destinations idst where i.interface_id = idst.interface_id and i.interface_id = $INTERFACE_ID and i.transfer_type = 'FF' and idst.destination_id in ('$DESTINATION_ID')"

if [ "$result" == "" ]; then
        echo "Interface Invalida"
        exit 1
fi;


#Get the filename

executesql $"select pck_interface_mng.get_target_file_name($INTERFACE_ID,'$DESTINATION_ID') from dual"

if [ "$result" == "" ]; then
        echo "Nao existem arquivos para processar"
        exit -2
else
		echo "Nome do ficheiro: $result"
		exit 0
fi;