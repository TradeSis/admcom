{admcab.i}

{ajusta-rateio-venda-def.i new}

def var vj as int. 
def var vtotalvlcus like plani.platot.
def var vtotal-liq like plani.platot.
def var tot-ven  like plani.platot.
def var tot-mar  like plani.platot.
def var tot-acr  like plani.platot.
def var vvlmarg like plani.platot.
def var vvlperc like plani.platot.
def var dev-m like plani.platot.
def var tro-m like plani.platot.
def var dev-c like plani.platot.
def var tro-c like plani.platot.
def var cus-m like plani.platot.
def var cus-c like plani.platot.
def var ven-c like plani.platot.
def var des-c like plani.platot.
def var acr-c like plani.platot.
def var ven-m like plani.platot.
def var des-m like plani.platot.
def var acr-m like plani.platot.
def var varquivo as char format "x(30)".
def var aa-c like plani.platot.
def var aa-m like plani.platot.
def var mm-c like plani.platot.
def var mm-m like plani.platot.
def buffer bplani for plani.
def var xx as i format "99".
def var vfer as int.
def var ii as i.
def var vv as date.
def var vdtimp      as date.
def var totmeta like plani.platot.
def var totvend like plani.platot.

def temp-table wplani
    field   wetbcod  like estab.etbcod
    field   wmeta    as char format "X"
    field   wetbcon  like estab.etbcon format ">>,>>>,>>9.99"
    field   wetbmov  like estab.etbmov format ">>,>>>,>>9.99"
    field   wdia     as int format "99"
    field   wmeta-c  like plani.platot
    field   wacum-c  like plani.platot
    field   wmeta-m  like plani.platot
    field   wacum-m  like plani.platot
    field   wcus-c   like plani.platot
    field   wven-c   like plani.platot format ">>,>>>,>>9.99"
    field   wdes-c   like plani.platot format ">>,>>9.99"
    field   wacr-c   like plani.platot format "->,>>>,>>>9.99"
    field   wdev-c   like plani.platot 
    field   wtro-c   like plani.platot 
    field   wcus-m   like plani.platot format ">>>>>,>>9.99"
    field   wven-m   like plani.platot format ">>,>>>,>>9.99"
    field   wdes-m   like plani.platot format ">>,>>9.99"
    field   wacr-m   like plani.platot format "->,>>>,>>>9.99"
    field   wdev-m   like plani.platot 
    field   wtro-m   like plani.platot .

def temp-table wmovim
    field placod like movim.placod
    field numero like plani.numero
    field movtdc like movim.movtdc
    field movdat like movim.movdat
    field procod like movim.procod
    field movqtm like movim.movqtm
    field movpc  like movim.movpc
    field movcto like estoq.estcusto
    field margem-v as dec
    field margem-p as dec
    index iq placod movtdc movdat procod.
    
def var dt     like plani.pladat.
def var acum-c like plani.platot.
def var acum-m like plani.platot.
def var vdia as int format ">9".
def var meta-c like plani.platot.
def var meta-m like plani.platot.
def var vcon like plani.platot.
def var vmov like plani.platot.
def buffer cmovim for movim.
def var vcat like produ.catcod initial 41.
def var lfin as log.
def var lcod as i.
def var vok as l.

def var vldev like plani.vlserv.
def buffer bmovim for movim.
def var wnp as i.
def var vvltotal as dec.
def var vvlcont  as dec.
def var wacr     as dec.
def var wper     as dec.
def var valortot as dec.
def var vval     as dec.
def var vval1    as dec.
def var vsal     as dec.
def var vlfinan  as dec.
def var vdti    as date format "99/99/9999".
def var vdtf    as date format "99/99/9999".
def var vetbi   like estab.etbcod.
def var vetbf   like estab.etbcod.
def var vvldesc     like plani.descprod column-label "Desconto".
def var vvlacre     like plani.acfprod column-label "Acrescimo".
def stream stela.
def var vcatcod like produ.catcod.
def buffer bcontnf for contnf.
def buffer dplani for plani.
def buffer dmovim for movim.
def buffer bprocar for procar.
def var vldevven like plani.platot.

def var v-clacod like clase.clacod.
def var v-etccod      like estac.etccod.
def var v-carcod      like caract.carcod.
def var v-subcod      like subcaract.subcod.
def var v-carcod-exc  like caract.carcod.
def var v-2-subcod  like subcaract.subcod.
def var v-exclui-prod as logical. 
def var vcomcod     like compr.comcod.

form v-carcod-exc  column-label "Caract"
     v-2-subcod  column-label "SubCaracteristica"
     with frame f-subcod centere  column 35 row 14 .

def buffer bclase for clase.
def var vignora as log.

def var v-tem-movim   as logical.

def temp-table tt-classe
    field clacod like clase.clacod.

def temp-table tt-subcarac
    field subcar like subcarac.subcod
    field subdes like subcarac.subdes
    index idx01 is primary unique subcar.

