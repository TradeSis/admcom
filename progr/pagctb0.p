{admcab.i}
def var vesc as log format "Sim/Nao" initial no.
repeat:              

    if connected ("banfin")
    then disconnect banfin.
                       
                       
    update vesc label "Conectar LP"
        with frame f1 side-label width 80.
    
    connect banfin -H erp.lebes.com.br -S sbanfin -N tcp -ld banfin.
    

    run pagctb5.p(input vesc). 
    
end.    
