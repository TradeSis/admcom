def var vsysdata as char.
vsysdata = string(day(today),"99") 
         + string(month(today),"99")
         + string(year(today),"9999")
         + string(time,"hh:mm:ss").
vsysdata = replace(vsysdata,":","").
         
/* Label - Fabricante   */
def temp-table tt-226
field   SKU_ID  as char format "x(25)"
field   MERCH_L2_ID as char format "x(25)"
field   MERCH_L3_ID as char format "x(25)"
field   MERCH_L4_ID as char format "x(25)"
field   MERCH_L5_ID as char format "x(25)"
field   MERCH_L6_ID as char format "x(25)"
field   ORIGIN_ID   as char format "x(12)"
field   LABEL_ID    as char format "x(25)"
field   PRIMARY_SUPPLIER_ID as char format "x(10)"
field   COLOUR_ID   as char format "x(10)"
field   SEASON_ID   as char format "x(10)"
field   LINE_ID as char format "x(25)"
field   STYLE_ID    as char format "x(25)"
field   SKU_DESC    as char format "x(128)"
field   SKU_SHORT_DESC  as char format "x(64)"
field   PACKAGE_UOM as char format "x(4)"
field   END_OF_LIFE_DATE    as char format "x(16)"
field   ORIGINAL_RETAIL_PRICE   as dec format ">>>>>>>>>>>>>>>>9999"
field   EAN as char format "x(20)"
field   PACKAGE_SIZE    as dec format ">>>>>>>>>>>>>>>>9999"
field   ITEM_ATTR_01_CHAR   as char format "x(40)"
field   ITEM_ATTR_02_CHAR   as char format "x(40)"
field   ITEM_ATTR_03_CHAR   as char format "x(40)"
field   ITEM_ATTR_04_CHAR   as char format "x(40)"
field   ITEM_ATTR_06_CHAR   as char format "x(40)"
field   ITEM_ATTR_01_NO as dec format ">>>>>>>>>>>>>>>>9999"
field   ITEM_ATTR_02_NO as dec format ">>>>>>>>>>>>>>>>9999"
field   ITEM_ATTR_01_FLAG   as char format "x(1)"
field   ITEM_ATTR_02_FLAG   as char format "x(1)"
field   ITEM_ATTR_03_FLAG   as char format "x(1)"
field   ITEM_ATTR_04_FLAG   as char format "x(1)"      
field   ITEM_ATTR_05_FLAG   as char format "x(1)"
field   ITEM_ATTR_06_FLAG   as char format "x(1)"
field   RECORD_STATUS   as char format "x(1)"
field   CREATE_USER_ID  as char format "x(25)"
field   CREATE_DATETIME as char format "x(16)"
field   LAST_UPDATE_USER_ID as char format "x(25)"
field   LAST_UPDATE_DATETIME    as char format "x(16)"
field   IMAGE_FILE_LINK as char format "x(1024)".

def buffer sClase   for clase.
def buffer grupo    for clase.
def buffer setClase for clase.
def buffer depto for clase.
def var vestatual like estoq.estatual.

def var vsituacao as log.

def var vestatus-d as char extent 4  FORMAT "X(15)"
    init["NORMAL","BRINDE","FORA DE LINHA","FORA DO MIX"].            
def var vestatus as int.    

for each produ where produ.procod < 999999 no-lock.
    if proseq = 99
    then next.
    find first movim where movim.movtdc = 5
                       and movim.procod = produ.procod
                       and movim.movdat >= today - 365
                            no-lock no-error.
    if not avail movim
    then next.
    /*find produsku of produ no-lock no-error.
    if avail produsku then next.*/
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
    
    /*** Estatus ***/
    find produaux where
                     produaux.procod = produ.procod and
                     produaux.nome_campo = "Estatus"
                     no-lock no-error.
    if avail produaux  
    then vestatus = int(valor_campo). 
    else vestatus = 0.     
    def var vetiqueta as log.
    vetiqueta = no. 
    find produaux where
                     produaux.procod = produ.procod and
                     produaux.nome_campo = "Etiqueta-Preco"
                     no-error.
    if avail produaux and 
        produaux.valor_campo = "Sim"
    then vetiqueta = yes.
    
    find probrick where probrick.procod = produ.procod no-lock no-error.
    vsituacao = yes.
    if produ.proseq = 99
    then vsituacao = no.
    if produ.pronom begins "*"
    then vsituacao = no.
    
    
    create tt-226.
            assign 
tt-226.SKU_ID  =   string(produ.procod)                                   .
tt-226.MERCH_L2_ID =   string(depto.clacod)                               .
tt-226.MERCH_L3_ID =   if avail     setclase
                       then  string(setClase.clacod)                          
                       else ""   .
tt-226.MERCH_L4_ID =   if avail     grupo
                       then  string(Grupo.clacod)                             
                       else "".
tt-226.MERCH_L5_ID =   if avail    clase
                       then string(clase.clacod) 
                       else "".
tt-226.MERCH_L6_ID =   if avail    sclase
                       then string(sclase.clacod) 
                       else "" .
