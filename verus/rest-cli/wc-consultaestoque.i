
DEFINE {1} SHARED TEMP-TABLE ttestoque NO-UNDO SERIALIZE-NAME "estoque"
    field codigoEstabelecimento as char
    field codigoProduto         as char
    field qtdDisponivel         as char
    field qtdBloqueado          as char
    field qtdTransito           as char
    field qtdTransferencia      as char
    field qtdDisponivelConsignado as char
    field total                 as char
    index x is unique primary codigoEstabelecimento asc codigoProduto asc.

define {1} shared temp-table ttretorno serialize-name "statusRetorno"
    field tstatus   as char serialize-name "status"
    field descricao as char.
    
