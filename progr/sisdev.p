{admcab.i }
def var v-seq as int.
def var vseq as int.
def var qtd_lote as int.
def var cod_lote as char.
def var cd_batch as char.
def var vtipo as log format "Vista/Prazo" initial no.
def stream stela.
def var vetbcod like estab.etbcod.
def var vdata       like titulo.titdtemi.
def var vdt1        as   date  format "99/99/9999" initial today. 
def var vdt2        as   date  format "99/99/9999" initial today.
def var vlote       as char format "xxxx".
def stream tela.
def temp-table tt-cab
    field etbcod like estab.etbcod
    field data   like plani.pladat
    field qtdlot as int
    field totval like fiscal.platot
    field codlot as char
    field codest as char.

def temp-table tt-lanca
    field tip  as char format "x(01)"
    field cre  as char format "x(04)"
    field val  as dec format ">,>>>,>>9.99" 
    field cod  as int format "999"
    field his  as char format "x(50)"
    field etbcod like estab.etbcod
    field data like plani.pladat
    field total_lote as int
    field seq  as int. 
        


repeat with 1 down side-label width 80 row 4 color blue/white:

    for each tt-lanca:
        delete tt-lanca.
    end.
    
    for each tt-cab:
        delete tt-cab.
    end.    
    
    vtipo = no.
    update /* vtipo   label "Notas" colon 20 */
           vetbcod label "Filial" colon 20.
    if vetbcod = 0
    then display "Geral" @ estab.etbnom.
    else do: 
           
        find estab where estab.etbcod = vetbcod no-lock.
    
        disp estab.etbnom no-label.
    end.
    update vdt1 label "Data Inicial" colon 20
           vdt2 label "Data Final". 
   
    for each tt-lanca:
        delete tt-lanca.
    end.

    
    output stream stela to terminal.
    for each estab where if vetbcod = 0
                         then true
                         else estab.etbcod = vetbcod no-lock,
        each plani where plani.movtdc = 13           and
                         plani.etbcod = estab.etbcod and
                         plani.pladat >= vdt1        and
                         plani.pladat <= vdt2        no-lock.
        
        if plani.emite = 5027
        then next.
       
        find forne where forne.forcod = plani.desti no-lock no-error.
        if not avail forne
        then next.

        disp stream stela plani.numero
                          plani.pladat format "99/99/9999" 
                                with 1 down. pause 0.
        
        create tt-lanca.
        assign tt-lanca.tip  = "C"
               tt-lanca.val  = plani.platot
               tt-lanca.cre  = "1"
               tt-lanca.cod  = 0
               tt-lanca.data = plani.pladat
               tt-lanca.etbcod = estab.etbcod
               tt-lanca.his = 
                "*LIVRE@DEVOLUCAO DE COMPRA CONF. REGISTRO DE SAIDAS "   
                                  + "-" + string(forne.fornom).
 
        find first tt-cab where tt-cab.etbcod = plani.emite and
                                tt-cab.data   = plani.pladat no-error.
        if not avail tt-cab
        then do:
            create tt-cab.
            assign tt-cab.etbcod = plani.emite
                   tt-cab.data   = plani.pladat
                   tt-cab.codest = "01" + string(plani.emite,"99").
        end.
        assign tt-cab.qtdlot = tt-cab.qtdlot + 1
               tt-cab.codlot = string(day(plani.pladat),"99")
               tt-cab.totval = tt-cab.totval + plani.platot.
               
    
    end.
    output stream stela close.
    
    for each tt-cab no-lock:
        if tt-cab.totval > 0
        then do:
            create tt-lanca.
            assign tt-lanca.tip  = "D"
                   tt-lanca.cre  = "01" + string(tt-cab.etbcod,">>9")
                   tt-lanca.cod  = 0. 
            if vtipo
            then tt-lanca.his = 
                 "*LIVRE@DEVOLUCAO DE COMPRAS A VISTA CONF.REG.DE ENTRADAS".
            else tt-lanca.his = 
                 "*LIVRE@DEVOLUCAO DE COMPRAS A PRAZO CONF.REG.DE ENTRADAS".
            
            tt-lanca.val  = tt-cab.totval.
        end.

    end.

    vseq = 0.
    for each tt-lanca break by tt-lanca.data:
        vseq = vseq + 1.
        tt-lanca.seq = vseq.
         
        if last-of(tt-lanca.data)
        then vseq = 0.
        
    end.


    
    output to value("l:\sispro\devcom" + string(vetbcod,">>9") +
               ".txt").

    v-seq = 0.

    for each tt-cab:
    
    /********************* HEADER ********************/
    cd_batch = "INTPGT" +
               string(day(today),"99") +  
               string(month(today),"99") +    
               string(year(today),"9999") +  
               tt-cab.codest.
               
    
    
    put unformatted 
    /* 01 */       "FISCAL         "
    /* 02 */       " " format "x(01)" 
    /* 03 */       tt-cab.codest format "x(20)"
    /* 04 */       " " format "x(01)" 
    /* 05 */       cd_batch   format "x(30)" 
    /* 06 */       " " format "x(01)" 
    /* 07 */       "INTPGT" format "x(15)" 
    /* 08 */       " " format "x(01)" 
    /* 09 */       tt-cab.codlot   format "x(10)" 
    /* 10 */       " " format "x(01)"  
    /* 11 */       "HEADER    " 
    /* 12 */       " " format "x(01)"  
    /* 13 */       tt-cab.qtdlot  format "999999"  
    /* 14 */       " " format "x(01)"  
    /* 15 */       string(day(tt-cab.data),"99") format "99"  
                   string(month(tt-cab.data),"99") format "99"  
                   string(year(tt-cab.data),"9999") format "9999" 
    /* 16 */       " " format "x(01)"  
    /* 17 */       "000000000000000000"  
    /* 18 */       " " format "x(01)"  
    /* 19 */       (tt-cab.totval * 100) format "999999999999999999"  
    /* 20 */       " " format "x(01)"  
    /* 21 */       string(day(tt-cab.data),"99") format "99"  
                   string(month(tt-cab.data),"99") format "99"  
                   string(year(tt-cab.data),"9999") format "9999" 
    /* 22 */       " " format "x(01)"  
    /* 23 */       " " format "x(721)"  
    /* 24 */       " " format "x(01)"  
    /* 25 */       "000000"   
    /* 26 */       " " format "x(01)" skip.

    

    
    for each tt-lanca where tt-lanca.etbcod = tt-cab.etbcod and
                            tt-lanca.data   = tt-cab.data:

