def var vopccod as int.
def var vi as int.

vopccod = int(os-getenv("opcom")).

find opcom where opcom.opccod = vopccod no-lock no-error.
if not avail opcom
then do:
        put unformatted "NAOEXISTE".
        quit.
end.
def temp-table ttcrepl
    field crecod    like crepl.crecod
    index crecod is primary unique crecod asc.
vi = 0.
for each crepprod where crepprod.opccod = opcom.opccod no-lock. 
    vi = vi + 1.
    find ttcrepl where ttcrepl.crecod = crepprod.crecod no-error.
    if not avail ttcrepl
    then create ttcrepl.
    ttcrepl.crecod = crepprod.crecod.
end.

if vi > 0
then do:
    put unformatted skip "#crepprod," + string(vi) skip.
    for each crepprod where crepprod.opccod = opcom.opccod no-lock. 
        export crepprod.
    end.
end.           
vi = 0.
for each crepjuro where crepjuro.opccod = opcom.opccod no-lock. 
    vi = vi + 1.
    find ttcrepl where ttcrepl.crecod = crepjuro.crecod no-error.
    if not avail ttcrepl
    then create ttcrepl.
    ttcrepl.crecod = crepjuro.crecod.
end.

if vi > 0
then do:
    put unformatted skip "#crepjuro," + string(vi) skip.
    for each crepjuro where crepjuro.opccod = opcom.opccod no-lock. 
        export crepjuro.
    end.
end.           
vi = 0.
for each ttcrepl.
    vi = vi + 1.
end.
if vi > 0
then do:
    put unformatted skip "#crepl," + string(vi) skip.
    for each ttcrepl.
        find crepl where crepl.crecod = ttcrepl.crecod no-lock no-error.
        if avail crepl
        then export crepl.
    end.
end.           




