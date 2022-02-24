/* HUBSEG 19/10/2021 */

def input  parameter vlcentrada as longchar.
def output parameter vlcsaida   as longchar.

def var vsaida as char.
def var hentrada as handle.
def var hsaida   as handle.

{/admcom/progr/api/acentos.i}

def temp-table ttentrada no-undo serialize-name "clientes"
    field cpfCnpj as char.

def var vconta as int.
def var vx as int.
/* Cartoes de loja */
def var vcartoes as char.
def var vct  as int.
def var auxcartao as char extent 7 format "x(20)"
      init ["Visa","Master","Banricompras","Hipercard",
            "Cartoes de Loja","American Express","Dinners"].
/* */
{/admcom/progr/acha.i}
{/admcom/barramento/functions.i}

/* SAIDA */

DEFINE TEMP-TABLE ttclien NO-UNDO       serialize-name 'creditoCliente'
    field tipo    as char format "x(18)"
    field clicod    as char serialize-name 'codigoCliente'
    field cpfCNPJ    as char format "x(18)"    serialize-name 'cpfCNPJ'
    field clinom    as char format "x(40)" serialize-name 'nomeCliente'
    field limite      as char format "x(20)"
    field vctoLimite  as char format "x(30)"
    field saldoLimite  as char format "x(30)"
    field comprometido as char format "x(30)"
    field comprometidoTotal as char format "x(30)"
    field comprometidoPrincipal as char format "x(30)"
    field comprometidoNormal as char format "x(30)"
    field comprometidoNovacao as char format "x(30)"
    index cli is unique primary clicod asc tipo desc.


DEFINE DATASET conteudoSaida FOR ttclien.

hSaida = DATASET conteudoSaida:HANDLE.
def var lokjson as log.

{/admcom/progr/neuro/achahash.i}  /* 03.04.2018 helio */
{/admcom/progr/neuro/varcomportamento.i} /* 03.04.2018 helio */

def temp-table ttsaida  no-undo serialize-name "conteudoSaida"
    field tstatus        as int serialize-name "status"
    field descricaoStatus      as char.

def var vvlrlimite  as dec.
def var vvlrdisponivel as dec.
def var vvctolimite as date.

def var var-comprometidoHUBSEG as dec.

def var var-comprometidoPrincipal as dec.
def var var-comprometidoTotal     as dec.
def var var-comprometidoNovacao     as dec.
def var var-comprometidoNormal     as dec.
def var var-comprometidoEPPrincipal as dec.
def var var-comprometidoEPTotal     as dec.
def var var-comprometidoEPNovacao     as dec.
def var var-comprometidoEPNormal     as dec.



hEntrada = temp-table ttentrada:HANDLE.

lokJSON = hentrada:READ-JSON("longchar",vlcentrada, "EMPTY").


find first ttentrada no-error.
if not avail ttentrada
then do:
  create ttsaida.
  ttsaida.tstatus = 400.
  ttsaida.descricaoStatus = "Sem dados de Entrada".

  hsaida  = temp-table ttsaida:handle.

  lokJson = hsaida:WRITE-JSON("LONGCHAR", vlcSaida, TRUE).
  /*message string(vlcSaida).*/
  return.

end.

find neuclien where neuclien.cpfCnpj =  dec(ttentrada.cpfCnpj) no-lock no-error.
if not avail neuclien
then do:
    find clien where clien.ciccgc = trim(ttentrada.cpfCnpj) no-lock no-error.
end.
else do:
  find clien where clien.clicod = neuclien.clicod no-lock no-error.
end.

if not avail neuclien
then do:

  create ttsaida.
  ttsaida.tstatus = 404.
  ttsaida.descricaoStatus = "Cliente com CPF " +
          (if ttentrada.cpfCnpj = ?
           then ""
           else ttentrada.cpfCnpj) + " Não encontrado.".

  hsaida  = temp-table ttsaida:handle.

  lokJson = hsaida:WRITE-JSON("LONGCHAR", vlcSaida, TRUE).
  /*message string(vlcSaida).*/
  return.

end.


create ttclien.
ttclien.tipo   = "Global".
ttclien.clicod = if avail clien then string(clien.clicod) else ?.
ttclien.clinom = removeacento(if avail clien then clien.clinom else neuclien.nome_pessoa).
ttclien.cpfCnpj = string(neuclien.cpf).

