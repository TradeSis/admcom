/*
  cyber/arquivo.i
  13/01/2015
*/
function formatadata returns character
    (input par-data  as date). 
    
    def var vdata as char.  
    if par-data <> ? 
    then 
        vdata = string(month(par-data), "99") + 
                string(day  (par-data), "99") +
                string(year (par-data), "9999"). 
    else 
        vdata = "00000000". 
    return vdata. 

end function.


function formatanumero returns int
    (input par-valor as int).

    if par-valor = ? /* valores invalidos */
    then return 0.
    else return int(par-valor).

end function.


function formatavalor returns dec
    (input par-valor as dec).

    if par-valor = ? or par-valor > 999999 /* valores invalidos */
    then return 0.
    else return par-valor * 100.

end function.


function trata-numero returns character
    (input par-num as char).

    def var par-ret as char.
    def var j as int.
    def var t as int.
    def var vletra as char.

    t = length(par-num).
    do j = 1 to t:
        vletra = substr(par-num,j,1).
        if vletra = "0" or
           vletra = "1" or
           vletra = "2" or
           vletra = "3" or
           vletra = "4" or
           vletra = "5" or
           vletra = "6" or
           vletra = "7" or
           vletra = "8" or
           vletra = "9"
        then assign par-ret = par-ret + vletra.
    end.
    return par-ret.

end function.

                    
def var vdata_geracao  as char.
def var vhora_geracao  as char.
def var cdata      as char.
def var vdiretorio as char.
def var varq       as char.
def var vnomearq   as char.

vdata_geracao = formatadata(v-today).


if {1} <> "mercadorias" and
   {1} <> "parcelas"       
then
do.
    vhora_geracao = string(v-time,"HH:MM:SS").
    vhora_geracao = substr(vhora_geracao,1,2) +
                    substr(vhora_geracao,4,2) +
                    substr(vhora_geracao,7,2) + "_".
end.
   
cdata = string(year (v-today), "9999") +
        string(month(v-today), "99") +
        string(day  (v-today), "99").

vnomearq = cdata + "_" + {1} + "_" + string(par-loja,"999") + "_in".

vdiretorio = "/admcom/tmp/cslog_reenvio/".

vdiretorio = vdiretorio + string(par-loja,"999") + "/" .
        /**+ string(v-etbcod,"999") + "/".**/

unix silent value("mkdir -p " + vdiretorio).

varq = vdiretorio + "/" + vnomearq + ".txt".
