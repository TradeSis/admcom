/* 30112021 helio retorno carteira */
{admcab.i}
def var vcobcodori  as int.
def var vcobcoddes  as int.

def var copcoes as char format "x(60)" extent 5 init 
     ["ARQUIVO PARA RETORNO PARA CARTEIRA LEBES (contrato completo)",
      "ARQUIVO ENVIO PARA A FINANCEIRA          (contrato completo)"       ,
     ""].
def var cmodo as char format "x(60)" extent 3 init
    ["Filtro","Arquivo csv","Digitar"].
disp
        copcoes
        with frame fop
        row 3 centered title "Escolha a Opcao" no-labels
        width 70.
choose field copcoes
    with frame fop.        

if frame-index = 1
then do:
    vcobcodori = ?.
    vcobcoddes = 1. /* Carteira Lebes */
end.    
if frame-index = 2
then do:
    vcobcodori = ?.
    vcobcoddes = 10. /* Carteira Lebes */
end.    

if frame-index = 1 or
   frame-index = 2
then do:
    run  finct/trocobdest.p (input vcobcodori, input vcobcoddes, input yes).
end.

hide frame fop no-pause.
hide frame fmod no-pause.
  