<?php

    $conteudo = json_decode(json_encode($jsonEntrada["dadosEntrada"]));


    $conteudoEntrada=
        json_encode(array("dadosEntrada" => array("boleto" => array(array(
                            "banco"         => $conteudo->boleto->banco,
                            "nossoNumero"   => $conteudo->boleto->nossoNumero,
                            "situacao"      => $conteudo->boleto->situacao,
                            "taxaEmissaoBoleto" => $jsonEntrada["taxaEmissaoBoleto"])),
                            "parcelas"      => $conteudo->parcelas
                          )));


$progr = new chamaprogress();

$retorno       = $progr->executarprogress("incluirboletoparcela",$conteudoEntrada,$dlc,$pf,$propath,$progresscfg,$tmp,$proginicial);


$conteudoSaida = json_decode($retorno, TRUE);
if (isset($conteudoSaida["return"][0])) {
  $jsonSaida     = $conteudoSaida["return"][0];
} else {
  echo "\nERRO ".$retorno."\n";
}
