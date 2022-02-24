{admcab.i}     
def var tipo-atualiza as char format "x(30)" extent 10
    initial["Relatorio de Credito Pessoal",
            "RESUMO MENSAL DE CAIXA",
            "RESUMO DAS LIQUIDACOES",
            "Exporta CSV pagamentos boleto",
            "Relatorio de Pagamentos Parciais",
            ""].    
        
            display tipo-atualiza no-label with frame 
                      f-atualiza centered.
            choose field tipo-atualiza with frame f-atualiza.
            hide frame f-atualiza no-pause.
            if frame-index = 1
            then run rel_cp_0119.p.
            if frame-index = 2
            then run cre02.p.
            if frame-index = 3
            then run resliq.p.
            
            if frame-index = 4
            then run fin/exppgmoeda.p.         
            if frame-index = 5 then run fin/relparcial.p.    
 