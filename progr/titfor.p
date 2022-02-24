{admcab.i}
{def.i}
esqcom2[1] = "".
def var vsetcod like setaut.setcod.
def var v-agendado as char format "x" label "A".
def var taxa-ante as dec format ">>9.99".
def var deletou-lancxa as log.
def var vfrecod like frete.frecod.
def var vv as int.
def var vlfrete like plani.platot.
def var vfre as int format "9" initial 1.
def buffer ftitulo for titulo.
def buffer ztitulo for titulo.

def var valor-ori as char.

def var vdt like plani.pladat.
def var vcompl like lancxa.comhis format "x(50)".
def var vlanhis like lancxa.lanhis.
def var vnumlan as int.
def buffer blancxa for lancxa.
def var vlancod like lancxa.lancod.
esqpos1  = 1. esqpos2  = 1.
def var vtitle  as char.
if avail setaut
then vtitle = setaut.setnom.
else vtitle = "FINANCEIRO".
form with frame ff1 title "   " + vtitle  + "   ".
repeat:
    for each wtit:
        delete wtit.
    end.
    clear frame ff1 all.
    assign recatu1  = ?.
    hide frame f-com1 no-pause.
    hide frame f-com2 no-pause.
    update vetbcod validate(can-find(estab where estab.etbcod = vetbcod),
                   "Estabelecimento Invalido") colon 18 with frame ff1.
    find estab where estab.etbcod = vetbcod no-lock.
    display estab.etbnom no-label with frame ff1.
    do on error undo:
        update vmodcod validate(can-find(modal where modal.modcod = vmodcod),
                                "Modalidade Invalida") colon 18 with frame ff1.
        find modal where modal.modcod = vmodcod NO-LOCK.
        display modal.modnom no-label with frame ff1.
        if modcod = "CRE"
        then do:
            message "modalidade invalida".
            undo, retry.
        end.
    end.
    do on error undo:
        vtitnat = yes.
        update vtitnat colon 18
               with frame ff1 side-labels row 3 width 80 color white/cyan.
    end.

    /**
    hide frame ff1 no-pause.
    display vetbcod vmodcod vtitnat
            with frame ff no-box row 3 side-labels color white/red width 81.
    **/
    vcliforlab = /* if vtitnat
                 then */ "Fornecedor:".
                 /* else "   Cliente:". */
    lclifor = if vtitnat
              then no
              else yes .
    display vcliforlab no-labels to 19 with frame ff1.
    update vforcod no-label with frame ff1.
    find forne where forne.forcod = vforcod NO-LOCK.
    vclifor = forne.forcod.
    if avail clien
    then vclifornom = forne.fornom.
    
    hide frame ff1 no-pause.
    display vetbcod vmodcod vtitnat
            vcliforlab no-label at 1 vforcod no-label forne.fornom no-label
            with frame ff no-box row 3 side-labels color white/red width 81.
