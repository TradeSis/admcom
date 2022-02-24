/* #H1 helio.neto 30072021 - ajustou a moecod, para a mesma regra de outras, que é pelo tipo de baixa */

/* Gestao de Boletos   - rotinas
   bol/efetivaacordo_v2101.p
   Efetiva acordo criando Contrato/Titulos e Baixando TitulosOriginais 
#1 22.02.2018 Helio - Corretiva TP 22125274 - Acerto para baixar titulo origem
   pelo valor do titulo, e nao o do parametro que é o valor da entrada do acordo
#2 TP 28872041 16.01.19 - Etbcod e modcod na origem
*/

/**
    {cabec.i}
**/
def input parameter par-pdvmov as recid.
def input parameter par-seqreg  as int.

def input parameter par-bolorigem as recid.
def input parameter par-titdtpag  as date.
def input parameter par-titvlpag  as dec.
def input parameter par-titjuro   as dec.  
def output param    par-ok as log.

def buffer origem-cybacparcela for cybacparcela.

def var vcontnum like contrato.contnum.
def var vetbcod  as int.
def var vmodcod     like titulo.modcod.
def var vparc    as int.
def var vseq as int.
par-ok = no.
def buffer epdvmov for pdvmov.
def var prec as recid.

find pdvmov where recid(pdvmov) = par-pdvmov no-lock.

            /* helio 25.11.2021 - cria movimento soh com a entrada */
            
                    find first pdvtmov where pdvtmov.ctmcod = "BOL" no-lock.

                    find cmon where cmon.etbcod = 999 and cmon.cxacod = 99 no-lock.
                    
                    run fin/cmdincdt.p (recid(cmon), recid(pdvtmov), 
                                        par-titdtpag,
                                        output prec).

                    find epdvmov where recid(epdvmov) = prec no-lock.


find banbolorigem where recid(banbolorigem) = par-bolorigem no-lock.
find banboleto of banbolorigem no-lock.
 
find origem-cybacparcela where 
     origem-cybacparcela.idacordo = int(entry(1,banbolorigem.dadosOrigem)) and
     origem-cybacparcela.parcela  = int(entry(2,banbolorigem.dadosOrigem))
    no-lock no-error.
if not avail origem-cybacparcela
then return.
find cybacordo of origem-cybacparcela no-lock no-error.
if not avail cybacordo
then return.

def var psicred as recid.

if cybacordo.dtefetiva = ? and
   cybacordo.situacao  = "V" /* Vinculado, mas Ainda nao Efetivado **/
