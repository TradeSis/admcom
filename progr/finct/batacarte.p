def var vtotal as dec.
def var vtotal2 as dec.
def var vtitvlcob as dec.                                                            
def var vdtref as date format "99/99/9999".
def var vdtini as date.
vdtref = 12/31/2020.
update vdtref.
vdtini = date(month(vdtref),01,year(vdtref)). 

for each ctbposcart where 
                ctbposcart.dtref  = vdtref.
    delete ctbposcart.                
end.

for each ctbposprod where 
                ctbposprod.dtref  = vdtref.
    delete ctbposprod.                
end.
for each ctbposcart where 
                ctbposcart.dtref  = vdtini.
    delete ctbposcart.                
end.

for each ctbposprod where 
                ctbposprod.dtref  = vdtini.
    delete ctbposprod.                
end.
def var vconta as int.

def var ccarteira as char.
def var cmodal    as char.
def var vetbcod   as int.
def var vtpcontrato as char.
def var vproduto as char.
def var vcobcod   as int.
def var vmodcod   as char.
def var vqtdarq as int.
def var varquivo as char.
do vqtdarq = 1 to 10:
    varquivo = "/admcom/helio/ctb/carteira/posicao_analitica_" + string(vdtref,"99999999") + "_arq" + string(vqtdarq) + ".csv".
    if search(varquivo) <> ?
    then do:
        input from value(varquivo).
        repeat.
            vconta = vconta + 1.
            if vconta = 1 or vconta mod 5000 = 0 then do:
                hide message no-pause.
                message vconta varquivo.
            end.
                import delimiter ";" 
                      ^
                      ^  
                      ^  
                      ^ 
                      ccarteira 
                      vtitvlcob
                      ^
                      ^
                      ^
                      cmodal
                      vetbcod
                      vtpcontrato
                      ^
                      vproduto.
                vcobcod   = int(entry(1,ccarteira,"-")).
                vmodcod   = entry(1,cmodal,"-").
                              
                    find first ctbposcart use-index ctbposcart where 
                        ctbposcart.cobcod = vcobcod and
                        ctbposcart.modcod = vmodcod and
                        ctbposcart.tpcontrato = vtpcontrato and
                        ctbposcart.etbcod = vetbcod and
                        ctbposcart.dtref  = vdtini 
                     no-error.
                    if not avail ctbposcart
                    then do:
                        create ctbposcart.
                        ctbposcart.dtref  = vdtini.
                        ctbposcart.etbcod = vetbcod .
                        ctbposcart.modcod = vmodcod .
                        ctbposcart.tpcontrato = vtpcontrato.
                        ctbposcart.cobcod = vcobcod.
                    end. 
                    ctbposcart.saldo   = ctbposcart.saldo   + vtitvlcob.
                    
            
                    find first ctbposprod use-index ctbposprod where 
                        ctbposprod.cobcod = vcobcod and
                        ctbposprod.modcod = vmodcod and
                        ctbposprod.tpcontrato = vtpcontrato and
                        ctbposprod.etbcod = vetbcod and
                        ctbposprod.produto = vproduto and
                        ctbposprod.dtref  = vdtini 
                     no-error.
                    if not avail ctbposprod
                    then do:
                        create ctbposprod.
                        ctbposprod.dtref  = vdtini.
                        ctbposprod.etbcod = vetbcod .
                        ctbposprod.modcod = vmodcod .
                        ctbposprod.tpcontrato = vtpcontrato.
                        ctbposprod.cobcod = vcobcod.
                        ctbposprod.produto = vproduto .
                            
                    end. 
                    ctbposprod.saldo   = ctbposprod.saldo   + vtitvlcob.
                                      
                              
            vtotal = vtotal + vtitvlcob.
        end.
        input close.
    end.
end.            
 
            
message vtotal.
pause.
