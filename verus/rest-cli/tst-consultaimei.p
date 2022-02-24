
def var vetbcod as int.
def var vimei as char.

vetbcod = 189.
vimei = "999992193129391291232".

{../verus/rest-cli/wc-consultaimei.i new}

run ../verus/rest-cli/wc-consultaimei.p (vetbcod, vimei).

find first ttimei no-error.
if not avail ttimei
then do:
    find first ttretornoimei no-error.
    if avail ttretornoimei
    then do:
        hide message no-pause.
        message "rest-cli barramento consultaimei" ttretornoimei.tstatus ttretornoimei.descricao.
        pause 2 no-message.
    end.
end.
else do:
    disp ttimei.
end.

