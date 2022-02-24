{admcab.i}     
def var tipo-atualiza as char format "x(40)" extent 10
    initial["-", /*"Parametros Novacao de Campanha", */
            "Parametros Limites por Area",
            "Parametros De boletos",
            "parametros de Validacao Sicred",
            "Planos para HubSeg",
            ""].    
        
            display tipo-atualiza no-label with frame 
                      f-atualiza centered 1 col.
            choose field tipo-atualiza with frame f-atualiza.
            hide frame f-atualiza no-pause.
            /*if frame-index = 1    retirado em 26/10/2021 ID 94590 
            then run fin/novcamp.p. */ 
            if frame-index = 2
            then run fin/limarea.p.
            if frame-index = 3
            then run fin/estboleto.p.
            if frame-index = 4
            then run fin/opesicparam.p.
            if frame-index = 5
            then run seg/segplanprodu.p.
            
 