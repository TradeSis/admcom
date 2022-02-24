/* 05012022 helio iepro */
{admcab.i new}
def var poperacao as char.
poperacao = "IEPRO".

def var copcoes as char format "x(60)" extent 5 init 
    [" cockpit de remessa para protesto em cartorio IEPRO ",
     " cockpit de parcelas em protesto em cartorio  IEPRO ",
     " parcelas baixadas do protesto              - IEPRO ",
     
     ""].
def var iopcoes as int.

def var cmodo as char format "x(20)" extent 6 init
    ["Filtro","Arquivo csv","Digitar","Remessa","Rejeitados","Atualizar"].
def var imodo as int.    

def var cstatus as char format "x(20)" extent 4 init
    ["TODOS",
     "ATUALIZAR",
     "",
     "" ].
                                                        
def var istatus as int.    


def var cstatusPG as char format "x(30)" extent 4 init
    ["DESISTENCIA",
     "CANCELADO",
     "PAGO LEBES",
     "PAGO CARTORIO"].
                                                        
def var istatusPG as int.    



repeat.

disp
        copcoes
        with frame fop
        row 3 centered title " - GESTAO DE PROTESTOS - " no-labels
        width 70.
choose field copcoes
    with frame fop.        
iopcoes = frame-index.


if iopcoes = 1
then do: 
    disp
        cmodo
        with frame fmod
        row 9 centered title "Escolha a forma de entrada de dados" no-labels
                overlay.
    choose field cmodo
        with frame fmod.
    imodo = frame-index.

    if imodo = 6
    then do:

        run iep/tremstatus.p (input poperacao,
                              input "ATUALIZAR", 
                              input "ATIVO", /* Ativos */
                              input trim(copcoes[iopcoes])).

    end.
    else
    if imodo = 5
    then do:

        run iep/tremstatus.p (input poperacao,
                              input "CONFIRMACAO", 
                              input "REJEITADO", /* Nao Ativo ainda */
                              input trim(copcoes[iopcoes])).

    end.
    else
    if imodo = 4
    then do:

        run iep/tremstatus.p (input poperacao,
                              input "REMESSA", 
                              input "", /* Nao Ativo ainda */
                              input trim(copcoes[iopcoes])).

    end.
    else do:
        hide frame fmod no-pause.
    
        run iep/tfilrem.p (input poperacao,
                           input trim(copcoes[iopcoes]),
                           input trim(cmodo[imodo])).

        run iep/tremstatus.p (input poperacao,
                           input "REMESSA", 
                           input "", /* nao ativo ainda */
                           input trim(copcoes[iopcoes])).
    end.    
end.


if iopcoes = 2
then do: 

    /*
    disp
        cstatus
        with frame fstatus
        row 9 centered title "Escolha o STATUS" no-labels
                width 80
                overlay.
    choose field cstatus
        with frame fstatus.
    istatus = frame-index.
    hide frame fstatus no-pause.
    */
    run iep/tatvstatus.p   (input poperacao,
                            input "ATIVO",                           
      /*                      input cstatus[istatus], */
                            input trim(copcoes[iopcoes])).


end.

if iopcoes = 3
then do: 

    /*disp
        cstatusPG
        with frame fstatusPG
        row 9 centered title "Escolha o STATUS" no-labels
                width 80
                overlay.
    choose field cstatusPG
        with frame fstatusPG.
    istatusPG = frame-index.
    hide frame fstatusPG no-pause.

    run iep/tpgstatus.p (input poperacao,
                           input trim(cstatuspg[istatuspg]), 
                           input trim(copcoes[iopcoes])).
    */
    run iep/tatvstatus.p   (input poperacao,
                            input "BAIXADO",                           
      /*                      input cstatus[istatus], */
                            input trim(copcoes[iopcoes])).

end.




end.

hide frame fop no-pause.
hide frame fmod no-pause.
  