def var vcpf as char.
vcpf = "1513".
def var lcParamEntrada as LongChar.
def var lcParamRetorno as LongChar.

{/admcom/barramento/metodos/buscaComportamento.i}
    
/* GRAVA PRAMETROS DE ENTRADA */
create ttComportamentoEntrada.
ttComportamentoEntrada.cpfCNPJ = vcpf.

hcomportamentoEntrada:WRITE-JSON("LONGCHAR",   lcParamEntrada,   true).


run ../barramento/socketclient.p ("PASSOSROBERTO",
                            input  "buscaComportamento",
                            input  lcParamEntrada,
                            output lcParamRetorno).

lokJSON = hcomportamentoCliente:READ-JSON("longchar", 
                                         lcParamRetorno, 
                                         "EMPTY") no-error.

hcomportamentoCliente:WRITE-JSON("FILE","client_comportamentoCliente.json", true).

for each ttclien.
    disp ttclien.
    for each ttcredito of ttclien.
        disp ttcredito.
    end.
    for each ttmodalcomportamento of ttclien.
        disp ttmodalcomportamento.
    end.
    for each ttcomportamento of ttclien.
        disp ttcomportamento except ttcomportamento.clicod.
    end.    
end.    
