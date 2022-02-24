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
def var vsequencialmovim as int.

xtime = time.
pause.
def stream csvmovimento.
output stream csvmovimento to ../tmp/lidia_movimento2.csv.
put stream csvmovimento unformatted skip 
 "CPFCNPJ"
vcp "CODIGOCLIENTE"
vcp "CODIGOLOJA"
vcp "NUMEROCONTRATO"
vcp "SEQUENCIAL"
vcp "DATAHORABAIXA"
vcp "SEQUENCIALMOVIM"
vcp "CODIGOLOJAMOVIM"
vcp "TIPOBAIXA"
vcp "VALORBAIXAPRINCIPAL"
vcp "VALORBAIXAJUROSATRASO"
vcp "VALORBAIXATOTAL"
skip.



 
/*  Todos emitidos a partir de 2016 ou com alguma parcela em aberto  */

for each contrato  no-lock
            by contrato.contnum.
    if contrato.dtinicial < 01/01/2016 then next.
    if contrato.contnum < 304288522
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
            
            vsequencialmovim = 0.            
            for each pdvdoc where pdvdoc.contnum = titulo.titnum and
                                  pdvdoc.titpar = titulo.titpar and 
                                  pdvdoc.pstatus = yes 
                                  no-lock:
                find pdvmov of pdvdoc                      no-lock no-error.
                if not avail pdvmov then next.

                vsequencialmovim = vsequencialmovim + 1.                                                                            
                put stream csvmovimento
                    unformatted  
                     vcpf
                     vcp contrato.clicod
                     vcp contrato.etbcod
                     vcp contrato.contnum
                    vcp titulo.titpar
                    vcp  string(year(pdvmov.datamov),"9999") + "-" + 
                         string(month(pdvmov.datamov),"99")   + "-" + 
                         string(day(pdvmov.datamov),"99") + " " +
                         string(pdvmov.horamov,"HH:MM:SS")
                    vcp string(vsequencialmovim)
                    vcp string(pdvdoc.etbcod)   
                    vcp pdvdoc.ctmcod
                    vcp trim(string(pdvdoc.titvlcob,"->>>>>>>>>>>>>9.99"))
                    vcp trim(string(pdvdoc.valor_encargo,"->>>>>>>>>>>>>9.99"))
                    vcp trim(string(pdvdoc.valor,"->>>>>>>>>>>>>9.99"))
                    skip.
            end.  
        end.
    end.

end.            


