/*
    Motor de Credito: julho/2017
*/
{neuro/neu-funcoes.i}

def output parameter p-neuro-sit  as char.
def output parameter p-vlrlimite  as dec.
def output parameter p-vctolimite as date.

def shared temp-table AtualizacaoDadosCliente
    field codigo_filial as int
    field codigo_operador as char
    field numero_pdv    as int
    field codigo_cliente as char
    field cpf as char
    field nome as char
    field data_nascimento as char
    field codigo_senha as char
    field valor_limite as char
    field codigo_bloqueio as int
    field descricao_bloqueio as char
    field percentual_desconto as char
    field validade_desconto as char
    field valor_seguro as char
    field situacao_seguro_cliente as char
    field cep as char
    field endereco as char
    field numero as char
    field complemento as char
    field bairro as char
    field cidade as char
    field uf as char
    field pais as char
    field email as char
    field deseja_receber_email as char
    field ddd as char
    field telefone as char
    field tipo_pessoa as char
    field credito as char
    field tipo_credito as char
    field sexo as char
    field nacionalidade as char
    field identidade as char
    field estado_civil as char
    field naturalidade as char
    field cnpj as char
    field pai as char
    field mae as char
    field numero_dependentes as char
    field grau_de_instrucao as char
    field situacao_grau_de_instrucao as char
    field plano_saude as char
    field seguros as char
    field ponto_referencia as char
    field celular as char
    field tipo_residencia as char
    field tempo_na_residencia as char
    field data_cadastro as char
    field empresa as char
    field cnpj_empresa as char
    field telefone_empresa as char
    field data_admissao as char
    field profissao as char
    field renda_total as char
    field endereco_empresa as char
    field numero_empresa as char
    field complemento_empresa as char
    field bairro_empresa   as char 
    field cidade_empresa   as char 
    field estado_empresa   as char 
    field cep_empresa   as char 
    field nome_conjuge   as char 
    field cpf_conjuge   as char 
    field data_nascimento_conjuge   as char 
    field pai_conjuge   as char 
    field mae_conjuge   as char 
    field empresa_conjuge as char 
    field telefone_conjuge   as char 
    field profissao_conjuge as char 
    field data_admissao_conjuge  as char 
    field renda_mensal_conjuge as char
    field cartoes_de_credito  as char 
    field banco1 as char
    field tipo_conta_banco1 as char
    field ano_conta_banco1 as char
    field banco2 as char
    field tipo_conta_banco2 as char
    field ano_conta_banco2 as char
    field banco3 as char
    field tipo_conta_banco3 as char
    field ano_conta_banco3 as char
    field banco_outros as char
    field tipo_conta_outros as char
    field ano_banco_outros as char
    field referencias_comerciais1 as char
    field situacao_referencias_comerciais1 as char
    field referencias_comerciais2 as char
    field situacao_referencias_comerciais2 as char
    field referencias_comerciais3 as char
    field situacao_referencias_comerciais3 as char
    field referencias_comerciais4 as char
    field situacao_referencias_comerciais4 as char
    field referencias_comerciais5 as char
    field situacao_referencias_comerciais5 as char
    field observacoes as char 
    field possui_veiculo    as char         
    field marca as char  
    field modelo as char  
    field ano as char   
    field nome_ref1 as char  
    field fone_comercial_ref1  as char 
    field celular_ref1  as char 
    field parentesco_ref1  as char 
    field documentos_apresentados_rf1   as char 
    field nome_ref2  as char 
    field fone_comercial_ref2   as char 
    field celular_ref2  as char 
    field parentesco_ref2 as char 
    field documentos_apresentados_rf2  as char 
    field nome_ref3  as char 
    field fone_comercial_ref3  as char 
    field celular_ref3  as char 
    field parentesco_ref3  as char 
    field documentos_apresentados_rf3  as char 
    field resultado_consulta_spc  as char 
    field filial_efetuou_consulta  as char 
    field data_consulta  as char 
    field quantidade_consultas_realizadas   as char 
    field registros_de_alertas as char 
    field registro_do_credito  as char 
    field registro_de_cheques  as char 
    field registro_nacional  as char 
    field spc_cod_motivo_cancelamento  as char 
    field spc_descr_motivo  as char 
    field resultado_consulta_serasa  as char 
    field serasa_cod_motivo_cancelamento  as char 
    field serasa_descr_motivo  as char 
    field resultado_consulta_crediario  as char 
    field crediario_cod_motivo_cancelament  as char 
    field crediario_descr_motivo  as char 
    field limite_cod_motivo_cancelamento  as char 
    field limite_descr_motivo  as char 
    field nota as char .

def var vneu-llimite as dec.
def var vneu-dtlimite as date.

find first atualizacaodadoscliente no-lock.
assign
    vtipoconsulta = "Cadastro"
    vetbcod = int(atualizacaodadoscliente.codigo_filial)
    vcxacod = int(atualizacaodadoscliente.numero_pdv)
    vfuncod = int(atualizacaodadoscliente.codigo_operador)
    vcpf    = int64(atualizacaodadoscliente.cpf).

/***
    Acionar Neurotech
***/
p-neuro-sit = "". /*** PROVISORIO ***/

/***

***/
if p-neuro-sit = "A" or
   p-neuro-sit = "R"
then do on error undo.
    assign
        vtime = time.
    if p-neuro-sit = "A"
    then do.
        find neuclien where neuclien.cpfcnpj = vcpf no-error.

        run grava-proposta (p-neuro-sit).
    end.
end.
else run grava-log("ERRO ao acessar WS Neurotech"). /*** Grava Log - ERRO ***/
