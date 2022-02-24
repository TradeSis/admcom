/*
    #1 Garantia/RFQ
*/
def var p-etbcod as int.
def var p-placod as int.
def var v-param as char.
def var vq as int.                                
v-param = os-getenv("vndseguro").
p-etbcod = int(substr(string(v-param),1,3)).
p-placod = int(substr(string(v-param),4,10)). 

def var vcalclim as dec.
def var vpardias as dec.
def var vdisponivel as dec.
def new shared temp-table tt-dados
    field parametro as char
    field valor     as dec
    field valoralt  as dec
    field percent   as dec
    field vcalclim  as dec
    field operacao  as char format "x(1)" column-label ""
    field numseq    as int
    index dado1 numseq.

def var vobs as char.
def var q as int.                    

    q = 0.
    put "@INICIO;" string(time) skip.
    
    put "#VNDSEGURO;" string(time) skip.
    for each com.vndseguro where
             com.vndseguro.etbcod = p-etbcod and
             com.vndseguro.placod = p-placod and
             com.vndseguro.tpseguro < 4 /* #1 */
             no-lock:
        export vndseguro /*#1*/ except tempo.
        q = q + 1.
    end.  
    put skip "@FIMVNDSEGURO;" string(q,"99999") skip.                      

