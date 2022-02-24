#!/bin/bash

USERNAME=tp_dsa_ctrl;
PASS=tp_dsa_ctrl;

log_file="submit_flow.log"
max_log_size="10000"

result=""


executesql() {
        local code=${1##*/}
        echo -e "set head off\nset define off\n $code ; \nquit" > a.sql
        result=`sqlplus -S $USERNAME/$PASS@$ORACLE_SID @a.sql | sed '/^$/d' | sed 's/\t//g' | sed 's/\ //g' `
        rm a.sql
}


#Get IPO's installation path (for logging purposes)
#installation_path="/usr/oracle/ipo_interfaces/" #default
installation_path=""
executesql $"select (select int_config_value from int_config where int_config_id='ARCHIVE_PATH') || (select int_config_value from int_config where int_config_id='DIR_SEPARATOR') from dual"
if [ $result != "" ]; then
	installation_path=$result
fi;

#Check log file size
for i in `find $installation_path -maxdepth 1 -type f -size +$max_log_size | egrep "$log_file$"`; do
   currdate=`date +"%Y%m%d%k%M%S"`
   mv "$i" "$i"_"$currdate"
done;

log_file=$installation_path$log_file


#Log call
echo "-----" >> $log_file
date >> $log_file
echo "Parameter: $1 ." >> $log_file

case "$#" in
 "1")
        FILENAME=$1
        ;;
   *)
        echo "Formato: $0 <FILENAME>"
        echo "Format error" >> $log_file
        exit -1
esac


#Do the submission

executesql $"select pck_interface_mng.submit_interface($FILENAME) from dual"

echo $result
echo $result >> $log_file
exit 0