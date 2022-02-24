
def var lcParamEntrada as LongChar.
def var lcParamRetorno as LongChar.

{/admcom/barramento/metodos/bonusCrm.i}
    
/* GRAVA PRAMETROS DE ENTRADA */
create ttbonusCrmEntrada.
ttbonusCrmEntrada.codigocliente = "9652".
ttbonusCrmEntrada.codigoloja = "188".
ttbonusCrmEntrada.dataEmisao = "2020-03-04".
ttbonusCrmEntrada.descricao = "VIVO CONTROLE DIGITAL - 5GB - R$89.99".
ttbonusCrmEntrada.valor = "400".

hbonusCrmEntrada:WRITE-JSON("LONGCHAR",   lcParamEntrada,   true).


run ../barramento/socketclient.p ("PASSOSROBERTO",
                            input  "bonusCrm",
                            input  lcParamEntrada,
                            output lcParamRetorno).

lokJSON = hbonusCrmSaida:READ-JSON("longchar", 
                                         lcParamRetorno, 
                                         "EMPTY") no-error.
for each ttbonus.
    disp ttbonus.
end.    
