
def var vprocod as int.
def var vi as int.
def buffer xestab for estab.
def buffer xtipped for tipped.
def buffer xliped for liped.

vprocod = int(os-getenv("produ")).

find produ where produ.procod = vprocod no-lock no-error.
if not avail produ
then do:
        put unformatted "NAOEXISTE".
        quit.
end.
put unformatted skip "#produ,1" skip.
export produ.

find first precohrg    where                                                                 precohrg.procod = vprocod and                                                  precohrg.dativig <= today no-lock.                                  
if avail precohrg
then do:
    put unformatted skip "#precohrg,1" skip. 
    export precohrg.procod 
            precohrg.rgcod 
            precohrg.dativig 
            precohrg.prvenda 
            precohrg.funcod 
            precohrg.data 
            precohrg.hora.
end.

vi = 0.
for each precohvnd where precohvnd.procod = vprocod and
                         precohvnd.dtivig <= today no-lock.
    vi = vi + 1.
end.
if vi > 0
then do:
    put unformatted skip "#precohvnd," + string(vi) skip.
    for each precohvnd where precohvnd.procod = vprocod and
                             precohvnd.dtivig <= today no-lock.
        export precohvnd.
    end.
end.
 
vi = 0.
for each promoc where promoc.procod = vprocod and
                        promoc.dtivig <= today and
                    (promoc.dtfvig >= today or
                     promoc.dtfvig = ?)
     no-lock.
    vi = vi + 1.
end.
if vi > 0
then do:
    put unformatted skip "#promoc," + string(vi) skip.
    for each promoc  where  
            promoc.procod = vprocod and                                
            promoc.dtivig <= today and
           (promoc.dtfvig >= today or
            promoc.dtfvig = ?) no-lock.                            
        export promoc.
    end.           
end.           

vi = 0.
for each estoq where estoq.procod = vprocod no-lock.
    /*if estoq.estatual = 0
    then next.
*/
    vi = vi + 1.
end.

def var vestreser         like estoq.estreser.
def var vlipqtd                as   dec.  
def var vdtped                 as   date. 

put unformatted skip "#estoq," + string(vi)  skip.
for each estoq where estoq.procod = vprocod no-lock.
    vestreser = 0.
    vlipqtd   = 0.
    vdtped    = ?.
    if estoq.etbcod = 99
    then do. 
        for each prodistr where prodistr.procod = produ.procod
                            and prodistr.lipsit = "A"
                          no-lock.                                       
            if prodistr.tipo = "NEG" or                        
               prodistr.tipo = "LOJ" or                        
               prodistr.tipo = "COM" then                      
            vestreser = vestreser + prodistr.lipqtd.            
        end.                                                  

        vdtped = 11/11/2099.
        vlipqtd = 0.
    
        for each xtipped where
            no-lock.
            for each xestab no-lock.
                for each xliped where
                        xliped.etbped = xestab.etbcod and
                        xliped.pedtdc = xtipped.pedtdc and
                        xliped.lipsit = "P" and
                        xliped.procod = vprocod
                    no-lock.
                    for each proenoc of xliped no-lock.
                        vlipqtd = vlipqtd +
                            (proenoc.qtdmerca - proenoc.qtdmercaent).
                        vdtped = min(vdtped,proenoc.datentrega).
                    end.        
                end.                
            end.
        end.
        if vdtped = 11/11/2099
        then vdtped = ?.
    end.
        export estoq.procod
               estoq.etbcod
               estoq.estatual
               vestreser
               vlipqtd
               vdtped
               .

end.

find fabri of produ no-lock no-error.
if avail fabri
then do.
    put unformatted skip "#fabri,1"   skip.
    export fabri.
end.
    
vi = 0.
for each producas where producas.procod = produ.procod
                    and (producas.dtivig > today - 30 or
                         producas.dtfvig > today - 30)
                  no-lock.
    vi = vi + 1.
end.
if vi > 0
then do.
    put unformatted skip "#producas," + string(vi) skip.
    for each producas where producas.procod = produ.procod
                        and (producas.dtivig > today - 30 or
                             producas.dtfvig > today - 30)
                      no-lock.
        export producas.
    end.
end.

vi = 0.
for each produgar where produgar.procod = produ.procod no-lock.
    vi = vi + 1.
end.
if vi > 0
then do.
    put unformatted skip "#produgar," + string(vi) skip.
    for each produgar where produgar.procod = produ.procod no-lock.
        export produgar.
    end.
end.

vi = 0.
for each mvcustogar where mvcustogar.procod = produ.procod no-lock.
    vi = vi + 1.
end.
if vi > 0
then do.
    put unformatted skip "#mvcustogar," + string(vi) skip.
    for each mvcustogar where mvcustogar.procod = produ.procod no-lock.
        export mvcustogar.
    end.
end.

/* Estoque regulador */
vi = 0.
for each estab no-lock.
    for each ficha where ficha.etbcod = estab.etbcod
                     and ficha.procod = produ.procod
                     and ficha.motivo = "ESTOQMINIMO"
                   no-lock.
        vi = vi + 1.
    end.
end.
if vi > 0
then do.
    put unformatted skip "#ficha," + string(vi) skip.
    for each estab no-lock.
        for each ficha where ficha.etbcod = estab.etbcod
                         and ficha.procod = produ.procod
                         and ficha.motivo = "ESTOQMINIMO"
                       no-lock.
            export ficha.
        end.
    end.
end.

run agilwebbuscacmp.p (vprocod).
