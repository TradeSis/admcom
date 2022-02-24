def input param pstatus     like sicred_contrato.sstatus.

{admbatch.i}
{acha.i}
def var vtitvlcob as dec.
def var vvlracrescimo as dec.
  def var vplano-fin like contrato.crecod.
  def var vcod-produto  as integer.

def var vservicos as dec.
def var vvlf_principal as dec.
def var vtpcontrato     like contrato.tpcontrato.
def buffer btitulo for titulo.

     def buffer blotefin for lotefin.
def temp-table ttcob no-undo
    field cobcod as int
    index idx is unique primary cobcod asc.

pause 0 before-hide.

        for each sicred_contrato where
            sicred_contrato.sstatus  = "ERRO":
            
            sicred_contrato.sstatus  = pstatus.
            sicred_contrato.descerro = "".
            
        end.

        find first sicred_param where (sicred_param.dtfim = ? or sicred_param.dtfim > today) and 
                                      sicred_param.dtini <= today
                                      no-lock no-error.
        if not avail sicred_param                                      
        then do:
            for each sicred_contrato where
                sicred_contrato.sstatus  = pstatus:

                sicred_contrato.descerro = "Sem tabela de Parametros vigente".
                hide message no-pause.
                message today sicred_contrato.descerro. 
                sicred_contrato.sstatus  = "ERRO".
            end.    
        end.

        for each sicred_contrato where
            sicred_contrato.sstatus  = pstatus:


            find contrato where contrato.contnum = sicred_contr.contnum no-lock no-error. 
            if not avail contrato 
            then do:
                sicred_contrato.descerro = "Contrato nao encontrado".
                hide message no-pause.
                message today sicred_contrato.sstatus sicred_contrato.operacao sicred_contr.contnum sicred_contrato.descerro. 
                sicred_contrato.sstatus  = "ERRO".
                next.
            end.  

            find clien of contrato no-lock no-error.
            if not avail clien 
            then do:
                sicred_contrato.descerro = "Cliente nao encontrado".
                hide message no-pause.
                message today sicred_contrato.sstatus sicred_contrato.operacao sicred_contr.contnum sicred_contrato.descerro. 
                
                sicred_contrato.sstatus  = "ERRO".
                next.
            end.  
            
            /*Data nascimento */
            if clien.dtnasc = ? or clien.dtnasc < today - (100 * 365)
            then  do:
                sicred_contrato.descerro = "Problema na Data de Nascimento do Cliente ".
                hide message no-pause.
                                message today sicred_contrato.sstatus sicred_contrato.operacao sicred_contr.contnum sicred_contrato.descerro. 

                sicred_contrato.sstatus  = "ERRO".
                next.
            end.
                
            /*data admissão  */
            if clien.proemp[1] <> ? and clien.proemp[1]  <> ""
            then 
            if 
                clien.prodta[1] = ? or clien.prodta[1] < today - (100 * 365)
            then  do:
                sicred_contrato.descerro = "Problema na Data de Admissao do Cliente ".
                hide message no-pause.
                message today sicred_contrato.sstatus sicred_contrato.operacao sicred_contr.contnum sicred_contrato.descerro. 
                
                sicred_contrato.sstatus  = "ERRO".
                next.
            end.
            
            /*Data nascimento */
            if clien.conjuge <> ? and clien.conjuge <> ""  and (clien.estciv = 2 or clien.estciv = 6) and clien.tippes
            then
            if  (clien.nascon = ? or clien.nascon < today - (100 * 365))
            then  do:
                sicred_contrato.descerro = "Problema na Data de Nascimento do Conjuje do Cliente ".
                hide message no-pause.
                message today sicred_contrato.sstatus sicred_contrato.operacao sicred_contr.contnum sicred_contrato.descerro. 
                
                sicred_contrato.sstatus  = "ERRO".
                next.
            end.
                        
            /**{1}.dias_retroativo     = - dias máximo retroativos para operação.**/
            if contrato.dtinicial < today - sicred_param.dias_retroativo
            then do:
                sicred_contrato.descerro = "Dias retroativos para operacao nao permitido".
                hide message no-pause.
                message today sicred_contrato.sstatus sicred_contrato.operacao sicred_contr.contnum sicred_contrato.descerro. 
                
                sicred_contrato.sstatus  = "ERRO".
                next.
            
            end.
            
            /*    {1}.tfc_minimo          - Intervalor de valor permitido para TFC
                  {1}.tfc_maximo    */
            if contrato.vltaxa >= sicred_param.tfc_minimo and
               contrato.vltaxa <= sicred_param.tfc_maximo
            then.   
            else do:
                sicred_contrato.descerro = "Intervalo Min/max do Valor TFC nao permitido".
                hide message no-pause.
                message today sicred_contrato.sstatus sicred_contrato.operacao sicred_contr.contnum sicred_contrato.descerro. 
                            
                sicred_contrato.sstatus  = "ERRO".
                next.
            end.
            
            vtitvlcob = 0.    
            for each titulo where
                    titulo.empcod     = 19 and
                    titulo.titnat     = no and
                    titulo.modcod     = contrato.modcod and
                    titulo.etbcod     = contrato.etbcod and
                    titulo.clifor     = contrato.clicod and
                    titulo.titnum     = string(contrato.contnum) and 
                    titulo.titdtemi   = contrato.dtinicial
                    no-lock.
                if titulo.titvltot > 0
                then   vtitvlcob = vtitvlcob + titulo.titvltot.
                else   vtitvlcob = vtitvlcob + titulo.titvlcob.

            end.                    

            /* 17.06 le a nota para pegar o valor dos servicos */
                vservicos = 0.
                find contnf where 
                        contnf.etbcod = contrato.etbcod and
                        contnf.contnum = contrato.contnum no-lock no-error.
                if avail contnf
                then do:
                    find plani where plani.etbcod = contnf.etbcod and
                                     plani.placod = contnf.placod
                                     no-lock no-error.
                    if avail plani
                    then do:

                        if contrato.modcod = "CP0" or contrato.modcod = "CP1"
                        then vvlf_principal = plani.protot + plani.vlserv.
                        vservicos = plani.vlserv. 
                        if contrato.modcod = "CP0" or 
                           contrato.modcod = "CP1" 
                        then do:
                            vservicos = if plani.seguro = ?
                                        then 0
                                        else plani.seguro. 
                        end.


                    end.
                end.            
    
                if contrato.modcod = "CP0" or
                   contrato.modcod = "CP1"
                then.
                else    
                vvlf_principal = if contrato.vlf_principal = 0
                                 then contrato.vltotal - contrato.vlentra - contrato.vliof
                                 else if sicred_contrato.operacao = "NOVACAO"
                                      then contrato.vlf_principal - contrato.vlentra
                                      else contrato.vlf_principal.
                 
                if vvlf_principal < vservicos
                then do:
                    vvlf_principal = vservicos.
                    vservicos = 0.
                end.

            vvlracrescimo =  contrato.vlf_acrescimo.
                /*                        vtitvlcob - vvlf_principal - vservicos.*/
            
            if vvlracrescimo >= sicred_param.valor_min_acrescimo
            then.   
            else do:
                if vvlracrescimo <= 0
                then do:
                    if vvlracrescimo = 0
                    then   sicred_contrato.descerro = "Valor Minimo de acrescimo esta ZERO ".
                    else   sicred_contrato.descerro = "Valor Minimo de acrescimo esta negativo ".
                    
                end.
                else do:
                    sicred_contrato.descerro = "Valor Minimo de acrescimo permitido é " + string(sicred_param.valor_min_acrescimo,">>>>>>>9.99").
                end.    
                hide message no-pause.
                message today sicred_contrato.sstatus sicred_contrato.operacao sicred_contr.contnum sicred_contrato.descerro. 
                            
                sicred_contrato.sstatus  = "ERRO".
                next.
            end.
            
            
            find titulo where titulo.contnum = contrato.contnum and
                    titulo.titpar  = 1
                      no-lock no-error.

                if not avail titulo
                then do:
                    find first titulo where
                    titulo.empcod     = 19 and
                    titulo.titnat     = no and
                    titulo.modcod     = contrato.modcod and
                    titulo.etbcod     = contrato.etbcod and
                    titulo.clifor     = contrato.clicod and
                    titulo.titnum     = string(contrato.contnum) and 
                    titulo.titpar     = 1 and
                    titulo.titdtemi   = contrato.dtinicial
                    no-lock no-error.
                    if not avail titulo
                    then do:
                        for each titulo where
                         titulo.empcod     = 19 and
                        titulo.titnat     = no and
                        titulo.modcod     = contrato.modcod and
                        titulo.etbcod     = contrato.etbcod and
                        titulo.clifor     = contrato.clicod and
                        titulo.titnum     = string(contrato.contnum)
                         no-lock by titulo.titpar.
                         leave.
                        end.
                    end.
                    
                end.
 
            find first profin where profin.modcod = contrato.modcod no-lock no-error.
      
            if avail profin
            then assign vcod-produto = profin.Codigo_Sicred.
            else do:
                assign vcod-produto = 1.
                if sicred_contrato.operacao = "NOVACAO"
                then do:
                    run achacobcod(output vcod-produto).
                    vservicos = contrato.vlseguro. 
                end.     
            end.  
            if (contrato.tpcontrato = "N" or (avail titulo and titulo.tpcontrato = "N")) and contrato.modcod = "CRE"
            then vcod-produto = 2.
            else if contrato.modcod = "CPN"
                 then vcod-produto = 5.
            
            if sicred_contrato.operacao = "TRANSFERE"
            then do:
                if contrato.tpcontrato = "N"
                then vcod-produto = 12.
                else vcod-produto = 11.
            end.
            
            find contrsite where contrsite.contnum = contrato.contnum no-lock no-error.
            if avail contrsite
            then do:
                vcod-produto = sicred_param.codProdutoEcom.
            end.
             
            sicred_contr.codProduto = vcod-produto.

            vplano-fin = contrato.crecod.
                 
                if vcod-produto = 2 or vcod-produto = 12 
                then vplano-fin = 500. 
                else if vcod-produto = 5 
                     then vplano-fin = 501.
    
            find contnf where  
                contnf.etbcod = contrato.etbcod and 
                contnf.contnum = contrato.contnum no-lock no-error. 
            if avail contnf
            then do:
                find plani where plani.etbcod = contnf.etbcod and
                                 plani.placod = contnf.placod
                             no-lock no-error.
                if avail plani
                then do:
                    if contrato.modcod = "CP0" or contrato.modcod = "CP1"
                    then vvlf_principal = plani.protot + plani.vlserv.
            
                    vservicos = plani.vlserv. 

                    if contrato.modcod = "CP0" or 
                       contrato.modcod = "CP1" 
                    then do:
                        vservicos = if plani.seguro = ?
                                         then 0
                                    else plani.seguro. 
                    end.
                    
                        find finan where finan.fincod = plani.pedcod no-lock no-error.
                        if avail finan
                        then vplano-fin = if vplano-fin = 0 or vplano-fin = ?
                                          then plani.pedcod
                                          else vplano-fin.
                
            
                end.
            end.      
                  
            sicred_contr.fincod = if vplano-fin = ?
                                  then 0
                                  else vplano-fin.
            
            /**- cadastro de prazos do plano**/
            find sicred_planos of sicred_contr no-lock no-error.
            if not avail sicred_planos
            then do:
                sicred_contrato.descerro = "Plano " + string(sicred_contr.fincod) + " nao encontrado".
                hide message no-pause.
                message today sicred_contrato.sstatus sicred_contrato.operacao sicred_contr.contnum sicred_contrato.descerro. 
                
                sicred_contrato.sstatus  = "ERRO".
                next.                                     
            end.
            else do:
                /**- vigência do plano**/
                if sicred_planos.dtvigencia <> ? and
                   sicred_planos.dtvigencia < today
                then do:
                    sicred_contrato.descerro = "Plano " + string(sicred_contr.fincod) + " fora de vigencia".
                    hide message no-pause.
                    message today sicred_contrato.sstatus sicred_contrato.operacao sicred_contr.contnum sicred_contrato.descerro. 
                    
                    sicred_contrato.sstatus  = "ERRO".
                    next.
                end.    
            end.
            
            /**- cadastro de produtos por plano**/
            if lookup(string(sicred_contr.codProduto),sicred_planos.lista_Produtos) > 0
            then.
            else do:
                sicred_contrato.descerro = "Produto " + string(sicred_contr.codProduto) + " nao eh valido no plano "
                            + string(sicred_contr.fincod).
                hide message no-pause.
                message today sicred_contrato.sstatus sicred_contrato.operacao sicred_contr.contnum sicred_contrato.descerro. 
                            
                sicred_contrato.sstatus  = "ERRO".
                next.
            end.

            /**{1}.qtd_vezes                   - cadastro de prazos do plano**/
            if contrato.nro_parcelas > sicred_planos.qtd_vezes
            then do:
                sicred_contrato.descerro = "Prazo " + string(contrato.nro_parcelas) + "x maior que permitido no plano "
                            + string(sicred_contr.fincod) + " " + string(sicred_planos.qtd_vezes) + "x".
                hide message no-pause.
                message today sicred_contrato.sstatus sicred_contrato.operacao sicred_contr.contnum sicred_contrato.descerro. 
                            
                sicred_contrato.sstatus  = "ERRO".
                next.
            end.

            
            /*{1}.dias_min_privenc    - dias mínimo para primeiro vencimento
              {1}.dias_max_venc       - dias máximo para primeiro vencimento**/
            if titulo.titdtven >= contrato.dtinicial + sicred_planos.dias_min_privenc and
               titulo.titdtven <= contrato.dtinicial + sicred_planos.dias_max_venc
            then.
            else do:
                sicred_contrato.descerro = "Intervalor Min/max do Primeiro Vencimento nao permitido no plano "
                            + string(sicred_contr.fincod).
                hide message no-pause.
                message today sicred_contrato.sstatus sicred_contrato.operacao sicred_contr.contnum sicred_contrato.descerro. 
                            
                sicred_contrato.sstatus  = "ERRO".
                next.
            end.
            
            /*{1}.taxa_minima         - taxa mínima permitida por plano
              {1}.taxa_maxima         - taxa máxima permitida por plano**/
            if contrato.TxJuros >= sicred_planos.taxa_minima and
               contrato.TxJuros <= sicred_planos.taxa_maxima
            then.   
            else do:
                sicred_contrato.descerro = "Intervalo Min/max do Valor Taxa nao permitido no plano "
                            + string(sicred_contr.fincod).
                hide message no-pause.
                message today sicred_contrato.sstatus sicred_contrato.operacao sicred_contr.contnum sicred_contrato.descerro. 
                            
                sicred_contrato.sstatus  = "ERRO".
                next.
            end.
    
    
            /*{1}.dias_valido_emissao - validade de emissão de contrato no plano*/
            if contrato.dtinicial < today - sicred_planos.dias_valido_emissao
            then do:
                sicred_contrato.descerro = "Data Emissao nao permitido no plano "
                            + string(sicred_contr.fincod) .
                hide message no-pause.
                message today sicred_contrato.sstatus sicred_contrato.operacao sicred_contr.contnum sicred_contrato.descerro. 
                            
                sicred_contrato.sstatus  = "ERRO".
                next.
            end.
        
        end.




