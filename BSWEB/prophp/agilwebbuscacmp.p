def input parameter par-procod like produ.procod.

/***
def var par-movdat as date.

par-movdat = today - 3.
***/

find last movim where                   
    movim.procod  = par-procod and    
    movim.movsit  = "F" and   
    movim.movtdc  = 2
    no-lock no-error.
/***
vrec2 = recid(movim).
vdt = if avail movim then movim.movdat else ?.
***/

if not avail movim
then
find last movim where
    movim.procod = par-procod and
    movim.movsit = "F" and
    movim.movtdc = 7 /* comprausado */
    no-lock no-error.
    
if not avail movim
then
find last movim where
    movim.procod = par-procod and
    movim.movsit = "F" and
    movim.movtdc = 24 /* compra consignada */
    no-lock no-error.
/***
                if not avail movim                                              
                then do:                                                        
                    find movim where recid(movim) = vrec2 no-lock no-error.     
                end.                                                            
                else do:                                                        
                    if vdt2 > movim.movdat                                      
                    then                                                        
                        find movim where recid(movim) = vrec2 no-lock no-error. 
                end.                                                            
***/
if avail movim 
then do.
    find plani of movim no-lock no-error.
    if avail plani
    then do.
        put unformatted skip "#plani,1" skip. 
        export plani.                         
    end.
    put unformatted skip "#movim,1" skip.
    export movim.                        
end.
