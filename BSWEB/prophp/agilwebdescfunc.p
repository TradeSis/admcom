def var p-ciccgc as char.
def var v-param as char.

def var v-ciccgc as char.

v-param = os-getenv("descfunc").

assign p-ciccgc = v-param.

def var q as int.                    
def var i as int.

v-ciccgc = "".
do i = 1 to length(p-ciccgc):
    if substring(p-ciccgc,i,1) = "0" or
        substring(p-ciccgc,i,1) = "1" or
        substring(p-ciccgc,i,1) = "2" or
        substring(p-ciccgc,i,1) = "3" or
        substring(p-ciccgc,i,1) = "4" or
        substring(p-ciccgc,i,1) = "5" or
        substring(p-ciccgc,i,1) = "6" or
        substring(p-ciccgc,i,1) = "7" or
        substring(p-ciccgc,i,1) = "8" or
        substring(p-ciccgc,i,1) = "9"
    then v-ciccgc = v-ciccgc + substring(p-ciccgc,i,1).
end.

find first clien where
           clien.ciccgc = v-ciccgc  
            no-lock no-error.

if avail clien 
then find first tipo_clien where tipo_clien.tipocod = clien.tipocod
                                    no-lock no-error.
            
q = 0.                            
put unformatted "@INICIO;" string(time) skip.
    
put unformatted "#DESCFUNC".

if avail clien
then put unformatted "|CADASTRO=SIM".
else put unformatted "|CADASTRO=NAO".
         
if avail tipo_clien
    and tipo_clien.tipodes = "FUNCIONARIO"
then do:
    
    put unformatted "|FUNCIONARIO=SIM".

    for each categoria where categoria.desc_func > 0 no-lock.
    
        if categoria.catcod = 31
        then do:
            
             put unformatted
             "|DESC31=" trim(string(categoria.desc_func,">>9.99")).
            
        end.    
        else if categoria.catcod = 41
        then do:
            
            put unformatted
            "|DESC41=" trim(string(categoria.desc_func,">>9.99")).
            
        end.
    end.
    
end.
else put unformatted "|FUNCIONARIO=NAO".

q = q + 1.

put skip "@FIMDESCFUNC;" string(q,"99999") skip.                      
put skip "@FIMFIM;" string(time) skip.

