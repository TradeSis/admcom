/*----------------------------------------------------------------------------*/
/* finan/pag_gru1.p                                         Agenda - Listagem */
/*                                                                            */
/*----------------------------------------------------------------------------*/
{admcab.i}

def var vtotal as dec.
def var vsetcod like setaut.setcod.
def var vval as char.
def var vvalcre as char.
def var vvaldeb as char.
def var v as char.
def var cc-desc as char.
def var vfornom like forne.fornom.
def var vacumme as dec initial 0.
def input parameter vesc as log.
def var varquivo as char format "x(20)".
def var vv as char.
def var vtot like fin.titulo.titvlcob.
def buffer bmodgru for modgru.
def var vperc as dec.
def temp-table wpag
    field wcod like fin.titulo.clifor
    field wnome like forne.fornom
    field wmodcod like fin.titulo.modcod
    field wmogsup like modgru.mogsup
    field wdes  like fin.titulo.titvlcob
    field wjur  like fin.titulo.titvlcob
    field wcob  like fin.titulo.titvlcob
    field wpag  like fin.titulo.titvlcob
    field wcre  like fin.titulo.titvlcob
    field wdeb  like fin.titulo.titvlcob
    field wven  like fin.titulo.titvlcob.

def temp-table wgru
    field wcod like fin.titulo.clifor
    field wnome like forne.fornom
    field wmodcod like fin.titulo.modcod
    field wdes  like fin.titulo.titvlcob
    field wjur  like fin.titulo.titvlcob
    field wcob  like fin.titulo.titvlcob
    field wpag  like fin.titulo.titvlcob
    field wcre  like fin.titulo.titvlcob
    field wdeb  like fin.titulo.titvlcob
    field wven  like fin.titulo.titvlcob.

def temp-table wfor
    field wcod like fin.titulo.clifor
    field wnome like forne.fornom
    field wmodcod like fin.titulo.modcod
    field wdes  like fin.titulo.titvlcob
    field wjur  like fin.titulo.titvlcob
    field wcob  like fin.titulo.titvlcob
    field wpag  like fin.titulo.titvlcob
    field wcre  like fin.titulo.titvlcob
    field wdeb  like fin.titulo.titvlcob
    field wven  like fin.titulo.titvlcob.

def temp-table tt-exp
    field ano as int format "9999"
    field mes as int format "99"
    field datpag as date format "99/99/9999"
    field ccusto as int format ">>9"
    field desccc as char 
    field etbcod like estab.etbcod
    field cidade as char
    field grucod as int 
    field grumod like fin.modal.modcod
    field grunom as char
    field codmod as int
    field modcod like fin.modal.modcod
    field modnom as char
    field forcod as int  format ">>>>>>>>9"
    field fornom as char
    field titnum like fin.titulo.titnum
    field valor as dec
    field valcre as dec
    field valdeb as dec
    index i1 etbcod ano mes datpag
    .
    
def var vcob like fin.titulo.titvlpag.
def var vpag like fin.titulo.titvlpag.
def var vdes like fin.titulo.titvlpag.
def var vjur like fin.titulo.titvlpag.
def var vacum like fin.titulo.titvlpag.
def var vlog as log.
def var vdt as date.
def var vmodcod like fin.modal.modcod.
def temp-table wmodal like fin.modal.
def var wtotger like fin.titulo.titvlcob.
def var vnome like clien.clinom.
def var recatu2 as recid.
def var vtitrel     as char format "x(50)".
def var wetbcod like fin.titulo.etbcod initial 0.
def var wmodcod like fin.titulo.modcod initial "".
def var wtitnat like fin.titulo.titnat.
def var wclifor like fin.titulo.clifor initial 0.
def var wclicod like clien.clicod initial 0.
def var wdti    like fin.titulo.titdtven label "Periodo" initial today.
def var wdtf    like fin.titulo.titdtven.
def var wtitvlcob like fin.titulo.titvlcob.
def var wtot      as dec format ">,>>>,>>>,>>9.99" label "Total".
def var wseq as i extent 2.
def var i as i.
def var wbar as c label "/" initial "/" format "x".
def var wclfnom as char format "x(30)" label "clfnom".
def var wforcli as i format "999999" label "For/Cli".

wdtf = today.
wtotger = 0.
def var vven as dec.
form with frame f-pag.
def buffer bestab for estab.
def var vpfor as log format "Sim/Nao".
def var vana as log format "Sim/Nao".
def var valor as char.

