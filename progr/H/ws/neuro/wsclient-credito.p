/*
    Motor de Credito: julho/2017
*/
{neuro/neu-funcoes.i}

def output parameter p-neuro-sit  as char.
def output parameter p-vlrlimite  as dec.
def output parameter p-vctolimite as date.

def shared temp-table VerificaCreditoVenda
    field codigo_filial   as char
    field codigo_operador as char
    field numero_pdv      as char
    field codigo_cliente  as char
    field valor_compra    as char
    field valor_prestacao as char
    field classe_produtos as char.

def var vclicod as int.

find first VerificaCreditoVenda no-lock.
assign
    vtipoconsulta = "Proposta"
    vetbcod = int(VerificaCreditoVenda.codigo_filial)
    vcxacod = int(VerificaCreditoVenda.numero_pdv)
    vfuncod = int(VerificaCreditoVenda.codigo_operador)
    vclicod = int(VerificaCreditoVenda.codigo_cliente).
/***    vcpf    = int64(VerificaCreditoVenda.cpf)***/.

find clien where clien.clicod = vclicod no-lock.
assign
    vcpf    = int64(clien.ciccgc).

/***
    Acionar Neurotech
***/
p-neuro-sit = "". /*** PROVISORIO ***/

/***

***/
if p-neuro-sit = "A" or
   p-neuro-sit = "P" or
   p-neuro-sit = "R"
then do on error undo.
    assign
        vtime = time.

        run grava-clien (p-neuro-sit, vclicod, "").
        run grava-proposta (p-neuro-sit).
end.
else run grava-log("ERRO ao acessar WS Neurotech"). /*** Grava Log - ERRO ***/

