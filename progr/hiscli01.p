/*
*
*           consulta de contratos por clientes menu SSH
*/
{/admcom/progr/admcab.i.ssh}
def var vsit as char format "x(06)".
def var vatr            as log.
def var vpag as log.
def var reccont         as int.
def var vinicio         as log.
def var recatu1         as recid.
def var recatu2         as recid.
def var esqpos1         as int.
def var esqpos2         as int.
def var esqregua        as log.
def var esqcom1         as char format "x(18)" extent 4
    initial [" Parcelas ","","",""].
def var esqcom2         as char format "x(12)" extent 5
            initial ["","","","",""].


def buffer bcontrato     for contrato.
def var vcontnum         like contrato.contnum.

def temp-table ttcon
    field ttrec as recid
    field dtinicial like contrato.dtinicial
    index ind1 dtinicial desc.



    form
        esqcom1
            with frame f-com1
                 row 3 no-box no-labels side-labels column 1.
    form
        esqcom2
            with frame f-com2
                 row screen-lines no-box no-labels side-labels column 1.
repeat:
    clear frame frame-a all.
    for each ttcon.
        delete ttcon.
    end.
    
    prompt-for clien.clicod label "Cliente"
               with frame fclien centered
                color white/cyan row 4 side-label
                width 80 .
    find clien using clicod no-lock no-error .
    if not avail clien
    then do:
        message "Cliente Nao cadastrado".
        undo.
    end.
    display clien.clinom no-label
            with frame fclien.

    assign
        esqregua = yes
        esqpos1  = 1
        esqpos2  = 1
        recatu1  = ?.
    pause 0.
    
    for each contrato where contrato.clicod = clien.clicod no-lock.
        find first ttcon where ttcon.ttrec = recid(contrato) no-error.
        if not avail ttcon
        then do:
            create ttcon.
            assign ttcon.ttrec     = recid(contrato)
                   ttcon.dtinicial = contrato.dtinicial.
        end.
    end.