/*************************** LANCAMENTOS *************************/
    
    
        v-seq = v-seq + 1.
        put unformatted
    /* 01 */       "FISCAL         "
                   " " format "x(01)"
                   tt-cab.codest format "x(20)"
                   " " format "x(01)" 
                   cd_batch   format "x(30)" 
                   " " format "x(01)"
                   "INTPGT" format "x(15)"  
                   " " format "x(01)" 
                   tt-cab.codlot   format "x(10)" 
     /* 10 */      " " format "x(01)"
                   "LANCTO    "  
                   " " format "x(01)"
                   string(day(tt-lanca.data),"99") format "99"  
                   string(month(tt-lanca.data),"99") format "99"  
                   string(year(tt-lanca.data),"9999") format "9999" 
                   " " format "x(01)" 
                   " " format "x(30)" 
                   " " format "x(01)" 
                   " " format "x(22)" 
                   " " format "x(01)" 
                   tt-lanca.cre format "x(30)"
     /* 20 */      " " format "x(01)" 
                   tt-lanca.cre format "x(22)" 
                   " " format "x(01)" 
                   " " format "x(20)" 
                   " " format "x(01)"
                   tt-cab.codest format "x(20)" 
                   " " format "x(01)" 
                   " " format "x(06)" 
                   " " format "x(01)" 
                   " " format "x(15)"  
     /* 30 */      " " format "x(01)"  
                   " " format "x(06)"  
                   " " format "x(01)"  
                   " " format "x(15)"  
                   " " format "x(01)"  
                   " " format "x(06)" 
                   " " format "x(01)" 
                   " " format "x(15)"  
                   " " format "x(01)" 
                   " " format "x(06)"
     /* 40 */      " " format "x(01)" 
                   " " format "x(15)"  
                   " " format "x(01)" 
                   " " format "x(06)" 
                   " " format "x(01)" 
                   " " format "x(15)"  
                   " " format "x(01)" 
                   " " format "x(06)" 
                   " " format "x(01)" 
                   " " format "x(15)" 
     /* 50 */      " " format "x(01)" 
                   " " format "x(06)" 
                   " " format "x(01)" 
                   " " format "x(15)"  
                   " " format "x(01)" 
                   " " format "x(06)" 
                   " " format "x(01)" 
                   " " format "x(15)"  
                   " " format "x(01)" 
                   " " format "x(06)"
     /* 60 */      " " format "x(01)" 
                   " " format "x(15)"   
                   " " format "x(01)" 
                   " " format "x(06)" 
                   " " format "x(01)" 
                   " " format "x(15)"  
                   " " format "x(01)" 
                   " " format "x(06)" 
                   " " format "x(01)" 
                   " " format "x(15)" 
     /* 70 */      " " format "x(01)" 
                   " " format "x(06)" 
                   " " format "x(01)" 
                   " " format "x(15)"  
                   " " format "x(01)" 
                   (tt-lanca.val * 100) format "999999999999999999" 
                   " " format "x(01)" 
                   "0    " format "x(05)" 
                   " " format "x(01)" 
                   tt-lanca.his format "x(119)"
     /* 80 */      " " format "x(01)" 
                   " " format "x(15)" 
                   " " format "x(01)" 
                   " " format "x(120)" 
                   " " format "x(01)" 
                   " " format "x(05)" 
                   " " format "x(01)" 
                   " " format "x(01)"   
                   " " format "x(01)"   
                   "DIV" format "x(03)"  
     /* 90 */      " " format "x(01)"   
                   " " format "x(10)"    
                   " " format "x(01)"   
                   " " format "x(10)"   
                   " " format "x(34)"   
                   " " format "x(01)"   
                   v-seq format "999999"
     /* 97 */      " " format "x(01)"  skip.

    end.
    
/******************** TRAILLER ******************************/
    
    
    put unformatted 
         /* 01 */       "FISCAL         "
         /* 02 */       " " format "x(01)"  
         /* 03 */       tt-cab.codest format "x(20)" 
         /* 04 */       " " format "x(01)"  
         /* 05 */       cd_batch   format "x(30)"  
         /* 06 */       " " format "x(01)"  
         /* 07 */       "INTPGT" format "x(15)"  
         /* 08 */       " " format "x(01)"  
         /* 09 */       tt-cab.codlot   format "x(10)"  
         /* 10 */       " " format "x(01)"   
         /* 11 */       "TRAILLER  "  
         /* 12 */       " " format "x(01)"  
         /* 13 */       " " format "x(785)"  
         /* 14 */       "000000" format "x(06)"  
         /* 15 */       " " format "x(01)" skip.

    end.    
    output close.

end.
