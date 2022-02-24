/*************************INFORMA€OES DO PROGRAMA******************************
*  perfoest-cron.p
*  Versão Cron de perfoest.p
*  Antonio
* 
*******************************************************************************/

{admcab-batch.i}
def output parameter varqsai as char.

/*
{admcab.i new}
def var varqsai as char.
*/


def temp-table tt-verif-clase
    field clacod like clase.clacod.
    

def var vclase-cron-cod as int extent 10 format ">>9" initial
[260,1000,270,1456,1457,1487,1466,1472,1542,274].
def var vclase-cron-seq as int extent 10 initial
[1,2,3,4,5,6,7,8,9,10].

def buffer icategoria for categoria.
def buffer iclase for clase.

def var v-clase-cod like clase.clacod.
def var v-nivel-list as int.
def var v-clase-list as int.
def var v-clase-imp    as int.
def var varquivo as char.
def var vforcod like forne.forcod.
def var vfabcod like fabri.fabcod.
def var v-clanom like clase.clanom.
def var v-totcom    as dec.
def var v-ttmet     as dec.
def var v-totperc   as dec.
def var v-totalzao  as dec.
def var vhora       as char.
def var vok as logical.
def var vquant like movim.movqtm.
def var flgetb      as log.
def var vmovtdc     like tipmov.movtdc.
def var v-totaldia  as dec.
def var v-total     as dec.
def var v-totdia    as dec.
def var v-nome      like estab.etbnom.
def var d           as date.
def var j           as int.
def var i           as int.
def var v-qtd       as dec.
def var v-tot       as dec.
def var v-movtdc    like plani.movtdc.
def var v-dif       as dec.
def var v-valor     as dec decimals 2.
def var vetbcod     like plani.etbcod no-undo.
def var vetbcod2    like plani.etbcod no-undo.
def var v-totger    as  dec.
def new shared      var vdti as date format "99/99/9999" no-undo.
def new shared      var vdtf as date format "99/99/9999" no-undo.
def var p-vende     like func.funcod.
def var p-setor     like setor.setcod.
def var p-grupo     like clase.clacod.
def var p-clase     like clase.clacod.
def var p-clase1    like clase.clacod.
def var p-sclase    like clase.clacod.
def var v-titset    as char.
def var v-titgru    as char.
def var v-titcla    as char.
def var v-titscla   as char.
def var v-titvenpro as char.
def var v-titven    as char.
def var v-titpro    as char.
def var v-titproaux as char.

def var v-etccod    like estac.etccod.
def var v-carcod    like caract.carcod.
def var v-subcod    like subcaract.subcar.

def buffer sclase   for clase.
def buffer grupo    for clase.
def buffer clasup1 for clase.


def temp-table ttlista  no-undo
    field etbcod    like plani.etbcod
    field qtd       like movim.movqtm
    field clacod    like clase.clacod
    field nivel     as int
    field seqimp    as int.

def temp-table tt-lista-cla no-undo
    field etbcod    like plani.etbcod
    field clacod    like clase.clacod extent 10
    field qtd       like movim.movqtm extent 10.


for each ttlista:
    delete ttlista.
end.

for each tt-lista-cla:
   delete tt-lista-cla.
end.                                               
                                               
                                               
do on error undo:

        find first estab no-lock no-error.
        if avail estab then vetbcod = estab.etbcod.
        else vetbcod = 1.
                 
        find last estab no-lock no-error.
        if avail estab then vetbcod2 = estab.etbcod.
        else vetbcod2 = 99999.

        assign  vfabcod  = 0
                v-etccod = 0
                v-carcod = 0
                v-subcod = 0.

    for each ttlista : delete ttlista.  end.
    
    assign vdti = today - 7 vdtf = today.
    
    def var vdtini as date.
    def var vdtfin as date.
    def var vmes as i.
    def var vano as i.

    varquivo = "/admcom/relat-auto/" + string(day(today),"99") + "-" + 
                                   string(month(today),"99") + "-" + 
                                   string(year(today),"9999") +
        "/perfoestcron" +
        string(day(today),"99") + string(month(today),"99") +  
        string(year(today)) + "." + string(time).

    run calcesto.
    
    run imprime.

    leave.
end.
leave.
    
procedure calcesto.

