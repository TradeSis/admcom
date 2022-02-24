
def var v-param as char.
def var v-ind as char.
def var v-etbcod like estab.etbcod.
def var v-funcod like func.funcod.
def var valor as dec.
def var vmodcod as char.
def var vtipo   as char.
v-param = os-getenv("contacor").
v-ind = substr(string(v-param),1,1).
v-etbcod = int(substr(string(v-param),2,3)).
v-funcod = int(substr(string(v-param),5,6)).
valor = int(substr(string(v-param),11,8)) / 100. 
vmodcod = substr(string(v-param),19,3).

if v-ind = "A"
then do on error undo:
    vtipo = substr(string(v-param),19,5).
end.

def var valor-cre as dec.
def var valor-deb as dec.
def buffer bcontacor for contacor.
def buffer dcontacor for contacor.

def buffer x-contacor for contacor.

def var vliberapp as char.
def var vtexto as char.
def var q as int.
def var vtotal as dec.
def var vpct as dec.

def temp-table tt-contacor like contacor.

if v-ind = "C" and  vmodcod = ""
then do:    
    for each contacor where contacor.natcor = no and
                        contacor.etbcod = v-etbcod and
                        contacor.clifor = ? and
                        contacor.funcod = v-funcod and
                        contacor.sitcor = "LIB" 
                        no-lock:
        if  contacor.campo3[1] = "COMPL" 
        then do:
            if contacor.datemi < 11/19/15
            then next.
            if month(contacor.datemi) = month(today) and
               year(contacor.datemi)  = year(today)
            then.
            else next.
        end.       
        create tt-contacor.
        buffer-copy contacor to tt-contacor.
    end.        
 
    vtexto = "VALOR;" + string(vtotal).
    put "@INICIO;" string(time) skip.
    put "#CONTACOR;" string(time) skip.
    q = 0.

    FOR EACH tt-contacor where tt-contacor.natcor = no and
                        tt-contacor.etbcod = v-etbcod and
                        tt-contacor.clifor = ? and
                        tt-contacor.funcod = v-funcod and
                        tt-contacor.sitcor = "LIB" 
                        no-lock
                        break 
                               by tt-contacor.campo3[1] desc
                               by tt-contacor.datemi.
                        /* By tipo de desconto */
 
        if first-of(tt-contacor.campo3[1])
        then do:
        
            assign vtotal = 0
                   vpct   = 0.             
        
        end.

        vtotal = vtotal + (tt-contacor.valcob - tt-contacor.valpag).

        if  last-of(tt-contacor.campo3[1])   
        then do:

            find first x-contacor
                 where x-contacor.natcor = yes and
                       x-contacor.etbcod = v-etbcod and
                                        x-contacor.clifor = ? and
                            x-contacor.funcod = v-funcod and
                            x-contacor.sitcor = "PAG"  and
                            x-contacor.modcod = "PCT"
                                no-lock no-error.
        if not avail x-contacor
        then find first x-contacor where x-contacor.natcor = yes and
                        x-contacor.etbcod = v-etbcod and
                        x-contacor.clifor = ? and
                        x-contacor.funcod = 0 and
                        x-contacor.sitcor = "PAG"  and
                        x-contacor.modcod = "PCT"
                        no-lock no-error.
        if not avail x-contacor
        then find first x-contacor where x-contacor.natcor = yes and
                        x-contacor.etbcod = 0 and
                        x-contacor.clifor = ? and
                        x-contacor.funcod = 0 and
                        x-contacor.sitcor = "PAG"  and
                        x-contacor.modcod = "PCT"
                        no-lock no-error.
        if avail x-contacor
        then do:
        
            case (tt-contacor.campo3[1]):
            
                when "EST"    then vpct = x-contacor.valcob.
                when "COMPL"  then vpct = x-contacor.campo2[1].
                otherwise vpct = 0.
            end case.
            
        end.
        else vpct = 0.
        assign q = q + 1.                   
        PUT unformatted vtotal " NAO " vpct " " tt-contacor.campo3[1] skip.
        end.
    end.
    put skip "@FIMCONTACOR;" string(q,"99999").    
    put skip "@FIMFIM;" + string(time) skip.
