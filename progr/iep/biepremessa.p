/* 05012022 helio iepro */

def input param pacao   as char.

def var vi as int.
def var poperacao   as char init "IEPRO".
def var pcodocorrencia as char.
def var pocorrencia as char.
def var parquivo as char.
def var premessa as int.
def var parquivorecid as recid.
def var dstatus   as char. 


def new shared temp-table ttprot
    field precid        as recid.


/** **/
def var wcontinua as log.
        message string(time,"HH:MM:SS") pacao.
        do while true.
            run envia.
            if wcontinua = no
            then leave.
        end.
        

procedure envia.
def var vqtd as int.
    for each ttprot.
        delete ttprot.
    end.        
    vqtd = 0.        
    wcontinua = no.
    for each titprotesto where  titprotesto.operacao = poperacao and
                                titprotesto.acao     = pacao     and
                                titprotesto.dtacao   = ?
            no-lock.
        if (titprotesto.protocolo = ? and pacao = "REMESSA") or titprotesto.protocolo <> ?
        then.
        else next.
        vqtd = vqtd + 1.
        if vqtd > 20
        then do:
            wcontinua = yes.
            leave.
        end.    
            
        disp titprotesto
        with title pacao.    
        disp vqtd.
        create ttprot.
        ttprot.precid  = recid(titprotesto).   
    end.

    find first ttprot no-error.
    if not avail ttprot
    then do:
        message poperacao pacao "nenhum registro encontrado".
    end.
    else do:
        if pacao = "remessa"
        then do:
            run iep/geraarquivo.p (input poperacao,
                                   input pacao,
                                   output parquivorecid ,
                                   output parquivo,
                                   output premessa).
            /* GERA XML e ENVIA IEPRO - CHAMADA API */
            run iep/montaxml-remessa.p (    input poperacao,
                                            input parquivo,            
                                            input premessa,
                                            output pcodocorrencia,
                                            output pocorrencia).

            message "Final montaxml-remessa" pcodocorrencia pocorrencia parquivo premessa.
            
        end.
        
        if pacao = "desistencia"        or pacao = "cancelamento" or
           pacao = "aut.desistencia"    or pacao = "aut.cancelamento" 
        then do:
            run iep/geraarquivo.p (input poperacao,
                                   input lc(pacao),
                                   output parquivorecid,
                                   output parquivo,
                                   output premessa).

            /* GERA XML e ENVIA IEPRO - CHAMADA API */
            run iep/montaxml-cancelamentos.p (    input poperacao,
                                            input lc(pacao),
                                            input parquivo,            
                                            output pcodocorrencia,
                                            output pocorrencia).

            message "Final montaxml-cancelamentos" pacao pcodocorrencia pocorrencia.
            
        end.
        
        if pcodocorrencia = "0000" /*"REGISTROS OK"*/
        or pcodocorrencia = "2016"
        then do:

        /* MARCA COMO ENVIADO */
            for each ttprot.
                run iep/bproatualiza.p (ttprot.precid,today,"",premessa).
                        
                delete ttprot.
            end.
        end. 
    end.        


    for each ttprot.
        delete ttprot.
    end.    

end procedure.