repeat with column 50 side-labels 1 down width 31 row 4 frame f1:

    disp "" @ wetbcod colon 12.
    update wetbcod label "Estabelec." .
    if  wetbcod <> 0
    then do: 
        find estab where estab.etbcod =  wetbcod no-lock.
        display etbnom no-label format "x(10)".
    end. 
    
    else disp "TODOS" @ etbnom.
    update wmodcod validate(wmodcod = "" or
                            can-find(fin.modal where 
                                     fin.modal.modcod = wmodcod),
                            "Modalidade nao cadastrada")
                            label "Modal/Natur" colon 12.
    display " - ".
    if wmodcod = "CRE"
       then wtitnat = no.
    wtitnat = yes.
    update wtitnat no-label.
    repeat:
        
       for each wpag:
            delete wpag.
       end.
       for each wfor:
        delete wfor.
       end. 
         clear frame ff.
        clear frame fc.
        if wtitnat
           then do with column 1 side-labels 1 down width 48 row 4 frame ff:
             disp "" @ wclifor.
             update wclifor label "Fornecedor"
                help "Informe o codigo do Fornecedor ou <ENTER> para todos".
             if input wclifor <> "" and wclifor <> 0
                then do:
                        find forne where forne.forcod = input wclifor.
                        display fornom format "x(32)" no-label at 10.
                end.
                else disp "RELATORIO DE TODOS OS FORNECEDORES" @ fornom.
           end.
           else do with column 1 side-labels 1 down width 48 row 4 frame fc:
             disp "" @ wclicod.
             prompt-for wclicod label "Cliente"
                help "Informe o codigo do Cliente ou <ENTER> para todos".
             if input wclicod <> ""
                then do:
                        find clien where clien.clicod = input wclicod.
                        display clinom format "x(32)" no-label at 10.
                end.
                else disp "RELATORIO DE TODOS OS CLIENTES" @ clinom.
           end.
        if not wtitnat
        then wclifor = wclicod.
        else wclifor = wclifor.
        
        def var vad-setcod like setaut.setcod.
        update vad-setcod label "Setor" with frame f-sel
            side-label 1 down width 80 no-box color message.
        if vad-setcod <> 0
        then do:
            find setaut where setaut.setcod = vad-setcod no-lock.
            disp setaut.setnom no-label with frame f-sel.
        end.
        else disp "Relatorio geral" @ setaut.setnom with frame f-sel.

        
        form wdti colon 12
             " A"
             wdtf colon 29 no-label with frame fdat width 80 side-label.

        update wdti
               wdtf with frame fdat.
               
        for each wmodal:
            delete wmodal.
        end.
        if wmodcod = ""
        then do:
            for each fin.modal where fin.modal.modcod <> "DEV"
                                 and fin.modal.modcod <> "BON"
                                 and fin.modal.modcod <> "CHP" no-lock:
                create wmodal.
                assign wmodal.modcod = fin.modal.modcod
                       wmodal.modnom = fin.modal.modnom.
            end.
            vlog = no.
            repeat:
                vmodcod = "DUP".
                find first wmodal where wmodal.modcod = vmodcod
                                                            no-lock no-error.
                if avail wmodal
                then delete wmodal.
                vlog = yes.
                leave.
            end.
        end.
        else do:
            find first modgru where modgru.mogsup = 0 and
                              modgru.modcod = wmodcod
                              no-lock no-error.
            if avail modgru
            then do:
                for each bmodgru where 
                         bmodgru.mogsup = modgru.mogcod
                         no-lock:
                    find fin.modal where
                        fin.modal.modcod = bmodgru.modcod no-lock.
                    
                    create wmodal.
                    assign wmodal.modcod = fin.modal.modcod
                           wmodal.modnom = fin.modal.modnom.
                end.             
            end.
            else do:
                find fin.modal where fin.modal.modcod = wmodcod no-lock.
                create wmodal.
                assign wmodal.modcod = wmodcod
                   wmodal.modnom = fin.modal.modnom.
            end.
            vlog = yes.
        end.
        
        wtot = 0.
        vtitrel = if wtitnat
                  then "PAGAR"
                  else "RECEBER" .
        if wclifor = 0
        then vv = "GERAL".
        else vv = forne.fornom.
        
        vacum = 0.
        vcob  =  0.
        vjur  =  0.
        vdes  =  0.
        vpag  =  0.

        if opsys = "UNIX"
        then varquivo = "/admcom/relat/exp_pag1.csv".
        else varquivo = "l:\admcom\relat\exp_pag1.csv".

        update varquivo label "Arquivo"  format "x(60)"
                with frame f-arq 1 down side-label width 80.
        
        do vdt = wdti to wdtf:
            disp vdt with frame f-dt 1 down
                centered no-label no-box color message.
            pause 0.    
            for each wmodal:
                find modgru where modgru.modcod = wmodal.modcod and
                                  modgru.mogsup <> 0
                                no-lock no-error.
                if avail modgru
                then
                find bmodgru where bmodgru.mogcod = modgru.mogsup and
                                   bmodgru.mogsup = 0
                                no-lock no-error.
                for each fin.titulo where fin.titulo.empcod = wempre.empcod and
                                      fin.titulo.titnat =   wtitnat   and
                                      fin.titulo.modcod = wmodal.modcod and
                                      fin.titulo.titdtpag =  vdt        and
                                ( if wetbcod = 0
                                     then true
                                     else fin.titulo.etbcod = wetbcod ) and
                                ( if wclifor = 0
                                     then true
                                     else fin.titulo.clifor = wclifor ) and
                                  fin.titulo.titsit   =   "PAG" no-lock:

                    if fin.titulo.titvlpag <= 0
                    then next.
                    
                    find first titudesp where
                               titudesp.empcod = fin.titulo.empcod and
                               titudesp.titnat = fin.titulo.titnat and
                               titudesp.modcod = fin.titulo.modcod and
                               titudesp.etbcod = fin.titulo.etbcod and
                               titudesp.clifor = fin.titulo.clifor and
                               titudesp.titnum = fin.titulo.titnum and
                               titudesp.titdtemi = fin.titulo.titdtemi
                               no-lock no-error.
                    if avail titudesp and vdt > 06/30/13
                    then next. 
                    

                    cc-desc = "".
                    find bestab where bestab.etbcod = fin.titulo.etbcod
                            no-lock.
                    find forne where forne.forcod = fin.titulo.clifor no-lock
                                no-error.
                    if wclifor <> 0 and
                       wclifor <> fin.titulo.clifor
                    then next.
                       
                    vsetcod = 0.
                    if  fin.titulo.titbanpag > 0 
                    then vsetcod = fin.titulo.titbanpag.

                    if avail forne
                    then
                    find foraut where foraut.forcod = forne.forcod
                                no-lock no-error.
                    if avail foraut and
                       vsetcod = 0
                    then vsetcod = foraut.setcod.
                       
                    if vad-setcod <> 0
                        and vad-setcod <> vsetcod
                    then next.
                    find first setaut where setaut.setcod = vsetcod
                            no-lock no-error.
                    if avail setaut
                    then cc-desc = setaut.setnom.

                    create tt-exp.
                    assign 
                        tt-exp.ano = year(fin.titulo.titdtpag)
                        tt-exp.mes = month(fin.titulo.titdtpag)
                        tt-exp.datpag = fin.titulo.titdtpag
                        tt-exp.ccusto = vsetcod
                        tt-exp.desccc = cc-desc
                        tt-exp.etbcod = fin.titulo.etbcobra
                        tt-exp.cidade = bestab.munic
                        .
                    if avail bmodgru
                    then assign    
                        tt-exp.grucod = bmodgru.mogcod
                        tt-exp.grumod = bmodgru.modcod
                        tt-exp.grunom = bmodgru.mognom
                        .
                    if avail modgru
                    then tt-exp.codmod = modgru.mogcod.
                    assign    
                        tt-exp.modcod = fin.titulo.modcod
                        tt-exp.modnom = wmodal.modnom
                        tt-exp.forcod = fin.titulo.clifor
                        tt-exp.fornom = if avail forne
                                then forne.fornom else ""
                        tt-exp.titnum = fin.titulo.titnum 
                        tt-exp.valor  = fin.titulo.titvlpag
                        .
                        
                    if fin.titulo.etbcobra = ? or
                       fin.titulo.etbcobra = 0
                    then tt-exp.etbcod = fin.titulo.etbcod.
                       
                end.
                
                run fin-titudesp.
                
                for each fin.titluc where fin.titluc.empcod = wempre.empcod and
                                      fin.titluc.titnat =   no          and
                                      fin.titluc.modcod = wmodal.modcod and
                                      fin.titluc.titdtpag =  vdt /*       and
                                ( if wetbcod = 0
                                     then true
                                     else fin.titluc.etbcod = wetbcod ) and
                                ( if wclifor = 0
                                     then true
                                     else fin.titluc.clifor = wclifor )*/ and
                                  fin.titluc.titsit   =   "PAG" and
                                  fin.titluc.evecod = 8 no-lock:
                    if fin.titluc.titbanpag = 0 then next.
                    if vad-setcod > 0 
                    then do:
                        if fin.titluc.titbanpag > 0 and
                            fin.titluc.titbanpag <> vad-setcod
                        then do:
                            next.
                        end.    
                        if fin.titluc.titbanpag = 0
                        then do:
                            find first foraut where
                                   foraut.forcod = fin.titluc.clifor
                                   no-lock no-error.
                            if avail foraut 
                            then do:
                                if foraut.setcod <> vad-setcod 
                                then next.
                            end.
                            else next.
                        end.
                    end.    

                    if  fin.titluc.titbanpag > 0 
                    then vsetcod = fin.titluc.titbanpag.

                    find forne where forne.forcod = fin.titluc.clifor no-lock.
                    if avail forne
                    then
                    find foraut where foraut.forcod = forne.forcod
                                no-lock no-error.
                    if avail foraut and
                       vsetcod = 0
                    then vsetcod = foraut.setcod.
 
                     if vad-setcod <> 0
                        and vad-setcod <> vsetcod
                    then next.
 
                    cc-desc = "".
                    find bestab where bestab.etbcod = fin.titluc.etbcod
                            no-lock.
                    find first setaut where setaut.setcod = vsetcod
                            no-lock no-error.
                    if avail setaut
                    then cc-desc = setaut.setnom.

                    create tt-exp.
                    assign 
                        tt-exp.ano = year(fin.titluc.titdtpag)
                        tt-exp.mes = month(fin.titluc.titdtpag)
                        tt-exp.datpag = fin.titluc.titdtpag
                        tt-exp.ccusto = vsetcod
                        tt-exp.desccc = cc-desc
                        tt-exp.etbcod = fin.titluc.etbcobra
                        tt-exp.cidade = bestab.munic
                        .
                    if avail bmodgru
                    then assign    
                        tt-exp.grucod = bmodgru.mogcod
                        tt-exp.grumod = bmodgru.modcod
                        tt-exp.grunom = bmodgru.mognom
                        .
                    if avail modgru
                    then tt-exp.codmod = modgru.mogcod.
                    assign    
                        tt-exp.modcod = fin.titluc.modcod
                        tt-exp.modnom = wmodal.modnom
                        tt-exp.forcod = fin.titluc.clifor
                        tt-exp.fornom = if avail forne
                                then forne.fornom else ""
                        tt-exp.titnum = fin.titluc.titnum 
                        tt-exp.valcre  = fin.titluc.titvlpag
                        .
                        
                    if fin.titluc.etbcobra = ? or
                       fin.titluc.etbcobra = 0
                    then tt-exp.etbcod = fin.titluc.etbcod.
                     
                    /*****************
                    find first wpag where wpag.wmodcod = fin.titluc.modcod 
                                                                    no-error.
                    if not avail wpag
                    then do:
                        create wpag.
                        wpag.wmodcod = fin.titluc.modcod.
                    end.
                    find modal where modal.modcod = fin.titluc.modcod 
                                                        no-lock no-error.
                    if not avail modal
                    then wpag.wnome = "".
                    else wpag.wnome = modal.modnom.
                    
                    find first wfor where
                               wfor.wcod = fin.titluc.clifor and
                               wfor.wmodcod = fin.titluc.modcod
                                no-error.
                    if not avail wfor
                    then do:
                        create wfor.
                        assign
                            wfor.wcod = fin.titluc.clifor
                            wfor.wmodcod = fin.titluc.modcod
                            .
                    end.
                    /*****
                    find first wdoc where
                               wdoc.wcod  = fin.titluc.clifor and
                               wdoc.wmod  = fin.titluc.modcod and
                               wdoc.wnome = if fin.titluc.titobs[1] <> ""
                                then fin.titluc.titobs[1]
                                else  (fin.titluc.titnum + "/" +
                                           string(fin.titluc.titpar)) 
                               no-error.
                    if not avail wdoc
                    then do:
                        create wdoc.
                        assign
                            wdoc.wcod = fin.titluc.clifor 
                            wdoc.wmod = fin.titluc.modcod
                            wdoc.wnome = if fin.titluc.titobs[1] <> ""
                                then fin.titluc.titobs[1]
                                else  (fin.titluc.titnum + "/" +
                                    string(fin.titluc.titpar))
                            .
                    end. 
                    **/
                    assign            
                    wpag.wcre  = wpag.wcre  + fin.titluc.titvlcob
                    wfor.wcre  = wfor.wcre  + fin.titluc.titvlcob.
                    /*wdoc.wcre  = wdoc.wcre  + fin.titluc.titvlcob.
                      */
                    *************/
                    
                end.
                /**/
                for each fin.titluc where fin.titluc.empcod = wempre.empcod and
                                      fin.titluc.titnat =   yes          and
                                      fin.titluc.modcod = wmodal.modcod and
                                      fin.titluc.titdtpag =  vdt /*       and
                                ( if wetbcod = 0
                                     then true
                                     else fin.titluc.etbcod = wetbcod ) and
                                ( if wclifor = 0
                                     then true
                                     else fin.titluc.clifor = wclifor )*/ and
                                  fin.titluc.titsit   =   "PAG" and
                                  fin.titluc.evecod = 9 no-lock:
                    if fin.titluc.titbanpag = 0 then next.

                    /* Diretores */
                    /*disp fin.titluc.titnum with frame f-proc.
                    pause 0.*/
                    if vad-setcod > 0 
                    then do:
                        if fin.titluc.titbanpag > 0 and
                            fin.titluc.titbanpag <> vad-setcod
                        then do:
                            next.
                        end.    
                        if fin.titluc.titbanpag = 0
                        then do:
                            find first foraut where
                                   foraut.forcod = fin.titluc.clifor
                                   no-lock no-error.
                            if avail foraut 
                            then do:
                                if foraut.setcod <> vad-setcod 
                                then next.
                            end.
                            else next.
                        end.
                    end.    
                    if  fin.titluc.titbanpag > 0 
                    then vsetcod = fin.titluc.titbanpag.

                    find forne where forne.forcod = fin.titluc.clifor no-lock.
                    if avail forne
                    then
                    find foraut where foraut.forcod = forne.forcod
                                no-lock no-error.
                    if avail foraut and
                       vsetcod = 0
                    then vsetcod = foraut.setcod.
 
                    if vad-setcod <> 0
                        and vad-setcod <> vsetcod
                    then next.
                    cc-desc = "".
                    find bestab where bestab.etbcod = fin.titluc.etbcod
                            no-lock.
                    find first setaut where setaut.setcod = vsetcod
                            no-lock no-error.
                    if avail setaut
                    then cc-desc = setaut.setnom.

                    create tt-exp.
                    assign 
                        tt-exp.ano = year(fin.titluc.titdtpag)
                        tt-exp.mes = month(fin.titluc.titdtpag)
                        tt-exp.datpag = fin.titluc.titdtpag
                        tt-exp.ccusto = vsetcod
                        tt-exp.desccc = cc-desc
                        tt-exp.etbcod = fin.titluc.etbcobra
                        tt-exp.cidade = bestab.munic
                        .
                    if avail bmodgru
                    then assign    
                        tt-exp.grucod = bmodgru.mogcod
                        tt-exp.grumod = bmodgru.modcod
                        tt-exp.grunom = bmodgru.mognom
                        .
                    if avail modgru
                    then tt-exp.codmod = modgru.mogcod.
                    assign    
                        tt-exp.modcod = fin.titluc.modcod
                        tt-exp.modnom = wmodal.modnom
                        tt-exp.forcod = fin.titluc.clifor
                        tt-exp.fornom = if avail forne
                                then forne.fornom else ""
                        tt-exp.titnum = fin.titluc.titnum 
                        tt-exp.valdeb  = fin.titluc.titvlpag
                        .
                        
                    if fin.titluc.etbcobra = ? or
                       fin.titluc.etbcobra = 0
                    then tt-exp.etbcod = fin.titluc.etbcod.
                    
                    
                    /**************
                    find first wpag where wpag.wmodcod = fin.titluc.modcod 
                                                                    no-error.
                    if not avail wpag
                    then do:
                        create wpag.
                        wpag.wmodcod = fin.titluc.modcod.
                    end.
                    find modal where modal.modcod = fin.titluc.modcod 
                                                        no-lock no-error.
                    if not avail modal
                    then wpag.wnome = "".
                    else wpag.wnome = modal.modnom.
                    
                    find first wfor where
                               wfor.wcod = fin.titluc.clifor and
                               wfor.wmodcod = fin.titluc.modcod
                                no-error.
                    if not avail wfor
                    then do:
                        create wfor.
                        assign
                            wfor.wcod = fin.titluc.clifor
                            wfor.wmodcod = fin.titluc.modcod
                            .
                    end.
                    /***
                    find first wdoc where
                               wdoc.wcod  = fin.titluc.clifor and
                               wdoc.wmod  = fin.titluc.modcod and
                               wdoc.wnome = if fin.titluc.titobs[1] <> ""
                                then fin.titluc.titobs[1]
                                else  (fin.titluc.titnum + "/" +
                                           string(fin.titluc.titpar)) 
                               no-error.
                    if not avail wdoc
                    then do:
                        create wdoc.
                        assign
                            wdoc.wcod = fin.titluc.clifor 
                            wdoc.wmod = fin.titluc.modcod
                            wdoc.wnome = if fin.titluc.titobs[1] <> ""
                                then fin.titluc.titobs[1]
                                else  (fin.titluc.titnum + "/" +
                                    string(fin.titluc.titpar))
                            .
                    end.
                     ***/
                    assign            
                    wpag.wdeb  = wpag.wdeb  + fin.titluc.titvlcob
                    wfor.wdeb  = wfor.wdeb  + fin.titluc.titvlcob
                    /*wdoc.wdeb  = wdoc.wdeb  + fin.titluc.titvlcob*/.
                    **************/
                end.
                
                /***********************
                if vesc
                then do:
                    for each banfin.titulo where 
                             banfin.titulo.empcod = wempre.empcod and
                             banfin.titulo.titnat = wtitnat   and
                             banfin.titulo.modcod = wmodal.modcod and
                             banfin.titulo.titdtpag =  vdt        and
                                ( if wetbcod = 0
                                  then true
                                  else banfin.titulo.etbcod = wetbcod ) and
                                ( if wclifor = 0
                                  then true
                                  else banfin.titulo.clifor = wclifor ) and
                                       banfin.titulo.titsit =   "PAG" no-lock:
                        
                        if banfin.titulo.titvlpag <= 0
                        then next.
    
                        find first titudesp where
                               titudesp.empcod = banfin.titulo.empcod and
                               titudesp.titnat = banfin.titulo.titnat and
                               titudesp.modcod = banfin.titulo.modcod and
                               titudesp.etbcod = banfin.titulo.etbcod and
                               titudesp.clifor = banfin.titulo.clifor and
                               titudesp.titnum = banfin.titulo.titnum and
                               titudesp.titdtemi = banfin.titulo.titdtemi
                               no-lock no-error.
                        if avail titudesp and vdt > 06/30/13
                        then  next. 
                        
                        find bestab where bestab.etbcod = banfin.titulo.etbcod
                            no-lock.
                        find forne where 
                            forne.forcod = banfin.titulo.clifor no-lock
                            no-error.
                    
                        if wclifor <> 0 and
                           wclifor <> banfin.titulo.clifor
                        then next.
                           
                        vsetcod = 0.
                        if banfin.titulo.titbanpag > 0 
                        then vsetcod = banfin.titulo.titbanpag.

                        if avail forne
                        then
                        find foraut where foraut.forcod = forne.forcod
                                no-lock no-error.
                        if avail foraut and
                        vsetcod = 0
                        then vsetcod = foraut.setcod.
                       
                        if vad-setcod <> 0 
                            and vad-setcod <> vsetcod
                        then next.
                            
                        find first setaut where setaut.setcod = vsetcod
                            no-lock no-error.
                        if avail setaut
                        then cc-desc = setaut.setnom.

                        create tt-exp.
                        assign 
                            tt-exp.ano = year(banfin.titulo.titdtpag)
                            tt-exp.mes = month(banfin.titulo.titdtpag)
                            tt-exp.datpag = banfin.titulo.titdtpag
                            tt-exp.ccusto = vsetcod
                            tt-exp.desccc = cc-desc
                            tt-exp.etbcod = banfin.titulo.etbcobra
                            tt-exp.cidade = bestab.munic
                            .
                        if avail bmodgru
                        then assign    
                            tt-exp.grucod = bmodgru.mogcod
                            tt-exp.grumod = bmodgru.modcod
                            tt-exp.grunom = bmodgru.mognom
                            .
                        if avail modgru
                        then tt-exp.codmod = modgru.mogcod.
                        assign    
                            tt-exp.modcod = banfin.titulo.modcod
                            tt-exp.modnom = wmodal.modnom
                            tt-exp.forcod = banfin.titulo.clifor
                            tt-exp.fornom = if avail forne
                                    then forne.fornom else ""
                            tt-exp.titnum = banfin.titulo.titnum 
                            tt-exp.valor  = banfin.titulo.titvlpag
                            .
                        if banfin.titulo.etbcobra = ? or
                           banfin.titulo.etbcobra = 0
                        then tt-exp.etbcod = banfin.titulo.etbcod.

                    end.
                    for each  banfin.titluc where 
                             banfin.titluc.empcod = wempre.empcod and
                             banfin.titluc.titnat = no            and
                             banfin.titluc.modcod = wmodal.modcod and
                             banfin.titluc.titdtpag =  vdt        and
                                ( if wetbcod = 0
                                  then true
                                  else banfin.titluc.etbcod = wetbcod ) and
                                ( if wclifor = 0
                                  then true
                                  else banfin.titluc.clifor = wclifor ) and
                                       banfin.titluc.titsit = "PAG" and
                                       banfin.titluc.evecod = 8 no-lock:
                                       
                        if banfin.titluc.titbanpag = 0 then next.
                        /* diretores */               
                        disp banfin.titluc.titnum with frame f-proc.
                        pause 0.
                        if vsetcod > 0 
                        then do:
                            if  banfin.titluc.titbanpag > 0 and
                            banfin.titluc.titbanpag <> vsetcod
                            then next.
                            if banfin.titluc.titbanpag = 0
                            then do:
                                find first foraut where
                                   foraut.forcod = banfin.titluc.clifor
                                   no-lock no-error.
                                if avail foraut 
                                then do:
                                    if foraut.setcod <> vsetcod 
                                    then next.
                                end.
                                else next.
                            end.
                        end.

                        find first wpag where wpag.wmodcod = 
                                            banfin.titluc.modcod no-error.
                        if not avail wpag
                        then do:
                            create wpag.
                            assign wpag.wcod    = banfin.titluc.clifor
                                   wpag.wmodcod = banfin.titluc.modcod.
                        end.
                        find modal where modal.modcod = banfin.titluc.modcod 
                                                            no-lock no-error.
                        if not avail modal
                        then wpag.wnome = "".
                        else wpag.wnome = modal.modnom.
                        find first wfor where
                               wfor.wcod = banfin.titluc.clifor and
                               wfor.wmodcod = banfin.titluc.modcod
                                no-error.
                        if not avail wfor
                        then do:
                            create wfor.
                            assign
                                wfor.wcod = banfin.titluc.clifor
                                wfor.wmodcod = banfin.titluc.modcod
                                .
                        end.
                        find first wdoc where
                               wdoc.wcod  = banfin.titluc.clifor and
                               wdoc.wmod  = banfin.titluc.modcod and
                               wdoc.wnome = if banfin.titluc.titobs[1] <> ""
                                then banfin.titluc.titobs[1]
                                else  (banfin.titluc.titnum + "/" +
                                           string(banfin.titluc.titpar)) 
                               no-error.
                    if not avail wdoc
                    then do:
                        create wdoc.
                        assign
                            wdoc.wcod = banfin.titluc.clifor 
                            wdoc.wmod = banfin.titluc.modcod
                            wdoc.wnome = if banfin.titluc.titobs[1] <> ""
                                then banfin.titluc.titobs[1]
                                else  (banfin.titluc.titnum + "/" +
                                    string(banfin.titluc.titpar))
                            .
                    end. 

                        assign            
                        wpag.wcre  = wpag.wcre  + banfin.titluc.titvlcob
                        wfor.wcre  = wfor.wcre  + banfin.titluc.titvlcob
                        wdoc.wcre  = wdoc.wcre  + banfin.titluc.titvlcob
                        .
                   end.
                   /*** Debito ***/
                   for each  banfin.titluc where 
                             banfin.titluc.empcod = wempre.empcod and
                             banfin.titluc.titnat = yes            and
                             banfin.titluc.modcod = wmodal.modcod and
                             banfin.titluc.titdtpag =  vdt        and
                                ( if wetbcod = 0
                                  then true
                                  else banfin.titluc.etbcod = wetbcod ) and
                                ( if wclifor = 0
                                  then true
                                  else banfin.titluc.clifor = wclifor ) and
                                       banfin.titluc.titsit = "PAG" and
                                       banfin.titluc.evecod = 9 no-lock:
                                       
                        if banfin.titluc.titbanpag = 0 then next.
                        /* diretores */               
                        disp banfin.titluc.titnum with frame f-proc.
                        pause 0.
                        if vsetcod > 0 
                        then do:
                            if  banfin.titluc.titbanpag > 0 and
                            banfin.titluc.titbanpag <> vsetcod
                            then next.
                            if banfin.titluc.titbanpag = 0
                            then do:
                                find first foraut where
                                   foraut.forcod = banfin.titluc.clifor
                                   no-lock no-error.
                                if avail foraut 
                                then do:
                                    if foraut.setcod <> vsetcod 
                                    then next.
                                end.
                                else next.
                            end.
                        end.

                        find first wpag where wpag.wmodcod = 
                                            banfin.titluc.modcod no-error.
                        if not avail wpag
                        then do:
                            create wpag.
                            assign wpag.wcod    = banfin.titluc.clifor
                                   wpag.wmodcod = banfin.titluc.modcod.
                        end.
                        find modal where modal.modcod = banfin.titluc.modcod 
                                                            no-lock no-error.
                        if not avail modal
                        then wpag.wnome = "".
                        else wpag.wnome = modal.modnom.
                        find first wfor where
                               wfor.wcod = banfin.titluc.clifor and
                               wfor.wmodcod = banfin.titluc.modcod
                                no-error.
                        if not avail wfor
                        then do:
                            create wfor.
                            assign
                                wfor.wcod = banfin.titluc.clifor
                                wfor.wmodcod = banfin.titluc.modcod
                                .
                        end.
                        find first wdoc where
                               wdoc.wcod  = banfin.titluc.clifor and
                               wdoc.wmod  = banfin.titluc.modcod and
                               wdoc.wnome = if banfin.titluc.titobs[1] <> ""
                                then banfin.titluc.titobs[1]
                                else  (banfin.titluc.titnum + "/" +
                                           string(banfin.titluc.titpar)) 
                               no-error.
                    if not avail wdoc
                    then do:
                        create wdoc.
                        assign
                            wdoc.wcod = banfin.titluc.clifor 
                            wdoc.wmod = banfin.titluc.modcod
                            wdoc.wnome = if banfin.titluc.titobs[1] <> ""
                                then banfin.titluc.titobs[1]
                                else  (banfin.titluc.titnum + "/" +
                                    string(banfin.titluc.titpar))
                            .
                    end. 

                        assign            
                        wpag.wdeb  = wpag.wdeb  + banfin.titluc.titvlcob
                        wfor.wdeb  = wfor.wdeb  + banfin.titluc.titvlcob
                        wdoc.wdeb  = wdoc.wdeb  + banfin.titluc.titvlcob
                        .
                   end.


                end.
                ******************/
                
            end.
        end.        
        output to value(varquivo) page-size 0.
        
        put UNFORMATTED 
        "ANO;MES;DATA PAGAMENTO;COD. CENTRO DE CUSTO;CENTRO DE CUSTO;" +
         "COD. ESTABELECIMENTO;CIDADE;" +
    "COD.GRUPO;GRUPO;COD.MODALIDADE;MODALIDADE;COD.FORNECEDOR;FORNECEDOR;" +
           "CODIGO DESPESA;VA LOR DESPESA;CREDITO;DEBITO" format "x(260)" 
           SKIP.
        
        for each tt-exp:
            vval = string(tt-exp.valor).
            vvaldeb = string(tt-exp.valdeb).
            vvalcre = string(tt-exp.valcre).
            if num-entries(vval,".") = 1
            then vval = vval + ".00".
            else if length(entry(2,vval,".")) = 1
            then vval = vval + "0".

            vval = replace(vval,".",";").
            vval = replace(vval,",",".").
            vval = replace(vval,";",",").

            if num-entries(vvaldeb,".") = 1
            then vvaldeb = vvaldeb + ".00".
            else if length(entry(2,vvaldeb,".")) = 1
            then vvaldeb = vvaldeb + "0".

            vvaldeb = replace(vvaldeb,".",";").
            vvaldeb = replace(vvaldeb,",",".").
            vvaldeb = replace(vvaldeb,";",",").

            if num-entries(vvalcre,".") = 1
            then vvalcre = vvalcre + ".00".
            else if length(entry(2,vvalcre,".")) = 1
            then vvalcre = vvalcre + "0".

            vvalcre = replace(vvalcre,".",";").
            vvalcre = replace(vvalcre,",",".").
            vvalcre = replace(vvalcre,";",",").

            if length(trim(vval)) < 15
            then vval = substr(string(v,"x(20)"),1,15 - length(trim(vval)))
                + trim(vval).
                
            put unformatted 
                tt-exp.ano ";"
                tt-exp.mes ";"
                tt-exp.datpag ";"
                tt-exp.ccusto ";"
                tt-exp.desccc format "x(25)" ";"
                tt-exp.etbcod format ">>>" ";"
                tt-exp.cidade format "x(25)" ";"
                tt-exp.grumod ";"
                tt-exp.grunom format "x(30)" ";"
                tt-exp.modcod ";"
                tt-exp.modnom format "x(30)" ";"
                tt-exp.forcod format ">>>>>>>>9" ";"
                tt-exp.fornom format "x(40)" ";"
                tt-exp.titnum format "x(15)" ";"
                vval format "x(15)"  ";"
                vvalcre ";"
                vvaldeb ";"
                skip .
            
            vtotal = vtotal + tt-exp.valor.
            
        end.
        output close.
        /*
        message vtotal. pause.
        */
        message color red/with
          varquivo view-as alert-box title " Arquivo gerado "
          .
        
        /*
        run visurel.p(varquivo,"").  
        leave.
        */
    end.
    leave.
