<?php

  //  $jsonEntrada = json_decode($argv[1],true);

//    $conteudo = json_decode(json_encode($jsonEntrada["dadosEntrada"]));

    $jsonEntrada = (object) $jsonEntrada["boleto"][0];


    $conteudoFormatado= json_encode(
                            array("dadosEmissao" => array(
                                    "valorCobrado"   => $jsonEntrada->valorCobrado,
                                    "dataVencimento" => $jsonEntrada->dataVencimento,
                                    "nossoNumero"    => $jsonEntrada->nossoNumero,
                                    "dataEmissao"    =>   $jsonEntrada->dataEmissao,
                                    "pagador"  =>  array(
                                        "cpfCnpjPagador" => $jsonEntrada->cpfCnpjPagador,
                                        "nomePagador" => $jsonEntrada->nomePagador,
                                        "codigoInternoPagador" => $jsonEntrada->codigoInternoPagador,
                                        "enderecoPagador" => array(
                                          "cepPagador" => $jsonEntrada->cepPagador,
                                          "ufPagador" => $jsonEntrada->ufPagador,
                                          "cidadePagador" => $jsonEntrada->cidadePagador,
                                          "logradouroPagador" => $jsonEntrada->logradouroPagador,
                                          "bairroPagador" => $jsonEntrada->bairroPagador,
                                          "numeroPagador" => $jsonEntrada->numeroPagador
                                      )
                                    )
                                  )
                                ));


  //  $conteudoFormatado= json_encode(array("cpfCliente" => $jsonEntrada->cpfCnpjPagador));

    //echo json_decode(json_encode($conteudoFormatado));

    // HML http://lebcapp07-hml.matriz.drebes.com.br:5555/gateway/FinanceiroBoletos/1.0/boleto/emitir?banco=104
    $service_url = 'http://lebcapp01-prd.matriz.drebes.com.br:5555/gateway/FinanceiroBoletos/1.0/boleto/emitir?banco=104';
    $curl = curl_init($service_url);
    curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "POST");
    curl_setopt($curl, CURLOPT_POSTFIELDS, $conteudoFormatado);
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($curl, CURLOPT_HTTPHEADER, array(
      'Content-Type: application/json',
      'Content-Length: ' . strlen($conteudoFormatado))
    );
//    curl_setopt($curl, CURLOPT_HEADER, true);
//    curl_setopt($curl, CURLOPT_FOLLOWLOCATION, 1);
    curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
    $curl_response = curl_exec($curl);
    $result = json_decode($curl_response, true);

  //  var_dump($result);

    $info = curl_getinfo($curl);

    curl_close($curl); // close cURL handler


    if ($info['http_code']==200) {
      $jsonSaida     = array(
              "return"   => array(array(
                    "status" => "REGISTRADO",
                    "linhaDigitavel" => $result["boleto"]["linhaDigitavel"],
                    "codigoBarras"    => $result["boleto"]["codigoBarras"],
                    "DVNossoNumero"    =>  ""))
            );
    } else {
            $jsonSaida     = array(
                    "return"   => array(array(
                          "status" => "ERRO=".$info['http_code']))
                  );

    }

    //echo json_decode(json_encode($jsonSaida))

    //echo $conteudoFormatado;
