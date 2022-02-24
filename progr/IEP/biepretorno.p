/* 05012022 helio iepro */

def var vi as int.
def var poperacao as char init "IEPRO".
def var pcodocorrencia as char.
def var pocorrencia as char.
def var pacao   as char.
def var parquivo as char.
def var dstatus   as char. 


def new shared temp-table ttprot
    field precid        as recid
    field protocolo     as char
    field dtprotocolo   as char
    field vlrcustas     as dec
    field codocorrencia as char
    field ocorrencia    as char.
    
for each ttprot.
    delete ttprot.
end.

    pacao = "confirmacao". 
    message "buscando " pacao.

    /* CHAMA API */ 
    parquivo = "CY742801.221".
   
    run iep/montaxml-confirmacao.p (poperacao, 
                                    input parquivo,
                                    output pcodocorrencia,        
                                    output pocorrencia).
    find first ttprot no-error.
    
    message "Ocorrencia:" pcodocorrencia pocorrencia.
    
    if avail ttprot
    then do:
    
        for each ttprot.
            find titprotesto where recid(titprotesto) = ttprot.precid
                    exclusive-lock no-wait no-error.
            if avail titprotesto
            then do:   
                if titprotesto.acao = "REMESSA"
                then do:
                    titprotesto.acao    = "". 
                    titprotesto.dtacao  = today. 
                    titprotesto.acaooper = pacao.  
                    titprotesto.protocolo = ttprot.protocolo.
                    titprotesto.dtprotocolo = ttprot.dtprotocolo.
                    titprotesto.titvlcustas = ttprot.vlrcustas.
                    titprotesto.ocorrencia = ttprot.codocorrencia.
                    
                    find titprotsit where 
                            titprotsit.operacao   = titprotesto.operacao and
                            titprotsit.ocorrencia = ttprot.codocorrencia no-lock no-error.
                    if avail titprotsit 
                    then do: 
                        titprotesto.situacao = titprotsit.situacao. 
                        titprotesto.ativo    = titprotsit.ativo. 
                    end.  
                    else do: 
                        titprotesto.situacao = ttprot.ocorrencia. 
                    end.  
                    run iep/bproatualiza.p (recid(titprotesto)).
                end.                
            end.      
            delete ttprot.
        end.
        
    end.                        
                                        
        
    for each ttprot.
        delete ttprot.
    end.    
    pacao = "retorno". 
    message "buscando " pacao.

    /* CHAMA API */ 
    parquivo = "RY742801.221".
   
    run iep/montaxml-retorno.p (poperacao, 
                                    input parquivo,
                                    output pcodocorrencia,        
                                    output pocorrencia).
    find first ttprot no-error.
    
    message "Ocorrencia:" pcodocorrencia pocorrencia.
    
    if avail ttprot
    then do:
    
        for each ttprot.
            disp ttprot.
            find titprotesto where recid(titprotesto) = ttprot.precid
                    exclusive-lock no-wait no-error.
            if avail titprotesto
            then do:   
                disp titprotesto.
                /*
                if titprotesto.acao = "REMESSA"
                then do:
                    titprotesto.acao    = "". 
                    titprotesto.dtacao  = today. 
                    titprotesto.acaooper = pacao.  
                    titprotesto.protocolo = ttprot.protocolo.
                    titprotesto.dtprotocolo = ttprot.dtprotocolo.
                    titprotesto.titvlcustas = ttprot.vlrcustas.
                    titprotesto.ocorrencia = ttprot.codocorrencia.
                    
                    find titprotsit where 
                            titprotsit.operacao   = titprotesto.operacao and
                            titprotsit.ocorrencia = ttprot.codocorrencia no-lock no-error.
                    if avail titprotsit 
                    then do: 
                        titprotesto.situacao = titprotsit.situacao. 
                        titprotesto.ativo    = titprotsit.ativo. 
                    end.  
                    else do: 
                        titprotesto.situacao = ttprot.ocorrencia. 
                    end.  
                    run iep/bproatualiza.p (recid(titprotesto)).
                end.                
                */
            end.      
            delete ttprot.
        end.
        
    end.                        

    
/***

pacao = "RETORNO". 
    for each ttprot.
        delete ttprot.
    end.    

    /* CHAMA API */
    for each titprotesto where 
                titprotesto.situacao = "xCONFIRMADO" and dtacao <> ?.
        disp titprotesto
            with title pacao.
                
        create ttprot.
        ttprot.contnum = titprotesto.contnum.
        ttprot.titpar  = titprotesto.titpar.
        ttprot.ocorrencia = "PRO".
    end.
    
    for each ttprot.
        find first titprotesto where 
                titprotesto.operacao = poperacao and
                titprotesto.contnum  = ttprot.contnum and
                titprotesto.titpar   = ttprot.titpar
                exclusive-lock no-wait no-error.
        if avail titprotesto
        then do: 

                titprotesto.acao    = "".
                titprotesto.dtacao  = today.
                titprotesto.acaooper = pacao.
                
                find titprotsit where  
                        titprotsit.operacao   = titprotesto.operacao and
                        titprotsit.ocorrencia = ttprot.ocorrencia no-lock no-error.
                if avail titprotsit
                then do:
                    titprotesto.situacao = titprotsit.situacao.
                    titprotesto.ativo    = titprotsit.ativo.
                end.
                else do:
                    titprotesto.situacao = ttprot.ocorrencia.
                end.

                run iep/bproatualiza.p (recid(titprotesto)).
                
        end.
        
    end.                        
                                        
        



***/
