pause 0 before-hide.
def var pPorta as int.
def var pHost  as char.

def var par-param as char.
 
par-param = SESSION:PARAMETER.

pPorta = int(entry(1, par-param)).
if pPorta = 0 or pPorta = ?
then pPorta = 23453.

{/admcom/barramento/socket.i}

DEFINE VARIABLE hServerSocket AS HANDLE.
DEFINE VARIABLE l-Ok          AS LOGICAL.


    def var mDados  as memptr.
    def var mAux    as memptr.
    def var lOK as log.
    def var iBytes  as int.
    def var hSocket as handle.
    def var cRetorno as char.
    def var lcEnvio   as longchar.
    def var lcRetorno as longchar.
    def var CEnvio as char.
    def var mEnvio as memptr.
    def var iTamenvio as int.
    def var cMetodo as char.
    def var iTamanho  as int.
    def var cStatus as char.

def var cModeloSocket as char.
 
CREATE SERVER-SOCKET hServerSocket.
hServerSocket:SET-CONNECT-PROCEDURE("serverSocket").
l-Ok = hServerSocket:ENABLE-CONNECTIONS( "-S " + string(pPorta)).

run logando("ENABLE-CONNECTIONS -S " + string(pPorta)).

IF NOT l-Ok THEN
 RETURN.
pause 0 before-hide.
REPEAT ON STOP UNDO, LEAVE ON QUIT UNDO, LEAVE:
    WAIT-FOR CONNECT OF hServerSocket.
    run logando("CONNECT " + string(hServerSocket)).
END.

run logando("FINALIZADO " + string(hServerSocket)).

hServerSocket:DISABLE-CONNECTIONS().
DELETE OBJECT hServerSocket.

MESSAGE "SERVER SOCKET FINALIZADO".



procedure serverSocket: 
    DEFINE INPUT PARAMETER hSocketx AS HANDLE NO-UNDO.
  

    hSocket = hSocketx.
    run logando("serverSocket " + string(hSocket)).
      
    IF NOT hsocket:CONNECTED()  
    THEN DO:  
        LEAVE.  
    END.  

    run logando("serverSocket " + string(hSocket) + " VAI Passo1").
    
    run Passo1.

    run logando("serverSocket " + string(hSocket) + " VOLTA Passo1").

    if cModeloSocket = "3PASSOS" or
       cModeloSocket = "PASSOSROBERTO"
    then do:   
        run logando("serverSocket " + string(hSocket) + " VAI Passo2 " + cModeloSocket).
        run Passo2.
        run logando("serverSocket " + string(hSocket) + " VOLTA Passo2 e VAI Passo 3" + cModeloSocket).

        run Passo3.
        run logando("serverSocket " + string(hSocket) + " VOLTA Passo3 " + cModeloSocket).
        
    end.      
   
   hSocket:DISCONNECT() NO-ERROR.
    DELETE OBJECT hSocket.
      
end procedure.



procedure Passo1.

