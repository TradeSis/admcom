/*
*
* Geracao de Operacao do Movimento de Centros Monetarios cmgope.p
*
*/
{cabec.i}
def var vcodcod as int.
def input  parameter par-pdvmov-Recid  as   recid.

def var vcxadt as date.
def var sal-cmocod         like cmon.cmocod.
def buffer tcmon            for cmon.
def buffer tpdvtmov          for pdvtmov.
def buffer tpdvmov         for pdvmov.
def buffer tpdvdoc         for pdvdoc.
def buffer bpdvdoc         for pdvdoc.

def buffer btitpag          for titpag.
def var    tpdvmov-recid   as recid.
def var vlrtra          as dec.
def var vmaismenos      as char.
def var vdtref          as date format "99/99/9999".

def buffer bpdvmov for pdvmov.

find pdvmov where recid(pdvmov) = par-pdvmov-Recid.
find pdvtmov of pdvmov no-lock.
find CMon of pdvmov no-lock.
find cmtipo of cmon  no-lock.

do on error undo:
    assign
        vcxadt = if pdvmov.datamov = ?
                 then today
                 else pdvmov.datamov
        pdvmov.datamov = vcxadt.
        pdvmov.valortot = 0.

end.

    for each pdvdoc of pdvmov.
        run p-processa.
        pdvmov.valortot = pdvmov.valortot + pdvdoc.valor.
    end.

    
    
def var vdebcre as log.

procedure p-processa.

    find modal of pdvdoc no-lock.

    vdebcre     = pdvmov.entsai.
    vmaismenos  = "-".
    
    if vmaismenos = "-" /* Casos onde Dimunui o Saldo */
    then do:
        /* 1. Baixando o Saldo de Um titulo */
        if pdvdoc.contnum <> ?
        then do: 
            find titulo where titulo.contnum = int(pdvdoc.contnum) and
                              titulo.titpar  = pdvdoc.titpar.
                              
                            /* qdo transferencia entre caixas 
                               nao cria titpag */

            run fin/baixatitulo.p (recid(pdvdoc),
                                   recid(titulo)).
        end.
end.            
end procedure.
