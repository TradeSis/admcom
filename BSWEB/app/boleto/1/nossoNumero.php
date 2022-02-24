<?php

  $conteudo = json_decode(json_encode($jsonEntrada["dadosEntrada"]));

  if (isset($conteudo)) {

      $conteudoEntrada = json_encode(array('dadosEntrada' => array($conteudo)));


  } else {
    $conteudo = json_decode(json_encode($jsonEntrada));

    $conteudoEntrada=json_encode(array('dadosEntrada' => $jsonEntrada));

  }

/**
  {"dadosEntrada":{
	"cpfCliente": "00315554037",
	"dataVencimentoBoleto": "2021-05-15",
	"valorTotalBoleto": "99.90",
	"taxaEmissaoBoleto": "1.00",
	"banco": "104"
}
}
**/

  // formata para o Progress
  /**
  $conteudoEntrada=json_encode(
    array('dadosEntrada' =>array(array(
                          'cpfCliente' => $conteudo->cpfCliente,
                          'dataVencimentoBoleto' => $conteudo->dataVencimentoBoleto,
                          'valorTotalBoleto' => $conteudo->valorTotalBoleto,
                          'taxaEmissaoBoleto' => $conteudo->taxaEmissaoBoleto,
                          'banco' => $conteudo->banco
                        ))));
**/

  $progr = new chamaprogress();

  $retorno       = $progr->executarprogress("nossonumero",$conteudoEntrada,$dlc,$pf,$propath,$progresscfg,$tmp,$proginicial);


  $conteudoSaida = json_decode($retorno, TRUE);
  
  if (isset($conteudoSaida["return"][0])) {

    $jsonSaida     = $conteudoSaida["return"][0];
  } else {
    echo "\nERRO ".$retorno."\n";
  }


/*

$jsonSaida = json_decode(json_encode(
     array("status" => "200",
         "descricaoStatus" => "tudo Certo",
         "nossoNumero" => rand())
       ), TRUE);
*/

//$jsonSaida = json_decode($conteudoEntrada, TRUE);
