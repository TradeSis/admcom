{admcab.i}
def var vsitu   like cheque.chesit.
def var vsit    as log format "PAG/LIB" initial no.
def var vdti    as date format "99/99/9999".
def var vdtf    as date format "99/99/9999".
def var vetbi   like estab.etbcod.
def var vetbf   like estab.etbcod.
def stream stela.
def var vdata like plani.pladat.
def var totval like plani.platot.
def var totjur like plani.platot.
def var varquivo as char.


repeat:
    update vsit    label "Situacao"
           vdti  label "Data Inicial"
           vdtf  label "Data Final  "
                with frame f-dep centered side-label color blue/cyan row 4.

        disp " Prepare a Impressora para Imprimir Relatorio " with frame
                                f-pre centered row 16.
        pause.

        if opsys = "UNIX"
        then varquivo = "/admcom/relat/cel8" + string(time).
        else varquivo = "l:~\relat~\cel8" + string(time).

        {mdad.i
            &Saida     = "value(varquivo)"
            &Page-Size = "64"
            &Cond-Var  = "135"
            &Page-Line = "66"
            &Nom-Rel   = ""CHELI8""
            &Nom-Sis   = """SISTEMA FINANCEIRO"""
            &Tit-Rel   = """LISTAGEM DE CHEQUES DEVOLVIDOS"" + "" - "" +
                            string(vsit,""PAG/LIB"") + "" DE "" + 
                            string(vdti,""99/99/9999"") + "" ATE "" +
                            string(vdtf,""99/99/9999"")"
            &Width     = "135"
            &Form      = "frame f-cabcab"}

    if vsit
    then vsitu = "PAG".
    else vsitu = "LIB".




    for each cheque where cheque.chesit = vsitu and
                          cheque.cheven >= vdti and
                          cheque.cheven <= vdtf
                                        no-lock break by cheque.cheetb:

            if cheque.cheetb = 900
            then next.
            output stream stela to terminal.
            disp stream stela
                 cheque.cheven
                 cheque.clicod
                  with frame fffpla centered 1 down.
            pause 0.
            output stream stela close.

            totval = totval + cheque.cheval.
            totjur = totjur + cheque.chejur.
            
            if last-of(cheque.cheetb)
            then do:
            
                display cheque.cheetb column-label "Fil"
                        totval(total) space(4)
                                with frame f-imp width 150 down.
                totval = 0.
                totjur = 0.
            end.
    end.
    output close.  
    if opsys = "UNIX"
    then do:
        run visurel.p(varquivo,"").
    end.
    else do:    
    {mrod.i}
    end.
end.
