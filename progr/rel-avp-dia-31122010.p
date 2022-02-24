{admcab.i}

def temp-table seq-mes 
    field ano as int
    field mes as int
    field seq as int
    field avpdia as dec
    field vencido as dec
    field avencer as dec
    index i1 ano mes.
 
def var v-vtotal as dec.
def var v-vencido as dec.
def var v-vencer as dec.
def var val-avpdia as dec.

def var vdatref as date format "99/99/9999".
def var vdata as date.
def var vseq as int.

vdatref = 12/31/2010.

disp vdatref label "Data referencia"
    with frame f-dtrf 1 down side-label width 80.
pause 0.

def buffer titsalctb for SC2010.
    
def var vmes as int format "99".
def var vano as int format "9999".
def var vindex as int.

run tipo-rel.
if sresp = no then return.

def temp-table tt-tit
    field clifor like fin.titulo.clifor
    field titnum like fin.titulo.titnum
    field titdtemi like fin.titulo.titdtemi
    field titdtven like fin.titulo.titdtven
    field titvlcob like fin.titulo.titvlcob
    field valoravp as dec format ">>>,>>>,>>9.99"
    field valoraju as dec format ">>>,>>>,>>9.99"
    field taxajuro as dec decimals 4 format ">>9.9999"
    index i1 clifor.
    
def stream stela.
def var vtot as dec format ">>>>>>>>9".
form "Aguarde processamento ..." vtot
     "registros processados"
     with frame f-tot 1 down no-label color message width 80 no-box.
     

do vdata = vdatref + 1 to vdatref + 3600:
    find first seq-mes where
               seq-mes.ano = year(vdata) and
               seq-mes.mes = month(vdata)
               no-error.
    if not avail seq-mes
    then do:
        create seq-mes.
        assign
            seq-mes.ano = year(vdata)
            seq-mes.mes = month(vdata)
            vseq = vseq + 1
            seq-mes.seq = vseq
            .
    end.           
end.

def var vi as int.
def var vb as dec.
def var va as dec.


def var varq as char.
varq = "/admcom/relat/saldo-clientes-avp-dia"
        + string(vdatref,"99999999") 
        + "-" + string(vmes,"99")
        + "-" + string(vano,"9999")
        + ".txt"
        .
output stream stela to terminal.
output to value(varq).
for each titsalctb where 
             titsalctb.titdtemi <= vdatref and
             (titsit = "LIB" or  titdtpag > vdatref)
              no-lock.

    if vmes > 0 and vmes <> month(titsalctb.titdtven)
    then next.
    if vano > 0 and vano <> year(titsalctb.titdtven)
    then next.

    vtot = vtot + 1.
    if vtot mod 1000 = 0
    then do:
    disp stream stela vtot with frame f-tot.
    pause 0.
    end. 
        
    /*
    create tt-tit.
    assign
        tt-tit.clifor = titsalctb.clifor
        tt-tit.titnum = titsalctb.titnum
        tt-tit.titdtemi = titsalctb.titdtemi
        tt-tit.titdtven = titsalctb.titdtven
        tt-tit.titvlcob = titsalctb.titvlcob
        tt-tit.valoravp = titsalctb.valavpdia
        tt-tit.valoraju = titsalctb.titvlcob - titsalctb.valavpdia
        tt-tit.taxajuro = titsalctb.pctavp[1]
        .
    */
    
    find clien where clien.clicod = titsalctb.clifor no-lock no-error.
    disp titsalctb.clifor column-label "Codigo" format ">>>>>>>>>9"
         clien.clinom     column-label "Nome"   format "x(40)"
         clien.ciccgc     column-label "CPF"    format "x(16)"
         titsalctb.titnum column-label "Documento"  format "x(15)"
         titsalctb.titdtemi column-label "Emissao"
         titsalctb.titdtven column-label "Vencimento"
         titsalctb.titvlcob(total) column-label "Valor!Original"
         titsalctb.titvlcob - titsalctb.valavpdia(total) 
            format ">>>,>>9.99" column-label "Valor!Ajuste"
         titsalctb.pctavp[1] column-label "Taxa!Juro"
         with frame f-disp down width 200.
    down with frame f-disp.     

end.
output close.
output stream stela close.

unix silent unix2dos value(varq).

message color red/with
    "Arquivo gerado:" skip
    varq
    view-as alert-box.
    
/*
run visurel.p(varq, "").
*/

procedure tipo-rel:

    def var v-esc as char extent 2  format "x(15)"
        init["Sintetico","Analitico"]
        .
    disp v-esc with frame f-esc 1 down
        side-label no-label centered.
    choose field v-esc with frame f-esc.
    vindex = frame-index.
    
    if vindex = 2
    then do:
    
        vano = year(vdatref) + 1.
        update vmes label "Mes"
               vano label "Ano"
               with frame f-ma side-label
               . 
        sresp = no.
        message "Confirme gerar relatorio " v-esc[vindex] "?" update sresp.
    end.        
    else do:
        sresp = no.
        message "Confirme gerar relatorio " v-esc[vindex] "?" update sresp.
    end.
end procedure.    
