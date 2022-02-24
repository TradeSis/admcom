/*
    #1 Garantia/RFQ
*/
def var varquivo as char.
def var v-clicod like clien.clicod.
def var v-param as char.
def var vetbcod like estab.etbcod.
def var vnumero like plani.numero.
def var vserie as char.
def var vpladat like plani.pladat.
def var vdif as char format "xx".
def var vdesti like plani.desti.
def var vq as int. 
vdesti = 0.
v-param = os-getenv("planimov").
vdif = substr(string(v-param),1,2).
vetbcod = int(substr(string(v-param),3,3)).
if vdif = "CL"
then vdesti = int(substr(string(v-param),6,10)).
else vnumero = int(substr(string(v-param),6,10)).
if vdif <> "CL"
then
vpladat = date(int(substr(string(v-param),18,2)),
               int(substr(string(v-param),16,2)),
               int(substr(string(v-param),20,4))).

if vdif = "DV"
then assign
        vdesti = int(substr(string(v-param),24,10))
        vserie = substr(string(v-param),34,4).

def temp-table tt-movim like movim.
def temp-table tt-contnf like fin.contnf.
def temp-table tt-vndseguro like vndseguro.
def var vobs as char.
def var q as int.                    

if vdif = "DV" and vserie <> ""
then do:
    put "~"@INICIO;" string(time) "~"" skip.
    put "~"#PLANI;" string(time) "~"" skip.
    q = 0. 

    find first plani where plani.movtdc = 5 and
                           plani.etbcod = vetbcod and
                           plani.numero = vnumero and
                           plani.pladat = vpladat and
                           plani.serie  = vserie and
                (if vdesti > 0 then plani.desti = vdesti else true)
                           no-lock no-error.
    if avail plani
    then do.        
        find first fin.contnf where
                   contnf.etbcod = plani.etbcod and
                   contnf.placod = plani.placod and
                   contnf.notaser  = plani.serie
                   no-lock no-error.
        if avail contnf
        then do:
            create tt-contnf.
            buffer-copy contnf to tt-contnf.
        end.
        else do:
            find first fin.contrato where contrato.clicod = plani.desti and
                                      contrato.dtinicial = plani.pladat and
                                      contrato.etbcod = plani.etbcod and 
                                      contrato.crecod = plani.pedcod and
                                      contrato.vltotal = plani.biss
                                      no-lock no-error.
            if avail fin.contrato
            then do:
                create tt-contnf.
                assign
                    tt-contnf.etbcod = plani.etbcod
                    tt-contnf.placod = plani.placod
                    tt-contnf.contnum = contrato.contnum
                    tt-contnf.notaser = plani.serie
                    tt-contnf.notanum = plani.numero
                    .
            end.
        end.                 
        for each movim where movim.etbcod = plani.etbcod
                                  and movim.placod = plani.placod
                                  and movim.movtdc = plani.movtdc
                                  and movim.movdat = plani.pladat no-lock:
            find first produ where
                       produ.procod = movim.procod no-lock no-error.
            if produ.proipiper = 98
            then next.           
            create tt-movim.
            buffer-copy movim to tt-movim.
         end.   
         find first vndseguro where
                    vndseguro.etbcod = plani.etbcod and
                    vndseguro.placod = plani.placod and
                    vndseguro.tpseguro < 4 /* #1 */
                    no-lock no-error.
         if avail vndseguro    
         then do:
            create tt-vndseguro.
            buffer-copy vndseguro to tt-vndseguro.
         end.       
         export plani except plaUFEmi plaUFDes  
         ValorFCPUFDestino
         ValorICMSPartilhaOrigem 
         ValorICMSPartilhaDestino
         baseii ii  NumProcImp 
         .
         q = q + 1.

    end.
    put skip "~"@FIMPLANI;" string(q,"99999") "~"" skip.
    put "~"#MOVIM;" string(time) "~"" skip.
    q = 0.
    for each tt-movim where tt-movim.procod > 0 :
       export tt-movim except movbsubst
            ValorFCPUFDestino
            ValorICMSPartilhaOrigem 
            ValorICMSPartilhaDestino
            movbii movaliii movii NumProcImp movbipi qCom VUnCom
            .
       q = q + 1.
    end.
    put skip "~"@FIMMOVIM;" string(q,"99999") "~"" skip.
    if vdif = "PM"
    then put "~"@FIMFIM;" string(time) "~"" skip.
    q = 0.
