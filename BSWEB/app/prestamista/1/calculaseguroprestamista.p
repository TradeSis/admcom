/* helio 20012022 - [UNIFICAÇÃO ZURICH - FASE 2] NOVO CÁLCULO PARA SEGURO PRESTAMISTA MÓVEIS NA PRÉ-VENDA */

def input  parameter vlcentrada as longchar.

def var vlcsaida   as longchar.
def var vsaida as char.

DEFINE VARIABLE lokJSON                  AS LOGICAL.

def var vok as log. 
def var vqtdParcelas as int.
def var vvalorTotalSeguroPrestamista as dec.
def var vvalorTotalSeguroPrestamistaEntrada as dec.
def var vvalorParcelaSeguroPrestamista as dec.
def var vvalorTotal as dec.
def var vvalorAcrescimo as dec.
def var vvalorEntrada as dec.   

{/admcom/progr/seg/jsonprestamista.i NEW}

lokJSON = hentrada:READ-JSON("longchar",vlcentrada, "EMPTY").

    find segtipo where segtipo.tpseguro = 1 no-lock no-error.    /* seguro prestamista */
    
    create ttsegprestpar.
    ttsegprestpar.elegivel                      = "false".
    
    vok = no.
    find first ttpedidoCartaoLebes no-error.
    if avail ttpedidoCartaoLebes
    then do:
        vvalorTotal     = dec(ttpedidoCartaoLebes.valorTotal).
    end.
    find first ttcartaoLebes no-error.
    if avail ttcartaoLebes
    then do:
        vvalorEntrada   = dec(ttcartaoLebes.valorEntrada).
        vqtdParcelas    = int(ttcartaoLebes.qtdParcelas).  
        vvalorAcrescimo    = int(ttcartaoLebes.valorAcrescimo).  
    end.
    find first ttparcelas no-error.
    find first ttprodutos no-error.
    if  avail ttpedidoCartaoLebes and
        avail ttcartaoLebes and
        avail ttprodutos and 
        avail ttparcelas and
        avail segtipo
    then do: 
        find produ where produ.procod = int(ttprodutos.codigoProduto) no-lock no-error.
        if avail produ
        then do:
            find categoria of produ no-lock no-error.
            if avail categoria
            then do:
            

                find first segprestpar where 
                        segprestpar.tpseguro  = segtipo.tpseguro and
                        segprestpar.categoria = trim(categoria.catnom) and
                        segprestpar.etbcod    = int(ttpedidocartaolebes.codigoLoja)
                    no-lock no-error.
                if not avail segprestpar
                then do:
                    find first segprestpar where 
                            segprestpar.tpseguro  = segtipo.tpseguro and
                            segprestpar.categoria = trim(categoria.catnom) and
                            segprestpar.etbcod    = 0
                        no-lock no-error.
                end.     
                
                        
                if avail segprestpar
                then do:
                    vok = yes.
                    for each ttparcelas.
                        if dec(ttparcelas.valorParcela) < segprestpar.valMinParc
                        then do:
                            vok = no.

                        end.    
                    end.
                    if vqtdparcelas < qtdMinParc
                    then do:
                    
                        vok = no.
                    end.    
                    if vok
                    then do:

                        vvalorTotalSeguroPrestamista    = 0.
                        vvalorTotalSeguroPrestamistaEntrada  = 0.                      
                        /*
                        if segprestpar.considerarEntrada = yes
                        then do:
                            if segprestpar.valorPorParcela > 0
                            then vvalorTotalSeguroPrestamistaEntrada = segprestpar.valorPorParcela.
                            else vvalorTotalSeguroPrestamistaEntrada = vvalorEntrada * segprestpar.percentualSeguro / 100.
                        end.
                        */

                        if segprestpar.valorPorParcela > 0
                        then vvalorTotalSeguroPrestamista = (vqtdparcelas * segprestpar.valorPorParcela).
                        else vvalorTotalSeguroPrestamista = (vvalorTotal) * segprestpar.percentualSeguro / 100.
                        
                        vvalorParcelaSeguroPrestamista    = vvalorTotalSeguroPrestamista / vqtdparcelas.
                        
                        ttsegprestpar.codigoSeguroPrestamista       = string(segprestpar.codigoSeguro).
                        ttsegprestpar.valorTotalSeguroPrestamista   = trim(string(vvalorTotalSeguroPrestamista + 
                                                                                  vvalorTotalSeguroPrestamistaEntrada  ,">>>>>>>>>>>>>>>>>9.99")).
                        ttsegprestpar.elegivel                      = "true".
                        ttsegprestpar.valorSeguroPrestamistaEntrada = trim(string(
                                                                    vvalorTotalSeguroPrestamistaEntrada,">>>>>>>>>>>>>>>>>9.99")).
                        
                        for each ttparcelas.
                            create ttsaidaparcelas.
                            ttsaidaparcelas.seqParcela     = ttparcelas.seqParcela.
                            ttsaidaparcelas.valorParcela   = 
                                        trim(string(
                                        dec(ttparcelas.valorParcela) + vvalorParcelaSeguroPrestamista
                                        ,">>>>>>>>>>>>>>>>>9.99")).
                            ttsaidaparcelas.valorSeguroRateado   = 
                                        trim(string(
                                        vvalorParcelaSeguroPrestamista
                                        ,">>>>>>>>>>>>>>>>>9.99")).
                                        
                            ttsaidaparcelas.dataVencimento = ttparcelas.dataVencimento.
                        end.        
                        
                    end.
                end.
            end.
        end.
    end.



    /*    lokJson = hsaida:WRITE-JSON("LONGCHAR", vlcSaida, TRUE).
          message string(vlcsaida).*/

def var varquivo as char.
def var ppid as char.
INPUT THROUGH "echo $PPID".
DO ON ENDKEY UNDO, LEAVE:
IMPORT unformatted ppid.
END.
INPUT CLOSE.
          
varquivo  = "calculaseguroprestamista" + string(today,"999999") + replace(string(time,"HH:MM:SS"),":","") +
          trim(ppid) + ".json".
lokJson = hsaida:WRITE-JSON("FILE", varquivo, TRUE).

os-command value("cat " + varquivo).
os-command value("rm -f " + varquivo)
