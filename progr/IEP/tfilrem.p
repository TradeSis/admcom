/* 05012022 helio iepro */

{admcab.i}

def input param poperacao   as char.
def input param ctitle      as char.
def input param copcao      as char.

def var xtime as int.
def var vconta as int.
def var pfiltro as char.
def var recatu1         as recid.
def var recatu2     as reci.
def var reccont         as int.
def var esqpos1         as int.
def var esqcom1         as char format "x(9)" extent 7
    initial ["filtrar","parcelas","marca","todos","juros","enviar","digitar"].

form
    esqcom1
    with frame f-com1 row 5 no-box no-labels column 1 centered.

assign
    esqpos1  = 1.

def buffer btitulo for titulo.
def var vsel as int.
def var vabe as dec.

{iep/tfilsel.i new}
    
def buffer bttparcela for ttparcela.
def var vtitvlcob   like ttparcela.vlrabe.
def var vvlmar      like ttparcela.vlrabe.
def var vtitvljur   like ttparcela.vlrabe.
def var vvlmarjur      like ttparcela.vlrabe.
def var vtitvltot   like ttparcela.vlrabe.
def var vvlmartot      like ttparcela.vlrabe.

    form  
        ttparcela.marca format "*/ "            column-label "*" space(0)
        contrato.etbcod                         column-label "fil"
        titulo.modcod  format "x(03)"           column-label "mod" space(0)
        titulo.tpcontrato format "x"            column-label "t"

        contrato.contnum format ">>>>>>>>>9"
        titulo.titpar format ">9"              column-label "pr"
        contrato.clicod                         column-label "cliente"
        titulo.titdtemi format "999999"         column-label "dtemi"
/*        ttparcela.vlrctr      column-label "vl ctr"    format ">>>>9.99" */
                                            
/*        ttparcela.vlratr      column-label "vl atras"    format ">>>>9.99" */
        
        titulo.titdtven format "999999"         column-label "venc"
        
        titulo.titvlcob      column-label "parc"      format ">>>>9.99"
        ttparcela.titvljur   column-label "juros"     format ">>>9.99" 
        ttparcela.diasatraso column-label "d atr"     format "-99999"

        with frame frame-a 9 down centered row 7
        no-box.




disp 
    ctitle format "x(60)" no-label
        with frame ftit
            side-labels
            row 3
            centered
            no-box
            color messages.



if copcao = "Filtro"
then do:
    esqcom1[1] = "filtrar".
    create ttfiltros.
    run iep/tfilsel.p (input poperacao).
    find first ttparcela no-error.
    if not avail ttparcela
    then return.
end.
if copcao = "arquivo csv"
then do:
    esqcom1[1] = "".
    run finct/trocobcsv.p .
end.
if copcao = "digitar"
then do:
    esqcom1[1] = "".
    run digitaContrato.
end.



disp 
    vtitvlcob    label "filtrado"      format "zzzzzzzz9.99" colon 15
    vtitvljur    label "juros"      format "zzzzzzzz9.99" colon 35
    vtitvltot    label "total"      format "zzzzzzzz9.99" colon 65
    
    vvlmar       label "marcado"       format "zzzzzzzz9.99" colon 15
    vvlmarjur    label "juros"       format "zzzzzzzz9.99" colon 35
    vvlmartot    label "total"       format "zzzzzzzz9.99" colon 65
    
        with frame ftot
            side-labels
            row screen-lines - 2
            width 80
            no-box.



