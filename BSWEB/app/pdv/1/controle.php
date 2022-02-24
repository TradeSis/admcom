<?php

//echo "funcao=".$funcao."\n";
//echo "parametro=".$parametro."\n";

if (!isset($funcao)) {
  if ($parametro=="atualizaNeuProposta") {
    $funcao=$parametro;
    $parametro=null;
  }
  if ($parametro=="consultaCliente") {
    $funcao=$parametro;
    $parametro=null;
  }
  if ($parametro=="atualizacaoDadosCliente") {
    $funcao=$parametro;
    $parametro=null;
  }
  if ($parametro=="preAutorizacao") {
    $funcao=$parametro;
    $parametro=null;
  }
  if ($parametro=="verificaCreditoVenda") {
    $funcao=$parametro;
    $parametro=null;
  }
  if ($parametro=="verificacaoCarteiraDestino") {
    $funcao=$parametro;
    $parametro=null;
  }
} else {
    $aux=$parametro;
    $parametro=$funcao;
    $funcao=$aux;
}
//echo "funcao=".$funcao."\n";
//echo "parametro=".$parametro."\n";



switch ($funcao) {
   case "atualizaNeuProposta":
      if (isset($jsonEntrada)){
         include 'atualizaNeuProposta.php';
       } else {
         $jsonSaida = json_decode(json_encode(
          array("erro" => "400",
              "retorno" => "conteudo JSON vazio 1")
            ), TRUE);
       }
  break;
  case "consultaCliente":
    if (isset($jsonEntrada)){
       include 'consultaCliente.php';
     } else {
       $jsonSaida = json_decode(json_encode(
        array("erro" => "400",
            "retorno" => "conteudo JSON vazio 1")
          ), TRUE);
     }
break;
case "atualizacaoDadosCliente":
  if (isset($jsonEntrada)){
     include 'atualizacaoDadosCliente.php';
   } else {
     $jsonSaida = json_decode(json_encode(
      array("erro" => "400",
          "retorno" => "conteudo JSON vazio 1")
        ), TRUE);
   }
break;
case "preAutorizacao":
  if (isset($jsonEntrada)){
     include 'preAutorizacao.php';
   } else {
     $jsonSaida = json_decode(json_encode(
      array("erro" => "400",
          "retorno" => "conteudo JSON vazio 1")
        ), TRUE);
   }
break;
case "verificaCreditoVenda":
  if (isset($jsonEntrada)){
     include 'verificaCreditoVenda.php';
   } else {
     $jsonSaida = json_decode(json_encode(
      array("erro" => "400",
          "retorno" => "conteudo JSON vazio 1")
        ), TRUE);
   }
break;
case "verificacaoCarteiraDestino":
  if (isset($jsonEntrada)){
     include 'verificacaoCarteiraDestino.php';
   } else {
     $jsonSaida = json_decode(json_encode(
      array("erro" => "400",
          "retorno" => "conteudo JSON vazio 1")
        ), TRUE);
   }
break;
   default:
      $jsonSaida = json_decode(json_encode(
       array("erro" => "400",
           "retorno" => "Aplicacao " . $aplicacao . " Versao ".$versao." Funcao ".$funcao." Invalida")
         ), TRUE);
      break;
}
