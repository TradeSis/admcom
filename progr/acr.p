/*
*
*    MANUTENCAO EM acrfilELECIMENTOS                         finan.p    02/05/95
*
*/

{admcab.i}
def var v-mar as dec.
def var vmarca          as char format "x"                          no-undo.
def temp-table wfin
    field wrec as recid.
def var reccont         as int.
def var vinicio         as log.
def var recatu1         as recid.
def var recatu2         as recid.
def var esqpos1         as int.
def var esqpos2         as int.
def var esqregua        as log.
def var esqcom1         as char format "x(12)" extent 5
            initial ["Marca","Listagem","","        ","        "].
def var esqcom2         as char format "x(12)" extent 5
            initial ["","","","",""].


def buffer bacrfil       for acrfil.
def var vclicod         like acrfil.clicod.

def var v-ven  as dec.
def var v-con  as dec.
def var v-acr  as dec.

    form
        esqcom1
            with frame f-com1
                 row 3 no-box no-labels side-labels column 1.
    form
        esqcom2
            with frame f-com2
                 row screen-lines no-box no-labels side-labels column 1.
    esqregua  = yes.
    esqpos1  = 1.
    esqpos2  = 1.
    for each wfin:
        delete wfin.
    end.
    v-ven = 0.
    v-acr = 0.
    v-con = 0.
    for each acrfil:
        v-ven = v-ven + acrfil.acrven.
        v-con = v-con + acrfil.acrcon.
        v-acr = v-acr + acrfil.acracr.
    end.

    display v-ven
            v-con
            v-acr
            v-mar
                with frame f-tot no-label row 21
                        no-box color white/red centered.

