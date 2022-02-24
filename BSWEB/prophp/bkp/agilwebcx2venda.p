def var varquivo as char.
def var v-clicod like clien.clicod.
def var v-param as char.

def var v-etbcod like estab.etbcod.
def var vq as int.                                
v-param = os-getenv("cx2venda").
v-etbcod = int(substr(string(v-param),1,3)).
v-clicod = int(substr(string(v-param),4,10)).

def temp-table tt-clien like clien.

def temp-table tt-titulo like fin.titulo
use-index cxmdat
use-index datexp
use-index etbcod
use-index exportado
use-index iclicod
use-index titdtpag
use-index titdtven
use-index titnum
use-index titsit
.

def new shared temp-table tp-titulo like fin.titulo
    index dt-ven titdtven
        index titnum empcod
              titnat
               modcod
               etbcod
                clifor
                 titnum
                titpar.

def new shared temp-table tp-historico
        field clicod like clien.clicod
        field sal-aberto like clien.limcrd
        field lim-credito as dec
        field lim-calculado like clien.limcrd format "->>,>>9.99"
        field ult-compra like plani.pladat
        field qtd-contrato as int format ">>>9"
        field parcela-paga as int format ">>>>9"
        field parcela-aberta as int format ">>>>9"
        field qtd-15 as int format ">>>>9"
        field vtotal as dec
        field media-contrato as dec
        field qtd-45  as int format ">>>>9"
        field vqtd as dec
        field v-acum like clien.limcrd
        field v-mes as int format "99"
        field v-ano as int format "9999"
        field qtd-46 as int format ">>>>9"
        field pct-pago2 as dec
        field v-media like clien.limcrd
        field vrepar as log format "Sim/Nao"
        field proximo-mes  as dec
        field maior-atraso as date
        field vencidas like clien.limcrd
        field cheque_devolvido like plani.platot
        .

def new shared temp-table tp-cheque like fin.cheque.

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

