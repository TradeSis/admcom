{admcab.i new}
setbcod = 188.
sfuncod = 100.
def var vprocod     AS INT.
def var vvalorproduto as dec.
def var vvalordesconto  as dec.

{../verus/rest-cli/wc-consultamargemdesconto.i new}

vprocod = 211.
vvalorproduto = 600.
vvalordesconto = 20.

message setbcod sfuncod.

create ttconsultamargemdescontoEntrada.
ttconsultamargemdescontoEntrada.codigoLoja      = string(setbcod).
ttconsultamargemdescontoEntrada.codigoProduto   = string(vprocod).
ttconsultamargemdescontoEntrada.valorProduto     = string(vvalorproduto).
ttconsultamargemdescontoEntrada.valorDescontoSolicitado = string(vvalordesconto).
ttconsultamargemdescontoEntrada.codigoOperador  = string(sfuncod).


run ../verus/rest-cli/wc-consultamargemdesconto.p.

find first ttmargemdesconto no-error.
if not avail ttmargemdesconto
then do:
    find first ttretornomargemdesconto no-error.
    if avail ttretornomargemdesconto
    then do:
        hide message no-pause.
        message "rest-cli barramento consultamargemdesconto" ttretornomargemdesconto.tstatus ttretornomargemdesconto.descricao.
        pause 2 no-message.
    end.
end.
else do:
    for each ttmargemdescontoproduto.
        disp ttmargemdescontoproduto.
    end.
    for each ttmargemdesconto.
        disp ttmargemdesconto.
    end.        
end.

