
def var vetbcod as int.
def var vprocod as int.

vetbcod = 188.
vprocod = 40.

{../verus/rest-cli/wc-consultaestoque.i new}

run ../verus/rest-cli/wc-consultaestoque.p (vetbcod, vprocod).

find first ttestoque no-error.
if not avail ttestoque
then do:
    find first ttretorno no-error.
    if avail ttretorno
    then do:
        hide message no-pause.
        message "rest-cli barramento consultaestoque" ttretorno.tstatus ttretorno.descricao.
        pause 2 no-message.
    end.
end.
