{admcab.i}

def input parameter p-rec as recid.
def var valor-vale like commatriz.plani.platot.
def var qtd-vale   as int.
def var xx as char format "x(22)".
def var vporta as char.
def var vmes as char initial "Janeiro,Fevereiro,Marco,Abril,Maio,Junho,Julho,Agosto,Setembro,Outubro,Novembro,Dezembro".
def var vcontrato as char format "x(30)".
def var vvenda as dec format ">>>>>>>.99".
def var vprest as dec format ">>>>>>>.99".
def var vdpaga as int format ">>9".
def var vendereco as char format "x(25)".
def var vdtult as char.
def var vdtpri as char.
def var vparc as char.
def var v-etbcod like estab.etbcod.
def var v-pladat like com.plani.pladat.

def buffer btitulo for finmatriz.titulo.

def var largura as int init 56.

def temp-table tt-texto
    field linha as char format "x(96)".

input from value("/usr/admcom/progr/contrato.txt") no-echo.
repeat transaction.
    create tt-texto.
    import unformatted tt-texto.
end.
input close.
 
find finmatriz.contrato where recid(contrato) = p-rec no-lock no-error.

assign vcontrato = string(contrato.contnum,">>>>>>>>>9").

find last finmatriz.titulo where titulo.empcod = 19 
                   and titulo.titnat = no 
                   and titulo.modcod = "CRE"
                   and titulo.etbcod = contrato.etbcod
                   and titulo.clifor = contrato.clicod
                   and titulo.titnum = string(contrato.contnum)
                   no-lock no-error.
if avail titulo then 
    assign vprest = titulo.titvlcob
           vdtult = string(titulo.titdtven)
           vparc  = string(titulo.titpar).
           
find first btitulo where btitulo.empcod = 19
                    and btitulo.titnat = no
                    and btitulo.modcod = "CRE"
                    and btitulo.etbcod = contrato.etbcod
                    and btitulo.clifor = contrato.clicod
                    and btitulo.titnum = string(contrato.contnum)
                    and btitulo.titpar = 1 no-lock no-error.
if avail btitulo
then assign
    vdtpri = string(btitulo.titdtven)
    vdpaga = btitulo.titdtven - btitulo.titdtemi
.                        

message btitulo.titdtven btitulo.titdtemi
btitulo.titdtven - btitulo.titdtemi
. pause 0.
    
find finmatriz.contnf where contnf.etbcod = contrato.etbcod and
                  contnf.contnum = contrato.contnum no-lock no-error.

find first commatriz.plani where plani.etbcod  =  contnf.etbcod and 
                 plani.placod  = contnf.placod and
                 plani.movtdc  = 5 and
                 plani.serie = "V" no-lock no-error.
if not avail commatriz.plani
then find first commatriz.plani where plani.etbcod  =  contnf.etbcod and
            plani.placod  = contnf.placod and
            plani.movtdc  = 5 and
            plani.serie = "3" no-lock no-error.
if not avail commatriz.plani
then find first commatriz.plani where 
                commatriz.plani.etbcod  =  contnf.etbcod and
                commatriz.plani.placod  =  contnf.placod and
                commatriz.plani.serie   =  contnf.notaser
                no-lock no-error.
if avail commatriz.plani 
then assign
    vvenda = plani.platot - plani.vlserv - plani.descprod
    v-etbcod = commatriz.plani.etbcod
    v-pladat = commatriz.plani.pladat
    .
    
else do:
    message color red/with "Venda não encontrada."
    view-as alert-box.
    return.
end.
find germatriz.clien where clien.clicod = contrato.clicod no-lock no-error.

if avail clien then
assign vendereco = trim(clien.endereco[1]).

find finmatriz.finan where finan.fincod = contrato.crecod no-lock no-error.

/*if avail finan then
    assign vparc = string(finan.finnpc).
  */
                    
def var parametro as char format "x(20)".
def var funcao          as char format "x(20)" .
def var sprog-contrato as char.

/****
input from ./admcom.ini  no-echo.
repeat:                   
    set funcao parametro.
    if funcao = "IMPRIME-CONTRATO"
    then sprog-contrato = parametro.
end.
input close.

if sprog-contrato = "" then return.
***/

def var varquivo as char.
def var valor-divida as dec.
def var pct-fin as dec.

