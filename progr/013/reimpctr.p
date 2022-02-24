{admcab.i}

connect com -H erp.lebes.com.br -S sdrebcom -N tcp -ld
                    commatriz no-error.
connect fin -H erp.lebes.com.br -S sdrebfin -N tcp -ld
                    finmatriz no-error.
connect ger -H erp.lebes.com.br -S sdrebger -N tcp -ld
                    germatriz no-error.

if connected("finmatriz")
then do:
    run reimp-contrato-financeira.p.
end. 
disconnect commatriz.
disconnect finmatriz.
disconnect germatriz.