for each estab where if vetbcod = 0
                     then true
                     else (estab.etbcod >= vetbcod and
                           estab.etbcod <= vetbcod2) no-lock.

  for each estoq where estoq.etbcod = estab.etbcod 
                     and estoq.estatual > 0 no-lock:
    
     find produ of estoq no-lock.
     
     if v-etccod > 0 and
        produ.etccod <> v-etccod
     then next.
        
     if v-carcod > 0 and 
        v-subcod > 0 and
        not can-find(first procar where procar.procod = produ.procod and
                                        procar.subcod = v-subcod)
     then next.                         


     if /*vfabcod*/ vforcod <> 0
     then if produ.fabcod <> /*vfabcod*/ vforcod then next.
    
     for each tt-verif-clase:
        delete tt-verif-clase.
     end.

     /* Verfica clase e niveis */
     
     find first sclase where sclase.clacod = produ.clacod no-lock  no-error.
     find first tt-verif-clase 
          where tt-verif-clase.clacod = sclase.clacod no-error.
     
     if avail tt-verif-clase then next.
     create tt-verif-clase.
     assign tt-verif-clase.clacod = produ.clacod.
 
     for each clase where clase.clacod = sclase.clasup no-lock:
         find first tt-verif-clase 
              where tt-verif-clase.clacod = clase.clacod no-error.
         if avail tt-verif-clase then next.
         create tt-verif-clase.
         assign tt-verif-clase.clacod = clase.clacod.
         for each clasup1 where clasup1.clacod = clase.clasup no-lock:
             find first tt-verif-clase 
                        where tt-verif-clase.clacod = clasup1.clacod no-error.
             if avail tt-verif-clase then next.
             create tt-verif-clase.
             assign tt-verif-clase.clacod = clasup1.clacod.
             for each grupo where grupo.clacod = clasup1.clasup no-lock:
                  find first tt-verif-clase where 
                             tt-verif-clase.clacod = grupo.clacod no-error.
                  if avail tt-verif-clase then next.
                  create tt-verif-clase.
                  assign tt-verif-clase.clacod = grupo.clacod.
             end.
         end.    
     end.
    
     assign v-clase-cod = ?
            v-nivel-list = ?
            v-clase-imp = ?.
     for each tt-verif-clase:
        do j = 1 to 10:
           if vclase-cron-cod[j]     = tt-verif-clase.clacod 
           then assign
                v-clase-cod          = tt-verif-clase.clacod
                v-clase-imp          = vclase-cron-seq[j] 
                v-nivel-list = 1. 
        end.
     end.    

     /***********************
     for each tt-verif-clase:
        disp tt-verif-clase.
     end.
     message "achei --> " produ.clacod  v-clase-cod view-as alert-box.
     ***********************/
   
    if v-clase-cod = ? then next.
        
            
    /************** GERANDO TEMP-LISTA **************/
    
    find first ttlista where ttlista.etbcod   = estoq.etbcod
                         and ttlista.clacod   = v-clase-cod
                         and ttlista.nivel    = v-nivel-list 
                         no-error.
    if not avail ttlista
    then do:
        create ttlista.
        assign ttlista.etbcod   = estoq.etbcod
               ttlista.clacod   = v-clase-cod
               ttlista.nivel    = v-nivel-list 
               ttlista.seqimp   = v-clase-imp.
    end.
                
    assign ttlista.qtd = ttlista.qtd + estoq.estatual.
         
  end.
end.


end procedure.

procedure imprime.

    for each ttlista :
        find first tt-lista-cla 
            where tt-lista-cla.etbcod = ttlista.etbcod no-error.
        if not avail tt-lista-cla
        then do:
            create tt-lista-cla.
            assign tt-lista-cla.etbcod = ttlista.etbcod.
            do j = 1 to 10:
                assign tt-lista-cla.clacod[j] = vclase-cron-cod[j]
                       tt-lista-cla.qtd[j] = 0.
            end.           
        end.
        do j = 1 to 10:
            if ttlista.clacod = tt-lista-cla.clacod[j] 
            then assign tt-lista-cla.qtd[j] = tt-lista-cla.qtd[j] 
                                                            + ttlista.qtd.
        end.
    end.

    {mdad.i
        &Saida     = "value(varquivo)"
        &Page-Size = "60"
        &Cond-Var  = "100"
        &Page-Line = "66"
        &Nom-Rel   = ""perfoest""
        &Nom-Sis   = """SISTEMA COMERCIAL"""
        &Tit-Rel   = """PERFOMANCE DE ESTOQUES """
        &Width     = "100"
        &Form      = "frame f-cabcab" }.

    for each tt-lista-cla by tt-lista-cla.etbcod :
        
        disp tt-lista-cla.etbcod 
             tt-lista-cla.qtd[1] column-label " 260"  
             tt-lista-cla.qtd[2] column-label "1000"  
             tt-lista-cla.qtd[3] column-label " 270"  
             tt-lista-cla.qtd[4] column-label "1456"  
             tt-lista-cla.qtd[5] column-label "1457"  
             tt-lista-cla.qtd[6] column-label "1487"  
             tt-lista-cla.qtd[7] column-label "1466"  
             tt-lista-cla.qtd[8] column-label "1472"  
             tt-lista-cla.qtd[9] column-label "1542"  
             tt-lista-cla.qtd[10] column-label " 274" 
         with frame fmost width 130 down.
                 
    end.
                
    output close.                
    varqsai = varquivo.

end procedure.


