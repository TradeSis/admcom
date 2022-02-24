def var p-valor as char.
def var arq_retorno as char.
def var arq_erro as char.
def var arq_temp as char.
def var arq_envio as char.

def temp-table tt-retorno
    field varq as char.
def temp-table tt-erro
    field varq as char.
def temp-table tt-temp
    field varq as char.
def temp-table tt-envio
    field varq as char.
    
p-valor = "".
run /admcom/progr/le_tabini.p (0, 0,
            "NFE - DIRETORIO ENVIO ARQUIVO", OUTPUT p-valor) .
arq_envio = p-valor.

p-valor = "".
run /admcom/progr/le_tabini.p (0, 0,
            "NFE - DIRETORIO RETORNO ARQUIV", OUTPUT p-valor) .
arq_retorno = p-valor.

p-valor = "".
run /admcom/progr/le_tabini.p (0, 0,
            "NFE - DIRETORIO ERRO ARQUIVO", OUTPUT p-valor) .
arq_erro = p-valor.

p-valor = "".
run /admcom/progr/le_tabini.p (0, 0,
            "NFE - DIRETORIO TEMP ARQUIV", OUTPUT p-valor) .
arq_temp = p-valor.

FUNCTION pega_xml returns character
    (input par-oque as char,
     input par-onde as char).
         
    def var vx as int.
    def var vret as char.  
    
    vret = ?.  
    
    do vx = 1 to num-entries(par-onde,"<"). 
        if entry(1,entry(vx,par-onde,"<"),">") = par-oque 
        then do: 
            vret = entry(2,entry(vx,par-onde,"<"),">"). 
            leave. 
        end. 
    end.
    return vret. 
END FUNCTION.
def var v-tpamb as int format "9" init 2. 
p-valor = "".
run /admcom/progr/le_tabini.p (0, 0,
            "NFE - AMBIENTE", OUTPUT p-valor) .
if p-valor = "PRODUCAO"
then v-tpamb = 1.

def var varquivo as char format "x(70)".
def var varqsai as char format "x(70)".
def var varqlog as char format "x(70)".
def var varq as char format "x(70)".
varqlog = "/admcom/nfe/erp/arq.log".
def var vret as char format "x(14)".
def var v-cstat as char.
def var v-chnfe as char.
def var v-xmotivo as char.

def temp-table tt-infnfe like A01_infnfe.

