def var v-clicod like clien.clicod.
def var v-param as char.
def var v-etbcod like estab.etbcod.
def var v-ciccgc as char.                               
v-param = os-getenv("clienok").
v-etbcod = int(substr(string(v-param),1,3)).
v-clicod = int(substr(string(v-param),4,10)).
v-ciccgc = substr(string(v-param),14,11).

find clien where clien.clicod = v-clicod no-lock no-error.
if avail clien
then do:    
    put "#CLIEN;OK;" 
         string(today,"99/99/9999") ";"
         string(time,"hh:mm:ss") skip.
end.