bl-princ:
repeat :
    hide frame f-set no-pause.
    disp esqcom1 with frame f-com1.
    disp esqcom2 with frame f-com2.
    if recatu1 = ?
    then find first titulo use-index titdtven
                    where titulo.empcod   = wempre.empcod and
            titulo.titnat   = vtitnat       and
            titulo.modcod   = vmodcod       and
            titulo.etbcod   = vetbcod       and
            titulo.clifor   = vclifor NO-LOCK no-error.
    else find titulo where recid(titulo) = recatu1 NO-LOCK.
    vinicio = no.
    if not available titulo
    then do:
        message "Cadastro de Titulos Vazio".
        message "Deseja Incluir ?" update sresp.
        if not sresp then undo.
        do ON ERROR UNDO with frame ftit2:
                /* vtitnum = "". */
                vsetcod = 0.
                run setor-aut.
                vtitpar = 1.
                update vtitnum vtitpar.
                find first btitulo where btitulo.empcod   = wempre.empcod and
                                         btitulo.titnat   = vtitnat       and
                                         btitulo.modcod   = vmodcod       and
                                         btitulo.etbcod   = vetbcod       and
                                         btitulo.clifor   = vclifor       and
                                         btitulo.titnum   = vtitnum       and
                                         btitulo.titpar   = vtitpar
                                    NO-LOCK no-error.
                if avail btitulo
                then do:
                    message "Titulo ja Existe".
                    undo, retry.
                end.
                update vtitdtemi
                       vtotal label "Total".
                i = 0.
                vt = 0.
                ii = 0.
                vtot = 0.
                do i = 1 to vtitpar:
                    vdia = 0.
                    display i column-label "Pr" with frame f-par.
                    update vdia column-label "dias"
                                with frame f-par centered color message.
                    vvenc = vtitdtemi + /*vdia*/ 3.
                    update vvenc validate((vvenc < (vtitdtemi + 3)),  
                            "Data invalida")
                        column-label "Venc." with frame f-par.
                    create titulo.
                    assign titulo.exportado = yes
                           titulo.empcod = wempre.empcod
                           titulo.titsit = "lib"
                           titulo.titnat = vtitnat
                           titulo.modcod = vmodcod
                           titulo.etbcod = vetbcod
                           titulo.datexp = today
                           titulo.clifor = vclifor
                           titulo.titnum = vtitnum
                           titulo.titpar  = i
                           titulo.titdtemi = vtitdtemi
                           titulo.titdtven = vvenc
                           titulo.titbanpag = vsetcod.
                    titulo.titvlcob = (vtotal - vt) / (vtitpar - ii).
                    ii = ii + 1.
                    do on error undo:
                        update titulo.titvlcob with frame f-par.
                        vt = vt + titulo.titvlcob.
                        if vt <> vtotal and ii = vtitpar
                        then do:
                        message "Valor das prestacoes nao confere com o total".
                            undo, retry.
                        end.
                    end.
                    create wtit.
                    assign wtit.wrec = recid(titulo).
                end.
                update vcobcod.
                find cobra where cobra.cobcod = vcobcod NO-LOCK.
                display cobra.cobnom  no-label.
                if  cobra.cobban then do with frame fbanco2.
                    update vbancod.
                    find banco where banco.bancod = vbancod NO-LOCK.
                    display banco.bandesc .
                    update vagecod.
                    find agenc of banco where agenc.agecod = vagecod NO-LOCK.
                    display agedesc.
                end.
                wperjur = 0.
                update vevecod.
                find event where event.evecod = vevecod no-lock.
                display event.evenom no-label.
                update wperjur with frame fjurdes2.
                vtitvljur = 0.
                update vtitvljur column-label "Juros" with frame fjurdes2.
                wperdes = 0.
                update vtitdtdes
                       wperdes
                       vtitvldes format ">>>,>>9.99"
                        with frame fjurdes2 no-validate.

                update text(vtitobs) with frame fobs2. pause 0.
                  /***********/
                vlancod = 0.
                vlanhis = 0.
                vcompl  = "".
                if vtitnat = yes
                then do on error undo, retry:
                
                    hide frame ff no-pause.
                    hide frame ff1 no-pause.
                    hide frame fdadpg no-pause.
                    hide frame f-com1 no-pause.
                    hide frame f-com2 no-pause.
                    hide frame ftitulo no-pause.
                    hide frame ftit    no-pause.
                    hide frame ftit2   no-pause.
                    hide frame fbancpg no-pause.
                    hide frame fbanco  no-pause.
                    hide frame fbanco2 no-pause.
                    hide frame fjurdes no-pause.
                    hide frame fjurdes2 no-pause.
                    hide frame fobs2  no-pause.
                    hide frame fobs   no-pause.
                    hide frame fpag1  no-pause.


                    if vclifor = 533
                    then vlanhis = 5.
                    
                    if vclifor = 100071
                    then vlanhis = 4.

                    if vclifor = 100072
                    then vlanhis = 3.

                    if titulo.modcod = "DUP"
                    then assign vlancod = 100
                                vlanhis = 1.
                    /*
                    find first lanaut where 
                               lanaut.etbcod = ? and
                               lanaut.forcod = ? and
                               lanaut.modcod = titulo.modcod
                               no-lock no-error.
                    if avail lanaut
                    then do:
                        assign
                            vlancod = lanaut.lancod
                            vlanhis = lanaut.lanhis
                            .
                    end. 
                    */          
                    else do:   
       
                        find last blancxa where blancxa.forcod = forne.forcod
                                            and  blancxa.etbcod = titulo.etbcod
                                            and  blancxa.lantip = "C"
                                            no-lock no-error.
                        if avail blancxa
                        then assign vlancod = blancxa.lancod
                                    vlanhis = blancxa.lanhis
                                    vcompl  = blancxa.comhis.
                     
                        if vclifor = 533
                        then vlanhis = 5.
                    
                        if vclifor = 100071
                        then vlanhis = 4.

                        if vclifor = 100072
                        then vlanhis = 3.
                        
                        find lanaut where lanaut.etbcod = titulo.etbcod and
                                           lanaut.forcod = titulo.clifor
                                                no-lock no-error.
                        if avail lanaut
                        then do:
                            assign vlancod = lanaut.lancod
                                   vlanhis = lanaut.lanhis.
                        end.

                     
                        if vlancod = 0 or
                           vlanhis = 0
                        then
                        
                        update vlancod label "Lancamento"
                               vlanhis label "Historico"
                                      with frame lanca centered side-label
                                                row 15 overlay.
                    end.                            
                    find tablan where tablan.lancod = vlancod no-lock no-error.
                    if vlanhis = 150
                    then vcompl = tablan.landes.
                    else if vlanhis <> 2
                         then vcompl = titulo.titnum 
                                    + "-" + string(titulo.titpar) 
                                    + " " + forne.fornom.
                         else vcompl = forne.fornom.

                    find lanaut where lanaut.etbcod = titulo.etbcod and
                                      lanaut.forcod = titulo.clifor
                                                no-lock no-error.
                    if avail lanaut 
                    then do: 
                        assign vlanhis = lanaut.lanhis
                               vcompl  = lanaut.comhis
                               vlancod = lanaut.lancod.
                    end.
     
                         
                    if vlancod <> 100
                    then update vcompl  label "Complemento"
                             with frame lanca centered side-label
                                   row 15 overlay.
                    if vlancod = 0
                    then do:
                        message "Lancamento Invalido".
                        undo, retry.
                    end.
                    if vlanhis = 6
                    then vcompl = "".
                     
                end.
                titulo.vencod = vlancod.
                titulo.titnumger = vcompl.
                titulo.titparger = vlanhis.
                /***********/
                
                for each wtit:
                    find titulo where recid(titulo) = wtit.wrec.
                    assign titulo.cobcod   = cobra.cobcod
                           titulo.bancod   = vbancod
                           titulo.agecod   = vagecod
                           titulo.evecod   = event.evecod
                           titulo.titvljur = vtitvljur
                           titulo.titdtdes = vtitdtdes
                           titulo.titvldes = vtitvldes
                           titulo.titobs[1] = vtitobs[1]
                           titulo.titobs[2] = vtitobs[2].
                end.
                vinicio = yes.
                recatu1 = recid(titulo).
                next.

        end.
    end.
    clear frame frame-a all no-pause.
    view frame ff.
    if acha("AGENDAR",titulo.titobs[2]) <> ? and
       titulo.titdtven <> date(acha("AGENDAR",titulo.titobs[2])) 
    then v-agendado = "*".
    else v-agendado = "".
    display titulo.titnum format "x(7)"
            titulo.titpar   format ">9"  when titulo.titpar < 100
        titulo.titvlcob format ">,>>>,>>9.99" column-label "Vl.Cobrado"
        titulo.titdtven format "99/99/99"   column-label "Dt.Vecto"
        titulo.titdtpag format "99/99/99"   column-label "Dt.Pagto"
        titulo.titvlpag when titulo.titvlpag > 0 format ">,>>>,>>9.99"
                                            column-label "Valor Pago"
        titulo.titvljur column-label "Juros" format ">>,>>9.9"
        titulo.titvldes column-label "Desc"  format ">>>,>>9.9"
        titulo.titsit column-label "S" format "X"
        v-agendado
            with frame frame-a 10 down centered row 6 color white/red
            title " " + vcliforlab + " " + forne.fornom + " "
                    + " Cod.: " + string(vclifor) + " " width 80.
    recatu1 = recid(titulo).

    if  esqregua then do:
        display esqcom1[esqpos1] with frame f-com1.
        color  display message esqcom1[esqpos1] with frame f-com1.
    end.
    else do:
        display esqcom2[esqpos2] with frame f-com2.
        color display message esqcom2[esqpos2] with frame f-com2.
    end.

    repeat:
        find next titulo use-index titdtven   
                    where titulo.empcod   = wempre.empcod and
                               titulo.titnat   = vtitnat       and
                               titulo.modcod   = vmodcod       and
                               titulo.etbcod   = vetbcod       and
                               titulo.clifor   = vclifor NO-LOCK no-error.
        if not available titulo
        then leave.
        if frame-line(frame-a) = frame-down(frame-a)
        then leave.
        if not vinicio
        then down with frame frame-a.
        view frame ff.

        if acha("AGENDAR",titulo.titobs[2]) <> ? and
           titulo.titdtven <> date(acha("AGENDAR",titulo.titobs[2])) 
        then v-agendado = "*".
        else v-agendado = "".
        display titulo.titnum
                titulo.titpar  when titulo.titpar < 100
                titulo.titvlcob
                titulo.titdtven
                titulo.titdtpag
                titulo.titvlpag when titulo.titvlpag > 0
                titulo.titvljur
                titulo.titvldes
                titulo.titsit 
                v-agendado with frame frame-a.
    end.
    up frame-line(frame-a) - 1 with frame frame-a.
    repeat with frame frame-a:
        find titulo where recid(titulo) = recatu1 NO-LOCK.
        /*
        color display messages titulo.titnum titulo.titpar when titulo.titpar < 100.      */
        on f7 recall.
        choose field titulo.titnum titulo.titpar
            go-on(cursor-down cursor-up cursor-left cursor-right F7 PF7
                  page-up page-down tab PF4 F4 ESC return v V ).
        {pagtit.i}
       if  keyfunction(lastkey) = "RECALL"
       then do with frame fproc centered row 5 overlay color message side-label:
            prompt-for titulo.titnum colon 10.
            find last titulo where titulo.empcod   = wempre.empcod and
                                    titulo.titnat   = vtitnat       and
                                    titulo.modcod   = vmodcod       and
                                    titulo.etbcod   = vetbcod       and
                                    titulo.clifor   = vclifor       and
                                    titulo.titnum = input titulo.titnum 
                                   NO-LOCK no-error.
            recatu1 = if avail titulo
                      then recid(titulo) else ?.
            leave.
       end. on f7 help.

       if keyfunction(lastkey) = "V" or
          keyfunction(lastkey) = "v"
       then do with frame fdt centered row 5 overlay color message side-label:
            vdt = today.
            update vdt label "Vencimento".
            find first titulo where titulo.empcod   = wempre.empcod and
                                    titulo.titnat   = vtitnat       and
                                    titulo.modcod   = vmodcod       and
                                    titulo.etbcod   = vetbcod       and
                                    titulo.clifor   = vclifor       and
                                    titulo.titdtven >= vdt NO-LOCK no-error.
            if avail titulo
            then recatu1 = recid(titulo). 
            else do:
                find next titulo use-index titdtven where 
                                 titulo.empcod = wempre.empcod   and
                                 titulo.titnat   = vtitnat       and
                                 titulo.modcod   = vmodcod       and
                                 titulo.etbcod   = vetbcod       and
                                 titulo.clifor   = vclifor       and
                                 titulo.titdtven >= vdt NO-LOCK no-error.
                if avail titulo
                then recatu1 = recid(titulo).
                else do:
                     find prev titulo use-index titdtven where 
                                 titulo.empcod = wempre.empcod   and
                                 titulo.titnat   = vtitnat       and
                                 titulo.modcod   = vmodcod       and
                                 titulo.etbcod   = vetbcod       and
                                 titulo.clifor   = vclifor       and
                                 titulo.titdtven <= vdt NO-LOCK no-error.
                    if avail titulo
                    then recatu1 = recid(titulo).
                    else recatu1 = ?.
                end.    
            end.   
            leave.
        end. 
        
        if  keyfunction(lastkey) = "TAB" then do:
            if  esqregua then do:
                color display normal
                    esqcom1[esqpos1]
                    with frame f-com1.
                color display message
                    esqcom2[esqpos2]
                    with frame f-com2.
            end.
            else do:
                color display normal
                    esqcom2[esqpos2]
                    with frame f-com2.
                color display message
                    esqcom1[esqpos1]
                    with frame f-com1.
            end.
            esqregua = not esqregua.
        end.
        if keyfunction(lastkey) = "cursor-right" then do:
            if  esqregua then do:
                color display normal
                    esqcom1[esqpos1]
                    with frame f-com1.
                esqpos1 = if esqpos1 = 5
                          then 5
                          else esqpos1 + 1.
                color display messages
                    esqcom1[esqpos1]
                    with frame f-com1.
            end.
            else do:
                color display normal
                    esqcom2[esqpos2]
                    with frame f-com2.
                esqpos2 = if esqpos2 = 3
                          then 3
                          else esqpos2 + 1.
                color display messages
                    esqcom2[esqpos2]
                    with frame f-com2.
            end.
            next.
        end.
        if keyfunction(lastkey) = "cursor-left" then do:
            if esqregua then do:
                color display normal
                    esqcom1[esqpos1]
                    with frame f-com1.
                esqpos1 = if esqpos1 = 1
                          then 1
                          else esqpos1 - 1.
                color display messages
                    esqcom1[esqpos1]
                    with frame f-com1.
            end.
            else do:
                color display normal
                    esqcom2[esqpos2]
                    with frame f-com2.
                esqpos2 = if esqpos2 = 1
                          then 1
                          else esqpos2 - 1.
                color display messages
                    esqcom2[esqpos2]
                    with frame f-com2.
            end.
            next.
        end.
        if keyfunction(lastkey) = "cursor-down" then do:
            find next titulo use-index titdtven
                             where titulo.empcod   = wempre.empcod and
                                   titulo.titnat   = vtitnat       and
                                   titulo.modcod   = vmodcod       and
                                   titulo.etbcod   = vetbcod   and
                                   titulo.clifor   = vclifor NO-LOCK no-error.
            if  not avail titulo
            then next.
            color display white/red titulo.titnum titulo.titpar when titulo.titpar < 100. 
            if frame-line(frame-a) = frame-down(frame-a)
            then scroll with frame frame-a.
            else down with frame frame-a.
        end.
        if  keyfunction(lastkey) = "cursor-up" then do:
            find prev titulo use-index titdtven
                             where titulo.empcod   = wempre.empcod and
                                   titulo.titnat   = vtitnat       and
                                   titulo.modcod   = vmodcod       and
                                   titulo.etbcod   = vetbcod       and
                                   titulo.clifor   = vclifor NO-LOCK no-error.
            if not avail titulo
            then next.
            color display white/red titulo.titnum titulo.titpar when titulo.titpar < 100.
            if frame-line(frame-a) = 1
            then scroll down with frame frame-a.
            else up with frame frame-a.
        end.
        if keyfunction(lastkey) = "end-error"
        then leave bl-princ.

        if keyfunction(lastkey) = "return"
        then do on error undo, retry on endkey undo, leave.
          if esqcom2[esqpos2] <> "Pagamento/Cancelamento" or
             esqcom2[esqpos2] <> "Bloqueio/Liberacao"
          then hide frame frame-a no-pause.
          /*
          display vcliforlab at 6 vclifornom
                with frame frame-b 1 down centered color blue/gray
                width 81 no-box no-label row 5 overlay.
            */
          if  esqregua
          then do:
            if  esqcom1[esqpos1] = "Inclusao"
            then do ON ERROR UNDO with frame ftit2:
                /* vtitnum = "". */
                vsetcod = 0.
                run setor-aut.
                vtitpar = 1.
                update vtitnum vtitpar.
                find first btitulo where btitulo.empcod   = wempre.empcod and
                                         btitulo.titnat   = vtitnat       and
                                         btitulo.modcod   = vmodcod       and
                                         btitulo.etbcod   = vetbcod       and
                                         btitulo.clifor   = vclifor       and
                                         btitulo.titnum   = vtitnum       and
                                         btitulo.titpar   = vtitpar
                                   NO-LOCK no-error.
                if avail btitulo
                then do:
                    message "Titulo ja Existe".
                    undo, retry.
                end.
                update vtitdtemi vtotal label "Total".
                i = 0.
                ii = 0.
                vt = 0.
                vtot = 0.
                do i = 1 to vtitpar:
                    vdia = 0.
                    display i column-label "Pr" with frame f-par.
                    update vdia column-label "dias"
                                with frame f-par centered color message.
                    vvenc = vtitdtemi + /*vdia*/ 3.
                    update vvenc /*validate((vvenc < (vtitdtemi + 3)),  
                            "Data invalida")*/ 
                            column-label "Venc." with frame f-par.
                    create titulo.
                    assign titulo.exportado = yes
                           titulo.empcod = wempre.empcod
                           titulo.titsit = "lib"
                           titulo.titnat = vtitnat
                           titulo.modcod = vmodcod
                           titulo.etbcod = vetbcod
                           titulo.datexp = today
                           titulo.clifor = vclifor
                           titulo.titnum = vtitnum
                           titulo.titpar  = i
                           titulo.titdtemi = vtitdtemi
                           titulo.titdtven = vvenc
                           titulo.titbanpag = vsetcod
                           titulo.titvlcob = (vtotal - vt) / (vtitpar - ii).
                           ii = ii + 1.
                    do on error undo:
                        update titulo.titvlcob with frame f-par.
                        vt = vt + titulo.titvlcob.
                        if vt <> vtotal and ii = vtitpar
                        then do:
                        message "Valor das prestacoes nao confere com o total".
                            undo, retry.
                        end.
                    end.
                    create wtit.
                    assign wtit.wrec = recid(titulo).
                    vtot = vtot + titulo.titvlcob.
                end.
                update vcobcod.
                find cobra where cobra.cobcod = vcobcod NO-LOCK.
                display cobra.cobnom  no-label.
                if  cobra.cobban then do with frame fbanco2.
                    update vbancod.
                    find banco where banco.bancod = vbancod NO-LOCK.
                    display banco.bandesc .
                    update vagecod.
                    find agenc of banco where agenc.agecod = vagecod NO-LOCK.
                    display agedesc.
                end.
                wperjur = 0.
                /* vevecod = 0. */
                update vevecod.
                find event where event.evecod = vevecod no-lock.
                display event.evenom no-label.
                wperjur = 0.
                vtitvljur = 0.
                wperdes = 0.
                vtitobs = "".
                vtitvldes = 0.
                vtitdtdes = ?.
                update wperjur with frame fjurdes2.
                update vtitvljur column-label "Juros" with frame fjurdes2.
                wperdes = 0.
                update vtitdtdes
                       wperdes
                       vtitvldes format ">>>,>>9.99"
                            with frame fjurdes2 no-validate.
                update text(vtitobs) with frame fobs2. pause 0.
                /******* frete *********/
                    vv = 0.
                    update vfre label "Frete" with frame f-fre
                            centered side-label row 8.
                    if vfre = 2
                    then do:
                        vv = 0.            
                        for each ftitulo use-index cxmdat where 
                                        ftitulo.etbcod = titulo.etbcod and
                                        ftitulo.cxacod = titulo.clifor and
                                        ftitulo.titnumger = 
                                                        string(titulo.titnum) 
                                          no-lock.
                            find first frete where frete.forcod = 
                                                        ftitulo.clifor
                                                                    no-lock.
                            display ftitulo.etbcod
                                    ftitulo.titdtven
                                    ftitulo.titnum column-label "Conhec."
                                                 format "x(10)"
                                    ftitulo.titnumger column-label "NF.Fiscal"
                                                 format "x(07)"
                                    frete.frenom format "x(20)"
                                    ftitulo.titvlcob column-label "Vl.Cobrado" 
                                           with frame ffrete  1 down row 15
                                            width 80 centered color white/cyan.
                            vv = vv + 1.
                            pause.
                        end.    
                        if vv = 0
                        then do:
                            update  vfrecod with frame f-frete2.
                            find frete where frete.frecod = vfrecod no-lock.
                            display frete.frenom no-label with frame f-frete2.
                            vlfrete = 0.
                            update vlfrete label "Valor Frete"
                                        with frame f-frete2.

                            create btitulo.
                            assign btitulo.exportado = yes
                                   btitulo.etbcod   = titulo.etbcod
                                   btitulo.titnat   = yes
                                   btitulo.modcod   = "NEC"
                                   btitulo.clifor   = frete.forcod
                                   btitulo.cxacod   = forne.forcod
                                   btitulo.titsit   = "lib"
                                   btitulo.empcod   = titulo.empcod
                                   btitulo.titdtemi = titulo.titdtemi
                                   btitulo.titnum   = titulo.titnum
                                   btitulo.titpar   = 1
                                   btitulo.titnumger = titulo.titnum
                                   btitulo.titvlcob = vlfrete.
                                   
                            update btitulo.titdtven label "Venc.Frete"
                                   btitulo.titnum   label "Controle"
                                with frame f-frete2 centered color white/cyan
                                                side-label row 15 no-validate.

                        end.    
                            
                    end. 
                    hide frame ffrete no-pause.
                    
                
                
                /**********************/
                
                vlancod = 0.
                vlanhis = 0.
                if vtitnat = yes
                then do on error undo, retry:
                    hide frame ff no-pause.
                    hide frame ff1 no-pause.
                    hide frame fdadpg no-pause.
                    hide frame f-com1 no-pause.
                    hide frame f-com2 no-pause.
                    hide frame ftitulo no-pause.
                    hide frame ftit    no-pause.
                    hide frame ftit2   no-pause.
                    hide frame fbancpg no-pause.
                    hide frame fbanco  no-pause.
                    hide frame fbanco2 no-pause.
                    hide frame fjurdes no-pause.
                    hide frame fjurdes2 no-pause.
                    hide frame fobs2  no-pause.
                    hide frame fobs   no-pause.
                    hide frame fpag1  no-pause.

                    if vclifor = 533
                    then vlanhis = 5.
                    
                    if vclifor = 100071
                    then vlanhis = 4.

                    if vclifor = 100072
                    then vlanhis = 3.

                    if titulo.modcod = "DUP"
                    then assign vlancod = 100
                                vlanhis = 1.
                    /*
                    find first lanaut where 
                               lanaut.etbcod = ? and
                               lanaut.forcod = ? and
                               lanaut.modcod = titulo.modcod
                               no-lock no-error.
                    if avail lanaut
                    then do:
                        assign
                            vlancod = lanaut.lancod
                            vlanhis = lanaut.lanhis
                            .
                    end.
                    */             
                    else do:
                        find last blancxa where 
                                     blancxa.forcod = forne.forcod  and
                                     blancxa.etbcod = titulo.etbcod and
                                     blancxa.lantip = "C"
                                             no-lock no-error.
                        if avail blancxa
                        then assign vlancod = blancxa.lancod
                                    vlanhis = blancxa.lanhis
                                    vcompl  = blancxa.comhis.
                        
                        if vclifor = 533
                        then vlanhis = 5.
                    
                        if vclifor = 100071
                        then vlanhis = 4.

                        if vclifor = 100072
                        then vlanhis = 3.
                        
                        find lanaut where lanaut.etbcod = titulo.etbcod and
                                          lanaut.forcod = titulo.clifor
                                                no-lock no-error.
                        if avail lanaut  
                        then do:  
                            assign vlanhis = lanaut.lanhis 
                                   vcompl  = lanaut.comhis 
                                   vlancod = lanaut.lancod.
                        end.
     
 
                         
                        if vlancod = 0
                        then update vlancod label "Lancamento"
                                      with frame lanca centered side-label
                                         row 15 overlay.
                                         
                    end.
                    
                    find tablan where tablan.lancod = vlancod no-lock no-error.
                    if not avail tablan
                    then do:
                        message "Lancamento Invalido".
                        undo, retry.
                    end.

                    if vlanhis = 0
                    then vlanhis = tablan.lanhis.

                    find lanaut where lanaut.etbcod = titulo.etbcod and
                                      lanaut.forcod = titulo.clifor
                                                no-lock no-error.
                    if avail lanaut 
                    then do: 
                        assign vlanhis = lanaut.lanhis
                               vcompl  = lanaut.comhis
                               vlancod = lanaut.lancod.
                    end.
     
                    
                    
                    if vlanhis = 150
                    then vcompl = tablan.landes.
                    else if vlanhis <> 2
                         then vcompl = titulo.titnum 
                                    + "-" + string(titulo.titpar)
                                    + " " + forne.fornom.
                         else vcompl = forne.fornom.
                    
                    if vlancod = 100
                    then assign vlanhis = 1
                                vcompl = titulo.titnum 
                                        + "-" + string(titulo.titpar)
                                        + " " + forne.fornom.
                    else if
                         vlanhis = 0 or
                         vcompl  = ""
                         then update vlanhis label "Historico"
                                     vcompl  label "Complemento"
                                        with frame lanca centered side-label
                                               row 15 overlay.
                    if vlanhis = 6
                    then vcompl = "".
                end.
                titulo.vencod = vlancod.
                titulo.titnumger = vcompl.
                titulo.titparger = vlanhis. 
                /***********/
                
                for each wtit:
                    find titulo where recid(titulo) = wtit.wrec.
                    assign titulo.cobcod   = cobra.cobcod
                           titulo.bancod   = vbancod
                           titulo.agecod   = vagecod
                           titulo.evecod   = event.evecod
                           titulo.titvljur = vtitvljur
                           titulo.titdtdes = vtitdtdes
                           titulo.titvldes = vtitvldes
                           titulo.titobs[1] = vtitobs[1]
                           titulo.titobs[2] = vtitobs[2].
                    delete wtit.
                end.
                
                recatu1 = recid(titulo).
                leave.
            end.

            if esqcom1[esqpos1] = "Alteracao"
            then do ON ERROR UNDO with frame ftitulo:
 
                if titulo.titsit = "PAG" 
                     and (sfuncod <> 30 or setbcod <> 999)
                     and (sfuncod <> 89 or setbcod <> 999)
                     and (sfuncod <> 404 or setbcod <> 999)
                then do:
                    message "Titulo so pode ser alterado por Tania". pause.
                    undo, retry.
                end.

                find current titulo EXCLUSIVE.
                vtitvlcob = titulo.titvlcob .
                titulo.datexp = today.
                hide frame f-senha no-pause.
                hide frame f-fre2 no-pause.
                vsetcod = titulo.titbanpag.
                run setor-aut.
                update titulo.clifor column-label "Fornecedor"
                       titulo.titnum
                       titulo.titpar   when titulo.titpar < 100
                       titulo.titdtemi
                       titulo.titdtven
                       titulo.titvlcob
                       titulo.cobcod with no-validate.
                titulo.titbanpag = vsetcod.
                find cobra where cobra.cobcod = titulo.cobcod NO-LOCK.
                display cobra.cobnom.
                if cobra.cobban
                then do with frame fbanco:
                    update titulo.bancod.
                    find banco where banco.bancod = titulo.bancod NO-LOCK.
                    display banco.bandesc .
                    update titulo.agecod.
                    find agenc of banco where agenc.agecod = titulo.agecod
                               NO-LOCK.
                    display agedesc.
                end.
                /* Alterar modalidade na tela de consulta
                update titulo.modcod colon 15.
                */
                find modal where modal.modcod = titulo.modcod no-lock.
                display modal.modnom no-label.
                update titulo.evecod colon 15.
                find event where event.evecod = titulo.evecod no-lock.
                display event.evenom no-label.
                update titulo.titvljur with frame fjurdes .
                update titulo.titdtdes with frame fjurdes.
                valor-ori = string(titulo.titvldes).
                update titulo.titvldes format ">>>,>>9.99"
                        with frame fjurdes no-validate.
                if titulo.titvldes <> dec(valor-ori)
                then run titulolog.p(input recid(titulo),
                                     input "titvldes",
                                     input valor-ori,
                                     input "").
                update text(titulo.titobs) with frame fobs.
                if  titulo.titvlcob <> vtitvlcob then do:
                   if  titulo.titvlcob < vtitvlcob then do:
                    assign sresp = yes.
                    display "  Confirma GERACAO DE NOVO TITULO ?"
                                with frame fGERT color messages
                                width 60 overlay row 10 centered.
                    update sresp no-label with frame fGERT.
                    if sresp
                    then do:
                        find last btitulo where
                            btitulo.empcod   = wempre.empcod and
                            btitulo.titnat   = vtitnat       and
                            btitulo.modcod   = vmodcod       and
                            btitulo.etbcod   = vetbcod       and
                            btitulo.clifor   = vclifor       and
                            btitulo.titnum   = titulo.titnum.
                            create ctitulo.
                            assign ctitulo.exportado = yes
                                   ctitulo.empcod = btitulo.empcod
                                   ctitulo.modcod = btitulo.modcod
                                   ctitulo.clifor = btitulo.clifor
                                   ctitulo.titnat = btitulo.titnat
                                   ctitulo.etbcod = btitulo.etbcod
                                   ctitulo.titnum = btitulo.titnum
                                   ctitulo.cobcod = titulo.cobcod
                                   ctitulo.titpar   = btitulo.titpar + 1
                                   ctitulo.titdtemi = today
                                   ctitulo.titdtven = titulo.titdtven
                                  ctitulo.titvlcob = vtitvlcob - titulo.titvlcob
                                   ctitulo.titnumger = titulo.titnum
                                   ctitulo.titparger = titulo.titpar
                                   ctitulo.datexp    = today.
                            display ctitulo.titnum
                                    ctitulo.titpar when titulo.titpar < 100
                                    ctitulo.titdtemi
                                    ctitulo.titdtven
                                    ctitulo.titvlcob
                                    with frame fmos width 40 1 column
                                              title " Titulo Gerado " overlay
                                              centered row 10.
                            recatu1 = recid(ctitulo).
                            leave.
                        end.
                     end.
                     else do:
                        display "  Confirma AUMENTO NO VALOR DO TITULO?"
                                with frame faum color messages
                                width 60 overlay row 10 centered.
                        update sresp no-label with frame faum.
                        if not sresp then undo, leave.
                    end.
                end.
                message "Confirma Titulo" update sresp.
                if sresp
                then do on error undo:
                    /*
                    for each ztitulo use-index titdtven where
                                            ztitulo.clifor = titulo.clifor and
                                            ztitulo.titnat = yes no-lock:
                        if ztitulo.titnum begins "A"
                        then do:
                            display ztitulo.etbcod
                                    ztitulo.titnum
                                    ztitulo.titpar   when ztitulo.titpar < 100
                                    ztitulo.titdtven
                                    ztitulo.titdtpag
                                    ztitulo.titvlpag  
                                        with frame f-alerta down
                                                centered overlay row 10
                                                    color black/yellow.
                            pause.
                        end.
                    end. 
                    */
                    hide frame f-alerta no-pause.
                    vv = 0.
                    update vfre label "Frete" with frame f-fre2
                            centered side-label row 8.
                    if vfre = 2
                    then do:
                        vv = 0.            
                        for each ftitulo use-index cxmdat where 
                                        ftitulo.etbcod = titulo.etbcod and
                                        ftitulo.cxacod = titulo.clifor and
                                        ftitulo.titnumger = 
                                                        string(titulo.titnum) 
                                          no-lock.
                            find first frete where frete.forcod = 
                                                        ftitulo.clifor
                                                                    no-lock.
                            display ftitulo.etbcod
                                    ftitulo.titdtven
                                    ftitulo.titnum column-label "Conhec."
                                                 format "x(10)"
                                    ftitulo.titnumger column-label "NF.Fiscal"
                                                 format "x(07)"
                                    frete.frenom format "x(20)"
                                    ftitulo.titvlcob column-label "Vl.Cobrado" 
                                           with frame ffrete2 1 down row 15
                                            width 80 centered color white/cyan.
                            vv = vv + 1.
                            pause.
                        end.    
                        if vv = 0
                        then do:
                            update  vfrecod with frame f-frete22.
                            find frete where frete.frecod = vfrecod no-lock.
                            display frete.frenom no-label with frame f-frete22.
                            vlfrete = 0.
                            update vlfrete label "Valor Frete"
                                        with frame f-frete22.

                            create btitulo.
                            assign btitulo.exportado = yes
                                   btitulo.etbcod   = titulo.etbcod
                                   btitulo.titnat   = yes
                                   btitulo.modcod   = "NEC"
                                   btitulo.clifor   = frete.forcod
                                   btitulo.cxacod   = forne.forcod
                                   btitulo.titsit   = "lib"
                                   btitulo.empcod   = titulo.empcod
                                   btitulo.titdtemi = titulo.titdtemi
                                   btitulo.titnum   = titulo.titnum
                                   btitulo.titpar   = 1
                                   btitulo.titnumger = titulo.titnum
                                   btitulo.titvlcob = vlfrete.
                                   
                            update btitulo.titdtven label "Venc.Frete"
                                   btitulo.titnum   label "Controle"
                                with frame f-frete22 centered color white/cyan
                                                side-label row 15 no-validate.

                        end.    
                            
                    end. 
                    hide frame ffrete2 no-pause.
                    
                    vsenha = "".
                    update vfunc
                           vsenha blank
                           with frame f-senha side-label overlay centered.
                    if vfunc <> 29 and
                       vfunc <> 30 and
                       vfunc <> 89 and
                       vfunc <> 111 and
                       vfunc <> 404 and
                       vfunc <> 1123
                    then do:
                        message "Funcionario nao autorizado".
                        undo, retry.
                    end.
                    find func where func.etbcod = 999 and
                                    func.funcod = vfunc and
                                    func.senha  = vsenha no-lock no-error.
                    if not avail func
                    then do:
                        message "Senha Invalida".
                        undo, retry.
                    end.
                    if titulo.titsit = "CON"
                    then assign
                            titulo.titdtdes = ?
                            titulo.titsit = "LIB".
                    else do:
                        assign 
                            titulo.titdtdes = today
                            titulo.titsit = "CON".
                        /* antonio - sol 24539 */
                        if titulo.modcod = "DUP"
                        then assign titulo.cxacod = vfunc.
                        /**/
                    end.
                    message "Confirma Frete" update sresp.
                    if sresp
                    then do:
                        for each btitulo use-index cxmdat where 
                                   btitulo.etbcod    = titulo.etbcod and
                                   btitulo.cxacod    = titulo.clifor and
                                   btitulo.titnumger = string(titulo.titnum): 
                        
                            if btitulo.titsit = "CON"
                            then assign
                                    btitulo.titdtdes = ?
                                    btitulo.titsit = "LIB".
                            else do:
                                    assign
                                      btitulo.titdtdes = today
                                      btitulo.titsit = "CON".
                                   /* antonio - sol 24539 */
                                   if btitulo.modcod = "DUP"
                                   then assign btitulo.cxacod = vfunc.
                                   /**/
                            end.

                        end.
                    end.
                    

                end.
            end.

            if esqcom1[esqpos1] = "Consulta" or
               esqcom1[esqpos1] = "Exclusao"
            then do:
                find modal of titulo no-lock no-error.
                disp titulo.modcod
                     modal.modnom when available modal no-label
                     titulo.titnum
                     titulo.titpar  when titulo.titpar < 100
                     titulo.titdtemi
                     titulo.titdtven
                     titulo.titvlcob
                     titulo.cobcod with frame ftitulo.
                disp titulo.titvljur
                     titulo.titjuro
                     titulo.titdtdes
                     titulo.titvldes
                     titulo.titdtpag
                     titulo.titvlpag with frame fjurdes.
               disp titulo.titobs[1] format "x(72)" label "Obs." skip 
                    space(3) titulo.titobs[2] format "x(72)" no-label
                    with frame fobs3 side-labels no-box overlay.
            end.

            if esqcom1[esqpos1] = "Exclusao"
            then do ON ERROR UNDO
                    with frame f-exclui overlay row 6 1 column centered.
                
                if titulo.titsit = "PAG" 
          and (sfuncod <> 30 or setbcod <> 999)
          and (sfuncod <> 89 or setbcod <> 999)
          and (sfuncod <> 404 or setbcod <> 999)
                then do:
                    message "Titulo so pode ser excluido por Tania". pause.
                    undo, retry.
                 end.
                 
                if titulo.titsit = "CON"
                then do:
                    message "Titulo nao pode ser excluido". pause.
                    undo, retry.
                end.

                find first fatudesp where
                               fatudesp.etbcod = titulo.etbcod and
                               fatudesp.clicod = titulo.clifor and
                               fatudesp.fatnum = int(titulo.titnum)
                               no-lock no-error.
                if avail fatudesp
                then do:
                    message 
                    "Para excluir este documento favor entrar em contato com o SETOR CONTABIL"     . pause. undo, retry.

                end.
                
                message "Confirma Exclusao de Titulo"
                            titulo.titnum ",Parcela" titulo.titpar
                update sresp.
                if not sresp
                then leave.
                find next titulo use-index titdtven
                                 where titulo.empcod   = wempre.empcod and
                                       titulo.titnat   = vtitnat       and
                                       titulo.modcod   = vmodcod       and
                                       titulo.etbcod   = vetbcod       and
                                       titulo.clifor   = vclifor
                                 NO-LOCK no-error.
                if not available titulo
                then do:
                    find titulo where recid(titulo) = recatu1 NO-LOCK.
                    find prev titulo use-index titdtven
                                     where titulo.empcod   = wempre.empcod and
                                           titulo.titnat   = vtitnat       and
                                           titulo.modcod   = vmodcod       and
                                           titulo.etbcod   = vetbcod       and
                                           titulo.clifor   = vclifor
                                     NO-LOCK no-error.
                end.
                recatu2 = if available titulo
                          then recid(titulo)
                          else ?.
                find titulo where recid(titulo) = recatu1.
                {ctb02.i}
                
                deletou-lancxa = no.
                for each lancxa where lancxa.datlan = titulo.titdtpag and
                                      lancxa.forcod = titulo.clifor   and
                                      lancxa.titnum = titulo.titnum   and
                                      lancxa.lancod = titulo.vencod:
                    delete lancxa.
                    deletou-lancxa = yes.
                    
                end.
                if deletou-lancxa = no
                then do:
                    message "Nao Excluiu lancamento na contabilidade".
                    pause.
                end.
                
                delete titulo.
                recatu1 = recatu2.
                leave.
            end.

            if esqcom1[esqpos1] = "Agendamento"
            then do:
                if titulo.titsit = "LIB" or
                   titulo.titsit = "CON"
                then do on error undo:
                    run agendamento.
                end.
                leave.   
            end.
          end.
          else do:
            hide frame f-com2 no-pause.
            if  esqcom2[esqpos2] = "Pagamento/Cancelamento"
            then
              if titulo.titsit = "LIB" or
                 titulo.titsit = "IMP" or
                 titulo.titsit = "CON"
              then do ON ERROR UNDO 
                    with frame f-Paga overlay row 6 1 column centered.
                 display titulo.titnum    colon 13
                        titulo.titpar    colon 33 label "Pr" when titulo.titpar < 100
                        titulo.titdtemi  colon 13
                        titulo.titdtven  colon 13
                        titulo.titvlcob  colon 13 label "Vl.Cobr."
                        titulo.titvljur  colon 13 label "Vl.Juro"
                        titulo.titvldes  format ">>>,>>9.99"
                                colon 13 label "Vl.Desc"
                        with frame fdadpg side-label
                        overlay row 6 color white/cyan width 40
                        title " Titulo ".

                 find current titulo EXCLUSIVE.
                 titulo.datexp = today.
               if titulo.modcod = "CRE" then do:
                   {titpagb4.i}
                   update titulo.titvljur  colon 13 label "Vl.Juro"
                          titulo.titvldes  colon 13 label "Vl.Desc"
                                format ">>>,>>9.99"
                                            with frame fdadpg side-label
                                    overlay row 6 color white/cyan width 40
                                          title " Titulo " no-validate.
               end.
               else do:
                   hide frame lanca no-pause.
                   assign titulo.titdtpag = today.
                   display titulo.titdtdes colon 13 label "Dt.Desc"
                           titulo.titvldes colon 13 label "Vl.Desc"
                                           format ">>>,>>9.99"
                           titulo.titvljur colon 13 label "Vl.Juro"
                                      with frame fdadpg.
                   update titulo.titdtpag with frame fpag1.
                   /**
                   if titulo.titdtpag < titulo.titdtven
                   then do:
                        message  "Informe a taxa para pagamento antecipado %"
                                 update taxa-ante.
                                                 
                        if taxa-ante > 0
                        then do:
                            titulo.titvlpag = titulo.titvlcob -
                            (titulo.titvlcob * (taxa-ante / 100)).
                            titulo.titdesc = taxa-ante.
                        end.
                        else titulo.titvlpag = titulo.titvlcob.   
                         
                   end.
                   else
                   **/
                   titulo.titvlpag = titulo.titvlcob.
                   
                   /*
                   if titulo.titdtpag > titulo.titdtven 
                   then assign titulo.titvlpag = titulo.titvlcob
                                                 + titulo.titvljur.
                                                  /* *
                                        (titulo.titdtpag - titulo.titdtven)).
                                                  */
                   else if titulo.titdtpag <= titulo.titdtdes
                   then assign titulo.titvlpag = titulo.titvlcob -
                                          titulo.titvldes. /* *
                                     ((titulo.titdtdes - titulo.titdtpag) + 1)).
                                                   */
                   */
                   
                titulo.titvlpag = titulo.titvlcob + titulo.titvljur
                                     - titulo.titvldes.
                assign vtitvlpag = titulo.titvlpag.
                update titulo.titvlpag with frame fpag1.
                update titulo.cobcod with frame fpag1.
                update titulo.titvljur column-label "Juros"
                       titulo.titvldes format ">>>,>>9.99"
                            with frame fpag1 no-validate.
                
                
                titulo.titvlpag = titulo.titvlcob + titulo.titvljur -
                                  titulo.titvldes.
                
                
                vlancod = 0.
                if vtitnat = yes
                then do on error undo, retry:
                    hide frame ff no-pause.
                    hide frame ff1 no-pause.
                    hide frame fdadpg no-pause.
                    hide frame f-com1 no-pause.
                    hide frame f-com2 no-pause.
                    hide frame ftitulo no-pause.
                    hide frame ftit    no-pause.
                    hide frame ftit2   no-pause.
                    hide frame fbancpg no-pause.
                    hide frame fbanco  no-pause.
                    hide frame fbanco2 no-pause.
                    hide frame fjurdes no-pause.
                    hide frame fjurdes2 no-pause.
                    hide frame fobs2  no-pause.
                    hide frame fobs   no-pause.
                    hide frame fpag1  no-pause.

                    vlancod = titulo.vencod.
                    vlanhis = titulo.titparger.
                    vcompl  = titulo.titnumger.

                    if vclifor = 533
                    then vlanhis = 5.
                    
                    if vclifor = 100071
                    then vlanhis = 4.

                    if vclifor = 100072
                    then vlanhis = 3.

                    find lanaut where lanaut.etbcod = titulo.etbcod and
                                      lanaut.forcod = titulo.clifor
                                                no-lock no-error.
                    if avail lanaut 
                    then do: 
                        assign vlanhis = lanaut.lanhis
                               vcompl  = lanaut.comhis
                               vlancod = lanaut.lancod.
                    end.
                    
                    if titulo.modcod = "DUP"
                    then assign vlancod = 100
                                vlanhis = 1
                                vcompl  = titulo.titnum 
                                        + "-" + string(titulo.titpar)
                                        + " " + forne.fornom.
                    /*
                    find first lanaut where 
                               lanaut.etbcod = ? and
                               lanaut.forcod = ? and
                               lanaut.modcod = titulo.modcod
                               no-lock no-error.
                    if avail lanaut
                    then do:
                        assign
                            vlancod = lanaut.lancod
                            vlanhis = lanaut.lanhis
                            vcompl  = titulo.titnum 
                                + "-" + string(titulo.titpar)
                                + " " + forne.fornom.
                            .
                    end. 
                    */
                    else do:
                        find last blancxa where blancxa.forcod = forne.forcod
                                            and  blancxa.etbcod = titulo.etbcod
                                            and  blancxa.lantip = "C"
                                            no-lock no-error.
                        if avail blancxa
                        then assign vlancod = blancxa.lancod
                                    vlanhis = blancxa.lanhis
                                    vcompl  = blancxa.comhis.
   
                        if vclifor = 533
                        then vlanhis = 5.
                    
                        if vclifor = 100071
                        then vlanhis = 4.

                        if vclifor = 100072
                        then vlanhis = 3.
                        
                        find lanaut where lanaut.etbcod = titulo.etbcod and
                                          lanaut.forcod = titulo.clifor
                                                no-lock no-error.
                        if avail lanaut 
                        then do: 
                            assign vlanhis = lanaut.lanhis
                                   vcompl  = lanaut.comhis
                                   vlancod = lanaut.lancod.
                        end.
     
 

                        if vcompl  = "" or
                           vlancod = 0  or
                           vlanhis = 0
                        then

                        update vlancod label "Lancamento"
                               vlanhis label "Historico" format ">99"
                               vcompl  label "Complemento"
                                    with frame lanca centered side-label
                                            row 15 overlay.
                                            
                    end.
                    
                    if vlanhis = 6
                    then vcompl = "".
                    
                    run his-complemento.
                    
                    if vlancod <> 0 and vtitnat = yes
                    then do:
                        find tablan where tablan.lancod = vlancod 
                                                    no-lock no-error.
                        if not avail tablan
                        then do:
                            message "Lancamento nao cadastrado".
                            undo, retry.
                        end.
                        display tablan.landes no-label with frame lanca.
                        
                        find last blancxa use-index ind-1
                                where blancxa.numlan <> ? no-lock no-error.
                        if not avail blancxa
                        then vnumlan = 1.
                        else vnumlan = blancxa.numlan + 1.
                        create lancxa.
                        assign lancxa.cxacod = 13
                               lancxa.datlan = titulo.titdtpag
                               lancxa.lancod = vlancod
                               lancxa.numlan = vnumlan
                               lancxa.vallan = titulo.titvlcob
                               lancxa.comhis = vcompl
                               lancxa.lantip = "C"
                               lancxa.forcod = titulo.clifor
                               lancxa.titnum = titulo.titnum
                               lancxa.etbcod = titulo.etbcod
                               lancxa.modcod = titulo.modcod
                               lancxa.lanhis = vlanhis.
                        
                        if lancxa.lanhis = 1
                        then lancxa.comhis = titulo.titnum 
                                + "-" + string(titulo.titpar)
                                + " " + forne.fornom.
                        
                        find lanaut where lanaut.etbcod = titulo.etbcod and
                                          lanaut.forcod = titulo.clifor
                                                no-lock no-error.
                        if avail lanaut
                        then do:
                            assign lancxa.lanhis = lanaut.lanhis
                                   lancxa.comhis = lanaut.comhis
                                   lancxa.lancod = lanaut.lancod.
                        end.

                        if titulo.titvljur > 0 and vtitnat = yes
                        then do:
                            vlanhis = 13.
                            
                            run his-complemento.
                            
                            find last lancxa use-index ind-1
                                    where lancxa.numlan <> ? no-lock no-error.
                            if not avail lancxa
                            then vnumlan = 1.
                            else vnumlan = lancxa.numlan + 1.

                            create blancxa.
                            ASSIGN blancxa.cxacod = 13
                                   blancxa.datlan = titulo.titdtpag
                                   blancxa.lancod = 110
                                   blancxa.numlan = vnumlan
                                   blancxa.vallan = titulo.titvljur
                                   blancxa.comhis = vcompl
                                   blancxa.lantip = "C"
                                   blancxa.forcod = titulo.clifor
                                   blancxa.titnum = titulo.titnum
                                   blancxa.etbcod = titulo.etbcod
                                   blancxa.modcod = titulo.modcod
                                   blancxa.lanhis = vlanhis.
                                   
                        end.    
                        
                        if titulo.titvldes > 0 and vtitnat = yes
                        then do:
                            find last lancxa use-index ind-1
                                 where lancxa.numlan <> ? no-lock no-error.
                            if not avail lancxa
                            then vnumlan = 1.
                            else vnumlan = lancxa.numlan + 1.
                            create blancxa.
                            if titulo.clifor = 100090 or
                               titulo.clifor = 101463
                            then find tablan where tablan.lancod = 111 no-lock.
                            else find tablan where tablan.lancod = 439 no-lock.
                            vlanhis = tablan.lanhis.
                            run his-complemento.
                            ASSIGN blancxa.cxacod = 13
                                   blancxa.datlan = titulo.titdtpag
                                   blancxa.lancod = tablan.lancod
                                   blancxa.numlan = vnumlan
                                   blancxa.vallan = titulo.titvldes
                                   blancxa.comhis = vcompl
                                   blancxa.lantip = "D"
                                   blancxa.forcod = titulo.clifor
                                   blancxa.titnum = titulo.titnum
                                   blancxa.etbcod = titulo.etbcod
                                   blancxa.modcod = titulo.modcod
                                   blancxa.lanhis = tablan.lanhis.
                            
                            if tablan.lanhis = 12
                            then blancxa.comhis =  titulo.titnum 
                                 + "-" + string(titulo.titpar)
                                 + " " + forne.fornom.

                        end.    

                    end.
                    else do:
                        message "Lancamento nao cadastrado".
                        undo, retry.
                    end.
                end.
                hide frame lanca no-pause.
  
                if titulo.titvlpag >= titulo.titvlcob
                then. /* titulo.titjuro = titulo.titvlpag - titulo.titvlcob. */
                else do:
                   assign sresp = no.
                   display "  Confirma PAGAMENTO PARCIAL ?"
                     with frame fpag color messages
                                width 40 overlay row 10 centered.
                    update sresp no-label with frame fpag.
                    if  sresp then do:
                        find last btitulo where
                            btitulo.empcod   = wempre.empcod and
                            btitulo.titnat   = vtitnat       and
                            btitulo.modcod   = vmodcod       and
                            btitulo.etbcod   = vetbcod       and
                            btitulo.clifor   = vclifor       and
                            btitulo.titnum   = titulo.titnum.
                            create ctitulo.
                            assign 
                                ctitulo.exportado = yes
                                ctitulo.empcod = btitulo.empcod
                                ctitulo.modcod = btitulo.modcod
                                ctitulo.clifor = btitulo.clifor
                                ctitulo.titnat = btitulo.titnat
                                ctitulo.etbcod = btitulo.etbcod
                                ctitulo.titnum = btitulo.titnum
                                ctitulo.cobcod = titulo.cobcod
                                ctitulo.titpar   = btitulo.titpar + 1
                                ctitulo.titdtemi = titulo.titdtemi
                                ctitulo.titdtven = if titulo.titdtpag <
                                                      titulo.titdtven
                                                   then titulo.titdtven
                                                   else titulo.titdtpag
                                ctitulo.titvlcob = vtitvlpag - titulo.titvlpag
                                ctitulo.titnumger = titulo.titnum
                                ctitulo.titparger = titulo.titpar
                                ctitulo.datexp    = today
                                 titulo.titnumger = ctitulo.titnum
                                 titulo.titparger = ctitulo.titpar.
                            display ctitulo.titnum
                                    ctitulo.titpar when ctitulo.titpar < 100
                                    ctitulo.titdtemi
                                    ctitulo.titdtven
                                    ctitulo.titvlcob
                                    with frame fmos width 40 1 column
                                              title " Titulo Gerado " overlay
                                              centered row 10.
                        end.
                        else titulo.titdesc = titulo.titvlcob - titulo.titvlpag.
                end.
                assign titulo.titsit = "PAG".
                {ctb01.i}
               end.
               recatu1 = recid(titulo).
               leave.
              end.
              else
                if  titulo.titsit = "PAG"
                then do ON ERROR UNDO:
                find current titulo EXCLUSIVE.
                display titulo.titnum
                        titulo.titpar when titulo.titpar < 100
                        titulo.titdtemi
                        titulo.titdtven
                        titulo.titvlcob
                        titulo.cobcod with frame ftitulo.
                    titulo.datexp = today.
                    titulo.cxmdat = ?.
                    titulo.cxacod = 0.
                    display titulo.titdtpag titulo.titvlpag titulo.cobcod
                            with frame fpag1.
                    message "Pagemento ja efetuado ". pause.
                    undo, retry.
                    
                    /*
                    message "Confirma o Cancelamento do Pagamento ?"
                            update sresp.
                    if sresp then do:
                        for each lancxa where lancxa.datlan = titulo.titdtpag
                                        and   lancxa.forcod = titulo.clifor 
                                        and   lancxa.titnum = titulo.titnum
                                        and   lancxa.lancod = titulo.vencod:
                            delete lancxa.
                        end.
                        assign titulo.titsit  = "LIB"
                               titulo.titdtpag  = ?
                               titulo.titvlpag  = 0
                               /*titulo.titbanpag = 0*/
                               titulo.titagepag = ""
                               titulo.titchepag = ""
                               titulo.titvljur  = 0
                               titulo.datexp    = today.
                        find first b-titu where
                                   b-titu.empcod    =  titulo.empcod and
                                   b-titu.titnat    =  titulo.titnat and
                                   b-titu.modcod    =  titulo.modcod and
                                   b-titu.etbcod    =  titulo.etbcod and
                                   b-titu.clifor    =  titulo.clifor and
                                   b-titu.titnum    =  titulo.titnum and
                                   b-titu.titpar    <> titulo.titpar and
                                   b-titu.titparger =  titulo.titpar
                                   no-lock no-error.
                        if  avail b-titu then do:
                        display "Verifique Titulo Gerado do Pagamento Parcial"
                                with frame fver color messages
                                width 50 overlay row 10 centered.
                            pause.
                        end.
                   
                   end.
                   
                   recatu1 = recid(titulo).
                   next bl-princ.
                   */
                   
                end.
            if esqcom2[esqpos2]  = "Bloqueio/Liberacao" and
               titulo.titsit    <> "PAG"
            then do ON ERROR UNDO.
                find current titulo.
                if titulo.titsit <> "BLO"
                then do:
                    message "Confirma o Bloqueio do Titulo ?" update sresp.
                    if  sresp then do:
                        titulo.titsit = "BLO".
                        titulo.datexp = today.
                    end.
                end.
                else
                    if titulo.titsit = "BLO"
                    then do:
                        message "Confirma a Liberacao do Titulo ?" update sresp.
                        if  sresp then do:
                            titulo.titsit = "LIB".
                            titulo.datexp = today.
                        end.
                     end.
            end.
          end.
          view frame frame-a.
          view frame f-com2 .
        end.
          if keyfunction(lastkey) = "end-error"
          then view frame frame-a.
        if acha("AGENDAR",titulo.titobs[2]) <> ? and
            titulo.titdtven <> date(acha("AGENDAR",titulo.titobs[2])) 
        then v-agendado = "*".
        else v-agendado = "".

        display titulo.titnum
                titulo.titpar   when titulo.titpar < 100
                titulo.titvlcob
                titulo.titdtven
                titulo.titdtpag
                titulo.titvlpag when titulo.titvlpag > 0
                titulo.titvljur
                titulo.titvldes
                titulo.titsit 
                v-agendado with frame frame-a.
        if esqregua
        then display esqcom1[esqpos1] with frame f-com1.
        else display esqcom2[esqpos2] with frame f-com2.
        recatu1 = recid(titulo).
   end.
