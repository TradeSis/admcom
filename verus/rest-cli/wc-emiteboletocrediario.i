/* Entrada */

DEFINE {1} shared TEMP-TABLE ttboletoentrada NO-UNDO SERIALIZE-NAME "boletoEntrada"
    field cpfCliente    as char /*":"18690718087", */
    field dataVencimentoBoleto  as char /*":"2019-04-13", */
    field valorTotalBoleto  as char /*  ":"9.70", */
    field taxaEmissaoBoleto as char. /*":"1.90",*/

/*
def temp-table ttidSolicitante NO-UNDO SERIALIZE-NAME "idSolicitante"
    field numeroPdv     as char     /*":"100",*/ 
    field codigoLoja    as char     /*":"200",*/ 
    field origem        as char.     /* ":"4all"*/
*/
DEFINE {1} shared TEMP-TABLE ttparcelas NO-UNDO SERIALIZE-NAME "parcelas"  
    field cpfCliente        as char /*":"18690718087",*/
    field numeroContrato    as char /*":"0302360498",*/ 
    field seqParcela        as char /*":"2",*/ 
    field vctoParcela       as char /*":"2019-05-08",*/ 
    field valorParcela      as char /*":"3.90",*/ 
    field valorEncargo      as char /*":"0.00",*/ 
    field valorDesconto     as char /*":"0.00",*/ 
    field valorPago         as char. /*":"3.90"*/

                                                                                                                                                            
DEFINE DATASET emiteboletoEntrada SERIALIZE-NAME "docEmiteBoletoPagtoParcelaCrediarioEntrada"
    FOR ttboletoentrada, ttparcelas
    DATA-RELATION for1 FOR ttboletoentrada, ttparcelas         
        RELATION-FIELDS(ttboletoentrada.cpfCliente,ttparcelas.cpfCliente) NESTED.


def temp-table ttboletosaida NO-UNDO SERIALIZE-NAME "boletoSaida"
    field campo as char serialize-hidden.
                                                                                                                            
def {1} shared temp-table ttstatusRetorno NO-UNDO SERIALIZE-NAME "statusRetorno"
    field campo as char serialize-hidden
    field   rstatus     as char serialize-name "status" /*":"200", */
    field   statusMsg   as char. /*":"OK" */

DEFINE {1} SHARED TEMP-TABLE ttboleto NO-UNDO SERIALIZE-NAME "boleto"
    field campo as char serialize-hidden
    field banco         as char /*":"341", */ 
    field agencia       as char /*":"6935", */ 
    field codigoCedente as char /*":"010857", */ 
    field contaCorrente as char /*":"10857", */ 
    field carteira      as char /*":"109", */ 
    field nossoNumero   as char /*":"00026233", */ 
    field dvNossoNumero as char /*":"3", */ 
    field dtEmissao     as char /*":"2019-04-10", */ 
    field dtVencimento  as char /*":"2019-04-13", */ 
    field fatorVencimento   as char /*":"7858", */ 
    field numeroDocumento   as char /*":"10023440", */ 
    field sacadoNome    as char /*":"ANGELA MARIA SILVA", */ 
    field sacadoEndereco    as char /*":"JOSE DE ALENCAR", */ 
    field sacadoCEP     as char /*":"95820000", */ 
    field linhaDigitavel    as char /*":"34191.09008 02623.336936 50108.570008 5 78580000000970", */ 
    field codigoBarras  as char /*":"34195785800000009701090002623336935010857000", */ 
    field vlPrincipal   as char. /*":"9.70" */
   
                                                      
DEFINE DATASET emiteboletoSaida serialize-name "docEmiteBoletoPagtoParcelaCrediarioSaida" 
    FOR ttboletosaida , ttstatusRetorno, ttboleto
        DATA-RELATION for1 FOR ttboletosaida, ttstatusretorno
        RELATION-FIELDS(ttboletosaida.campo,ttstatusretorno.campo) NESTED
    DATA-RELATION for2 FOR ttboletosaida, ttboleto
        RELATION-FIELDS(ttboletosaida.campo,ttboleto.campo) NESTED.

                                                      
