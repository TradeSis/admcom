{wsnotamax.i new}  

/* #1 - 16.10.2017 - Horario de verao */


def output parameter vstatus as char.
def output parameter vmensagem_erro as char.
def input parameter rec-mdfe as recid.


/* #1 */
FUNCTION fusohr returns character.
    return SUBSTRING(  STRING(DATETIME-TZ(DATE(STRING(DAY(today),"99") + "/" +
        STRING(MONTH(today),"99") + "/" + STRING(YEAR(today),"9999")), MTIME,
        TIMEZONE)),  24,6).
END FUNCTION.



def var vi as int.
def var vl as int.
def var vcpl as char.
def var lcpl as char.
def var xtpTransp as char init "1,2,3".
def var xfretpcod as char init "ETC,TAC,CTC".
def var vtptransp as char.

def var vcont as int.
def var qnfe as int.

find mdfe where recid(mdfe) = rec-mdfe no-lock.

hide message no-pause. 
message "Solicitando Autorizacao " mdfe.mdfechave.

def buffer bestab for estab.
def var ibge-cidcod as int.

def temp-table tt-carrega-uf no-undo
    field ufemi    like munic.ufecod.

def temp-table tt-carrega-MuniC no-undo
    field ufemi    like munic.ufecod
    field cidemi    like munic.cidcod
    field municemi  like munic.cidnom.


def temp-table tt-descarrega-MuniC no-undo
    field ufdes    like munic.ufecod
    field ciddes    like munic.cidcod
    field municdes  like munic.cidnom.


def temp-table tt-descarrega-nfe no-undo
    field rectt as recid
    field recmdfnfe as recid.


/**
    field ufdes    like munic.ufecod
    field ciddes    like munic.cidcod
    field municdes  like munic.cidnom
    index x rotaseq desc.
**/


def var mdfe_versao as char.
def var mdfe_modelo as char.
def var vemite_cnpj as char.
def var mdfe_dhemi as char.
def var mdfe_dhviag as char.



find mdfviagem of mdfe no-lock.
find frete of mdfviagem no-lock.
find forne of frete no-lock.
find tpfrete of frete no-lock.
find veiculo of mdfviagem no-lock.
find estab of mdfviagem no-lock.


    run rota-carrega.
    run rota-descarrega.

    find first munic where munic.ufecod = estab.ufecod and
                           munic.cidnom = estab.munic
                no-lock no-error  .
    if avail munic 
    then do: 
        ibge-cidcod = munic.cidcod. 
    end.                

    vemite_cnpj = estab.etbcgc.
    vemite_cnpj = replace(vemite_cnpj,".","").
    vemite_cnpj = replace(vemite_cnpj,"/","").
    vemite_cnpj = replace(vemite_cnpj,"-","").


    mdfe_dhemi = string(year(mdfe.mdfedtemissao),"9999") + "-" +
                 string(month(mdfe.mdfedtemissao),"99")  + "-" +
                 string(day(mdfe.mdfedtemissao),"99")    + "T" +
                 substr(
                     string(mdfe.mdfehremissao,"HH:MM:SS"),1,2) + ":" +
                 substr(
                     string(mdfe.mdfehremissao,"HH:MM:SS"),4,2) + ":" +
                 substr(
                     string(mdfe.mdfehremissao,"HH:MM:SS"),7,2) + fusohr(). /* #1 */

    mdfe_dhviag = string(year(mdfviagem.dtviagem),"9999") + "-" +
                 string(month(mdfviagem.dtviagem),"99")  + "-" +
                 string(day(mdfviagem.dtviagem),"99")    + "T" +
                 substr(
                     string(mdfviagem.hrviagem,"HH:MM:SS"),1,2) + ":" +
                 substr(
                     string(mdfviagem.hrviagem,"HH:MM:SS"),4,2) + ":" +
                 substr(
                     string(mdfviagem.hrviagem,"HH:MM:SS"),7,2) + fusohr(). /* #1 */