def var vobs as char.
def var q as int.                    
    
    q = 0.

    put "~"@INICIO;" string(time) "~"" skip.
    
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
    put skip "~"@FIMCLIEN;" string(q,"99999") "~"" skip.
    put skip "#CPCLIEN;" string(time) skip. 
    q = 0.
    for each cpclien where cpclien.clicod = v-clicod no-lock. 
        export cpclien.
        q = q + 1.    
    end.
    put skip "~"@FIMCPCLIEN;" string(q,"99999") "~"" skip.
    put skip "#CARRO;" string(time) skip.
    q = 0.
    for each carro where
             carro.clicod = v-clicod no-lock:
         export carro.
         q = q + 1.
    end.   
    put skip "~"@FIMCARRO;" string(q,"99999") "~"" skip.
    put "#TITULO;" string(time) skip.   
    q = 0. 
    for each fin.titulo use-index iclicod where 
             fin.titulo.empcod = 19        and
             fin.titulo.titnat = no        and
             fin.titulo.clifor = v-clicod no-lock:
        find first tp-titulo where tp-titulo.empcod = titulo.empcod and
                                   tp-titulo.titnat = titulo.titnat and
                                   tp-titulo.modcod = titulo.modcod and
                                   tp-titulo.etbcod = titulo.etbcod and
                                   tp-titulo.clifor = titulo.clifor and
                                   tp-titulo.titnum = titulo.titnum and
                                   tp-titulo.titpar = titulo.titpar
                                   no-error.
        if not avail tp-titulo
        then do: 
            create tp-titulo.
            buffer-copy fin.titulo to tp-titulo.
        end.
        if fin.titulo.titdtpag <> ? and
                fin.titulo.titsit = "PAG" and
                fin.titulo.titdtpag < today - 60
        then next. 

        if fin.titulo.modcod = "CHQ" then next.
        
        find first tt-titulo where tt-titulo.empcod = titulo.empcod and
                                   tt-titulo.titnat = titulo.titnat and
                                   tt-titulo.modcod = titulo.modcod and
                                   tt-titulo.etbcod = titulo.etbcod and
                                   tt-titulo.clifor = titulo.clifor and
                                   tt-titulo.titnum = titulo.titnum and
                                   tt-titulo.titpar = titulo.titpar
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
                 fin.titulo.clifor = v-clicod no-lock:
        /*if fin.titulo.titobs[1] <> ""
        then find acao where
                  acao.acaocod = int(fin.titulo.titobs[1])
                  no-lock no-error.
        */
        find first tt-titulo where tt-titulo.empcod = titulo.empcod and
                                   tt-titulo.titnat = titulo.titnat and
                                   tt-titulo.modcod = titulo.modcod and
                                   tt-titulo.etbcod = titulo.etbcod and
                                   tt-titulo.clifor = titulo.clifor and
                                   tt-titulo.titnum = titulo.titnum and
                                   tt-titulo.titpar = titulo.titpar
                                   no-error.
        if not avail tt-titulo
        then do:                                        
             create tt-titulo.
             buffer-copy fin.titulo to tt-titulo.
        end.
        if fin.titulo.titobs[1] <> ""
        then do:
            find acao where
                  acao.acaocod = int(fin.titulo.titobs[1])
                  no-lock no-error.
            if avail acao
            then tt-titulo.titchepag = acao.descricao.
        end.
    end.
    for each dragao.titulo use-index iclicod
                 where dragao.titulo.empcod = 19
                   and dragao.titulo.titnat = no
                   and dragao.titulo.modcod = "CRE"     
                   and dragao.titulo.clifor = v-clicod
                   no-lock:

        find first tp-titulo where tp-titulo.empcod = titulo.empcod and
                                   tp-titulo.titnat = titulo.titnat and
                                   tp-titulo.modcod = titulo.modcod and
                                   tp-titulo.etbcod = titulo.etbcod and
                                   tp-titulo.clifor = titulo.clifor and
                                   tp-titulo.titnum = titulo.titnum and
                                   tp-titulo.titpar = titulo.titpar
                                   no-error.
        if not avail tp-titulo
        then do: 
            create tp-titulo.
            buffer-copy dragao.titulo to tp-titulo.
        end.

        if dragao.titulo.titdtpag <> ? and
           dragao.titulo.titsit = "PAG" and
           dragao.titulo.titdtpag < today - 60
        then next.

        find first tt-titulo where tt-titulo.empcod = titulo.empcod and
                                   tt-titulo.titnat = titulo.titnat and
                                   tt-titulo.modcod = titulo.modcod and
                                   tt-titulo.etbcod = titulo.etbcod and
                                   tt-titulo.clifor = titulo.clifor and
                                   tt-titulo.titnum = titulo.titnum and
                                   tt-titulo.titpar = titulo.titpar
                                   no-error.
        if not avail tt-titulo
        then do:                                        
             create tt-titulo.
             buffer-copy dragao.titulo to tt-titulo.
        end.

    end.
    for each fin.cheque where fin.cheque.clicod = v-clicod
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
    put skip "~"@FIMTITULO;" string(q,"99999") "~"" skip.
    put "#CHEQUE;" string(time) skip. 
    q = 0.   
    for each fin.cheque where fin.cheque.clicod = v-clicod
                              and fin.cheque.chesit = "LIB" no-lock:
            
               export cheque.
        q = q + 1.
    end.
    put skip "~"@FIMCHEQUE;" string(q,"99999") "~"" skip.
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
    put skip "~"@FIMCAMPANHA;" string(q,"99999") "~"" skip.
    put "#HISTORICO;" string(time) skip.
    q = 0.
    run /admcom/progr/hiscliWG.p(v-clicod).
    for each tp-historico where tp-historico.clicod > 0:
        export tp-historico.
        q = q + 1.
    end.    
    put skip "~"@FIMHISTORICO;" string(q,"99999") "~"" skip.
    put "~"@FIMFIM;" string(time) "~"" skip.
    q = 0. 
