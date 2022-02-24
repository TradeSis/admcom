<?php
/* helio 20012022 - [UNIFICAÇÃO ZURICH - FASE 2] NOVO CÁLCULO PARA SEGURO PRESTAMISTA MÓVEIS NA PRÉ-VENDA */


    $chamadaPREVENDA = "";

    $progr = new chamaprogress();
  //  $conteudoEntrada= json_encode($jsonEntrada);
    
  //  $conteudo = json_decode(json_encode($jsonEntrada["pedidoCartaoLebes"]));
    $dadosEntrada = $jsonEntrada["dadosEntrada"];
   
   
    if (!isset($dadosEntrada)) {
      
        $jsonEntrada = (object) $jsonEntrada["pedidoCartaoLebes"];
        $jsonEntradacartaoLebes = (object) $jsonEntrada->cartaoLebes;
        $conteudoEntrada= json_encode(
          array("dadosEntrada" => array(
                  "pedidoCartaoLebes"  =>  array(array(
                      "codigoLoja" => $jsonEntrada->codigoLoja,
                      "dataTransacao" => $jsonEntrada->dataTransacao,
                      "numeroComponente" => $jsonEntrada->numeroComponente,
                      "codigoVendedor" => $jsonEntrada->codigoVendedor,
                      "codigoOperador" => $jsonEntrada->codigoOperador,
                      "valorTotal" => $jsonEntrada->valorTotal,
                      "codigoCliente" => $jsonEntrada->codigoCliente,
                      "cpfCnpjCliente" => $jsonEntrada->cpfCnpjCliente,
                      "cartaoLebes" => array(array(
                        "qtdParcelas" => $jsonEntradacartaoLebes->qtdParcelas,
                        "valorEntrada" => $jsonEntradacartaoLebes->valorEntrada,
                        "valorAcrescimo" => $jsonEntradacartaoLebes->valorAcrescimo,
                        "dataPrimeiroVencimento" => $jsonEntradacartaoLebes->dataPrimeiroVencimento,
                        "dataUltimoVencimento" => $jsonEntradacartaoLebes->dataUltimoVencimento,
                        "vendaTerceiros" => $jsonEntradacartaoLebes->vendaTerceiros,
                        "parcelas" => $jsonEntradacartaoLebes->parcelas)),
                      "produtos"  => $jsonEntrada->produtos
                          
                  ))
                )
              ));
            //  var_dump($conteudoEntrada);
    
    } else {
        $conteudoEntrada = json_encode($jsonEntrada);
        $chamadaPREVENDA = "SIM";
       // var_dump($jsonEntrada);
    }
  
       

    
  //  $conteudoEntrada=json_encode(array('clienteEntrada' => $jsonEntrada));

   //echo "ENTRADA=".$conteudoEntrada;

   $retorno = $progr->executarprogress("prestamista/1/calculaseguroprestamista",$conteudoEntrada,$dlc,$pf,$propath,$progresscfg,$tmp,$proginicial);
    
    //echo "\nRETORNO=".$retorno ;

    if ($chamadaPREVENDA=="SIM") {
        $jsonSaida = json_decode($retorno, TRUE);
    }   else {

    
      $conteudoSaida = (object) json_decode($retorno, TRUE);
      $conteudoSaidaDados = (object) $conteudoSaida->dadosSaida;
      $conteudoSaidaParametros = (object) $conteudoSaidaDados->parametros["0"];
    //  var_dump($conteudoSaidaParametros);

      //echo "\nJSON=".$conteudoSaidaParametros->codigoSeguroPrestamista ;

    
        $jsonSaida     = array(
                      "codigoSeguroPrestamista" => $conteudoSaidaParametros->codigoSeguroPrestamista,
                      "valorTotalSeguroPrestamista"    => $conteudoSaidaParametros->valorTotalSeguroPrestamista,
                      "elegivel"    =>  $conteudoSaidaParametros->elegivel,
                      "valorSeguroPrestamistaEntrada" => $conteudoSaidaParametros->valorSeguroPrestamistaEntrada,
                      "parcelas" => $conteudoSaidaParametros->parcelas
              );
      }  

    //  $jsonSaida  =  json_decode($retorno, TRUE);
