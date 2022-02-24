def var v-param as char.
v-param = os-getenv("novacao2").

def var v-etbcod like estab.etbcod.
def temp-table tt-contrato like fin.contrato.
def temp-table tt-titulo like fin.titulo. 

def var vobs as char.

def var q as int.
    put skip "~"@INICIO;" string(time) "~"".
    put skip "~"#CONTRATO;" string(time) "~"" skip.
    q = 0.
    for each fin.contrato where 
             fin.contrato.clicod = int(v-param) no-lock:
       find first tt-contrato where
                  tt-contrato.contnum = fin.contrato.contnum
                  no-error.
       if not avail tt-contrato
       then do:           
        create tt-contrato.
        buffer-copy fin.contrato to tt-contrato.
       end. 
    end.
    for each dragao.contrato where 
             dragao.contrato.clicod = int(v-param) no-lock:
        find first tt-contrato where
                  tt-contrato.contnum = dragao.contrato.contnum
                  no-error.
        if not avail tt-contrato
        then do: 
            create tt-contrato.
            buffer-copy dragao.contrato to tt-contrato.
        end.
    end.                 
    for each tt-contrato where tt-contrato.clicod > 0:
        export tt-contrato.
        q = q + 1.
    end.    
    put skip "~"@FIMCONTRATO;" string(q,"99999") "~"" .    
    put skip "~"#TITULO;" string(time) "~"" skip.   
    q = 0. 
    for each fin.titulo use-index iclicod where 
             fin.titulo.empcod = 19        and
             fin.titulo.titnat = no        and
             fin.titulo.clifor = int(v-param) no-lock:
 
             if fin.titulo.titdtpag <> ? and
                fin.titulo.titsit = "PAG" and
                fin.titulo.titdtpag < today - 30
             then next. 

             if fin.titulo.modcod = "CHQ" then next.
        find first tt-titulo where tt-titulo.empcod = fin.titulo.empcod and
                                   tt-titulo.titnat = fin.titulo.titnat and
                                   tt-titulo.modcod = fin.titulo.modcod and
                                   tt-titulo.etbcod = fin.titulo.etbcod and
                                   tt-titulo.clifor = fin.titulo.clifor and
                                   tt-titulo.titnum = fin.titulo.titnum and
                                   tt-titulo.titpar = fin.titulo.titpar
                                   no-error.
        if not avail tt-titulo
        then do:         
             create tt-titulo.
             buffer-copy fin.titulo to tt-titulo.
        end.
    end.
        
    for each fin.titulo use-index iclicod where 
                 fin.titulo.empcod = 19        and
                 fin.titulo.titnat = yes       and
                 fin.titulo.modcod = "BON"     and
                 fin.titulo.clifor = int(v-param) no-lock:

             if fin.titulo.titobs[1] <> ""
             then find acao where
                       acao.acaocod = int(fin.titulo.titobs[1])
                       no-lock no-error.
        find first tt-titulo where tt-titulo.empcod = fin.titulo.empcod and
                                   tt-titulo.titnat = fin.titulo.titnat and
                                   tt-titulo.modcod = fin.titulo.modcod and
                                   tt-titulo.etbcod = fin.titulo.etbcod and
                                   tt-titulo.clifor = fin.titulo.clifor and
                                   tt-titulo.titnum = fin.titulo.titnum and
                                   tt-titulo.titpar = fin.titulo.titpar
                                   no-error.
        if not avail tt-titulo
        then do:         
             create tt-titulo.
            
             buffer-copy fin.titulo to tt-titulo.
             if avail acao
             then tt-titulo.titchepag = acao.descricao.
        end.
    end.
    for each dragao.titulo use-index iclicod
                 where dragao.titulo.empcod = 19
                   and dragao.titulo.titnat = no
                   and dragao.titulo.modcod = "CRE"     
                   and dragao.titulo.clifor = int(v-param)
                   no-lock:

             if dragao.titulo.titdtpag <> ? and
                dragao.titulo.titsit = "PAG" and
                dragao.titulo.titdtpag < today - 30
             then next.

        find first tt-titulo where tt-titulo.empcod = dragao.titulo.empcod and
                                   tt-titulo.titnat = dragao.titulo.titnat and
                                   tt-titulo.modcod = dragao.titulo.modcod and
                                   tt-titulo.etbcod = dragao.titulo.etbcod and
                                   tt-titulo.clifor = dragao.titulo.clifor and
                                   tt-titulo.titnum = dragao.titulo.titnum and
                                   tt-titulo.titpar = dragao.titulo.titpar
                                   no-error.
        if not avail tt-titulo
        then do:          
             create tt-titulo.
             buffer-copy dragao.titulo to tt-titulo.
        end.
    end.
    for each fin.cheque where fin.cheque.clicod = int(v-param)
                              and fin.cheque.chesit = "LIB" no-lock:
                vobs = "".
                vobs = "NOME="     + string(fin.cheque.nome).
                if fin.cheque.cheemi <> ?
                then vobs = vobs  + "|CHEEMI=" + string(fin.cheque.cheemi).
                else vobs = vobs  + "|CHEEMI=?".
                if fin.cheque.cheven <> ?
                then vobs = vobs + "|CHEVEN=" + string(fin.cheque.cheven).
                else vobs = vobs + "|CHEVEN=?".
                vobs = vobs + "|CHEVAL="  + string(fin.cheque.cheval)
                            + "|CHENUM="  + string(fin.cheque.chenum)
                            + "|CHEBAN="  + string(fin.cheque.cheban)
                            + "|CHEAGE="  + string(fin.cheque.cheage)
                            + "|CHECID="  + string(fin.cheque.checid)
                            + "|CHEETB="  + string(fin.cheque.cheetb)
                            + "|CHEALIN=" + string(fin.cheque.chealin).
                if fin.cheque.chedti <> ?
                then vobs = vobs + "|CHEDTI=" + string(fin.cheque.chedti).
                else vobs = vobs + "|CHEDTI=?".
                if fin.cheque.chedtf <> ?
                then vobs = vobs + "|CHEDTF="  + string(fin.cheque.chedtf).
                else vobs = vobs + "|CHEDTF=?".
                vobs = vobs + "|CHESIT="  + string(fin.cheque.chesit)
                            + "|CODCOB="  + string(fin.cheque.codcob) 
                            + "|CLICOD="  + string(fin.cheque.clicod).
                            
                if fin.cheque.chepag <> ?
                then vobs = vobs + "|CHEPAG="  + string(fin.cheque.chepag).
                else vobs = vobs + "|CHEPAG=?".
                vobs = vobs + "|CHEJUR="  + string(fin.cheque.chejur).
        
        create tt-titulo.
             assign
                 tt-titulo.empcod = 19
                 tt-titulo.modcod = "CHQ"
                 tt-titulo.clifor = fin.cheque.clicod
                 tt-titulo.titnum = string(fin.cheque.chenum)
                 tt-titulo.titpar = 1
                 tt-titulo.titnat = no
                 tt-titulo.etbcod = fin.cheque.cheetb
                 tt-titulo.titdtemi = fin.cheque.cheemi
                 tt-titulo.titdtven = fin.cheque.cheven
                 tt-titulo.titvlcob = fin.cheque.cheval
                 tt-titulo.titsit   = "LIB"    
                 tt-titulo.titdtpag = ?
                 tt-titulo.titvlpag = 0
                 tt-titulo.titobs[1] = vobs
                 .
    end.
    for each tt-titulo:
      export tt-titulo.
      q = q + 1.
    end.  
    put skip "~"@FIMTITULO;" string(q,"99999") "~"".
    put skip "~"@FIMFIM;" + string(time) "~"" skip.
