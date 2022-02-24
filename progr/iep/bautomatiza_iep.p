
def var vpropath as char.
input from /admcom/linux/propath no-echo.  /* Seta Propath */
import vpropath.
input close.

propath = vpropath.


    message time string(time,"HH:MM:SS") "remessa das " string(57300,"HH:MM:SS") "ate as" string(57900,"HH:MM:SS") 
            string(time >= 57300 and time <= 57900,"OK/---").

    message time string(time,"HH:MM:SS") "outras remessas das " string(43100,"HH:MM:SS") "ate as" string(43500,"HH:MM:SS") 
            string(time >= 43100 and time <= 43500,"OK/---").

    if time >= 57300 and time <= 57900
    then do:
        run iep/biepremessa.p ("REMESSA").
    end.    

    if time >= 43100 and time <= 43500
    then do:    
        run iep/biepremessa.p ("desistencia"). 
        run iep/biepremessa.p ("AUT.DESISTENCIA").  
        run iep/biepremessa.p ("CANCELAMENTO").  
        run iep/biepremessa.p ("AUT.CANCELAMENTO"). 
    end.
    

    message time string(time,"HH:MM:SS") "confirmacao a partir das " string(59100,"HH:MM:SS") "ate as " string(59700,"HH:MM:SS")
            string(time >= 59100 and time <= 59700,"OK/---").

    message time string(time,"HH:MM:SS") "retorno a partir das " string(44100,"HH:MM:SS") "ate as " string(45300,"HH:MM:SS")
            string(time >= 44100 and time <= 45300,"OK/---").
    
        
    if time >= 59100 and time <= 59700
    then do:
        run iep/biepretorno.p ("CONFIRMACAO").
    end.
 
    if time >= 44100 and time <= 45300
    then do:
        run iep/biepretorno.p ("RETORNO").
    end.

