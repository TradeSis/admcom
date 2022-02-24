display program-name(1) format "x(30)" skip
        program-name(2) format "x(30)" skip
        program-name(3) format "x(30)" skip
        program-name(4) format "x(30)" skip
        skip.
        
        
if program-name(2) matches("*tstlaureano*")
        then message "Ok".
        else message "notOk...".
