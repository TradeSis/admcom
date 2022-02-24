pause 0 before-hide.
/*
linha dura - todos os produtos ativos, sendo que a quantidade maxima será o que tem no mix, e o que não estiver no mix, vai nulo. Linha mole: enviar o estoque da loja
*/
def var vsysdata as char.
vsysdata = string(day(today),"99") 
         + string(month(today),"99")
         + string(year(today),"9999")
         + string(time,"hh:mm:ss").
vsysdata = replace(vsysdata,":","").
         
def temp-table tt-323
    field STORE_ID    as char format "x(10)"
    field SKU_ID  as char format "x(25)"
    field ORIGIN_ID   as char format "x(12)"
    field OPEN_TO_BUY as char format "x(1)"
    field ITEM_ST_ATTR_01_NO  as dec format ">>>>>>>>>>>>>>>>9999"
    field ITEM_ST_ATTR_02_NO  as dec format ">>>>>>>>>>>>>>>>9999"
    field ITEM_ST_ATTR_03_NO  as dec format ">>>>>>>>>>>>>>>>9999"
    field ITEM_ST_ATTR_04_NO  as dec format ">>>>>>>>>>>>>>>>9999"
    field ITEM_ST_ATTR_05_NO  as dec format ">>>>>>>>>>>>>>>>9999"
    field ITEM_ST_ATTR_06_NO  as dec format ">>>>>>>>>>>>>>>>9999"
    field ITEM_ST_ATTR_07_NO  as dec format ">>>>>>>>>>>>>>>>9999"
    field ITEM_ST_ATTR_08_NO  as dec format ">>>>>>>>>>>>>>>>9999"
    field ITEM_ST_ATTR_09_NO  as dec format ">>>>>>>>>>>>>>>>9999"
    field ITEM_ST_ATTR_10_NO  as dec format ">>>>>>>>>>>>>>>>9999"
    
    
    field RECORD_STATUS   as char format "x(1)"
    field CREATE_USER_ID  as char format "x(25)"
    field CREATE_DATETIME as char format "x(16)"
    field LAST_UPDATE_USER_ID as char format "x(25)"
    field LAST_UPDATE_DATETIME    as char format "x(16)"
    .

/**
Serão gerados 3 arquivos de exportação do ADMCOM com informações de Mix;
- Arquivo de Mix de Móveis dos produtos que estão cadastrados na tabela de Mix com a quantidade indicada nesta tabela;
- Arquivo de Mix de Móveis de todos os produtos Ativos do cadastro da Lebes que não estão na tabela de Mix com a quandidade de mix nulo;
- Arquivo de Mix de Moda com todos os produtos Ativos que possuem estoque na loja (temporário até que a área de compras moda faça a Gestão do Mix no ERP);
**/

def buffer sClase   for clase.
def buffer grupo    for clase.
def buffer setClase for clase.
def buffer depto for clase.
def var vestatual like estoq.estatual.

for each produ where produ.procod < 999999 /*produ.catcod = 31 or
                     produ.catcod = 35 or 
                     produ.catcod = 41*/   no-lock.
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
    
    
    for each estab /*where etbcod = 1 or
                            etbcod = 2 or
                            etbcod = 3  */
                            no-lock.
            
        if produ.catcod = 41 
        then do.
            find estoq where estoq.procod = produ.procod and
                             estoq.etbcod = estab.etbcod no-lock no-error.
            if not avail estoq or (avail estoq and estoq.estatual = 0)
            then next.       
        end.    
        def var vITEM_ST_ATTR_01_NO as dec.
        find estoq where estoq.procod = produ.procod and 
                         estoq.etbcod = estab.etbcod no-lock no-error.
        vITEM_ST_ATTR_01_NO = if avail estoq and estoq.estatual > 0
                              then estoq.estatual * 10000
                              else 0.
find last movim where movim.procod = produ.procod
                  and movim.movtdc = 4 no-lock no-error.
                  
                  
            create tt-323.
            assign  STORE_ID   = string(estab.etbcod). 
                    SKU_ID     = string(produ.procod). 
                    ORIGIN_ID  = "LEBES" .
                    OPEN_TO_BUY = "Y"     .
                    ITEM_ST_ATTR_01_NO  = vITEM_ST_ATTR_01_NO .
                    ITEM_ST_ATTR_02_NO  = 0.
                    ITEM_ST_ATTR_03_NO  =  if avail movim
                                            then movim.movalicms * 10000
                                            else 12   * 10000      .
                    
                    ITEM_ST_ATTR_04_NO  = produ.proipiper * 10000.
                    /*17    * 10000       .*/
                    ITEM_ST_ATTR_05_NO  = 1.65  * 10000      .
                    ITEM_ST_ATTR_06_NO  = 1.65  * 10000    .
                    ITEM_ST_ATTR_07_NO  = 7.6   * 10000    .
                    ITEM_ST_ATTR_08_NO  = 7.6   * 10000   .
                    ITEM_ST_ATTR_09_NO  = 0     * 10000  .
                    ITEM_ST_ATTR_10_NO  = 0     * 10000 .
                    
                    
            tt-323.RECORD_STATUS            = "A"                .
            tt-323.CREATE_USER_ID           = "ADMCOM"           .
            tt-323.CREATE_DATETIME          = vsysdata           .
            tt-323.LAST_UPDATE_USER_ID      = "ADMCOM"           .
            tt-323.LAST_UPDATE_DATETIME     = vsysdata           .
            .
        def var f as int.
        f = f + 1.
        if f mod 10000 = 0 
        then
        disp f  STORE_ID 
                            SKU_ID  
                            with 1 down.
    end.
end.            
output to value("/admcom/progr/itim/ADMCOM_0323_"  +
                    string(year(today),"9999")     +
                    string(month(today),"99")      +
                    string(day(today),"99")        + "1.DAT") .
for each tt-323.
    put                      
        STORE_ID                          "|"
        SKU_ID                            "|"        
        ORIGIN_ID                         "|"
        OPEN_TO_BUY                       "|" 
        ITEM_ST_ATTR_01_NO                "|"        
        ITEM_ST_ATTR_02_NO                "|" 
        ITEM_ST_ATTR_03_NO                "|" 
        ITEM_ST_ATTR_04_NO                "|" 
        ITEM_ST_ATTR_05_NO                "|" 
        ITEM_ST_ATTR_06_NO                "|" 
        ITEM_ST_ATTR_07_NO                "|" 
        ITEM_ST_ATTR_08_NO                "|" 
        ITEM_ST_ATTR_09_NO                "|"
        ITEM_ST_ATTR_10_NO                "|" 
        RECORD_STATUS                     "|" 
        CREATE_USER_ID                    "|" 
        CREATE_DATETIME                   "|" 
        LAST_UPDATE_USER_ID               "|" 
        LAST_UPDATE_DATETIME
        
    
        skip.
        
end.
output close .