def var vtametiq as int format "9999".
def var vqtdpar as int.
def var vseq as int.
def var vseq2 as int.
def var vseq3 as int.
def var vtitlin as char format "x(61)".
def var vpostit as char format "x(15)".
def var vtampro as int format ">>9".
def var vstring as char format "x(66)".
def var vvlcomp like plani.platot.
def var vlinven as int.
def var vfunc like germatriz.func.funcod.
def var vent  like titulo.titvlcob.
def var vseq1 as int.
def var vtampro99 as int.
/*
message contrato.etbcod
        contrato.crecod
        finan.finnpc
        vvenda
        vprest
        vdpaga.
        pause.
*/                                   
{chama-cal-tx-wssicred.i}

message vret-CET vret-CETAnual. pause 0.

assign vret-CET = trim(string(round(decimal(vret-CET),2),">,>>9.99")).
assign vret-CETAnual = trim(string(round(decimal(vret-CETAnual),2),">,>>9.99")).

varquivo = "/usr/admcom/spool/contrato" +
            string(time) + "." + string(contrato.contnum).

valor-divida = vprest * int(vparc).
pct-fin = (valor-divida / dec(vret-ValorFinanciado)) * 100.

/*************
vret-CETAnual = trim(string(round(decimal(vret-CETAnual),2),">,>>9.99")).

def buffer movim for commatriz.movim.
def buffer produ for commatriz.produ.

/***
def var vret-CETAnual as dec.
def var vret-Taxa as dec.
def var vret-ValorIOF as dec.

find finmatriz.envfinan where envfinan.empcod = 19 and
                    finmatriz.envfinan.titnat  = yes and
                    finmatriz.envfinan.modcod = "CRE" and
                    finmatriz.envfinan.etbcod = finmatriz.contrato.etbcod and
                    finmatriz.envfinan.clifor = finmatriz.contrato.clicod and
                    finmatriz.envfinan.titnum =
                                        string(finmatriz.contrato.contnum) and
                    finmatriz.envfinan.titpar = 999
                    no-lock no-error.
assign
    vret-CETAnual = finmatriz.envfinan.envcet
    vret-Taxa     = finmatriz.envfinan.txjuro
    vret-ValorIOF = finmatriz.envfinan.enviof.
***/

varquivo = "/usr/admcom/spool/" + "contrato" +
            string(time) + "." + string(contrato.contnum).

*****/

{contratoimp.i}

