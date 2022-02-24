<?php
/* helio 20012022 - [UNIFICAÇÃO ZURICH - FASE 2] NOVO CÁLCULO PARA SEGURO PRESTAMISTA MÓVEIS NA PRÉ-VENDA */

$progr = new chamaprogress();
$conteudoEntrada= json_encode($jsonEntrada);
    // echo "ENTRADA=".$conteudoEntrada;
      $retorno = $progr->executarprogress("prestamista/1/buscaparametros",$conteudoEntrada,$dlc,$pf,$propath,$progresscfg,$tmp,$proginicial);
      //echo "\nRETORNO=".$retorno ;

    //  $jsonSaida = json_decode($retorno, TRUE);
    //  echo "\nJSON=".$jsonSaida ;

      $jsonSaida  =  json_decode($retorno, TRUE);
