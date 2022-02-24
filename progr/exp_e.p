{admcab.i}
def var vetbcod like estab.etbcod.
def stream sprodu.
def stream sestoq.


repeat:
    update  vetbcod label "Filial"
                with frame f0 side-label width 80 
                    title "EXPORTACAO DE PRODUTOS".
 
    output stream sprodu to /admcom/dados/produ.d.
    for each produ no-lock.
        if produ.itecod = 0 and
           produ.corcod = "" and
           produ.protam = ""
        then next.                     
      
        display "Exportacao Produtos...."
                produ.procod no-label
                with frame f1 1 down centered.
        pause 0.         
        export stream sprodu produ.                           
    
    end.    
    output stream sprodu close.

    output stream sestoq to /admcom/dados/estoq.d.
    for each estoq where estoq.etbcod = vetbcod no-lock by estoq.procod:
        find produ where produ.procod = estoq.procod no-lock no-error.
        if not avail produ then next.

        if produ.itecod = 0 and
           produ.corcod = "" and
           produ.protam = ""
        then next. 
                         
        display "Atualizando Estoque...."
                 estoq.procod no-label
                    with frame f2 1 down centered.
        pause 0.         
                                   
        export stream sestoq estoq.
            
    end.
    output stream sestoq close.
    
end.

    



         

                       