/*
output to value(varquivo).
    
       put chr(29) + chr(33) + chr(0)   skip  .      /* tamanho da fonte */

       put chr(27) + chr(97) + chr(49) /* skip */.       /* centraliza */
   
       put chr(27) + chr(51) + chr(25) /* skip */  . /* espaco 1/6 entre lin */

       put chr(27) + "!" + chr(30)  skip .
       
       put "PROPOSTA DE FINANCIAMENTO/ADESAO" skip
           "PESSOA FISICA" skip(1).
       
       put chr(27) + "!" + chr(8).
       
       put chr(27) + chr(97) + chr(49) skip.       /* centraliza */
       
       put chr(27) + chr(97) + chr(48) skip.    /* justifica esquerda */ 
 
       put "TIPO DE OPERACAO" skip
       "(XX) CDC"  " (  ) CREDITO LOJISTA" skip
       " N: "  vcontrato  skip.

       put "DREBES & CIA LTDA, inscrito no CNPJ sob n" skip
           "96.662.1680001-31, legalmente representado" skip
           "na forma do seu Contrato Social, doravante" skip
           "designado LOJA. DREBES FINANCEIRA S.A." skip
           "CREDITO FINANCIAMENTO E INVESTIMENTOS," skip
           "inscrita no CNPJ sob n 11.271.860/0001-86," skip
           "doravante designado FINANCEIRA." skip
           "CLIENTE/FINANCIADO - Dados" skip.
       put "Nome: " clien.clinom format "x(40)" skip.
       put "CPF: "  clien.ciccgc format "x(16)" " RG: "
                    clien.ciinsc format "x(11)" skip
           "Orgao Emissor: " skip
           "End.Residencial: " vendereco format "x(25)" "," 
           "n " trim(string(clien.numero[1])) " compl "             trim(string(clien.compl[1],"x(15)")) skip
           "Cidade: " clien.cidade[1] skip
           "CEP: "  trim(string(clien.cep[1],"x(10)"))  " UF: "trim(string(clien.ufecod[1],"x(2)")) skip.                 
       put "Especificacao do Credito " skip.
       put "DT Financ: " string(contrato.dtinicial,"99/99/99") " DT 1Venc:" vdtpri skip
           "Ult.venc:" vdtult "  de Prest:" vparc skip

           "CET Ano: " vret-CETAnual + "%"
           " Tx mes:" string(dec(vret-Taxa),">>9.99") + "%" skip
           
           "Valor da Prestacao: " vprest skip
           "Valor IOF:        " string(dec(vret-ValorIOF),">>>>9.99") skip
           "Valor da Venda:   " vvenda format ">>>>>9.99"  skip
           "Valor Financiado: " contrato.vltotal format ">>>>>9.99" skip
           skip
           "Produto(s) Financiado(s): "  skip.
           
    for each commatriz.movim where movim.etbcod = plani.etbcod and
                         movim.placod = plani.placod and
                         movim.movtdc = plani.movtdc no-lock:
                    
        find commatriz.produ where produ.procod = movim.procod no-lock no-error.

        if avail produ then
          put unformatted produ.pronom skip.

    end. 
       put skip(1).
        put   "Confirmo  que  os  dados  do  CLIENTE/" skip
           "FINANCIADO  foram  verificados  mediante " skip
           "apresentacao  dos  documentos  originais " skip
           "necessarios." skip(2).

           put chr(27) + chr(97) + chr(49) skip.       /* centraliza */

           put fill("-",30) format "x(30)" skip
               "Loja/Correspondente" skip.
               
           put chr(27) + chr(97) + chr(48) skip.    /* justifica esquerda */ 
          
           put "Ao assinar(em)  esta  proposta em uma vez " skip
               "aprovado  o  credito  pela  FINANCEIRA e o" skip
               "CLIENTE/FINANCIADO se declara vinculado as" skip
               "disposicoes  contidas   nas  Clausulas  e " skip
               "Condicoes   Gerais   do   Contrato   de   " skip
               "Financiamento  registrado  no  Registro de" skip
               "Titulos e Documentos de Sao Jeronimo (RS)," skip
               "sob n  14911         para as operacoes que" skip
               "estiverem  assinaladas  no  quadro TIPO DE" skip
               "OPERACAO  a  opcao  CDC. Para as operacoes" skip
               "que estiverem  assinaladas  no quadro TIPO" skip
               "DE  OPERACAO  a  opcao  CREDITO LOJISTA, a" skip
               "LOJA  e  o  CLIENTE/FINANCIADO  declara(m)" skip
               "vinculado(s)  as  disposicoes contidas nas" skip
               "Clausulas  e Condicoes  Gerais do Contrato" skip
               "de Compra  e Venda  com Reserva de Dominio" skip
               "registrado  no  Registro  de  Titulos  e  " skip
               "Documentos  de  Sao  Jeronimo  (RS),  sob " skip
               "n 14910          , as quais declara(m) ter" skip
               "recebido  copia,  concordando com todos os" skip
               "termos  e  condicoes  CLIENTE/FINANCIADO  " skip
               "autoriza, desde ja, a FINANCEIRA a efetuar" skip
               "o credito em conta  corrente indicada pela" skip
               "Loja/Correspondente  do  Valor  Financiado" skip
               "expresso  no   quadro   ESPECIFICACAO   DO" skip
               "CREDITO. O  CLIENTE/FINANCIADO   autoriza:" skip
               "a)  a  FINANCEIRA  a  obter  e   fornecer " skip
               "informacoes  pertinentes  a  operacoes  de" skip
               "credito garantia de suas responsabilidades" skip
               "junto ao Sistema de Informacoes de Credito" skip
               "do Banco Central do Brasil b) a FINANCEIRA" skip
               "a   obter,   fornecer   e     compartilhar" skip
               "informacoes  cadastrais,  financeiras e de" skip
               "operacoes  ativas  e  passivas  e servicos" skip
               "prestados,   junto   a   controladora   da" skip
               "FINANCEIRA,   empresas   e   instituicoes " skip
               "controladas,  coligadas  e  que  tenham  o" skip
               "mesmo   controle   comum,  ficando   todos" skip
               "autorizados  a  examinar  e a utilizar, no" skip
               "Brasil  e  no  exterior,  tais informacoes" skip
               "relacionadas  ao  CLIENTE/FINANCIADO;  c) " skip
               "a   FINANCEIRA   a   efetuar  a  troca  de" skip
               "informacoes  cadastrais,  financeiras e de" skip
               "operacoes  ativas  e  passivas  e serviços" skip
               "prestados   com     outras    instituicoes" skip
               "financeiras.  A   FINANCEIRA  fica  expres" skip
               "samente  autorizada  a  informar  os dados" skip
               "relativos a todas as obrigacoes  assumidas" skip
               "pelo    CLIENTE/FINANCIADO    junto    a  " skip
               "FINANCEIRA, para  constarem  de  cadastros" skip
               "compartilhados pela FINANCEIRA  com outras" skip
               "instituicoes   conveniadas   para   tanto," skip
               "administradas    pela    SERASA   ou   por" skip
               "outras  entidades  de protecao ao credito." skip
               "A  FINANCEIRA  e  tais outras instituicoes" skip
               "ficam    expressamente    autorizadas    a" skip
               "disponibilizar  e  intercambiar  entre  si" skip
               "informacoes  sobre  obrigacoes  contraidas" skip
               "pelo    CLIENTE/FINANCIADO,   o   que   é " skip
               "de  utilidade  aos  seus interesses. ( ) O" skip
               "CLIENTE/FINANCIADO  nao  concorda com esta" skip
               "clausula. O CLIENTE assume, perante a lei," skip
               "inteira responsabilidade  pela  veracidade" skip
               "das  informacoes  prestadas, bem como pela" skip
               "autenticidade dos documentos apresentados." skip
               "No  caso  das  operacoes   que  estiverem " skip
               "assinaladas  no  quadro  TIPO  DE OPERACAO" skip
               "a opcao CREDITO LOJISTA, o CLIENTE declara" skip
               "para  os  devidos  fins,   que  tem  pleno" skip
               "conhecimento  da  abertura  do cadastro no" skip
               "SPC  (Serviço  de  Protecao  ao  Credito)," skip
               "quando  da  eventual  falta  de pagamento," skip
               "apos  30(trinta)  dias  do  vencimento  do" skip
               "debito." skip.
               put "Sao Jeronimo, "  string(day(contrato.dtinicial)) " de " string(entry(month(contrato.dtinicial),vmes)) " de " string(year(contrato.dtinicial)) skip.

               put chr(27) + chr(97) + chr(49) skip.       /* centraliza */
               put fill("-",30) format "x(30)" skip
                   "CLIENTE" skip(3)
                   fill("-",30) format "x(30)" skip
                   "FINANCEIRA" skip(3).
                    
              put chr(27) + chr(97) + chr(48) skip.    /* justifica esquerda */                     
               put "TESTEMUNHAS:" skip(2)
                   fill("-",30) format "x(30)" skip
                   "Nome: " skip
                   "CPF: " skip(3)
                   fill("-",30) format "x(30)" skip
                   "Nome: " skip
                   "CPF: " skip.

    put unformatted chr(29) + "h" + chr(70) /* Set bar code height */. 
    put unformatted chr(29) + "H" + chr(2) skip. /* Select printing position
                                                    of HRI characters */
    put unformatted chr(29) + "w" + chr(2) skip. /* Set bar code width */
    put chr(29) + chr(86) + chr(66) skip .      /* corta */ 
    put chr(27) + chr(64) skip.                /* reseta */

