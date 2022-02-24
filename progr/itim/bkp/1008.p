def stream tela.
output stream tela to terminal.
output to value("/admcom/progr/itim/ADMCOM_1008_"  +
                    string(year(today),"9999")     +
                    string(month(today),"99")      +
                    string(day(today),"99")        + "1.DAT") append.
output close.

def buffer bestoq for estoq.
pause 0 before-hide.
def var vvprocod like produ.procod.
def var vreserva_loja_cd as dec.
def var compras_pendentes_entrega_CD as dec.
def var vestatual_cd as dec.

def var vsysdata as char.
vsysdata = string(day(today),"99") 
         + string(month(today),"99")
         + string(year(today),"9999")
         + string(time,"hh:mm:ss").
vsysdata = replace(vsysdata,":","").
         
def temp-table tt-1008
    field STOCK_DATE  as char format "x(16)"
    field SKU_ID  as char format "x(25)"
    field STORE_ID    as char format "x(10)"
    field ORIGIN_ID   as char format "x(12)"
    field SOH_VAL as dec format "->>>>>>>>>>>>>>>9999"
    field SIT_VAL as dec format "->>>>>>>>>>>>>>>9999"
    field SOO_VAL as dec format "->>>>>>>>>>>>>>>9999"
    field OTHER_STK_VAL   as dec format "->>>>>>>>>>>>>>>9999"
    field SOH_QTY as dec format "->>>>>>>>>>>>>>>9999"
    field SIT_QTY as dec format "->>>>>>>>>>>>>>>9999"
    field SOO_QTY as dec format "->>>>>>>>>>>>>>>9999"
    field OTHER_STK_QTY   as dec format "->>>>>>>>>>>>>>>9999"
    field CREATE_USER_ID  as char format "x(25)"
    field CREATE_DATETIME as char format "x(16)"
    field LAST_UPDATE_USER_ID as char format "x(25)"
    field LAST_UPDATE_DATETIME    as char format "x(16)"
    index ind01 STOCK_DATE SKU_ID STORE_ID.
    .


def buffer sClase   for clase.
def buffer grupo    for clase.
def buffer setClase for clase.
def buffer depto for clase.
def var vestatual like estoq.estatual.

def new shared var vestatual995  like estoq.estatual format "->>>>9".
def new shared var vdisponiv993  like estoq.estatual format "->>>>9".
def new shared var vestatual993  like estoq.estatual format "->>>>9".
def new shared var vestatual998  like estoq.estatual format "->>>>9".
def new shared var vestatual500  like estoq.estatual format "->>>>9".
def var vreservado like estoq.estatual.
def var vestcusto like estoq.estcusto.



