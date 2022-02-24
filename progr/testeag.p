/*def input parameter p-etbcod as int.  */
def var vfilial as char.

repeat:
        
    pause 1 no-message.
    vfilial = SESSION:PARAMETER.

    output to /tmp/testeag.log append.
        put "Filial:" vfilial skip.
    output close.
        
end.    
