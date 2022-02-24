def input param doperacao as char.
def input param precid  as recid.
def input param pdigita as log.
def input-output param vsel   as int.
def input-output param vabe   as dec.

def buffer btitulo for titulo.

{iep/tfilsel.i}

find titulo     where recid(titulo)     = precid no-lock.
find contrato   where contrato.contnum  = int(titulo.titnum) no-lock.
find clien of contrato no-lock.
find neuclien where neuclien.clicod = clien.clicod no-lock no-error.

    /* verifica se a parcela ja esta em algum protesto 
        neste momento não permite 2 protestos */ 
    find first titprotparc where
        titprotparc.operacao = doperacao and
        titprotparc.contnum = contrato.contnum and
        titprotparc.titpar  = titulo.titpar
        no-lock no-error.
    if avail titprotparc
    then return.        
                

find first ttfiltros.

def var vtitpar as int.
do on error undo:

    create ttparcela.
    ttparcela.clicod  = contrato.clicod.
    ttparcela.clinom  = clien.clinom . 
    ttparcela.contnum  = contrato.contnum.
    ttparcela.titpar   = titulo.titpar.
    ttparcela.trecid   = recid(titulo).
    ttparcela.titvlcob = titulo.titvlcob.
    ttparcela.titdtemi = titulo.titdtemi.
    ttparcela.titdtven = titulo.titdtven.
    ttparcela.modcod = titulo.modcod.
    ttparcela.tpcontrato = titulo.tpcontrato.
    ttparcela.marca    = ?.
    ttparcela.diasatraso = max(ttparcela.diasatraso,today - titulo.titdtven) .

    /* helio 11012022 - IEPRO */
    run juro_titulo.p (if clien.etbcad = 0 then titulo.etbcod else clien.etbcad,
                   titulo.titdtven,
                   titulo.titvlcob,
                   output ttparcela.titvljur).
    


    /* calculos do contrato */
    vtitpar = titulo.titpar.
    for each btitulo where btitulo.empcod = 19 and btitulo.titnat = no and     
            btitulo.etbcod = contrato.etbcod and btitulo.modcod = contrato.modcod and
            btitulo.clifor = contrato.clicod and btitulo.titnum = string(contrato.contnum)
            no-lock.
        if btitulo.titpar = 0 then next.

        if btitulo.titsit = "PAG"
        then do:
            ttparcela.vlrpag = ttparcela.vlrpag + btitulo.titvlcob.
            ttparcela.qtdpag = ttparcela.qtdpag + 1.
        end.
        if btitulo.titsit = "LIB"
        then do:
            ttparcela.vlrabe = ttparcela.vlrabe + btitulo.titvlcob.
            if btitulo.titdtven < today
            then do:
                ttparcela.vlratr = ttparcela.vlratr + btitulo.titvlcob.
                if  btitulo.titdtven >= today - ttfiltros.diasatrasmin and
                    btitulo.titdtven <= today - ttfiltros.diasatrasmax
                then do:
                    if today - btitulo.titdtven > ttparcela.diasatraso 
                    then do:
                        vtitpar = btitulo.titpar.
                        if not pdigita
                        then ttparcela.diasatraso = today - btitulo.titdtven.
                    end.
                end.
            end.    
        end.      
    end. 
    /*
    if not pdigita 
    then  ttparcela.titpar = vtitpar. 
    */
    
    
    if avail neuclien 
    then do:
        if neuclien.cpf = ?
        then ttparcela.marca = no.
    end.
    else do:
        ttparcela.marca = no.
    end.
         
    if ttparcela.vlrabe > 0 and
       ttparcela.marca = ? 
    then ttparcela.marca = yes.   

    
    if ttparcela.marca = no or
       ttparcela.marca = ?
    then delete ttparcela.
    else do:
        vsel = vsel + 1.
        vabe = vabe + ttparcela.vlrabe.
    end.    

end.
