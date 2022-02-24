

def temp-table tt_Prof_1771
    like Prof_1771.
    
def var v as int.
def var par-arq as char.
update par-arq.
input from value(par-arq).
repeat.
    create tt_Prof_1771.
    import delimiter "|" tt_Prof_1771.
    v = v + 1.
end.

for each tt_Prof_1771.
    find first Prof_1771 where Prof_1771.STORE_ID = tt_Prof_1771.STORE_ID
        no-lock no-error.
    
    if not avail Prof_1771
    then do:
        create Prof_1771.
        buffer-copy tt_Prof_1771 to Prof_1771.
    end.
    delete tt_Prof_1771.
end.