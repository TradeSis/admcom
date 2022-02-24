/*
Motor de Credito
*/
{admcab.i}

def var mopcao as char extent 3 format "x(25)" init
    [ "Neurotech - Acessos","Logs de Acoes WS","Comportamento"].

repeat with frame f-neuclien side-label 2 col centered
    1 down row 3.
    prompt-for neuclien.cpfcnpj.
    if input neuclien.cpfcnpj > 0
    then do.
        find neuclien where neuclien.cpfcnpj = input neuclien.cpfcnpj
                      no-lock no-error.
    end.
    else do.
        prompt-for neuclien.clicod.
        if input neuclien.clicod > 0
        then find neuclien where neuclien.clicod = input neuclien.clicod
                           no-lock no-error.
    end.
    if not avail neuclien
    then do:
        message "NEUCLIEN nao encontrado".
        next.
    end.

    repeat.
        find clien where clien.clicod = neuclien.clicod no-lock no-error.
         
        disp 
            NeuClien.CpfCnpj
            NeuClien.Clicod
            clien.clinom when avail clien
            NeuClien.VlrLimite
            NeuClien.VctoLimite
            with frame f-neuclien.

        disp mopcao with frame f-opcao centered no-label 1 col row 8.
        choose field mopcao with frame f-opcao.

        hide frame f-opcao no-pause.
        if frame-index = 1 or frame-index = 2
        then hide frame f-neuclien no-pause.
             
        if frame-index = 1
        then run neuro/cdneuproposta.p (recid(neuclien)).
        else if frame-index = 2
        then run neuro/cdneuclienlog.p (recid(neuclien)).
        else if frame-index = 3
        then run neuro/mostra_comportamento.p (recid(neuclien)).
    end.
end.
hide frame f-neuclien no-pause.
