def var vi as int.
def var vt as int.
pause 0 before-hide.
def temp-table ttclien like clien.
for each estab no-lock.
for each titulo where titnat = no and titdtpag = ? and titulo.modcod = "CRE"
and 
(titulo.clifor = 167 or
 titulo.clifor = 1165 or
 titulo.clifor = 2865 or
 titulo.clifor = 1107)

and titulo.etbcod = estab.etbcod
and titulo.titdtven > 01/01/2015
 no-lock.
 vi = vi + 1.
 disp vi.
 disp titulo.clifor titulo.titnum 
 titulo.titdtven titulo.titvlcob
 titulo.etbcod .
 find first ttclien where ttclien.clicod = titulo.clifor no-error.
 if not avail ttclien
 then do:
    find first clien where clien.clicod = titulo.clifor no-lock no-error.
    if not avail clien then next.
    create ttclien.
    buffer-copy clien to ttclien.
    vt = vt + 1.
    if vt > 10 then leave.
 end.   
 disp vt.
end.
vt = 0.
vi = 0.
end.
message "export".
output to x/titulo.d.
for each ttclien,
    each titulo where
        titulo.titnat = no and
        titulo.modcod = "CRE" and
        titulo.clifor = ttclien.clicod
        no-lock.
    export titulo.
end.            
output close.
message "clien".
output to x/clien.d.
for each ttclien.
    export ttclien.
end.
output close.    

