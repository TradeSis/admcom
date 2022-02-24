def var v-param as char.
v-param = os-getenv("novacao2").

def var v-clicod like fin.contrato.clicod.
v-clicod = int(v-param).
def var v-etbcod like estab.etbcod.
def temp-table tt-contrato like fin.contrato.
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

def temp-table tt-cyber 
    field clicod    as int
    field situacao  as log init no.

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

    for each tt-contrato where tt-contrato.clicod > 0:
        export tt-contrato
                   except vltaxa modcod vlseguro DtEfetiva VlIof Cet TxJuros
                   vlf_principal vlf_acrescimo nro_parcelas
                   .
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
                 tt-titulo.titobs[1] = vobs.
    end.
    for each tt-titulo:
      export tt-titulo.
      q = q + 1.
    end.  
    put skip "~"@FIMTITULO;" string(q,"99999") "~"" skip.
    
    put skip "~"#NOVACORDO;" string(time) "~"" skip.
    q = 0.
    for each novacordo where
             novacordo.clicod = int(v-param) and
             novacordo.situacao = "PENDENTE"
             no-lock:
        export novacordo.
        q = q + 1.
    end.    
    put skip "~"@FIMNOVACORDO;" string(q,"99999") "~"" skip. 
    
    for each tt-cyber.
        delete tt-cyber.
    end.
    find first clien where clien.clicod = int(v-param) no-lock no-error.
    if avail clien
    then do. 
        /**/
        find first cyber_clien where cyber_clien.clicod     = clien.clicod and
                                     cyber_clien.Situacao   = yes
                                     no-lock no-error.
        if avail cyber_clien
        then do.
            create tt-cyber.
            assign tt-cyber.clicod   = clien.clicod
                   tt-cyber.situacao = cyber_clien.Situacao.
        end.
        /**/
    end.
    put skip "~"#CYBER;" string(time) "~""  skip. 
    q = 0.
    for each TT-CYBER where TT-CYBER.clicod = v-clicod no-lock. 
        export TT-CYBER.
        q = q + 1.    
    end.
    put skip "~"@FIMCYBER;" string(q,"99999") "~"" skip.
/*
    put skip "~"#VNDSEGURO;" string(time) "~""  skip.
    q = 0.
    for each tt-contrato:
        find first com.vndseguro where
                   com.vndseguro.contnum = tt-contrato.contnum and
                   com.vndseguro.tpseguro < 4 /* #1 */
                   no-lock no-error.
        if avail com.vndseguro
        then do:
            export com.vndseguro /*#1*/ except tempo.
            q = q + 1.      
        end.
    end.
    put skip "~"@FIMVNDSEGURO;" string(q,"99999") "~"" skip.    
*/
    put skip "~"@FIMFIM;" + string(time) "~"" skip.