vmetodo = "MDFeEmissaoSolicitarAutorizacao".
vLOG    = "MDFe_" + string(mdfe.mdfenumero, "999999999").


vxml = vxml + geraXmlNfe("Inicio", "envNotamax", "").

vxml = vxml + geraXmlNfe("GrupoFIM", "parametros", "").
vxml = vxml + geraXmlNfe("GrupoFIM", "envNotamax", "").

vxml = vxml + geraXmlNfe("Inicio", "xml_mdfe", "").

vxml = vxml + geraXmlNfe("GrupoINI",  "xml_mdfe", "").

vxml = vxml + geraXmlNfe("GrupoINI", "enviMDFe", 
                            " versao=\"3.00\" " +
                            " xmlns=\"http://www.portalfiscal.inf.br/mdfe\" " ).

    vxml = vxml + geraXmlNfe("Tag", "idLote", string(mdfe.mdfenumero)).
    vxml = vxml + geraXmlNfe("GrupoINI", "MDFe", 
                            " xmlns=\"http://www.portalfiscal.inf.br/mdfe\" " ).

    vxml = vxml + geraXmlNfe("GrupoINI", "infMDFe", 
                            " versao=\"3.00\" " +
                            " Id=\"" +  "MDFe" + mdfe.mdfechave + "\" ").


    vxml = vxml + geraXmlNfe("GrupoINI", "ide", "").
        vxml = vxml + geraXmlNfe("Tag", "cUF", mdfe.ibge-ufemi).
        vxml = vxml + geraXmlNfe("Tag", "tpAmb", "2").
        vxml = vxml + geraXmlNfe("Tag", "tpEmit", "2").   
                                /*string(tpfrete.fretpemit)).*/
        
        /** retirado 27.04
        if tpfrete.fretpemit = 1
        then do:
            vtptransp = entry(lookup(xfretpcod,xfretpcod),xtptransp) no-error.
            if vtptransp = "0" or vtptransp = ?
            then vtptransp = "1".
            vxml = vxml + geraXmlNfe("Tag", "tpTransp", vtptransp).
        end.
        **/
        
        vxml = vxml + geraXmlNfe("Tag", "mod", "58").
        vxml = vxml + geraXmlNfe("Tag", "serie", string(int(mdfe.mdfeserie))).
        vxml = vxml + geraXmlNfe("Tag", "nMDF", string(int(mdfe.mdfenumero))).
        vxml = vxml + geraXmlNfe("Tag", "cMDF", 
                    string(mdfe.mdfecod,"99999999") ).
        vxml = vxml + geraXmlNfe("Tag", "cDV",  string(mdfe.mdfedv,"9")).
        vxml = vxml + geraXmlNfe("Tag", "modal", "1"). /* RODO */
        vxml = vxml + geraXmlNfe("Tag", "dhEmi", mdfe_dhemi).
        vxml = vxml + geraXmlNfe("Tag", "tpEmis", string(mdfe.mdfeformaemi)).
        vxml = vxml + geraXmlNfe("Tag", "procEmi", "0").
        vxml = vxml + geraXmlNfe("Tag", "verProc", "1"). 
        vxml = vxml + geraXmlNfe("Tag", "UFIni", mdfe.ufemi).
        vxml = vxml + geraXmlNfe("Tag", "UFFim", mdfe.ufdes).
    
        vxml = vxml + geraXmlNfe("GrupoINI", "infMunCarrega", "").
            for each tt-carrega-munic.
                vxml = vxml + geraXmlNfe("Tag", "cMunCarrega", 
                        string(tt-carrega-munic.cidemi)).
                vxml = vxml + geraXmlNfe("Tag", "xMunCarrega", 
                        string(tt-carrega-munic.municemi)).
            end.
        vxml = vxml + geraXmlNfe("GrupoFIM", "infMunCarrega", "").
    
        /**
        vxml = vxml + geraXmlNfe("GrupoINI", "infPercurso", "").
            for each tt-carrega-uf.
                vxml = vxml + geraXmlNfe("Tag", "UFPer", 
                    tt-carrega-uf.ufemi).
            end.
        vxml = vxml + geraXmlNfe("GrupoFIM", "infPercurso", "").
        **/
        
        vxml = vxml + geraXmlNfe("Tag", "dhIniViagem", mdfe_dhviag).
    
    vxml = vxml + geraXmlNfe("GrupoFIM", "ide", "").


    vxml = vxml + geraXmlNfe("GrupoINI", "emit", "").
        vxml = vxml + geraXmlNfe("Tag", "CNPJ", vemite_cnpj).
        vxml = vxml + geraXmlNfe("Tag", "IE", 
                replace(estab.etbinsc,"/","")).
        vxml = vxml + geraXmlNfe("Tag", "xNome", estab.etbnom).