end.
else if v-ind = "C" and vmodcod = "LPP"
then do:
    vliberapp = "NAO".
    find first contacor where contacor.natcor = yes and
                        contacor.etbcod = v-etbcod and
                        contacor.clifor = 0 and
                        contacor.funcod = v-funcod and
                        contacor.sitcor = ""  and
                        contacor.modcod = "LPP"
                        no-lock no-error.
    if avail contacor
    then do:
        vtotal = contacor.campo1[1].
        vpct   = contacor.campo1[2].    

        if day(today) > contacor.campo1[1] and
           day(today) < contacor.campo1[2]
        then vliberapp = "SIM".
        else vliberapp = "NAO".
    end.
    else vliberapp = "NAO".
    
    put "@INICIO;" string(time) skip.
    put "#CONTACOR;" string(time) skip.
    q = 1.
    PUT unformatted vtotal " " vliberapp " " vpct  skip.
    put skip "@FIMCONTACOR;" string(q,"99999").    
    put skip "@FIMFIM;" + string(time) skip.
end.
else if v-ind = "A"  and
     valor > 0
then do:
    valor-cre = valor.
    valor-deb = 0.

    for each contacor where contacor.natcor = no and
                        contacor.etbcod = v-etbcod and
                        contacor.clifor = ? and
                        contacor.funcod = v-funcod and
                        contacor.sitcor = "LIB" /*   and
                        contacor.campo3[1] = vtipo*/
                        exclusive 
                        :

        if contacor.campo3[1] <> vtipo
        then next.
        
        if  contacor.campo3[1] = "COMPL" 
        then do:
            if contacor.datemi < 11/19/15
            then next.
            if month(contacor.datemi) = month(today) and
               year(contacor.datemi)  = year(today)
            then.
            else next.
        end. 

        if contacor.valcob - contacor.valpag >= valor-cre
        then do on error undo:
            contacor.valpag = contacor.valpag + valor-cre.
            valor-deb = valor-deb + valor-cre.
            create dcontacor.
            find last bcontacor  use-index ndx-7 where 
                  bcontacor.etbcod = v-etbcod
                  no-lock no-error.
            if not avail bcontacor
            then dcontacor.numcor = v-etbcod * 10000000.
            else dcontacor.numcor = bcontacor.numcor + 1.
            assign
                dcontacor.natcor = yes
                dcontacor.etbcod = v-etbcod
                dcontacor.funcod = v-funcod
                dcontacor.datemi = today
                dcontacor.datven = today
                dcontacor.valcob = valor-cre
                dcontacor.rec-titluc = ?
                dcontacor.rec-conta = recid(contacor)
            .
            valor-cre = 0.    
            if contacor.valcob = contacor.valpag
            then contacor.sitcor = "PAG".
            leave.
        end.
        else do on error undo:
            create dcontacor.
            find last bcontacor  use-index ndx-7 where 
                  bcontacor.etbcod = v-etbcod
                  no-lock no-error.
            if not avail bcontacor
            then dcontacor.numcor = v-etbcod * 10000000.
            else dcontacor.numcor = bcontacor.numcor + 1.
            assign
                dcontacor.natcor = yes
                dcontacor.etbcod = v-etbcod
                dcontacor.funcod = v-funcod
                dcontacor.datemi = today
                dcontacor.datven = today
                dcontacor.valcob = (contacor.valcob - contacor.valpag)
                dcontacor.rec-titluc = ?
                dcontacor.rec-conta = recid(contacor)
                .

            valor-cre = valor-cre - (contacor.valcob - contacor.valpag).
            valor-deb = valor-deb + (contacor.valcob - contacor.valpag).
            contacor.valpag = contacor.valpag +
                                   (contacor.valcob - contacor.valpag).
            if contacor.valcob = contacor.valpag
            then contacor.sitcor = "PAG".                           
        end.    
        if valor-cre = 0
        then leave.
    end.
    vtotal = 0.
    put "@INICIO;" string(time) skip.
    put "#CONTACOR;" string(time) skip.
    q = 1.
    PUT unformatted valor " SIM " vpct skip.
    put skip "@FIMCONTACOR;" string(q,"99999").    
    put skip "@FIMFIM;" + string(time) skip.
    PUT unformatted v-param "cre " valor-cre "deb " valor-deb skip.
    
end.
quit.

