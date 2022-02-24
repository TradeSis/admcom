def var vclicod as int.
def var vi as int.
def var v2 as int.

vclicod = int(os-getenv("clien")).

find clien where clien.clicod = vclicod no-lock no-error.
if not avail clien
then do:
        put unformatted "NAOEXISTE".
        quit.
end.
def var vd as dec.

find current clien no-lock.

put unformatted skip "#clien,1" skip.
export clien.

/***
find cpfis of clien no-lock no-error.
if avail cpfis
then do:
    put unformatted skip "#cpfis,1" skip.
    export cpfis.
end.
find cpjur of clien no-lock no-error.
if avail cpjur
then do:
    put unformatted skip "#cpjur,1" skip.
    export cpjur.
end.

if vclicod = 1 then return.

def temp-table tt-titpag
    field rec   as recid.

vi = 0.
v2 = 0.
for each titulo where titulo.titnat = no and
                      titulo.clicod = vclicod
                no-lock.
    vi = vi + 1.
    for each titpag of titulo /*where titpag.titdtpag > today - 45*/ no-lock.
        v2 = v2 + 1.
        create tt-titpag.
        tt-titpag.rec = recid(titpag).
    end.
end.
for each titulo where titulo.titnat = yes and
                      titulo.clicod = vclicod
                no-lock.
    vi = vi + 1.
    for each titpag of titulo /*where titpag.titdtpag > today - 45*/ no-lock.
        v2 = v2 + 1.
        create tt-titpag.
        tt-titpag.rec = recid(titpag).
    end.
end.

if vi > 0
then do:
    put unformatted skip "#titulo," + string(vi) skip.
    for each titulo where titulo.titnat = no and
                          titulo.clicod = vclicod
                    no-lock.
        export titulo.
    end.
    for each titulo where titulo.titnat = yes and
                          titulo.clicod = vclicod
                    no-lock.
        export titulo.
    end.
end.

if v2 > 0
then do:
    put unformatted skip "#titpag," + string(v2) skip.
    for each tt-titpag no-lock.
        find titpag where recid(titpag) = tt-titpag.rec no-lock.
        export titpag.
    end.
/***
    for each titulo where
        titulo.titnat = no and
        titulo.clicod = vclicod
        no-lock.
        for each titpag of titulo where titpag.titdtpag > today - 45 no-lock.
            export titpag.
        end.
    end.
    for each titulo where
        titulo.titnat = yes and
        titulo.clicod = vclicod
        no-lock.
        for each titpag of titulo where titpag.titdtpag > today - 45 no-lock.
            export titpag.
        end.
    end.
***/
end.

vi = 0.
find last sitcli where sitcli.clicod = clien.clicod
                   and sitcli.tipspc
                 no-lock no-error.
if avail sitcli
then vi = vi + 1.

/* Consultas ao SPC */
for each sitcli where sitcli.clicod  = clien.clicod
                  and sitcli.sitdata = today
                  and sitcli.LCreTip = "SPC-CPF"
                no-lock.
    vi = vi + 1.
end.

if vi > 0
then do.
    put unformatted skip "#sitcli," + string(vi) skip.
    find last sitcli where sitcli.clicod = clien.clicod
                       and sitcli.tipspc
                     no-lock no-error.
    if avail sitcli
    then export sitcli.

    for each sitcli where sitcli.clicod  = clien.clicod
                      and sitcli.sitdata = today
                      and sitcli.LCreTip = "SPC-CPF"
                    no-lock.
        export sitcli.
    end.
end.

vi = 0.
for each titconta where titconta.clicod  = clien.clicod
                    and titconta.titcope > 0
                    and titconta.titcvlr > 0
                  no-lock.
    vi = vi + 1.
end.
if vi > 0
then do.
    put unformatted skip "#titconta," + string(vi) skip. 
    for each titconta where titconta.clicod  = clien.clicod
                        and titconta.titcope > 0
                        and titconta.titcvlr > 0
                      no-lock.
        export titconta.
    end.
end.

vi = 0.
for each clienaux where clienaux.clicod = clien.clicod no-lock.
    vi = vi + 1.
end.
if vi > 0
then do.
    put unformatted skip "#clienaux," + string(vi) skip.
    for each clienaux where clienaux.clicod = clien.clicod no-lock.
        export clienaux.
    end.
end.
 */
