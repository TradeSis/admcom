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
 "1")
	INTERFACE_ID=$1
	;;
   *)
        echo "PARAMETROS EM FALTA: $1 "
        echo "Formato: $0 <INTERFACE ID>"
        exit -1
esac


#Check Parameters
param1_len=`echo $INTERFACE_ID | awk '{ print length }'`


if [ $param1_len -lt 3 ] || [ $param1_len -gt 4 ] ; then

    echo "Codigo de Interface errado (3 ou 4 digitos): $1 "
    echo "Formato: $0 [INTF]"
    exit -1
fi;


#Check Interface
executesql $"select max(isr.source_id) from interfaces i, interface_source isr where i.interface_id = isr.interface_id and i.interface_id = $INTERFACE_ID and i.transfer_type = 'FF' and isr.source_id in ('ADMCOM')"

if [ "$result" == "" ]; then
        echo "Interface Invalida"
        exit 1
fi;


#Get the source filename

executesql $"select pck_interface_mng.get_source_file_name($INTERFACE_ID) from dual"

if [ "$result" == "" ]; then
        echo "Erro ao determinar o nome do ficheiro"
        exit -2
else
		echo "Nome do ficheiro source: $result"
		exit 0
fi;