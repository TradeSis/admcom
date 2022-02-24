def var p-etbcod as int.
def var p-placod as int.
def var p-contnum as int.
def var p-certificado as char.
def var v-param as char.
v-param = os-getenv("numerosorte").
p-etbcod = int(substr(string(v-param),1,3)).
/*p-placod = int(substr(string(v-param),4,10)). 
p-contnum = int(substr(string(v-param),14,10)).
p-certificado = substr(string(v-param),24,20).
  */
p-certificado = trim(substr(string(v-param),4,20)).  
def var q as int.                    

find first segnumsorte where
           segnumsorte.etbcod = p-etbcod and 
           segnumsorte.certifi = p-certificado
            no-lock no-error.
    q = 0.
    put "@INICIO;" string(time) skip.
    
    put "#SEGNUMSORTE;" string(time) skip.

    export Certifi contnum DtFVig DtIncl DtIVig DtSorteio DtUso
         etbcod NSorteio PlaCod Serie.
         
    q = q + 1.

    put skip "@FIMSEGNUMSORTE;" string(q,"99999") skip.                      
    put skip "@FIMFIM;" string(time) skip.

