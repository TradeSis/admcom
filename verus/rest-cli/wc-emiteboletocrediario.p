    
def var vcJSON as longchar.

def var vcMetodo as char.
def var vLCEntrada as longchar.
def var vLCSaida   as longchar.
def var vcsaida    as char.

vcMetodo = "/gateway/LebesCrediarioDigital/1.0/resourceEmiteBoletoPagtoParcelaCrediario".
vcmetodo = "/restv2/emiteBoletoPagtoParcelaCrediarioResource".

DEFINE VARIABLE lokJSON                  AS LOGICAL.
def var hemiteboletocrediarioEntrada          as handle.
def var hemiteboletocrediarioSaida            as handle.
def var hretorno                         as handle.

{../verus/rest-cli/wc-emiteboletocrediario.i}

hemiteboletocrediarioEntrada            = DATASET emiteBoletoEntrada:HANDLE.
    

hemiteboletocrediarioSaida  = DATASET emiteBoletoSaida:HANDLE.

lokJSON = hemiteboletocrediarioEntrada:WRITE-JSON("longchar",vLCEntrada, TRUE).

/*
lokJSON = hemiteboletocrediarioEntrada:WRITE-JSON("file","boletoentrada.json", TRUE).
*/

/**
vlcEntrada = vcJSON.
***/

run ../verus/rest-cli/rest-barramento.p 
                 ( input  vcMetodo, 
                   input  vLCEntrada,  
                   output vLCSaida).

lokJSON = hemiteboletocrediarioSaida:READ-JSON("longchar",vLCSaida, "EMPTY").


/*
output to hsv.sai.
 put unformatted string(vlcSaida).
 output close.
*/

 
