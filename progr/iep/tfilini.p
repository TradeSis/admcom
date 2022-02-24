/* 05012022 helio iepro */         
{admcab.i }

def var poperacao as char.
poperacao = "IEPRO".

def var vhostname as char.
def var xetbcod as int.
input through hostname.
import vhostname.
input close.

def var pclicod like clien.clicod.
def var premessa as int format ">>>>>>9".
.
def var copcoes as char format "x(60)" extent 15 init 
    [" contratos PARA remessas em cartorio         - IEPRO ",
     " contratos EM protesto em cartorio           - IEPRO ",
     " contratos BAIXADOS do cartorio              - IEPRO ",
     " contratos por remessa                       - IEPRO ",
     " contratos por cliente                       - IEPRO ",
     " consulta de contratos",
     "",
     " Negociacao de Clientes em Protesto",
     "",
     " Parametros de Campanhas para Protesto",
     
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
        row 3 centered title " - GESTAO DE PROTESTOS - " + poperacao no-labels
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
                           
        run iep/tatvstatus.p   (input poperacao,
                                input "ATIVO",                           
                                input trim(copcoes[iopcoes]),
                                input ?,
                                input ?).

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
                            input trim(copcoes[iopcoes]),
                            input ?,
                            input ?).


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
                            input trim(copcoes[iopcoes]),
                            input ?,
                            input ?).

end.
if iopcoes = 4
then do:
    update premessa
        with frame fremessa
        row 9 centered side-labels overlay.
    find titprotremessa where titprotremessa.operacao = poperacao and
                          titprotremessa.remessa  = premessa
            no-lock no-error.
    if not avail titprotremessa
    then do:
        message "remessa nao encontrada".
        undo.
    end.    
                                            
    run iep/tatvstatus.p   (input poperacao,
                            input "BAIXADO",                           
                            input "contratos remessa " + string(premessa) + " " + string(titprotremessa.dtinc,"99/99/9999") + " - IEPRO",
                            input ?,
                            input premessa).


end.
if iopcoes = 5
then do:
    update pclicod
        with frame fcli
        row 9 centered side-labels overlay.
    find clien where clien.clicod = pclicod no-lock no-error.
    if not avail clien
    then do:
        message "cliente nao cadastrado.".
         undo.
    end.     
                    
    run iep/tatvstatus.p   (input poperacao,
                            input "BAIXADO",                           
                            input "contratos " + caps(clien.clinom) + " - IEPRO",
                            input pclicod,
                            input ?).


end.

if iopcoes = 6
then do:
    run conco_v1701.p ("MENU").

end.

if iopcoes = 10
then do:
    run fin/novcampman.p (input "PRO").
end.

if iopcoes = 8
then do:
        xetbcod = setbcod.

        if vhostname = "SV-CA-DB-DEV" or
           vhostname = "SV-CA-DB-QA"
        then message vhostname "Altera a Filial para Simular" update setbcod.
        find estab where estab.etbcod = setbcod no-lock.
        pause 0.
        display trim(caps(wempre.emprazsoc)) + " / " + trim(caps(estab.etbnom))
         + "-" + trim(if avail func then func.funnom else "")
                    @  wempre.emprazsoc
                    wdata with frame fc1.
        pause 0.


        hide frame f-regua1 no-pause.
        hide frame f1 no-pause.
        hide frame f2 no-pause.
        hide frame f3 no-pause.
        hide frame f4 no-pause.
        hide frame f5 no-pause.
        
        run iep/novnegocia.p (?).
        
        setbcod = xetbcod.
        find estab where estab.etbcod = setbcod no-lock.
        pause 0.
        display trim(caps(wempre.emprazsoc)) + " / " + trim(caps(estab.etbnom))
         + "-" + trim(if avail func then func.funnom else "")
 
                    @  wempre.emprazsoc
                    wdata with frame fc1.
        pause 0.




end.

end.

hide frame fop no-pause.
hide frame fmod no-pause.
  