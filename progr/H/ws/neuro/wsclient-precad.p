/*
    Motor de Credito: julho/2017
*/
{neuro/neu-funcoes.i}

def output parameter p-neuro-sit as char.
def output parameter par-clicod  as int init ?.

def shared temp-table PreAutorizacao
    field codigo_filial   as char
    field codigo_operador as char
    field numero_pdv      as char
    field codigo_cliente  as char
    field cpf             as char
    field nome_pessoa     as char
    field data_nascimento as char
    field mae             as char
    field codigo_mae      as char
    field categoria_profissional as char.

def var vdtnasc as date.

find first PreAutorizacao no-lock.

assign
    vtipoconsulta = "Pre-Cad"
    vetbcod = int(PreAutorizacao.codigo_filial)
    vcxacod = int(PreAutorizacao.numero_pdv)
    vfuncod = int(PreAutorizacao.codigo_operador)
    vcpf    = int64(PreAutorizacao.cpf).

/***
    Acionar Neurotech
***/
p-neuro-sit = "E". /*** PROVISORIO ***/

/***
    Cliente_Credito
***/
if p-neuro-sit = "A" or
   p-neuro-sit = "R"
then do on error undo.
    assign
        vtime = time.

    if p-neuro-sit = "A"
    then do.
        run ./progr/p-geraclicod.p (output par-clicod).

        vdtnasc = date(int(substring(PreAutorizacao.data_nascimento,6,2)),
                       int(substring(PreAutorizacao.data_nascimento,9,2)),
                       int(substring(PreAutorizacao.data_nascimento,1,4))).
        create clien.
        assign
            clien.clicod = par-clicod
            clien.ciccgc = PreAutorizacao.cpf
            clien.clinom = caps(PreAutorizacao.nome_pessoa)
            clien.tippes = yes
            clien.dtnasc = vdtnasc
            clien.etbcad = vetbcod
            clien.mae    = PreAutorizacao.mae.

        create cpclien.
        assign 
            cpclien.clicod     = par-clicod
            cpclien.var-char11 = ""
            cpclien.datexp     = today.
    end.

    run grava-clien (p-neuro-sit, par-clicod,
                     PreAutorizacao.categoria_profissional).

    /***
        Proposta e Operacao
    ***/
    run grava-proposta (p-neuro-sit).
end.
else do on error undo.
    run grava-clien (p-neuro-sit, par-clicod,
                     PreAutorizacao.categoria_profissional).
    run grava-log("ERRO ao acessar WS Neurotech"). /*** Grava Log - ERRO ***/
end.
