{admcab.i}     
def var tipo-atualiza as char format "x(70)" extent 10
    initial["Renegociacoes de Novacoes",
            "Contratos com Carteiras Trocadas (Rejeitados e outros)", 
            ""].    
        
            display tipo-atualiza no-label with frame 
                      f-atualiza centered.
            choose field tipo-atualiza with frame f-atualiza.
            hide frame f-atualiza no-pause.
            if frame-index = 1
            then run finct/relnegnov.p.
            if frame-index = 2
            then run finct/trocarini.p.
