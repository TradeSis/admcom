{/admcom/progr/admcab-batch.i new}
setbcod = 999.
sfuncod = 101.

def var varquivo as char.
def var varqsai as char.
def var vassunto as char.
def var vmail as char.

varquivo = "/admcom/logs/mail.sh-guradirel-" + string(day(today),"99") +
            string(month(today),"99") + string(year(today),"9999") + "." +
            string(time).

    
    output to value(varquivo) append.

    put "Inicio processamento bascontr-cron.p " 
        today " "
        string(time,"hh:mm:ss") skip.

    vassunto = "BASE DE PRODUTOS LEBES".
    varqsai = "".
    run /admcom/progr/bascontr-cron.p (input "PRODU", output varqsai).
    
    put "Final  processamento bascontr-cron.p " 
        today " "
        string(time,"hh:mm:ss") skip.
    output close.
    
    if search(varqsai)  <> ?
    then do:
        run envia_info_anexo_v2.p(input "1002", input varquivo,
                input varqsai, input vassunto).
    end.