bl-princ:
repeat:
    
   vtitvlcob = 0. vvlmar = 0.      
   vtitvljur = 0. vvlmarjur = 0.      
   vtitvltot = 0. vvlmartot = 0.      
   
   for each ttparcela .
        find titulo where recid(titulo) = ttparcela.trecid no-lock.
        vtitvlcob = vtitvlcob + titulo.titvlcob.
        vtitvljur = vtitvljur + ttparcela.titvljur.
        vtitvltot = vtitvltot + titulo.titvlcob + ttparcela.titvljur.
        
        if ttparcela.marca
        then do:
            vvlmar      = vvlmar + titulo.titvlcob.
            vvlmarjur   = vvlmarjur + ttparcela.titvljur.
            vvlmartot   = vvlmartot + titulo.titvlcob + ttparcela.titvljur.
            
        end.    

   end.
    disp
        vtitvlcob
        vtitvljur vtitvltot
        vvlmar
        vvlmarjur vvlmartot
        with frame ftot.

    disp esqcom1 with frame f-com1.
    if recatu1 = ?
    then run leitura (input "pri").
    else find ttparcela where recid(ttparcela) = recatu1 no-lock.
    if not available ttparcela
    then do.
        return.
        
    end.
    clear frame frame-a all no-pause.
    run frame-a.

    recatu1 = recid(ttparcela).
    color display message esqcom1[esqpos1] with frame f-com1.
    repeat:
        run leitura (input "seg").
        if not available ttparcela
        then leave.
        if frame-line(frame-a) = frame-down(frame-a)
        then leave.
        down with frame frame-a.
        run frame-a.
    end.
    up frame-line(frame-a) - 1 with frame frame-a.

    repeat with frame frame-a:

        find ttparcela where recid(ttparcela) = recatu1 no-lock.
        find titulo where recid(titulo) = ttparcela.trecid no-lock.

        status default "".
        
                        
                     
        def var vx as int.
        def var va as int.
        va = 1.
        do vx = 1 to 6.
            if esqcom1[vx] = ""
            then next.
            esqcom1[va] = esqcom1[vx].
            va = va + 1.  
        end.
        vx = va.
        do vx = va to 6.
            esqcom1[vx] = "".
        end.     
        
        
        
        disp esqcom1 with frame f-com1.
        
        run color-message.
            
        choose field titulo.titpar
            help "Selecione a opcao" 

                go-on(cursor-down cursor-up
                      cursor-left cursor-right
                      page-down   page-up
                      L l
                      tab PF4 F4 ESC return).

                run color-normal.
        hide message no-pause.
                 
        pause 0. 

                                                                
            if keyfunction(lastkey) = "cursor-right"
            then do:
                color display normal esqcom1[esqpos1] with frame f-com1.
                esqpos1 = if esqpos1 = 7 then 7 else esqpos1 + 1.
                color display messages esqcom1[esqpos1] with frame f-com1.
                next.
            end.
            if keyfunction(lastkey) = "cursor-left"
            then do:
                color display normal esqcom1[esqpos1] with frame f-com1.
                esqpos1 = if esqpos1 = 1 then 1 else esqpos1 - 1.
                color display messages esqcom1[esqpos1] with frame f-com1.
                next.
            end.
            if keyfunction(lastkey) = "page-down"
            then do:
                do reccont = 1 to frame-down(frame-a):
                    run leitura (input "down").
                    if not avail ttparcela
                    then leave.
                    recatu1 = recid(ttparcela).
                end.
                leave.
            end.
            if keyfunction(lastkey) = "page-up"
            then do:
                do reccont = 1 to frame-down(frame-a):
                    run leitura (input "up").
                    if not avail ttparcela
                    then leave.
                    recatu1 = recid(ttparcela).
                end.
                leave.
            end.
            if keyfunction(lastkey) = "cursor-down"
            then do:
                run leitura (input "down").
                if not avail ttparcela
                then next.
                if frame-line(frame-a) = frame-down(frame-a)
                then scroll with frame frame-a.
                else down with frame frame-a.
            end.
            if keyfunction(lastkey) = "cursor-up"
            then do:
                run leitura (input "up").
                if not avail ttparcela
                then next.
                if frame-line(frame-a) = 1
                then scroll down with frame frame-a.
                else up with frame frame-a.
            end.
 
        if keyfunction(lastkey) = "end-error"
        then leave bl-princ.
                
                
                /**
            if keyfunction(lastkey) = "L" or
               keyfunction(lastkey) = "l"
            then do:
                hide frame fcab no-pause.
                hide frame f-com1 no-pause.
                hide frame frame-a no-pause.                
                run fin/fqanadoc.p 
                        (   ctitle + "/" + pfiltro,
                            poldfiltro, 
                            pfiltro,
                            ttparcela.ctmcod,
                            contrato.modcod,
                            contrato.tpcontrato,
                            ttparcela.etbcod,
                            ttparcela.cobcod).

                leave.
            end.

                **/
                
        if keyfunction(lastkey) = "return"
        then do:
            
            if esqcom1[esqpos1] = "digitar"
            then do:
                run digitaContrato.
                disp 
                    ctitle format "x(60)" no-label
                        with frame ftit.

                recatu1 = ?.
                leave.
            end.
            
            if esqcom1[esqpos1] = "filtrar"
            then do:
                run iep/tfilsel.p.
                disp 
                    ctitle format "x(60)" no-label
                        with frame ftit.
                
                recatu1 = ?. 
                leave.
            end.            

            if esqcom1[esqpos1] = "parcelas"
            then do:
                run conco_v1701.p (string(ttparcela.contnum)).
                disp 
                    ctitle format "x(60)" no-label
                        with frame ftit.
                
            end.

            if esqcom1[esqpos1] = "marca"
            then do:
                if ttparcela.marca
                then do:
                    vvlmar      = vvlmar - titulo.titvlcob.
                    vvlmarjur   = vvlmarjur - ttparcela.titvljur.
                    vvlmartot   = vvlmartot - (titulo.titvlcob + ttparcela.titvljur).
                    
                end.    
                else do:
                    vvlmar      = vvlmar + titulo.titvlcob.
                    vvlmarjur   = vvlmarjur + ttparcela.titvljur.
                    vvlmartot   = vvlmartot + titulo.titvlcob + ttparcela.titvljur.
                    
                end.    
                disp vvlmar vvlmarjur vvlmartot with frame ftot.
                ttparcela.marca = not ttparcela.marca.
                disp ttparcela.marca with frame frame-a. 
                
                next.
            end.
            if esqcom1[esqpos1] = "todos"
            then do:
                def var vmarca as log.
                recatu2 = recatu1.
                vmarca = ttparcela.marca.
                for each bttparcela.
                    bttparcela.marca = not vmarca.
                end.
                leave.
            end.
             if esqcom1[esqpos1] = "juros"
             then do:
                do on error undo:
                    update ttparcela.titvljur.
                end.
             end.
            
            if esqcom1[esqpos1] = "enviar"
            then do: 
                disp caps(esqcom1[esqpos1]) @ esqcom1[esqpos1] with frame f-com1.

                do with frame fcab
                        row 6 centered
                    side-labels overlay
                    title " ENVIO ".

                    update  skip(1)
                            ttfiltros.arrastaparcelasvencidas        label "ARRASTO NO MESMO CONTRATO - todas as parcelas          ?"    colon 60.
                    if ttfiltros.arrastaparcelasvencidas = yes
                    then ttfiltros.arrastaparcelas = no.
                    else do:
                        update            
                            ttfiltros.arrastaparcelas                label "                          - todas as parcelas vencidas ?"    colon 60.
                    end.
                    update  skip(1)
                            ttfiltros.arrastacontratosvencidos        label "ARRASTO OUTROS CONTRATOS  - todos os contratos         ?"    colon 60.
                    if ttfiltros.arrastacontratosvencidos = yes
                    then ttfiltros.arrastacontratos = no.
                    else do:
                        update            
                            ttfiltros.arrastacontratos               label "                             todos os contratos vencidos?"    colon 60
                            skip(1).
                    end.
                
                    message "confirma enviar registros macados para " poperacao "?" update sresp.
                    if sresp
                    then  run iep/ptitpenvia.p (input poperacao).
                    
                    return.
                end.
            end.

                
             
        end.
        run frame-a.
        display esqcom1[esqpos1] with frame f-com1.
        recatu1 = recid(ttparcela).
    end.
    if keyfunction(lastkey) = "end-error"
    then do:
        view frame fc1.
        view frame fc2.
    end.
