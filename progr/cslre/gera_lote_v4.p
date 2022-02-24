
def input param p-today as date.
def input param par-loja as int.

def var vok as log.

def var ve_tipo     as char extent 7 init
    ["CADAS","CONTR","FINAN","PARCE","MERCA","PAGTO","BAIXA"].

def var ve_programa as char extent 7 init
    ["../helio/cslre/man_cadastro_v3.p", /* #4 */
     "../helio/cslre/carga_contrato_v3.p",
     "../helio/cslre/man_finan.p",
     "../helio/cslre/parcela.p",
     "../helio/cslre/mercadorias.p",
     "../helio/cslre/pagamentos_v2001.p",
     "../helio/cslre/baixas.p"].
    
def var vti as int.
def var vi as int.

def new shared var v-today as date.
def new shared var v-time  as int.
def new shared var v-etbcod as int.

v-today = p-today.
v-time  = time.

message string(time, "hh:mm:ss") "Criando interface PARA REENVIO".

do vi = 7 to 1 by -1 .

    message string(time, "hh:mm:ss") "Gerando Arquivo" ve_tipo[vi] ve_programa[vi] par-loja.
    run value(ve_programa[vi]) (input par-loja).
    
end.
    
message string(time, "hh:mm:ss") "FIM LOTE" today.

