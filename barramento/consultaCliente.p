
DEFINE INPUT PARAMETER v-longJson 		AS LONGCHAR.
DEFINE OUTPUT PARAMETER v-longJsonSaida 		AS LONGCHAR.

DEFINE VARIABLE lOK 			AS LOGICAL.
DEFINE VARIABLE lRetOK    AS LOGICAL.
DEFINE VARIABLE hdsOrderLog 	AS handle  NO-UNDO.

DEFINE TEMP-TABLE tt-cliente NO-UNDO SERIALIZE-NAME "cliente"
    FIELD clicod as int
    FIELD clinom as char
    INDEX icliente IS UNIQUE PRIMARY clicod ASC.

CREATE tt-cliente.
tt-cliente.clicod = 0. tt-cliente.clinom = "TESTE LOAD INICIAL".

DEFINE DATASET conteudo FOR tt-cliente.



hdsOrderLog = DATASET conteudo:HANDLE.
lOK = hdsOrderLog:READ-JSON("longchar", v-longJson, "EMPTY").

OUTPUT TO /admcom/barramento/sockServer3.js APPEND.
  PUT UNFORMATTED " " SKIP.
  PUT UNFORMATTED "CLICOD" + "|" + "CLINOM" SKIP.
  FOR EACH tt-cliente by clicod:

    find first clien where clien.clicod = tt-cliente.clicod no-lock no-error.
      if avail clien then do:
        UPDATE tt-cliente.clinom = clien.clinom.
      end.
      else do:
        UPDATE tt-cliente.clinom = "NAO LOCALIZADO".
      end.

    PUT UNFORMATTED STRING(tt-cliente.clicod) + "|" + tt-cliente.clinom FORMAT "x(50)" SKIP.

  END.
OUTPUT CLOSE.

ASSIGN
      lRetOK =  hdsOrderLog:WRITE-JSON("LONGCHAR", v-longJsonSaida, true).
