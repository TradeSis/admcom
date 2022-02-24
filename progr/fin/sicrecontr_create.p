def input  param ppdvforma as recid.
def input  param pcontnum  like contrato.contnum. 
def output param psicred as recid.

find pdvforma where recid(pdvforma) = ppdvforma no-lock no-error.
if avail pdvforma
then do:
    find pdvmov   of pdvforma no-lock.
    find pdvtmov of pdvmov no-lock.
    find contrato where contrato.contnum = int(pdvforma.contnum) no-lock.
end.    
else  find contrato where contrato.contnum = pcontnum no-lock.


find cobra where cobra.cobcod = 10 no-lock.

if cobra.sicred
then DO on error undo:
  create sicred_contrato.
  psicred = recid(sicred_contrato).  
  ASSIGN
    sicred_contrato.operacao  = if avail pdvtmov and pdvtmov.novacao
                                then "NOVACAO"
                                else "CONTRATO"
    sicred_contrato.dtinc     = today
    sicred_contrato.hrinc     = time
    sicred_contrato.contnum   = contrato.contnum
    sicred_contrato.sstatus   = "ENVIAR"
    sicred_contrato.cobcod    = cobra.cobcod
    sicred_contrato.lotnum    = ?.
    if avail pdvforma
    then do:
        assign
        sicred_contrato.cmocod    = pdvmov.cmocod
        sicred_contrato.ctmcod    = pdvmov.ctmcod
        sicred_contrato.DataMov   = pdvmov.DataMov
        sicred_contrato.etbcod    = pdvmov.etbcod
        sicred_contrato.Sequencia = pdvmov.Sequencia
        sicred_contrato.seqforma  = pdvforma.seqforma.
    end.
    else do:
        assign
        sicred_contrato.cmocod    = ?
        sicred_contrato.ctmcod    = "SIT"
        sicred_contrato.DataMov   = contrato.dtinicial
        sicred_contrato.etbcod    = contrato.etbcod
        sicred_contrato.Sequencia = ?
        sicred_contrato.seqforma  = ?.
    end.            
END.

