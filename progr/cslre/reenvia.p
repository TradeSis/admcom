def var p-etbcod as int.
p-etbcod = int(entry(1,SESSION:PARAMETER)) no-error.

find estab where estab.etbcod = p-etbcod no-lock no-error.


if not avail estab
then do:
    message "Loja Invalida" p-etbcod.
    return.
    
end.
def var vpropath as char.

input from /admcom/linux/propath no-echo.  /* Seta Propath */
import vpropath.
input close.
propath = vpropath + ",\dlc".

message " CSLOG - REENVIO - LOJA " p-etbcod
today 
        "INICIO:" string(time,"HH:MM:SS").


run /admcom/helio/cslre/gera_lote_v4.p (today, p-etbcod).




