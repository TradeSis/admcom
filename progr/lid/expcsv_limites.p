def var vt as int.
def var vi as int.
def var xtime as int.

def var vcp as char init ";".
def var vvlr_aberto as dec.
def var vfinanceira as log.
def var vdt_primvenc as date.
def var vqtd_parcelas as int.
def var vtpcontrato as char.
def var vcpf as char.


def var vvlrlimite  as dec.
def var vvlrdisponivel as dec.
def var vvctolimite as date.
def var var-comprometidoPrincipal as dec.
def var var-comprometidoTotal     as dec.
def var var-comprometidoNovacao     as dec.
def var var-comprometidoNormal     as dec.
def var var-comprometidoEPPrincipal as dec.
def var var-comprometidoEPTotal     as dec.
def var var-comprometidoEPNovacao     as dec.
def var var-comprometidoEPNormal     as dec.

{../progr/neuro/achahash.i}  /* 03.04.2018 helio */
{../progr/neuro/varcomportamento.i} /* 03.04.2018 helio */



xtime = time.

def stream csvlimite.
output stream csvlimite to ../tmp/lidia_limites2.csv.
put stream csvlimite unformatted skip 
    "TIPO"
vcp "CODIGOCLIENTE"
vcp "CPFCNPJ"
vcp "NOMECLIENTE"
vcp "LIMITE"
vcp "VCTOLIMITE"
vcp "SALDOLIMITE"
vcp "COMPROMETIDO"
vcp "COMPROMETIDOTOTAL"
vcp "COMPROMETIDOPRINCIPAL"
vcp "COMPROMETIDONOVACAO"
vcp "COMPROMETIDONORMAL"
 skip.
 
/*  Todos emitidos a partir de 2016 ou com alguma parcela em aberto  */