end.
end.

procedure setor-aut:
    do on error undo, retry:
        update vsetcod with frame f-set 1 down no-box color message
            side-label width 80 overlay row 6.
        if vsetcod > 0
        THEN DO:
            find setaut where setaut.setcod = vsetcod no-lock no-error.
            if not avail setaut
            then do:
                message "Setor nao cadastrado".
                undo, retry.
            end.
            disp setaut.setnom no-label with frame f-set .
        end.
    END.
end procedure.

procedure his-complemento:

    find hispad where hispad.hiscod = vlanhis no-lock no-error.
    if avail hispad and hispad.hiscom
    then do:
        if hispad.hisnum
        then vcompl = vcompl + " " + titulo.titnum.
        if hispad.hisfor
        then vcompl = vcompl + " " + forne.fornom .
        if hispad.hisdat
        then vcompl = vcompl + " " + string(titulo.titdtpag).
    end.

end procedure.

procedure agendamento:
    def var dt-agenda as date.
    def var vl-juro as dec.
    def var vl-juroc as dec.
    def var vl-desc as dec.
    def var vl-descc as dec.
    def var vl-total as dec.
    def var tit-des as dec.
    def var pct-jd as dec.
    def var qtd-titag as int.
    def var val-titag like titulo.titvlcob.
    def var des-titag like titulo.titvlcob.
    def var jur-titag like titulo.titvlcob.
    def var atu-titag like titulo.titvlcob.
    def var jur-dia as dec.
    def buffer btitulo for titulo.
    for each btitulo where btitulo.empcod = titulo.empcod and
                           btitulo.titnat = titulo.titnat and
                           btitulo.modcod = titulo.modcod and
                           btitulo.clifor = titulo.clifor and
                           btitulo.titsit <> "PAG"
                           no-lock.
        if acha("AGENDAR",btitulo.titobs[2]) <> ? and
           btitulo.titdtven <> date(acha("AGENDAR",btitulo.titobs[2])) 
        then do:
            if acha("VALJURO",btitulo.titobs[2]) <> "?"
            then vl-juro   = dec(acha("VALJURO",btitulo.titobs[2])).
            else vl-juro   = 0.
            if acha("VALDESC",btitulo.titobs[2]) <> "?"
            then vl-desc   = dec(acha("VALDESC",btitulo.titobs[2])).
            else vl-desc = 0.
            if vl-juro = ? then vl-juro = 0.
            if vl-desc = ? then vl-desc = 0.
            if vl-juro <> ?
            then jur-titag = jur-titag + vl-juro + btitulo.titvljur.
            if vl-desc <> ?
            then des-titag = des-titag + vl-desc + btitulo.titvldes.
            qtd-titag = qtd-titag + 1.
            val-titag = val-titag + btitulo.titvlcob.
        end.
    end.  
    atu-titag = val-titag - des-titag + jur-titag.
    disp qtd-titag   label "Titulos"
         val-titag   label "Valor"      
         jur-titag   label "Juro"
         des-titag   label "Desconto"
         atu-titag   label "Total"
         with frame f-disp11 no-box row 18 centered.
         
    dt-agenda = date(acha("AGENDAR",titulo.titobs[2])).
    pct-jd    = dec(acha("PCTJD",titulo.titobs[2])).
    vl-juro   = dec(acha("VALJURO",titulo.titobs[2])).
    vl-desc   = dec(acha("VALDESC",titulo.titobs[2])).
    if vl-juro = ? then vl-juro = 0.
    if vl-desc = ? then vl-desc = 0.
    vl-total = titulo.titvlcob - vl-desc + vl-juro.
    vl-juroc = vl-juroc + titulo.titvljur.
    vl-descc = vl-descc + titulo.titvldes.
    disp titulo.titnum   to 37
         /*titulo.titpar to 45*/
         titulo.titvlcob to 41 
         titulo.titdtven to 35
         dt-agenda to 35 label "Agendado   para"    format "99/99/9999"
         pct-jd    to 32 label "% Juro/Desconto" format ">>9.99%"
         vl-juro   to 35 label "JURO calculado"
         vl-juroc  label "JURO informado"
         vl-desc   to 35 label "DESCONTO calculado"
         vl-descc  label "DESCONTO informado"
         vl-total  to 35 label "   Valor  Atual" 
         with frame f-agenda 1 down row 7
         side-label color message overlay width 80.
    update dt-agenda label "Agendar para"
                    with frame f-agenda.
    if dt-agenda <> ? /*and
       dt-agenda >= today*/ 
    then do:
        update pct-jd with frame f-agenda.
        jur-dia = pct-jd / 30.
        vl-desc = 0 . vl-juro = 0.
        if dt-agenda < titulo.titdtven
        then vl-desc = ((titulo.titvlcob - titulo.titvldes) * (jur-dia / 100))
                * ( titulo.titdtven - dt-agenda ) .
        else if dt-agenda > titulo.titdtven
            then vl-juro = ((titulo.titvlcob + titulo.titvljur) 
                            * (jur-dia / 100))
                    * ( dt-agenda - titulo.titdtven) .
            
        disp vl-juro vl-desc with frame f-agenda.
        vl-total = titulo.titvlcob + vl-juro + vl-juroc 
                        - vl-desc - vl-descc.
        
        disp vl-total with frame f-agenda.
        sresp = no.
        message "Confirma agendamento ?" update sresp.
        if sresp
        then do on error undo:
            find current titulo exclusive-lock.
            titulo.titobs[2] = "|AGENDAR=" + string(dt-agenda,"99/99/9999") +
                       "|PCTJD="   + string(pct-jd,">>9.99")        + 
                       "|VALJURO=" + 
                       string(vl-juro,">,>>>,>>9.99") +
                       "|VALDESC=" + 
                       string(vl-desc,">,>>>,>>9.99") +
                       "|" .
        end.
    end.                 
    else do:
        message "Agendamento nao permitido, CONFIRA A DATA INFORMADA. ".
        pause. 
    end.
end.