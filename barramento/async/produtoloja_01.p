/* helio 12/11/2021 novos campos fase 2 */

disable triggers for load of estoq.
disable triggers for load of produ.

DEFINE INPUT  PARAMETER lcJsonEntrada      AS LONGCHAR.
def    output param     vok as char no-undo.
vok = "".

DEFINE var lcJsonsaida      AS LONGCHAR.

def var vestvenda as dec.
{/admcom/barramento/functions.i}

{/admcom/barramento/async/produtoloja_01.i}

/* LE ENTRADA */
lokJSON = hprodutoLojaEntrada:READ-JSON("longchar",lcJsonEntrada, "EMPTY").

/***
pause 1.
*def var vsaida as char.
find first ttprodutoloja.        

vsaida = "./json/produtoloja/" + trim(ttprodutoloja.codigoProduto) + "_" + ttprodutoloja.codigoloja + "_" 
                           + trim(ttprodutoloja.ativo)  + "_" + string(time)
                           + "produtoloja.json".


**hprodutolojaEntrada:WRITE-JSON("FILE",vsaida, true).

**/

/*


*/

for each ttprodutoloja.
    /*        
    field ativo as char
    field mixLoja as char
    field tempoGarantia as char
    */
   
    find estoq where estoq.etbcod = int(codigoLoja) and
                     estoq.procod = int(codigoProduto)
        exclusive no-wait no-error.                      
    if not avail estoq
    then do:
        if locked estoq
        then do:
            vok = "locado".
            return. 
        end.    
        create estoq.
        estoq.etbcod = int(codigoLoja) .
        estoq.procod = int(codigoProduto).
        estoq.datexp = today.
    end. 
    /* 25/08/2021 MIX - campo novo mixDistribuicaoLoja */
    if ttprodutoloja.mixDistribuicaoLoja = "true"
    then do:
        find abasgrade where 
                    abasgrade.etbcod = estoq.etbcod and
                    abasgrade.procod = estoq.procod
                    exclusive-lock no-error.
        if not avail abasgrade
        then do:
            create abasgrade. 
            abasgrade.etbcod = estoq.etbcod.
            abasgrade.procod = estoq.procod.
        end.
        abasgrade.abgqtd = int(ttprodutoloja.mixLoja).       
    end.    
    if ttprodutoloja.mixDistribuicaoLoja <> "true"
    then do:
        find abasgrade where 
                    abasgrade.etbcod = estoq.etbcod and
                    abasgrade.procod = estoq.procod
                    exclusive-lock no-error.
        if avail abasgrade
        then do:
            abasgrade.abgqtd = if int(ttprodutoloja.mixLoja) <> ? /* Roberto Pediu 03/02/2022 */
                               then int(ttprodutoloja.mixLoja)
                               else 0 .       
        end.    
    end.    

    for each ttpreco where ttpreco.idpai =  ttprodutoloja.id.
        /* 
        field precoRegular as char  
        field precoRemarcado as char  
        */
        estoq.estcusto = dec(precoCusto).
        vestvenda = dec(precoPraticado) no-error.
        if vestvenda <> ? 
        then do:
            estoq.estvenda = /*if ttprodutoloja.tipo = "SERV" /*11032020*/
                             then 0
                             else*/ vestvenda.
            estoq.datexp  = today.
        end.    
 
        for each ttprecopromocional where ttprecopromocional.idpai = ttpreco.id.
            
            if dec(ttprecopromocional.precoPromocional) <> ? and
               dec(ttprecopromocional.precoPromocional) <> 0
            then estoq.estproper = dec(ttprecopromocional.precoPromocional).
            if aaaa-mm-dd_todate(ttprecopromocional.dataInicialPromocao) <> ?
            then estoq.estbaldat = aaaa-mm-dd_todate(ttprecopromocional.dataInicialPromocao).
            if aaaa-mm-dd_todate(ttprecopromocional.dataFinalPromocao) <>?
            then estoq.estprodat = aaaa-mm-dd_todate(ttprecopromocional.dataFinalPromocao).
            
        end.
            
    end.            
    for each tttributacao where tttributacao.idpai =  ttprodutoloja.id.
        
        find produ of estoq exclusive no-wait no-error.
        if avail produ
        then do:
            produ.proipiper = dec(tttributacao.aliquotaIcms). 
            if produ.tipoSAP = "SERV"
            then produ.proipiper = 98.
            
            if int(tttributacao.cst) = 60
            then produ.proipiper = 99.  /* ST */ 
            
            
        end.
    end.     
    
    run /admcom/progr/geraindicegenerico.p (estoq.procod, ?).
          
end.    



