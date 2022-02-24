def temp-table tt-produ
    field procod like produ.procod.

def var vdata as date.
def var vdtini as int.
def var vdtfin as int.
pause 0 before-hide.
def var a_vista as log.
def temp-table tt-planobiz
    field crecod as integer
    index idx01 crecod.
for each tabaux where tabaux.tabela = "PlanoBiz" no-lock:
    create tt-planobiz.
    assign tt-planobiz.crecod = integer(tabaux.valor_campo).    
      
end.
def var vplanobiz as log.
def buffer bestoq for estoq.
def var vcodplano as int. 
def var vcrecod     as int.
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
         
def temp-table tt-510
    field SALES_DATE  as char format "x(16)"
    field SKU_ID  as char format "x(25)"
    field STORE_ID    as char format "x(10)"
    field ORIGIN_ID   as char format "x(12)"
    field TOT_SLS_VAL as dec format "->>>>>>>>>>>>>>>>>>9,9999"
    field REG_SLS_VAL as dec format "->>>>>>>>>>>>>>>>>>9,9999"
    field PRM_SLS_VAL as dec format "->>>>>>>>>>>>>>>>>>9,9999"
    field CLR_SLS_VAL as dec format "->>>>>>>>>>>>>>>>>>9,9999"
    field TOT_SLS_QTY as dec format "->>>>>>>>>>>>>>>>>>9,9999"
    field REG_SLS_QTY as dec format "->>>>>>>>>>>>>>>>>>9,9999"
    field PRM_SLS_QTY as dec format "->>>>>>>>>>>>>>>>>>9,9999"
    field CLR_SLS_QTY as dec format "->>>>>>>>>>>>>>>>>>9,9999"
    field REG_RTRN_QTY    as dec format "->>>>>>>>>>>>>>>>>>9,9999"
    field REG_RTRN_VAL    as dec format "->>>>>>>>>>>>>>>>>>9,9999"
    field PRM_RTRN_QTY    as dec format "->>>>>>>>>>>>>>>>>>9,9999"
    field PRM_RTRN_VAL    as dec format "->>>>>>>>>>>>>>>>>>9,9999"
    field CLR_RTRN_QTY    as dec format "->>>>>>>>>>>>>>>>>>9,9999"
    field CLR_RTRN_VAL    as dec format "->>>>>>>>>>>>>>>>>>9,9999"
    field OFFER_ID    as char format "x(12)"
    field RECORD_STATUS   as char format "x(1)"
    field CREATE_USER_ID  as char format "x(25)"
    field CREATE_DATETIME as char format "x(16)"
    field LAST_UPDATE_USER_ID as char format "x(25)"
    field LAST_UPDATE_DATETIME    as char format "x(16)"
    index xx is primary unique 
                        SALES_DATE  
                        SKU_ID 
                        STORE_ID
    .
def var vdti as date init today .
def var vdtf as date init today.
def var val_acr like plani.platot.
def var val_des like plani.platot.
def var val_dev like plani.platot.
def var val_com like plani.platot.
def var valor_venda like val_com.
def var qtd_venda   like movim.movqtm.
def var val_fin like plani.platot.
def buffer sclase   for clase.
def buffer grupo    for clase.
def buffer nivel1 for clase.
def buffer nivel2 for clase.
vdti = 08/31/2012.
vdtf = today - 10.

for each tt-produ.
    delete tt-produ.
end.
vdtini = time.
vdata = today - 365.

for each produ no-lock.
for each movim use-index datsai where movim.procod = produ.procod
                 and movim.movtdc = 5
                 and movim.movdat >= vdata no-lock.
    find produ where produ.procod = movim.procod no-lock no-error.
   find first tt-produ where tt-produ.procod = produ.procod  
no-error.
    if not avail tt-produ
    then do:
        create tt-produ.
        tt-produ.procod = produ.procod.
        hide message no-pause.
        message estab.etbcod tt-produ.procod string(vdtini,"hh:mm:ss") string(time,"hh:mm:ss").
    end.
    
end.
end.

vdtfin = time.

disp string(vdtini,"hh:mm:ss") string(vdtfin,"hh:mm:ss") string(vdtfin - vdtini,"hh:mm:ss")
