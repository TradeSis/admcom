def var varquivo as char.
def var v-clicod like clien.clicod.
def var v-param as char.
def var vetbcod like estab.etbcod.
def var vnumero like plani.numero.
def var vpladat like plani.pladat.
def var vdif as char format "xx".
def var vpedmod as char.
def var vq as int.                                
v-param = os-getenv("pedliped").
vetbcod = int(substr(string(v-param),1,3)).
vpedmod = substr(string(v-param),4,4).

def temp-table tt-pedid like pedid.
def temp-table tt-liped like liped.
def var vobs as char.
def var q as int.                    
    

    if vpedmod = ""
    then do:
         for each com.pedid where com.pedid.pedtdc = 3
                              and com.pedid.etbcod = vetbcod
                              and com.pedid.peddat >= (today - 120) no-lock:
            create tt-pedid.
            buffer-copy com.pedid to tt-pedid.
            
            for each com.liped where
                     com.liped.etbcod = com.pedid.etbcod and
                     com.liped.pedtdc = com.pedid.pedtdc and
                     com.liped.pednum = com.pedid.pednum no-lock:
            
                create tt-liped.
                buffer-copy com.liped to tt-liped.   
            end.
            
         end.
    end.
    else do:
            for each com.pedid where com.pedid.pedtdc = 3
                              and com.pedid.etbcod = vetbcod
                              and com.pedid.peddat >= (today - 120) 
                              and com.pedid.modcod  = vpedmod
                              no-lock:
                if com.pedid.pendente then next.
                create tt-pedid.
                buffer-copy com.pedid to tt-pedid.
                for each com.liped where
                     com.liped.etbcod = com.pedid.etbcod and
                     com.liped.pedtdc = com.pedid.pedtdc and
                     com.liped.pednum = com.pedid.pednum no-lock:
                    create tt-liped.
                    buffer-copy com.liped to tt-liped.

                    
                    if com.pedid.pendente and
                        com.liped.Lip_Status = ""
                then tt-pedid.pedobs[5] = "PENDENTE". 
                    

                end.                       
            end.
    end.

 
    put "~"@INICIO;" string(time) "~"" skip.
    put "~"#PEDID;" string(time) "~"" skip.
    q = 0. 
    for each tt-pedid:
        export tt-pedid.
        q = q + 1.
    end.    
    put skip "~"@FIMPEDID;" string(q,"99999") "~"" skip.
    put "~"#LIPED;" string(time) "~"" skip.
    q = 0.
    for each tt-liped:
        /*export tt-liped except lipipi lipdes wmsgaiola lipqtdcanc.*/
        export tt-liped.pedtdc tt-liped.pednum tt-liped.procod tt-liped.lipqtd tt-liped.lippreco tt-liped.lipsit tt-liped.lipent tt-liped.predtf tt-liped.predt tt-liped.lipcor tt-liped.etbcod tt-liped.lipsep tt-liped.protip .
        q = q + 1.
    end.    
    put skip "~"@FIMLIPED;" string(q,"99999") "~"" skip.
    put "~"@FIMFIM;" string(time) "~"" skip.
    q = 0.

