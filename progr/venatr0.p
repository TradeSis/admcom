{admcab.i}
message "Conectando...".
connect dragao -H erp.lebes.com.br -S sdragao -N tcp -ld d.

hide message no-pause.
              
run venatr.p.

if connected ("d") 
then disconnect d.
               
