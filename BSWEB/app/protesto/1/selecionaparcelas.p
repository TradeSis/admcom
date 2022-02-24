
def input  parameter vlcentrada as longchar.

def var vlcsaida   as longchar.
def var vsaida as char.

DEFINE VARIABLE lokJSON                  AS LOGICAL.
def var hEntrada     as handle.
def var hSAIDA            as handle.

{/admcom/progr/iep/tfilsel.i new}


hentrada = temp-table ttfiltros:HANDLE.

lokJSON = hentrada:READ-JSON("longchar",vlcentrada, "EMPTY").

hsaida = TEMP-TABLE ttparcela:HANDLE.

def var vsel as dec.
def var vabe as dec.
def var poperacao as char.
poperacao = "IEPRO".



run /admcom/progr/iep/pselecionaparcelas.p (input poperacao, input-output vsel , input-output vabe, no).


/* 
    lokJson = hsaida:WRITE-JSON("LONGCHAR", vlcSaida, TRUE).
*/
    lokJson = hsaida:WRITE-JSON("FILE", "saida.json", TRUE).

    os-command silent cat saida.json.
    
/*put unformatted string(vlcsaida).*/
/* 
message string(vlcsaida).
*/
