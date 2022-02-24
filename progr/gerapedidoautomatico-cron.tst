{admcab.i}
/*
define variable vint-funcod-aux as integer no-undo.

if sfuncod > 0
then assign vint-funcod-aux = sfuncod.

setbcod = 999.
sfuncod = 101.
*/

def var p-teste as log init no.
def var p-etbcod like estab.etbcod.
def var p-procod like produ.procod.
def var p-data as date init today.

p-teste = yes.
p-etbcod = 0.

update p-etbcod label "Filial"
       p-procod label "Produto"
       p-data   label "Data venda" format "99/99/9999"
       with 1 column.
/*
if keyfunction(lastkey) = "end-error"
then do:

    if vint-funcod-aux > 0
    then assign sfuncod = vint-funcod-aux.
    
    return "end-error".
end. 
*/ 
FUNCTION acha-pro returns character
    (input par-oque as char,
     input par-onde as char,
     input par-proc as char).
         
    def var vx as int.
    def var vret as char.  
    
    vret = ?.  
    
    do vx = 1 to num-entries(par-onde,"|"). 
        if entry(1,entry(vx,par-onde,"|"),"=") = par-oque 
        then do: 
            vret = entry(2,entry(vx,par-onde,"|"),"="). 
            if vret = par-proc
            then leave. 
        end. 
    end.
    return vret. 
END FUNCTION.
 
def var p-ok as log.
def var v-peda as log.
def var p-sugerido as dec.
def var vmovqtm as dec.
def var qtd-conjunto as dec.
def var vpednum like pedid.pednum.
def var vaj-min as dec.
def var vaj-mix as dec.
def var qtd-mix as int.
def var qtd-estoque as dec.
def var qtd-pedido as int.
def var ventrega-out as dec.
             
def buffer bpedid for pedid.

def new shared temp-table tt-proped
    field etbcod like estab.etbcod
    field pladat like plani.pladat
    field placod like plani.placod
    field numero like plani.numero
    field procod like produ.procod
    field movqtm like movim.movqtm
    field sugere like p-sugerido
    field tipo   as char  
    field whr as int
    field pednum as int
    .  

def var varqlog as char.
if p-teste = no
then do:
    varqlog = "/admcom/logs/pedidoautomatico-" + string(day(today),"99") +
            string(month(today),"99") + string(year(today),"9999")
            .
    output to value(varqlog) append.
    put "#INICIO;" string(today,"99/99/9999") ";" 
        time skip .
    output close.
end.

def temp-table tt-plani
    field etbcod like plani.etbcod
    field placod like plani.placod
    field procod like movim.procod
    field pladat like plani.pladat
    field geroua as log
    index i1 etbcod placod procod.

if not p-teste
then do:
for each estab where estab.etbnom begins "DREBES-FIL" no-lock:
    if p-etbcod > 0 and
       estab.etbcod <> p-etbcod 
    then next.   
    if estab.etbcod > 200
    then next.
    pause 2 no-message.
    for each plani where plani.movtdc = 5 and
             plani.etbcod = estab.etbcod and
             plani.pladat = p-data   
             no-lock,
        each movim where movim.etbcod = plani.etbco and
                             movim.placod = plani.placod and
                             movim.movtdc = plani.movtdc and
                             movim.movdat = plani.pladat 
                             no-lock:
            create tt-plani.
            assign
                tt-plani.etbcod = plani.etbcod
                tt-plani.placod = plani.placod
                tt-plani.procod = movim.procod
                tt-plani.pladat = plani.pladat
                tt-plani.geroua = no.
    end.
end.

for each tt-plani :

    for each pedid where 
             pedid.etbcod = tt-plani.etbcod and
             pedid.peddat = tt-plani.pladat and
             pedid.pedtdc = 3 and
             pedid.modcod = "PEDA" no-lock,
        each liped of pedid where liped.procod = tt-plani.procod and
                                liped.predt  >= tt-plani.pladat
                               no-lock:
        if tt-plani.procod = 
                int(acha-pro(string(tt-plani.placod),pedid.pedobs[5],
                                string(tt-plani.procod)))
        then tt-plani.geroua = yes.
        
    end.
end.        
end.

def var mix-difer as log.
def var v-time as int.

