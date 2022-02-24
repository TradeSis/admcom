def var vsysdata as char.
vsysdata = string(day(today),"99") 
         + string(month(today),"99")
         + string(year(today),"9999")
         + string(time,"hh:mm:ss").
vsysdata = replace(vsysdata,":","").
         
def temp-table tt-318
    field SKU_ID  as char format "x(25)"
    field UDA_ID  as char format "x(10)"
    field ORIGIN_ID   as char format "x(12)"
    field UDA_CHAR    as char format "x(250)"
    field RECORD_STATUS   as char format "x(1)"
    field CREATE_USER_ID  as char format "x(25)"
    field CREATE_DATETIME as char format "x(14)"
    field LAST_UPDATE_USER_ID as char format "x(25)"
    field LAST_UPDATE_DATETIME  as char format "x(14)"      
.
def buffer sClase   for clase.
def buffer grupo    for clase.
def buffer setClase for clase.
def buffer depto for clase.


for each procarac  no-lock.
    find produ of procarac no-lock no-error.
    if not avail produ then next.
    if proseq = 99
    then next.
    /*find produsku of produ no-lock no-error.
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
    
    find subcarac of procarac no-lock.

    if setClase.clacod = 0 then next.
    if grupo.clacod = 0 then next.
    if depto.clacod = 0 then next.
    if Clase.clacod = 0 then next.
    if sClase.clacod = 0 then next.


    find first estoq of produ no-lock no-error.
    if avail estoq and estoq.estatual = 0
    then do.
        find first movim where movim.procod  = produ.procod and
                               movim.movdat >= today - 365 no-lock no-error.
        if not avail movim
        then if produ.prodtcad < today - 365 then next.
    end.
    
    
    
            create tt-318.
            assign 
            tt-318.SKU_ID           = string(produ.procod)
            tt-318.UDA_ID           = string(procar.subcod)
            tt-318.ORIGIN_ID        = "LEBES"
            tt-318.UDA_CHAR         = subcarac.subdes
                        

            
            tt-318.RECORD_STATUS            = "A"                .
            tt-318.CREATE_USER_ID           = "ADMCOM"           .
            tt-318.CREATE_DATETIME          = vsysdata           .
            tt-318.LAST_UPDATE_USER_ID      = "ADMCOM"           .
            tt-318.LAST_UPDATE_DATETIME     = vsysdata           .
            .

end.            
output to value("/admcom/progr/itim/ADMCOM_0318_"  +
                    string(year(today),"9999")     +
                    string(month(today),"99")      +
                    string(day(today),"99")        + "1.DAT") .
for each tt-318.
    put                      
        SKU_ID                    "|"
        UDA_ID                    "|"
        ORIGIN_ID                 "|"
        UDA_CHAR                  "|"
        RECORD_STATUS             "|"
        CREATE_USER_ID            "|"
        CREATE_DATETIME           "|"
        LAST_UPDATE_USER_ID       "|"
        LAST_UPDATE_DATETIME
        skip.
        
end.
output close .
