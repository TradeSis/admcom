<?php

  $progr = new chamaprogress();

  $conteudoEntrada=json_encode($jsonEntrada);

  $retorno = $progr->executarprogress("etiqueta/1/geraarquivo",$conteudoEntrada,$dlc,$pf,$propath,$progresscfg,$tmp,$proginicial);

  $jsonSaida =  json_decode($retorno, TRUE);

?>
