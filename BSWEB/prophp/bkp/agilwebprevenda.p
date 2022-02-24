def var varquivo as char.
def var v-clicod like clien.clicod.
def var v-param as char format "x(20)".

def var vq as int.                                
v-param = os-getenv("prevenda").
v-clicod = int(substr(string(v-param),4,10)).

/*
output to value("/admcom/work/x." + string(v-clicod)).
put v-param skip.
output close.
*/

def temp-table tt-clien like clien.
def temp-table tt-titulo like fin.titulo.
/*
def temp-table tt-movim like com.movim.
*/
def var vcalclim as dec.
def var vpardias as dec.
def var vdisponivel as dec.
def new shared temp-table tt-dados
    field parametro as char
    field valor     as dec
    field valoralt  as dec
    field percent   as dec
    field vcalclim  as dec
    field operacao  as char format "x(1)" column-label ""
    field numseq    as int
    index dado1 numseq.

def temp-table tt-movim like movim
    index i1 movdat descending. 
def var vobs as char.
def var q as int.                    

    q = 0.
    put "@INICIO;" string(time) skip.
    
    put "#TBCARTAO;" string(time) skip.
    for each tbcartao where tbcartao.codoper = 999 and
                            tbcartao.nrocartao = v-param
                            no-lock.
        export tbcartao.
        v-clicod = tbcartao.clicod.
        q = q + 1.
    end.  
    put skip "@FIMTBCARTAO;" string(q,"99999") skip.                      
    put "#CLIEN;" string(time) skip.
    q = 0.
    for each tt-clien. delete tt-clien. end.
    for each clien where
               clien.clicod = v-clicod no-lock:
               create tt-clien.
               buffer-copy clien to tt-clien.
    end.
    for each tt-clien where
               tt-clien.clicod = v-clicod :
            find clien where clien.clicod = tt-clien.clicod no-lock.

                vcalclim = 0.
                vpardias = 0.
                vdisponivel = 0.
                run /admcom/progr/calccredscore.p (input "",
                        input recid(clien),
                        output vcalclim,
                        output vpardias,
                        output vdisponivel).
                tt-clien.limcrd = vcalclim.
                tt-clien.medatr = vpardias.
            
            export tt-clien.
            q = q + 1.
            
    end.  
    put skip "@FIMCLIEN;" string(q,"99999") skip.
    put "#CPCLIEN;" string(time) skip. 
    q = 0.
    for each cpclien where cpclien.clicod = v-clicod no-lock. 
        export cpclien.
        q = q + 1.    
    end.
    put skip "@FIMCPCLIEN;" string(q,"99999") skip.
    put "#CARRO;" string(time) skip.
    q = 0.
    for each carro where
             carro.clicod = v-clicod no-lock:
         export carro.
         q = q + 1.
    end.   
    put skip "@FIMCARRO;" string(q,"99999") skip.
    put "#TITULO;" string(time) skip.   
    q = 0. 
    for each fin.titulo use-index iclicod where 
             fin.titulo.empcod = 19        and
             fin.titulo.titnat = no        and
                 /*fin.titulo.modcod = "CRE"     and*/
             fin.titulo.clifor = v-clicod no-lock:
             if fin.titulo.titdtpag <> ?
             then next.
             if fin.titulo.modcod = "CHQ" then next.
             create tt-titulo.
             assign
                 tt-titulo.empcod = fin.titulo.empcod
                 tt-titulo.modcod = fin.titulo.modcod
                 tt-titulo.clifor = fin.titulo.clifor
                 tt-titulo.titnum = fin.titulo.titnum
                 tt-titulo.titpar = fin.titulo.titpar
                 tt-titulo.titnat = fin.titulo.titnat
                 tt-titulo.etbcod = fin.titulo.etbcod
                 tt-titulo.titdtemi = fin.titulo.titdtemi
                 tt-titulo.titdtven = fin.titulo.titdtven
                 tt-titulo.titvlcob = fin.titulo.titvlcob
                 tt-titulo.titsit   = fin.titulo.titsit    
                 tt-titulo.titdtpag = fin.titulo.titdtpag
                 tt-titulo.titvlpag = fin.titulo.titvlpag
                 tt-titulo.titobs[1] = fin.titulo.titobs[1]
                 tt-titulo.moecod =   fin.titulo.moecod
                 .
    end.
    for each fin.titulo use-index iclicod where 
                 fin.titulo.empcod = 19        and
                 fin.titulo.titnat = yes       and
                 fin.titulo.modcod = "BON"     and
                 fin.titulo.clifor = v-clicod no-lock:

             if fin.titulo.titobs[1] <> ""
             then find acao where
                       acao.acaocod = int(fin.titulo.titobs[1])
                       no-lock no-error.
             create tt-titulo.
             assign
                 tt-titulo.empcod = fin.titulo.empcod
                 tt-titulo.modcod = fin.titulo.modcod
                 tt-titulo.clifor = fin.titulo.clifor
                 tt-titulo.titnum = fin.titulo.titnum
                 tt-titulo.titpar = fin.titulo.titpar
                 tt-titulo.titnat = fin.titulo.titnat
                 tt-titulo.etbcod = fin.titulo.etbcod
                 tt-titulo.titdtemi = fin.titulo.titdtemi
                 tt-titulo.titdtven = fin.titulo.titdtven
                 tt-titulo.titvlcob = fin.titulo.titvlcob
                 tt-titulo.titsit   = fin.titulo.titsit    
                 tt-titulo.titdtpag = fin.titulo.titdtpag
                 tt-titulo.titvlpag = fin.titulo.titvlpag
                 tt-titulo.titobs[1] = fin.titulo.titobs[1]
                 tt-titulo.moecod =   fin.titulo.moecod
                 tt-titulo.titagepag =   fin.titulo.titagepag
                 .
             if avail acao
             then tt-titulo.titchepag = acao.descricao.
    end.
    for each dragao.titulo use-index iclicod
                 where dragao.titulo.empcod = 19
                   and dragao.titulo.titnat = no
                   and dragao.titulo.modcod = "CRE"     
                   and dragao.titulo.clifor = v-clicod
                   /*and dragao.titulo.titsit = "LIB"*/ no-lock:
             if dragao.titulo.titdtpag <> ?
             then next.
             create tt-titulo.
             assign
                 tt-titulo.empcod = dragao.titulo.empcod
                 tt-titulo.modcod = dragao.titulo.modcod
                 tt-titulo.clifor = dragao.titulo.clifor
                 tt-titulo.titnum = dragao.titulo.titnum
                 tt-titulo.titpar = dragao.titulo.titpar
                 tt-titulo.titnat = dragao.titulo.titnat
                 tt-titulo.etbcod = dragao.titulo.etbcod
                 tt-titulo.titdtemi = dragao.titulo.titdtemi
                 tt-titulo.titdtven = dragao.titulo.titdtven
                 tt-titulo.titvlcob = dragao.titulo.titvlcob
                 tt-titulo.titsit   = dragao.titulo.titsit    
                 tt-titulo.titdtpag = dragao.titulo.titdtpag
                 tt-titulo.titvlpag = dragao.titulo.titvlpag
                 tt-titulo.moecod =   dragao.titulo.moecod .
    end.
    q = 0.
    for each tt-titulo:
      export tt-titulo.
      q = q + 1.
    end.  
    put skip "@FIMTITULO;" string(q,"99999") skip.
    put "#CAMPANHA;" string(time) skip.  
    q = 0.  
    for each campanha where
               campanha.clicod = v-clicod no-lock,
        first acao where acao.acaocod = campanha.acaocod no-lock:
        if acao.dtini <= today and
           acao.dtfin >= today
        then do:
            export campanha.
            q = q + 1.
        end.
    end.         
    put skip "@FIMCAMPANHA;" string(q,"99999") skip.
    put "#PLANI;" string(time) skip.
    q = 0. 
    for each plani where plani.movtdc = 5
                     and plani.desti  = v-clicod and
                     plani.pladat >= today - 180 no-lock:
                 export plani.
        q = q + 1.
    end.
    put skip "@FIMPLANI;" string(q,"99999") skip.
    put "#MOVIM;" string(time) skip.
    q = 0.
    for each plani where plani.movtdc = 5
                     and plani.desti  = v-clicod and
                     plani.pladat >= today - 180 no-lock:
        for each movim where movim.etbcod = plani.etbcod
                                  and movim.placod = plani.placod
                                  and movim.movtdc = plani.movtdc
                                  and movim.movdat = plani.pladat no-lock:
            create tt-movim.
            buffer-copy movim to tt-movim.                  
        end.
    end.
    for each tt-movim :
        export tt-movim.
        q = q + 1.
        if q = 5 then leave.
    end.    
    put skip "@FIMMOVIM;" string(q,"99999") skip.
    put "@FIMFIM;" string(time) skip.
    q = 0.