for each produ where produ.procod < 999999   
                    no-lock by procod desc.
    if proseq = 99
    then next.
    find first movim where movim.movtdc = 5
                       and movim.procod = produ.procod
                       and movim.movdat >= today - 365
                           no-lock no-error.
    if not avail movim
    then next.
                                    
    find sClase     where sClase.clacod   = produ.clacod    no-lock no-error.
    if not avail sClase then next.
    find Clase      where Clase.clacod    = sClase.clasup   no-lock no-error.
    if not avail clase then next.
    find grupo      where grupo.clacod    = Clase.clasup    no-lock no-error.
    if not avail grupo then next.
    find setClase   where setClase.clacod = grupo.clasup    no-lock no-error.  
    if not avail setclase then next.
    find depto   where depto.clacod = setclase.clasup    no-lock no-error.   
    if not avail depto then next.

    if setClase.clacod = 0 then next.      
    if grupo.clacod = 0 then next.         
    if depto.clacod = 0 then next.         
    if Clase.clacod = 0 then next.         
    if sClase.clacod = 0 then next.        
    
    vestatual = 0.
    for each estoq of produ no-lock.
        vestatual = vestatual + estoq.estatual.
    end.
    if vestatual = 0
    then do.
        find first movim where movim.procod  = produ.procod and
                               movim.movdat >= today - 365 no-lock no-error.
        if not avail movim
        then if produ.prodtcad < (today - 365) then next.
    end.

    vdisponiv993 = 0.
    vestatual993 = 0.
    vestatual995 = 0.
    vestatual998 = 0.
    vestatual500 = 0.
    vestcusto = 0.

    find first bestoq where bestoq.procod = produ.procod no-lock no-error.
    vestcusto = if avail bestoq
                then bestoq.estcusto
                else 0.
    
    assign vvprocod = int(produ.procod).
    find estoq where estoq.etbcod = 993 and estoq.procod = vvprocod
        no-lock no-error.
    if avail estoq then assign vestatual993 = vestatual993 + estoq.estatual.
    find estoq where estoq.etbcod = 995 and estoq.procod = vvprocod
        no-lock no-error.
    if avail estoq then assign vestatual995 = vestatual995 + estoq.estatual.
    find estoq where estoq.etbcod = 998 and estoq.procod = vvprocod
        no-lock no-error.
    if avail estoq then assign vestatual998 = vestatual998 + estoq.estatual.
    find estoq where estoq.etbcod = 500 and estoq.procod = vvprocod           
        no-lock no-error.                                                     
    if avail estoq then assign vestatual500 = vestatual500 + estoq.estatual.  


    for each estoq where estoq.procod = produ.procod /*and
                (estoq.etbcod = 1 or estoq.etbcod = 2 or estoq.etbcod = 3)
                */
                
                no-lock.      
                
            find estab where estab.etbcod = estoq.etbcod
                                no-lock no-error.
            if not avail estab
            then next.

            run compras_pendentes_entrega_CD
                                ( input  produ.procod, 
                                  output compras_pendentes_entrega_CD).
            
            
            vestatual_cd =  vestatual993 + 
                            vestatual995 + 
                            vestatual998 + 
                            vestatual500.
            
            run vreserva_loja_cd( input  produ.procod, 
                                  input  estoq.etbcod, 
                                  output vreserva_loja_cd).


            def var f as int.
            
            

            find first tt-1008 
                where tt-1008.STOCK_DATE = string(today,"99999999")
                  and tt-1008.SKU_ID     = string(produ.procod)
                  and tt-1008.STORE_ID   = string(estoq.etbcod)
                    no-error.
            if not avail tt-1008
            then do:
                create tt-1008.
                assign      .
                tt-1008.STOCK_DATE  = string(today,"99999999")      .
                tt-1008.SKU_ID      = string(produ.procod)          .
                tt-1008.STORE_ID    = string(estoq.etbcod)           .
                tt-1008.ORIGIN_ID   = "LEBES"                 .
                tt-1008.SOH_VAL     = estoq.estatual * vestcusto * 10000 .
                tt-1008.SIT_VAL     = vreserva_loja_cd * vestcusto * 10000.
                tt-1008.SOO_VAL     = compras_pendentes_entrega_CD * vestcusto
                                                    * 10000.
                tt-1008.OTHER_STK_VAL = vestatual_cd * vestcusto * 10000    .
                tt-1008.SOH_QTY       = estoq.estatual      * 10000       .
                tt-1008.SIT_QTY       = vreserva_loja_cd * 10000.
                tt-1008.SOO_QTY       = compras_pendentes_entrega_CD * 10000.
                tt-1008.OTHER_STK_QTY = vestatual_cd * 10000.
                        
                    tt-1008.CREATE_USER_ID           = "ADMCOM"           .
                    tt-1008.CREATE_DATETIME          = vsysdata           .
                    tt-1008.LAST_UPDATE_USER_ID      = "ADMCOM"           .
                    tt-1008.LAST_UPDATE_DATETIME     = vsysdata           .
                    .
        
    
        if f mod 1000 = 0
        then do.
            disp stream tela f
                 tt-1008.STOCK_DATE   
                 tt-1008.SKU_ID
                 tt-1008.STORE_ID.
            run arq.
        end.
        end. /* if not avail tt-1008 ... */    
        
    
    end.
    pause 0.
end.                     


procedure arq.
output to value("/admcom/progr/itim/ADMCOM_1008_"  +
                    string(year(today),"9999")     +
                    string(month(today),"99")      +
                    string(day(today),"99")        + "1.DAT") append.
