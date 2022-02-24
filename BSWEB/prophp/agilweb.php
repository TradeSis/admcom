<?php

include "prophp_config.php";
function getvar($varname) {
        $v=(isset($_GET[$varname]))?$_GET[$varname]:((isset($_POST[$varname]))?$_POST[$varname]:'');
        if(!$v) $v = $_SESSION[$varname];
        else $_SESSION[$varname] = $v;
        return($v);
}
$parametro=getvar('parametro');
$executa=getvar('executa');

$command = $proexe . " " . " -T " . $tmp . " -pf " . $pf . " -b -p " . $projeto . $executa ;

$exportparametro = 
        "AMBIENTE=php export AMBIENTE; DLC=/usr/dlc export DLC; PROPATH=" . $projeto . " export PROPATH ; ";


$parametros = array ();

$i = 0;

$parametros = explode ( "!", $parametro );

for ( $i = 0; $i < count ( $parametros ); $i++ ) {
        $l = trim ( $parametros[$i] ); 
        $x = getvar($l); 
        $exportparametro .= $l . "=\"" . $x . "\" export " . $l . "; " ;
}


system($exportparametro . " " . $command);

?>


