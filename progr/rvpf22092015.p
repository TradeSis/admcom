{admcab.i new}

def var v150 as dec format ">>>,>>>,>>9.99".
def var vpm as dec  format ">>>,>>>,>>9.99".
def var vm10 as dec format ">>>,>>>,>>9.99".
def var vl00 as dec format ">>>,>>>,>>9.99".
def var v400 as dec format ">>>,>>>,>>9.99".
def var vfin as dec format ">>>,>>>,>>9.99".

prompt-for estab.etbcod label "Filial" with frame f-1
                1 down side-label width 80.
if input frame f-1 estab.etbcod <> 0
then do:
    find estab where estab.etbcod = input frame f-1 estab.etbcod    
           no-lock no-error.
    disp estab.etbnom no-label with frame f-1.
end.           
prompt-for plani.pladat at 1 label "Data" with frame f-1.

def var varquivo as char.
varquivo = "/admcom/relat/venda-financiada-" + 
        string(input frame f-1 plani.pladat,"99999999")
            + "." + string(time).
output to value(varquivo).


for each estab where
        (if input frame f-1 estab.etbcod <> 0
            then estab.etbcod = input frame f-1 estab.etbcod
            else true)
            no-lock:
    disp estab.etbcod column-label "Fil".
    pause 0.
    for each plani where  plani.pladat = input frame f-1 plani.pladat and
                          plani.etbcod = estab.etbcod and
                          plani.movtdc = 5 no-lock:
        
        find first contnf where contnf.etbcod = plani.etbcod and
                                contnf.placod = plani.placod 
                                no-lock no-error.
        if not avail contnf then next.
        find contrato where contrato.contnum = contnf.contnum
                                no-lock no-error.
        if not avail contrato then next.                        
        
        vl00 = 0.
        for each movim where movim.etbcod = plani.etbcod and
                             movim.placod = plani.placod and
                             movim.movtdc = plani.movtdc and
                             movim.movdat = plani.pladat
                             no-lock.
            find produ where produ.procod = movim.procod no-lock no-error.
            if not avail produ then next.
            
            if produ.proipiper = 99
            then.
            else vl00 = vl00 + (movim.movpc * movim.movqtm).
        end.
        if plani.vencod = 150
        then v150 = v150 + contrato.vltotal.
        else if plani.biss < (plani.platot - plani.vlserv)
            then vpm = vpm + contrato.vltotal.
            else if plani.biss - (plani.platot - plani.vlserv) < 10
                then vm10 = vm10 + contrato.vltotal.
                else if vl00 = 0 and
                      (plani.biss - (plani.platot - plani.vlserv)) <= 400
                     then v400 = v400 + contrato.vltotal.
                     else vfin = vfin + contrato.vltotal .
    end.
    disp v150(total) column-label "Cxa=150" format ">>>,>>>,>>9.99"
         vpm (total) column-label "Prazo<Venda" 
         format ">>>,>>>,>>9.99"
         vm10(total) column-label "Acr<10"  format ">>>,>>>,>>9.99"
         v400(total) column-label "ST<400"  format ">>>,>>>,>>9.99"
         vfin(total) column-label "Financiado"  format ">>>,>>>,>>9.99"
         with width 100.


    assign
        v150 = 0
        vpm = 0
        vm10 = 0
        v400 = 0
        vfin = 0.
end. 
              
put skip(3)
    "LEGENDA:" skip
    "         Cxa=150      - Venda caixa 150  "     skip
    "         Parazo<Venda - Valor a prazo menor valor vendido" skip
    "         Acr<10       - Acrescimo menor R$ 10,00" skip
    "         ST<400       - ST 100% acrescimo menor R$ 400,00" skip
    "         Financiado   - Gerar contrato Financeira " skip
    .

output close.      

run visurel.p(input varquivo, "").