then do:
    
    do for geranum on error undo on endkey undo: 
    /*** Numeracao para CONTRATOS criados na matriz ***/ 
        find geranum where geranum.etbcod = 999 exclusive no-error. 
        if not avail geranum 
        then do: 
            create geranum. 
            assign geranum.etbcod  = 999 
                geranum.clicod  = 300000000 
                geranum.contnum = 300000000. 
        end. 
        geranum.contnum = geranum.contnum + 1. 
        find current geranum no-lock. 
        vcontnum = geranum.contnum. 
    end.

    find first cybacorigem of cybacordo /* #2 */ NO-LOCK no-error.
    if cybacorigem.modcod begins "CP" 
    then vmodcod = "CPN".
    else vmodcod = cybacorigem.modcod.

    do on error undo:
        create contrato.
        ASSIGN
            contrato.contnum   = vcontnum
            contrato.clicod    = cybacordo.clifor
            contrato.dtinicial = par-titdtpag
            contrato.etbcod    = cybacordo.etbcod
            contrato.vltotal   = 0
            contrato.vlentra   = 0
            contrato.modcod    = vmodcod
            contrato.crecod    = 500
            contrato.banco = if vmodcod = "CPN"
                             then 13 else 10
            contrato.tpcontrato = "N".

        /* helio 25.11.2021 ID 98001 - Novações cslog fora da estrutura padrão para origem e novo.
                criando forma e pdvmoeda */
            find first pdvforma where      
                     pdvforma.etbcod     = pdvmov.etbcod and
                 pdvforma.cmocod     = pdvmov.cmocod and
                 pdvforma.DataMov    = pdvmov.DataMov and
                 pdvforma.Sequencia  = pdvmov.Sequencia and
                 pdvforma.ctmcod     = pdvmov.ctmcod and
                 pdvforma.COO        = pdvmov.COO and
                 pdvforma.seqforma   = 1
                no-error.
            if not avail pdvforma 
            then do: 
                create pdvforma.
                assign
                    pdvforma.etbcod     = pdvmov.etbcod
                    pdvforma.DataMov    = pdvmov.DataMov
                    pdvforma.cmocod     = pdvmov.cmocod
                    pdvforma.COO        = pdvmov.COO
                    pdvforma.Sequencia  = pdvmov.Sequencia
                    pdvforma.ctmcod     = pdvmov.ctmcod 
                    pdvforma.seqforma   = 1.
            end.                     

            find pdvtforma where pdvtforma.pdvtfcod = "93" no-lock no-error.
            pdvforma.crecod       = contrato.crecod.
            pdvforma.modcod       = contrato.modcod.
            pdvforma.pdvtfcod     = "93".
            pdvforma.fincod       = 1.
            pdvforma.valor_forma  = contrato.vlTotal.
            pdvforma.valor        = contrato.vlTotal.


            pdvforma.contnum      = string(contrato.contnum).
            pdvforma.clifor       = contrato.clicod.
            pdvforma.crecod       = 2.
            
            pdvforma.qtd_parcelas = contrato.nro_parcela.
            pdvforma.valor_ACF    = contrato.vlf_Acrescimo.
            pdvforma.valor        = contrato.vlTotal.
        /* helio 25.11.2021 ID 98001 - Novações cslog fora da estrutura padrão para origem e novo.
                criando forma e pdvmoeda */

    end.                                                    

    for each cybacparcela of cybacordo
        by cybacparcela.parcela.
                
        create titulo.
        ASSIGN
            titulo.empcod     = 19
            titulo.modcod     = contrato.modcod
            titulo.tpcontrato = "N" 
            titulo.CliFor     = contrato.Clicod
            titulo.titnum     = string(contrato.contnum)
            titulo.titpar     = cybacparcela.parcela
            titulo.titnat     = no
            titulo.etbcod     = contrato.etbcod
            titulo.titdtemi   = par-titdtpag
            titulo.titdtven   = cybacparcela.dtVencimento
            titulo.titvlcob   = cybacparcela.vlCobrado.


        /* helio 25.11.2021 ID 98001 - Novações cslog fora da estrutura padrão para origem e novo.
                criando forma e pdvmoeda */.
                find first pdvmoeda where      
                     pdvmoeda.etbcod       = pdvmov.etbcod and
                     pdvmoeda.cmocod       = pdvmov.cmocod and
                     pdvmoeda.DataMov      = pdvmov.DataMov and
                     pdvmoeda.Sequencia    = pdvmov.Sequencia and
                     pdvmoeda.ctmcod       = pdvmov.ctmcod and
                     pdvmoeda.COO          = pdvmov.COO and
                     pdvmoeda.seqforma     = pdvforma.seqforma and
                     pdvmoeda.seqfp        = 1 and
                     pdvmoeda.titpar       = titulo.titpar
                    no-error.
                if not avail pdvmoeda
                then do: 
                    create pdvmoeda.
                    /*pdvmoeda.titcod   = next-value(titcod).*/
                    assign
                         pdvmoeda.etbcod       = pdvmov.etbcod
                         pdvmoeda.DataMov      = pdvmov.DataMov
                         pdvmoeda.cmocod       = pdvmov.cmocod
                         pdvmoeda.COO          = pdvmov.COO
                         pdvmoeda.Sequencia    = pdvmov.Sequencia
                         pdvmoeda.ctmcod       = pdvmov.ctmcod
                         pdvmoeda.seqforma     = pdvforma.seqforma
                         pdvmoeda.seqfp        = 1
                         pdvmoeda.titpar       = titulo.titpar.   
                end.                  
                assign
                    pdvmoeda.contrato_p2k = pdvforma.contnum.
                pdvmoeda.clifor = contrato.clicod.
                pdvmoeda.titnum = string(contrato.contnum).
                pdvmoeda.moecod = pdvforma.modcod.
                pdvmoeda.modcod = pdvforma.modcod.

                pdvmoeda.valor = titulo.titvlcob.
                pdvmoeda.titdtven = titulo.titdtven.
        /* helio 25.11.2021 ID 98001 - Novações cslog fora da estrutura padrão para origem e novo.
                criando forma e pdvmoeda */.
        
        assign
            cybacparcela.contnum    = contrato.contnum.

        if cybacparcela.parcela = origem-cybacparcela.parcela
        then do:
            assign
                titulo.titdtpag = par-titdtpag
                titulo.titvlpag = titulo.titvlcob + par-titjuro /* #1 */ 
                        /*par-titvlpag*/
                titulo.titjuro  = par-titjuro
                titulo.titsit   = "PAG". 
                
                titulo.etbcobra = 999.
                titulo.moecod    = epdvmov.ctmcod. /* #H1 */
                
            assign
                cybacparcela.dtbaixa  = today
                cybacparcela.situacao = "B". /* Baixado */ 
            vseq = vseq + 1.    
            create pdvdoc.
            ASSIGN
                pdvdoc.etbcod            = epdvmov.etbcod
                pdvdoc.cmocod            = epdvmov.cmocod
                pdvdoc.DataMov           = epdvmov.DataMov
                pdvdoc.Sequencia         = epdvmov.Sequencia
                pdvdoc.ctmcod            = epdvmov.ctmcod
                pdvdoc.COO               = epdvmov.COO
                pdvdoc.seqreg            = par-seqreg + vseq
                pdvdoc.CliFor            = titulo.CliFor
                pdvdoc.ContNum           = string(titulo.titnum)
                pdvdoc.titpar            = titulo.titpar
                pdvdoc.titdtven          = titulo.titdtven.
            ASSIGN
                pdvdoc.pago_parcial      = "N"
                pdvdoc.modcod            = titulo.modcod
                pdvdoc.Desconto_Tarifa   = 0
                pdvdoc.Valor_Encargo     = 0
                pdvdoc.hispaddesc        = "BAIXA ENTRADA ACORDO CYB " + string(cybacordo.idacordo)
                                         + " BOLETO " + string(banboleto.nossonumero) . /* ENTRADA */
                pdvdoc.valor             = titulo.titvlcob. /*par-titvlpag.*/
                pdvdoc.titvlcob          = titulo.titvlcob.
                pdvdoc.valor_encargo    = 0.
            if pdvdoc.valor_encargo < 0
            then do:
                    pdvdoc.desconto = pdvdoc.valor_encargo * -1.
                    pdvdoc.valor_encargo = 0.
            end.
            pdvdoc.pstatus = yes.
        end.
        else do: 
            titulo.titsit     = "LIB".
        
            if cybacparcela.parcela = origem-cybacparcela.parcela + 1
            then cybacparcela.situacao = "ENVIARBOLETO".
            else cybacparcela.Situacao = "E".
        end.            
    
        contrato.vltotal = contrato.vltotal + cybacparcela.vlCobrado.
        if cybacparcela.parcela = 0
        then contrato.vlentra = contrato.vlentra + cybacparcela.vlCobrado.
    end.

    for each cybacorigem of cybacordo /* #2 */ NO-LOCK.
        do vparc = 1 to num-entries(cybacorigem.ParcelasLista).
            /* #2 */
            if CybAcOrigem.etbcod = 0
            then vetbcod = cybacordo.etbcod.
            else vetbcod = CybAcOrigem.etbcod.
        
            find first titulo where
                titulo.empcod = 19 and
                titulo.titnat = no and
                titulo.modcod = CybAcOrigem.modcod /* #2 cybacordo */ and
                titulo.etbcod = vetbcod /* #2 cybacordo.etbcod */ and
                titulo.clifor = cybacordo.clifor and
                titulo.titnum = string(cybacorigem.contnum) and
                titulo.titpar = int(entry(vparc,cybacorigem.parcelasLista))
                exclusive no-error.
            if avail titulo
            then do.
                assign /* #2 */
                    titulo.titdtpag = par-titdtpag
                    titulo.titvlpag = titulo.titvlcob + par-titjuro /* #1 */ 
                        /*par-titvlpag*/ 
                    titulo.titjuro  = par-titjuro
                    titulo.titsit   = "PAG"
                    titulo.moecod   = pdvmov.ctmcod /* #H1 */
                    titulo.etbcobra = 999.
                find current titulo no-lock. /* #2 */

                vseq = vseq + 1.
                do on error undo, next.
                    
                    create pdvdoc.
                    ASSIGN
                        pdvdoc.etbcod            = pdvmov.etbcod
                        pdvdoc.cmocod            = pdvmov.cmocod
                        pdvdoc.DataMov           = pdvmov.DataMov
                        pdvdoc.Sequencia         = pdvmov.Sequencia
                        pdvdoc.ctmcod            = pdvmov.ctmcod
                        pdvdoc.COO               = pdvmov.COO
                        pdvdoc.seqreg            = par-seqreg + vseq
                        pdvdoc.CliFor            = titulo.CliFor
                        pdvdoc.ContNum           = string(titulo.titnum)
                        pdvdoc.titpar            = titulo.titpar
                        pdvdoc.titdtven          = titulo.titdtven.
                    ASSIGN
                        pdvdoc.pago_parcial      = "N"
                        pdvdoc.modcod            = titulo.modcod
                        pdvdoc.Desconto_Tarifa   = 0
                        pdvdoc.Valor_Encargo     = 0
                        pdvdoc.hispaddesc        = "BAIXA ORIGEM ACORDO CYB " + string(cybacordo.idacordo). /* PARCELAS ACORDO */
                        pdvdoc.valor             = titulo.titvlcob. 
                        pdvdoc.titvlcob          = titulo.titvlcob.
                        pdvdoc.valor_encargo    = 0.
                
                    if pdvdoc.valor_encargo < 0
                    then do:
                        pdvdoc.desconto = pdvdoc.valor_encargo * -1.
                        pdvdoc.valor_encargo = 0.
                    end.
                    pdvdoc.pstatus = yes.
                    
                    find cobra of titulo no-lock.
                    if cobra.sicred
                    then run /admcom/progr/fin/sicrepagam_create.p 
                                (recid(pdvdoc),
                                 int(pdvdoc.contnum), 
                                 pdvdoc.titpar,
                                 output psicred).
                    
                    find first tit_novacao where
                         tit_novacao.ori_empcod   = titulo.empcod and
                         tit_novacao.ori_titnat   = titulo.titnat and
                         tit_novacao.ori_modcod   = titulo.modcod and
                         tit_novacao.ori_etbcod   = titulo.etbcod and
                         tit_novacao.ori_clifor   = titulo.clifor and
                         tit_novacao.ori_titnum   = titulo.titnum and
                         tit_novacao.ori_titpar   = titulo.titpar and
                         tit_novacao.ori_titdtemi = titulo.titdtemi and
                         tit_novacao.tipo         = ""
                        exclusive no-error.
                    if not avail tit_novacao
                    then do:
                        create tit_novacao.
                        assign
                         tit_novacao.ori_empcod   = titulo.empcod
                         tit_novacao.ori_titnat   = titulo.titnat
                         tit_novacao.ori_modcod   = titulo.modcod
                         tit_novacao.ori_etbcod   = titulo.etbcod
                         tit_novacao.ori_clifor   = titulo.clifor
                         tit_novacao.ori_titnum   = titulo.titnum
                         tit_novacao.ori_titpar   = titulo.titpar
                         tit_novacao.ori_titdtemi = titulo.titdtemi
                         tit_novacao.ori_titvlcob = titulo.titvlcob
                         tit_novacao.ori_titdtven = titulo.titdtven.
                         tit_novacao.id_acordo    = ?.
                    end.                         
                    
                    assign
                         tit_novacao.tipo         = "RENEGOCIACAO"
                         tit_novacao.ger_contnum  = contrato.contnum
                         tit_novacao.ori_titdtpag = titulo.titdtpag
                         tit_novacao.ori_titdtpag = pdvmov.datamov
                         tit_novacao.dtnovacao    = pdvmov.datamov
                         tit_novacao.hrnovacao    = pdvmov.horamov
                         tit_novacao.etbnovacao   = pdvmov.etbcod
                         tit_novacao.funcod       = int(pdvmov.codigo_operador)
                         tit_novacao.datexp       = today
                         tit_novacao.exportado    = no.
                end.
                
                contrato.vlf_principal = contrato.vlf_principal +
                                        titulo.titvlcob.
                     
            end.
        end.
    end.
    do on error undo.
        contrato.vlf_acrescimo = contrato.vltotal -
                                contrato.vlf_principal.
        find current cybacordo exclusive.
        assign
            cybacordo.situacao = "E"
            cybacordo.dtefetiva = today. 
        par-ok = yes.
    end.
end.