bl-princ:
repeat:

    disp esqcom1 with frame f-com1.
    disp esqcom2 with frame f-com2.
    
    if recatu1 = ?
    then find first ttcon no-error.
    else find ttcon where recid(ttcon) = recatu1 no-error.
    vinicio = yes.
    if not available ttcon
    then do:
        message "Nenhum Contrato Para o Cliente".
        leave bl-princ.
    end. 
    clear frame frame-a all no-pause.
    vpag = yes.
    vatr = no.
    find contrato where recid(contrato) = ttcon.ttrec no-lock.
    for each titulo where titulo.empcod = wempre.empcod             and
                          titulo.titnum = string(contrato.contnum)  and
                          titulo.titnat = no                        and
                          titulo.etbcod = contrato.etbcod           and
                          titulo.clifor = contrato.clicod           and
                          titulo.modcod = contrato.modcod no-lock by titulo.titpar.
                          
        if titulo.titsit = "LIB"
        then do:
            vpag = no.
            if titulo.titdtven < today
            then vatr = yes.
            leave.
        end.
    end.

    find estab where estab.etbcod = contrato.etbcod no-lock no-error.
    
    vsit = "".
    if vpag
    then vsit = "PAG".
    if vatr
    then vsit = "ATR".
    pause 0.
    display
        contrato.contnum     FORMAT ">>>>>>>>9"        LABEL "Contrato"
        estab.etbnom  when avail estab 
         column-label "Estabelecimento" format "x(15)"
        contrato.dtinicial   FORMAT "99/99/9999"     column-LABEL "Data Emis"
        contrato.vltotal     FORMAT ">>,>>9.99" LABEL "Valor total"
        contrato.vlentra     FORMAT ">>,>>9.99" LABEL "Vl Entrada"
        vsit            no-label    
        with frame frame-a 14 down centered 
            title " Cod. " + string(clien.clicod) + " " + clien.clinom + " ".

    recatu1 = recid(ttcon).
    color display message
        esqcom1[esqpos1]
            with frame f-com1.
    repeat:
        find next ttcon no-error.
        if not available ttcon
        then leave.
        if frame-line(frame-a) = frame-down(frame-a)
        then leave.
        if vinicio
        then
        down with frame frame-a.
        vpag = yes.
        vatr = no.
        find contrato where recid(contrato) = ttcon.ttrec no-lock.
        
        for each titulo where titulo.empcod = wempre.empcod             and
                              titulo.titnum = string(contrato.contnum)  and
                              titulo.titnat = no                        and
                              titulo.etbcod = contrato.etbcod           and
                              titulo.clifor = contrato.clicod           and
                              titulo.modcod = contrato.modcod no-lock.
            if titulo.titsit = "LIB"
            then do:
                vpag = no.
                if titulo.titdtven < today
                then vatr = yes.
                leave.
            end.
        end.
        find estab where estab.etbcod = contrato.etbcod no-lock no-error.
        
        vsit = "".
        if vpag
        then vsit = "PAG".
        if vatr
        then vsit = "ATR".
    
        display
            contrato.contnum
            estab.etbnom   when avail estab
            contrato.dtinicial
            contrato.vltotal
            contrato.vlentra
            vsit       
                 with frame frame-a.
    end.
    up frame-line(frame-a) - 1 with frame frame-a.

    repeat with frame frame-a:

        find ttcon where recid(ttcon) = recatu1.
        find contrato where recid(contrato) = ttcon.ttrec no-lock.


        choose field contrato.contnum
            go-on(cursor-down cursor-up
                  cursor-left cursor-right
                  page-down page-up
                  PF4 F4 ESC return).
        if keyfunction(lastkey) = "TAB"
        then do:
            if esqregua
            then do:
                color display normal
                    esqcom1[esqpos1]
                    with frame f-com1.
                color display message
                    esqcom2[esqpos2]
                    with frame f-com2.
            end.
            else do:
                color display normal
                    esqcom2[esqpos2]
                    with frame f-com2.
                color display message
                    esqcom1[esqpos1]
                    with frame f-com1.
            end.
            esqregua = not esqregua.
        end.
        if keyfunction(lastkey) = "cursor-right"
        then do:
            if esqregua
            then do:
                color display normal
                    esqcom1[esqpos1]
                    with frame f-com1.
                esqpos1 = if esqpos1 = 4
                          then 4
                          else esqpos1 + 1.
                color display messages
                    esqcom1[esqpos1]
                    with frame f-com1.
            end.
            else do:
                color display normal
                    esqcom2[esqpos2]
                    with frame f-com2.
                esqpos2 = if esqpos2 = 5
                          then 5
                          else esqpos2 + 1.
                color display messages
                    esqcom2[esqpos2]
                    with frame f-com2.
            end.
            next.
        end.

        if keyfunction(lastkey) = "page-down"
        then do:
            do reccont = 1 to frame-down(frame-a):
                find next ttcon no-error.
                if not avail ttcon
                then leave.
                recatu1 = recid(ttcon).
            end.
            leave.
        end.
        if keyfunction(lastkey) = "page-up"
        then do:
            do reccont = 1 to frame-down(frame-a):
                find prev ttcon no-error.
                if not avail ttcon
                then leave.
                recatu1 = recid(ttcon).
            end.
            leave.
        end.

        if keyfunction(lastkey) = "cursor-left"
        then do:
            if esqregua
            then do:
                color display normal
                    esqcom1[esqpos1]
                    with frame f-com1.
                esqpos1 = if esqpos1 = 1
                          then 1
                          else esqpos1 - 1.
                color display messages
                    esqcom1[esqpos1]
                    with frame f-com1.
            end.
            else do:
                color display normal
                    esqcom2[esqpos2]
                    with frame f-com2.
                esqpos2 = if esqpos2 = 1
                          then 1
                          else esqpos2 - 1.
                color display messages
                    esqcom2[esqpos2]
                    with frame f-com2.
            end.
            next.
        end.
        if keyfunction(lastkey) = "cursor-down"
        then do:
            find next ttcon no-error.
            find contrato where recid(contrato) = ttcon.ttrec no-lock.

            if not avail ttcon
            then next.
            color display normal
                contrato.contnum.
            if frame-line(frame-a) = frame-down(frame-a)
            then scroll with frame frame-a.
            else down with frame frame-a.
        end.
        if keyfunction(lastkey) = "cursor-up"
        then do:
            find prev ttcon no-error.
            find contrato where recid(contrato) = ttcon.ttrec no-lock no-error.

            if not avail contrato
            then next.
            color display normal
                contrato.contnum.
            if frame-line(frame-a) = 1
            then scroll down with frame frame-a.
            else up with frame frame-a.
        end.
        if keyfunction(lastkey) = "end-error"
        then leave bl-princ.

        if keyfunction(lastkey) = "return"
        then do on error undo, retry on endkey undo,leave.
          if esqregua
          then do:
            display caps(esqcom1[esqpos1]) @ esqcom1[esqpos1]
                with frame f-com1.

            if esqcom1[esqpos1] = "    Nota Fiscal"
            then do:

                for each contnf where contnf.etbcod  = contrato.etbcod and
                                      contnf.contnum = contrato.contnum 
                                                    no-lock:
                    for each plani where plani.etbcod = contrato.etbcod and
                                         plani.placod = contnf.placod no-lock.
                        display plani.numero label "Numero" format ">>>>>>9"
                                             colon 20
                                plani.serie  label "Serie"
                                plani.pladat label "Data"
                                plani.platot label "Valor da Nota"   colon 20
                                plani.vlserv label "Valor Devolucao" colon 20
                                plani.biss   label "Valor C/ Acrescimo"
                                                        colon 20
                                    with frame fnota side-label centered
                                            color message.
                        find finan where finan.fincod = plani.pedcod no-lock
                                                        no-error.
                        display plani.pedcod label "Plano" colon 20
                                finan.finnom no-label when avail finan
                                        with frame fnota.
                        find func where func.etbcod = plani.etbcod and
                                        func.funcod = plani.vencod 
                                                no-lock no-error.
                        display plani.vencod label "Vendedor"colon 20
                                func.funnom no-label when avail func 
                                        with frame fnota side-label.
                        for each movim where movim.etbcod = plani.etbcod and
                                             movim.placod = plani.placod and
                                             movim.movtdc = plani.movtdc and
                                             movim.movdat = plani.pladat
                                                        no-lock:
                            find produ where produ.procod = movim.procod 
                                                        no-lock no-error.
                            display movim.procod
                                    produ.pronom when avail produ 
                                            format "x(21)"
                                    movim.movqtm column-label "Qtd" 
                                            format ">>>>9"
                                    movim.movpc format ">>,>>9.99" 
                                            column-label "Preco" 
                                    (movim.movqtm * movim.movpc)
                                            column-label "Total"
                                        with frame fmov down centered
                                                        color blue/message.
                        
                        end.                                
                    end.                     
                end.                                
            end.     
            
            if esqcom1[esqpos1] = " Parcelas "
            then do:
                hide frame f-com1 no-pause.
                hide frame f-com2 no-pause.
                run hiscli02.p (input recid(contrato)).
                view frame f-com1.
                view frame f-com2.
            end.

            if esqcom1[esqpos1] = " Extrato "
            then do:
                message "Confirma a emissao do extrato do cliente"
                        clien.clinom "?" update sresp.
                if not sresp
                then leave.
                if opsys = "UNIX" then
                 run extrato1.p (input recid(clien)).
                else 
                run extrato.p (input recid(clien)).
                leave.
             end.
             
             if esqcom1[esqpos1] = "Consulta/Extrato"
             then run extrato3.p (input recid(clien)).

          end.
          else do:
            display caps(esqcom2[esqpos2]) @ esqcom2[esqpos2]
                with frame f-com2.
            message esqregua esqpos2 esqcom2[esqpos2].
            pause.
          end.
          view frame frame-a.
        end.
          if keyfunction(lastkey) = "end-error"
          then view frame frame-a.
        find contrato where recid(contrato) = ttcon.ttrec no-lock.
        find first estab of contrato no-lock no-error.
        vpag = yes.
        vatr = no.
        for each titulo where titulo.empcod = wempre.empcod             and
                              titulo.titnum = string(contrato.contnum)  and
                              titulo.titnat = no                        and
                              titulo.etbcod = contrato.etbcod           and
                              titulo.clifor = contrato.clicod           and
                              titulo.modcod = contrato.modcod no-lock.
            if titulo.titsit = "LIB"
            then do:
                vpag = no.
                if titulo.titdtven < today
                then vatr = yes.
                leave.
            end.
        end.
        
        vsit = "".
        if vpag
        then vsit = "PAG".
        if vatr
        then vsit = "ATR".
    
        display
            contrato.contnum
            estab.etbnom when avail estab
            contrato.dtinicial
            contrato.vltotal
            contrato.vlentra
            vsit
             with frame frame-a.
        if esqregua
        then display esqcom1[esqpos1] with frame f-com1.
        else display esqcom2[esqpos2] with frame f-com2.
        recatu1 = recid(ttcon).
   end.
end.
end.
