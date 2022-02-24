{admcab.i}
def temp-table wmargem
    field data like plani.pladat
    field valor like plani.platot.

def buffer bplani for plani.
def buffer bcontnf for contnf.
def var vtot like plani.platot.
def var wacr like plani.platot.
def var vetbcod like estab.etbcod.
def var vdt1 like plani.pladat.
def var vdt2 like plani.pladat.
def var vtotal like plani.platot.
def var vtotal1 like plani.platot.
def var vtotal2 like plani.platot.
def var valortot like plani.platot.
def var vvltotal like plani.platot.
def var vtotacr like plani.platot.
def var vtotser like plani.platot.
def var vvlcont like plani.platot.
def var wper like plani.platot.
def var vvldesc like plani.platot.
def var vvlacre like plani.platot.
repeat:
    for each wmargem:
        delete wmargem.
    end.
    update vetbcod with frame f1 side-label width 80.
    find estab where estab.etbcod = vetbcod no-lock.
    display estab.etbnom no-label with frame f1.

    update vdt1 label "Periodo"
           vdt2 no-label with frame f1.

    for each plani where plani.etbcod = estab.etbcod and
                         plani.movtdc = 5 and
                         plani.pladat >= vdt1 and
                         plani.pladat <= vdt2 no-lock break by plani.pladat:

        vvltotal = 0.
        vvlcont = 0.
        vvldesc = 0.
        wacr = 0.
        if plani.crecod > 1
        then do:
            find first contnf where contnf.etbcod = plani.etbcod and
                                    contnf.placod = plani.placod
                                        no-lock no-error.
            if avail contnf
            then do:
                for each bcontnf where bcontnf.etbcod  = contnf.etbcod and
                                       bcontnf.contnum = contnf.contnum
                                           no-lock:
                    find first bplani where bplani.etbcod = bcontnf.etbcod and
                                      bplani.placod = bcontnf.placod       and
                                      bplani.pladat = plani.pladat         and
                                      bplani.movtdc = plani.movtdc
                                          no-lock no-error.

                    if not avail bplani
                    then next.
                    vvltotal = vvltotal + (bplani.platot - bplani.vlserv).
                end.
                find contrato where contrato.contnum = contnf.contnum 
                                                 no-lock no-error.
                if avail contrato
                then do:
                    /*
                    find finan where finan.fincod = contrato.crecod
                                                    no-lock no-error.
                    if avail finan
                    then do:
                    */
                        vvlcont = contrato.vltotal.
                        valortot = contrato.vltotal.
                    /*
                    end.
                    */
                    wacr = vvlcont  - vvltotal.

                    wper = plani.platot / vvltotal.

                    wacr = wacr * wper.

                end.
                else do:
                     wacr = plani.acfprod.
                     valortot = plani.platot.
                end.

                if wacr < 0 or wacr = ?
                then wacr = 0.

                assign vvldesc  = vvldesc  + plani.descprod
                       vvlacre  = vvlacre  + wacr.

            end.

            vtot = vtot + plani.platot.
            vtotal = vtotal + plani.platot - vvldesc -
                     plani.vlserv + wacr.
            vtotacr = vtotacr + wacr.
            vtotser = vtotser + plani.vlserv.
        end.
        else do:
            vtot = vtot + plani.platot.
            vtotal = vtotal + plani.platot - plani.vlserv.
            vtotser = vtotser + plani.vlserv.
        end.
        if last-of(plani.pladat)
        then do:
            display plani.pladat column-label "Data"
                    vtot(total) column-label "Total Liq." format ">>,>>>,>>9.99"
                    vtotal(total) column-label "Total Venda"
                    vtotacr(total) column-label "Total Acrescimo"
                    vtotser(total) column-label "Total Devolucao"
                        with frame f2 down centered.
            create wmargem.
            assign wmargem.data = plani.pladat
                   wmargem.valor = vtotal.
            vtotal = 0.
            vtotacr = 0.
            vvlacre = 0.
            vvldesc = 0.
            valortot = 0.
            wacr = 0.
            wper = 0.
            vvltotal = 0.
            vvlcont  = 0.
            valortot = 0.
            vtot = 0.
            vtotser = 0.
        end.
    end.
    message "Confirma emissao de relatorio" update sresp.
    if sresp
    then do:

        {mdadmcab.i
            &Saida     = "printer"
            &Page-Size = "64"
            &Cond-Var  = "130"
            &Page-Line = "66"
            &Nom-Rel   = ""CONF_D1""
            &Nom-Sis   = """SISTEMA DE ESTOQUE"""
            &Tit-Rel   = """DEMONSTRATIVO DE VENDAS POR FILIAL - PERIODO DE "" +
                                  string(vdt1,""99/99/9999"") + "" A "" +
                                  string(vdt2,""99/99/9999"") + "" "" +
                                  string(estab.etbcod,"">>9"") + "" "" +
                                  string(estab.etbnom)"
            &Width     = "130"
            &Form      = "frame f-cabcab"}
        for each wmargem:
            display wmargem.data column-label "Data" at 50
                    wmargem.valor(total) column-label "Valor"
                            with frame f4 down width 200.
        end.
        output close.
    end.
end.