repeat:
    if search("/admcom/progr/predevcmp_nfe.p") <> ?
    then run predevcmp_nfe.p .
     
    for each tt-infnfe: delete tt-infnfe. end.
    
    for each A01_infnfe where A01_infnfe.solicitacao <> "" no-lock:
        create tt-infnfe.
        buffer-copy A01_infnfe to tt-infnfe.
    end.
        
    for each tt-infnfe:
        
        pause 2 no-message.
        
        assign
            varquivo = "" 
            varqsai = "".
        /*
        message tt-infnfe.solicitacao. pause.
        */
        if tt-infnfe.solicitacao = "Re-Impressao"
        then do:
            varquivo = "".
            varquivo = arq_envio + tt-infnfe.id + "_danfe.txt".
        
            pause 1 no-message.
        
            if search(varquivo) = ?
            then do transaction:
                find A01_infnfe where A01_infnfe.chave = tt-infnfe.chave
                               exclusive no-wait no-error.
                if avail A01_infnfe
                then do:
                    assign
                        A01_infnfe.situacao = "Autorizada"
                        A01_infnfe.solicitacao = "".
                    run ultimo-evento.
                end.    
            end.    
        end.
        else if tt-infnfe.solicitacao = "Re-envio email"
        then do:
            varquivo = "".
            varquivo = arq_envio + tt-infnfe.id + "_email.txt".
        
            pause 1 no-message.
        
            if search(varquivo) = ?
            then do transaction:
                find A01_infnfe where A01_infnfe.chave = tt-infnfe.chave
                               exclusive no-wait no-error.
                if avail A01_infnfe
                then do:
                    assign
                        A01_infnfe.situacao = "Autorizada"
                        A01_infnfe.solicitacao = "".
                    run ultimo-evento.
                end.             
            end.
        end.
        else if tt-infnfe.solicitacao = "Cancelamento"
        then do:
            varquivo = "".
            if substr(string(tt-infnfe.id),1,3) = "NFe"
            then varquivo = arq_retorno + 
                    substr(string(tt-infnfe.chave),4,34) + "_retCancNFe.xml".
            else  varquivo = arq_retorno + tt-infnfe.id + "_retCancNFe.xml".
        
            pause 1 no-message.

            if search(varquivo) <> ?
            then do transaction:
                p-valor = "".
                run /admcom/progr/le_xml.p(input varquivo, 
                                            input "cStat", 
                                        output p-valor).
                v-cstat = p-valor.
                if v-cstat <> ""
                then do:
                    find A01_infnfe where A01_infnfe.chave = tt-infnfe.chave
                               exclusive no-wait no-error.
                    if avail A01_infnfe
                    then do:
                        A01_infnfe.sitnfe = int(v-cstat).
                        if v-cstat = "101"
                        then do:
                            assign
                                A01_infnfe.situacao = "Cancelada"
                                A01_infnfe.solicitacao = ""
                                .
                             if v-tpamb = 1
                             then run canc-movimento.
                        end.        
                        else A01_infnfe.aguardando =
                                    "Intervenção-Rejeição SEFAZ"
                                        .
                                        
                        run ultimo-evento.
                    end.
                end.             
            end.
        end.
        else if tt-infnfe.solicitacao = "Inutilizacao"
        then do:            
            varquivo = "".
            if substr(string(tt-infnfe.id),1,3) = "NFe"
            then varquivo = arq_retorno + 
                 substr(string(tt-infnfe.chave),4,34) + "_retInutNFe.xml".
            else  varquivo = arq_retorno + tt-infnfe.id + "_retInutNFe.xml".
        
            pause 1 no-message.
                
            if search(varquivo) <> ?
            then do:
                p-valor = "".
                run /admcom/progr/le_xml.p(input varquivo, 
                                            input "cStat", 
                                        output p-valor).
                v-cstat = p-valor.
                if v-cstat <> ""
                then do transaction:
                    find A01_infnfe where A01_infnfe.chave = tt-infnfe.chave
                               exclusive no-wait no-error.
                    if avail A01_infnfe
                    then do:
                        A01_infnfe.sitnfe = int(v-cstat).
                        if v-cstat = "102"
                        then do:
                            assign
                                A01_infnfe.situacao = "Inutilizada"
                                A01_infnfe.solicitacao = ""
                                .
                        end.
                        else A01_infnfe.aguardando =
                                    "Intervenção-Rejeição SEFAZ"
                                        .
                                        
                        run ultimo-evento.
                    end.
                end.
            end.
            else do:
                varquivo = "".
            if substr(string(tt-infnfe.id),1,3) = "NFe"
            then varquivo = arq_retorno + 
                    substr(string(tt-infnfe.chave),4,34) + "*".
            else  varquivo = arq_retorno + tt-infnfe.id + "_retCancNFe.xml".
        
            pause 1 no-message.

            varqsai = "/admcom/nfe/erp/" + tt-infnfe.chave.
    
            output to value(varqlog).                
            unix silent value("ls " + varquivo + " > " + varqsai).
            output close.

            input from value(varqsai).
            repeat:
                import varquivo.
                leave.
            end.    
            input close.    

            if search(varquivo) <> ?
            then do transaction:
                p-valor = "".
                run /admcom/progr/le_xml.p(input varquivo, 
                                            input "cStat", 
                                        output p-valor).
                v-cstat = p-valor.
                if v-cstat <> ""
                then do:
                    find A01_infnfe where A01_infnfe.chave = tt-infnfe.chave
                               exclusive no-wait no-error.
                    if avail A01_infnfe
                    then do:
                        A01_infnfe.sitnfe = int(v-cstat).
                        if v-cstat = "101"
                        then do:
                            assign
                                A01_infnfe.situacao = "Cancelada"
                                A01_infnfe.solicitacao = ""
                                .
                             if v-tpamb = 1
                             then run canc-movimento.
                        end.        
                        else A01_infnfe.aguardando =
                                    "Intervenção-Rejeição SEFAZ"
                                        .
                                        
                        run ultimo-evento.
                    end.
                end.             
            end.

            end.    
        end.
        else do: 
            
            assign
                varquivo = arq_retorno +
                        substr(string(tt-infnfe.chave),4,50) + "*"
                varqsai = "/admcom/nfe/erp/" + tt-infnfe.chave.
    
            
            output to value(varqlog).                
            unix silent value("ls " + varquivo + " > " + varqsai).
            output close.

            assign
                v-chnfe = ""
                v-cstat = ""
                v-xmotivo = ""
                varq = ""
                vret = "".
    
            pause 1 no-message.
    
            if search(varqsai) <> ?
            then do:
                input from value(varqsai).
                repeat:
                    import unformatted varq.
                    if entry(2,varq,"_") = "retConsReciNFe.xml"
                    then leave.
                end.
                input close.

                if varq <> ""
                then do:
                    vret = entry(2,varq,"_").
                    if vret = "retConsReciNFe.xml" and tt-infnfe.situacao = ""
                    then do:
                        p-valor = "".
                        run /admcom/progr/le_xml.p(input varq, input "chNFe", 
                                    output p-valor).
                        v-chnfe = p-valor.
                        p-valor = "".
                        run /admcom/progr/le_xml.p(input varq, input "cStat", 
                                        output p-valor).
                        v-cstat = p-valor.
                        if v-cstat <> ""
                        then do transaction:
                            find A01_infnfe where 
                                    A01_infnfe.chave = tt-infnfe.chave
                                    exclusive no-wait no-error.
                            if avail A01_infnfe
                            then do :
                                A01_infnfe.sitnfe = int(v-cstat).
                                if A01_infnfe.sitnfe = 100
                                then do:
                                    assign
                                        A01_infnfe.id = v-chnfe
                                        A01_infnfe.sitnfe = int(v-cstat)
                                        A01_infnfe.situacao = "Autorizada"
                                        A01_infnfe.solicitacao = ""
                                        .

                                    if v-tpamb = 1
                                    then run cria-movimento.     
                                end.
                                else do:
                                    A01_infnfe.aguardando = 
                                        "Intervenção-Rejeição SEFAZ"
                                        .
                                end.
                                run ultimo-evento.
                            end.
                        end.
                    end.
                    else if vret = "retConsSitNFe.xml" and 
                           tt-infnfe.situacao = ""
                    then do:
                        p-valor = "".
                        run /admcom/progr/le_xml.p(input varq, input "xmotivo", 
                                        output p-valor).
                        v-xmotivo = p-valor.
                        p-valor = "".
                        run /admcom/progr/le_xml.p(input varq, input "cStat", 
                                        output p-valor).
                        v-cstat = p-valor.

                        if v-cstat <> ""
                        then do transaction:
                            find A01_infnfe where
                                    A01_infnfe.chave = tt-infnfe.chave
                                    exclusive no-wait no-error.
                            if avail A01_infnfe
                            then do:

                                A01_infnfe.sitnfe = int(v-cstat).
                                
                                if v-cstat = "100"
                                then do:
                                    assign
                                        A01_infnfe.id = v-chnfe
                                        A01_infnfe.sitnfe = int(v-cstat)
                                        A01_infnfe.situacao = "Autorizada"
                                        A01_infnfe.solicitacao = ""
                                     .

                                    if v-tpamb = 1
                                    then run cria-movimento.     
                                end.
                                else A01_infnfe.aguardando =
                                    "Intervenção-Rejeicao SEFAZ"
                                    .
                                    
                                run ultimo-evento.
                            end.
                        end.
                    end.
                    else if vret = "retEnviNFe.xml" and
                            tt-infnfe.situacao = ""
                    then do transaction:

                        find A01_infnfe where 
                                A01_infnfe.chave = tt-infnfe.chave
                               exclusive no-wait no-error.
                        if avail A01_infnfe
                        then do:
                            assign
                                A01_infnfe.sitnfe = 0
                                A01_infnfe.aguardando = "Consulta"
                                .
                            
                            run ultimo-evento.
                        end.
                    end.
                    else if vret = "retCncNFe.xml" and
                           tt-infnfe.solicitacao = "Cancelamento" 
                    then do:
                        p-valor = "".
                        run /admcom/progr/le_xml.p(input varq, input "cStat", 
                                    output p-valor).
                        v-cstat = p-valor.
                        if v-cstat = "101"
                        then do transaction:
                            find A01_infnfe where 
                                    A01_infnfe.chave = tt-infnfe.chave
                                    exclusive no-wait no-error.
                            if avail A01_infnfe
                            then do:

                                assign
                                    A01_infnfe.sitnfe = int(v-cstat)
                                    A01_infnfe.situacao = "Cancelada"
                                    A01_infnfe.solicitacao = ""
                                    .
                                if v-tpamb = 1
                                then run canc-movimento.
                                
                                run ultimo-evento.
                            end.
                        end.
                    end.
                    else if vret = "retInutNFe.xml" and
                            tt-infnfe.solicitacao = "Inutilizacao"      
                    then do:
                        p-valor = "".
                        run /admcom/progr/le_xml.p(input varq, input "cStat", 
                                    output p-valor).
                        v-cstat = p-valor.
                        if v-cstat = "102"
                        then do transaction:
                            find A01_infnfe where
                                    A01_infnfe.chave = tt-infnfe.chave
                                    exclusive no-wait no-error.
                            if avail A01_infnfe
                            then do:
                                assign
                                    A01_infnfe.sitnfe = int(v-cstat)
                                    A01_infnfe.situacao = "Inutilizada"
                                    A01_infnfe.solicitacao = ""
                                    .
                
                                run ultimo-evento.
                            end.
                        end.
                    end.
                end.
                else if tt-infnfe.solicitacao = "Autorizacao"
                then do:
                    varquivo = arq_erro + tt-infnfe.chave + ".txt-erro.txt".
                
                    pause 1 no-message.
            
                    if search(varquivo) <> ?
                    then do transaction:
                        find A01_infnfe where
                            A01_infnfe.chave = tt-infnfe.chave
                               exclusive no-wait no-error.
                        if avail A01_infnfe
                        then do:
                            assign
                                A01_infnfe.sitnfe = 0
                            A01_infnfe.aguardando = "Intervenção-Erro parser"
                            .
                            run ultimo-evento.
                        end.
                    end.
                end.
                unix silent value("rm " + varqsai).
            end.
            else do:
                varquivo = arq_erro + tt-infnfe.chave + ".txt-erro.txt".
                
                pause 1 no-message.
                
                if search(varquivo) <> ?
                then do transaction:
                    find A01_infnfe where
                            A01_infnfe.chave = tt-infnfe.chave
                               exclusive no-wait no-error.
                    if avail A01_infnfe
                    then do:
                        assign
                            A01_infnfe.sitnfe = 0
                         A01_infnfe.aguardando = "Intervenção-Erro parser"
                        .
                        run ultimo-evento.
                    end.
                end.
                else do:
                    varquivo = arq_envio + A01_infnfe.chave + ".txt".
                    if search(varquivo) = ?
                    then do transaction:
                        find A01_infnfe where
                            A01_infnfe.chave = tt-infnfe.chave
                               exclusive no-wait no-error.
                        if avail A01_infnfe
                        then do:
                            A01_infnfe.aguardando = "Consulta".
                            run ultimo-evento.
                        end.
                    end.
                end. 
            end.
        end.    
    end.

    pause 1 no-message.
    do transaction:
    find first tab_log where tab_log.etbcod = 0 and
                        tab_log.nome_campo = "NFe" and
                        tab_log.valor_campo = "polling" and
                        tab_log.dtinclu = today
                        exclusive no-wait no-error.
    if not avail tab_log
    then do :
        if not locked tab_log
        then do:
            create tab_log.
            assign
                tab_log.nome_campo = "NFe"
                tab_log.valor_campo = "polling"
                tab_log.dtinclu = today
            .
        end.
    end.
    if avail tab_log
    then tab_log.hrinclu = time.
    end.
    pause 1 no-message.