end.

procedure fin-titudesp:
    for each titudesp where titudesp.empcod = wempre.empcod and
                                      titudesp.titnat =   wtitnat   and
                                      titudesp.modcod = wmodal.modcod and
                                      titudesp.titdtpag =  vdt /*       and
                                ( if wetbcod = 0
                                     then true
                                     else titudesp.etbcod = wetbcod ) and
                                ( if wclifor = 0
                                     then true
                                     else titudesp.clifor = wclifor )*/ and
                                  titudesp.titsit   =   "PAG" no-lock:
                    
                    cc-desc = "".
                    find bestab where bestab.etbcod = titudesp.etbcod
                            no-lock no-error.
                    find forne where forne.forcod = titudesp.clifor no-lock
                                no-error.
                    
                    if wclifor <> 0 and
                       wclifor <> titudesp.clifor
                    then next.
                       
                    vsetcod = 0.
                    if  titudesp.titbanpag > 0 
                    then vsetcod = titudesp.titbanpag.

                    if avail forne
                    then
                    find foraut where foraut.forcod = forne.forcod
                                no-lock no-error.
                    if avail foraut and
                       vsetcod = 0
                    then vsetcod = foraut.setcod.
                       
                    if vad-setcod <> 0 
                        and vad-setcod <> vsetcod
                    then next.
                        
                    find first setaut where setaut.setcod = vsetcod
                            no-lock no-error.
                    if avail setaut
                    then cc-desc = setaut.setnom.

                    create tt-exp.
                    assign 
                        tt-exp.ano = year(titudesp.titdtpag)
                        tt-exp.mes = month(titudesp.titdtpag)
                        tt-exp.datpag = titudesp.titdtpag
                        tt-exp.ccusto = vsetcod
                        tt-exp.desccc = cc-desc
                        tt-exp.etbcod = titudesp.etbcobra
                        tt-exp.cidade = bestab.munic
                        .
                    if avail bmodgru
                    then assign    
                        tt-exp.grucod = bmodgru.mogcod
                        tt-exp.grumod = bmodgru.modcod
                        tt-exp.grunom = bmodgru.mognom
                        .
                    if avail modgru
                    then tt-exp.codmod = modgru.mogcod.
                    assign    
                        tt-exp.modcod = titudesp.modcod
                        tt-exp.modnom = wmodal.modnom
                        tt-exp.forcod = titudesp.clifor
                        tt-exp.fornom = if avail forne
                                then forne.fornom else ""
                        tt-exp.titnum = titudesp.titnum 
                        tt-exp.valor  = titudesp.titvlpag
                        .
                        
                    if titudesp.etbcobra = ? or
                       titudesp.etbcobra = 0
                    then tt-exp.etbcod = titudesp.etbcod.
 
 
                    
    end.

end procedure.

