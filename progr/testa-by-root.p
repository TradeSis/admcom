{admcab.i new}


repeat:

    find last a01_infnfe where a01_infnfe.etbcod = 993
                           and a01_infnfe.serie = "1"
                                exclusive-lock no-error no-wait.
                                
    if locked a01_infnfe
    then do:
                                    
        display "Locked".
        pause 0.
                                    
    end.
    else do:
    
    
        display a01_infnfe.numero.
        pause 0.
    
    end.
                                

end.