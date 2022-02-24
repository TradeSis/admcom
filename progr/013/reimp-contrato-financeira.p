{admcab.i}

def var vcontnum like fin.contrato.contnum.

repeat:
    update vcontnum format ">>>>>>>>>9"
            at 4 with frame f-1 1 down side-label.

    find finmatriz.contrato where 
         finmatriz.contrato.contnum = vcontnum no-lock no-error.
    if not avail contrato
    then do:
        bell.
        message color red/with
        "Contrato não encontrado."
        view-as alert-box.
        next.
    end.
    find germatriz.clien where clien.clicod = contrato.clicod 
                    no-lock no-error.
    disp clien.clicod at 1
         clien.clinom no-label with frame f-1.

    sresp = no.

    message "Confirma emitir contrato?" update sresp.
    if sresp
    then run /srv/admcom/progr/contratoreimp.p(input recid(contrato)).
    
end.