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

def stream csvparcela.
output stream csvparcela to ../tmp/lidia_parcelas_2.csv.
put stream csvparcela unformatted skip 
    "CPFCNPJ"
vcp "CODIGOCLIENTE"
vcp "CODIGOLOJA"
vcp "NUMEROCONTRATO"
vcp "SEQUENCIAL"
vcp "VALORPARCELA"
vcp "DATAVENCIMENTO"
vcp "DATAEMISSAO"
vcp "CODIGOCOBRANCA"
vcp "VALORPRINCIPAL"
vcp "VALORFINANCEIROACRESCIMO"
vcp "VALORSEGURO"
vcp "SITUACAO"
vcp "SALDO"
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
        message "parcelas" today string(time,"HH:MM:SS") string(time - xtime,"HH:MM:SS") vt vi.
    end.
    vcpf = ?.
            if vcpf = ?
            then do:
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
            end.
    
    for each titulo where titulo.titnat = no and titulo.empcod = 19 and
            titulo.modcod = contrato.modcod and titulo.etbcod = contrato.etbcod and
            titulo.clifor = contrato.clicod and titulo.titnum = string(contrato.contnum)
            no-lock
            by titulo.titpar.
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
        
        if (titulo.titsit = "LIB" and contrato.dtinicial < 01/01/2016) or 
            contrato.dtinicial >= 01/01/2016 
        then do: 
            if titulo.titsit = "LIB"
            then vvlr_aberto = titulo.titvlcob.
            put stream csvparcela
                unformatted  
                        vcpf
                     vcp contrato.clicod
                     vcp contrato.etbcod
                     vcp contrato.contnum
                    vcp titulo.titpar
                    vcp trim(string(titulo.titvlcob,"->>>>>>>>>>>>>>>>>>>>>>>>>>9.99")) 
                    vcp  (string(year(titulo.titdtven),"9999") + "-" + 
                          string(month(titulo.titdtven),"99")   + "-" + 
                          string(day(titulo.titdtven),"99"))
                    
                    vcp  (string(year(contrato.dtinicial),"9999") + "-" + 
                          string(month(contrato.dtinicial),"99")   + "-" + 
                          string(day(contrato.dtinicial),"99"))
                    
                    vcp titulo.cobcod
                    vcp trim(string(titulo.titvlcob,"->>>>>>>>>>>>>>>>>>>>>>>>>>9.99"))
                    vcp trim(string(titulo.vlf_acrescimo,"->>>>>>>>>>>>>>>>>>>>>>>>>>9.99"))
                    vcp trim(string(titulo.titdesc,"->>>>>>>>>>>>>>>>>>>>>>>>>>9.99"))
                    vcp titulo.titsit
                    vcp trim(string(vvlr_aberto,"->>>>>>>>>>>>>>>>>>>>>>>>>>9.99"))
                    skip.
            
        end.
    end.

end.            