def buffer cclase for clase.
def buffer dclase for clase.
def buffer eclase for clase.
def var vforcod like forne.forcod.

def var val_com as dec.
def var val_ven as dec.
def var vvaldes as dec.
def var vvalacr as dec.
def var val_dev as dec.
 
def var vescolha as char format "x(15)" extent 2
        init["Analitico","Sintetico"].
def var vindex as int.
repeat:
    for each wplani:
        delete wplani.
    end.
    for each tt-classe:
        delete tt-classe.
    end.    
    update vcatcod label "Departamento"
                with frame f-dep width 80
                side-label color blue/cyan row 4.
    find categoria where categoria.catcod = vcatcod no-lock.
    disp categoria.catnom no-label with frame f-dep.

    update vforcod at 3 label "Fornecedor" with frame f-dep.
    
    if vforcod <> 0
    then do:
        find fabri where fabri.fabcod = vforcod no-lock no-error.
        if not avail fabri
        then do:
            message "Fabricante/Fornecedor nao Cadastrado".
            undo.
        end.    
        display fabri.fabnom no-label with frame f-dep.
    end.
    else disp "Geral" @ fabri.fabnom  with frame f-dep.

    update vcomcod at 4 label "Comprador" format ">>>9"
            with frame f-dep.
                
    find first compr where compr.comcod = vcomcod
                       and vcomcod > 0  no-lock no-error.
                                  
    if avail compr then display compr.comnom format "x(27)" no-label
                          with frame f-dep.                 
    else if vcomcod = 0 then display "TODOS" @ compr.comnom no-label
                                with frame f-dep.
    else do:
         message "Comprador n�o encontrado!" view-as alert-box.
         undo, retry.
    end.
 
    update vetbi label "Da Filial" at 4
           vetbf label "Ate a Filial"
            with frame f-dep.

    update vdti label "Periodo de"   at 3
           vdtf label "Ate" with frame f-dep.

    assign
        v-clacod = 0
        v-etccod = 0
        v-carcod = 0
        v-subcod = 0.

    update v-clacod at 1 label "Classe"
           with frame f-dep1 side-label 1 down width 80.
    if v-clacod > 0
    then do:
        find clase where clase.clacod = v-clacod no-lock.
        disp clase.clanom no-label with frame f-dep1.
        create tt-classe.
        tt-classe.clacod = clase.clacod.
        for each bclase where bclase.clasup = clase.clacod no-lock.
          create tt-classe.
          tt-classe.clacod = bclase.clacod.
          for each cclase where cclase.clasup = bclase.clacod no-lock.
            create tt-classe.
            tt-classe.clacod = cclase.clacod.
            for each dclase where dclase.clasup = cclase.clacod no-lock.
              create tt-classe.
              tt-classe.clacod = dclase.clacod.
              for each eclase where eclase.clasup = dclase.clacod no-lock.
                create tt-classe.
                tt-classe.clacod = eclase.clacod.
              end.
            end.
          end.
        end.          
    end.
    
    if vcatcod = 41
    then do:
        update v-etccod with frame f-dep1.
        if v-etccod > 0
        then do:
            find estac where estac.etccod = v-etccod no-lock. 
            disp estac.etcnom no-label with frame f-dep1. 
        end.
    end.
    
    update v-carcod at 1 with frame f-dep1.
    if v-carcod > 0
    then do on error undo:
        find caract where caract.carcod = v-carcod no-lock no-error.
        if not avail caract
        then do:
            message "Caracteristica nao cadastrada" view-as alert-box.
            undo.
        end.
        
        update v-subcod label "Sub.Car." with frame f-dep1.
        if v-subcod = 0
        then next.
        find first subcaract where 
                    subcaract.carcod = v-carcod and
                    subcaract.subcar = v-subcod no-lock.
        disp subdes format "x(20)" no-label with frame f-dep1.
    end.
    else do:
        sresp = no.
        message "Deseja informar Subcaracter�sticas para descarte?"
        update sresp.
        if sresp
        then do:
            bl_subcar:
            repeat on error undo, retry:
            
               update v-carcod-exc go-on ("end-error")
                    with frame f-subcod column 30.
               
               find first caract where caract.carcod = v-carcod-exc
                            no-lock no-error.

               if keyfunction(lastkey) = "end-error"
               then leave bl_subcar.
               
               update v-2-subcod go-on ("end-error")
                    with frame f-subcod column 0.
               
               if keyfunction(lastkey) = "end-error"
               then leave bl_subcar.
               
               if v-2-subcod = 0
               then undo, retry.
               
               find first subcaract where
                          subcaract.carcod = v-carcod-exc and
                          subcaract.subcar = v-2-subcod no-lock.
               
               create tt-subcarac.
               assign tt-subcarac.subcar = subcaract.subcar
                      tt-subcarac.subdes = subcaract.subdes.
                          
               disp tt-subcarac.subcar column-label "Cod."
                    tt-subcarac.subdes format "x(23)"
                                        column-label "SubCaracter�stica"
                         with frame f-subcaract row 5 down column 50 overlay
                            title "Descartar:".               
               next bl_subcar.
            end.
        end.
    end. 
    
    for each wmovim:
        delete wmovim.
    end.    
    vindex = 2.
    if vetbi = vetbf
    then do:
        disp vescolha with frame f-es centered no-label.
        choose field vescolha with frame f-es.
        vindex = frame-index.
    end.
    if opsys = "UNIX"
    then varquivo = "/admcom/relat/geral" + string(time).
    else varquivo = "..\relat\geral" + string(time).

        assign vvldesc  = 0
               vvlacre  = 0
               vmov    = 0
               vcon    = 0
               acum-m   = 0
               acum-c   = 0
               mm-c     = 0
               mm-m     = 0
               aa-c     = 0
               aa-m     = 0
               vtotal-liq = 0.

    if v-clacod = 0 and
       v-carcod = 0 and
       v-etccod = 0 and
       vforcod  = 0 and
       vcomcod  = 0
    then do:    
    for each estab where estab.etbcod >= vetbi and
                         estab.etbcod <= vetbf no-lock:

        if estab.etbcod = 22 then next.
        
        assign vmov    = 0
               vcon    = 0
               acum-c  = 0
               acum-m  = 0
               cus-m   = 0
               cus-c   = 0
               ven-c   = 0
               des-c   = 0
               acr-c   = 0
               ven-m   = 0
               des-m   = 0
               acr-m   = 0
               dev-m   = 0
               tro-m   = 0
               dev-c   = 0
               tro-c   = 0.

        do dt = vdti to vdtf:

            for each plani where plani.movtdc = 5             and
                                 plani.etbcod = estab.etbcod  and
                                 plani.pladat = dt no-lock:
                                 
                vvldesc  = 0.
                vvlacre = 0.

                if vcatcod <> 31 
                then vignora = no.
                else vignora = yes.
               
                assign v-tem-movim = no.

                   for each movim where movim.etbcod = plani.etbcod and
                                     movim.placod = plani.placod and
                                     movim.movtdc = plani.movtdc and
                                     movim.movdat = plani.pladat
                                      no-lock:
                                      
                       if not v-tem-movim
                       then assign v-tem-movim = yes.
                                      
                       find produ where produ.procod = movim.procod 
                            no-lock no-error.
                       if not avail produ
                       then next.
                       
                       if vforcod > 0 and
                           produ.fabcod <> vforcod
                       then next.
                       
                            /* antonio */
                            if vcatcod <> 31  
                            then if produ.catcod <> vcatcod
                                 then vignora = yes.
                            if vcatcod = 31 
                            then if produ.catcod = vcatcod or
                                 /* produ.catcod = 35 or */
                                    produ.catcod = 50 or
                                    produ.procod = 88888
                            then vignora = no. /* pelo menos 1 movel */
                       /* antonio */
                 end. /* movim */

                 if vignora
                 then next.
                 
                 if not v-tem-movim
                 then next.

                for each tt-plani: delete tt-plani. end.
                for each tt-movim: delete tt-movim. end.
                
                create tt-plani.
                buffer-copy plani to tt-plani.
                
                for each movim where movim.etbcod = plani.etbcod and
                                     movim.placod = plani.placod and
                                     movim.movtdc = plani.movtdc and
                                     movim.movdat = plani.pladat
                                      no-lock:
                    find produ where produ.procod = movim.procod 
                               no-lock no-error.
                    if not avail produ
                    then next.

                    create tt-movim.
                    buffer-copy movim to tt-movim.
                    
                end.

                run ajusta-rateio-venda-pro.p.

                for each tt-movim where tt-movim.etbcod = plani.etbcod and
                                     tt-movim.placod = plani.placod and
                                     tt-movim.movtdc = plani.movtdc and
                                     tt-movim.movdat = plani.pladat
                                     no-lock:
                    find produ where produ.procod = tt-movim.procod 
                               no-lock no-error.
                    if not avail produ
                    then next.

                    if vforcod > 0 and
                       produ.fabcod <> vforcod
                    then next.
                    
                    if vcatcod > 0 and
                       produ.catcod <> vcatcod
                    then next.    

                    if produ.procod = 88888
                    then vcat = 31.
                    else vcat = produ.catcod.

                    find estoq where estoq.etbcod = plani.etbcod and
                                         estoq.procod = produ.procod
                                   no-lock no-error.
                    if not avail estoq
                    then next.

                    if v-subcod = 0 and can-find (first tt-subcarac) 
                    then do:
                            assign v-exclui-prod = no.
                            
                            bl_tt-sub:
                            for each tt-subcarac no-lock:
                            
                                if can-find(first bprocar
                                      where bprocar.procod = produ.procod
                                        and bprocar.subcod = tt-subcarac.subcar)
                                then.
                                else do:
                                    assign v-exclui-prod = yes.
                                    leave bl_tt-sub.
                                end.
                            end.
                            
                            if v-exclui-prod
                            then next.
                    end.
                    if v-carcod > 0
                    then do.
                            sresp = no. 
                            run valprocaract.p (produ.procod, 
                                                v-carcod,
                                                v-subcod,
                                                output sresp).
                            if not sresp
                            then next. 
                    end.

                    if (vcat = 31 or
                            vcat = 35 or
                            vcat = 50)
                        then cus-m = cus-m + (tt-movim.movqtm * estoq.estcusto).
                    else cus-c = cus-c + (tt-movim.movqtm * estoq.estcusto).
                    
                    find first wmovim where 
                               wmovim.placod = plani.placod and
                               wmovim.numero = plani.numero and
                               wmovim.movdat = tt-movim.movdat and 
                               wmovim.procod = tt-movim.procod and
                               wmovim.movqtm = tt-movim.movqtm and
                               wmovim.movpc  = tt-movim.movpc  and
                               wmovim.movcto = estoq.estcusto
                               no-error.
                    if not avail wmovim
                    then do:
                            create wmovim.
                            assign
                                wmovim.placod = plani.placod
                                wmovim.numero = plani.numero
                                wmovim.movdat = tt-movim.movdat  
                                wmovim.procod = tt-movim.procod 
                                wmovim.movqtm = tt-movim.movqtm 
                                wmovim.movpc  = tt-movim.movpc  
                                wmovim.movcto = estoq.estcusto.
                    end.
                    vvlcont = 0.
                    wacr    = 0.
                    vvlacre = 0.
                    if plani.crecod >= 1
                    then do:
                        wacr = tt-movim.acr-fin.

                        if wacr < 0 or wacr = ?
                        then wacr = 0.

                        assign vvldesc  = vvldesc + tt-movim.movdes
                           vvlacre  = vvlacre  + wacr.
                    end.

                    if (vcat = 31 or
                        vcat = 35 or
                        vcat = 50)
                    then assign 
                            acum-m = acum-m + tt-movim.movtot
                            ven-m  = ven-m + (tt-movim.movpc * tt-movim.movqtm)
                            des-m  = des-m + vvldesc
                            acr-m  = acr-m + vvlacre
                            .

                    else if vcat <> 88
                    then assign
                            acum-c = acum-c + tt-movim.movtot
                            ven-c  = ven-c + (tt-movim.movpc * tt-movim.movqtm)
                            des-c  = des-c + vvldesc
                            acr-c  = acr-c + vvlacre
                            .
 
                 end.
                
                output stream stela to terminal.
                disp stream stela plani.etbcod
                                  plani.pladat
                                  with frame fffpla centered color white/red.
                pause 0.
                output stream stela close.


            end.
            run cal-dev-ven.
        end.
        
        create wplani.
        assign wplani.wetbcod = estab.etbcod
               wplani.wacum-c  = acum-c
               wplani.wacum-m  = acum-m
               wplani.wcus-c   = cus-c
               wplani.wven-c   = ven-c
               wplani.wdes-c   = des-c
               wplani.wacr-c   = acr-c
               wplani.wdev-c   = dev-c
               wplani.wtro-c   = tro-c
               wplani.wcus-m   = cus-m
               wplani.wven-m   = ven-m
               wplani.wdes-m   = des-m
               wplani.wacr-m   = acr-m
               wplani.wdev-m   = dev-m
               wplani.wtro-m   = tro-m.
    end.
    end.
    /**********************************/
    else do:  
    for each estab where estab.etbcod >= vetbi and
                         estab.etbcod <= vetbf no-lock:

        if estab.etbcod = 22 then next.
        
        assign vmov    = 0
               vcon    = 0
               acum-c  = 0
               acum-m  = 0
               cus-m   = 0
               cus-c   = 0
               ven-c   = 0
               des-c   = 0
               acr-c   = 0
               ven-m   = 0
               des-m   = 0
               acr-m   = 0
               dev-m   = 0
               tro-m   = 0
               dev-c   = 0
               tro-c   = 0.

        do dt = vdti to vdtf:
    
            for each plani where plani.movtdc = 5
                     and plani.etbcod = estab.etbcod
                     and plani.pladat = dt 
                     use-index pladat
                     no-lock :

                
                output stream stela to terminal.
                disp stream stela plani.etbcod
                                  plani.pladat
                                  with frame fffpla1 centered color white/red.
                pause 0.
                output stream stela close.
 
                vvldesc  = 0.
                vvlacre = 0.

                if vcatcod <> 31 
                then vignora = no.
                else vignora = yes.
                
                /*
                if vcatcod > 0
                then 
                */

                assign v-tem-movim = no.
                
                for each movim where movim.etbcod = plani.etbcod and
                                     movim.placod = plani.placod and
                                     movim.movtdc = plani.movtdc and
                                     movim.movdat = plani.pladat
                                      no-lock:
                       
                    if not v-tem-movim
                    then assign v-tem-movim = yes.    
                                      
                       find produ where produ.procod = movim.procod
                                                       no-lock no-error.
                       if not avail produ
                       then next.

                       if vforcod > 0 and
                           produ.fabcod <> vforcod
                       then next.

                       /* antonio */
                        if vcatcod <> 31  
                        then if produ.catcod <> vcatcod
                             then vignora = yes.
                        if vcatcod = 31 
                        then if produ.catcod = vcatcod or
                             /* produ.catcod = 35 or */
                                produ.catcod = 50 or
                                produ.procod = 88888
                        then vignora = no. /* pelo menos 1 movel */
                end.
                
                if not v-tem-movim
                then next.
                
                if vignora then next.

                for each tt-plani: delete tt-plani. end.
                for each tt-movim: delete tt-movim. end.
                
                create tt-plani.
                buffer-copy plani to tt-plani.
                
                for each movim where movim.etbcod = plani.etbcod and
                                     movim.placod = plani.placod and
                                     movim.movtdc = plani.movtdc and
                                     movim.movdat = plani.pladat
                                      no-lock:
                    find produ where produ.procod = movim.procod 
                               no-lock no-error.
                    if not avail produ
                    then next.

                    create tt-movim.
                    buffer-copy movim to tt-movim.
                    
                end.

                run ajusta-rateio-venda-pro.p.

                for each tt-movim where tt-movim.etbcod = plani.etbcod and
                             tt-movim.placod = plani.placod and
                             tt-movim.movtdc = plani.movtdc and
                             tt-movim.movdat = plani.pladat
                             no-lock:
                    find produ where produ.procod = tt-movim.procod 
                            no-lock no-error.
                    if not avail produ
                    then next.
                    if vforcod > 0 and
                       produ.fabcod <> vforcod
                    then next.

                    if vcomcod > 0
                    then do:
                        release liped.
                        release pedid.
                        find last liped where liped.procod = tt-movim.procod
                                          and liped.pedtdc = 1
                                            no-lock use-index liped2 no-error.

                        find first pedid of liped no-lock no-error.

                        if (avail pedid and pedid.comcod <> vcomcod)
                            or not avail pedid
                        then do:
                            /* Nede - 16/01/2012 */
                            find last probrick where
                            probrick.codbrick = tt-movim.procod 
                            no-lock no-error.
                             
                            if avail probrick
                            then do:
                                find last liped where 
                                liped.procod = probrick.procod and
                                liped.pedtdc = 1
                                no-lock use-index liped2 no-error.
 
                                find first pedid of liped 
                                where pedid.comcod = vcomcod
                                no-lock no-error.
                                
                                if not avail pedid then next.
                             
                            end. 
                            else next.
                            /*****/
                        
                        end.
                    end.
                    
                    if vcatcod > 0 and
                       produ.catcod <> vcatcod
                    then next.    

                    if v-clacod > 0 and
                           not can-find (first tt-classe where
                                    tt-classe.clacod = produ.clacod)
                    then next.     
                    if v-etccod > 0 and
                            produ.etccod <> v-etccod
                    then next.
                    if v-carcod > 0
                    then do.
                           sresp = no. 
                           run valprocaract.p (produ.procod, 
                                               v-carcod,
                                               v-subcod,
                                               output sresp).
                           if not sresp then next. 
                    end.
                        
                    if v-subcod = 0
                            and can-find (first tt-subcarac) 
                    then do:
                            find first bprocar where
                                       bprocar.procod = produ.procod and
                                       bprocar.subcod = v-subcod
                                               no-lock no-error.
                            if avail bprocar
                                and can-find (first tt-subcarac 
                                     where tt-subcarac.subcar = bprocar.subcod)
                            then next.
                    end.

                    if produ.procod = 88888
                    then vcat = 31.
                    else vcat = produ.catcod.
                    find estoq where estoq.etbcod = plani.etbcod and
                                         estoq.procod = produ.procod
                                                no-lock no-error.
                    if not avail estoq
                    then next.

                    if (vcat = 31 or
                            vcat = 35 or
                            vcat = 50)
                    then cus-m = cus-m + (tt-movim.movqtm * estoq.estcusto).
                    else cus-c = cus-c + (tt-movim.movqtm * estoq.estcusto).
                    
                    find first wmovim where 
                               wmovim.placod = plani.placod and
                               wmovim.numero = plani.numero and
                               wmovim.movdat = tt-movim.movdat and 
                               wmovim.procod = tt-movim.procod and
                               wmovim.movqtm = tt-movim.movqtm and
                               wmovim.movpc  = tt-movim.movpc  and
                               wmovim.movcto = estoq.estcusto
                               no-error.
                    if not avail wmovim
                    then do:
                            create wmovim.
                            assign
                                wmovim.placod = plani.placod
                                wmovim.numero = plani.numero
                                wmovim.movdat = tt-movim.movdat  
                                wmovim.procod = tt-movim.procod 
                                wmovim.movqtm = tt-movim.movqtm 
                                wmovim.movpc  = tt-movim.movpc  
                                wmovim.movcto = estoq.estcusto
                                .
                    end. 

                    vvlcont = 0.
                    wacr    = 0.
                    vvlacre = 0.
                    if plani.crecod >= 1
                    then do:
                        wacr = tt-movim.acr-fin.
                                        
                        if wacr < 0 or wacr = ?
                        then wacr = 0.

                        assign vvldesc  = vvldesc  + tt-movim.movdes
                               vvlacre  = vvlacre  + wacr.
                    end.

                    if (vcat = 31 or
                        vcat = 35 or
                        vcat = 50)
                    then assign acum-m = acum-m + tt-movim.movtot
                                ven-m  = ven-m + (movim.movpc * movim.movqtm)
                                des-m  = des-m + vvldesc
                                acr-m  = acr-m + vvlacre
                                .
                    else if vcat <> 88
                    then assign
                            acum-c = acum-c + tt-movim.movtot
                            ven-c  = ven-c + (movim.movpc * movim.movqtm)
                            des-c  = des-c + vvldesc
                            acr-c  = acr-c + vvlacre
                            .                      
                end.
            end.    
            run cal-dev-ven.
        end.
        
        create wplani.
        assign wplani.wetbcod = estab.etbcod
               wplani.wacum-c  = acum-c
               wplani.wacum-m  = acum-m
               wplani.wcus-c   = cus-c
               wplani.wven-c   = ven-c
               wplani.wdes-c   = des-c
               wplani.wacr-c   = acr-c
               wplani.wdev-c   = dev-c
               wplani.wtro-c   = tro-c
               wplani.wcus-m   = cus-m
               wplani.wven-m   = ven-m
               wplani.wdes-m   = des-m
               wplani.wacr-m   = acr-m
               wplani.wdev-m   = dev-m
               wplani.wtro-m   = tro-m.

        end.
    end.
    
   assign sresp = yes.
   message "Deseja imprimir o relat�rio?" update sresp.         
   if not sresp
   then return.
               
        {mdad_l.i
            &Saida     = "value(varquivo)"
            &Page-Size = "0"
            &Cond-Var  = "130"
            &Page-Line = "66"
            &Nom-Rel   = ""GERAL""
            &Nom-Sis   = """SISTEMA DE ESTOQUE""  + ""       DEPARTAMENTO ""
                            + string(categoria.catcod,""99"")"
            &Tit-Rel   = """MOVIMENTACAO GERAL FILIAL PERIODO DE "" +
                                  string(vdti,""99/99/9999"") + "" A "" +
                                  string(vdtf,""99/99/9999"") +
                                  ""  Dep. "" + string(vcatcod,""99"")"
            &Width     = "130"
            &Form      = "frame f-cabcab"}

 
    /*************************************/
    if vindex = 1
    then do:
        run analitico.
    end.
    else do: 
       disp with frame f-dep.
       disp with frame f-dep1.
    if categoria.catcod = 41
    then do:
        for each wplani by wplani.wetbcod:

            vvlmarg = (wplani.wven-c - wplani.wcus-c).
            vvlperc = (vvlmarg * 100) / wplani.wven-c.
            if vvlperc = ?
            then vvlperc = 0.

            if wplani.wven-c = 0
            then next.

            find estab where estab.etbcod = wplani.wetbcod no-lock no-error.

            disp estab.etbcod column-label "Fl"
                 wplani.wcus-c(total) column-label "Vl.Custo" 
                        format ">>,>>>,>>9.99"
                 wplani.wven-c(total) column-label "Venda(i1)" 
                        format ">>,>>>,>>9.99"
                 (wplani.wven-c - wplani.wcus-c)(total) 
                  column-label "Margem(1) " format "->,>>>,>>9.99"
                 vvlperc        when vvlperc >= 0 format "->>9.99%"
                 wplani.wdes-c(total) column-label "Desconto"
                 format ">>>,>>9.99"
                 wplani.wacr-c(total) column-label "Acrescimo" 
                    format ">>,>>>,>>9.99"
                 (wplani.wven-c) (total)
                    column-label "Venda(i2)"  format ">>,>>>,>>9.99"
                 ((wplani.wacr-c / wplani.wven-c) * 100)
                                    label "M %" format ">>9.99"
                 wplani.wdev-c(total) column-label "Devolucao" 
                                format ">>>,>>9.99"
                 wplani.wtro-c(total) column-label "Troca" 
                        format ">>>,>>9.99"       
                 (wplani.wven-c - wplani.wdes-c + wplani.wacr-c
                  - wplani.wdev-c - wplani.wtro-c)(total) 
                  column-label "Venda(i3)" format "->>,>>>,>>9.99"
                                            with frame f-imp width 160 down.

                tot-ven = tot-ven + wplani.wven-c.
                tot-mar = tot-mar + vvlmarg.
                tot-acr = tot-acr  + wplani.wacr-c.
                vtotalvlcus = vtotalvlcus + wplani.wcus-c.
                vtotal-liq = vtotal-liq + 
                        (wplani.wven-c - wplani.wdes-c + wplani.wacr-c
                  - wplani.wdev-c - wplani.wtro-c).
        end.
        display ((tot-mar / tot-ven) * 100) no-label format "->>9.99 %" at 53
                ((tot-acr / tot-ven) * 100) no-label format "->>9.99 %" at 103
                              with frame f-tot width 160 no-label no-box.
        
        run p-final.
        
        assign tot-ven = 0.
               tot-mar = 0.
               tot-acr = 0.
               vtotal-liq = 0.
               vtotalvlcus = 0.
               
    end.
    else do:
        for each wplani by wplani.wetbcod:

            vvlmarg = (wplani.wven-m - wplani.wcus-m).
            vvlperc = (vvlmarg * 100) / wplani.wven-m.
            if vvlperc = ?
            then vvlperc = 0.
