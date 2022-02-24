<?php


$dadosEntrada = $jsonEntrada["dadosEntrada"];

   
if (!isset($dadosEntrada)) {
  
    $dadosEntrada = (object) $jsonEntrada;
   // var_dump($dadosEntrada);

    $conteudoEntrada = json_encode(
      array("dadosEntrada" => array(
              "proposta"  =>  array(array(
                "idOperacaoMotor" => $dadosEntrada->idOperacaoMotor,
                "statusProposta" => $dadosEntrada->statusProposta,
                "politica" => $dadosEntrada->politica,
                "fluxo" => $dadosEntrada->fluxo,
                "cpf" => $dadosEntrada->cpf)),
              "rets"  => $dadosEntrada->rets)
      ));



} else {
    $conteudoEntrada = json_encode($jsonEntrada);
 
}

   




  //echo "ENTRADA=".$conteudoEntrada;


    $progr = new chamaprogress();
   
    
  
   $retorno = $progr->executarprogress("pdv/1/atualizaneuproposta",$conteudoEntrada,$dlc,$pf,$propath,$progresscfg,$tmp,$proginicial);
    
 
    //echo "\nRETORNO=".$retorno ;

    
      $conteudoSaida = json_decode($retorno, TRUE);
      $jsonSaida = $conteudoSaida["dadosSaida"][0];

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

