def var vt as int.
def var vi as int.
def var xtime as int.

def var vcp as char init ";".
def var vvlr_aberto as dec.
def var vfinanceira as log.
def var vdt_primvenc as date.
def var vqtd_parcelas as int.
def var vtpcontrato as char.
def var vcpf as char.

xtime = time.

def stream csvcontrato.
output stream csvcontrato to ../tmp/lidia_contratos_2.csv.
put stream csvcontrato unformatted skip 
 "CPFCNPJ" 
 vcp "CODIGOCLIENTE" 
 vcp "CODIGOLOJA" 
 vcp "NUMEROCONTRATO" 
 vcp "DATAINICIAL" 
 vcp "VALORTOTAL" 
 vcp "PLANOCREDITO" 
 vcp "CONTRATOFINANCEIRA"
 vcp "TIPOOPERACAO"
 vcp "DATAEFETIVACAO"
 vcp "VALORENTRADA"
 vcp "PRIMEIROVENCIMENTO"
 vcp "QTDPARCELAS"
 vcp "TAXAMES"
 vcp "VALORACRESCIMO"
 vcp "VALORIOF"
 vcp "VALORTFC"
 vcp "TAXACETANO"
 vcp "TAXACET"
 vcp "TIPOCONTRATO"
 vcp "VALORPRINCIPAL"
 vcp "MODALIDADE"
 vcp "CODIGOEMPRESA"
 vcp "VALORSEGURO"
 skip.
 
/*  Todos emitidos a partir de 2016 ou com alguma parcela em aberto  */

for each contrato  no-lock
    by contrato.contnum.

    if contrato.contnum < 99492201 
    then next.
    
    vvlr_aberto = 0.
    vfinanceira = no.
    vdt_primvenc = ?.
    vqtd_parcelas = 0.
    vtpcontrato = "".
    vt = vt + 1.    
    if vt mod 1000 = 0 or vt = 1
    then do:
        hide message no-pause.
        message "contratos" today string(time,"HH:MM:SS") string(time - xtime,"HH:MM:SS") vt vi.
    end.
    for each titulo where titulo.titnat = no and titulo.empcod = 19 and
            titulo.modcod = contrato.modcod and titulo.etbcod = contrato.etbcod and
            titulo.clifor = contrato.clicod and titulo.titnum = string(contrato.contnum)
            no-lock.
        if titulo.titpar > 0
        then do:
            vdt_primvenc = if vdt_primvenc = ? then titulo.titdtven else min(vdt_primvenc,titulo.titdtven).
            vqtd_parcelas = vqtd_parcelas + 1.
            if vtpcontrato = "" and titulo.tpcontrato <> ""
            then vtpcontrato = titulo.tpcontrato.
            find cobra of titulo no-lock.
            if cobra.sicred
            then vfinanceira  = yes.
        end.    
        else next. 
        if titulo.titsit = "LIB"
        then do: 
            find cobra of titulo no-lock.
            if cobra.sicred
            then vfinanceira  = yes.
            vvlr_aberto = vvlr_aberto + titulo.titvlcob.
        end.
    end.
    if (contrato.dtinicial < 01/01/2016 and vvlr_aberto > 0 ) or
        contrato.dtinicial >= 01/01/2016
    then do:
        vi = vi + 1.
        vcpf = ?.
        find neuclien where neuclien.clicod = contrato.clicod no-lock no-error.
        if avail neuclien then do:
            vcpf = trim(string(neuclien.cpf,">>>>>>>>>>>>>>>")).
        end.
        if vcpf = ?
        then do:
            find clien where clien.clicod = contrato.clicod no-lock no-error.
            if avail clien
            then do:
                vcpf = clien.ciccgc.
            end.    
        end.
        if vcpf = ?
        then vcpf = "".
        
        put stream csvcontrato unformatted skip 
             vcpf
         vcp contrato.clicod
         vcp contrato.etbcod
         vcp contrato.contnum
         vcp  (string(year(contrato.dtinicial),"9999") + "-" + string(month(contrato.dtinicial),"99")   + "-" + string(day(contrato.dtinicial),"99"))
         
         vcp trim(string(contrato.vltotal,"->>>>>>>>>>>>>>>>>>>>>>>>>>9.99")) 
         vcp contrato.crecod
         vcp string(vfinanceira,"SIM/NAO")
         vcp ""
         vcp  (string(year(contrato.dtinicial),"9999") + "-" + string(month(contrato.dtinicial),"99")   + "-" + string(day(contrato.dtinicial),"99"))
         
         vcp trim(string(contrato.vlentra ,"->>>>>>>>>>>>>>>>>>>>>>>>>>9.99"))
         vcp  (string(year(vdt_primvenc),"9999") + "-" + string(month(vdt_primvenc),"99")   + "-" + string(day(vdt_primvenc),"99"))
         vcp vqtd_parcelas
         vcp trim(string(contrato.txjuros,"->>>>>>>>>>>>>>>>>>>>>>>>>>9.99"))
         vcp trim(string(contrato.vlf_acrescimo,"->>>>>>>>>>>>>>>>>>>>>>>>>>9.99"))
         vcp trim(string(contrato.vliof,"->>>>>>>>>>>>>>>>>>>>>>>>>>9.99"))
         vcp trim(string(contrato.vltaxa,"->>>>>>>>>>>>>>>>>>>>>>>>>>9.99"))
         vcp trim(string(contrato.cet,"->>>>>>>>>>>>>>>>>>>>>>>>>>9.99"))
         vcp trim(string(contrato.cet,"->>>>>>>>>>>>>>>>>>>>>>>>>>9.99"))
         vcp vtpcontrato
         vcp trim(string(contrato.vlf_principal,"->>>>>>>>>>>>>>>>>>>>>>>>>>9.99"))
         vcp contrato.modcod
         vcp 19
         vcp trim(string(contrato.vlseguro,"->>>>>>>>>>>>>>>>>>>>>>>>>>9.99"))
         skip.
    end.
end.            