/***
            if wplani.wven-m = 0
            then next.
***/
            find estab where estab.etbcod = wplani.wetbcod no-lock no-error.

            disp estab.etbcod column-label "Fl"
                 wplani.wcus-m(total) column-label "Vl.Custo"
                 wplani.wven-m(total) column-label "Venda(i1)"
                 (wplani.wven-m - wplani.wcus-m)(total) column-label "Margem(1)"
                                                format "->,>>>,>>9.99"
                 vvlperc        when vvlperc >= 0 format "->>9.99%"
                 wplani.wdes-m(total) column-label "Desconto"
                         format ">>>,>>9.99"
                 wplani.wacr-m(total) column-label "Acrescimo"
                         format ">>,>>>,>>9.99"
                 (wplani.wven-m - wplani.wdes-m + wplani.wacr-m) (total)
                                    format "->>,>>>,>>9.99"
                                        column-label "Venda(i2)"
                 ((wplani.wacr-m / wplani.wven-m) * 100)
                                    label "M %" format ">>9.99"
                 wplani.wdev-m(total) column-label "Devolucao"
                 wplani.wtro-m(total) column-label "Troca"
                 (wplani.wven-m - wplani.wdes-m + wplani.wacr-m
                  - wplani.wdev-m - wplani.wtro-m)(total) 
                        column-label "Venda(i3)"
                                    format "->,>>>,>>9.99"
                                            with frame f-imp1 width 165 down.

                tot-ven = tot-ven + wplani.wven-m.
                tot-mar = tot-mar + vvlmarg.
                tot-acr = tot-acr  + wplani.wacr-m.
                vtotal-liq = vtotal-liq + (wplani.wven-m - wplani.wdes-m + 
                wplani.wacr-m - wplani.wdev-m - wplani.wtro-m).
                vtotalvlcus = vtotalvlcus + wplani.wcus-m.
        end.

        display ((tot-mar / tot-ven) * 100) no-label format "->>9.99 %" at 45
                ((tot-acr / tot-ven) * 100) no-label format "->>9.99 %" at 90
                              with frame f-tot width 150 no-label no-box.
        run p-final.
        
        assign tot-ven = 0.
               tot-mar = 0.
               tot-acr = 0.
               vtotal-liq = 0.
               vtotalvlcus = 0.
    end.
    end. 
    
    output close.
   
    if opsys = "UNIX"
    then do:
        run visurel.p (input varquivo, input "").
    end.
    else do:
        {mrod.i}.
    end.

