{admcab.i}
def var varquivo as char.
def var outras-icms as dec format "->>>,>>9.99".
def var vetbcod  like estab.etbcod.
def var nu as int.
def var vvlcont as dec format ">>>>>.99".
def var vlannum as int.
def var i       as int.
def var wni     as int.
def var ni      as int.
def var nf      as int.
def var vdt     as date format "99/99/9999".
def var vdti    as date format "99/99/9999" initial today.
def var vdtf    as date format "99/99/9999" initial today.
def stream sarq.

update vetbcod with frame f1.
find estab where estab.etbcod = vetbcod no-lock.
display estab.etbnom no-label with frame f1.
update vdti label "Data Inicial" colon 16
       vdtf label "Data Final" with frame f1 side-label width 80.

update vlannum label "Lancamento" with frame f1.

def temp-table wforne
    field wforcod like forne.forcod
    field wfornom like forne.fornom
    field wforcgc like forne.forcgc
    field wuf     like forne.ufecod.

def var d-dtini     as   date init today                            no-undo.
def var i-nota      like plani.numero                               no-undo.
def var i-seq       as   int format ">>>9"                          no-undo.
def var vcgc as char format "xx.xxx.xxx/xxxx-xx".
def var vemp as int.
for each wforne.
    delete wforne.
end.

do vdt = vdti to vdtf:
    for each plani where plani.movtdc  = 15           and
                         plani.desti   = estab.etbcod and
                         plani.dtinclu = vdt no-lock:
        
        if plani.emite = 5027
        then next.
        find forne where forne.forcod = plani.emite no-lock no-error.
        if not avail forne
        then next.
        vcgc = string(forcgc,"xx.xxx.xxx/xxxx-xx").
        vemp = estab.etbcod.
        if estab.etbcod = 1
        then vemp = 50.

        if estab.etbcod = 995
        then vemp = 122. 
        if estab.etbcod = 996
        then vemp = 54.
        if estab.etbcod = 997
        then vemp = 51.
        if estab.etbcod = 98
        then vemp = 53.
        if estab.etbcod = 999
        then vemp = 52.

        find first lfcad where lfcad.cgc = vcgc and
                               lfcad.empcod = vemp no-error.
        if not avail lfcad or vcgc = ""
        then do:
            find first wforne where wforne.wforcod = forne.forcod no-error.
            if not avail wforne
            then create wforne.
            assign wforne.wforcod = forne.forcod
                   wforne.wfornom = forne.fornom
                   wforne.wforcgc = forne.forcgc
                   wforne.wuf     = forne.ufecod.
        end.
    end.
end.
output to printer.
for each wforne by wfornom.
    disp wforne.
end.
output close.
find first wforne no-error.
if avail wforne
then do:
    message "Existem fornecedores nao cadastrados".
    undo, retry.
end.

varquivo = "m:\lf" + string(estab.etbcod,">>9") + ".txt".

 

output stream sarq to value(varquivo).

do vdt = vdti to vdtf:
    display vdt with 1 down. pause 0.
    for each plani where plani.movtdc = 15       and
                         plani.desti  = estab.etbcod and
                         plani.dtinclu = vdt no-lock:

        if plani.emite = 5027
        then next.
        outras-icms = 0.
        find forne where forne.forcod = plani.emite no-lock no-error.
        if not avail forne
        then next.
        vcgc = string(forcgc,"xx.xxx.xxx/xxxx-xx").
        vemp = estab.etbcod.
        if estab.etbcod = 1
        then vemp = 50.
        if estab.etbcod = 995
        then vemp = 122. 
        if estab.etbcod = 996
        then vemp = 54.
        if estab.etbcod = 997
        then vemp = 51.
        if estab.etbcod = 98
        then vemp = 53.
        if estab.etbcod = 999
        then vemp = 52.
        find first lfcad where lfcad.cgc = vcgc and
                               lfcad.empcod = vemp no-error.


        nu = nu + 1.
        put stream sarq unformatted
            nu  at 1                                    ",".
        put stream sarq  unformatted
            lfcad.codigo ",".

        put stream sarq
        /*d*/       trim(string(year(plani.pladat),"9999") +
                         string(month(plani.pladat),"99")  +
                         string(day(plani.pladat),"99"))        ",".

        put stream sarq
        /*d*/       trim(string(year(plani.dtinclu),"9999") +
                         string(month(plani.dtinclu),"99")  +
                         string(day(plani.dtinclu),"99"))     ",".

        put stream sarq  unformatted
        /*c*/       plani.numero ",".
        put stream sarq unformatted
        /*c*/       chr(34) plani.serie
            chr(34) ",".
        put stream sarq unformatted
        /*c*/       chr(34)
                    "NF"
                    chr(34) ",".
        
        put stream sarq
        /*n*/       plani.platot  format ">>>>>9.99"   ",".
        
        put stream sarq unformatted
        /*c*/       chr(34)
                    "  "
                    chr(34) ",".
        put stream sarq unformatted
        /*c*/       chr(34)

        if forne.ufecod = "RS"
        then "1.99"
        else "2.99" chr(34) ",".

        put stream sarq
        /*n*/      plani.bicms  format ">>>>>9.99"  ",".
        put stream sarq unformatted
        /*n*/      0                                  ",".
        put stream sarq unformatted
        /*n*/      plani.outras format "->>>>9.99"      ",".
        put stream sarq unformatted
        /*n*/
        plani.alicms format "99.99"  ",".
        put stream sarq
        /*n*/      plani.icms  format ">>>>9.99"    ",".
        put stream sarq unformatted
        /*n*/      0                                ",".
        put stream sarq unformatted
        /*n*/      0                                  ",".
        put stream sarq unformatted
        /*n*/      0                                  ",".
        put stream sarq unformatted
        /*n*/      0                                  ",".
        put stream sarq unformatted
        /*n*/      0                                  ",".
        put stream sarq unformatted
        /*n*/      plani.ipi    format ">>>>9.99"    ",".
        put stream sarq unformatted
        /*n*/      0                                  ",".
        put stream sarq unformatted
        /*n*/      0                                  ",".
        put stream sarq unformatted
        /*c*/       chr(34)
                    " " /*  NFS canceladas */
                    chr(34) ",".
        put stream sarq unformatted
        /*n*/      0                                             ",".
        put stream sarq unformatted
                    0   ",".
        put stream sarq unformatted
        /*c*/       chr(34) " "
                    chr(34).

    end.
end.
output stream sarq close.