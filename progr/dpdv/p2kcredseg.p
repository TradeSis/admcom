/*
*
*    dpdv/p2kdoc.p    Esqueleto de Programacao    com esqvazio
*
*/
{admcab.i}

def input parameter  par-recid-pdvmov   as recid.

def var vtottit as dec.
def var vtotvlr as dec.
find pdvmov where recid(pdvmov) = par-recid-pdvmov no-lock.

def var recatu1         as recid.
def var reccont         as int.
def var esqpos1         as int.
def var esqascend       as log initial yes.
def var esqcom1         as char format "x(12)" extent 5
    initial [" Consulta "," "].

form
    esqcom1
    with frame f-com1 row 5 no-box no-labels column 1 centered.
assign
    esqpos1  = 1.

bl-princ:
repeat:
    disp esqcom1 with frame f-com1.
    if recatu1 = ?
    then run leitura (input "pri").
    else find pdvcredseg where recid(pdvcredseg) = recatu1 no-lock.
    if not available pdvcredseg
    then do.
        message "Sem registros: pdvcredseg" view-as alert-box.
        leave.
    end.
    clear frame frame-a all no-pause.
        run frame-a.

    recatu1 = recid(pdvcredseg).
    color display message esqcom1[esqpos1] with frame f-com1.
    repeat:
        run leitura (input "seg").
        if not available pdvcredseg
        then leave.
        if frame-line(frame-a) = frame-down(frame-a)
        then leave.
        down with frame frame-a.
        run frame-a.
    end.
    up frame-line(frame-a) - 1 with frame frame-a.

    repeat with frame frame-a:

            find pdvcredseg where recid(pdvcredseg) = recatu1 no-lock.

            status default "".
            run color-message.
            choose field pdvcredseg.seqforma  help ""
                go-on(cursor-down cursor-up
                      cursor-left cursor-right
                      page-down   page-up
                      PF4 F4 ESC return) .
            run color-normal.
            status default "".

            if keyfunction(lastkey) = "cursor-right"
            then do:
                    color display normal esqcom1[esqpos1] with frame f-com1.
                    esqpos1 = if esqpos1 = 5 then 5 else esqpos1 + 1.
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
                    if not avail pdvcredseg
                    then leave.
                    recatu1 = recid(pdvcredseg).
                end.
                leave.
            end.
            if keyfunction(lastkey) = "page-up"
            then do:
                do reccont = 1 to frame-down(frame-a):
                    run leitura (input "up").
                    if not avail pdvcredseg
                    then leave.
                    recatu1 = recid(pdvcredseg).
                end.
                leave.
            end.
            if keyfunction(lastkey) = "cursor-down"
            then do:
                run leitura (input "down").
                if not avail pdvcredseg
                then next.
                color display white/red pdvcredseg.seqforma
                with frame frame-a.
                if frame-line(frame-a) = frame-down(frame-a)
                then scroll with frame frame-a.                  
                else down with frame frame-a.
            end.
            if keyfunction(lastkey) = "cursor-up"                             
            then do:
                run leitura (input "up").
                if not avail pdvcredseg
                then next.
                color display white/red pdvcredseg.seqforma
                with frame frame-a.
                if frame-line(frame-a) = 1
                then scroll down with frame frame-a.
                else up with frame frame-a.
            end.
 
        if keyfunction(lastkey) = "end-error"
        then leave bl-princ.

        if keyfunction(lastkey) = "return"
        then do:
            form 
            pdvcredseg.seqforma 
            pdvcredseg.valorseguro  
            pdvcredseg.num_apolice  
            pdvcredseg.num_sorteio            
            pdvcredseg.tiposeguro   
            pdvcredseg.contnum     
            pdvcredseg.seqseguro       
            with frame f-pdvcredseg color black/cyan
                      centered side-label row 5 2 col.
            hide frame frame-a no-pause.
                display caps(esqcom1[esqpos1]) @ esqcom1[esqpos1]
                        with frame f-com1.

                if esqcom1[esqpos1] = " Consulta "
                then do with frame f-pdvcredseg row 6.
                    disp  
                    pdvcredseg.seqforma      label "Forma" 
                    pdvcredseg.valorseguro
                    pdvcredseg.num_apolice   label "Num.Apolice"
                    pdvcredseg.num_sorteio   label "Num.sort"
                    pdvcredseg.tiposeguro    label "Tip.seg"
                    pdvcredseg.contnum 
                    pdvcredseg.seqseguro     label "Seq.Seg".                 
                end.
        end.
            run frame-a.
        display esqcom1[esqpos1] with frame f-com1.
        recatu1 = recid(pdvcredseg).
    end.
    if keyfunction(lastkey) = "end-error"
    then do:
        view frame fc1.
        view frame fc2.
    end.
end.
hide frame f-com1  no-pause.
hide frame frame-a no-pause.

procedure frame-a.
    display
    pdvcredseg.seqforma      column-label "Forma"
    pdvcredseg.valorseguro
    pdvcredseg.contnum   
    pdvcredseg.valorseguro
    pdvcredseg.num_apolice   column-label "Num.Apolice"
    pdvcredseg.num_sorteio   column-label "Num.Sort"
    pdvcredseg.tiposeguro    column-label "Tip.Seg"
    pdvcredseg.seqseguro     column-label "Seq.Seg"
    with frame frame-a 11 down centered color white/red row 6 .
end procedure.


procedure color-message.
color display message
        pdvcredseg.seqforma
        with frame frame-a.
end procedure.


procedure color-normal.
color display normal
       pdvcredseg.seqforma 
       with frame frame-a.
end procedure.


procedure leitura.
def input parameter par-tipo as char.
        
if par-tipo = "pri" 
then  
    if esqascend  
    then find first pdvcredseg of pdvmov no-lock no-error.
    else find last pdvcredseg  of pdvmov no-lock no-error.
                                             
if par-tipo = "seg" or par-tipo = "down" 
then  
    if esqascend  
    then find next pdvcredseg  of pdvmov no-lock no-error.
    else find prev pdvcredseg  of pdvmov no-lock no-error.
             
if par-tipo = "up" 
then                  
    if esqascend   
    then find prev pdvcredseg of pdvmov  no-lock no-error.
    else find next pdvcredseg of pdvmov  no-lock no-error.
        
end procedure.

