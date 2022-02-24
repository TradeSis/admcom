
def var vpropath as char.
input from /admcom/linux/propath no-echo.  /* Seta Propath */
import vpropath.
input close.

propath = vpropath.


    message "remessas".
    message time string(time,"HH:MM:SS") "remessa ate as" string(57600,"HH:MM:SS") .
    message time string(time,"HH:MM:SS") "outras ate as" string(43500,"HH:MM:SS") .

    if true or time <= 57900 /* 16:00:00 */
            or time <= 43500
    then do:
        run iep/biepremessa.p.
    end.
    

    message "retornos".
    message time string(time,"HH:MM:SS") "confirmacao a partir das " string(59400,"HH:MM:SS") .
    message time string(time,"HH:MM:SS") "retorno a partir das" string(44100,"HH:MM:SS") .
        
    if true or time >= 59399 /*16:30:00*/
            or time >= 44099
    then do:
        run iep/biepretorno.p.
    end.
 

