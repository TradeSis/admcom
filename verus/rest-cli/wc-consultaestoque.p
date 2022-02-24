def input parameter p-etbcod    as int.
def input parameter p-procod    as int.
    
def var vcJSON as longchar.
/***
vcjson = "\{
    \"consultaEstoqueEntrada\": \{
            \"codigoEstabelecimento\": \"" + string(p-etbcod) + "\",
                    \"codigoProduto\": \"" + string(p-procod) + "\"
                        \}
                        \}".
message string(vcjson) view-as alert-box.
***/

def var vcMetodo as char.
def var vLCEntrada as longchar.
def var vLCSaida   as longchar.
def var vcsaida    as char.

vcMetodo = "consultaEstoqueRestResource".

DEFINE VARIABLE lokJSON                  AS LOGICAL.
def var hconsultaEstoqueEntrada          as handle.
def var hconsultaEstoqueSaida            as handle.
def var hretorno                         as handle.

/* ENTRADA */
DEFINE TEMP-TABLE ttentrada NO-UNDO SERIALIZE-NAME "consultaEstoqueEntrada"
    field codigoEstabelecimento as char 
    field codigoProduto as char.
hconsultaEstoqueEntrada = TEMP-TABLE ttentrada:HANDLE.

{../verus/rest-cli/wc-consultaestoque.i}


    
DEFINE DATASET consultaEstoqueSaida FOR ttestoque.
hconsultaEstoqueSaida = DATASET consultaestoqueSaida:HANDLE.

DEFINE DATASET dsretorno SERIALIZE-NAME "consultaEstoqueSaida"
    FOR ttretorno.
hretorno = DATASET dsretorno:HANDLE.




create ttentrada.
ttentrada.codigoEstabelecimento = if p-etbcod = 0
                                  then "*"
                                  else string(p-etbcod).
ttentrada.codigoProduto         = string(p-procod).


lokJSON = hconsultaEstoqueEntrada:WRITE-JSON("longchar",vLCEntrada, TRUE).

/**
vlcEntrada = vcJSON.
***/

run ../verus/rest-cli/rest-barramento.p 
                 ( input  vcMetodo, 
                   input  vLCEntrada,  
                   output vLCSaida).

lokJSON = hconsultaEstoqueSaida:READ-JSON("longchar",vLCSaida, "EMPTY").

find first ttestoque no-error.
if not avail ttestoque
then do:
    vcsaida  = string(vLCSaida).
    vcSaida  = replace(vcsaida,"\"estoque\":[],",""). 
    vcSaida  = replace(vcsaida,"\"statusRetorno\":","\"statusRetorno\":[").
    vcSaida  = replace(vcsaida,"\}\}\}","\}]\}\}").
    vlcsaida = vcSaida.
    
    hretorno:READ-JSON("longchar",vLCSaida, "EMPTY").
    
    /*
    find first ttretorno no-error.
    if avail ttretorno
    then do:
        hide message no-pause.
        message ttretorno.descricao.
        pause 1 no-message.
    end.
    */
end.

/*
output to hsv.sai.
 put unformatted string(vlcSaida).
 output close.
*/

 
