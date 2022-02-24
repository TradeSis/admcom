#! /bin/bash
#
#
#
# mail.sh - Envia email pelo shell com anexo
#
# Autor - Cassio Lago
#
# 16/09/2014 - laureano.noguez@linx.com.br Alterado para usar a conta do
#              Gmail enviando e-mail pelo SendMail. 
#
#
#
#
#
#--------------------- INCLUDES ---------------------------#
#--- Chama Script de funcoes para formatar tela
. /admcom/progr/funcoes-tela.in

#-------------- VARIAVEIS GLOBAIS -------------------------#
script_nome="mail.sh"
assunto=$1
arq=$2
dest=$3

if [ -n "$4" ]
then if [ "$4" == "informativo@lebes.com.br" ]
     then
     remet="monitor.ti@lebes.com.br"
     fi
else
remet="monitor.ti@lebes.com.br"
fi

mtype_aux="$5"

mtype_aux="${mtype_aux// /}"

if [ -n "$5" ]
then
mtype="-m $5"
else
mtype="-m text/html"
fi

if [ "$mtype_aux" == "zip" ]
 then tipo_envio="ANEXO_ZIP"
else tipo_envio="CORPO_MENSAGEM" 
fi


##### Ao executar o mail.sh grava Log de execução #####

dest_aux="$dest"
arquivo_log="/admcom/logs/mail.sh.${dest_aux//@/_}.log"

echo "Enviando e-mail para $dest_aux em $(date +%d/%m/%Y) as $(date +%r) no formato $mtype_aux favor conferir na caixa de saida do e-mail monitor.ti" >> $arquivo_log


#------------------ FUNCOES -------------------------------#
### Mostra a sintaxe do script
function f-sintaxe {
        f-echo "****** $script_nome ******" 1
        echo -ne "\n"
        f-echo "DESCRICAO" 1
        f-echo "Envia email pelo shell com anexo" 1
        echo -ne "\n"
        f-echo "SINTAXE:" 1
        f-echo "$script_nome <assunto> <arquivo de anexo> [destinatario] [remetente] [mtype] " 1
        echo -ne "\n"
        f-echo "EXEMPLOS:" 1
        f-echo "$script_nome teste /tmp/teste teste@lebes.com.br" 
        f-echo "$script_nome teste /tmp/teste teste@lebes.com.br joao@lebes.com.br text/plain" 
                }
#-------------- INICIO DO PROGRAMA ------------------------#

#--- Se nao tiver algum parametro
if [ "$#" -lt 3 -o "$#" -gt 5  ] 
then
        f-echo "ERRO: Parametros invalidos!" 1
        echo -ne "\n"
        f-sintaxe
        exit                 
fi

echo -ne "\n"
#f-echo "Zipando arquivo $arq.." 1
#cd /admcom/relat
#/usr/bin/zip -f  $arq
                     
#arq1=$arq.zip

if [ "$mtype" == "-m zip" ]
then
        mtype="-m application/x-compress"
        echo "Zipando arquivo '$arq'..."
        sleep 1
        zip -9 $arq.zip $arq
        arq="$arq.zip"
fi

echo -ne "\n"
f-echo "Enviando Email..." 1
 #echo '' | /usr/bin/mutt -s $assunto -a $arq   $dest
 #/usr/bin/metasend -b  -S 3000000000 -s "$assunto" -F "$remet" -f "$arq"  
 #$ mtype -t "$dest"

if [ "$tipo_envio" == "ANEXO_ZIP" ]
then

 /usr/bin/sendEmail -f "Lojas Lebes <monitor.ti@lebes.com.br>" -t "$dest"  -u "$assunto" -m "Arquivo em anexo." -a "$arq" -o tls=yes  -s "aspmx.l.google.com"  -xu "monitor.ti@lebes.com.br"  -xp "94BrBPG!"

  f-echo "Enviando Email com Anexo... $arq" 1

else

 /usr/bin/sendEmail -f "Lojas Lebes <monitor.ti@lebes.com.br>" -t "$dest"  -u "$assunto" -o message-file="$arq"  -o tls=yes  -o message-content-type=html  -s "aspmx.l.google.com"  -xu "monitor.ti@lebes.com.br"  -xp "94BrBPG!"

 f-echo "Enviando Email sem Anexo..." 1

fi

 #echo $?

echo -ne "\n"
f-echo "Data: `date`" 1
f-echo "Arquivo: $arq" 1
f-echo "Arquivo ZIP: $arq.zip" 1
f-echo "Tipo MIME: $mtype" 1
f-echo "Tipo Envio: $tipo_envio" 1


 if [ $? = 0 ]
 then
        echo -ne "\n"
        f-echo "Email Enviado com Sucesso para $dest!!!" 1
 else
        echo -ne "\n"
        f-echo "FALHA NO ENVIO DO EMAIL PARA:  $dest!!!" 1
 fi

