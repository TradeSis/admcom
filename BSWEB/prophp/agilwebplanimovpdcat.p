FUNCTION acha returns character
    (input par-oque as char,
     input par-onde as char).
         
    def var vx as int.
    def var vret as char.  
    
    vret = ?.  
    
    do vx = 1 to num-entries(par-onde,"|"). 
        if entry(1,entry(vx,par-onde,"|"),"=") = par-oque 
        then do: 
            vret = entry(2,entry(vx,par-onde,"|"),"="). 
            leave. 
        end. 
    end.
    return vret. 
END FUNCTION.
def buffer ctdescat31 for ctdescat.
def buffer ctdescat41 for ctdescat.

def var vcatcod like categoria.catcod.
def var val-total-movim as dec.
def var val-total-plani as dec.
def var val-total-movim41 as dec.
def var val-total-plani41 as dec.


def var varquivo as char.
def var v-clicod like clien.clicod.
def var v-param as char.
def var vetbcod like estab.etbcod.
def var vnumero like plani.numero.
def var vserie as char.
def var vpladat like plani.pladat.
def var vdif as char format "xx".
def var vdesti like plani.desti.
def var vdti as date.
def var vdtf as date.
def var vq as int. 
vdesti = 0.

v-param = os-getenv("planimovpdcat").
vdif = substr(string(v-param),1,2).
vetbcod = int(substr(string(v-param),3,3)).

if vdif = "PD"
then assign
         vdti = date(int(substr(string(v-param),8,2)),
               int(substr(string(v-param),6,2)),
               int(substr(string(v-param),10,4)))
         vdtf = date(int(substr(string(v-param),16,2)),
               int(substr(string(v-param),14,2)),
               int(substr(string(v-param),18,4)))
               .

def temp-table tt-movim like movim.

def var vobs as char.
def var q as int.                
    
def var vdata as date.
def var vokd as log.
def var vokc as log.
def var vltotven as dec decimals 2.
def var vltotven31 as dec decimals 2. 
def var vltotven41 as dec decimals 2.


def var vltotdes as dec.
def var vltotdes31 as dec.
def var vltotdes41 as dec.

if vdti <> ? and vdtf <> ? and vdtf > vdti
then 
do vdata = vdti to vdtf:
    for each plani where   plani.movtdc = 5 and
                       plani.etbcod = vetbcod and
                       plani.pladat = vdata
                       no-lock:
        
        if acha("DESCONTO_FUNCIONARIO",plani.notobs[3]) = "SIM"
        then next.
        
        val-total-plani = 0.
    
        if plani.biss > plani.platot - plani.vlserv
        then val-total-plani = plani.biss.
        else val-total-plani = plani.platot - plani.vlserv.
            
        val-total-movim = 0.
        val-total-movim41 = 0.
    
        vokd = yes.
        vokc = no.
        vcatcod = 0.
        for each movim where movim.etbcod = plani.etbcod
                         and movim.placod = plani.placod
                         and movim.movtdc = plani.movtdc
                         and movim.movdat = plani.pladat no-lock:
            find produ where produ.procod = movim.procod no-lock no-error.
            if not avail produ then next.
            /*
            if produ.clacod = 101 or
               produ.clacod = 102 or
               produ.clacod = 107 or
               produ.clacod = 109 or
               produ.clacod = 201 or
               produ.clacod = 191 or
               produ.clacod = 181
            then do:
                vokd = no.
                leave.
            end.
            */
            if produ.catcod = 31
            then do:
                vcatcod = 31.
                vokc = yes.
                val-total-movim = 
                        val-total-movim + (movim.movpc * movim.movqtm).
            end.
            if produ.catcod = 41
            then do:
                vcatcod = 41.
                vokc = yes.
                val-total-movim41 = 
                        val-total-movim41 + (movim.movpc * movim.movqtm).

            end.
        end.   
        if vokc = no then next.

        val-total-plani41 = val-total-plani * (val-total-movim41 / plani.protot).
        val-total-plani   = val-total-plani * (val-total-movim / plani.protot).
        
        vltotven = vltotven + (val-total-plani + val-total-plani41).
        if vcatcod = 31
        then do:
            vltotven31 = vltotven31 + val-total-plani.
        end.
        if vcatcod = 41
        then do:    
            vltotven41 = vltotven41 + val-total-plani41.
        end.
        
        if vokd = no then next.
        
        if plani.notobs[2] <> ""
        then do:
            if acha("DESCONTO",plani.notobs[2]) <> ?
            then do:
                vltotdes = vltotdes + dec(acha("DESCONTO",plani.notobs[2])).
                if vcatcod = 31
                then do:
                    vltotdes31 = vltotdes31 + dec(acha("DESCONTO",plani.notobs[2])).
                end.
                if vcatcod = 41
                then do:
                    vltotdes41 = vltotdes41 + dec(acha("DESCONTO",plani.notobs[2])).
                end.
                
            end.
            else do:
                if substr(plani.notobs[2],1,1) <> "J" and
                      dec(plani.notobs[2]) > 0
                then vltotdes = vltotdes + dec(plani.notobs[2]).
            end.
        end.
    end.
end.

find ctdesven where ctdesven.etbcod = vetbcod and ctdesven.vencod = 0 no-lock no-error.
find ctdescat31 where ctdescat31.etbcod = vetbcod and ctdescat31.catcod = 31 no-lock no-error.
find ctdescat41 where ctdescat41.etbcod = vetbcod and ctdescat41.catcod = 41 no-lock no-error.


put unformatted "@INICIO" skip.
put unformatted "#LINHA" "|VENDA=" vltotven "|DESCONTO=" vltotdes .
put unformatted          "|VENDA31=" vltotven31 "|DESCONTO31=" vltotdes31 .
put unformatted          "|VENDA41=" vltotven41 "|DESCONTO41=" vltotdes41 .

if avail ctdesven
then do:
    put unformatted
                "|DESCMED=" ctdesven.descmed 
                "|DESCMAX=" ctdesven.descmax .
end.
else do:
    put unformatted
                "|DESCMED=" 0
                "|DESCMAX=" 0.
end.
if avail ctdescat31
then do:
    put unformatted
                "|DESCMED31=" ctdescat31.descmed 
                "|DESCMAX31=" ctdescat31.descmax .
end.
else do:
    put unformatted
                "|DESCMED31=0"
                "|DESCMAX31=0".
end.
if avail ctdescat41
then do:
    put unformatted
                "|DESCMED41=" ctdescat41.descmed 
                "|DESCMAX41=" ctdescat41.descmax .
end.
else do:                
    put unformatted
                "|DESCMED41=0"
                "|DESCMAX41=0".

end.
put unformatted
                skip.
put unformatted "@FIMFIM" skip.

