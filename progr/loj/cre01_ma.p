/* #1 Helio 04.04.18 - Regra definida 
    TITOBS[1] contem FEIRAO = YES - NAO PERTENCE A CARTEIRA 
    ou
    TPCONTRATO = "L" - NAO PERTENCE A CARTEIRA
*/

{admcab.i}

def var vtip as char format "x(10)" extent 2 initial ["Posicao I","Posicao II"].

repeat:
    disp vtip with frame f1 no-label centered row 10.
    choose field vtip with frame f1.
    hide frame f1 no-pause.
    
    if frame-index = 1
    then run loj/cre02_a.p.
    else run loj/cre03_a.p.
    
    hide message no-pause.
end.