vvlrlimite = 0.
vvctolimite = ?.
vvlrdisponivel = 0.

if avail neuclien
then do:
    vvlrlimite = if neuclien.vctolimite < today
                then 0
                else neuclien.vlrlimite.
    vvctolimite = neuclien.vctolimite.
end.
    ttclien.vctoLimite  =  string(year(vvctolimite),"9999") + "-" +
                          string(month(vvctolimite),"99")   + "-" +
                          string(day(vvctolimite),"99").
    ttclien.Limite   = trim(string(vvlrLimite,"->>>>>>>>>>>>>>>>>9.99")).

    var-propriedades = "" .


      run /admcom/progr/neuro/limites.p (neuclien.cpfCnpj,   output var-propriedades).

      var-comprometidoTotal     = dec(pega_prop("LIMITETOM")).
      var-comprometidoPrincipal = dec(pega_prop("LIMITETOMPR")).
      var-comprometidoHUBSEG    = dec(pega_prop("LIMITETOMHUBSEG")).
      var-comprometidoNovacao   = dec(pega_prop("LIMITETOMNOV")).
      var-comprometidoNormal    = dec(pega_prop("LIMITETOMNORM")).
      vvlrdisponivel = dec(pega_prop("LIMITEDISP")).

    if var-comprometidoHUBSEG = ? then var-comprometidoHUBSEG = 0.

    if var-comprometidoPrincipal = ? then var-comprometidoPrincipal = 0.
    var-comprometidoPrincipal = var-comprometidoPrincipal - var-comprometidoHUBSEG.
    
    if var-comprometidoTotal = ? then var-comprometidoTotal = 0.
    if var-comprometidoNovacao = ? then var-comprometidoNovacao = 0.
    if var-comprometidoNormal = ? then var-comprometidoNormal = 0.

    if vvlrdisponivel < 0
    then vvlrdisponivel = 0.

    ttclien.comprometido   = trim(string(var-comprometidoPrincipal,">>>>>>>>>>>>>>>>>>>9.99")).
    ttclien.saldoLimite    = trim(string(vvlrdisponivel,"->>>>>>>>>>>>>>>>>9.99")).

    ttclien.comprometidoTotal       = trim(string(var-comprometidoTotal,"->>>>>>>>>>>>>>>>>>9.99")).
    ttclien.comprometidoPrincipal   = trim(string(var-comprometidoPrincipal,"->>>>>>>>>>>>>>>>>>9.99")).
    ttclien.comprometidoNovacao     = trim(string(var-comprometidoNovacao,"->>>>>>>>>>>>>>>>>>9.99")).
    ttclien.comprometidoNormal      = trim(string(var-comprometidoNormal,"->>>>>>>>>>>>>>>>>>9.99")).

    create ttclien.
    ttclien.tipo   = "EP".
    ttclien.clicod = if avail clien then string(clien.clicod) else ?.
    ttclien.clinom = removeacento(if avail clien then clien.clinom else neuclien.nome_pessoa).
    ttclien.cpfCnpj = string(neuclien.cpf).

    vvlrlimite = dec(pega_prop("LIMITEEP")).
    vvlrdisponivel = dec(pega_prop("LIMITEDISPEP")).

        ttclien.vctoLimite  =  string(year(vvctolimite),"9999") + "-" +
                              string(month(vvctolimite),"99")   + "-" +
                              string(day(vvctolimite),"99").
        ttclien.Limite   = trim(string(vvlrLimite,"->>>>>>>>>>>>>>>>>>9.99")).


        var-comprometidoEPTotal     = dec(pega_prop("LIMITETOMEP")).
        var-comprometidoEPPrincipal = dec(pega_prop("LIMITETOMPREP")).
        var-comprometidoEPNovacao   = dec(pega_prop("LIMITETOMEPNOV")).
        var-comprometidoEPNormal    = dec(pega_prop("LIMITETOMEPNORM")).

      if var-comprometidoEPPrincipal = ? then var-comprometidoEPPrincipal = 0.
      if var-comprometidoEPTotal = ? then var-comprometidoEPTotal = 0.
      if var-comprometidoEPNovacao = ? then var-comprometidoEPNovacao = 0.
      if var-comprometidoEPNormal = ? then var-comprometidoEPNormal = 0.


      if vvlrdisponivel < 0
      then vvlrdisponivel = 0.

      ttclien.comprometido   = trim(string(var-comprometidoEPPrincipal,"->>>>>>>>>>>>>>>>>>9.99")).
      ttclien.saldoLimite    = trim(string(vvlrdisponivel,"->>>>>>>>>>>>>>>>>>9.99")).

      ttclien.comprometidoTotal       = trim(string(var-comprometidoEPTotal,"->>>>>>>>>>>>>>>>>>9.99")).
      ttclien.comprometidoPrincipal   = trim(string(var-comprometidoEPPrincipal,"->>>>>>>>>>>>>>>>>>9.99")).
      ttclien.comprometidoNovacao     = trim(string(var-comprometidoEPNovacao,"->>>>>>>>>>>>>>>>>>9.99")).
      ttclien.comprometidoNormal      = trim(string(var-comprometidoEPNormal,"->>>>>>>>>>>>>>>>>>9.99")).
                                                                               

