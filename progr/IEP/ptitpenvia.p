
/* 05012022 helio iepro */

def input param poperacao as char.

def var vjuros as dec.
{iep/tfilsel.i}

{api/acentos.i}

function testanull returns character
    (input par-char as char).
   
    def var par-ret as char.
    par-ret = par-char.
    
    if par-ret = ?
    then par-ret = "".

    return par-ret.
    
end.    
    
function trata-numero returns character
    (input par-num as char).

    def var par-ret as char init "".
    def var vletra  as char.
    def var vi      as int.

    if par-num = ?
    then par-num = "".

    do vi = 1 to length(par-num).
        vletra = substr(par-num, vi, 1).
        if (asc(vletra) >= 48 and asc(vletra) <= 57) /* 0-9 */
        then par-ret = par-ret + substring(par-num,vi,1).
    end.

    return par-ret.

end function.


function formatadata returns character
    (input par-data  as date). 
    
    def var vdata as char.  

    if par-data <> ? 
    then vdata = string(par-data, "999999").
    else vdata = "000000". 

    return vdata. 

end function. 
    

def var varquivo  as char.
    
    find first ttfiltros.
    do on error undo:    
        create titprofiltro.
        titprofiltro.operacao = poperacao. 
        titprofiltro.dtinc    = today. 
        titprofiltro.hrinc    = time.
        titprofiltro.sstatus  = "ENVIAR".    

        titprofiltro.filtros = 
            "qtdsel"                        + "=" + testanull(string(ttfiltros.qtdsel)) + "|" +
            "vlrctrmin"                     + "=" + testanull(string(ttfiltros.vlrctrmin)) + "|" +
            "vlrctrmax"                     + "=" + testanull(string(ttfiltros.vlrctrmax)) + "|" +
            "vlrabemin"                     + "=" + testanull(string(ttfiltros.vlrabemin)) + "|" +
            "vlrabemax"                     + "=" + testanull(string(ttfiltros.vlrabemax)) + "|" +
            "vlrparcmin"                    + "=" + testanull(string(ttfiltros.vlrparcmin)) + "|" +
            "vlrparcmax"                    + "=" + testanull(string(ttfiltros.vlrparcmax)) + "|" +
            "diasatrasmin"                  + "=" + testanull(string(ttfiltros.diasatrasmin)) + "|" +
            "diasatrasmax"                  + "=" + testanull(string(ttfiltros.diasatrasmax)) + "|" +
            "dtemiini"                      + "=" + testanull(string(ttfiltros.dtemiini)) + "|" +
            "dtemimax"                      + "=" + testanull(string(ttfiltros.dtemimax)) + "|" +
            "modcod"                        + "=" + testanull(string(ttfiltros.modcod)) + "|" +
            "tpcontrato"                    + "=" + testanull(string(ttfiltros.tpcontrato)) + "|" +
            "arrastaparcelasvencidas"       + "=" + testanull(string(ttfiltros.arrastaparcelasvencidas)) + "|" +
            "arrastaparcelas"               + "=" + testanull(string(ttfiltros.arrastaparcelas)) + "|" +
            "arrastacontratosvencidos"      + "=" + testanull(string(ttfiltros.arrastacontratosvencidos)) + "|" +
            "arrastacontratos"              + "=" + testanull(string(ttfiltros.arrastacontratos)) + "|".
        
    end.

        for each ttparcela where ttparcela.marca = yes.

            find titulo where recid(titulo) = ttparcela.trecid no-lock.
            find contrato where contrato.contnum = int(titulo.titnum) no-lock.
            find clien of contrato no-lock.
            
            create titprotparc.    
            titprotparc.operacao = titprofiltro.operacao.
            titprotparc.remessa  = ?. /* ainda nao tem remessa */
            titprotparc.clicod   = clien.clicod. 
            titprotparc.contnum  = contrato.contnum.
            titprotparc.titpar   = titulo.titpar.

            
            titprotparc.dtinc    = titprofiltro.dtinc.
            titprotparc.hrinc     = titprofiltro.hrinc.
            
            titprotparc.titvlcob = titulo.titvlcob.
            
            titprotparc.titvljur = ttparcela.titvljur.
            
            /* helio 11012022 - IEPRO */
            run juro_titulo.p (if clien.etbcad = 0 then titulo.etbcod else clien.etbcad,
                               titulo.titdtven,
                               titulo.titvlcob,
                               output vjuros).

            titprotparc.titdescjur = vjuros - titprotparc.titvljur.            
            
            find first titprotesto where 
                    titprotesto.operacao = titprotparc.operacao and
                    titprotesto.remessa  = titprotparc.remessa  and
                    titprotesto.clicod   = titprotparc.clicod   and
                    titprotesto.contnum  = titprotparc.contnum
                    exclusive no-error.
            if not avail titprotesto
            then do:
                create titprotesto. 
                titprotesto.operacao = titprotparc.operacao.
                titprotesto.remessa  = titprotparc.remessa.
                titprotesto.clicod   = titprotparc.clicod.
                titprotesto.contnum  = titprotparc.contnum.
                titprotesto.acao     = "REMESSA".
                titprotesto.DtAcao      = ?.
                titprotesto.pagaCustas = no.                
                titprotesto.ativo       = "".
            end.                                          
            assign 
                titprotesto.VlCobrado   = titprotesto.VlCobrado +
                            (titprotparc.titvlcob + titprotparc.titvljur) .
                                        
    end.
    


