def var par-parametros as char.
def var vi as int.
def buffer xestab for estab.
def buffer xtipped for tipped.
def buffer xliped for liped.

def var vprocod like produ.procod.
def var vetbcod like estab.etbcod.
def var vdtini  as char format "x(8)".
def var vdtfim  as char format "x(8)".
 
par-parametros  = os-getenv("proext").
vprocod = int(substr(par-parametros,1,10)).
vetbcod = int(substr(par-parametros,11,3)).
vdtini  =    (substr(par-parametros,14,8)).
vdtfim  =    (substr(par-parametros,22,8)).

put unformatted 
    "vprocod " vprocod
    "  vetbcod  " vetbcod
    "  vdtini " vdtini
    "  vdtfim " vdtfim 
    skip.
def var vdti as date.
vdti = date(int(substr(vdtini,03,2)),
            int(substr(vdtini,01,2)),
            int(substr(vdtini,05,5))).
def var vdtf as date.
vdtf = date(int(substr(vdtfim,03,2)),
            int(substr(vdtfim,01,2)),
            int(substr(vdtfim,05,5))).

find produ where produ.procod = vprocod no-lock no-error.
if not avail produ
then do:
        put unformatted "NAOEXISTE".
        quit.
end.
put unformatted skip "#produ,1" skip.
export produ.

def var vctmfim     like hiest.hiectmfim format "->>>>>9.99".

def new shared temp-table tt-extrato
    field data      as date format "99/99/9999"
    field hora      as int
    field seq       as int
    field emitente  as int
    field destino   as int
    field rec-movim as recid
    field funcod    like func.funcod
    field etb       like estab.etbcod
    field movimento  as char
    field numero    as char format "x(10)"
    field clfcod    like clifor.clfcod
    field qtd       like movim.movqtm
    field estoque   like estoq.estatual
    field custooper like movim.movctm
    field efin      like vctmfim

    field etbcod    like movim.etbcod
    field PlaCod    like movim.placod
    field movseq    like movim.movseq
    
    index esquema              data asc
                               hora asc
                               /*
                               numero asc 
                               seq asc 
                               */
                               /*
    index extrato   is primary data asc
                               seq asc */ .

for each tt-extrato.
    delete tt-extrato.
end.    
 
run proext1ger.p ( produ.procod,
                   vetbcod , 
                   vdti,
                   vdtf).
                   
vi = 0.
for each tt-extrato.
    vi = vi + 1.
end.    
if vi > 0
then do.
    put unformatted "#ttextrato," vi  skip.
    for each tt-extrato.   
        export tt-extrato.
    end.
    vi = 0.
    for each tt-extrato,    
        each movim where recid(movim) = tt-extrato.rec-movim no-lock,
        each plani of movim no-lock break by recid(plani).
        if last-of(recid(plani))
        then vi = vi + 1.
    end.      
    put unformatted "#plani," vi  skip.
    for each tt-extrato,    
        each movim where recid(movim) = tt-extrato.rec-movim no-lock,
        each plani of movim no-lock break by recid(plani).
        if last-of(recid(plani))
        then export plani.
    end.
    vi = 0.
    for each tt-extrato,    
        each movim where recid(movim) = tt-extrato.rec-movim no-lock
                                    break by recid(movim).
        if last-of(recid(movim))
        then vi = vi + 1.
    end.      
    put unformatted "#movim," vi  skip.
    for each tt-extrato,    
        each movim where recid(movim) = tt-extrato.rec-movim no-lock
                                break by recid(movim).
        if last-of(recid(movim))
        then export movim.
    end.
end.

