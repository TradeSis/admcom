def var v-param as char.
def var v-etbcod like estab.etbcod.
def var v-funcod like func.funcod.
def var valor as dec.
v-param = os-getenv("asstec01").
v-etbcod = int(substr(string(v-param),1,3)).

def var vtexto as char.
def var q as int.
def var vtotal as dec.
def var vpct as dec.
    put "@INICIO;" string(time) skip.
    put "#ASSTEC;" string(time) skip.
    q = 0.
    for each adm.asstec where adm.asstec.etbcod = V-etbcod no-lock:
            export adm.asstec.         
            q = q + 1.
    end.
    put skip "@FIMASSTEC;"  string(q,"99999").    
    put skip "@FIMFIM;"  string(time) skip.