/**        vxml = vxml + geraXmlNfe("Tag", "xFant", estab.etbnom).**/
        
        vxml = vxml + geraXmlNfe("GrupoINI", "enderEmit", "").
            vxml = vxml + geraXmlNfe("Tag", "xLgr", entry(1,estab.endereco) ).
            vxml = vxml + geraXmlNfe("Tag", "nro",  
                trim(entry(2,estab.endereco))).
/**            vxml = vxml + geraXmlNfe("Tag", "xCpl", "").**/
            vxml = vxml + geraXmlNfe("Tag", "xBairro", estab.munic).
            vxml = vxml + geraXmlNfe("Tag", "cMun", string(ibge-cidcod)).
            vxml = vxml + geraXmlNfe("Tag", "xMun", estab.munic).
/**            vxml = vxml + geraXmlNfe("Tag", "CEP", estab.cep).**/
            vxml = vxml + geraXmlNfe("Tag", "UF", estab.uf).
/**            vxml = vxml + geraXmlNfe("Tag", "fone", "").
            vxml = vxml + geraXmlNfe("Tag", "email", "").**/
        vxml = vxml + geraXmlNfe("GrupoFIM", "enderEmit", "").

    vxml = vxml + geraXmlNfe("GrupoFIM", "emit", "").

    /** INFO MODAL **/
    vxml = vxml + geraXmlNfe("GrupoINI", "infModal", 
                             " versaoModal=\"3.00\" ").

     /** DOCUMENTO XML RODO **/
   vxml = vxml + geraXmlNfe("GrupoINI", "rodo", 
                            " xmlns=\"http://www.portalfiscal.inf.br/mdfe\" " ).

    /**     
     vxml = vxml + geraXmlNfe("GrupoINI", "infANTT", "").

        vxml = vxml + 
                geraXmlNfe("Tag", "RNTRC", string(frete.rntrc,"99999999")).
      
        vxml = vxml + geraXmlNfe("GrupoINI", "infCIOT", "").
                
            vxml = vxml + geraXmlNfe("Tag", "CIOT", mdfviagem.ciot).
            vxml = vxml + geraXmlNfe("Tag", "CPF", mdfviagem.ciotCPF).
            vxml = vxml + geraXmlNfe("Tag", "CNPJ", mdfviagem.ciotCNPJ).

        vxml = vxml + geraXmlNfe("GrupoFIM", "infCIOT", "").


     vxml = vxml + geraXmlNfe("GrupoFIM", "infANTT", "").
    **/ 
     
     vxml = vxml + geraXmlNfe("GrupoINI", "veicTracao", "").
     
        vxml = vxml + geraXmlNfe("Tag", "cInt", caps(mdfviagem.placa)).
        vxml = vxml + geraXmlNfe("Tag", "placa", caps(veiculo.placa)).
        /**
        vxml = vxml + geraXmlNfe("Tag", "RENAVAM", 
            string(int(veiculo.renavam),"999999999")).
        **/    
        vxml = vxml + geraXmlNfe("Tag", "tara", string(veiculo.tara)).
        vxml = vxml + geraXmlNfe("Tag", "capKG", string(veiculo.capac_kg)).
        vxml = vxml + geraXmlNfe("Tag", "capM3", string(veiculo.capac_m3)).

        /**
        vxml = vxml + geraXmlNfe("GrupoINI", "prop", "").
        vxml = vxml + geraXmlNfe("GrupoFIM", "prop", "").
        **/
        
        do vcont = 1 to 10.
            if mdfviagem.motoristacpf[vcont] = "" then next.
           vxml = vxml + geraXmlNfe("GrupoINI", "condutor", "").
                vxml = vxml + geraXmlNfe("Tag", "xNome", 
                        mdfviagem.motoristanome[vcont]).
                vxml = vxml + geraXmlNfe("Tag", "CPF", 
                            mdfviagem.motoristacpf[vcont]).
            vxml = vxml + geraXmlNfe("GrupoFIM", "condutor", "").
        end.
        
        vxml = vxml + geraXmlNfe("Tag", "tpRod", string(veiculo.tprodado,"99")).
        vxml = vxml + geraXmlNfe("Tag", "tpCar", 
                string(veiculo.tpcarroceria,"99")).
        vxml = vxml + geraXmlNfe("Tag", "UF", caps(veiculo.ufplaca)).

     vxml = vxml + geraXmlNfe("GrupoFIM", "veicTracao", "").
     

   vxml = vxml + geraXmlNfe("GrupoFIM", "rodo", "").

    vxml = vxml + geraXmlNfe("GrupoFIM", "infModal", "").
    /*** FIM INFO MODAL **/
    
    vxml = vxml + geraXmlNfe("GrupoINI", "infDoc", "").
    
        vxml = vxml + geraXmlNfe("GrupoINI", "infMunDescarga", "").
        
        qnfe = 0.    
            
            for each tt-descarrega-munic.
            
                vxml = vxml + geraXmlNfe("Tag", "cMunDescarga", 
                        string(tt-descarrega-munic.ciddes)).
                vxml = vxml + geraXmlNfe("Tag", "xMunDescarga", 
                        string(tt-descarrega-munic.municdes)).
 
        
        /**
        vxml = vxml + geraXmlNfe("GrupoINI", "infCTe", "").
        vxml = vxml + geraXmlNfe("GrupoFIM", "infCTe", "").
        **/
                 for each tt-descarrega-nfe where 
                tt-descarrega-nfe.rectt = recid(tt-descarrega-munic).
                         
            find mdfnfe where recid(mdfnfe) = tt-descarrega-nfe.recmdfnfe
                            no-lock.
         vxml = vxml + geraXmlNfe("GrupoINI", "infNFe", "").
          
            vxml = vxml + geraXmlNfe("Tag", "chNFe",  mdfnfe.nfeID).
            qnfe = qnfe + 1.
            
            vxml = vxml + geraXmlNfe("GrupoINI", "infUnidTransp", "").
                vxml = vxml + geraXmlNfe("Tag", "tpUnidTransp", "1").
                vxml = vxml + geraXmlNfe("Tag", "idUnidTransp", 
                                                    caps(mdfviagem.placa)).
            vxml = vxml + geraXmlNfe("GrupoFIM", "infUnidTransp", "").
           vxml = vxml + geraXmlNfe("GrupoFIM", "infNFe", "").
          end.
            
        end.            
        vxml = vxml + geraXmlNfe("GrupoFIM", "infMunDescarga", "").

     
    vxml = vxml + geraXmlNfe("GrupoFIM", "infDoc", "").

    /** Informacoes Seguro **/
  
    if tpfrete.fretpemit = 1 and
       mdfviagem.seguradora <> "" and
       mdfviagem.segcnpj <> ""
    then do:
      vxml = vxml + geraXmlNfe("GrupoINI", "seg", "").
        vxml = vxml + geraXmlNfe("GrupoINI", "infResp", "").
            vxml = vxml + geraXmlNfe("Tag", "respSeg", if mdfviagem.SegResp
                                                       then "1"
                                                       else "2").

            if mdfviagem.segresp = no
            then do:
                vxml = vxml + geraXmlNfe("Tag", "CNPJ", 
                        if length(mdfviagem.SegRespCNPJCPF) > 11
                        then mdfviagem.SegRespCNPJCPF
                        else "").
                vxml = vxml + geraXmlNfe("Tag", "CPF", 
                        if length(mdfviagem.SegRespCNPJCPF) > 11
                        then ""
                        else mdfviagem.SegRespCNPJCPF).
            end.            
        vxml = vxml + geraXmlNfe("GrupoFIM", "infResp", "").

        vxml = vxml + geraXmlNfe("GrupoINI", "infSeg", "").
            vxml = vxml + geraXmlNfe("Tag", "xSeg", mdfviagem.seguradora).
            vxml = vxml + geraXmlNfe("Tag", "CNPJ", mdfviagem.segcnpj).
        vxml = vxml + geraXmlNfe("GrupoFIM", "infSeg", "").

        vxml = vxml + geraXmlNfe("Tag", "nApol", mdfviagem.segnApol).
        vxml = vxml + geraXmlNfe("Tag", "nAver", mdfviagem.segnAver).
    
      vxml = vxml + geraXmlNfe("GrupoFIM", "seg", "").
    end.                                                                  
    vxml = vxml + geraXmlNfe("GrupoINI", "tot", "").

            vxml = vxml + geraXmlNfe("Tag", "qNFe", string(qnfe)).
    
            vxml = vxml + geraXmlNfe("Tag", "vCarga", "100.00").
            vxml = vxml + geraXmlNfe("Tag", "cUnid", "01").
            vxml = vxml + geraXmlNfe("Tag", "qCarga", "100.0000").

    vxml = vxml + geraXmlNfe("GrupoFIM", "tot", "").
                                                                    
    vxml = vxml + geraXmlNfe("GrupoINI", "infAdic", "").
    lcpl = "".
    for each mdfnfe of mdfe no-lock.
        lcpl = lcpl + 
                    if lcpl = ""
                    then string(mdfnfe.numero,"99999999") 
                    else " - " + string(mdfnfe.numero,"99999999").        
    end.
    
        vxml = vxml + geraXmlNfe("Tag", "infCpl", lcpl).

   vxml = vxml + geraXmlNfe("GrupoFIM", "infAdic", "").
 
   

    vxml = vxml + geraXmlNfe("GrupoFIM", "infMDFe", "").


    vxml = vxml + geraXmlNfe("GrupoFIM",  "MDFe", "").


