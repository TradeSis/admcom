
<HTML>
<BODY>

<?php

include "prophp_config.php";

$command = $proexe . " " . " -T " . $tmp . " -pf " . $pf . " -b -p " . $projeto . $executa ;

$exportparametro = 
	"AMBIENTE=php export AMBIENTE; DLC=/usr/dlc export DLC; PROPATH=" . $projeto . " ; export PROPATH ";


$parametros = array ();

$i = 0;

$parametros = explode ( "!", $parametro );

for ( $i = 0; $i < count ( $parametros ); $i++ ) {
   $l = trim ( $parametros[$i] ); 
   $exportparametro .= $l . "=\"" . $$l . "\" export " . $l . "; " ;
}

// echo $exportparametro;

system($exportparametro . " " . $command . " >./x.php ");

include ("./x.php");

?>

</BODY>
</HTML>


