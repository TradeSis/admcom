def var vsysdata as char.
vsysdata = string(day(today),"99") 
         + string(month(today),"99")
         + string(year(today),"9999")
         + string(time,"hh:mm:ss").
vsysdata = replace(vsysdata,":","").

def temp-table tt-405
    field EFFECTIVE_DATE   as char format "x(16)"
    field CALCULATE_DATE   as char format "x(16)"
    field SKU_ID  as char format "x(25)"
    field SUPPLIER_ID as char format "x(10)"
    field ORIGIN_ID   as char format "x(12)"
    field UNIT_COST   as dec format ">>>>>>>>>>>>>>>>9999"
    field RECORD_STATUS   as char format "x(1)"
    field CREATE_USER_ID  as char format "x(25)"
    field CREATE_DATETIME  as char format "x(16)"
    field LAST_UPDATE_USER_ID as char format "x(25)"
    field LAST_UPDATE_DATETIME     as char format "x(16)"
    index tt-405    is primary unique CALCULATE_DATE
                                      SKU_ID
                                      SUPPLIER_ID  
    .


def buffer sClase   for clase.
def buffer grupo    for clase.
def buffer setClase for clase.
def buffer depto for clase.
def var vestatual like estoq.estatual.
def buffer vmovim for movim.

def var vdata as date.
for each tipmov where tipmov.movtdc = 4 no-lock.
do vdata = today - 365 to today.
    disp vdata.
    for each estab no-lock.
        for each plani where plani.movtdc = tipmov.movtdc and
                             plani.EtbCod = estab.etbcod  and
                             plani.PlaDat = vdata no-lock
                             by dtinclu.
                              
            find forne where forne.forcod = plani.emite no-lock no-error.
            if not avail forne
            then next.
            for each movim where movim.etbcod = plani.etbcod and
                                 movim.placod = plani.placod and
                                 movim.movtdc = plani.movtdc and
                                 movim.movdat = plani.pladat no-lock.

                
                find produ of movim no-lock no-error.
                if not avail produ then next.
                if proseq = 99
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
        find first vmovim where vmovim.procod  = produ.procod and
                                vmovim.movdat >= today - 365 no-lock no-error.
        if not avail vmovim
        then if produ.prodtcad < today - 365 then next.
    end.                
    
   find first vmovim where vmovim.movtdc = 5
                       and vmovim.procod = produ.procod
                       and vmovim.movdat >= today - 365
                          no-lock no-error.
   if not avail vmovim
   then next.
                                    
                
                find tt-405 where 
                     tt-405.CALCULATE_DATE = string(movim.movdat,"99999999")  and
                     tt-405.SKU_ID         = string(movim.procod)       and
                     tt-405.SUPPLIER_ID    = string(plani.emite)
                     no-error.
                if not avail tt-405
                then create tt-405.
                assign  
                tt-405.EFFECTIVE_DATE      = string(movim.movdat,"99999999") .
                tt-405.CALCULATE_DATE      = string(movim.movdat,"99999999") .
                tt-405.SKU_ID              = string(movim.procod)              .
                tt-405.SUPPLIER_ID         = string(plani.emite)              .
                tt-405.ORIGIN_ID           = "LEBES"                  .
                tt-405.UNIT_COST           = movim.movpc  * 10000     .
                if tt-405.UNIT_COST < 0
                then tt-405.UNIT_COST = tt-405.UNIT_COST * -1.
                
            
                    tt-405.RECORD_STATUS            = "A"                .
                    tt-405.CREATE_USER_ID           = "ADMCOM"           .
                    tt-405.CREATE_DATETIME          = vsysdata           .
                    tt-405.LAST_UPDATE_USER_ID      = "ADMCOM"           .
                    tt-405.LAST_UPDATE_DATETIME     = vsysdata           .
                    .
            end.            
        end.
        pause 0.
    end.
    pause 0.
end.
end. /* for each tipmov */


output to value("/admcom/progr/itim/ADMCOM_0405_"  +
                    string(year(today),"9999")     +
                    string(month(today),"99")      +
                    string(day(today),"99")        + "1.DAT") .
for each tt-405.
    put                      
        EFFECTIVE_DATE            "|"
        CALCULATE_DATE            "|"
        SKU_ID                    "|"
        SUPPLIER_ID               "|"
        ORIGIN_ID                 "|"
        UNIT_COST                 "|"
        RECORD_STATUS             "|"
        CREATE_USER_ID            "|"
        CREATE_DATETIME           "|"
        LAST_UPDATE_USER_ID       "|"
        LAST_UPDATE_DATETIME
        skip.
        
end.
output close .
