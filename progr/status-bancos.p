/* GERA ARQUIVO DO STATUS DOS BANCOS PROGRAS */

connect ger -N tcp -S sdrebger -H db1.lebes.com.br no-error.
connect com -N tcp -S sdrebcom -H db1.lebes.com.br no-error.
connect fin -N tcp -S sdrebfin -H db1.lebes.com.br no-error.
connect adm -N tcp -S sadm -H db1.lebes.com.br    no-error.
connect nfe -N tcp -S sdrebnfe -H db1.lebes.com.br no-error.
connect suporte -N tcp -S sdrebsup -H db1.lebes.com.br no-error.
connect dragao -N tcp -S sdragao -H db1.lebes.com.br no-error.
connect ecommerce -N tcp -S sdrebecommerce -H db1.lebes.com.br no-error.
connect banfin -N tcp -S sbanfin -H db1.lebes.com.br no-error.
connect crm -N tcp -S sdrebcrm -H db1.lebes.com.br no-error.
/*connect itim -N tcp -S sitim -H db1.lebes.com.br no-error.*/
/*connect cyber -N tcp -S scyber -H db1.lebes.com.br no-error.*/


output to /admcom/logs/bancos-progress.log .

if connected ("ger")
then put  "GER     OK" skip.
else put  "GER     PROBLEMA" SKIP.
if connected ("com")
then put  "COM     OK" skip.
else put  "COM     PROBLEMA" SKIP.
if connected ("fin")
then put  "FIN     OK" skip.
else put  "FIN     PROBLEMA" SKIP.
if connected ("adm")
then put  "ADM     OK" skip.
else put  "ADM     PROBLEMA" SKIP.
if connected ("nfe")
then put  "NFE     OK" skip.
else put  "NFE     PROBLEMA" SKIP.
if connected ("suporte")
then put  "SUPORTE OK" skip.
else put  "SUPORTE PROBLEMA" SKIP.
if connected ("dragao")
then put  "DRAGAO OK" skip.
else put  "DRAGAO PROBLEMA" SKIP.
if connected ("ecommerce")
then put  "ECOMMERCE OK" skip.
else put  "ECOMMERCE PROBLEMA" SKIP.
if connected ("banfin")
then put  "BANFIN OK" skip.
else put  "BANFIN PROBLEMA" SKIP.
if connected ("crm")
then put  "CRM OK" skip.
else put  "CRM PROBLEMA" SKIP.
/*if connected ("itim")
then put  "ITIM OK" skip.
else put  "ITIM PROBLEMA" SKIP.*/
/*if connected ("cyber")
then put  "CYBER OK" skip.
else put  "CYBER PROBLEMA" SKIP.*/

output close.


/*** desconecta ***/

if connected ("ger")
then disconnect "ger".
if connected ("com")
then disconnect "com".
if connected ("fin")
then disconnect "fin".
if connected ("adm")
then disconnect "adm".
if connected ("nfe")
then disconnect "nfe".
if connected ("suporte")
then disconnect "suporte".
if connected ("dragao")
then disconnect "dragao".
if connected ("ecommerce")
then disconnect "ecommerce".
if connected ("banfin")
then disconnect "banfin".
if connected ("crm")
then disconnect "crm".
/*if connected ("itim")
then disconnect "itim".*/
/*if connected ("cyber")
then disconnect "cyber".*/

quit.

