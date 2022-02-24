<?php

    $progr = new chamaprogress();
    $conteudoEntrada= json_encode($jsonEntrada);
    
  
   $retorno = $progr->executarprogress("protesto/1/selecionaparcelas",$conteudoEntrada,$dlc,$pf,$propath,$progresscfg,$tmp,$proginicial);
    
  
  //    echo "\nRETORNO=".$retorno ;
    $jsonSaida = json_decode($retorno, TRUE);
    /*** 
      $conteudoSaida = (object) json_decode($retorno, TRUE);
      $conteudoSaidaDados = (object) $conteudoSaida->dadosSaida;
      $conteudoSaidaParametros = (object) $conteudoSaidaDados->parametros["0"];
      ***/
    //  var_dump($conteudoSaidaParametros);

      //echo "\nJSON=".$conteudoSaidaParametros->codigoSeguroPrestamista ;

    /*
        $jsonSaida     = array(
                      "codigoSeguroPrestamista" => $conteudoSaidaParametros->codigoSeguroPrestamista,
                      "valorTotalSeguroPrestamista"    => $conteudoSaidaParametros->valorTotalSeguroPrestamista,
                      "elegivel"    =>  $conteudoSaidaParametros->elegivel,
                      "valorSeguroPrestamistaEntrada" => $conteudoSaidaParametros->valorSeguroPrestamistaEntrada,
                      "parcelas" => $conteudoSaidaParametros->parcelas
              );
      */
