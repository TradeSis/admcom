<?php


$dadosEntrada = $jsonEntrada["dadosEntrada"];

   
if (!isset($dadosEntrada)) {
  
    $dadosEntrada = (object) $jsonEntrada;
   // var_dump($dadosEntrada);

    $conteudoEntrada = json_encode(
      array("dadosEntrada" => array(
              )
      ));



} else {
    $conteudoEntrada = json_encode($jsonEntrada);
 
}

   




  //echo "ENTRADA=".$conteudoEntrada;


    $progr = new chamaprogress();
    $conteudoEntrada= json_encode($jsonEntrada);
    
  
   $retorno = $progr->executarprogress("pdv/1/verificacreditovenda",$conteudoEntrada,$dlc,$pf,$propath,$progresscfg,$tmp,$proginicial);
    

  //  $retorno = "{\"dadosSaida\":{\"resposta\":\"ok\"}}";
  //echo "\nRETORNO=".$retorno ;

    
   //   $conteudoSaida = (object) json_decode($retorno, TRUE);
  //    $jsonSaida =  $conteudoSaida /*->dadosSaida*/ ;
    
      $jsonSaida = json_decode($retorno,true);

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