end.
 
procedure cria-movimento:
    def var vplacod like plani.placod.
    def buffer bplani for plani.
    def var recmov as recid.
    
    find placon where placon.etbcod = A01_infnfe.etbcod and
                      placon.emite  = A01_infnfe.emite and
                      placon.serie  = A01_infnfe.serie and
                      placon.numero = A01_infnfe.numero
                      no-lock no-error.
    if avail placon
    then do:                  
        /**
        find last bplani where bplani.etbcod = estab.etbcod and
                           bplani.placod <= 500000 and
                           bplani.placod <> ? no-lock no-error.
        if not avail bplani
        then vplacod = 1.
        else vplacod = bplani.placod + 1.
        */
        vplacod = placon.placod.
        create plani.
        buffer-copy placon to plani.
        plani.placod = vplacod.
        
        
        for each movcon where movcon.etbcod = placon.etbcod and
                              movcon.placod = placon.placod and
                              movcon.movtdc = placon.movtdc
                              no-lock:
            create movim.
            buffer-copy movcon to movim.
            movim.placod = vplacod.
            recmov = recid(movim).
            find movim where recid(movim) = recmov no-lock.
            if placon.crecod <> 2
            then
            run /admcom/progr/atuest.p (input recid(movim),
                      input "I",
                      input 0).
        end. 
        plani.notsit = no.
    end.
