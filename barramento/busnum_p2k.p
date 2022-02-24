def input  parameter par-tipo   as char.
def input  parameter par-etbcod as int.
def output parameter par-numcod as dec.

def var aux as dec.

if par-tipo = "TITULO"
then do for numtitulo on error undo:    
/***
    find last titbsmoe use-index titcod exclusive no-error. 
    vtitcod = if avail titbsmoe 
              then titbsmoe.titcod + 1 
              else 1.
***/
    find first numtitulo where 
            numtitulo.etbcod = par-etbcod and
            numtitulo.titcod <> ? exclusive no-error.
    if not avail numtitulo
    then do:
        create numtitulo.
        numtitulo.etbcod = par-etbcod.
        par-numcod = 1.
    end.
    else par-numcod = numtitulo.titcod + 1.

    numtitulo.titcod = par-numcod.
    
    aux = numtitulo.etbcod * 1000000000.
    
    par-numcod = aux + par-numcod.    
end.