/* PASSO 1 */
    run logando("serverSocket " + string(hSocket) + " PASSO1 - WAIT ").

    WAIT-FOR READ-RESPONSE OF hSocket.  

    run logando("serverSocket " + string(hSocket) + " PASSO1 - WAIT - FIM").

    run lerSocket ( input hSocket, 
                    input 128,  
                    output cRetorno).

    run logando("serverSocket " + string(hSocket) + " PASSO1 - cRetorno = " + cRetorno).

    cModeloSocket =  acha&("ModeloSocket" ,string(cRetorno)).     
    if cModeloSocket = "" or
       cModeloSocket = ?
    then cModeloSocket = "PASSOSROBERTO".    
    
    if cModeloSocket = "PASSOSROBERTO"
    then do:
        if num-entries(cRetorno,"&") > 1 and
           num-entries(CRetorno,"&") <= 3 
        then do:
            cMetodo = Entry(1,cRetorno,"&").
            iTamanho = int(Entry(2,Cretorno,"&")).
        end.
        else do:
            cModeloSocket = "DESCONHECIDO".         
            cMetodo  = "retorna".
            iTamanho = ?.
        end.     
    end.
    else do:
        cMetodo  =     acha&("METODO" ,string(cRetorno)).     
        iTamanho = int(acha&("TAMANHO",string(cRetorno))).
    end.
    
    
    if cMetodo <> ? and
       iTamanho <> ?
    then cEnvio = "STATUS=OK".   
    else do:
        cEnvio = "STATUS=ERRO".
        if cModeloSocket = "DESCONHECIDO"
        then do:
            cEnvio = cRetorno.
        end.
    end.     
   
    
    hide message no-pause.  
    run logando("serverSocket " + string(hSocket) + " POR=" + string(pPorta) + 
                " MOD=" + cModeloSocket +
                " MET=" + CMetodo +
                " TAM=" + string(ITamanho) +
                " ENT=" + CRetorno +
                " RET=" + CEnvio).
    
     
    if cModeloSocket = "3PASSOS" or
       cModeloSocket = "PASSOSROBERTO" or
       cModeloSocket = "DESCONHECIDO"
    then do:
        run escreverSocket (input  hSocket,
                            input  0,
                            input  cEnvio).
    end.
    else do:
        run lerSocketLong( input hSocket, 
                           input iTamanho, 
                           output lcRetorno).

        run logando("serverSocket " + string(hSocket) + " PASSO1 - REC Long" + "ENT=" + string(lcRetorno) ).
               
        RUN value("/admcom/barramento/metodos/" + cMetodo + ".p") 
                            (input lcRetorno, 
                            output lcEnvio) no-error.
        if error-status:error
        then do:
            lcEnvio = "ERRO".
            run logando("serverSocket " + string(hSocket) + " PASSO1 - RET Metodo=" + cmetodo + 
                    " ERRO EM " + "/admcom/barramento/metodos/" + cMetodo + ".p"  ).
        end.
        else do:
            run logando("serverSocket " + string(hSocket) + " PASSO1 - RET Metodo=" + cmetodo + 
                    " SAI="   ).
 
        end.
        /*
        cRetorno = string(lcRetorno).
        lcEnvio = cEnviar.
        */
        
        run escreverSocketLong (input  hSocket,
                                input  lcEnvio).
 
    end.
    run logando("serverSocket " + string(hSocket) + " PASSO1 - SAIDA").

            
end procedure.

procedure passo2.

    /* run logando("PASSO2 - WAIT " + "TAM=" + string(iTamanho) ).
    */
    WAIT-FOR READ-RESPONSE OF hSocket.  
    /*run logando("PASSO2 - VAI lerLong" + "TAM=" + string(iTamanho) ).
    */
    
    run lerSocketLong( input hSocket, 
                       input iTamanho, 
                       output lcRetorno).

    cRetorno = string(lcRetorno).  

    run logando("PASSO2 - REC Long" + "ENT=" + cRetorno ).
    
    RUN value("/admcom/barramento/metodos/" + cMetodo + ".p") 
                  (input lcRetorno, 
                   output lcEnvio).

/*    run logando("PASSO2 - RET Metodo=" + cmetodo + 
                " SAI=" + string(lcEnvio) ).*/
    
        
    copy-lob LCEnvio to mEnvio convert target codepage "utf-8".
    iTamEnvio = get-size(mEnvio).

    if cModeloSocket = "PASSOSROBERTO"
    then cEnvio = string(iTamEnvio).
    else cEnvio = "STATUS=OK&Tamanho=" + string(iTamEnvio).
    run escreverSocket (input  hSocket,
                        input  0,
                        input  cEnvio).
        
end procedure.


procedure Passo3.

    WAIT-FOR READ-RESPONSE OF hSocket.  
    
    run lerSocket ( input hSocket, 
                    input 0,
                    output cRetorno).
    cStatus  =     acha&("STATUS" ,string(cRetorno)).     
    
    
    run escreverSocketLong (input  hSocket,
                            input  lcEnvio).
    
end procedure.


procedure logando.
    def input param vlog as char.

/*    output to value("/admcom/barramento/socketservice_" + string(pPorta) + ".log") append.*/
    message
        today string(time,"HH:MM:SS") vlog.
/*    output close.*/

end procedure.