end procedure.
procedure canc-movimento:
    def var vplacod like plani.placod.
    def buffer bplani for plani.
    def var recmov as recid.
    
    find placon where placon.etbcod = A01_infnfe.etbcod and
                      placon.emite  = A01_infnfe.emite and
                      placon.serie  = A01_infnfe.serie and
                      placon.numero = A01_infnfe.numero
                      no-lock no-error.
    if avail placon
    then do:  
        find plani where plani.etbcod = placon.etbcod and
                         plani.emite  = placon.emite and
                         plani.serie = placon.serie and
                         plani.numero = placon.numero
                          no-error.
        if avail plani
        then do:
            for each movim where movim.etbcod = plani.etbcod and
                              movim.placod = plani.placod and
                              movim.movtdc = plani.movtdc
                              no-lock:
                run /admcom/progr/atuest.p (input recid(movim),
                      input "E",
                      input 0).
            end.
            if A01_infnfe.situacao = "CANCELADA"
            THEN DO:
            find planiaux where planiaux.etbcod = plani.etbcod and
                         planiaux.emite  = plani.emite and
                         planiaux.serie = plani.serie and
                         planiaux.numero = plani.numero and
                         planiaux.nome_campo = "SITUACAO" AND
                         planiaux.valor_campo = "CANCELADA"
                         NO-LOCK no-error.
            if not avail planiaux
            THEN DO:
                create planiaux.
                assign
                    planiaux.etbcod = plani.etbcod 
                    planiaux.placod = plani.placod
                    planiaux.emite  = plani.emite 
                    planiaux.serie = plani.serie 
                    planiaux.numero = plani.numero 
                    planiaux.nome_campo = "SITUACAO" 
                    planiaux.valor_campo = "CANCELADA"
                    .
                                             
            END.
            END.
            plani.notsit = yes.
        end.
        else do:
            if A01_infnfe.situacao = "INUTILIZADA"
            THEN DO:
            find planiaux where planiaux.etbcod = placon.etbcod and
                         planiaux.emite  = placon.emite and
                         planiaux.serie = placon.serie and
                         planiaux.numero = placon.numero and
                         planiaux.nome_campo = "SITUACAO" AND
                         planiaux.valor_campo = "INUTILIZADA"
                         NO-LOCK no-error.
            if not avail planiaux
            THEN DO:
                create planiaux.
                assign
                    planiaux.etbcod = placon.etbcod 
                    planiaux.placod = placon.placod
                    planiaux.emite  = placon.emite 
                    planiaux.serie = plani.serie 
                    planiaux.numero = plani.numero 
                    planiaux.nome_campo = "SITUACAO" 
                    planiaux.valor_campo = "INUTILIZADA"
                    .
            END.
            END.

        end.                              
    end.
end procedure.
procedure ultimo-evento:
    find first tab_log where tab_log.etbcod = A01_InfNFe.etbcod and
                        tab_log.nome_campo = "NFe-UltimoEvento" and
                        tab_log.valor_campo = A01_InfNFe.chave
                         no-error.
                if not avail tab_log
                then do:
                    create tab_log.
                    assign
                        tab_log.etbcod = A01_InfNFe.etbcod
                        tab_log.nome_campo = "NFe-UltimoEvento"
                        tab_log.valor_campo = A01_InfNFe.chave
                        .
                end.
                assign
                    tab_log.dtinclu = today
                    tab_log.hrinclu = time.
 
end procedure.

