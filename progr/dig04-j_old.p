/*
  31
  15/08/2006
  23
  401340
*/
  
{admcab.i}

def var venderecos as char.
def var vtipo-aux as int.
def var vaspas as char.
vaspas = chr(34).

def var vopcao-sai as char format "x(25)" extent 2
                initial ["  1. Visualizar em Tela",
                         "  2. Envio por Email   "].

def var vop as log format "GERAL/PARCIAL".
def var varquivo as char.
def var vemail as log.
def var tot  like plani.platot.
def var tot1  like plani.platot.
def var vac   like plani.platot.
def var tot2  like plani.platot.
def var vde   like plani.platot.
def var vest like estoq.estatual.
def var vtipo as char format "x(10)" extent 2
                initial ["Numerica","Alfabetica"].
def var vpend   as int format "->>>9".
def var vetbcod like estab.etbcod.
def var vqtd like estoq.estinvctm format "->,>>9.99".
def var vprocod like estoq.procod.
def var vdata   like estoq.estbaldat format "99/99/9999".
def var vcatcod like produ.catcod.
form vprocod
     produ.pronom format "x(30)"
     vqtd
     vpend
     coletor.colqtd column-label "Qtd" with frame f-pro width 80 down.

update  vcatcod with frame f-data.
find categoria where categoria.catcod = vcatcod no-lock.
display categoria.catnom no-label with frame f-data.
update  vdata label "Data Referencia" with frame f-data side-label centered.

