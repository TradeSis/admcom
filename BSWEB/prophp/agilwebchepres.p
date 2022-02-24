def var vtipcon    as int.
def var vcheprenum as int.
def var vi as int.

vtipcon    = int(entry(1, os-getenv("chepres"), "-")). 
vcheprenum = int(entry(2, os-getenv("chepres"), "-")).

output to ./log.
put unformatted os-getenv("chepres") " " vtipcon " " vcheprenum.
output close.

find chepres where chepres.tipcon    = vtipcon and
                   chepres.cheprenum = vcheprenum no-lock no-error.
if not avail chepres
then do:
    put unformatted "NAOEXISTE".
    quit.
end.
put unformatted skip "#chepres,1" skip.
export chepres.

vi = 0.
for each chepresmov of chepres no-lock.
    vi = vi + 1.
end.

if vi > 0
then do:
    put unformatted skip "#chequepresentemovimento," + string(vi) skip.
    for each chepresmov of chepres no-lock.
        export chepresmov.
    end.
end.