end.    
if (vdif = "PM" or vdif = "DV") and vserie = "" 
then do:
    put "~"@INICIO;" string(time) "~"" skip.
    put "~"#PLANI;" string(time) "~"" skip.
    q = 0. 

    find first plani where plani.movtdc = 5 and
                           plani.etbcod = vetbcod and
                           plani.numero = vnumero and
                           plani.pladat = vpladat and
                           plani.serie = "V" and
                (if vdesti > 0 then plani.desti = vdesti else true)
                           no-lock no-error.
    if not avail plani
    then find first plani where plani.movtdc = 5 and
                                plani.etbcod = vetbcod and
                                plani.numero = vnumero and
                                plani.pladat = vpladat and
                                plani.serie = "3" and
                     (if vdesti > 0 then plani.desti = vdesti else true)
                                no-lock no-error.
    if not avail plani
    then find first plani where plani.movtdc = 5 and
                                plani.etbcod = vetbcod and
                                plani.numero = vnumero and
                                plani.pladat = vpladat and
                                plani.serie = "30" and
                     (if vdesti > 0 then plani.desti = vdesti else true)
                                no-lock no-error.
    if not avail plani
    then find first plani where plani.movtdc = 5 and
                                plani.etbcod = vetbcod and
                                plani.numero = vnumero and
                                plani.serie = "V" and
                (if vdesti > 0 then plani.desti = vdesti else true)
                                 no-lock no-error.
    if not avail plani
    then find first plani where plani.movtdc = 5 and
                                plani.etbcod = vetbcod and
                                plani.numero = vnumero and
                                plani.serie = "V1" and
                (if vdesti > 0 then plani.desti = vdesti else true)
                                no-lock no-error.
    if not avail plani
    then find first plani where plani.movtdc = 5 and
                                plani.etbcod = vetbcod and
                                plani.numero = vnumero and
                                plani.serie = "3" and
                (if vdesti > 0 then plani.desti = vdesti else true)
                                no-lock no-error.
    if not avail plani
    then find first plani where plani.movtdc = 5 and
                                plani.etbcod = vetbcod and
                                plani.numero = vnumero and
                                plani.serie = "30" and
                (if vdesti > 0 then plani.desti = vdesti else true)
                                no-lock no-error.
    if avail plani
    then do.        
        /*
        if vdif = "DV"
        then
        find first ctdevven where
                    ctdevven.etbcod-ori = plani.etbcod and
                    ctdevven.placod-ori = plani.placod and
                    ctdevven.pladat-ori = plani.pladat
                    no-lock no-error.
        */
        find first fin.contnf where
                   contnf.etbcod = plani.etbcod and
                   contnf.placod = plani.placod and
                   contnf.notaser  = plani.serie
                   no-lock no-error.
        if avail contnf
        then do:
            create tt-contnf.
            buffer-copy contnf to tt-contnf.
        end.
        else do:
            find first fin.contrato where contrato.clicod = plani.desti and
                                      contrato.dtinicial = plani.pladat and
                                      contrato.etbcod = plani.etbcod and 
                                      contrato.crecod = plani.pedcod and
                                      contrato.vltotal = plani.biss
                                      no-lock no-error.
            if avail fin.contrato
            then do:
                create tt-contnf.
                assign
                    tt-contnf.etbcod = plani.etbcod
                    tt-contnf.placod = plani.placod
                    tt-contnf.contnum = contrato.contnum
                    tt-contnf.notaser = plani.serie
                    tt-contnf.notanum = plani.numero
                    .
            end.
        end.                 
        for each movim where movim.etbcod = plani.etbcod
                                  and movim.placod = plani.placod
                                  and movim.movtdc = plani.movtdc
                                  and movim.movdat = plani.pladat no-lock:
            find first produ where
                       produ.procod = movim.procod no-lock no-error.
            if produ.proipiper = 98
            then next.           
            create tt-movim.
            buffer-copy movim to tt-movim.
         end.   
         find first vndseguro where
                    vndseguro.etbcod = plani.etbcod and
                    vndseguro.placod = plani.placod and
                    vndseguro.tpseguro < 4 /* #1 */
                    no-lock no-error.
         if avail vndseguro    
         then do:
            create tt-vndseguro.
            buffer-copy vndseguro to tt-vndseguro.
         end.       
         export plani except plaUFEmi plaUFDes
                ValorFCPUFDestino
                ValorICMSPartilhaOrigem 
                ValorICMSPartilhaDestino
                baseii ii  NumProcImp
                .
         q = q + 1.
    end.
    put skip "~"@FIMPLANI;" string(q,"99999") "~"" skip.
    put "~"#MOVIM;" string(time) "~"" skip.
    q = 0.
    for each tt-movim where tt-movim.procod > 0 :
       export tt-movim except
                ValorFCPUFDestino
                ValorICMSPartilhaOrigem 
                ValorICMSPartilhaDestino
                movbii movaliii movii NumProcImp movbipi qCom VUnCom
                .
       q = q + 1.
    end.
    put skip "~"@FIMMOVIM;" string(q,"99999") "~"" skip.
    if vdif = "PM"
    then put "~"@FIMFIM;" string(time) "~"" skip.
    q = 0.