end.
hide frame f-com1  no-pause.
hide frame frame-a no-pause.
hide frame ftit no-pause.
hide frame ftot no-pause.
return.
 
procedure frame-a.
    find contrato where contrato.contnum = ttparcela.contnum no-lock.
    find titulo where recid(titulo) = ttparcela.trecid no-lock. 
    
    display  
        ttparcela.marca 
        contrato.etbcod  
        contrato.contnum 
        titulo.titpar 
        contrato.clicod
        titulo.titdtemi
        titulo.titdtven
        titulo.modcod  
        titulo.tpcontrato 
/*        ttparcela.vlrctr  */
/*        ttparcela.vlratr  */
        titulo.titvlcob  
         ttparcela.titvljur
        ttparcela.diasatraso 
        with frame frame-a.


end procedure.

procedure color-message.
    color display message
        ttparcela.marca 
        contrato.etbcod  
        contrato.contnum 
        titulo.titpar 
        contrato.clicod
        titulo.titdtemi
        titulo.titdtven
        titulo.modcod  
        titulo.tpcontrato 
/*        ttparcela.vlrctr  */
/*        ttparcela.vlratr  */
        titulo.titvlcob  
        ttparcela.titvljur
        ttparcela.diasatraso 
                    
        with frame frame-a.
end procedure.


