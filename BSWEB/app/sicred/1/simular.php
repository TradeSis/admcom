<?php
    $username = "ADMCOM";
    $password = "LL908521";
  
    $novo_token = "sim";
    if (isset($parametro)) {
        $access_token = $parametro;    
        $novo_token = "nao";
    }
    $conteudo = $jsonEntrada["dados"][0];
    $simples = "nao";
    if (!isset($conteudo)) {
      $conteudo = $jsonEntrada;
      $simples = "sim";
    }

    $conteudoFormatado = json_encode($conteudo);
    

/*
   curl --location --request POST 'http://lebes-hml.k8s.lebes.com.br/auth/connect/token' \
   --header 'Content-Type: application/x-www-form-urlencoded' \
   --data-urlencode 'grant_type=password' \
   --data-urlencode 'username=BARRAMENTO' \
   --data-urlencode 'password=LL203104' \
   --data-urlencode 'scope=sicred.usuario' \
   --data-urlencode 'client_id=sicred-client' \
   --data-urlencode 'client_secret=5fb7c802-9b5a-46a8-b022-cec03327a7e9'
*/
    
  //echo "novo_token=".$novo_token."\n";
  
  //$hml = false;
       
  if ($novo_token == "sim") {
        
          if ($hml==true) {
            $service_url = 'http://lebes-hml.k8s.lebes.com.br/auth/connect/token';
          } else {
            $service_url = 'http://lebes-prod.k8s.lebes.com.br/auth/connect/token';
        
          }
          //echo "servidor=".$service_url."\n";
          // echo "username=".$username."\n";
          // echo "password=".$password."\n";
        

          $curl = curl_init($service_url);
          curl_setopt($curl, CURLOPT_POST, TRUE);
          curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
          
          curl_setopt($curl, CURLOPT_HTTPHEADER, array('Content-Type: application/x-www-form-urlencoded'));
          $fields =  "grant_type=password&username=".$username."&password=".$password;
          $fields .= "&scope=sicred.usuario&client_id=sicred-client";
          $fields .= "&client_secret=5fb7c802-9b5a-46a8-b022-cec03327a7e9";
          curl_setopt($curl, CURLOPT_POSTFIELDS,$fields);
          /*
          curl_setopt($curl, CURLOPT_POSTFIELDS, array(
            'grant_type' => 'password',
            'username' => $username,
            'password' => $password,
            'scope' => 'sicred.usuario',
            'client_id' => 'sicred-client',
            'client_secret' => '5fb7c802-9b5a-46a8-b022-cec03327a7e9'
           ));
          curl_setopt($curl, CURLOPT_HTTPHEADER, array(
            'Content-Type: application/json',
            'Content-Length: ' . strlen(array(
              'grant_type' => 'password',
              'username' => $username,
              'password' => $password,
              'scope' => 'sicred.usuario',
              'client_id' => 'sicred-client',
              'client_secret' => '5fb7c802-9b5a-46a8-b022-cec03327a7e9'
             )))
          );
          */
          //curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
        
          $data = curl_exec($curl);
          $info = curl_getinfo($curl);

          curl_close($curl);
          
          $data_obj = json_decode($data);
          //var_dump($data);
          //echo "\n";
          $access_token = $data_obj->{"access_token"};
          $expires_in   = $data_obj->{"expires_in"};
          
    }          
    //echo "\n". $access_token."\n";
    
        
    if ($hml==true) {
         $service_url = 'http://lebes-hml.k8s.lebes.com.br/simulacao/api/Simulacao/Calculadora';
    } else {
      $service_url = 'http://lebes-prod.k8s.lebes.com.br/simulacao/api/Simulacao/Calculadora';

    }
    //echo  "\n". $service_url."\n";
    //echo "\nconteudo\n";
    //var_dump($conteudoFormatado);
    //echo "\nconteudo\n";
    
    $host = parse_url($service_url);    
    //var_dump($host);
        
    $headers = array(
    "Content-Type: application/json",
    "Authorization: Bearer $access_token",
    "Host: " . $host['host'],
    "Content-Length: " . strlen($conteudoFormatado)    
    );

  /*  $post_params = array(
    'accessLevel' => 'View'
  );*/
    $payload = json_encode($post_params);

   // var_dump($payload);
  // var_dump($headers);
   
  $curl = curl_init($service_url);
  //curl_setopt( $curl, CURLINFO_HEADER_OUT, true);
 // curl_setopt( $curl, CURLOPT_POST, $payload);

  curl_setopt($curl, CURLOPT_POSTFIELDS, $conteudoFormatado);
  curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
  curl_setopt($curl, CURLOPT_HTTPHEADER, $headers );
  //curl_setopt($curl, CURLOPT_FAILONERROR, true);
  $curl_response = curl_exec($curl);
  
  //echo "\nRESPOSTA\n";
  //var_dump($curl_response);


  $info = curl_getinfo($curl);

  if (curl_errno($curl)) {
    $error_msg = curl_error($curl);
  }
  curl_close($curl); // close cURL handler

  $retorno = json_decode($curl_response,true);

  // var_dump($retorno);
  // echo $info['http_code'];
  
    if ($info['http_code']==200) {
      if ($simples == "nao") {
        if ($novo_token == "sim")
        {
            $jsonSaida =  array("retorno" => array("token" => array(array( "username"     => $username, 
                                                          "access_token" => $access_token, 
                                                          "expires_in"   => $expires_in)),
                                 "return" => json_decode($curl_response)) ); 
                                                          
        
        } else {
            $jsonSaida =  array("retorno" => array( "return" => json_decode($curl_response)) ); 
        
        
        }
                                                                                          

      } else {
        $jsonSaida     = json_decode($curl_response,true) ;

        $jsonSaida = $jsonSaida[0];

      }

    } else {
      $jsonSaida = json_decode(json_encode(
       array("status" => $info['http_code'],
             "erro"   => $retorno
            )
         ), TRUE);
    }
