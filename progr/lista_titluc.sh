while read line
do

echo $line

ls -la | grep -w $line


done < lista_titulo_progr.txt
