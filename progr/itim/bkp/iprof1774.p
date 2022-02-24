

def temp-table tt_Prof_1774
    like Prof_1774.
    
def var v as int.
def var par-arq as char.
update par-arq.
input from value(par-arq).
repeat.
    create tt_Prof_1774.
    import delimiter "|" tt_Prof_1774.
    v = v + 1.
end.

for each tt_Prof_1774.
    find first Prof_1774 where Prof_1774.PZ_GROUP_ID = tt_Prof_1774.PZ_GROUP_ID
        no-lock no-error.
    
    if not avail Prof_1774
    then do:
        create Prof_1774.
        buffer-copy tt_Prof_1774 to Prof_1774.
    end.
    delete tt_Prof_1774.
end.