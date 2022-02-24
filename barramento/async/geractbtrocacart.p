def input param vdtini as date.
def input param vgeral as log.
def var hpagtoRecebidoPeriodoEntrada as handle.
def var lcJsonSaida as longchar.
def var lokJson as log.

def var vdt as date. 
def var vcobnom like cobra.cobnom.
def var vvalor as dec.
DEFINE TEMP-TABLE ttstatus NO-UNDO serialize-name 'pagtoRecebidoPeriodo'
    FIELD chave as char     serialize-hidden  
    field dataExecucao  as date 
    index x is unique primary chave asc.

def temp-table tt-pgcontrato no-undo serialize-name 'pagtoRecebido'
    FIELD chave as char     serialize-hidden  
    field dataDocumento     like pdvmov.datamov 
    field dataLancamento    like pdvmov.datamov 
    field documentoReferencia like pdvdoc.contnum
    index x dataDocumento asc documentoReferencia asc.
    
def temp-table tt-mov no-undo serialize-name 'movimentos'
    FIELD chave as char     serialize-hidden  
    field dataDocumento     like tt-pgcontrato.dataDocumento serialize-hidden
    field documentoReferencia like tt-pgcontrato.documentoReferencia serialize-hidden
    field carteira          like cobra.cobnom
    field ctmcod            like pdvtmov.ctmnom serialize-name 'operacao'
    field funnom            like func.funnom serialize-name 'usuario'
    field setor             as char 
    field valor             as dec format "->>>>>>>>>9.99" serialize-name 'valor'
    field moeda             as char initial "BRL"
    index x dataDocumento asc documentoReferencia asc.


DEFINE DATASET pagtoRecebidoPeriodoEntrada FOR ttstatus, tt-pgcontrato, tt-mov
  DATA-RELATION for1 FOR ttstatus, tt-pgcontrato
    RELATION-FIELDS(ttstatus.chave,tt-pgcontrato.chave) NESTED 
  DATA-RELATION for2 FOR tt-pgcontrato , tt-mov
    RELATION-FIELDS(tt-pgcontrato.dataDocumento,tt-mov.dataDocumento,
                    tt-pgcontrato.documentoReferencia,tt-mov.documentoReferencia) NESTED .

hpagtoRecebidoPeriodoEntrada = DATASET pagtoRecebidoPeriodoEntrada:HANDLE.


                        
def var vi as int.
def var vtoday as date.
pause 0 before-hide.

if vdtini < 07/01/2020 then vdtini = 07/01/2020.

message "Gerando  ctb da troca de carteira SAP desde " vdtini string(vgeral,"Geral/Novos") .

do vtoday = vdtini to today:

    for each ttstatus. delete ttstatus. end.
    for each tt-pgcontrato. delete tt-pgcontrato. end.
    for each tt-mov. delete tt-mov. end.
    
    create ttstatus.
    ttstatus.dataExecucao = today . 
   
    for each ctbtrocart where ctbtrocart.dtinc = vtoday .

                if vgeral = no
                then if ctbtrocart.dtenvsap = ?
                     then .
                     else next.
                

        find contrato where contrato.contnum = int(ctbtrocart.contnum) no-lock.
        find first titulo where
            titulo.empcod = 19 and titulo.titnat = no and titulo.etbcod = contrato.etbcod and
            titulo.modcod = contrato.modcod and titulo.clifor = contrato.clicod and
            titulo.titnum = string(contrato.contnum) and
            titulo.titpar = ctbtrocart.titpar
            no-lock no-error.

                    if avail titulo
                    then do:
                        find cobra of titulo no-lock.
                        find first tt-pgcontrato where
                            tt-pgcontrato.dataDocumento         = ctbtrocart.dtrefsaida and
                            tt-pgcontrato.dataLancamento        = ctbtrocart.dtrefsaida and
                            tt-pgcontrato.documentoReferencia   = titulo.titnum
                            no-error.      
                        if not avail tt-pgcontrato
                        then do:
                            create tt-pgcontrato.
                            tt-pgcontrato.dataDocumento         = ctbtrocart.dtrefsaida.
                            tt-pgcontrato.dataLancamento        = ctbtrocart.dtrefsaida.
                            tt-pgcontrato.documentoReferencia   = titulo.titnum.      
                        end.
                        find first tt-mov where
                            tt-mov.dataDocumento            = tt-pgcontrato.dataDocumento and
                            tt-mov.documentoReferencia      = tt-pgcontrato.documentoReferencia and
                            tt-mov.carteira                 = trim(cobra.cobnom) and
                            tt-mov.ctmcod                   = "TRC" and
                            tt-mov.funnom                   = ""
                                                          no-error.
                         if not avail tt-mov
                         then do:
                            create tt-mov.
                            tt-mov.dataDocumento            = tt-pgcontrato.dataDocumento.
                            tt-mov.documentoReferencia      = tt-pgcontrato.documentoReferencia.
                            tt-mov.carteira                 = trim(cobra.cobnom).
                            tt-mov.ctmcod                   = "TRC".
                            tt-mov.funnom                   = "".
                        end.       

                            tt-mov.valor                    = tt-mov.valor + ctbtrocart.valorSAIDA.
                        
                        vi = vi + 1.                    
                        if ctbtrocart.dtenvsap = ? then     ctbtrocart.dtenvsap = today.
                    end.

        
    end.         
    
    find first tt-pgcontrato no-error. 
    if avail tt-pgcontrato 
    then do: 
        lokJson = hpagtoRecebidoPeriodoEntrada:WRITE-JSON("LONGCHAR", lcJsonSaida, TRUE) no-error. 
        if lokJson 
        then do:  
            create verusjsonout. 
            ASSIGN  
                verusjsonout.interface     = "pagtoRecebidoPeriodo".  
                verusjsonout.jsonStatus    = "NP".  
                verusjsonout.dataIn        = today.  
                verusjsonout.horaIn        = time.  
            copy-lob from lcJsonSaida to verusjsonout.jsondados.
    
            hpagtoRecebidoPeriodoEntrada:WRITE-JSON("FILE","pagtoRecebidoPeriodoEntrada.json", true).
        end.
    end.
    
end.    


