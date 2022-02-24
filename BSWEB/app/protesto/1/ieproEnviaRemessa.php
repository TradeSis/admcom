<?php



     
    $Entrada = str_replace("\/", "/", json_encode($jsonEntrada));
    
    //var_dump($Entrada);
    $Entrada = json_decode($Entrada, TRUE);
    
  //  var_dump($Entrada);

    $conteudoEntrada = array("dadosEntrada" => 
                            array("nome_arquivo" => $Entrada["dadosEntrada"][0]["nome_arquivo"],
                                  "dadosXml" =>  $Entrada["dadosEntrada"][0]["dadosXml"]
                                            ));

   
    
    $operacaoSol  = $Entrada["dadosEntrada"][0]["operacao"];
    $nome_arquivo = $Entrada["dadosEntrada"][0]["nome_arquivo"];                                        
 
      
    $conteudoFormatado = json_encode($conteudoEntrada);
    
    //var_dump($conteudoFormatado);

    $service_url = 'http://172.19.130.11:5555/gateway/lebesIEPRO/1.0/protestos/'.$operacaoSol;


    $curl = curl_init($service_url);
    curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "POST");
    curl_setopt($curl, CURLOPT_POSTFIELDS, $conteudoFormatado);
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($curl, CURLOPT_CONNECTTIMEOUT, 0);
    curl_setopt($curl, CURLOPT_TIMEOUT, 120); //timeout in seconds
    curl_setopt($curl, CURLOPT_FAILONERROR, true); // Required for HTTP error codes to be reported via our call to curl_error($ch)
    curl_setopt($curl, CURLOPT_HTTPHEADER, array(
      'Content-Type: application/json',
      'Content-Length: ' . strlen($conteudoFormatado))
    );
//    curl_setopt($curl, CURLOPT_HEADER, true);
//    curl_setopt($curl, CURLOPT_FOLLOWLOCATION, 1);
    curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
    $curl_response = curl_exec($curl);
    $info = curl_getinfo($curl);

    $erro = null;
    if (curl_errno($curl)) {
        $errno= curl_errno($curl);
        $erro = curl_error($curl);
    }
    curl_close($curl); // close cURL handler
    
    $retorno = json_decode($curl_response,true);
    //var_dump($retorno);
   

    //var_dump($retorno);
    if ($operacaoSol == "remessas") {
        $jsonEntrada = $retorno;
        $ocorrencia = $jsonEntrada["jsonSoapResponse"]["relatorio"]["comarca"]["ocorrencia"];
        $codocorrencia = $jsonEntrada["jsonSoapResponse"]["relatorio"]["comarca"]["codigo"];
        if (!isset($ocorrencia)) {
            $ocorrencia = $jsonEntrada["jsonSoapResponse"]["relatorio"]["ocorrencia"];
            $codocorrencia = $jsonEntrada["jsonSoapResponse"]["relatorio"]["codigo"];
        }
        

        //$jsonEntrada = json_decode($fixoJson, true);
        //var_dump($retorno);
    } else 
   /* if ($operacaoSol == "desistencia")*/ {
        $jsonEntrada = $retorno;
        $ocorrencia = $jsonEntrada["jsonSoapResponse"]["relatorio"]["titulo"]["ocorrencia"];
        $codocorrencia = $jsonEntrada["jsonSoapResponse"]["relatorio"]["titulo"]["codigo"];
        if (!isset($ocorrencia)) {
            $ocorrencia = $jsonEntrada["jsonSoapResponse"]["relatorio"]["ocorrencia"];
            $codocorrencia = $jsonEntrada["jsonSoapResponse"]["relatorio"]["codigo"];
        }
        

        //$jsonEntrada = json_decode($fixoJson, true);
        //var_dump($retorno);
    } 

    
    $operacao = "";
    $array = array();
   /* $arrayhd = array();
    $arraytr = array();
    $arraytl = array();
    $valor   = array();
    */
  

  

    $array = array("jsonSoapResponse" =>array(array(
        "nome_arquivo" => $nome_arquivo,
        "operacaoSol" => $operacaoSol,
        "codocorrencia" => $codocorrencia,
        "ocorrencia" => $ocorrencia)));


    
  //  $dados["dadosEntrada"] = array($array); 
    

    $jsonSaida = $array;
    
?>
