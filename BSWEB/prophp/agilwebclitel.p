def var v-param as char.
def var v-etbcod like estab.etbcod.
def var v-clicod like clien.clicod.
v-param = os-getenv("clitel").
v-etbcod = int(substr(string(v-param),1,3)).
v-clicod = int(substr(string(v-param),4,10)).

def var vdata as date.
def var q as int.

def temp-table tt-estoq like estoq.
    
    put "~"@INICIO;" string(time) "~"" skip.
    
    put "~"#CLITEL;" string(time) "~"" skip.
    q = 0.
    for each clitel where clitel.clicod = v-clicod no-lock.
        find tipcont of clitel no-lock no-error.
        export clitel.CliCod     
               clitel.teldat     
               clitel.telhor     
               clitel.FunCod     
               clitel.telobs     
               clitel.titcod     
               clitel.titnum     
               clitel.datac      
               clitel.tiphis     
               clitel.codcont    
               clitel.dtpagcont  
               clitel.fonecont   
               clitel.ndiascont  
               clitel.carta      
               clitel.spc        
               clitel.hrpagcont  
               clitel.etbcod     
               clitel.empcod    
               clitel.modcod  
               clitel.titnat  
               clitel.titpar  
               clitel.etbcobra
               if avail tipcont
               then tipcont.desccont
               else "".
            q = q + 1.
      end.
      put skip "~"@FIMCLITEL;"  string(q,"9999") "~"". 
      put skip "~"@FIMFIM;"  string(time) "~"" skip.