for each clien no-lock use-index clien.
    if clien.clicod <= 1 then next.
    if clien.clicod <= 12496603 then next.

    find neuclien where neuclien.clicod = clien.clicod no-lock no-error. 

    vt = vt + 1.    
    if vt mod 100 = 0 or vt = 1
    then do:
        hide message no-pause.
        message "limites" today string(time,"HH:MM:SS") string(time - xtime,"HH:MM:SS") vt vi.
    end.
    vcpf  = ?.
    
        if avail neuclien then vcpf = trim(string(neuclien.cpf,">>>>>>>>>>>>>>>")).
        if vcpf = ?
        then do:
                vcpf = clien.ciccgc.
        end.
        if vcpf = ?
        then vcpf = "".

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
    var-propriedades = "" .


      run ../progr/neuro/limites.p (if avail neuclien then neuclien.cpf else ?, clien.clicod,   output var-propriedades).

      var-comprometidoTotal     = dec(pega_prop("LIMITETOM")).
      var-comprometidoPrincipal = dec(pega_prop("LIMITETOMPR")).
      var-comprometidoNovacao   = dec(pega_prop("LIMITETOMNOV")).
      var-comprometidoNormal    = dec(pega_prop("LIMITETOMNORM")).
      vvlrdisponivel = dec(pega_prop("LIMITEDISP")).

      if vvlrlimite = ? then vvlrlimite = 0.
      if vvlrdisponivel = ? then vvlrdisponivel = 0.  

    if var-comprometidoPrincipal = ? then var-comprometidoPrincipal = 0.
    if var-comprometidoTotal = ? then var-comprometidoTotal = 0.
    if var-comprometidoNovacao = ? then var-comprometidoNovacao = 0.
    if var-comprometidoNormal = ? then var-comprometidoNormal = 0.

    if vvlrdisponivel < 0
    then vvlrdisponivel = 0.

    put stream csvlimite unformatted
            "Global"
        vcp if avail clien then string(clien.clicod) else ""
        vcp vcpf
        vcp if avail clien then clien.clinom else neuclien.nome_pessoa
        vcp trim(string(vvlrLimite,"->>>>>>>>>>>>>>>>>9.99"))
        vcp  if vvctolimite = ? then "" else (string(year(vvctolimite),"9999") + "-" + string(month(vvctolimite),"99")   + "-" + string(day(vvctolimite),"99"))
        vcp trim(string(vvlrdisponivel,"->>>>>>>>>>>>>>>>>9.99"))
        vcp trim(string(var-comprometidoPrincipal,"->>>>>>>>>>>>>>>>>>>9.99"))
        vcp trim(string(var-comprometidoTotal,"->>>>>>>>>>>>>>>>>>9.99"))
        vcp trim(string(var-comprometidoPrincipal,"->>>>>>>>>>>>>>>>>>9.99"))
        vcp trim(string(var-comprometidoNovacao,"->>>>>>>>>>>>>>>>>>9.99"))
        vcp trim(string(var-comprometidoNormal,"->>>>>>>>>>>>>>>>>>9.99"))
        skip.
        


    vvlrlimite = dec(pega_prop("LIMITEEP")).
    vvlrdisponivel = dec(pega_prop("LIMITEDISPEP")).

        var-comprometidoEPTotal     = dec(pega_prop("LIMITETOMEP")).
        var-comprometidoEPPrincipal = dec(pega_prop("LIMITETOMPREP")).
        var-comprometidoEPNovacao   = dec(pega_prop("LIMITETOMEPNOV")).
        var-comprometidoEPNormal    = dec(pega_prop("LIMITETOMEPNORM")).

      if vvlrlimite = ? then vvlrlimite = 0.
      if vvlrdisponivel = ? then vvlrdisponivel = 0.  
      if var-comprometidoEPPrincipal = ? then var-comprometidoEPPrincipal = 0.
      if var-comprometidoEPTotal = ? then var-comprometidoEPTotal = 0.
      if var-comprometidoEPNovacao = ? then var-comprometidoEPNovacao = 0.
      if var-comprometidoEPNormal = ? then var-comprometidoEPNormal = 0.


      if vvlrdisponivel < 0
      then vvlrdisponivel = 0.

    put stream csvlimite unformatted
            "EP"
        vcp if avail clien then string(clien.clicod) else ""
        vcp vcpf
        vcp if avail clien then clien.clinom else neuclien.nome_pessoa
        vcp trim(string(vvlrLimite,"->>>>>>>>>>>>>>>>>9.99"))
        vcp  if vvctolimite = ? then "" else (string(year(vvctolimite),"9999") + "-" + string(month(vvctolimite),"99")   + "-" + string(day(vvctolimite),"99"))
        vcp trim(string(vvlrdisponivel,"->>>>>>>>>>>>>>>>>9.99"))
        vcp trim(string(var-comprometidoEPPrincipal,"->>>>>>>>>>>>>>>>>>>9.99"))
        vcp trim(string(var-comprometidoEPTotal,"->>>>>>>>>>>>>>>>>>9.99"))
        vcp trim(string(var-comprometidoEPPrincipal,"->>>>>>>>>>>>>>>>>>9.99"))
        vcp trim(string(var-comprometidoEPNovacao,"->>>>>>>>>>>>>>>>>>9.99"))
        vcp trim(string(var-comprometidoEPNormal,"->>>>>>>>>>>>>>>>>>9.99"))
        skip.


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

    vvlrdisponivel = dec(pega_prop("LIMITEDISP")).

      if vvlrlimite = ? then vvlrlimite = 0.
      if vvlrdisponivel = ? then vvlrdisponivel = 0.  

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


    put stream csvlimite unformatted
            "CDC"
        vcp if avail clien then string(clien.clicod) else ""
        vcp vcpf
        vcp if avail clien then clien.clinom else neuclien.nome_pessoa
        vcp trim(string(vvlrLimite,"->>>>>>>>>>>>>>>>>9.99"))
        vcp  if vvctolimite = ? then "" else (string(year(vvctolimite),"9999") + "-" + string(month(vvctolimite),"99")   + "-" + string(day(vvctolimite),"99"))
        vcp trim(string(vvlrdisponivel,"->>>>>>>>>>>>>>>>>9.99"))
        vcp trim(string(var-comprometidoPrincipal,"->>>>>>>>>>>>>>>>>>>9.99"))
        vcp trim(string(var-comprometidoTotal,"->>>>>>>>>>>>>>>>>>9.99"))
        vcp trim(string(var-comprometidoPrincipal,"->>>>>>>>>>>>>>>>>>9.99"))
        vcp trim(string(var-comprometidoNovacao,"->>>>>>>>>>>>>>>>>>9.99"))
        vcp trim(string(var-comprometidoNormal,"->>>>>>>>>>>>>>>>>>9.99"))
        skip.
        

end.            


