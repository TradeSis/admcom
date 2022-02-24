def input param poperacao as char.
def input param parquivo as char.
def output param pcodocorrencia as char.
def output param pocorrencia as char.

def var vcontnum as int.
def var vtitpar  as int.

def var lokJSON as log.
def var vlcEntrada as longchar.
def var vlcSaida   as longchar.

def shared temp-table ttprot
    field precid        as recid
    field protocolo     as char
    field dtprotocolo   as char
    field vlrcustas     as dec
    field codocorrencia as char
    field ocorrencia    as char.

def var hEntrada as handle.
def var hSaida   as handle.

def temp-table ttjson serialize-name "jsonSoapResponse"
    field acao  as char serialize-name "operacao"
    field nome_arquivo as char
    field operacaoSol as char
    field codocorrencia as char
    field ocorrencia as char.

def temp-table tthd serialize-name "hd"
         field h01   as char
         field h02   as char
         field h03   as char
         field h04   as char
         field h05   as char
         field h06   as char
         field h07   as char
         field h08   as char
         field h09   as char
         field h10   as char
         field h11   as char
         field h12   as char
         field h13   as char
         field h14   as char
         field h15   as char
         field h16   as char
         field h17   as char.
def temp-table tttr serialize-name "tr"
         field t01  as char
         field t02  as char
         field t03  as char
         field t04  as char
         field t05  as char
         field t06  as char
         field t07  as char
         field t08  as char
         field t09  as char
         field t10  as char
         field t11  as char
         field t12  as char
         field t13  as char
         field t14  as char
         field t15  as char
         field t16  as char
         field t17  as char
         field t18  as char
         field t19  as char
         field t20  as char
         field t21  as char
         field t22  as char
         field t23  as char
         field t24  as char
         field t25  as char
         field t26  as char
         field t27  as char
         field t28  as char
         field t29  as char
         field t30  as char
         field t31  as char
         field t32  as char
         field t33  as char
         field t34  as char
         field t35  as char
         field t36  as char
         field t37  as char
         field t38  as char
         field t39  as char
         field t40  as char
         field t41  as char
         field t42  as char
         field t43  as char
         field t44  as char
         field t45  as char
         field t46  as char
         field t47  as char
         field t48  as char
         field t49  as char
         field t50  as char
         field t51  as char
         field t52  as char.
def temp-table tttl serialize-name "tl"
         field t01   as char
         field t02   as char
         field t03   as char
         field t04   as char
         field t05   as char
         field t06   as char
         field t07   as char
         field t08   as char.
         
def dataset dadosEntrada for ttjson, tthd, tttr, tttl.

hSaida = dataset dadosEntrada:handle.



def temp-table ttentrada serialize-name "dadosEntrada"
    field nome_arquivo as char.

hEntrada = temp-table ttentrada:handle.

create ttentrada.
ttentrada.nome_arquivo = parquivo.

hEntrada:WRITE-JSON("longchar",vLCEntrada, true, ?) no-error.

run api/wc-iepro.p ("confirmacao",
                    input vlcentrada,
                    output vlcSaida).




lokJSON = hsaida:READ-JSON("longchar",vlcsaida, "EMPTY") no-error.
pocorrencia = "SEM RETORNO".
pcodocorrencia = ?.
find first ttjson no-error.
if avail ttjson
then do:
    pocorrencia = ttjson.ocorrencia.
    pcodocorrencia = ttjson.codocorrencia no-error.
    if ttjson.acao = ttjson.operacaosol and
       pcodocorrencia = "0"
    then do:
        for each tttr.
            disp tttr.t13.
            vcontnum = int(entry(1,tttr.t13,"/")).
            vtitpar  = int(entry(2,tttr.t13,"/")).
            find titprotesto where titprotesto.operacao = poperacao and
                                   titprotesto.contnum  = vcontnum  and
                                   titprotesto.titpar   = vtitpar
                no-lock no-error.
            if avail titprotesto
            then do:
                
                create ttprot.
                ttprot.precid = recid(titprotesto).
                ttprot.codocorrencia = pcodocorrencia.
                ttprot.ocorrencia = "CON".
                ttprot.protocolo = tttr.t32.
                ttprot.dtprotocolo = tttr.t34.
                ttprot.vlrcustas = dec(tttr.t40) + dec(tttr.t42) + dec(tttr.t50).
                 
            end.
        end.    
    end.
end.    

         
