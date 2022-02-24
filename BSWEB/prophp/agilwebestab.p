def var vdata       as date.
def var vetbcod     as int.
def var vi          as int.
def var vi2         as int.
def var vdias      as int init 30.

vetbcod = int(os-getenv("estab")).
find estab where estab.etbcod = vetbcod no-lock no-error.
if not avail estab
then do:
    put unformatted "NAOEXISTE".
    quit.
end.

def temp-table tttipmov
    field movtdc like tipmov.movtdc
    index movtdc is primary unique movtdc.

for each tttipmov.
    delete tttipmov.
end.
for each tipmov where tipmov.movttra no-lock.
    create tttipmov.
    assign tttipmov.movtdc = tipmov.movtdc.
end.
find opcom 45 no-lock no-error.
if avail opcom
then do.
    create tttipmov.
    assign tttipmov.movtdc = opcom.movtdc. 
end.
find opcom 6 no-lock no-error.
if avail opcom
then do.
    create tttipmov.
    assign tttipmov.movtdc = opcom.movtdc. 
end.


vi = 0.
for each tttipmov no-lock,
/*    tipmov where tipmov.movttra no-lock.*/
    tipmov where tipmov.movtdc = tttipmov.movtdc no-lock.
    do vdata = today - vdias to today.
        for each plani where plani.desti  = estab.clfcod
                         and plani.movtdc = tipmov.movtdc
                         and plani.dtincl = vdata
                         and plani.notsit = "F"
                       no-lock.
            vi = vi + 1.
            for each movim of plani no-lock.
                vi2 = vi2 + 1.
            end.
        end.
        for each plani where plani.desti  = estab.clfcod
                         and plani.movtdc = tipmov.movtdc
                         and plani.dtincl = vdata
                         and plani.notsit = "C"
                       no-lock.
            vi = vi + 1.
            for each movim of plani no-lock.
                vi2 = vi2 + 1.
            end.
        end.
    end.
end.

if vi > 0
then do.
    put unformatted skip "#plani," + string(vi) skip.
    for each tttipmov no-lock,
        tipmov where tipmov.movtdc = tttipmov.movtdc no-lock.

        do vdata = today - vdias to today.
            for each plani where plani.desti  = estab.clfcod
                             and plani.movtdc = tipmov.movtdc
                             and plani.dtincl = vdata
                             and plani.notsit = "F"
                           no-lock.
                export plani.
            end.
            for each plani where plani.desti  = estab.clfcod
                             and plani.movtdc = tipmov.movtdc
                             and plani.dtincl = vdata
                             and plani.notsit = "C"
                           no-lock.               
                export plani.
            end.
            
        end.
    end.

    put unformatted skip "#movim," + string(vi2) skip.
    for each tttipmov no-lock,
        tipmov where tipmov.movtdc = tttipmov.movtdc no-lock.

        do vdata = today - vdias to today.
            for each plani where plani.desti  = estab.clfcod
                             and plani.movtdc = tipmov.movtdc
                             and plani.dtincl = vdata
                             and plani.notsit = "F"
                           no-lock.
                for each movim of plani no-lock.
                    export movim.
                end.
            end.
            for each plani where plani.desti  = estab.clfcod
                             and plani.movtdc = tipmov.movtdc
                             and plani.dtincl = vdata
                             and plani.notsit = "C"
                           no-lock.
                for each movim of plani no-lock.
                    export movim.
                end.
            end.
        end.
    end.
end.
