def var varquivo as char.
def var v-clicod like clien.clicod.
def var v-param as char.

def var vq as int.                                
v-param = os-getenv("pre-venda").

def temp-table tt-clien like clien.
def temp-table tt-titulo like fin.titulo
use-index cxmdat
use-index datexp
use-index etbcod
use-index exportado
use-index iclicod
use-index titdtpag
use-index titdtven
use-index titnum
use-index titsit
.

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
    
    put "#TBCARTAO;" string(time) skip.
    for each tbcartao where tbcartao.codoper = 999 and
                            tbcartao.clicod = int(v-param)
                            no-lock.
        export tbcartao.
        v-clicod = tbcartao.clicod.
        q = q + 1.
    end.  
    put skip "@FIMTBCARTAO;" string(q,"99999") skip.                      
 

