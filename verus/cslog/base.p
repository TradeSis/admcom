def stream cli. output stream cli to /admcom/helio/cslog/clien.d.
def stream ctr. output stream ctr to /admcom/helio/cslog/contrato.d.
def stream tit. output stream tit to /admcom/helio/cslog/titulo.d.
def var vcliaberto as dec.
def var vctraberto as dec.

pause 0 before-hide.
for each contrato use-index est where etbcod = 160 no-lock break by contrato.etbcod by contrato.clicod.
    disp contrato.contnum format ">>>>>>>>>>>>9" contrato.modcod contrato.etbcod contrato.clicod with down.
    
    if first-of(contrato.clicod)
    then vcliaberto = 0.
    vctraberto = 0.
    for each titulo where titulo.titnat = no and titulo.titnum = string(contrato.contnum) no-lock.
        if titulo.clifor = contrato.clicod and titulo.etbcod = contrato.etbcod and titulo.modcod = contrato.modcod
        then do:
            if titulo.titsit = "LIB"
            then do:
                vctraberto = vctraberto + titulo.titvlcob.
            end.
        end.
    end        .
    disp vctraberto.
    
    if vctraberto <> 0
    then do:
        export stream ctr contrato.
        for each titulo where titulo.titnat = no and titulo.titnum = string(contrato.contnum) no-lock.
            if titulo.clifor = contrato.clicod and titulo.etbcod = contrato.etbcod and titulo.modcod = contrato.modcod
            then do:
                export stream tit titulo.
            end.
        end.
        vcliaberto = vcliaberto + vctraberto.
    end        .
    disp vcliaberto.        
    if last-of(contrato.clicod)
    then do:
        disp vcliaberto.
        if vcliaberto <> 0
        then do:
            find clien where clien.clicod = contrato.clicod no-lock.
            export stream cli clien.
        end.    
    end.



end.


output stream cli close.
output stream ctr close.
output stream tit close.

