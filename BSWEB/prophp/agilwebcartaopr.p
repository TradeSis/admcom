def var v-param as char.
v-param = os-getenv("cartaopr").

def var v-etbcod like estab.etbcod.
def var vtipo-price as char.
def var vseri-price as char.

def temp-table tt-titulo like fin.titulo
use-index cxmdat
use-index datexp
use-index etbcod
use-index exportado
use-index iclicod
use-index titdtpag
use-index titdtven
use-index titnum
use-index titsit.

def var q as int.

    put "@INICIO;" string(time) skip.
    put "#CARTAOPR;" string(time) skip.
    q = 0.

    for each fin.titulo where fin.titulo.empcod = 19           
                               and fin.titulo.titnat = yes
                               and fin.titulo.modcod = "CHP"     
                               and fin.titulo.etbcod = 999
                               and fin.titulo.clifor = 110165
                               and fin.titulo.titnum = v-param
                               and fin.titulo.titpar = 1
                               no-lock:
              create tt-titulo.
              assign
                  tt-titulo.empcod = fin.titulo.empcod
                  tt-titulo.modcod = fin.titulo.modcod
                  tt-titulo.clifor = fin.titulo.clifor
                  tt-titulo.titnum = fin.titulo.titnum
                  tt-titulo.titpar = fin.titulo.titpar
                  tt-titulo.titnat = fin.titulo.titnat
                  tt-titulo.etbcod = fin.titulo.etbcod
                  tt-titulo.titdtemi =  fin.titulo.titdtemi
                  tt-titulo.titdtven =  fin.titulo.titdtven
                  tt-titulo.titvlcob =  fin.titulo.titvlcob
                  tt-titulo.titsit   =  fin.titulo.titsit    
                  tt-titulo.titdtpag =  fin.titulo.titdtpag
                  tt-titulo.titvlpag =  fin.titulo.titvlpag
                  tt-titulo.titobs[1] =  fin.titulo.titobs[1]
                  tt-titulo.moecod    =  fin.titulo.moecod
                  tt-titulo.titdtdes  = fin.titulo.titdtdes.
         end.
    q = 0.
    for each tt-titulo:
        export tt-titulo.
        q = q + 1.
    end.    
    put skip "@FIMCARTAOPR;" string(q,"99999").    
    put skip "@FIMFIM;" + string(time) skip.