procedure achacobcod.
def output param vcod-produto as int.
def var vlebes as log.
def var vsicred as log.
def buffer bcontrato for contrato.
    find first pdvmov where 
                    pdvmov.etbcod = sicred_contr.etbcod and
                    pdvmov.cmocod = sicred_contr.cmocod and
                    pdvmov.datamov = sicred_contr.datamov and
                    pdvmov.sequencia = sicred_contr.sequencia
                no-lock .

    for each ttcob.
        delete ttcob.
    end.    
    for each pdvdoc of pdvmov no-lock.
        for each sicred_pagam where sicred_pagam.etbcod = pdvdoc.etbcod and 
                                    sicred_pagam.cmocod = pdvdoc.cmocod and
                                    sicred_pagam.datamov = pdvdoc.datamov and
                                    sicred_pagam.sequencia = pdvdoc.sequencia and
                                    sicred_pagam.ctmcod = pdvdoc.ctmcod and
                                    sicred_pagam.seqreg = pdvdoc.seqreg
                no-lock.
            find bcontrato where bcontrato.contnum = int(pdvdoc.contnum) no-lock. 
            find btitulo where btitulo.contnum = bcontrato.contnum and
                              btitulo.titpar  = pdvdoc.titpar
                              no-lock no-error.
                if not avail btitulo
                then do:
                    find first btitulo where
                    btitulo.empcod     = 19 and
                    btitulo.titnat     = no and
                    btitulo.modcod     = bcontrato.modcod and
                    btitulo.etbcod     = bcontrato.etbcod and
                    btitulo.clifor     = bcontrato.clicod and
                    btitulo.titnum     = string(bcontrato.contnum) and 
                    btitulo.titpar     = pdvdoc.titpar and
                    btitulo.titdtemi   = bcontrato.dtinicial
                    no-lock no-error.
                end.
                if avail btitulo
                then do:
                    find first ttcob where ttcob.cobcod = btitulo.cobcod no-error.
                    if not avail ttcob
                    then do:
                        create ttcob.
                        ttcob.cobcod = btitulo.cobcod.
                    end.
                end.            
                
        end.
    end.      
            vlebes  = no.
            vsicred = no.
            for each ttcob.
                find cobra where cobra.cobcod = ttcob.cobcod no-lock.
                if cobra.sicred = no
                then vlebes = yes.
                else vsicred = yes.
                delete ttcob. 
            end.
            if vlebes
            then do:
                if vsicred 
                then vcod-produto = 9.
                else vcod-produto = 7.
            end.
            else vcod-produto = 8.
       

end procedure.