bl-princ:
repeat:

    disp esqcom1 with frame f-com1.
    disp esqcom2 with frame f-com2.
    if recatu1 = ?
    then
        find first acrfil where
            true no-error.
    else
        find acrfil where recid(acrfil) = recatu1.
        vinicio = no.
    if not available acrfil
    then do:
        bell.
        message "Nao existe acrescimo para esta filial".
        pause.
        return.
        form acrfil
            with frame f-altera
            overlay row 6 1 column centered color white/cyan.
        message "Cadastro de acrfilelecimento Vazio".
        message "Deseja Incluir " update sresp.
        if not sresp
        then undo.
        do with frame f-altera:
                create acrfil.
                update acrfil.
                vinicio = yes.
        end.
    end.
    clear frame frame-a all no-pause.
    find first wfin where wfin.wrec = recid(acrfil) no-error.

    display if avail wfin then "*" else "" @ vmarca no-label
            acrfil.clicod
            acrfil.contnum
            acrfil.acrdat
            acrfil.acrven
            acrfil.acrcon
            acrfil.acracr
            with frame frame-a 12 down centered color white/red.

    recatu1 = recid(acrfil).
    color display message
        esqcom1[esqpos1]
            with frame f-com1.
    repeat:
        find next acrfil where
                true.
        if not available acrfil
        then leave.
        if frame-line(frame-a) = frame-down(frame-a)
        then leave.
        if vinicio = no
        then
        down
            with frame frame-a.
        find first wfin where wfin.wrec = recid(acrfil) no-error.
        display if avail wfin then "*" else "" @ vmarca no-label
            acrfil.clicod
            acrfil.contnum
            acrfil.acrdat
            acrfil.acrven
            acrfil.acrcon
            acrfil.acracr
                with frame frame-a.
    end.
    up frame-line(frame-a) - 1 with frame frame-a.

    repeat with frame frame-a:

        find acrfil where recid(acrfil) = recatu1.

        choose field acrfil.clicod
            go-on(cursor-down cursor-up
                  page-down   page-up
                  cursor-left cursor-right
                  tab PF4 F4 ESC return).
        hide message no-pause.
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
                esqpos1 = if esqpos1 = 5
                          then 5
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
        if keyfunction(lastkey) = "page-down"
        then do:
            do reccont = 1 to frame-down(frame-a):
                find next acrfil where
                    true no-error.
                if not avail acrfil
                then leave.
                recatu2 = recid(acrfil).
            end.
            if reccont = frame-down(frame-a)
            then recatu1 = recatu2.
            leave.
        end.
        if keyfunction(lastkey) = "page-up"
        then do:
            do reccont = 1 to frame-down(frame-a):
                find prev acrfil where
                    true no-error.
                if not avail acrfil
                then leave.
                recatu1 = recid(acrfil).
            end.
            leave.
        end.
        if keyfunction(lastkey) = "cursor-down"
        then do:
            find next acrfil where
                true no-error.
            if not avail acrfil
            then next.
            color display white/red
                acrfil.clicod.
            if frame-line(frame-a) = frame-down(frame-a)
            then scroll with frame frame-a.
            else down with frame frame-a.
        end.
        if keyfunction(lastkey) = "cursor-up"
        then do:
            find prev acrfil where
                true no-error.
            if not avail acrfil
            then next.
            color display white/red
                acrfil.clicod.
            if frame-line(frame-a) = 1
            then scroll down with frame frame-a.
            else up with frame frame-a.
        end.
        if keyfunction(lastkey) = "end-error"
        then leave bl-princ.

        if keyfunction(lastkey) = "return"
        then do on error undo, retry on endkey undo, leave.
        hide frame frame-a no-pause.
          if esqregua
          then do:
            display caps(esqcom1[esqpos1]) @ esqcom1[esqpos1]
                with frame f-com1.

            if esqcom1[esqpos1] = "Inclusao"
            then do with frame f-altera.
                create acrfil.
                update acrfil.
                recatu1 = recid(acrfil).
                leave.
            end.
            if esqcom1[esqpos1] = "Consulta" or
               esqcom1[esqpos1] = "Exclusao"
            then do with frame f-altera:
                disp acrfil.
            end.
            if esqcom1[esqpos1] = "Listagem"
            then leave bl-princ.
            if esqcom1[esqpos1] = "Marca"
            then do:
                find FIRST wfin where wfin.wrec = recid(acrfil) no-error.
                if not avail wfin
                then do:
                    create wfin.
                    assign wfin.wrec = recid(acrfil).
                    display "*" @ vmarca
                            with frame frame-a.
                end.
                else do:
                    delete wfin.
                    display "" @ vmarca
                            with frame frame-a.
                end.

                v-ven = 0.
                v-acr = 0.
                v-con = 0.
                v-mar = 0.
                for each acrfil:
                    find FIRST wfin where wfin.wrec = recid(acrfil) no-error.
                    if avail wfin
                    then do:
                        v-mar = v-mar + acrfil.acracr.
                        next.
                    end.
                    v-ven = v-ven + acrfil.acrven.
                    v-con = v-con + acrfil.acrcon.
                    v-acr = v-acr + acrfil.acracr.
                end.
                find first acrfil where recid(acrfil) = recatu1.
                display v-ven
                        v-con
                        v-acr
                        v-mar
                            with frame f-tot no-label row 21
                                    no-box color white/red centered.

            end.
            if esqcom1[esqpos1] = "Listagem"
            then do:
                message "Confirma Impressao do acrfilelecimento" update sresp.
                if not sresp
                then LEAVE.
                recatu2 = recatu1.
                output to printer.
                for each acrfil:
                    display acrfil.
                end.
                output close.
                recatu1 = recatu2.
                leave.
            end.

          end.
          else do:
            display caps(esqcom2[esqpos2]) @ esqcom2[esqpos2]
                with frame f-com2.
            message esqregua esqpos2 esqcom2[esqpos2].
            pause.
          end.
          view frame frame-a .
        end.
        if keyfunction (lastkey) = "end-error"
         then view frame frame-a.
         find first wfin where wfin.wrec = recid(acrfil) no-error.
        display if avail wfin then "*" else "" @ vmarca no-label
            acrfil.clicod
            acrfil.contnum
            acrfil.acrdat
            acrfil.acrven
            acrfil.acrcon
            acrfil.acracr
                    with frame frame-a.
        if esqregua
        then display esqcom1[esqpos1] with frame f-com1.
        else display esqcom2[esqpos2] with frame f-com2.
        recatu1 = recid(acrfil).
   end.
end.
for each acrfil:
    find FIRST wfin where wfin.wrec = recid(acrfil) no-error.
    if not avail wfin
    then delete acrfil.
end.