<?php
/*VERSAO 2 23062021*/

include "config.php";

if ($versao==""){$versao="1";}

if ($metodo=="POST") {

      switch ($versao) {
         case "1":
               include '1/controle.php';
               break;
         default:
          $jsonSaida = json_decode(json_encode(
             array("status" => 400,
                 "retorno" => "Aplicacao " . $aplicacao . " Versao ".$versao." Invalida")
               ), TRUE);
            break;
          }

}  else {

    $jsonSaida = json_decode(json_encode(
        array("status" => 405,
            "retorno" => "Aplicacao " . $aplicacao . " Metodo ".$metodo." Invalido")
          ), TRUE);

  

  }