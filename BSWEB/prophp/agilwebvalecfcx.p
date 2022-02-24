def var v-param as char.
def var v-ind as char.
def var v-etbcod like estab.etbcod.
def var v-funcod like func.funcod.
def var v-titsit like fin.titluc.titsit.
v-param = os-getenv("tabecf").
v-ind = substr(string(v-param),1,1).
v-etbcod = int(substr(string(v-param),2,3)).

def var q as int.

    put "@INICIO;" string(time) skip.
    put "#TABECF;" string(time) skip.
    q = 0.
    for each tabecf where tabecf.etbcod = v-etbcod no-lock:
        export tabecf .
        q = q + 1.
    end.                 
    put skip "@FIMTABECF;" string(q,"99999").    
    put skip "@FIMFIM;" + string(time) skip.


