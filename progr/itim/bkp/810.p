def var vsysdata as char.
vsysdata = string(day(today),"99") 
         + string(month(today),"99")
         + string(year(today),"9999")
         + string(time,"hh:mm:ss").
vsysdata = replace(vsysdata,":","").
         
def temp-table tt-810
        field TRAN_TYPE   as char format "x(1)"
        field APPROVED_DATE   as char format "x(16)"
        field EFFECTIVE_DATE  as char format "x(16)"
        field DUE_DATE    as char format "x(16)"
        field PRICE_KEY   as dec format ">>>>>>>>>>>>>>>>>>>>>9"
        field SKU_ID  as char format "x(25)"
        field STORE_ID    as char format "x(10)"
        field RETAIL_PRICE    as dec format "->>>>>>>>>>>>>>>9999"
        field RETAIL_PRICE_INST   as dec format "->>>>>>>>>>>>>>>9999"
        field RETAIL_PRICE_PLAN   as char format "x(25)"
        field PUBLISH_PRICE   as dec format "->>>>>>>>>>>>>>>9999"
        field OFFER_ID    as char format "x(32)"
        field ORIGIN_ID   as char format "x(12)"
        field PRICE_SYSTEM_ID as char format "x(25)"
        field PRICE_TYPE  as char format "x(1)"
        field RECORD_STATUS   as char format "x(1)"
        field CREATE_USER_ID  as char format "x(25)"
        field CREATE_DATETIME as char format "x(16)"
        field LAST_UPDATE_USER_ID as char format "x(25)"
        field LAST_UPDATE_DATETIME    as char format "x(16)"
        
    
    .

def buffer sClase   for clase.
def buffer grupo    for clase.
def buffer setClase for clase.
def buffer depto for clase.
def var vestatual like estoq.estatual.

for each produ  where produ.procod < 999999  
                    no-lock.
    if proseq = 99
    then next.

    find first movim where movim.movtdc = 5
                       and movim.procod = produ.procod
                       and movim.movdat >= today - 365
                            no-lock no-error.
    if not avail movim
    then next.
        
    /*
    find produsku of produ no-lock no-error. 
    if avail produsku then next.
    */
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
        then if produ.prodtcad < today - 365 then next.
    end.


    for each estoq where estoq.procod = produ.procod 
    /*and
                (estoq.etbcod = 1 or estoq.etbcod = 2 or estoq.etbcod = 3)
                */
                
                no-lock.      

            

hide message no-pause.
message produ.procod.

                create tt-810.
                assign      
                TRAN_TYPE           = "C".
                APPROVED_DATE       = string(today,"99999999") .
                EFFECTIVE_DATE      = string(today,"99999999") .
                DUE_DATE            = "".
                PRICE_KEY           = next-value(Seq_itim).
                SKU_ID              = string(estoq.procod).
                STORE_ID            = string(estoq.etbcod).
                RETAIL_PRICE        = estoq.estvenda * 10000.
                RETAIL_PRICE_INST   = estoq.estmin  * 10000    .
                RETAIL_PRICE_PLAN   = string(estoq.tabcod)     .
                PUBLISH_PRICE       = estoq.estproper * 10000.
                OFFER_ID            = ""        .
                ORIGIN_ID           = "LEBES"  .
                PRICE_SYSTEM_ID     = ""      .
                PRICE_TYPE          = "R"    .
                RECORD_STATUS       = "A"   .
                

                
                    
                    tt-810.CREATE_USER_ID           = "ADMCOM"           .
                    tt-810.CREATE_DATETIME          = vsysdata           .
                    tt-810.LAST_UPDATE_USER_ID      = "ADMCOM"           .
                    tt-810.LAST_UPDATE_DATETIME     = vsysdata           .
                    .
    end.
    pause 0.
end.                     


output to value("/admcom/progr/itim/ADMCOM_0810_"  +
                    string(year(today),"9999")     +
                    string(month(today),"99")      +
                    string(day(today),"99")        + "1.DAT") .
for each tt-810.
    put                      
        TRAN_TYPE                   "|"
        APPROVED_DATE               "|"
        EFFECTIVE_DATE              "|"
        DUE_DATE                    "|"
        PRICE_KEY                   "|"
        SKU_ID                      "|"
        STORE_ID                    "|"
        RETAIL_PRICE                "|"
        RETAIL_PRICE_INST           "|"
        RETAIL_PRICE_PLAN           "|"
        PUBLISH_PRICE               "|"
        OFFER_ID                    "|"
        ORIGIN_ID                   "|"
        PRICE_SYSTEM_ID             "|"
        PRICE_TYPE                  "|"
        RECORD_STATUS               "|"
        CREATE_USER_ID              "|"
        CREATE_DATETIME             "|"
        LAST_UPDATE_USER_ID         "|"
        LAST_UPDATE_DATETIME
        skip.
        
end.
output close .




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