procedure color-input.
    color display input
        ttparcela.marca 
        contrato.etbcod  
        contrato.contnum 
        titulo.titpar 
        contrato.clicod
        titulo.titdtemi
        titulo.titdtven
        titulo.modcod  
        titulo.tpcontrato 
/*        ttparcela.vlrctr  */
/*        ttparcela.vlratr  */
        titulo.titvlcob  
        ttparcela.titvljur
        ttparcela.diasatraso 
                    
        with frame frame-a.
end procedure.


procedure color-normal.
    color display normal
        ttparcela.marca 
        contrato.etbcod  
        contrato.contnum 
        titulo.titpar 
        contrato.clicod
        titulo.titdtemi
        titulo.titdtven
        titulo.modcod  
        titulo.tpcontrato 
/*        ttparcela.vlrctr  */
/*        ttparcela.vlratr  */
        titulo.titvlcob  
        ttparcela.titvljur
        ttparcela.diasatraso 

        with frame frame-a.
end procedure.

procedure leitura . 
def input parameter par-tipo as char.
        
if par-tipo = "pri" 
then do:
    if pfiltro = "ComBoleto"
    then do:
        find first ttparcela  where
                no-lock no-error.
    end.
    else
    if pfiltro = "SemBoleto"
    then do:
        find first ttparcela where
            no-lock no-error.
    end.
    else do:
        find first ttparcela
            no-lock no-error.
    end.    
    
            
end.    
                                             
if par-tipo = "seg" or par-tipo = "down" 
then do:
    if pfiltro = "ComBoleto"
    then do:
        find next ttparcela  where
                no-lock no-error.
    end.
    else
    if pfiltro = "SemBoleto"
    then do:
        find next ttparcela where
            no-lock no-error.
    end.
    else do:
        find next ttparcela
            no-lock no-error.
    end.    

end.    
             
if par-tipo = "up" 
then do:
    if pfiltro = "ComBoleto"
    then do:
        find prev ttparcela  where
                no-lock no-error.
    end.
    else
    if pfiltro = "SemBoleto"
    then do:
        find prev ttparcela where
            no-lock no-error.
    end.
    else do:
        find prev ttparcela
            no-lock no-error.
    end.    

end.    
        
end procedure.



procedure digitaContrato.

do on error undo:
    
    prompt-for ttparcela.contnum format ">>>>>>>>>>9" ttparcela.titpar format ">>9"
        with frame fcontr
        centered row 10
        overlay side-labels.

    find contrato where contrato.contnum = input ttparcela.contnum no-lock no-error.
    if not avail contrato
    then do:
        message "Contrato nao Cadastrado.".
        undo.
    end.    
    find titulo where titulo.empcod = 19 and titulo.titnat = no and
        titulo.etbcod = contrato.etbcod and titulo.modcod = contrato.modcod and
        titulo.clifor = contrato.clicod and titulo.titnum = string(contrato.contnum) and
        titulo.titpar = input ttparcela.titpar
        no-lock no-error.
    if not avail contrato
    then do:
        message "Parcela nao Cadastrado.".
        undo.
    end.    
    run iep/pavalparcsel.p (poperacao,recid(titulo),yes,input-output vsel, input-output vabe).
    
end.

end procedure.



