/* wf-pre.p */

def var v-param as char.
v-param = os-getenv("esnimei").

def var v-etbcod like estab.etbcod.
def var vtipo-price as char.
def var vseri-price as char.
if substr(string(v-param),1,1) = "s"
then assign
    vseri-price = substr(string(v-param),5,30)
    v-etbcod = int(substr(string(v-param),2,3)).
else v-etbcod = int(substr(string(v-param),1,3)).

def temp-table tt-tbprice like tbprice.
def var q as int.
    put "@INICIO;" string(time) skip.
    put "#TBPRICE;" string(time) skip.
    q = 0.
             vtipo-price = "".
             find first adm.tbprice where 
                  adm.tbprice.tipo = vtipo-price and
                  adm.tbprice.serial = vseri-price 
                  no-lock no-error.
             /*if not avail adm.tbprice
             then find first adm.tbprice where 
                  adm.tbprice.serial = vseri-price 
                  no-lock no-error.
             */     
             if avail adm.tbprice
             then do:
                export adm.tbprice.
                q = q + 1.
             end.
             else do:
                find first adm.tbprice where
                           adm.tbprice.etb_venda = 
                                int(substr(string(v-param),1,3)) and
                           adm.tbprice.data_venda =
                             date(substr(string(v-param),4,8)) and
                           adm.tbprice.nota_venda =
                                int(substr(string(v-param),12,9))
                           no-lock no-error.
                if avail adm.tbprice
                then do:
                    export adm.tbprice.
                    q = q + 1.
                end.
                else do:
                    find first adm.tbcntgen where
                         tbcntgen.tipcon = 4 and
                         tbcntgen.etbcod = v-etbcod no-lock no-error.
                    if not avail tbcntgen
                    then do:
                        create tt-tbprice.
                        tt-tbprice.serial = vseri-price.
                        export tt-tbprice.
                        delete tt-tbprice.
                        q = q + 1.
                    end.
                end.
             end.
    put skip "@FIMTBPRICE;" string(q,"99999").    
    put skip "@FIMFIM;" + string(time)
        skip.

quit.