end.

if vdif = "ON"  
then do:
    put "~"@INICIO;" string(time) "~"" skip.
    put "~"#PLANI;" string(time) "~"" skip.
    q = 0. 
    find first plani where plani.etbcod = vetbcod and
                           plani.numero = vnumero and
                           plani.pladat = vpladat and
                           plani.serie  = "1"
                           no-lock no-error.
    if avail plani
    then do.        
        for each movim where movim.etbcod = plani.etbcod
                                  and movim.placod = plani.placod
                                  and movim.movtdc = plani.movtdc
                                  and movim.movdat = plani.pladat no-lock:
            create tt-movim.
            buffer-copy movim to tt-movim.
         end.   
         export plani except plaUFEmi plaUFDes
                ValorFCPUFDestino
                ValorICMSPartilhaOrigem 
                ValorICMSPartilhaDestino
                baseii ii  NumProcImp
                .
         q = q + 1.
    end.
    find first plani where plani.etbcod = vetbcod and
                           plani.numero = vnumero and
                           plani.pladat = vpladat and
                           plani.serie  = "V"
                           no-lock no-error.
    if avail plani
    then do.        
        for each movim where movim.etbcod = plani.etbcod
                                  and movim.placod = plani.placod
                                  and movim.movtdc = plani.movtdc
                                  and movim.movdat = plani.pladat no-lock:
            create tt-movim.
            buffer-copy movim to tt-movim.
         end.   
         export plani except plaUFEmi plaUFDes
         ValorFCPUFDestino
         ValorICMSPartilhaOrigem 
         ValorICMSPartilhaDestino
         baseii ii  NumProcImp
         .
         q = q + 1.
    end.
    find first plani where plani.etbcod = vetbcod and
                           plani.numero = vnumero and
                           plani.pladat = vpladat and
                           plani.serie  = "3"
                           no-lock no-error.
    if avail plani
    then do.        
        for each movim where movim.etbcod = plani.etbcod
                                  and movim.placod = plani.placod
                                  and movim.movtdc = plani.movtdc
                                  and movim.movdat = plani.pladat no-lock:
            create tt-movim.
            buffer-copy movim to tt-movim.
         end.   
         export plani except plaUFEmi plaUFDes
         ValorFCPUFDestino
         ValorICMSPartilhaOrigem 
         ValorICMSPartilhaDestino
         baseii ii  NumProcImp
         .
         q = q + 1.
    end.
    find first plani where plani.etbcod = vetbcod and
                           plani.numero = vnumero and
                           plani.pladat = vpladat and
                           plani.serie  >= "30"
                           no-lock no-error.
    if avail plani
    then do.        
        for each movim where movim.etbcod = plani.etbcod
                                  and movim.placod = plani.placod
                                  and movim.movtdc = plani.movtdc
                                  and movim.movdat = plani.pladat no-lock:
            create tt-movim.
            buffer-copy movim to tt-movim.
         end.   
         export plani except plaUFEmi plaUFDes
         ValorFCPUFDestino
         ValorICMSPartilhaOrigem 
         ValorICMSPartilhaDestino
         baseii ii  NumProcImp
         .
         q = q + 1.
    end.

    put skip "~"@FIMPLANI;" string(q,"99999") "~"" skip.
    put "~"#MOVIM;" string(time) "~"" skip.
    q = 0.
    for each tt-movim where tt-movim.procod > 0 :
       export tt-movim except
         ValorFCPUFDestino
         ValorICMSPartilhaOrigem 
         ValorICMSPartilhaDestino
         movbii movaliii movii NumProcImp movbipi qCom VUnCom
       .
       q = q + 1.
    end.
    put skip "~"@FIMMOVIM;" string(q,"99999") "~"" skip.
    if vdif = "PM"
    then put "~"@FIMFIM;" string(time) "~"" skip.
    q = 0.
end.

