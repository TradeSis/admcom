{admcab.i}

def temp-table tt-promo like ctpromoc.

def var vetbcod as int format ">>9".
def var vdti as date format "99/99/9999".
def var vprocod as int format ">>>>>>>>9".
def var vprobrinde as int format ">>>>>>>>9".
def var vfincod as int format ">>>9".

def var vfinan as log.
vfinan = no.

update vetbcod at 13 label "Filial" with side-label frame f1 width 80.
if vetbcod > 0
then do:
    find estab where estab.etbcod = vetbcod no-lock no-error.
    if avail estab then disp estab.etbnom no-label with frame f1.
    else undo.
end.
/*
update vdti at 1 label "Inicio de vigencia" with frame f1.
*/
def buffer bprodu for produ.
def buffer bclasse for clase.
def buffer cclasse for clase.

update vprocod at 5 label "Codigo Produto" with frame f1.
if vprocod > 0
then do:
    find produ where produ.procod = vprocod no-lock no-error.
    if avail produ then disp produ.pronom no-label 
                    format "x(45)" with frame f1.
    else undo. 
end.
else do:
    update vprobrinde at 5 label "Produto Brinde" with frame f1.
    if vprobrinde > 0
    then do:
        find bprodu where bprodu.procod = vprobrinde no-lock no-error.
        if avail bprodu then disp bprodu.pronom no-label 
                    format "x(45)" with frame f1.
        else undo.
    end.
    else do:
        update vfincod at 5 label "Codigo Plano  " with frame f1.
        find finan where finan.fincod = vfincod no-lock no-error.
        if avail finan 
        then do:
            disp finan.finnom no-label 
                        format "x(45)" with frame f1.
            vfinan = yes.            
        end.    
        else undo.            
    end.
end.

def var vok as log.
def buffer bctpromoc for ctpromoc. 
def buffer ectpromoc for ctpromoc.
for each ctpromoc where ctpromoc.dtinicio <= today and
                        ctpromoc.dtfim >= today and
                        ctpromoc.linha = 0 and
                        ctpromoc.situacao = "L"
                        no-lock.
    vok = no.
    if vetbcod > 0
    then do:
        find first ectpromoc where 
               ectpromoc.sequencia = ctpromoc.sequencia and
               ectpromoc.linha > 0 and
               ectpromoc.etbcod > 0
               no-lock no-error.
        if avail ectpromoc
        then do:          
            find first bctpromoc where 
               bctpromoc.sequencia = ctpromoc.sequencia and
               bctpromoc.linha > 0 and
               bctpromoc.etbcod = vetbcod
               no-lock no-error.
            if avail bctpromoc
            then vok = yes.
        end.    
        else vok = yes.
    end.    
    else vok = yes.    

    if vok = no then undo.
    
    if vprocod > 0 
    then do:
        vok = no.
        find first ectpromoc where 
               ectpromoc.sequencia = ctpromoc.sequencia and
               ectpromoc.linha > 0 and
               ectpromoc.procod > 0
               no-lock no-error.
        if avail ectpromoc
        then do:          
            find first bctpromoc where 
               bctpromoc.sequencia = ctpromoc.sequencia and
               bctpromoc.linha > 0 and
               bctpromoc.procod = vprocod and
               (bctpromoc.tipo begins "PRODUTO" or
                bctpromoc.tipo = "")
               no-lock no-error.
            if avail bctpromoc
            then vok = yes.
            else run ver-classe(produ.clacod).
        end.    
    end.
    if vprobrinde > 0 
    then do:
        vok = no.
        find first ectpromoc where 
               ectpromoc.sequencia = ctpromoc.sequencia and
               ectpromoc.linha > 0 and
               ectpromoc.probrinde > 0
               no-lock no-error.
        if avail ectpromoc
        then do:          
            find first bctpromoc where 
               bctpromoc.sequencia = ctpromoc.sequencia and
               bctpromoc.linha > 0 and
               bctpromoc.probrinde = vprobrinde and
               (bctpromoc.tipo begins "PRODUTO" or
                bctpromoc.tipo = "")
               no-lock no-error.
            if avail bctpromoc
            then vok = yes.
            else run ver-classe(bprodu.clacod).
        end.    
    end.
    if vfinan = yes
    then do:
        vok = no.
        find first ectpromoc where                                                         ectpromoc.sequencia = ctpromoc.sequencia and
                   ectpromoc.linha > 0 and
                   ectpromoc.fincod <> ?
                   no-lock no-error.
        if avail ectpromoc 
        then do:
            find first bctpromoc where
                       bctpromoc.sequencia = ctpromoc.sequencia and
                       ctpromoc.linha > 0 and
                       ectpromoc.fincod = vfincod
                       no-lock no-error.
            if avail bctpromoc
            then vok = yes.
        end.
        else vok = yes.
    end.
                           
    if vok                                                                 then do:                      
        create tt-promo.                               
        buffer-copy ctpromoc to tt-promo.                                        end.        
end.   

def var varquivo as char.                                          
varquivo = "/admcom/relat/promoc-ativa-fil." + string(time).
output to value(varquivo). 
DISP "MODULOS PROMOCIONAIS ATIVOS FILIAL " VETBCOD NO-LABEL skip.               
for each tt-promo no-lock.

    disp     tt-promo.sequencia label "Codigo"
             tt-promo.dtinicio
             tt-promo.dtfim
             tt-promo.descricao[1] + " " + tt-promo.descricao[2] 
             label "Descricao" format "x(100)"
             tt-promo.situacao 
             with frame f2 down width 200
                          .
 
end.
output close.

run visurel.p(varquivo,"").


procedure ver-classe:
    def input parameter p-classe like produ.clacod.

    find clase where clase.clacod = p-classe no-lock no-error.
    if avail clase
    then do:
        find first bctpromoc where 
                   bctpromoc.sequencia = ctpromoc.sequencia and
                   bctpromoc.linha > 0 and
                   bctpromoc.procod = clase.clacod and
                   bctpromoc.tipo begins "CLASSE"
                   no-lock no-error.
        if avail bctpromoc
        then vok = yes.
        else do:
            find bclasse where 
                 bclasse.clacod = clase.clasup no-lock no-error.
            if avail bclasse
            then do:
                find first bctpromoc where 
                           bctpromoc.sequencia = ctpromoc.sequencia and
                           bctpromoc.linha > 0 and
                           bctpromoc.procod = bclasse.clacod and
                           bctpromoc.tipo begins "CLASSE"
                           no-lock no-error.
                if avail bctpromoc
                then vok = yes.
                else do:
                    find cclasse where
                         cclasse.clacod = bclasse.clasup no-lock no-error.
                    if avail cclasse
                    then do:
                        find first bctpromoc where 
                                   bctpromoc.sequencia = ctpromoc.sequencia and
                                   bctpromoc.linha > 0 and
                                   bctpromoc.procod = cclasse.clacod and
                                   bctpromoc.tipo begins "CLASSE"
                                   no-lock no-error.
                        if avail bctpromoc
                        then vok = yes.
                        else do:
                            find first bctpromoc where 
                                bctpromoc.sequencia = ctpromoc.sequencia and
                                bctpromoc.linha > 0 and
                                bctpromoc.procod = bclasse.clasup and
                                bctpromoc.tipo begins "CLASSE"
                                no-lock no-error.
                            if avail bctpromoc
                            then vok = yes.
                        end.    
                    end.
                end.
            end.
        end.
    end.
end procedure.                        