vxml = vxml + geraXmlNfe("GrupoFIM", "enviMDFe", "").

vxml = vxml + geraXmlNfe("GrupoFIM", "xml_mdfe", "").

run wsnotamax.p (  input "", /* Site em branco para padrao */   
                   input vmetodo, 
                   input vxml,
                   input vlog). /* GRAVA LOG */

find first tt-xmlretorno where
    tt-xmlretorno.tag = "status"
    no-error.
vstatus = if avail tt-xmlretorno
          then tt-xmlretorno.valor
          else "". 

find first tt-xmlretorno where
    tt-xmlretorno.tag = "mensagem_erro"
    no-error.
vmensagem_erro = if avail tt-xmlretorno
               then tt-xmlretorno.valor
               else "". 
if vmensagem_erro <> ""
then do:
    hide message no-pause.
    message 
    "Retorno Status:" vstatus " Mensagem: " vmensagem_erro
    view-as alert-box.
end.    





procedure rota-carrega.

def var vufemi as char.
def var vufdes as char.
def var vmunicemi as char.
def var vcidemi   like munic.cidcod.


for each mdfnfe of mdfe no-lock
    by mdfnfe.rotaseq.
    vufemi = "**". vmunicemi = "**". vcidemi = 0.
 
    if mdfnfe.tabemite = "ESTAB" or 
       mdfnfe.tabemite = ""
    then do:
        find bestab where bestab.etbcod = mdfnfe.emite no-lock no-error.
        if avail bestab 
        then do:
            find first munic where munic.ufecod = bestab.ufecod and
                             munic.cidnom = bestab.munic
                no-lock no-error  .
            if avail munic
            then do:
                vmunicemi = munic.cidnom.
                vcidemi   = munic.cidcod.
            end.                
            vufemi = bestab.ufecod.
            
        end.    
    end.
    if mdfnfe.tabemite = "FORNE"
    then do:
        find forne where forne.forcod = mdfnfe.emite no-lock no-error.
        if avail forne 
        then do:
            find first munic where munic.ufecod = forne.ufecod and
                             munic.cidnom = forne.formunic
                no-lock no-error  .
            if avail munic
            then do:
                vmunicemi = munic.cidnom.
                vcidemi   = munic.cidcod. 
            end.                
            vufemi = forne.ufecod.
        end. 
    end.        
                        
    find first tt-carrega-munic where
        tt-carrega-munic.ufemi       = vufemi and
        tt-carrega-munic.municemi    = vmunicemi and
        tt-carrega-munic.cidemi      = vcidemi
        no-error.
    if not avail tt-carrega-munic    
    then do:
        create tt-carrega-munic.
        tt-carrega-munic.ufemi       = vufemi.
        tt-carrega-munic.municemi    = vmunicemi.
        tt-carrega-munic.cidemi      = vcidemi.
    end.

                                                 
    find first tt-carrega-uf where
        tt-carrega-uf.ufemi       = vufemi 
        no-error.
    if not avail tt-carrega-uf    
    then do:
        create tt-carrega-uf.
        tt-carrega-uf.ufemi       = vufemi.
    end.
 
            
