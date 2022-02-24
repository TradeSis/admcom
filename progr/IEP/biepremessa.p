/* 05012022 helio iepro */

def var vi as int.
def var poperacao   as char init "IEPRO".
def var pcodocorrencia as char.
def var pocorrencia as char.
def var parquivo as char.
def var psequencial as int.

def var pacao   as char.
def var dstatus   as char. 


def new shared temp-table ttprot
    field precid        as recid.


/** **/
    pacao = "REMESSA". 
    run envia.
    
    pacao = "desistencia". 
    run envia.
    

    
/*
    pacao = "AUT.DESISTENCIA". 
    
    for each titprotesto where  titprotesto.operacao = poperacao and
                                titprotesto.acao     = pacao     and
                                titprotesto.dtacao   = ?
            no-lock.
        disp titprotesto
        with title pacao.    

        create ttprot.
        ttprot.precid  = recid(titprotesto).   
    end.

    pacao = "CANCELAMENTO". 
    
    for each titprotesto where  titprotesto.operacao = poperacao and
                                titprotesto.acao     = pacao     and
                                titprotesto.dtacao   = ?
            no-lock.
        disp titprotesto
        with title pacao.    

        create ttprot.
        ttprot.precid  = recid(titprotesto).   
    end.


    
    /* GERA XML */
    for each ttprot.
    
    end.

    /* ENVIA IEPRO - CHAMADA API */
    for each ttprot.
    
    end.
    
    /* MARCA COMO ENVIADO */
    for each ttprot.

            find titprotesto where recid(titprotesto) = ttprot.precid exclusive no-wait no-error.
            titprotesto.dtacao = today.
            titprotesto.acaooper    = "".    
            
            run iep/bproatualiza.p (recid(titprotesto)).
            
        
    end.
     
        


***/


procedure envia.

    for each ttprot.
        delete ttprot.
    end.        
        
    for each titprotesto where  titprotesto.operacao = poperacao and
                                titprotesto.acao     = pacao     and
                                titprotesto.dtacao   = ?
            no-lock.
        disp titprotesto
        with title pacao.    
        create ttprot.
        ttprot.precid  = recid(titprotesto).   
    end.

    find first ttprot no-error.
    if avail ttprot
    then do:
        if pacao = "remessa"
        then do:
            parquivo    = "BY742801.223".
            psequencial = 470 .
            /* GERA XML e ENVIA IEPRO - CHAMADA API */
            run iep/montaxml-remessa.p (    input poperacao,
                                            input parquivo,            
                                            input psequencial,
                                            output pcodocorrencia,
                                            output pocorrencia).

            message "Final montaxml-remessa" pcodocorrencia pocorrencia.
            pause.
            
        end.
        
        if pacao = "desistencia"
        then do:
            parquivo = "DPY742801.222".
            psequencial = 0.
            /* GERA XML e ENVIA IEPRO - CHAMADA API */
            run iep/montaxml-cancelamentos.p (    input poperacao,
                                            input pacao,
                                            input parquivo,            
                                            output pcodocorrencia,
                                            output pocorrencia).

            message "Final montaxml-cancelamentos" pacao pcodocorrencia pocorrencia.
            pause.
            
        end.
                
   
    
        if pcodocorrencia = "0000" /*"REGISTROS OK"*/
        then do:

        /* MARCA COMO ENVIADO */
            for each ttprot.
        
                find titprotesto where recid(titprotesto) = ttprot.precid exclusive no-wait no-error.
                titprotesto.dtacao      = today.
                titprotesto.acaooper    = "".    
                run iep/bproatualiza.p (recid(titprotesto)).
                        
                delete ttprot.
            end.
        end. 
    end.        


    for each ttprot.
        delete ttprot.
    end.    

end procedure.