create ttclien.
ttclien.tipo   = "CDC".
ttclien.clicod = if avail clien then string(clien.clicod) else ?.
ttclien.clinom = removeacento(if avail clien then clien.clinom else neuclien.nome_pessoa).
ttclien.cpfCnpj = string(neuclien.cpf).

vvlrlimite = 0.
vvctolimite = ?.
vvlrdisponivel = 0.

if avail neuclien
then do:
    vvlrlimite = if neuclien.vctolimite < today
                then 0
                else neuclien.vlrlimite.
    vvctolimite = neuclien.vctolimite.
end.
    ttclien.vctoLimite  =  string(year(vvctolimite),"9999") + "-" +
                          string(month(vvctolimite),"99")   + "-" +
                          string(day(vvctolimite),"99").
    ttclien.Limite   = trim(string(vvlrLimite,"->>>>>>>>>>>>>>>>>>9.99")).

    vvlrdisponivel = dec(pega_prop("LIMITEDISP")).
    ttclien.comprometido   = trim(string(var-comprometidoPrincipal,"->>>>>>>>>>>>>>>>>>9.99")).
    ttclien.saldoLimite    = trim(string(vvlrdisponivel,"->>>>>>>>>>>>>>>>>>9.99")).


      var-comprometidoTotal     = dec(pega_prop("LIMITETOMCDC")).
      var-comprometidoPrincipal = var-comprometidoPrincipal - var-comprometidoEPPrincipal.
      var-comprometidoNovacao   = var-comprometidoNovacao - var-comprometidoEPNovacao.
      var-comprometidoNormal    = var-comprometidoNormal - var-comprometidoEPNormal.


    if var-comprometidoPrincipal = ? then var-comprometidoPrincipal = 0.
    if var-comprometidoTotal = ? then var-comprometidoTotal = 0.
    if var-comprometidoNovacao = ? then var-comprometidoNovacao = 0.
    if var-comprometidoNormal = ? then var-comprometidoNormal = 0.

    if vvlrdisponivel < 0
    then vvlrdisponivel = 0.


    ttclien.comprometidoTotal       = trim(string(var-comprometidoTotal,"->>>>>>>>>>>>>>>>>>9.99")).
    ttclien.comprometidoPrincipal   = trim(string(var-comprometidoPrincipal,"->>>>>>>>>>>>>>>>>>9.99")).
    ttclien.comprometidoNovacao     = trim(string(var-comprometidoNovacao,"->>>>>>>>>>>>>>>>>>9.99")).
    ttclien.comprometidoNormal      = trim(string(var-comprometidoNormal,"->>>>>>>>>>>>>>>>>>9.99")).



lokJson = hSaida:WRITE-JSON("LONGCHAR", vlcsaida, TRUE) no-error.
if lokJson
then do:
        
        /* put unformatted string(vlcsaida).*/
        
end.
else do:
    create ttsaida.
    ttsaida.tstatus = 500.
    ttsaida.descricaoStatus = "Erro na Geração do JSON de SAIDA".

    hsaida  = temp-table ttsaida:handle.

    lokJson = hsaida:WRITE-JSON("LONGCHAR", vlcSaida, TRUE).
    /*message string(vlcSaida).*/
    return.
end.