tt-226.ORIGIN_ID   =   "LEBES"                                    .
tt-226.LABEL_ID    =   string(produ.fabcod)                .
tt-226.PRIMARY_SUPPLIER_ID  = string(produ.fabcod).
tt-226.COLOUR_ID   =   ""                                   .
tt-226.SEASON_ID   =   string(temp-cod)                               .
tt-226.LINE_ID =  ""                                          .
tt-226.STYLE_ID    =  ""                                      .
tt-226.SKU_DESC    =   produ.pronom                               .
tt-226.SKU_SHORT_DESC  =   produ.pronomc                          .
tt-226.PACKAGE_UOM =  produ.prouncom                                       .
tt-226.END_OF_LIFE_DATE    = ""                               .
find first estoq where estoq.procod = produ.procod no-lock no-error.
tt-226.ORIGINAL_RETAIL_PRICE   =   if avail estoq
                                   then (estoq.estcusto * 10000)
                                              else 0.
tt-226.EAN =   if produ.proindice <> ?
               then produ.proindice
               else ""
                                    .
tt-226.PACKAGE_SIZE    = 0                                   .
tt-226.ITEM_ATTR_01_CHAR   =   produ.prorefter              .
tt-226.ITEM_ATTR_02_CHAR   =  vestatus-d[vestatus + 1]                    .
tt-226.ITEM_ATTR_03_CHAR   =   ""                 .
tt-226.ITEM_ATTR_04_CHAR   =   "A_VISTA" .
tt-226.ITEM_ATTR_06_CHAR   =   ""      .
tt-226.ITEM_ATTR_01_NO     =   0                                 .
tt-226.ITEM_ATTR_02_NO     =   0                   .
tt-226.ITEM_ATTR_01_FLAG   =   if produ.proipival = 1
                               then "Y"
                               else "N".
tt-226.ITEM_ATTR_02_FLAG   =   ""                             .
tt-226.ITEM_ATTR_03_FLAG   =   if vetiqueta then "Y" else "N"      .
tt-226.ITEM_ATTR_04_FLAG   =   if avail probrick then "Y" else "N".
tt-226.ITEM_ATTR_05_FLAG   =   if vsituacao = yes then "Y" else "N".
tt-226.ITEM_ATTR_06_FLAG   =   ""                             .
                                                            
                                                            
            
            tt-226.RECORD_STATUS            = "A"                .
            tt-226.CREATE_USER_ID           = "ADMCOM"           .
            tt-226.CREATE_DATETIME          = vsysdata           .
            tt-226.LAST_UPDATE_USER_ID      = "ADMCOM"           .
            tt-226.LAST_UPDATE_DATETIME     = vsysdata           .
            .
end.            
output to value("/admcom/progr/itim/ADMCOM_0226_"  +
                    string(year(today),"9999")     +
                    string(month(today),"99")      +
                    string(day(today),"99")        + "1.DAT") .
for each tt-226.
    put                      
    tt-226.SKU_ID      "|"
    tt-226.MERCH_L2_ID     "|"
    tt-226.MERCH_L3_ID     "|"
    tt-226.MERCH_L4_ID     "|"
    tt-226.MERCH_L5_ID     "|"
    tt-226.MERCH_L6_ID     "|"
    tt-226.ORIGIN_ID       "|"
    tt-226.LABEL_ID        "|"
    tt-226.PRIMARY_SUPPLIER_ID "|"
    tt-226.COLOUR_ID       "|"
    tt-226.SEASON_ID       "|"
    tt-226.LINE_ID     "|"
    tt-226.STYLE_ID        "|"
    tt-226.SKU_DESC        "|"
    tt-226.SKU_SHORT_DESC      "|"
    tt-226.PACKAGE_UOM     "|"
    tt-226.END_OF_LIFE_DATE        "|"
    tt-226.ORIGINAL_RETAIL_PRICE       "|"
    tt-226.EAN     "|"
    tt-226.PACKAGE_SIZE        "|"
    tt-226.ITEM_ATTR_01_CHAR       "|"
    tt-226.ITEM_ATTR_02_CHAR       "|"
    tt-226.ITEM_ATTR_03_CHAR       "|"
    tt-226.ITEM_ATTR_04_CHAR       "|"
    tt-226.ITEM_ATTR_06_CHAR       "|"
    tt-226.ITEM_ATTR_01_NO     "|"
    tt-226.ITEM_ATTR_02_NO     "|"
    tt-226.ITEM_ATTR_01_FLAG       "|"
    tt-226.ITEM_ATTR_02_FLAG       "|"
    tt-226.ITEM_ATTR_03_FLAG       "|"
    tt-226.ITEM_ATTR_04_FLAG       "|"
    tt-226.ITEM_ATTR_05_FLAG       "|"
    tt-226.ITEM_ATTR_06_FLAG       "|"
    tt-226.RECORD_STATUS       "|"
    tt-226.CREATE_USER_ID      "|"
    tt-226.CREATE_DATETIME     "|"
    tt-226.LAST_UPDATE_USER_ID     "|"
    tt-226.LAST_UPDATE_DATETIME        "|"
    tt-226.IMAGE_FILE_LINK     
    
        skip.
        
end.
output close .