repeat:
    update vetbcod with frame f-etbcod side-label width 80.
    find estab where estab.etbcod = vetbcod no-lock no-error.
    if not avail estab
    then do:
        message "Estabelecimento nao cadastrado".
        undo, retry.
    end.
    display estab.etbnom no-label with frame f-etbcod.
    repeat:
        assign tot  = 0 tot1 = 0 vac  = 0
               tot2 = 0 vde  = 0 vprocod = 0.

        update vprocod with frame f-pro down width 80.
        find produ where produ.procod = vprocod no-lock.
        display produ.pronom format "x(30)"
                    with frame f-pro.
        vqtd = 0.                                                  
        vpend = 0.
        find estoq where estoq.etbcod = estab.etbcod 
                     and estoq.procod = produ.procod 
                         no-lock no-error.

        find coletor where coletor.etbcod = estab.etbcod and
                           coletor.procod = produ.procod and
                           coletor.coldat = vdata no-error.
        if not avail coletor
        then do transaction:
            create coletor.
            assign coletor.etbcod = estab.etbcod
                   coletor.procod = produ.procod
                   coletor.coldat = vdata.
        end.
        do transaction:
            display coletor.colqtd with frame f-pro.
            update vqtd column-label "Quantidade"
                   vpend column-label "Pendencia" with frame f-pro.
            coletor.colacr = 0.
            coletor.coldec = 0.
            if vpend >= 0
            then coletor.colqtd =  coletor.colqtd + vqtd - vpend.
            else coletor.colqtd =  coletor.colqtd + vqtd + vpend.
            display coletor.colqtd with frame f-pro down.
            down with frame f-pro.
        end.
        vest = estoq.estatual.
        
        for each movim where movim.etbcod = estab.etbcod and
                             movim.procod = produ.procod and
                             movim.movtdc = 08           and
                             movim.movdat > vdata no-lock:
            
            
            find first plani where plani.etbcod = movim.etbcod and
                                   plani.placod = movim.placod and
                                   plani.movtdc = movim.movtdc and
                                   plani.pladat = movim.movdat 
                                       use-index plani no-lock no-error.

            if not avail plani 
            then next.
            

            vest = vest + movim.movqtm.
            
        end.
            
            
        for each movim where movim.etbcod = estab.etbcod and
                             movim.procod = produ.procod and
                             movim.movtdc = 07           and
                             movim.movdat > vdata no-lock:
            
            
            find first plani where plani.etbcod = movim.etbcod and
                                   plani.placod = movim.placod and
                                   plani.movtdc = movim.movtdc and
                                   plani.pladat = movim.movdat 
                                       use-index plani no-lock no-error.

            if not avail plani 
            then next.
            
            vest = vest - movim.movqtm.

        end.
            

         
        
        for each movim where movim.procod = produ.procod and
                             movim.emite  = estab.etbcod and
                             movim.datexp > vdata no-lock:

            if movim.movtdc = 7 or
               movim.movtdc = 8
            then next.

             
            find first plani where plani.etbcod = movim.etbcod and
                                   plani.placod = movim.placod and
                                   plani.movtdc = movim.movtdc and
                                   plani.pladat = movim.movdat use-index plani
                                                     no-lock no-error.

            if not avail plani
            then next.
            
            if plani.etbcod <> estab.etbcod and
               plani.desti  <> estab.etbcod
            then next.

            if plani.emite = 22 and
               plani.serie = "m1"
            then next.

            if plani.movtdc = 5 and
               plani.emite  <> estab.etbcod
            then next.

            if movim.movtdc = 5 or
               movim.movtdc = 13 or
               movim.movtdc = 14 or
               movim.movtdc = 16 or
               movim.movtdc = 8  or
               movim.movtdc = 18
               then do:
                   if movim.movdat >= vdata
                   then vest = vest + movim.movqtm.
               end.

            if movim.movtdc = 4 or
               movim.movtdc = 1 or
               movim.movtdc = 7 or
               movim.movtdc = 12 or
               movim.movtdc = 15 or
               movim.movtdc = 17
            then do:
                if movim.movdat >= vdata
                then vest = vest - movim.movqtm.
            end.

            if movim.movtdc = 6
            then do:
                if plani.etbcod = estab.etbcod
                then do:
                    if movim.movdat >= vdata
                    then vest = vest + movim.movqtm.
                end.
                if plani.desti = estab.etbcod
                then do:
                    if movim.movdat >= vdata
                    then vest = vest - movim.movqtm.
                end.
            end.
        end.
        
        for each movim where movim.procod = produ.procod and
                             movim.desti  = estab.etbcod and
                             movim.datexp > vdata no-lock:

             if movim.movtdc = 7 or
                movim.movtdc = 8
             then next.

             find first plani where plani.etbcod = movim.etbcod and
                                   plani.placod = movim.placod and
                                   plani.movtdc = movim.movtdc and
                                   plani.pladat = movim.movdat no-lock no-error.

            if not avail plani
            then next.
            
            if avail plani
            then do:
                if plani.emite = 22 and desti = 996
                then next.
                
            end.
            
            if movim.movtdc = 5  or 
               movim.movtdc = 12 or 
               movim.movtdc = 13 or 
               movim.movtdc = 14 or 
               movim.movtdc = 16 
            then next.
            

            
            
            if plani.etbcod <> estab.etbcod and
               plani.desti  <> estab.etbcod
            then next.

            if plani.emite = 22 and
               plani.serie = "m1"
            then next.

            if plani.movtdc = 5 and
               plani.emite  <> estab.etbcod
            then next.
            if movim.movtdc = 5 or
               movim.movtdc = 13 or
               movim.movtdc = 14 or
               movim.movtdc = 16 or
               movim.movtdc = 8  
               then do:
                   if movim.movdat >= vdata
                   then vest = vest + movim.movqtm.
               end.

            if movim.movtdc = 4 or
               movim.movtdc = 1 or
               movim.movtdc = 7 or
               movim.movtdc = 12 or
               movim.movtdc = 15
            then do:
                if movim.movdat >= vdata
                then vest = vest - movim.movqtm.
            end.

            if movim.movtdc = 6
            then do:
                if plani.etbcod = estab.etbcod
                then do:
                    if movim.movdat >= vdata
                    then vest = vest + movim.movqtm.
                end.
                if plani.desti = estab.etbcod
                then do:
                    if movim.movdat >= vdata
                    then vest = vest - movim.movqtm.
                end.
            end.
        end.
        
        do transaction:
            if vest > coletor.colqtd
            then coletor.coldec = vest - coletor.colqtd.

            if vest < coletor.colqtd
            then coletor.colacr = coletor.colqtd - vest.
        end.

    end.

    message "Deseja gerar arquivo" update sresp.
    if not sresp
    then return.
    
    display "GERANDO ARQUIVO PARA CONFRONTO................"
                            WITH FRAME F-MEN CENTERED ROW 10 OVERLAY.


    for each produ where produ.catcod = vcatcod no-lock:
        find coletor where coletor.etbcod = estab.etbcod and
                           coletor.procod = produ.procod and
                           coletor.coldat = vdata no-error.
        if avail coletor
        then next.
        find estoq where estoq.etbcod = estab.etbcod and
                         estoq.procod = produ.procod no-lock no-error.
        if not avail estoq
        then next.
        
        display produ.procod with 1 down. pause 0.
        
        
        vest = estoq.estatual.
        
        
        for each movim where movim.etbcod = estab.etbcod and
                             movim.procod = produ.procod and
                             movim.movtdc = 08           and
                             movim.movdat > vdata no-lock:
            
            
            find first plani where plani.etbcod = movim.etbcod and
                                   plani.placod = movim.placod and
                                   plani.movtdc = movim.movtdc and
                                   plani.pladat = movim.movdat 
                                         use-index plani no-lock no-error.

            if not avail plani 
            then next.
            

            vest = vest + movim.movqtm.
            
        end.
            
            
        for each movim where movim.etbcod = estab.etbcod and
                             movim.procod = produ.procod and
                             movim.movtdc = 07           and
                             movim.movdat > vdata no-lock:
            
            
            find first plani where plani.etbcod = movim.etbcod and
                                   plani.placod = movim.placod and
                                   plani.movtdc = movim.movtdc and
                                   plani.pladat = movim.movdat 
                                         use-index plani no-lock no-error.

            if not avail plani 
            then next.
            
            vest = vest - movim.movqtm.

        end.
            

 
        
        
        for each movim where movim.procod = produ.procod and
                             movim.emite  = estab.etbcod and
                             movim.datexp > vdata no-lock:
        
            if movim.movtdc = 7 or
               movim.movtdc = 8
            then next.

         
            
            find first plani where plani.etbcod = movim.etbcod and
                                   plani.placod = movim.placod and
                                   plani.movtdc = movim.movtdc and
                                   plani.pladat = movim.movdat use-index plani
                                                     no-lock no-error.

            if not avail plani
            then next.
            
            if plani.etbcod <> estab.etbcod and
               plani.desti  <> estab.etbcod
            then next.

            if plani.emite = 22 and
               plani.serie = "m1"
            then next.

            if plani.movtdc = 5 and
               plani.emite  <> estab.etbcod
            then next.

            if movim.movtdc = 5 or
               movim.movtdc = 13 or
               movim.movtdc = 14 or
               movim.movtdc = 16 or
               movim.movtdc = 8  or
               movim.movtdc = 18
               then do:
                   if movim.movdat >= vdata
                   then vest = vest + movim.movqtm.
               end.

            if movim.movtdc = 4 or
               movim.movtdc = 1 or
               movim.movtdc = 7 or
               movim.movtdc = 12 or
               movim.movtdc = 15 or
               movim.movtdc = 17
            then do:
                if movim.movdat >= vdata
                then vest = vest - movim.movqtm.
            end.

            if movim.movtdc = 6
            then do:
                if plani.etbcod = estab.etbcod
                then do:
                    if movim.movdat >= vdata
                    then vest = vest + movim.movqtm.
                end.
                if plani.desti = estab.etbcod
                then do:
                    if movim.movdat >= vdata
                    then vest = vest - movim.movqtm.
                end.
            end.
        end.
        
        for each movim where movim.procod = produ.procod and
                             movim.desti  = estab.etbcod and
                             movim.datexp > vdata no-lock:

            if movim.movtdc = 7 or
               movim.movtdc = 8
            then next.

         
            
            find first plani where plani.etbcod = movim.etbcod and
                                   plani.placod = movim.placod and
                                   plani.movtdc = movim.movtdc and
                                   plani.pladat = movim.movdat
                                                     no-lock no-error.

            if not avail plani
            then next.
            
            if avail plani
            then do:
                if plani.emite = 22 and desti = 996
                then next.
                
            end.
            
            if movim.movtdc = 5  or 
               movim.movtdc = 12 or 
               movim.movtdc = 13 or 
               movim.movtdc = 14 or 
               movim.movtdc = 16 
            then next.
            

            
            
            if plani.etbcod <> estab.etbcod and
               plani.desti  <> estab.etbcod
            then next.

            if plani.emite = 22 and
               plani.serie = "m1"
            then next.

            if plani.movtdc = 5 and
               plani.emite  <> estab.etbcod
            then next.
            if movim.movtdc = 5 or
               movim.movtdc = 13 or
               movim.movtdc = 14 or
               movim.movtdc = 16 or
               movim.movtdc = 8  
               then do:
                   if movim.movdat >= vdata
                   then vest = vest + movim.movqtm.
               end.

            if movim.movtdc = 4 or
               movim.movtdc = 1 or
               movim.movtdc = 7 or
               movim.movtdc = 12 or
               movim.movtdc = 15 
            then do:
                if movim.movdat >= vdata
                then vest = vest - movim.movqtm.
            end.

            if movim.movtdc = 6
            then do:
                if plani.etbcod = estab.etbcod
                then do:
                    if movim.movdat >= vdata
                    then vest = vest + movim.movqtm.
                end.
                if plani.desti = estab.etbcod
                then do:
                    if movim.movdat >= vdata
                    then vest = vest - movim.movqtm.
                end.
            end.
        end.

 
        if vest = 0
        then next.

        do transaction:
            create coletor.
            assign coletor.etbcod = estab.etbcod
                   coletor.procod = produ.procod
                   coletor.coldat = vdata
                   coletor.colqtd = vest. 
        end.

        do transaction:
            if vest > coletor.colqtd
            then coletor.coldec = vest - coletor.colqtd.

            if vest < coletor.colqtd
            then coletor.colacr = coletor.colqtd - vest.
        end.
        
    end.



    vop = yes.

    message "Listagem: [ G ] Geral  [ P ] Parcial" update vop.

    display vtipo no-label with frame ff centered row 10.
    choose field vtipo with frame ff.
    
    vtipo-aux = frame-index.
    
    if opsys = "UNIX"
    then varquivo = "/admcom/relat/dig" + string(time).
    else varquivo = "..\relat\dig" + string(time).
    
    if opsys = "UNIX"
    then do:  /*
        display skip(1) vopcao-sai[1] no-label
                skip
                vopcao-sai[2] no-label skip(1)
                with frame f-opcao-sai centered row 10.

        choose field vopcao-sai with frame f-opcao-sai.
        if frame-index = 1
        then vemail = no.
        else*/ assign vemail = yes
                    varquivo = "dig_" 
                             + string(estab.etbcod,"999")
                             + "_"
                             + string(categoria.catcod,"99")
                             + "_"
                             + string(year(vdata),"9999")
                             + string(month(vdata),"99")
                             + string(day(vdata),"99")
                             + ".htm".

        output to value(varquivo) page-size 0.
        if vemail 
        then do:
             if vop
             then run p-cabecalho-a.
             else run p-cabecalho-s.
        end.
    end.
    else do:
    
      {mdad_l.i
        &Saida     = "value(varquivo)"
        &Page-Size = "0"
        &Cond-Var  = "147"
        &Page-Line = "66"
        &Nom-Rel   = """dig04"""
        &Nom-Sis   = """SISTEMA DE ESTOQUE"""
        &Tit-Rel   = """CONTROLE DE ESTOQUE - "" + estab.etbnom + ""  "" +
                                                   categoria.catnom + "" "" +
                                          string(vdata,""99/99/9999"")"
        &Width     = "147"
        &Form      = "frame f-cab"}
        
    end.
    
    if /*frame-index = 1*/ vtipo-aux = 1
    then do:
        for each coletor where coletor.etbcod = vetbcod and
                               coletor.coldat = vdata no-lock by coletor.procod:

            find produ where produ.procod = coletor.procod no-lock.
            if vemail
            then do:
                run p-corpo-s.
            end.
            else do:
                /*
                display produ.procod
                    produ.pronom 
                    coletor.colqtd column-label "Quantidade" format "->>,>>9.99"
                    coletor.colacr when coletor.colacr > 0 format "->>,>>9.99"
                    coletor.coldec when coletor.coldec > 0 format "->>,>>9.99"
                                        with frame f-cotac down width 200.
                */                        
            end.
        end.
    end. 
    else do: 
        for each produ use-index catpro where 
                            produ.catcod = categoria.catcod no-lock,
            each coletor where coletor.etbcod = vetbcod and
                               coletor.procod = produ.procod and
                               coletor.coldat = vdata break by produ.catcod:

            find estoq where estoq.etbcod = coletor.etbcod and
                             estoq.procod = produ.procod no-lock no-error.
            if avail estoq 
            then vest = estoq.estatual.
            else next.
            
        
            
            for each movim where movim.etbcod = estab.etbcod and
                                 movim.procod = produ.procod and
                                 movim.movtdc = 08           and
                                 movim.movdat > vdata no-lock:
            
            
                find first plani where plani.etbcod = movim.etbcod and
                                       plani.placod = movim.placod and
                                       plani.movtdc = movim.movtdc and
                                       plani.pladat = movim.movdat 
                                         use-index plani no-lock no-error.

                if not avail plani 
                then next.
            

                vest = vest + movim.movqtm.
            
            end.
            
            
            for each movim where movim.etbcod = estab.etbcod and
                                 movim.procod = produ.procod and
                                 movim.movtdc = 07           and
                                 movim.movdat > vdata no-lock:
            
            
                find first plani where plani.etbcod = movim.etbcod and
                                       plani.placod = movim.placod and
                                       plani.movtdc = movim.movtdc and
                                       plani.pladat = movim.movdat 
                                         use-index plani no-lock no-error.

                if not avail plani 
                then next.
            
                vest = vest - movim.movqtm.

            end.
            
            for each movim where movim.procod = produ.procod and
                                 movim.emite  = estab.etbcod and
                                 movim.datexp > vdata no-lock:

                if movim.movtdc = 7 or
                   movim.movtdc = 8
                then next.

                 
                
                find first plani where plani.etbcod = movim.etbcod and
                                       plani.placod = movim.placod and
                                       plani.movtdc = movim.movtdc and
                                       plani.pladat = movim.movdat 
                                         use-index plani no-lock no-error.

                if not avail plani 
                then next.
            
                if plani.etbcod <> estab.etbcod and 
                   plani.desti  <> estab.etbcod
                then next.

                if plani.emite = 22 and 
                   plani.serie = "m1" 
                then next.

                if plani.movtdc = 5 and 
                   plani.emite  <> estab.etbcod 
                then next.

                if movim.movtdc = 5 or
                   movim.movtdc = 13 or
                   movim.movtdc = 14 or
                   movim.movtdc = 16 or
                   movim.movtdc = 8  or
                   movim.movtdc = 18
                then do: 
                    if movim.movdat >= vdata
                    then vest = vest + movim.movqtm.
                end.

                if movim.movtdc = 4 or
                   movim.movtdc = 1 or
                   movim.movtdc = 7 or 
                   movim.movtdc = 12 or 
                   movim.movtdc = 15 or 
                   movim.movtdc = 17 
                then do: 
                    if movim.movdat >= vdata
                    then vest = vest - movim.movqtm.
                end.

                if movim.movtdc = 6
                then do:
                    if plani.etbcod = estab.etbcod
                    then do:
                        if movim.movdat >= vdata
                        then vest = vest + movim.movqtm.
                    end.
                    if plani.desti = estab.etbcod
                    then do:
                        if movim.movdat >= vdata
                        then vest = vest - movim.movqtm.
                    end.
                end.
            end.
        
            
            for each movim where movim.procod = produ.procod and
                                 movim.desti  = estab.etbcod and
                                 movim.datexp > vdata no-lock:

                if movim.movtdc = 7 or
                   movim.movtdc = 8
                then next.

                find first plani where plani.etbcod = movim.etbcod and
                                       plani.placod = movim.placod and
                                       plani.movtdc = movim.movtdc and
                                       plani.pladat = movim.movdat
                                           no-lock no-error.

                if not avail plani
                then next.
            
                if avail plani
                then do:
                    if plani.emite = 22 and desti = 996
                    then next.
                
                end.
            
                if movim.movtdc = 5  or  
                   movim.movtdc = 12 or  
                   movim.movtdc = 13 or  
                   movim.movtdc = 14 or  
                   movim.movtdc = 16 
                then next.
            
            
                if plani.etbcod <> estab.etbcod and
                   plani.desti  <> estab.etbcod
                then next.

                if plani.emite = 22 and
                   plani.serie = "m1"
                then next.

                if plani.movtdc = 5 and
                   plani.emite  <> estab.etbcod
                then next.
                if movim.movtdc = 5 or
                   movim.movtdc = 13 or
                   movim.movtdc = 14 or
                   movim.movtdc = 16 or
                   movim.movtdc = 8  
                then do:
                    if movim.movdat >= vdata
                    then vest = vest + movim.movqtm.
                end.

                if movim.movtdc = 4 or
                   movim.movtdc = 1 or
                   movim.movtdc = 7 or
                   movim.movtdc = 12 or
                   movim.movtdc = 15 
                then do:
                    if movim.movdat >= vdata
                    then vest = vest - movim.movqtm.
                end.

                if movim.movtdc = 6
                then do:
                    if plani.etbcod = estab.etbcod
                    then do:
                        if movim.movdat >= vdata
                        then vest = vest + movim.movqtm.
                    end.
                    if plani.desti = estab.etbcod
                    then do:
                        if movim.movdat >= vdata
                        then vest = vest - movim.movqtm.
                    end.
                end.
            end.    
            
            if vest = coletor.colqtd
            then do transaction:
                assign coletor.colacr = 0
                       coletor.coldec = 0.

                if vop = no
                then next.
                
            end.
            
            
            if coletor.colacr >= 0
            then assign tot = coletor.colacr
                        tot1 = tot1 + (estoq.estcusto * coletor.colacr)
                        vac  = vac  + coletor.colacr.

            if coletor.coldec >= 0
            then assign tot = coletor.coldec
                        tot2 = tot2 + (estoq.estcusto * coletor.coldec)
                        vde  = vde  + coletor.coldec.

            if vemail
            then do:
         
                run p-corpo-a.
                
            end.
            else do:        /*
               display produ.procod
                    produ.pronom format "x(37)"
                    vest(total by produ.catcod)
                        column-label "Comput." format "->>>>9"
                    coletor.colqtd(total by produ.catcod) 
                        column-label "Fisico" format "->>>>9"
                    coletor.colacr when coletor.colacr > 0 format "->>>>>9"
                    coletor.coldec when coletor.coldec > 0 format "->>>>>9"
                    estoq.estcusto column-label "Pc.Custo" format ">,>>9.99"
                    (coletor.colacr * estoq.estcusto) when colacr > 0
                        column-label "Acresc" format   "->>>>9"
                    (coletor.coldec * estoq.estcusto) when coldec > 0
                        column-label "Decres"  format "->>>>9"
                                        with frame f-cotac2 down width 200.
                          */
            end.    
        end.
        if vemail
        then do:

            run p-rodape.

        end.    
        else 
             put skip "TOTAL VL. ACRESCIMO : " at 40 tot1
                      "  TOTAL ACRESCIMO     : "       vac skip
                      "TOTAL VL. DECRESCIMO: " at 40 tot2
                      "  TOTAL DECRESCIMO    : "       vde.

    end.

    output close.

    venderecos = "filial" + string(vetbcod,"99") + "@lebes.com.br," +
                 "auditoria@lebes.com.br," +
                 "julio@custombs.com.br,rafael@lebes.com.br".
    
    if opsys = "UNIX"
    then do:

        if not vemail
        then run visurel.p (input varquivo, 
                            input " CONTROLE DE ESTOQUE ").
        else do:
        
            unix silent /admcom/progr/mail.sh 
                "Digitacao_de_Confronto_Auditoria" value(varquivo) 
                value(venderecos) " >> /admcom/logs/mail-audi.log 2>&1" .
                
            /***
            unix silent /usr/bin/metasend -b -s "Digitacao_de_Confronto_Auditoria" -F informativo@lebes.com.br -f value(varquivo) -m text/html -t julio@custombs.com.br.

            unix silent /usr/bin/metasend -b -s "Digitacao_de_Confronto_Auditor~ia" -F informativo@lebes.com.br -f value(varquivo) -m text/html -t brocca@lebes.com.br

            unix silent /usr/bin/metasend -b -s "Digitacao_de_Confronto_Auditor~~ia" -F informativo@lebes.com.br -f value(varquivo) -m text/html -t rafael@lebes.com.br


            unix silent /usr/bin/metasend -b -s "Digitacao_de_Confronto_Auditoria" -F informativo@lebes.com.br -f value(varquivo) -m text/html -t cassio@lebes.com.br.
            ***/
            
            
        end.
    end.
    else do:
        {mrod_l.i}
    end.        

end.

procedure p-cabecalho-a:

    put "<html>" skip
               "<body>" skip
               "<table border=" vaspas "0" vaspas "summary=>" skip
               "<tr>" skip
               "<td width=820 align=center><b><h3>"
               "DIGITACÃO DE CONFRONTO - AUDITORIA - ANALÍTICO"
               "</h3></b></td>" skip
               "</tr>" skip
               "</table>" skip
             
               "<br>"
               "<font size=3><b>Parametros:</b></font><br>"
               "<font size=3><b>&nbsp;&nbsp;&nbsp;Estabelecimento.:&nbsp;"
               estab.etbnom format "x(50)"
               "</b></font><br>"
               "<font size=3><b>&nbsp;&nbsp;&nbsp;Departamento....:&nbsp;"
               string(categoria.catcod,">9") " - "
                    categoria.catnom format "x(50)"
               "</b></font><br>"
               "<font size=3><b>&nbsp;&nbsp;&nbsp;Data Referencia:&nbsp;"
               vdata format "99/99/9999"
               "</b></font>"
               
               "<br><br>"
               "<table border=1 borderColor=black>" skip
               "<tr>" skip
               "<td width=50 align=left><b><font size=2>Produto"
               "</font></b></td>"     skip
               "<td width=420 align=left><b><font size=2>Descrição"
               "</font></b></td>"  skip
               "<td width=50 align=left><b><font size=2>Comput"
               "</font></b></td>" skip
               "<td width=50 align=left><b><font size=2>Fisico"
               "</font></b></td>" skip
               
               "<td width=50 align=left><b><font size=2>Acresc"
               "</font></b></td>" skip
               "<td width=50 align=left><b><font size=2>Decres"
               "</font></b></td>" skip

               "<td width=55 align=left><b><font size=2>P.Custo"
               "</font></b></td>" skip
               "<td width=50 align=left><b><font size=2>Acresc"
               "</font></b></td>" skip
               "<td width=50 align=left><b><font size=2>Decres"
               "</font></b></td>" skip
               
               "</tr>" skip.


end procedure.

procedure p-cabecalho-s:

           put "<html>" skip
               "<body>" skip
               "<table border=" vaspas "0" vaspas "summary=>" skip
               "<tr>" skip
               "<td width=820 align=center><b><h2>"
               "DIGITACAO DE CONFRONTO - AUDITORIA - SINTETICO"
               "</h2></b></td>" skip
               "</tr>" skip
               "</table>" skip
               "<table border=1 borderColor=black>" skip
               "<tr>" skip
               "<td width=50 align=left><b><font size=2>Produto"
               "</font></b></td>"     skip
               "<td width=420 align=left><b><font size=2>Descrição"
               "</font></b></td>"  skip
               "<td width=70 align=left><b><font size=2>Quantidade"
               "</font></b></td>" skip
               
               "<td width=70 align=left><b><font size=2>Acrescimo"
               "</font></b></td>" skip
               "<td width=70 align=left><b><font size=2>Decrescimo"
               "</font></b></td>" skip
               
               "</tr>" skip.

end procedure.

procedure p-corpo-a:

        put skip
            "<tr>" 
            skip 
            "<td width=50 align=left><font size=2>"
            produ.procod   "</font></td>"  skip
            "<td width=420 align=left><font size=2>"  
            produ.pronom  format "x(37)" "</font></td>"
            skip
            "<td width=50 align=right><font size=2>"  vest format "->>>>9"
            "</font></td>" skip
            "<td width=50 align=right><font size=2>"  coletor.colqtd 
                                         format "->>>>9"   
            "</font></td>"   skip

            "<td width=50 align=right><font size=2>"  (if coletor.colacr > 0
                                          then coletor.colacr 
                                          else 0)
                                         format "->>>>>9"   "</font></td>" skip

            "<td width=50 align=right><font size=2>"  (if coletor.coldec > 0
                                          then coletor.coldec 
                                          else 0)
                                         format "->>>>>9"   "</font></td>"  
            skip
            
            "<td width=55 align=right><font size=2>"  estoq.estcusto
                                         format ">,>>9.99"  
            "</font></td>" skip
            "<td width=50 align=right><font size=2>"  
                          (if colacr > 0
                           then (coletor.colacr * estoq.estcusto)
                           else 0)
                                         format "->>>>9"  "</font></td>"  
            skip
            "<td width=50 align=right><font size=2>"
                          (if coldec > 0
                           then (coletor.coldec * estoq.estcusto)
                           else 0)
                                         format "->>>>9"  "</font></td>" 
            skip

            
            "</tr>" skip.

end procedure.

procedure p-corpo-s:

        put skip
            "<tr>" 
            skip 
            "<td width=50 align=left><font size=2>" produ.procod   
            "</font></td>"  skip
            "<td width=420 align=left><font size=2>" 
            produ.pronom  format "x(37)" "</font></td>"
            skip
            "<td width=70 align=right><font size=2>"  coletor.colqtd 
            format "->>,>>9.99"
            "</font></td>" skip
            "<td width=70 align=right><font size=2>"  (if coletor.colacr > 0
                                          then coletor.colacr
                                          else 0) format "->>,>>9.99"
            "</font></td>"  
            skip
            "<td width=70 align=right><font size=2>"  (if coletor.coldec > 0
                                          then coletor.coldec
                                          else 0) format "->>,>>9.99"
            "</font></td>" skip
            "</tr>" skip.


end procedure.

procedure p-rodape:

    put "</table><br>"
        "<table border=" vaspas "0" vaspas "summary=>" skip
               "<tr>" 
               skip
               "<td width=820 align=left>
               <b>
               <h5>"
               "TOTAL VL. ACRESCIMO..: " tot1
               "<br>"
               "TOTAL ACRESCIMO..........: " vac
               "<br>"
               "TOTAL VL. DECRESCIMO: " tot2
               "<br>"
               "TOTAL DECRESCIMO........: " vde
               "<br>"
               "</h5>
               </b>
               </td>" 
               skip
               "</tr>" 
               skip
               "</table>"
               skip
         "<br>"
         "</body>"
         "</html>".


end procedure.
