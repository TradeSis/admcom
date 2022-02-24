
def var p-today as date init today.

def var vok as log.


def var ve_tipo     as char extent 7 init
    ["CADAS","CONTR","FINAN","PARCE","MERCA","PAGTO","BAIXA"].

def var ve_programa as char extent 7 init
    ["cslre/man_cadastro_v3.p", /* #4 */
     "cslre/carga_contrato_v3.p",
     "cslre/man_finan.p",
     "cslre/parcela.p",
     "cslre/pagamentos_v2001.p",
     ""].
     /*
     "cslre/mercadorias.p",
          "cslre/baixas.p"].*/
     
    
def var vti as int.
def var vi as int.

def new shared var v-today as date.
def new shared var v-time  as int.
def new shared var v-etbcod as int.

v-today = p-today.
v-time  = time.

message string(time, "hh:mm:ss") "Criando interface".
def new shared temp-table ttcontrato no-undo
    field contnum as int format ">>>>>>>>>>>>>9"
    index cont is unique primary contnum asc.
    
input from /admcom/helio/CSLOG/xaa.
repeat.
    create ttcontrato.
    import ttcontrato.
end.    
input close.

pause 0 before-hide.
do vi = 7 to 1 by -1 .

    message string(time, "hh:mm:ss") "Gerando Arquivo" ve_tipo[vi] ve_programa[vi].
    if ve_programa[vi] <> ""
    then run value(ve_programa[vi]) .
    
end.
    
message string(time, "hh:mm:ss") "AJUSTE".

message string(time, "hh:mm:ss") "FIM LOTE" today.

