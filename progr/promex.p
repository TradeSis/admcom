{admcab.i}
DEF BUFFER BESTOQ FOR ESTOQ.
def var vprocod like produ.procod.
repeat:
    UPDATE vprocod with frame f1 side-label width 80.
    find produ where produ.procod = vprocod no-lock no-error.
    if not avail produ
    then do:
        message "Produto nao Cadastrado".
        undo, retry.
    end.
    disp produ.pronom no-label with frame f1.
    /*
    FIND FIRST BESTOQ WHERE BESTOQ.PROCOD = PRODU.PROCOD NO-LOCK.
    display BESTOQ.ESTPRODAT
            BESTOQ.ESTPROPER format ">,>>9.99"
                    with frame f2 centered side-label row 6.
    */
    for each estab no-lock,
        each estoq where estoq.etbcod = estab.etbcod and
                                 estoq.procod = produ.procod 
                                 no-lock:
                if estoq.estproper <> 0 and
                   estoq.estprodat > today
                then do:
                    disp estab.etbcod    column-label "Filial"
                         estoq.estvenda  column-label "Pr.Venda"
                         estoq.estproper column-label "Pr.Promo"
                         format ">>,>>9.99"
                         estoq.estbaldat column-label "DatIniVig"
                         estoq.estprodat column-label "DatFimVig"
                         with frame f-promoc down centered.        
                end.
    end.
    
    message "Confirma exclusao da Promocao" update sresp.
    if sresp
    then do:
        for each estab no-lock:
            for each estoq where estoq.etbcod = estab.etbcod and
                                 estoq.procod = produ.procod.
                
                estoq.datexp = today.
                estoq.estproper = 0.
                estoq.estprodat = ?.
                estoq.dtaltpromoc = today.

                find first hisprpro where 
                    hisprpro.procod = estoq.procod and
                    hisprpro.etbcod = estoq.etbcod and
                    hisprpro.Data_inicio = estoq.estbaldat and
                    hisprpro.data_fim    = estoq.estprodat
                    no-error.
                if not avail hisprpro
                then do:
                    create hisprpro.
                    ASSIGN 
                        hisprpro.preco_tipo = "F"
                        hisprpro.etbcod     = estoq.etbcod
                        hisprpro.procod     = estoq.procod
                        hisprpro.data_inicio = estoq.estbaldat
                        hisprpro.data_fim    = today
                        hisprpro.preco_valor = estoq.estproper
                        hisprpro.OFFER_ID    = ?
                        hisprpro.preco_plano  = estoq.tabcod
                        hisprpro.preco_parcela = estoq.estmin
                        hisprpro.PRICE_KEY  = program-name(1)
                        hisprpro.data_inclu = today
                        hisprpro.hora_inclu = time .
                end.
                else hisprpro.data_fim    = today.
            end.
        end.
    end.
end.
