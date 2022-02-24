
def temp-table tt_Prof_1703
    like Prof_1703.
    
def var v as int.
def var par-arq as char.
update par-arq.
input from value(par-arq).
repeat.
    create tt_Prof_1703.
    import delimiter "|" tt_Prof_1703.
    v = v + 1.
end.

for each tt_Prof_1703.
    find first Prof_1703 
        where Prof_1703.OFFER_ID = tt_Prof_1703.OFFER_ID
        no-lock no-error.
    
    if not avail Prof_1703
    then do:
        create Prof_1703.
        buffer-copy tt_Prof_1703 to Prof_1703.
    end.
    delete tt_Prof_1703.
end.