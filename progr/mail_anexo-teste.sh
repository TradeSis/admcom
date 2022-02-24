#!/bin/bash 

#--------------------- INCLUDES ---------------------------#
#--- Chama Script de funcoes para formatar tela
. /admcom/progr/funcoes-tela.in



if [ $# -ne 5 ]
then 
    echo "Erro de parametros ... "
    echo "Uso:  $0 <assunto> <arquivo> <destinatario> <remetente> <zip|zipar|vazio]   "
    echo "zip = arquivo do tipo zip; zipar = zipa arquivo e enviar como zip; vazio = sem anexo "
    echo
    exit
fi

SUBJECT=$1            # Assunto
ATTACH=$2             # Arquivo zipado
MAILTO=$3             # Destinatario
FROM=$4               # Remetente
BODY=$2               # Arquivo com texto para corpo email

echo

if [ "$5" == "zip" -o "$5" == "zipar"  ] 
then


	if [ "$5" == "zipar" ]
	then 
		echo 
		#mtype="-m application/x-compress"
        	echo ">>> Zipando arquivo '$ATTACH'..."
        	sleep 1
        	zip -9 $ATTACH.zip $ATTACH
        	ATTACH="$ATTACH.zip"
	fi
 
	echo -ne "\n"
	f-echo ">>> Enviando Email com anexo..."
	sleep 1
	echo -ne "\n"
	   
    {
     echo "-F Lojas Lebes"
     echo "From: $FROM"
     echo "To: $MAILTO"
     echo "Subject: $SUBJECT"
     echo "MIME-Version: 1.0"
     echo 'Content-Type: multipart/mixed; boundary="-q1w2e3r4t5"'
     echo
     echo '---q1w2e3r4t5'
     echo "Content-Type: text/html"
     echo "Content-Disposition: inline"
     echo "Em Anexo arquivo :  $ATTACH  "
     echo '---q1w2e3r4t5'
     echo 'Content-Type: application; name="'$(basename $ATTACH)'"'
     echo "Content-Transfer-Encoding: base64"
     echo 'Content-Disposition: attachment; filename="'$(basename $ATTACH)'"'
     uuencode --base64 $ATTACH $(basename $ATTACH)
     echo '---q1w2e3r4t5--'
    } | /usr/sbin/sendmail $MAILTO
 
	 if [ $? = 0 ]
	 then
        	echo -ne "\n"
	        f-echo "Email Enviado com Sucesso para $MAILTO!!!" 1
	 else
        	echo -ne "\n"
	        f-echo "FALHA NO ENVIO DO EMAIL PARA:  $MAILTO!!!" 1
	 fi


    exit 0


else
 	echo -ne "\n"
	f-echo "Enviando Email sem anexo..."
     (
     echo "From: $FROM"
     echo "To: $MAILTO"
     echo "Subject: $SUBJECT"
     echo "MIME-Version: 1.0"
     echo 'Content-Type: multipart/mixed; boundary="-q1w2e3r4t5"'
     echo
     echo '---q1w2e3r4t5'
     echo "Content-Type: text/html"
     echo "Content-Disposition: inline"
     cat $BODY
     echo '---q1w2e3r4t5'
    ) | /usr/sbin/sendmail $MAILTO
 
        if [ $? = 0 ]
         then
                echo -ne "\n"
                f-echo "Email Enviado com Sucesso para $MAILTO!!!" 1
         else
                echo -ne "\n"
                f-echo "FALHA NO ENVIO DO EMAIL PARA:  $MAILTO!!!" 1
         fi


      exit 0

fi