repeat:
for each estab where estab.etbnom begins "DREBES-FIL" no-lock:
    
    if  p-teste = yes and estab.etbcod <> p-etbcod
    then next.

    for each tt-proped: delete tt-proped. end.
    
    if p-teste = no
    then do:
        output to value(varqlog) append.
        put "#FILIAL;" string(estab.etbcod) ";" 
            time skip .
        output close.
    end.

    pause 2 no-message.

    for each plani where plani.movtdc = 5 and
             plani.etbcod = estab.etbcod and
             plani.pladat = p-data    
             no-lock:

        for each movim where movim.etbcod = plani.etbco and
                             movim.placod = plani.placod and
                             movim.movtdc = plani.movtdc and
                             movim.movdat = plani.pladat
                             no-lock:
            
            if p-procod > 0 and
                movim.procod <> p-procod
            then next.
             
            find produ where produ.procod = movim.procod no-lock no-error.
            if not avail produ then next.
            if produ.procod = 10000 then next.
            if produ.catcod <> 31 then next.    
            if produ.pronom matches "*RECARGA*"  or
               produ.pronom matches "*FRETEIRO*" /*or
                   com.produ.pronom begins "*"  */
            then next.

            if produ.pronom begins "*"
            then do:
                find estoq where estoq.etbcod = 993 and
                                 estoq.procod = produ.procod 
                                 no-lock no-error.
                if not avail estoq or
                      estoq.estatual <= 0
                then next.                 
            end.
            
            if movim.ocnum[9] = movim.placod
            then next.
            
            
            find first tt-plani where
                       tt-plani.etbcod = plani.etbcod and
                       tt-plani.placod = plani.placod and
                       tt-plani.procod = movim.procod
                       no-lock no-error.
            if avail tt-plani and
                     tt-plani.geroua = yes
            then next.
                                
            p-ok = no.
            p-sugerido = 0.
            vmovqtm = 0.
            qtd-conjunto = 0.
            qtd-estoque = 0.
             vaj-min = 0.
            vaj-mix = 0.
            qtd-pedido = 0.
            qtd-mix = 0.
            ventrega-out = 0.
            run vercobertura-mix.p 
                                   (input recid(plani),
                                    input p-teste,
                                    input movim.procod,
                                    input movim.movqtm,
                                    input movim.etbcod,
                                    output qtd-estoque,
                                    output p-ok,
                                    output qtd-mix,
                                    output qtd-pedido,
                                    output p-sugerido,
                                    output vmovqtm,
                                    output qtd-conjunto,
                                    output vaj-min,
                                    output vaj-mix,
                                    output ventrega-out,
                                    output mix-difer).
    
            if p-teste = yes
            then do:
            disp produ.procod
                 produ.pronom
                 movim.movqtm
                 movim.etbcod
                 p-ok
                 qtd-mix        label "Mix"
                 qtd-pedido     label "Pedido"
                 qtd-estoque    label "Estoque"
                 qtd-conjunto   label "Conjunto"
                 p-sugerido     label "Sugerido"
                 vaj-min        label "Ajuste-minimo"
                 vaj-mix        label "Ajuste-mix"
                 ventrega-out   label "Entrega-outfi"
                 mix-difer      label "Mix diferenciado"
                 with 1 column.
            pause.
            end.
                 
            if p-ok = no then next.
            
            if p-teste = no
            then do:
            v-peda = no.
            /***
            for each liped where liped.etbcod = movim.etbcod and
                                 liped.procod = movim.procod and
                                 liped.pedtdc = 3 and
                                 liped.predt  >= plani.pladat
                                 no-lock,
                first pedid of liped where 
                            pedid.modcod = "PEDA" and
                            pedid.peddat = plani.pladat no-lock:
                if movim.procod =
                        int(acha-pro(string(plani.placod),pedid.pedobs[5],
                                string(movim.procod)))
                then do:
                    v-peda = yes.
                    leave.
                end.
            end.
            **/
            /**
            find first tt-plani where
                       tt-plani.etbcod = plani.etbcod and
                       tt-plani.placod = plani.placod and
                       tt-plani.procod = movim.procod
                       no-lock no-error.
            if avail tt-plani and
                     tt-plani.geroua = yes
            then v-peda = yes.
            else v-peda = no.
            **/
                       
            if v-peda = no
            then do transaction:
                if p-sugerido > 0
                then do:
                find last pedid where pedid.pedtdc = 3 and
                           pedid.sitped = "E" and
                           pedid.etbcod = movim.etbcod and
                           pedid.pednum >= 100000 and
                           pedid.peddat = today and
                           pedid.modcod = "PEDA"
                           no-error.
                if not avail pedid
                then do:
                     find last bpedid where bpedid.pedtdc = 3 and
                               bpedid.etbcod = movim.etbcod  and
                               bpedid.pednum >= 100000 no-error.
                     if avail bpedid
                     then vpednum = bpedid.pednum + 1.
                     else vpednum = 100000.
                     create pedid.
                     assign pedid.etbcod = movim.etbcod
                            pedid.pedtdc = 3
                            pedid.peddat = today
                            pedid.pednum = vpednum
                            pedid.sitped = "E"
                            pedid.modcod = "PEDA"
                            pedid.pedsit = yes.
                   
                end.
                find first liped where 
                           liped.etbcod = pedid.etbcod and
                           liped.pedtdc = pedid.pedtdc and
                           liped.pednum = pedid.pednum and
                           liped.procod = movim.procod no-error.
                if not avail liped
                then do:
                    create liped.
                    assign liped.pedtdc    = pedid.pedtdc
                           liped.pednum    = pedid.pednum
                           liped.procod    = movim.procod
                           liped.lippreco  = movim.movpc
                           liped.lipsit    = "Z"
                           liped.predtf    = pedid.peddat
                           liped.predt     = pedid.peddat
                           liped.etbcod    = pedid.etbcod
                           liped.protip    = string(movim.movhr).
                end.
                if qtd-conjunto > 0
                then liped.lipqtd = liped.lipqtd + p-sugerido.
                else liped.lipqtd = liped.lipqtd + p-sugerido /*movim.movqtm*/.
                                        
                pedid.pedobs[5] = pedid.pedobs[5] +
                string(movim.placod) + "=" + string(movim.procod) +
                                "|".

                find first tt-plani where
                           tt-plani.etbcod = plani.etbcod and
                           tt-plani.placod = plani.placod and
                           tt-plani.procod = movim.procod
                           no-error.
                if not avail tt-plani
                then do:
                    create tt-plani.
                    assign
                        tt-plani.etbcod = plani.etbcod
                        tt-plani.placod = plani.placod
                        tt-plani.procod = movim.procod
                        tt-plani.pladat = plani.pladat
                        tt-plani.geroua = no.
                end.    
                tt-plani.geroua = yes.
                        
                create tt-proped.
                assign
                        tt-proped.etbcod = plani.etbcod
                        tt-proped.pladat = plani.pladat
                        tt-proped.placod = plani.placod
                        tt-proped.numero = plani.numero
                        tt-proped.procod = movim.procod
                        tt-proped.movqtm = movim.movqtm
                        tt-proped.sugere = p-sugerido
                        tt-proped.tipo = "PEDA"
                        .

                end.
                else do:
                    find first tt-plani where
                           tt-plani.etbcod = plani.etbcod and
                           tt-plani.placod = plani.placod and
                           tt-plani.procod = movim.procod
                           no-error.
                    if not avail tt-plani
                    then do:
                        create tt-plani.
                        assign
                        tt-plani.etbcod = plani.etbcod
                        tt-plani.placod = plani.placod
                        tt-plani.procod = movim.procod
                        tt-plani.pladat = plani.pladat
                        tt-plani.geroua = no.
                    end.    
                    tt-plani.geroua = yes.
 
                    create tt-proped.
                    assign
                        tt-proped.etbcod = plani.etbcod
                        tt-proped.pladat = plani.pladat
                        tt-proped.placod = plani.placod
                        tt-proped.numero = plani.numero
                        tt-proped.procod = movim.procod
                        tt-proped.movqtm = movim.movqtm
                        tt-proped.sugere = p-sugerido
                        .
                end.
            end.
            end.
        end.
    end.
    
        if p-teste = no
        then do:
        output to value(varqlog) append.
        for each tt-proped:
            export tt-proped.
        end.
        output close.
        end.
        for each tt-proped:
            delete tt-proped.
        end.

end.

/*
if vint-funcod-aux > 0
then assign sfuncod = vint-funcod-aux.
*/

if p-teste = no
then do:
output to value(varqlog) append.
put "#PARADA;" string(today,"99/99/9999") ";"
    time skip.
output close.    

pause 120.

output to value(varqlog) append.
put "#REINICIO;" string(today,"99/99/9999") ";"
    time skip.
output close. 
end.
else leave.

end.
