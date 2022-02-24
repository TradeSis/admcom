<?php
/* helio 17022022 - 263458 - Revisão da regra de novações  */


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
                      "tipoOperacao" => $jsonEntrada->tipoOperacao,
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

    // echo "ENTRADA=".$conteudoEntrada;

   $retorno = $progr->executarprogress("pdv/1/verificacaocarteiradestino",$conteudoEntrada,$dlc,$pf,$propath,$progresscfg,$tmp,$proginicial);
    
  //  echo "\nRETORNO=".$retorno ;

    if ($chamadaPREVENDA=="SIM") {
        $jsonSaida = json_decode($retorno, TRUE);
    }   else {

    
      $conteudoSaida = json_decode($retorno, TRUE);
     
   // var_dump($conteudoSaida);

      //echo "\nJSON=".$conteudoSaidaParametros->codigoSeguroPrestamista ;

    
        $jsonSaida     = $conteudoSaida["dadosSaida"];
              
    }

    //  $jsonSaida  =  json_decode($retorno, TRUE);
