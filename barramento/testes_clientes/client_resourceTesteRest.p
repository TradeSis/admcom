def var lcParamEntrada as LongChar.
def var lcParamRetorno as LongChar.

def var lOk             as log.

DEFINE TEMP-TABLE ttEntrada NO-UNDO SERIALIZE-NAME "testeRestEntrada" 
    FIELD numero1 AS CHAR
    field numero2 as char.

DEFINE DATASET DSEntrada 
        FOR ttEntrada .


DEFINE TEMP-TABLE ttRetorno NO-UNDO SERIALIZE-NAME "testeRestSaida"
    FIELD resultadoDaSoma AS CHARACTER.
DEFINE DATASET DSRetorno serialize-name "conteudoSaida"
    FOR ttRetorno.

def var bcust as handle.

CREATE ttEntrada.
ttEntrada.numero1 = "2".
ttEntrada.numero2 = "3".


bcust = TEMP-TABLE ttEntrada:DEFAULT-BUFFER-HANDLE.
lok =  bcust:WRITE-JSON("LONGCHAR",  
            lcParamEntrada,  
            true).
def var vxml as char.
vxml = replace(string(lcParamEntrada),"[","").
vxml = replace(vxml,"]","").


/*
lok =  DATASET DSEntrada:HANDLE:WRITE-JSON("LONGCHAR",  
            lcParamEntrada,  
            true).
  */
run ./wsh2.p (input  vxml /*lcParamEntrada*/ , output lcParamRetorno).
/*
run ../barramento/socketclient.p ("PASSOSROBERTO",
                            input  ttEntrada.metodo,
                            input  lcParamEntrada,
                            output lcParamRetorno).
*/

/*lOK = DATASET DSRetorno:READ-JSON("longchar", 
                             lcParamRetorno, 
                             "EMPTY").
  */
  
bcust = TEMP-TABLE ttRetorno:DEFAULT-BUFFER-HANDLE.

message "RETORNO =" string(lcParamRetorno) view-as alert-box.
  
lOK = bcust:READ-JSON("longchar", 
                             lcParamRetorno, 
                             "EMPTY").

for each ttRetorno.
    disp ttretorno.
end.    
message string(lcParamRetorno)
    view-as alert-box.       