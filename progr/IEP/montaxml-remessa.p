def input  param poperacao   as char.
def input  param parquivo    as char.
def input  param psequencial as int.
def output param pcodocorrencia as char.
def output param pocorrencia as char.

def var hEntrada as handle.
def var hSaida   as handle.
def var vlcentrada as longchar.
def var vlcsaida as longchar.

def shared temp-table ttprot
    field precid as recid.

def temp-table ttdadosxml  no-undo serialize-name "dadosEntrada"
      field acao        as char serialize-name "operacao"
      field nome_arquivo    as char 
      field dadosXml        as char.

def temp-table ttresponsejson  no-undo serialize-name "jsonSoapResponse"
      field nome_arquivo    as char 
      field operacaoSol     as char
      field codocorrencia   as char
      field ocorrencia      as char.

hentrada = temp-table ttdadosxml:handle. 
hsaida   = temp-table ttresponsejson:handle. 


create ttdadosxml.
ttdadosxml.acao     = "remessas". 
ttdadosxml.nome_arquivo = parquivo.


def var vlayout as char.
def var vlayout-transacao as char.

input from /admcom/progr/iep/remessa-header.xml.
import unformatted vlayout.
input close.

def var vqtdregistros     as int.
def var vlinha as int.
def var vvalortot as dec.

for each ttprot.
    find titprotesto where recid(titprotesto) = ttprot.precid no-lock.
    vqtdregistros = vqtdregistros + 1.
    vvalortot = vvalortot + titprotesto.titvlcob + titprotesto.titvljur.
end.

vlayout = replace(vlayout,"@NOMEDOARQUIVO",ttdadosxml.nome_arquivo).
vlayout = replace(vlayout,"@DATAMOVIMENTO",string(today,"99999999")).
vlayout = replace(vlayout,"@SEQUENCIAREMESSA",string(pSEQUENCIAL)).
vlayout = replace(vlayout,"@QTDREGISTROS",string(vqtdregistros + 2)).
vlayout = replace(vlayout,"@QTDTITULOS",string(vqtdregistros)).

vlinha = 1.
vlayout = replace(vlayout,"@LINHA",string(vlinha)).

ttdadosxml.dadosxml = vlayout .

input from /admcom/progr/iep/remessa-transacao.xml.
import unformatted vlayout-transacao.
input close.


for each ttprot.
    find titprotesto where recid(titprotesto) = ttprot.precid no-lock.
    
    vlayout = vlayout-transacao.
    
    find contrato of titprotesto no-lock.
    find clien of contrato no-lock.
    find neuclien where neuclien.clicod = clien.clicod no-lock no-error.
    find titulo where titulo.empcod = 19 and titulo.titnat = no and
            titulo.etbcod = contrato.etbcod and titulo.modcod = contrato.modcod and
             titulo.clifor = contrato.clicod and titulo.titnum = string(contrato.contnum) and
             titulo.titpar = titprotesto.titpar
             no-lock.

    vlayout = replace(vlayout,"@TITNUM",titulo.titnum + string(titulo.titpar,"99")).
    vlayout = replace(vlayout,"@NOSSONUMERO",titulo.titnum + "/" + string(titulo.titpar,"99")).
    
    vlayout = replace(vlayout,"@TITDTEMI",string(titulo.titdtemi,"99999999")).
    vlayout = replace(vlayout,"@TITDTVEN",string(titulo.titdtven,"99999999")).
    vlayout = replace(vlayout,"@TITVLCOB",trim(string(titprotesto.titvlcob + titprotesto.titvljur,">>>>>>>>>>>>>>>>>>>9.99")) ).
    
    vlayout = replace(vlayout,"@CLINOM",string(clien.clinom)).
    vlayout = replace(vlayout,"@CPF",string(if avail neuclien then string(neuclien.cpf) else if clien.ciccgc = ? then "0" else clien.ciccgc)).
    vlayout = replace(vlayout,"@ENDERECO",string(clien.endereco[1])).
    vlayout = replace(vlayout,"@CI",string(clien.CIINSC)).
    
    vlayout = replace(vlayout,"@CEP",string(clien.cep[1])).
    vlayout = replace(vlayout,"@CIDADE",string(clien.cidade[1])).
    vlayout = replace(vlayout,"@BAIRRO",string(clien.bairro[1])).
    
    vlayout = replace(vlayout,"@UF",string(clien.ufecod[1])).
    
    
    
    vlinha = vlinha + 1.
    vlayout = replace(vlayout,"@LINHA",string(vlinha)).
    ttdadosxml.dadosxml = ttdadosxml.dadosxml + vlayout + " " .    


end.

input from /admcom/progr/iep/remessa-trailler.xml.
import unformatted vlayout.
input close.


vlayout = replace(vlayout,"@NOMEDOARQUIVO",ttdadosxml.nome_arquivo).
vlayout = replace(vlayout,"@DATAMOVIMENTO",string(today,"99999999")).
vlayout = replace(vlayout,"@SEQUENCIAREMESSA",string(PSEQUENCIAL)).

    vlayout = replace(vlayout,"@QTDREGISTROS",string(vqtdregistros * 3)).

    vlayout = replace(vlayout,"@VALORTOT",trim(string(vvalortot,">>>>>>>>>>>>>>>>>>>9.99"))).

vlinha = vlinha + 1.
vlayout = replace(vlayout,"@LINHA",string(vlinha)).

ttdadosxml.dadosxml = ttdadosxml.dadosxml + vlayout.



hEntrada:WRITE-JSON("longchar",vLCEntrada, true, ?).
hEntrada:WRITE-JSON("file","saida2-1.xml", true, ?).


run api/wc-iepro.p ("remessas",
                    input vlcentrada,
                    output vlcSaida).
hSaida:READ-JSON("longchar",vLCSaida, "EMPTY").

find first ttresponsejson no-error.

pocorrencia = "SEM RETORNO".
pcodocorrencia = ?.
if avail ttresponsejson
then do:
    pocorrencia = ttresponsejson.ocorrencia.
    pcodocorrencia = ttresponsejson.codocorrencia no-error.
end.