for each tt-1008.
    put                      
        STOCK_DATE              "|"
        SKU_ID                  "|"
        STORE_ID                "|"
        ORIGIN_ID               "|"
        SOH_VAL format "->>>>>>>>>>>>>>>9999"        "|"
        SIT_VAL format "->>>>>>>>>>>>>>>9999"                "|"
        SOO_VAL format "->>>>>>>>>>>>>>>9999"                "|"
        OTHER_STK_VAL format "->>>>>>>>>>>>>>>9999"          "|"
        SOH_QTY format "->>>>>>>>>>>>>>>9999"                "|"
        SIT_QTY format "->>>>>>>>>>>>>>>9999"                "|"
        SOO_QTY format "->>>>>>>>>>>>>>>9999"                "|"
        OTHER_STK_QTY format "->>>>>>>>>>>>>>>9999"          "|"
        CREATE_USER_ID          "|"
        CREATE_DATETIME         "|"
        LAST_UPDATE_USER_ID     "|"
        LAST_UPDATE_DATETIME
        skip.
delete tt-1008.        
end.
output close .
end procedure.




procedure vreserva_loja_cd.
def buffer pestoq for estoq.
def input  parameter par-procod like produ.procod.
def input  parameter par-etbcod like estoq.etbcod.
def output parameter reserva    as int.

def var vespecial  as int.
def var vdata as date.

find pestoq where pestoq.etbcod = par-etbcod and
                         pestoq.procod = par-procod no-lock no-error.

        if true
        then do:
            reserva = 0. 
            vespecial = 0.  
            do vdata = today - 40 to today.
            for each liped where liped.pedtdc = 3
                             and liped.predt  = vdata
                             and liped.procod = par-procod 
                             and liped.etbcod = par-etbcod
                             no-lock:
                                         
                find pedid where pedid.etbcod = liped.etbcod and
                                 pedid.pedtdc = liped.pedtdc and
                                 pedid.pednum = liped.pednum no-lock no-error.
                if not avail pedid 
                then next.

                if pedid.sitped <> "E" and
                   pedid.sitped <> "L"
                then next.
                
                reserva = reserva + liped.lipqtd.
            end.

            /* pedido especial */

            for each liped where liped.pedtdc = 6 
                             and liped.predt  = vdata
                             and liped.etbcod = par-etbcod
                             and liped.procod = par-procod no-lock,
                first pedid where pedid.etbcod = liped.etbcod and
                                 pedid.pedtdc = liped.pedtdc and
                                 pedid.pednum = liped.pednum and
                                 pedid.pedsit = yes    and
                                 pedid.sitped = "P"
                                 no-lock.
                
                vespecial = vespecial + liped.lipqtd.
               end.
            end.
            
            if (pestoq.estatual - vespecial) < 0
            then vespecial = 0.


            /****  antonio - sol 26212 - Reservas futuras *****/
                       assign vdata = today + 1.
            for each liped where liped.pedtdc = 3
                             and liped.predt  > vdata
                             and liped.etbcod = par-etbcod
                             and liped.procod = par-procod no-lock:
                                         
                find pedid where pedid.etbcod = liped.etbcod and
                                 pedid.pedtdc = liped.pedtdc and
                                 pedid.pednum = liped.pednum no-lock no-error.
                if not avail pedid 
                then next.

                if pedid.sitped <> "E" and
                   pedid.sitped <> "L"
                then next.
                reserva = reserva + liped.lipqtd.
            end.
            
            /*********** Reservas do E-Commerce **********/
            for each liped where liped.pedtdc = 8
                             and liped.predt  = today
                             and liped.etbcod = par-etbcod
                             and liped.procod = par-procod no-lock:
  
                find pedid where pedid.etbcod = liped.etbcod and
                                 pedid.pedtdc = liped.pedtdc and
                                 pedid.pednum = liped.pednum no-lock no-error.
                if not avail pedid
                then next.
                                                                 
                reserva = reserva + liped.lipqtd.
            end.
            /*** fim de reservas futuras - sol 26212 ***/    

        end.           


end procedure.


procedure compras_pendentes_entrega_CD.
def input  parameter par-procod like produ.procod.
def output parameter compras_pendentes_entrega_CD as int.
compras_pendentes_entrega_CD = 0.
    for each liped where  liped.procod = par-procod and
                                 liped.pedtdc = 1 and
                                 (liped.predtf = ? or
                                 liped.predtf >= today - 30) no-lock,
              first pedid of liped where pedid.pedsit = yes and
                            pedid.sitped <> "F"  and
                            pedid.peddat > today - 180   no-lock:
            compras_pendentes_entrega_CD = compras_pendentes_entrega_CD +
                                (liped.lipqtd - liped.lipent).
    end.

end procedure.
