
def var vtotboleto  as dec.

{/admcom/barramento/functions.i}

{../verus/rest-cli/wc-emiteboletocrediario.i new}


for each banmassacli where banmassacli.dtenvio = ? and
                           banmassacli.clicod  <> ?:

    
    for each ttparcelas. delete ttparcelas. end.
    for each ttboletoentrada. delete ttboletoentrada. end.

    find first banmassatit of banmassacli no-lock no-error.
    if not avail banmassatit then next.
    find neuclien where neuclien.clicod = banmassacli.clicod no-lock.

    for each banmassatit of banmassacli no-lock. 
        find titulo where recid(titulo) = banmassatit.titulo-recid no-lock.
        create ttparcelas.
        ttparcelas.cpfCliente       = string(neuclien.cpf).
        ttparcelas.numeroContrato   = titulo.titnum.
        ttparcelas.seqParcela       = string(titulo.titpar).
        ttparcelas.vctoParcela      = enviadata(titulo.titdtven).
        ttparcelas.valorParcela     = trim(string(titulo.titvlcob,">>>>>>>>>9.99")). 
        ttparcelas.valorEncargo     = "0.00".
        ttparcelas.valorDesconto    = "0.00".
        ttparcelas.valorPago        = ttparcelas.valorParcela.    
        vtotboleto = vtotboleto     + titulo.titvlcob.       
        disp ttparcelas.
    end.
    

    create ttboletoentrada.
    ttboletoentrada.cpfCliente              = string(neuclien.cpf).
    ttboletoentrada.dataVencimentoBoleto    = EnviaData(banmassacli.dtvenc).
    ttboletoentrada.valorTotalBoleto        = string(vtotboleto).
    ttboletoentrada.taxaEmissaoBoleto       = "0.00".    

    disp ttboletoentrada.
    
    run ../verus/rest-cli/wc-emiteboletocrediario.p .

    find first ttstatusretorno no-error.
    if avail ttstatusretorno
    then do:
        if int(ttstatusretorno.rstatus) <> 200
        then do:
            banmassacli.observacao = ttstatusretorno.statusmsg.
        end.
    end.        
    find first ttboleto no-error.
    
    if avail ttboleto
    then do:
        disp ttboleto.
        
        banmassacli.nossonumero = int(substring(ttboleto.nossonumero,1,length(ttboleto.nossonumero) - 1)).
        banmassacli.dtenvio     = today.
        
        find first banboleto where banboleto.bancod = 86 and
                    banboleto.nossonumero = banmassacli.nossonumero
                     no-lock no-error.
        if avail banboleto
        then banmassacli.banboleto-recid = recid(banboleto).                
                

    end.
end.
