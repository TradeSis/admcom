def var vclfcod     like clifor.clfcod.

vclfcod = int(os-getenv("pedid")).

def buffer forne-clifor for clifor.
def buffer filho-clifor for clifor.

def temp-table tt-grupo
    field clfcod as int.

find forne-clifor where forne-clifor.clfcod = vclfcod no-lock.

def temp-table tt-pedid
    field rec as recid
    field datentrega as date column-label "Entrega"
    field marcado as log.
    
def buffer bpedid       for pedid.
def var vpedid         like pedid.pednum.



run monta-tt.

procedure monta-tt. 

for each tt-grupo.
    delete tt-grupo.
end.
    
if forne-clifor.clfcodp = 0
then do: 

    create tt-grupo. 
    assign 
        tt-grupo.clfcod = forne-clifor.clfcod.

    for each filho-clifor where
        filho-clifor.clfcodp = forne-clifor.clfcod
        no-lock.
        create tt-grupo.
        assign
            tt-grupo.clfcod = filho-clifor.clfcod.
    end.
            
            
end.
else do:

    create tt-grupo. 
    assign 
        tt-grupo.clfcod = forne-clifor.clfcodp.


    for each filho-clifor where
        filho-clifor.clfcodp = forne-clifor.clfcodp
        no-lock.
        create tt-grupo.
        assign
            tt-grupo.clfcod = filho-clifor.clfcod.
    end.
 
end.

/* montar um tt com os codigos do grupo possiveis */
 
for each estab no-lock. 
    for each proenoc where
  
                proenoc.etbentrega = estab.etbcod and
                proenoc.sitproenoc = "P" and
                proenoc.procod <> 0
                no-lock.
        find liped of proenoc no-lock no-error.
        if not avail liped
        then next.
    
        find pedid of liped no-lock.
        
        find first tt-grupo where
            tt-grupo.clfcod = pedid.clfcod
            no-lock no-error.
        if not avail tt-grupo
        then next.
        
        find first tt-pedid where
            tt-pedid.rec = recid(pedid) 
                no-error.
        if avail tt-pedid then next.
            
        create tt-pedid.
        tt-pedid.rec = recid(pedid).
        tt-pedid.datentrega = proenoc.datentrega.
    
    end.                        
    
    for each proenoc where
  
                proenoc.etbentrega = estab.etbcod and
                proenoc.sitproenoc = "C" and
                proenoc.procod <> 0 and
                proenoc.DatEntrega >= today - 60
                no-lock.
        find liped of proenoc no-lock no-error.
        if not avail liped
        then next.
    
        find pedid of liped no-lock.
        
        find first tt-grupo where
            tt-grupo.clfcod = pedid.clfcod
            no-lock no-error.
        if not avail tt-grupo
        then next.
        
        find first tt-pedid where
            tt-pedid.rec = recid(pedid) 
                no-error.
        if avail tt-pedid then next.
            
        create tt-pedid.
        tt-pedid.rec = recid(pedid).
        tt-pedid.datentrega = proenoc.datentrega.
    
    end.                        
    
end.
end procedure.

def temp-table ttprodu
    field procod    like produ.procod
    index procod is primary unique procod asc.
for each ttprodu.
delete ttprodu.
end.
def var vi as int.

vi = 0.
for each tt-pedid no-lock.                               
    find pedid where recid(pedid) = tt-pedid.rec no-lock.
    vi = vi + 1.
end.    
if vi > 0
then do.
    put unformatted skip "#pedid," + string(vi) skip.
    for each tt-pedid no-lock.
        find pedid where recid(pedid) = tt-pedid.rec no-lock.
        export pedid.
    end.
end.
vi = 0.
for each tt-pedid no-lock.                               
    find pedid where recid(pedid) = tt-pedid.rec no-lock.
    for each liped of pedid no-lock. 
        vi = vi + 1.
    end.
end.
if vi > 0
then do.
    put unformatted skip "#liped," + string(vi) skip.
    for each tt-pedid no-lock.
        find pedid where recid(pedid) = tt-pedid.rec no-lock.
        for each liped of pedid no-lock.
            export liped.
            find first ttprodu where ttprodu.procod = liped.procod no-error.
            if not avail ttprodu
            then create ttprodu.
            ttprodu.procod = liped.procod.
        end.
    end.
end.
vi = 0.
for each tt-pedid no-lock.                               
    find pedid where recid(pedid) = tt-pedid.rec no-lock.
    for each proenoc of pedid no-lock. 
        vi = vi + 1.
    end.
end.
if vi > 0
then do.
    put unformatted skip "#proenoc," + string(vi) skip.
    for each tt-pedid no-lock.
        find pedid where recid(pedid) = tt-pedid.rec no-lock.
        for each proenoc of pedid no-lock.
            export proenoc.
        end.
    end.
end.
vi = 0.
for each ttprodu.
    find produ of ttprodu no-lock no-error.
    if not avail produ
    then next.
    vi = vi + 1.
end.
if vi > 0
then do.
    put unformatted skip "#produ," + string(vi) skip.
    for each ttprodu.                          
        find produ of ttprodu no-lock no-error. 
        if not avail produ                      
        then next.                             
        export produ.
    end.
end.