end.

procedure p-final:
    put skip(2).
    
    put "MARGEM MES...:" space(2)
          ((  (((tot-acr / tot-ven) * 100) + 100) / 
                      (100 - ((tot-mar / tot-ven) * 100)) - 1) * 100)
                      format "->>>>>>,>>9.99 %".
    
    put skip(1).
    
    put "VERBA GERADA.:" (vtotal-liq * (if vcatcod = 31
                                        then 0.65
                                        else 0.54)) format "->>>,>>>,>>9.99".

    put skip.
    
    put "VERBA EFETIVA:"~ vtotalvlcus format "->>>,>>>,>>9.99".

    put skip.
    
    put "SALDO........:" ((vtotal-liq * (if vcatcod = 31 
                                         then 0.65  
                                         else 0.54)) - vtotalvlcus)
                                         format "->>>,>>>,>>9.99".
    
    put skip(2).
 
    put "Venda(i1) : Qtd Itens Vendidos * Preco Itens Vendidos".
    put skip.
    put "Venda(i2) : Venda(i1) - descontos + acrescimo".
    put skip.
    put "Venda(i3) : Venda(i) - devolucao - valor de troca".
    

end procedure.

procedure  analitico:
    def var t-movpc as dec.
    def var t-movcto as dec.
    def var v-movpc as dec.
    def var v-movcto as dec.
    form with frame f-dm.
    disp with frame f-dep.
    disp with frame f-dep1.
    for each wmovim:
        find produ where produ.procod = wmovim.procod 
                no-lock no-error.
        if not avail produ then next.
                
        if vcatcod > 0 and
            produ.catcod <> vcatcod
        then next.    
        if (categoria.catcod <> 41 and
           produ.catcod = 41) or
           (categoria.catcod = 41 and
           produ.catcod <> 41)
        then delete wmovim.
        else do:
        wmovim.margem-v =  (wmovim.movpc * wmovim.movqtm) -
                           (wmovim.movcto * wmovim.movqtm)
                    .
        wmovim.margem-p =   (((wmovim.movpc * wmovim.movqtm) -
             (wmovim.movcto * wmovim.movqtm)) /
              (wmovim.movpc * wmovim.movqtm)) * 100 .
        end.
    end. 
    assign
        t-movpc = 0 t-movcto = 0.         
    for each wmovim break by margem-v:
        find produ where produ.procod = wmovim.procod 
                no-lock no-error.
        if not avail produ then next.        
        if vcatcod > 0 and
            produ.catcod <> vcatcod
        then next.
        v-movpc = wmovim.movpc * wmovim.movqtm.
        v-movcto = wmovim.movcto * wmovim.movqtm.    
        disp wmovim.procod 
             produ.pronom   format "x(30)"
             wmovim.movdat
             wmovim.numero format ">>>>>>>>9"
             wmovim.movqtm column-label "qtd"  format ">>9"
             v-movpc column-label "preco" format ">>>,>>9.99"
             v-movcto column-label "custo" format ">>>,>>9.99"
             wmovim.margem-v  column-label "margemR$" format "->>>>,>>9.99"
             wmovim.margem-p  column-label "margem%" format "->>>>,>>9.99" 
             with frame f-dm down width 130.
        down with frame f-dm.
        assign
            t-movpc = t-movpc + (wmovim.movpc * wmovim.movqtm)
            t-movcto = t-movcto + (wmovim.movcto * wmovim.movqtm).
    end.            
    down with frame f-dm.
    disp t-movpc @ v-movpc
         t-movcto @ v-movcto
         t-movpc - t-movcto @ wmovim.margem-v
         ((t-movpc - t-movcto) / t-movpc) * 100 @ wmovim.margem-p
         with frame f-dm.