if vdif = "CL"
then do:
    put "~"@INICIO;" string(time) "~"" skip.
    put "~"#PLANI;" string(time) "~"" skip.
    q = 0. 
    
    for each plani where plani.movtdc = 5 and
                           plani.desti = vdesti /*and
                           plani.serie = "V"*/ 
                           no-lock :
        find first contnf where
                   contnf.etbcod = plani.etbcod and
                   contnf.placod = plani.placod and
                   contnf.notaser  = plani.serie
                   no-lock no-error.
        if avail contnf
        then do:
            create tt-contnf.
            buffer-copy contnf to tt-contnf.
        end.                 
        for each movim where movim.etbcod = plani.etbcod
                                  and movim.placod = plani.placod
                                  and movim.movtdc = plani.movtdc
                                  and movim.movdat = plani.pladat no-lock:
            create tt-movim.
            buffer-copy movim to tt-movim.
         end.   
         export plani except plaUFEmi plaUFDes
         ValorFCPUFDestino
         ValorICMSPartilhaOrigem 
         ValorICMSPartilhaDestino
         baseii ii  NumProcImp
         .
         q = q + 1.
    end.
    /****
    for each plani where plani.movtdc = 5 and
                           plani.desti = vdesti and
                           plani.serie = "3" 
                           no-lock :
        find first contnf where
                   contnf.etbcod = plani.etbcod and
                   contnf.placod = plani.placod and
                   contnf.notaser  = plani.serie
                   no-lock no-error.
        if avail contnf
        then do:
            create tt-contnf.
            buffer-copy contnf to tt-contnf.
        end.                 
        for each movim where movim.etbcod = plani.etbcod
                                  and movim.placod = plani.placod
                                  and movim.movtdc = plani.movtdc
                                  and movim.movdat = plani.pladat no-lock:
            create tt-movim.
            buffer-copy movim to tt-movim.
         end.   
         export plani except plaUFEmi plaUFDes
         ValorFCPUFDestino
         ValorICMSPartilhaOrigem 
         ValorICMSPartilhaDestino
         baseii ii  NumProcImp
         .
         q = q + 1.
    end.
    for each plani where plani.movtdc = 5 and
                           plani.desti = vdesti and
                           plani.serie = "30" 
                           no-lock :
        find first contnf where
                   contnf.etbcod = plani.etbcod and
                   contnf.placod = plani.placod and
                   contnf.notaser  = plani.serie
                   no-lock no-error.
        if avail contnf
        then do:
            create tt-contnf.
            buffer-copy contnf to tt-contnf.
        end.                 
        for each movim where movim.etbcod = plani.etbcod
                                  and movim.placod = plani.placod
                                  and movim.movtdc = plani.movtdc
                                  and movim.movdat = plani.pladat no-lock:
            create tt-movim.
            buffer-copy movim to tt-movim.
         end.   
         export plani except plaUFEmi plaUFDes
         ValorFCPUFDestino
         ValorICMSPartilhaOrigem 
         ValorICMSPartilhaDestino
         baseii ii  NumProcImp
         .
         q = q + 1.
    end.
    ***/
    put skip "~"@FIMPLANI;" string(q,"99999") "~"" skip.
    put "~"#MOVIM;" string(time) "~"" skip.
    q = 0.
    for each tt-movim where tt-movim.procod > 0 :
       export tt-movim except
       ValorFCPUFDestino
       ValorICMSPartilhaOrigem 
       ValorICMSPartilhaDestino
       movbii movaliii movii NumProcImp movbipi qCom VUnCom
       .
       q = q + 1.
    end.
    put skip "~"@FIMMOVIM;" string(q,"99999") "~"" skip.
    if vdif = "PM"
    then put "~"@FIMFIM;" string(time) "~"" skip.
    q = 0.
end.


if vdif = "DV" or vdif = "CL" /* devolucao de venda */
then do:
    put "~"#CONTNF;" string(time) "~"" skip.
    q = 0.
    for each tt-contnf where tt-contnf.etbcod > 0:
        export tt-contnf.
        q = q + 1.
    end.
    put skip "~"@FIMCONTNF;" string(q,"99999") "~"" skip.
    put "~"#CONTRATO;" string(time) "~"" skip.
    q = 0.
    for each tt-contnf where tt-contnf.etbcod > 0:
        for each fin.contrato where contrato.contnum = tt-contnf.contnum
                    no-lock.
            export contrato
                except vltaxa modcod vlseguro DtEfetiva
                       VlIof DtEfetiva VlIof Cet TxJuros
                       vlf_principal vlf_acrescimo nro_parcelas
                       .
            q = q + 1.
        end.
    end.
    put skip "~"@FIMCONTRATO;" string(q,"99999") "~""  skip.
    put "~"#TBPRICE;" string(time) "~"" skip.
    q = 0.
    find first adm.tbprice where
               adm.tbprice.etb_venda = vetbcod and
               adm.tbprice.data_venda = vpladat and
               adm.tbprice.nota_venda = vnumero
               no-lock no-error.
    if avail adm.tbprice
    then do:
        export adm.tbprice.
        q = q + 1.
    end.
    put skip "~"@FIMTBPRICE;" string(q,"99999") "~"" skip.
    put "~"#VNDSEGURO;" string(time) "~"" skip.
    q = 0.
    for each tt-vndseguro where tt-vndseguro.etbcod > 0:
        export tt-vndseguro /*#1*/ except tempo.
        q = q + 1.
    end.
    put skip "~"@FIMVNDSEGURO;" string(q,"99999") "~"" skip.  
    put "~"@FIMFIM;" string(time) "~"" skip.
    q = 0.     
end.