end.

end procedure. 


procedure rota-descarrega.

def var vufdes as char.
def var vmunicdes as char.
def var vciddes   like munic.cidcod.


for each mdfnfe of mdfe no-lock
    by mdfnfe.rotaseq.
    vufdes = "**". vmunicdes = "**". vciddes = 0.
 
    if mdfnfe.tabdesti = "ESTAB" or 
       mdfnfe.tabdesti = ""
    then do:
        find bestab where bestab.etbcod = mdfnfe.desti no-lock no-error.
        if avail bestab 
        then do:
            find first munic where munic.ufecod = bestab.ufecod and
                             munic.cidnom = bestab.munic
                no-lock no-error  .
            if avail munic
            then do:
                vmunicdes = munic.cidnom.
                vciddes   = munic.cidcod.
            end.                
            vufdes = bestab.ufecod.
            
        end.    
    end.
    if mdfnfe.tabdesti = "FORNE"
    then do:
        find forne where forne.forcod = mdfnfe.desti no-lock no-error.
        if avail forne 
        then do:
            find first munic where munic.ufecod = forne.ufecod and
                             munic.cidnom = forne.formunic
                no-lock no-error  .
            if avail munic
            then do:
                vmunicdes = munic.cidnom.
                vciddes   = munic.cidcod. 
            end.                
            vufdes = forne.ufecod.
        end. 
    end.        
                        
    find first tt-descarrega-munic where
        tt-descarrega-munic.ufdes       = vufdes and
        tt-descarrega-munic.municdes    = vmunicdes and
        tt-descarrega-munic.ciddes      = vciddes
        no-error.
    if not avail tt-descarrega-munic    
    then do:
        create tt-descarrega-munic.
        tt-descarrega-munic.ufdes       = vufdes.
        tt-descarrega-munic.municdes    = vmunicdes.
        tt-descarrega-munic.ciddes      = vciddes.
    end.

                                                 
        create tt-descarrega-nfe.
        tt-descarrega-nfe.rectt       = recid(tt-descarrega-munic).
        tt-descarrega-nfe.recmdfnfe         = recid(mdfnfe).
 
            
end.

end procedure. 