end procedure. 

procedure cal-dev-ven:
    for each dplani where dplani.movtdc = 12             and
                          dplani.etbcod = estab.etbcod   and
                          dplani.pladat = dt no-lock:
                          
          vignora = no.

          if vcatcod > 0
          then do: 
               for each dmovim where dmovim.etbcod = dplani.etbcod and
                                     dmovim.placod = dplani.placod and
                                     dmovim.movtdc = dplani.movtdc and
                                     dmovim.movdat = dplani.pladat
                                      no-lock:
                       find produ where produ.procod = dmovim.procod
                                                       no-lock no-error.
                       if avail produ
                       then if vcatcod > 0 and
                               produ.catcod <> vcatcod
                            then vignora = yes.
                 end.
                 if vignora then next.
            end.
                          
        for each dmovim where 
                 dmovim.etbcod = dplani.etbcod and
                 dmovim.placod = dplani.placod and
                 dmovim.movtdc = dplani.movtdc
                 no-lock.         
            find produ where produ.procod = dmovim.procod 
                    no-lock no-error.
            if not avail produ
            then next.
            
            if vforcod > 0 and
                produ.fabcod <> vforcod
            then next.
            
            for each ctdevven where 
                     ctdevven.movtdc = dplani.movtdc and
                     ctdevven.etbcod = dplani.etbcod and
                     ctdevven.placod = dplani.placod
                     no-lock:
                find plani where 
                     plani.etbcod = ctdevven.etbcod-ori and
                     plani.placod = ctdevven.placod-ori and
                     plani.movtdc = ctdevven.movtdc-ori 
                     no-lock no-error.
                if avail plani
                then do:
                    find movim where movim.etbcod = plani.etbcod and
                                     movim.placod = plani.placod and
                                     movim.movtdc = plani.movtdc and
                                     movim.procod = dmovim.procod
                                     no-lock no-error.
                    if avail movim
                    then do:
                        vldevven = 0.
                        if movim.movqtm > dmovim.movqtm
                        then vldevven = movim.movpc * dmovim.movqtm.
                        else vldevven = movim.movpc * movim.movqtm.
                        if produ.catcod = 31 or
                           produ.catcod = 35 or
                           produ.catcod = 50
                        then do:    
                            if ctdevven.etbcod-ven = 0
                            then dev-m = dev-m + vldevven.
                            else tro-m = tro-m + vldevven.
                        end.
                        else do:
                            if ctdevven.etbcod-ven = 0
                            then dev-c = dev-c + vldevven.
                            else tro-c = tro-c + vldevven.
                        end.
                    end.                 
                end.
            end.
        end.
    end.  
end procedure.    