output close.
*/

/*
scarne = "local".
run visurel.p(varquivo,"").
*/

if scarne = "local"
then unix silent /fiscal/lp value(varquivo).
else unix silent /fiscal/lp value(varquivo) 1.

procedure imprime-texto.

def var vPos     as int.
def var vPalavra as char.
def var vPosUlt  as int.
def var vLetra   as char.
def var mTexto   as char extent 70.
def var vLin     as int.
def var vTextoIni   as char.

for each tt-texto no-lock.
    assign
        vtextoini = tt-texto.linha + " "
        vLin      = 1
        vPalavra  = ""
        mTexto    = ""
        vPos      = 1.
    repeat.
        if vPos > Length(vTextoIni)
        then leave.
        vLetra = substr(vTextoIni, vPos, 1).
        vPalavra = vPalavra + vLetra.
        if vLetra = " "
        then do.
            mTexto[vLin] = mTexto[vLin] + vPalavra.
            vPalavra = "".
            vPosUlt = vPos.
        end.
        if length(mTexto[vLin]) + length(vpalavra) > /*=*/ largura
        then do.
            vLin = vLin + 1.
            vPalavra = "".
            vPos = vPosUlt + 1.
        end.
        else
            vPos = vPos + 1.
    end.

    /* Fazer o alinhento "justificado" */
    do vPos = 1 to vLin - 1.
        mTexto[vPos] = trim(mTexto[vPos]).
        /* faz leitura do fim p/o incio da linha*/
        vPosUlt = length(mTexto[vPos]).
        repeat.
            if length(mTexto[vPos]) >= largura
            then leave.
            if substr(mTexto[vPos], vPosUlt, 1) = " " /* acrescenta um espaco */
            then mTexto[vPos] = substr(mTexto[vPos], 1, vPosUlt) +
                                substr(mTexto[vPos], vPosUlt).
            vPosUlt = vPosUlt - 1.
            if vPosUlt = 0
            then vPosUlt = length(mTexto[vPos]).
        end.
    end.
    do vPos = 1 to vLin.
        put unformatted mTexto[vPos] skip.
    end.
end.

end procedure.


