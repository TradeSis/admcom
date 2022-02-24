{admcom_funcoes.i}      

def buffer bclien for clien.

def var vcalclim as dec.
def var vpardias as dec.
def var vdisponivel as dec.

def var vtip-parc  as log format  "Abertas/Fechadas" initial yes. 
def var vdescricao as char.
def var icont as int.
def var vcrmlimite as dec.

def var vcomp-produtos as char.
def var vcomp-classes as char.
def var vcomp-fabricantes as char.
def var vncomp-produtos as char.
def var vncomp-classes as char.
def var vncomp-fabricantes as char.
def shared var vconta        as int.

def buffer tt-fabricantes for crmfabricantes.
def buffer tt-produtos    for crmprodutos.
def buffer tt-classes     for crmclasses.

def var vcatcod like produ.catcod.
def var vncatcod like produ.catcod.

def var v-data-compr-ini as date.
def var v-data-compr-fim as date.

def var v-val-min-compra as decimal.
def var v-val-max-compra as decimal.
def var v-qtd-min-compra as integer.
def var v-qtd-max-compra as integer.
def var v-add-classe-fabri as logical format "Sim/Nao".

def var vdtini as date.
def var vdtfin as date.
def var vpar-aber as logical format "Sim/Nao".
def var vdia-fil1 as int label "Dia Inicial de Aniversario" format "99".
def var vdia-fil2 as int label "Dia Final   de Aniversario" format "99".
def var vmes-fil1 as int .
def var vmes-fil2 as int .
def var vano-nasc1 as int label "Ano de Nascimento Inicial " format "9999".
def var vano-nasc2 as int label "Ano de Nascimento Final   " format "9999".

def var vrfv as char format "x(3)".
def var vok  as log.
def var vok2 as log.
def var v-indi-mostra as log format "Sim/Nao" init no.
def var v-indi-achou as log.
def shared var vetbcod like estab.etbcod.

def var vperc as dec format ">>9.99%".

def var vrec as i format "9".
def var vfre as i format "9".
def var vval as i format "9".

def var varquivo as char.
def var vtotqtd as integer format ">>>>>>>>>>>>9".

def var vcont-vezes as integer initial 0 no-undo.

def shared var vri as date format "99/99/9999" extent 5.
def shared var vrf as date format "99/99/9999" extent 5.

def shared var vfi as inte extent 5 format ">>>>>>>9".
def shared var vff as inte extent 5 format ">>>>>>>9".

def shared var vvi as dec format ">>>,>>9.99" extent 5.
def shared var vvf as dec format ">>>,>>9.99" extent 5.


def shared var i as i format ">>>>>>>>>>>>9".

def shared temp-table tt-filtro
    field descricao  as char format "x(30)"
    field considerar as log  format "Sim/Nao"
    field tipo       as char
    field tecla-p    as char
    field log        as log  format "Sim/Nao"
    field data       as date format "99/99/9999" extent 2
    field dec        as dec  extent 2
    field int        as int  extent 2
    field etbcod     like estab.etbcod
    index ietbcod  etbcod.

def buffer ztt-filtro for tt-filtro. 

def buffer crm for ncrm.

def  shared temp-table tt-cidade
    field cidade as char
    field marca  as log format "*/ "
    index icidade is primary unique cidade.

def shared temp-table tt-produ
    field procod like produ.procod
    field pronom like produ.pronom
    index iprocod is primary unique procod.
        
def shared temp-table tt-clase
    field clacod like clase.clacod
    field clanom like clase.clanom
    index iclase is primary unique clacod.

def shared temp-table tt-plano
    field fincod like finan.fincod
    field finnom like finan.finnom
    index iplano is primary unique fincod.

def shared temp-table tt-nplano
    field fincod like finan.fincod
    field finnom like finan.finnom
    index iplano is primary unique fincod.

def shared temp-table tt-forne
    field forcod like forne.forcod
    field fornom like forne.fornom
    index iforcod is primary unique forcod.
    
/** nao compraram **/
def shared temp-table tt-nprodu
    field procod like produ.procod
    field pronom like produ.pronom
    index iprocod is primary unique procod.

def shared temp-table tt-nclase
    field clacod like clase.clacod
    field clanom like clase.clanom
    index iclase is primary unique clacod.

def shared temp-table tt-nforne
    field forcod like forne.forcod
    field fornom like forne.fornom
    index iforcod is primary unique forcod.
    
/***/
 
def shared temp-table tt-bairro
    field bairro as char
    field marca  as log format "*/ "
    index ibairro is primary unique bairro.

def  shared temp-table tt-estciv
    field estciv as int
    field descricao as char
    field marca  as log format "*/ "
    index iestciv is primary unique estciv.

def shared temp-table tt-profissao
    field profissao as char
    field marca  as log format "*/ "
    index iprofissao is primary unique profissao.

def shared temp-table rfvtot
    field rfv   as int format "999"
    field recencia   as char format "x(7)"
    field frequencia as char format "x(7)"
    field valor      as char format "x(7)"
    field qtd-ori   as int
    field qtd-sel   as int
    field flag  as log format "*/ "
    field per-tot   as dec format ">>9.99%"
    field etbcod  like estab.etbcod
    field lim-credito as dec
    field lim-disponivel as dec
    index irfv-asc as primary unique rfv etbcod
    index irfv-des rfv descending
    index iqtd-asc qtd-ori
    index iqtd-des qtd-ori descending
    index ietbcod etbcod
    index iflagetb flag etbcod.

def new shared temp-table tt-dados
    field parametro as char
    field valor     as dec
    field valoralt  as dec
    field percent   as dec
    field vcalclim  as dec
    field operacao  as char format "x(1)" column-label ""
    field numseq    as int
    index dado1 numseq.

def buffer b-rfvtot for rfvtot.

def var iregs           as inte   initial 0       no-undo.
def var dPctTotal       as dec format ">>9.99%"   no-undo.     

def var recatu1         as recid.
def var recatu2         as recid.
def var reccont         as int.
def var esqpos1         as int.
def var esqpos2         as int.
def var esqregua        as log.
def var esqvazio        as log.
def var esqascend     as log initial yes.

/**
def var vordem as char extent 4  format "x(24)"
                init["1. R  F  V - Ascending  ",
                     "2. R  F  V - Descending ",
                     "3. QTD ORI - Ascending  ",
                     "4. QTD ORI - Descending "].
                     
def var vordenar as integer.

def var esc-fil as char format "x(27)" extent 3
    initial ["  Dados do Cliente         ",
             "  Cliente comprou ...      ",
             "  Cliente nao comprou ...  "].

**/

def var esqcom1         as char format "x(15)" extent 5
    initial [" Selecionar "," "," ", " ",""].

def var esqcom2         as char format "x(14)" extent 5
            initial ["  ",
                     "  ",
                     "  ", 
                     "  ",
                     " "].

{admcab.i}

 def var temlib as log initial no.
def buffer btitulo for titulo.
                    def temp-table tt-titulo
                        field clifor like titulo.clifor
                        field temlib as log initial no
                        index idx1 clifor.  

def buffer brfvtot       for rfvtot.
def var vrfvtot         like rfvtot.rfv.
def shared var vetbcodfin  like estab.etbcod. 

def var mc-aberto as dec.
def var md-aberto as dec.
def var pc-paga as dec.
def var vl-pontual as dec.
def var vlimcre-de as dec.
def var vlimcre-ate as dec.
def var vcrepre-de as dec.
def var vcrepre-ate as dec.
def var vpctpre-mais as dec.
def var vparpag as int.
def var vpontual as int.

def var vaumento-lim as logical format "Percentual/Valor" initial yes. 
def var vperc-aumento as dec.
def var vval-aumento as dec.
def var vlim-antigo as dec.
def var vlim-aux    as dec.

form vlimcre-de at 4 label "Limite de Credito de"
     vlimcre-ate validate(vlimcre-de <= vlimcre-ate,"")  label "Ate"
     vcrepre-de at 1 label "Credito Pre Aprovado de"
     vcrepre-ate validate(vcrepre-de <= vcrepre-ate,"") label "Ate"
     vpctpre-mais    label "+ % "
     vparpag    at 1 label "Parcelas Pagas acima de"
     vpontual   at 8 label "Pontual acima de"
     with frame f-limcre side-label width 70 row 10 centered
     overlay.
 
form
    esqcom1
    with frame f-com1
                 row 4 no-box no-labels side-labels column 1 centered.
form
    esqcom2
    with frame f-com2
                 row screen-lines no-box no-labels side-labels column 1
                 centered.
assign
    esqregua = yes
    esqpos1  = 1
    esqpos2  = 1.

def var vdescri as char.
def var vtipo  as char.
def var vtecla-p as char.

/* Busca Cadastro de Tipos de Filtros */
def input parameter par-tipofiltro as char.

def var arq-ini as char.
if opsys = "UNIX"
then arq-ini = "/admcom/progr/infc.ini".
else arq-ini = "l:~\progr~\infc.ini".
input from value(arq-ini).
repeat.
    import vdescri vtipo vtecla-p.
    find first tt-filtro where
        tt-filtro.tipo      = vtipo and
        tt-filtro.descricao = vdescri no-error.
    if not avail tt-filtro
    then do:
        create tt-filtro.
        tt-filtro.descricao = vdescri.
        tt-filtro.tipo      = vtipo.
        tt-filtro.considerar = no.
        assign
            tt-filtro.tecla-p    = if vtecla-p = "P" then "%" else "".
    end.
end.
input close.    

if par-tipofiltro = "PRODUTO" or
   par-tipofiltro = "NAOCOMP"
then do:
    vdtini = vri[1].
    vdtfin = vrf[5].

    update vdtini label "Periodo "  "a" vdtfin no-label
        with frame fper row 12 overlay side-labels centered.
        hide frame fper no-pause.
    assign
    vri[1] = vdtini
    vrf[5] = vdtfin
    v-data-compr-ini = vdtini
    v-data-compr-fim = vdtfin.
 end.


recatu1 = ?.


bl-princ:
repeat:
    
    disp esqcom1 with frame f-com1.
    disp esqcom2 with frame f-com2.
    
    if recatu1 = ?
    then
        run leitura (input "pri").
    else do:
        find tt-filtro where recid(tt-filtro) = recatu1 no-lock.
    end.
        
    if not available tt-filtro
    then esqvazio = yes.
    else esqvazio = no.
    
    clear frame frame-a all no-pause.
    
    if not esqvazio
    then do:
        run frame-a.
    end.

    recatu1 = recid(tt-filtro).
    
    if esqregua
    then color display message esqcom1[esqpos1] with frame f-com1.
    else color display message esqcom2[esqpos2] with frame f-com2.
    
    if not esqvazio
    then repeat:
        run leitura (input "seg").
    
        if not available tt-filtro
        then leave.
        
        if frame-line(frame-a) = frame-down(frame-a)
        then leave.
        down
            with frame frame-a.
        
        run frame-a.
        
    end.

    if not esqvazio
    then up frame-line(frame-a) - 1 with frame frame-a.

    repeat with frame frame-a:

        if not esqvazio
        then do:
            find tt-filtro where recid(tt-filtro) = recatu1 no-lock.
            
            run p-total.

            run color-message.
            
            choose field 
                tt-filtro.descricao
                         help ""
                go-on(cursor-down cursor-up
                      cursor-left cursor-right
                      page-down   page-up
                      tab PF4 F4 ESC return).

            run color-normal.
            
            status default "".

        end.
            if keyfunction(lastkey) = "TAB"
            then do:
                if esqregua
                then do:
                    color display normal esqcom1[esqpos1] with frame f-com1.
                    color display message esqcom2[esqpos2] with frame f-com2.
                end.
                else do:
                    color display normal esqcom2[esqpos2] with frame f-com2.
                    color display message esqcom1[esqpos1] with frame f-com1.
                end.
                esqregua = not esqregua.
            end.
            if keyfunction(lastkey) = "cursor-right"
            then do:
                if esqregua
                then do:
                    color display normal esqcom1[esqpos1] with frame f-com1.
                    esqpos1 = if esqpos1 = 5 then 5 else esqpos1 + 1.
                    color display messages esqcom1[esqpos1] with frame f-com1.
                end.
                else do:
                    color display normal esqcom2[esqpos2] with frame f-com2.
                    esqpos2 = if esqpos2 = 5 then 5 else esqpos2 + 1.
                    color display messages esqcom2[esqpos2] with frame f-com2.
                end.
                next.
            end.
            if keyfunction(lastkey) = "cursor-left"
            then do:
                if esqregua
                then do:
                    color display normal esqcom1[esqpos1] with frame f-com1.
                    esqpos1 = if esqpos1 = 1 then 1 else esqpos1 - 1.
                    color display messages esqcom1[esqpos1] with frame f-com1.
                end.
                else do:
                    color display normal esqcom2[esqpos2] with frame f-com2.
                    esqpos2 = if esqpos2 = 1 then 1 else esqpos2 - 1.
                    color display messages esqcom2[esqpos2] with frame f-com2.
                end.
                next.
            end.
            if keyfunction(lastkey) = "page-down"
            then do:
                do reccont = 1 to frame-down(frame-a):
                    run leitura (input "down").
                    if not avail tt-filtro
                    then leave.
                    recatu1 = recid(tt-filtro).
                end.
                leave.
            end.
            if keyfunction(lastkey) = "page-up"
            then do:
                do reccont = 1 to frame-down(frame-a):
                    run leitura (input "up").
                    if not avail tt-filtro
                    then leave.
                    recatu1 = recid(tt-filtro).
                end.
                leave.
            end.
    
            if keyfunction(lastkey) = "cursor-down"
            then do:
                run leitura (input "down").
                if not avail tt-filtro
                then next.
                color display white/red
                              with frame frame-a.
                if frame-line(frame-a) = frame-down(frame-a)
                then scroll with frame frame-a.
                else down with frame frame-a.
            end.
            
            if keyfunction(lastkey) = "cursor-up"
            then do:
                run leitura (input "up").
                if not avail tt-filtro
                then next.
                color display white/red 
                                        with frame frame-a.
                if frame-line(frame-a) = 1
                then scroll down with frame frame-a.
                else up with frame frame-a.
            end.
 
        if keyfunction(lastkey) = "end-error"
        then leave bl-princ.

        if keyfunction(lastkey) = "return"
        then do:
            form rfvtot
                 with frame f-rfvtot color black/cyan
                      centered side-label row 5 .
            hide frame frame-a no-pause.
            if esqregua
            then do:
                display caps(esqcom1[esqpos1]) @ esqcom1[esqpos1]
                        with frame f-com1.

                if esqcom1[esqpos1] = " Selecionar "
                then do with frame frame-a on error undo.
                    recatu2 = recatu1.
                    update tt-filtro.considerar.
                    if tt-filtro.considerar
                    then do:
                        
                        if (trim(tt-filtro.descricao) = "FABRICANTE"
                            or trim(tt-filtro.descricao) = "DEPARTAMENTO"
                            or trim(tt-filtro.descricao) = "CLASSE"
                            or trim(tt-filtro.descricao) = "CARTAO LEBES")
                            and tt-filtro.tipo <> "NAOCOMP"
                        then do:
                        
                            update v-val-min-compra label "Valor de "  "at�"                                      v-val-max-compra no-label
                               with frame fval row 12 overlay
                                     side-labels centered title "Insira uma faixa de valores de compra.".
                            hide frame fval no-pause.

                            update v-qtd-min-compra label "Valor de "  "at�"
                                   v-qtd-max-compra no-label
                                        with frame fqtd row 12 overlay
                                     side-labels centered title "Insira a quantidade comprada m�nima e m�xima para o filtro.".
                            hide frame fqtd no-pause.

                        end.
                        else assign v-val-min-compra = 0
                                    v-val-max-compra = 0
                                    v-qtd-min-compra = 0
                                    v-qtd-max-compra = 0.
                        
                        run p-filtro-considerar.
                    
                    end.
                    
                    if keyfunction(lastkey) = "end-error"
                    then do:
                        if tt-filtro.descricao = "PRODUTO"
                        then do:
                            find first tt-produ where
                                   tt-produ.procod > 0 no-lock no-error.
                            if not avail tt-produ
                            then do:
                                tt-filtro.considerar = no.
                                next bl-princ.
                            end.    
                        end.
                        else do:           
                            tt-filtro.considerar = no.
                            next bl-princ.
                        end.
                    end.
                    pause 0.
                    run p-nova-rfv.
                    pause 0.
                    run p-total.
                    pause 0.

                    
                    recatu1 = recatu2.    
                    leave.
                end.
                /**
                if esqcom1[esqpos1] = " Filtrar "
                then do with frame frame-a on error undo.
                    recatu2 = recatu1.

                    run p-filtro-considerar.

                    if keyfunction(lastkey) = "end-error"
                    then do:
                        if tt-filtro.descricao = "PRODUTO"
                        then do:
                            find first tt-produ where
                                   tt-produ.procod > 0 no-lock no-error.
                            if not avail tt-produ
                            then do:
                                tt-filtro.considerar = no.
                                next bl-princ.
                            end.    
                        end.
                        else do:           
                            tt-filtro.considerar = no.
                            next bl-princ.
                        end.
                    end.
                    pause 0.
                    run p-nova-rfv.
                    pause 0.
                    run p-total.
                    pause 0.
                    
                    recatu1 = recatu2.    
                    leave.
                end.
                **/
                
            end.
            else do:
                display caps(esqcom2[esqpos2]) @ esqcom2[esqpos2]
                        with frame f-com2.
                if esqcom2[esqpos2] = "  "
                then do:
                    hide frame f-com1  no-pause.
                    hide frame f-com2  no-pause.
                    /* run programa de relacionamento.p (input ). */
                    view frame f-com1.
                    view frame f-com2.
                end.
                
                leave.
            end.
        end.
        if not esqvazio
        then do:
            run frame-a.    
        end.
        if esqregua
        then display esqcom1[esqpos1] with frame f-com1.
        else display esqcom2[esqpos2] with frame f-com2.
        recatu1 = recid(tt-filtro).
    end.
    if keyfunction(lastkey) = "end-error"
    then do:
        view frame fc1.
        view frame fc2.
    end.
end.
hide frame f-com1  no-pause.
hide frame f-com2  no-pause.
hide frame frame-a no-pause.

procedure frame-a.
    display 
        tt-filtro.descricao
        tt-filtro.considerar
            with frame frame-a col 2 11 down color white/red row 5
            no-box.
            
end procedure.

procedure color-message.

    /*
    vperc = 0.
    vperc = ((rfvtot.qtd-ori * 100) / i).
    color display message
                  rfvtot.flag    column-label "*"
                  /*rfvtot.rfv column-label "R F V"*/
                         rfvtot.recencia
                         rfvtot.frequencia
                         rfvtot.valor
                  
                  
                  rfvtot.per-tot /*vperc*/
                  rfvtot.qtd-ori column-label "QTD ORI"
                  rfvtot.qtd-sel column-label "QTD SEL"
                  with frame frame-a.
    */
    
end procedure.

procedure color-normal.
    /*
    vperc = 0.
    vperc = ((rfvtot.qtd-ori * 100) / i).
    color display normal
                  rfvtot.flag    column-label "*"
                  /*rfvtot.rfv column-label "R F V"*/

                         rfvtot.recencia
                         rfvtot.frequencia
                         rfvtot.valor
                  
                  
                  rfvtot.per-tot /*vperc*/
                  rfvtot.qtd-ori column-label "QTD ORI"
                  rfvtot.qtd-sel column-label "QTD SEL"
                  with frame frame-a.
    */
    
end procedure.


procedure leitura.

    def input parameter par-tipo as char.
            
    if par-tipo = "pri"
    then do: 
        if esqascend
        then do:
            find first tt-filtro where
                tt-filtro.tipo = par-tipofiltro no-lock no-error.
        end.     
        else do: 
            find last tt-filtro where
                tt-filtro.tipo = par-tipofiltro no-lock no-error.
        end.
    end.                                         
                                             
    if par-tipo = "seg" or par-tipo = "down" 
    then do:
        if esqascend  
        then do:
            find next tt-filtro where
                tt-filtro.tipo = par-tipofiltro no-lock no-error.
        end.            
        else do: 
            find prev tt-filtro where
                tt-filtro.tipo = par-tipofiltro no-lock no-error.
        end.            
    end.
             
             
    if par-tipo = "up" 
    then do:
        if esqascend   
        then do:  
            find prev tt-filtro where
                tt-filtro.tipo = par-tipofiltro no-lock no-error.
        end.
        else do:
            find next tt-filtro where
                tt-filtro.tipo = par-tipofiltro no-lock no-error.
        end.
    end.        
        
end procedure.

procedure p-nao-libera:

    message " Procedimento ainda nao esta liberado" view-as alert-box.

end procedure.

procedure p-total.

    assign vtotqtd = 0.
    
    for each brfvtot where 
             brfvtot.flag = yes and
             brfvtot.etbcod = if vetbcod = 0
                              then brfvtot.etbcod
                              else vetbcod:
        vtotqtd = vtotqtd + brfvtot.qtd-sel.
        
    end.
    pause 0.
    disp skip(3)
         "      TOTAL GERAL" skip
         space(4)   i       no-label skip(2)
            
         "TOTAL SELECIONADO" skip
         space(4)   vtotqtd no-label skip

         with frame f-tot col 60 no-box overlay row 7.

end procedure.


procedure p-nova-rfv:
 def var vloop                 as int.
 def var vmens2                as char.
 def var vtime                 as int.
 def var vcha-filtro-anterior  as character.

 vmens2 = " F I L T R A N D O   *    *    *    *    *    *    *    *    *    *"
        + "   *    *".

vtime = time.
vmens2 = fill(" ",80 - length(vmens2)) + trim(vmens2) .

/* Antonio */
                
find first tt-filtro where tt-filtro.considerar and
                           tt-filtro.descricao = "LIMITE DE CREDITO"
                           no-error.
if avail tt-filtro
then do:
    sresp = no.
    message "Processar Limite Disponivel? " update sresp.
end.
 
/**/

 /*message "Filtrando Clientes...".*/

sresp = yes.
 
if vconta > 0
then message "Deseja que esse filtro seja aplicado sobre o resultado do filtro 
anterior?" update sresp.

if sresp or vconta = 0     
then for each b-rfvtot.
         b-rfvtot.qtd-sel = 0.
     end.

 
 
 assign vcont-vezes = vcont-vezes + 1.
 
 assign vcha-filtro-anterior = par-tipofiltro. 
 
 /***
 find first tt-filtro where tt-filtro.considerar
            and  tt-filtro.descricao = "LIMITE DE CREDITO"
                        no-error.
 if avail tt-filtro 
 then do:
            connect dragao -H "erp.lebes.com.br" -S sdragao -N tcp -ld dragao.
 end.
 ***/
  
  
 for each b-rfvtot where 
          b-rfvtot.flag   = yes and
          b-rfvtot.etbcod = if vetbcod = 0
                            then b-rfvtot.etbcod 
                            else vetbcod:
    /*      
    b-rfvtot.qtd-sel = 0.    
    */
    for each crm where 
             crm.rfv    = b-rfvtot.rfv and
             crm.etbcod = if vetbcod = 0
                          then crm.etbcod
                          else vetbcod:

        crm.mostra = yes.
        vconta = vconta + 1.
        
        find clien where clien.clicod = crm.clicod no-lock no-error.
        if not avail clien then next.
        if clien.estciv = 6
        then do:
            crm.mostra = no.
            next.
        end.    
        
        for each tt-filtro:
        
            /***/
            vloop = vloop + 1. 

            if vloop > 199
            then do: 
                put screen color normal    row 16  column 1 vmens2.
                put screen color messages  row 17  column 20 /*15*/
                " Decorridos : " + string(time - vtime,"HH:MM:SS") 
                + " Minutos    ".
             
                vmens2 = substring(vmens2,2,78) + substring(vmens2,1,1).
                vloop = 0.
            end.
        
            /**/
        
            if tt-filtro.considerar
            then do: /*Filtra*/
                
                if tt-filtro.descricao = "LIMITE DE CREDITO"
                 then do:
                    if sresp then run Pi-Processa-Limite.
                    vcrmlimite = crm.limite.
                    if sfuncod = 101 and (crm.clicod = 10812957 or
                                          crm.clicod = 12385057)
                    then message 999 crm.clicod vcrmlimite vlimcre-de vlimcre-ate vcalclim vdisponivel view-as alert-box.   
                    /***
                    if sfuncod = 101 and crm.clicod = 11307857
                    then message "111" crm.clicod vcrmlimite view-as alert-box.
                    vcrmlimite = limite-cred-scor(recid(clien)).
                    if sfuncod = 101 and crm.clicod = 11307857
                    then message "222" crm.clicod vcrmlimite view-as alert-box.
                    ***/
                    if vlimcre-ate > 0
                    then do:   
                    /*** 10/11/2009
                        if  vcrmlimite >= vlimcre-de and
                            vcrmlimite <= vlimcre-ate
                        then.
                        else crm.mostra = no.
                    ***/
                        if vdisponivel >= vlimcre-de and
                           vdisponivel <= vlimcre-ate
                        then .
                        else crm.mostra = no.
                    end.
                    /* antonio */
                    if crm.mostra = no then next.
                    /**/
                    if  vcrepre-ate > 0 or
                        vparpag > 0 or
                        vpontual > 0
                    then do:
                        run stcrecli.p(input crm.clicod,
                                       input 36,
                                       output mc-aberto,
                                       output md-aberto,
                                       output pc-paga,
                                       output vl-pontual).
                                                         
                        if vpctpre-mais > 0
                        then mc-aberto = mc-aberto + 
                            (mc-aberto * (vpctpre-mais / 100)).
                        
                        if vcrepre-ate > 0
                        then do:    
                            if mc-aberto >= vcrepre-de and
                               mc-aberto <= vcrepre-ate
                            then.
                            else crm.mostra = no.       
                        end.
                        if vparpag > 0
                        then do:   
                            if pc-paga >= vparpag
                            then.
                            else crm.mostra = no.
                        end.
                        if vpontual > 0
                        then do:
                            if vl-pontual >= vpontual
                            then.
                            else crm.mostra = no.   
                        end.
                        /* antonio */
                        if crm.mostra = no then next.
                        /**/
            
                    end.   
                end.    

                /* Antonio - Filtros de Cartao Lebes - Sol 26846 */  
                if tt-filtro.descricao = "CARTAO EMITIDO"
                then do:
                    find first tbcartao where tbcartao.codoper = 999 and
                                              tbcartao.clicod = clien.clicod
                                                    no-lock no-error.
                    if not avail tbcartao 
                    then crm.mostra = no.
                    else if tbcartao.situacao <> "E" 
                          /* and tbcartao.situacao <> "L"  */
                    then crm.mostra = no.
                    /* antonio */
                    if crm.mostra = no then next.
                    /**/
                 end.
                /**/
                if tt-filtro.descricao = "CARTAO LIBERADO"
                then do:
                         find first tbcartao where tbcartao.codoper = 999 
                                          and tbcartao.clicod = clien.clicod
                                          no-lock no-error.
                        if not avail tbcartao 
                        then crm.mostra = no.
                        else if tbcartao.situacao <> "L" then crm.mostra = no.
                        /* antonio */
                        if crm.mostra = no then next.
                        /**/
                end.
                /**/

                if tt-filtro.descricao = "TIPOS DE PARCELAS" and
                   tt-filtro.considerar = yes
                then do:
                        v-indi-mostra = no.
                    
                                                                  
                  for each fin.btitulo where
                              fin.btitulo.clifor = crm.clicod no-lock:

           if btitulo.titsit <> "LIB" and btitulo.titsit <> "PAG" then next.

                if btitulo.titsit = "LIB" then
                temlib = yes.
                if btitulo.titsit = "PAG" then
                temlib = no.

                             
            find first tt-titulo where tt-titulo.clifor = btitulo.clifor no-lock no-error.

            if not avail tt-titulo then do:  
                        create tt-titulo.
                        assign tt-titulo.clifor = btitulo.clifor 
                               tt-titulo.temlib = temlib.                                   end. 
             else do: 
                   if temlib = yes and tt-titulo.temlib = yes then leave.      
                   if temlib = no  and tt-titulo.temlib = yes then leave.
                   assign tt-titulo.temlib = temlib .                                       end.
              
      end.                       
                                       
                    for each fin.titulo where 
                             fin.titulo.clifor = crm.clicod no-lock:
                           
                   find first tt-titulo where tt-titulo.clifor = fin.titulo.clifor no-lock no-error.
                   if not avail tt-titulo then next.
        
                        if fin.titulo.titpar <> 0
                        then do:
                            
                           if vtip-parc = no and tt-titulo.temlib = no /* Fechadas*/                                                then do:
                                if fin.titulo.titsit = "PAG"                                                     then assign v-indi-mostra = yes.
                           end.  

                            /* Parametro Leitura Aberta */
                           if vtip-parc = yes  and tt-titulo.temlib = yes /* Abertas */
                           then do:
                               if fin.titulo.titsit = "LIB" 
                               then assign v-indi-mostra = yes.
                           end.   
                       end.
                    end.     
                    if v-indi-mostra = no 
                    then crm.mostra = no.

                    /* antonio */
                    if crm.mostra = no then next.
                    /**/
                end.

                /**/
                if tt-filtro.descricao = "SEXO"
                then do:
                    if crm.sexo <> tt-filtro.log
                    then crm.mostra = no.
                    
                    /* antonio */
                    if crm.mostra = no then next.
                    /**/
                      
                    /*
                    find first crmclidado where
                        crmclidado.clicod = crm.clicod and
                        crmclidado.NOMEdado = tt-filtro.descricao
                        no-lock.
                    if not avail crmclidado
                    then crm.mostra = no.
                    else do:
                        if crmclidado.VALORdado <> tt-filtro.VALORdado
                        then crm.mostra = no.
                    end.
                    */
                    
                end.

                if tt-filtro.descricao = "FAIXA DE IDADE"
                then do:
                    if crm.idade >= tt-filtro.int[1] and
                       crm.idade <= tt-filtro.int[2]
                    then.
                    else crm.mostra = no.
                    /* antonio */
                    if crm.mostra = no then next.
                    /**/
                end.
                if tt-filtro.descricao = "MES DE ANIVERSARIO"
                then do:
                    if crm.mes-ani >= tt-filtro.int[1] and
                       crm.mes-ani <= tt-filtro.int[2]
                    then.
                    else crm.mostra = no.
                    /* antonio */
                    if crm.mostra = no then next.
                     /**/
                end.
                /* antonio */
                if tt-filtro.descricao = "DIA DE ANIVERSARIO" 
                then do:
                                                           
                    if (int(day(clien.dtnasc)) < vdia-fil1) or
                       (int(day(clien.dtnasc)) > vdia-fil2)                                          then do:   
                       assign crm.mostra = no.
                       next.
                    end.
                end.    
                           
                if tt-filtro.descricao = "ANO DE NASCIMENTO"
                then do:
                     if vano-nasc1 < int(year(clien.dtnasc)) or
                        vano-nasc2 > int(year(clien.dtnasc))
                        then do:
                           assign crm.mostra = no.
                           next.
                        end.     
                end.
                /**/
                
                if tt-filtro.descricao = "COM DEPENDENTES"
                then do:
                    if not crm.dep
                    then crm.mostra = no.
                    /* antonio */
                    if crm.mostra = no then next.
                     /**/
                end.
                if tt-filtro.descricao = "POSSUI CELULAR"
                then do:
                    if not crm.celular
                    then crm.mostra = no.
                    /* antonio */
                    if crm.mostra = no then next.
                    /**/
                end.    
                if tt-filtro.descricao = "TIPO DE RESIDENCIA"
                then do:
                    if crm.residencia <> tt-filtro.log
                    then crm.mostra = no.
                    /* antonio */
                    if crm.mostra = no then next.
                    /**/
                end.
                if tt-filtro.descricao = "POSSUI CARRO"
                then do:
                    if not crm.carro
                    then crm.mostra = no.
                    /* antonio */
                    if crm.mostra = no then next.
                    /**/
                end.
                if tt-filtro.descricao = "CONSIDERAR SPC"
                then do:
                    if crm.spc
                    then crm.mostra = no.
                    else do:

                        find last fin.clispc where 
                                  fin.clispc.clicod = crm.clicod 
                                  no-lock no-error.
                        if avail fin.clispc and
                             fin.clispc.dtcanc = ?
                        then crm.mostra = no.                  
                    
                    end.
                    /* antonio */
                    if crm.mostra = no then next.
                    /**/

                end.
                if tt-filtro.descricao = "POSSUI E-MAIL"
                then do:
                    if not crm.email
                    then crm.mostra = no.
                    /* antonio */
                    if crm.mostra = no then next.
                    /**/
                end.
                if tt-filtro.descricao = "RENDA MENSAL"
                then do:
                    if crm.renda-mes >= tt-filtro.dec[1] and
                       crm.renda-mes <= tt-filtro.dec[2]
                    then.
                    else crm.mostra = no.
                    /* antonio */
                    if crm.mostra = no then next.
                    /**/
                end.
                if tt-filtro.descricao = "RENDA TOTAL"
                then do:
                    if crm.renda-tot >= tt-filtro.dec[1] and
                       crm.renda-tot <= tt-filtro.dec[2]
                    then.
                    else crm.mostra = no.
                    /* antonio */
                    if crm.mostra = no then next.
                    /**/
                end.
                
                if tt-filtro.descricao = "ELEGIVEIS CARTAO"
                THEN DO:
                    if crm.spc
                    then crm.mostra = no.
                    else do:

                        find last fin.clispc where 
                                  fin.clispc.clicod = crm.clicod 
                                  no-lock no-error.
                        if avail fin.clispc and
                             fin.clispc.dtcanc = ?
                        then crm.mostra = no.                  
                    
                    end.
                    if crm.mostra = yes
                    then do:
                        run crm20-car1.p (input crm.clicod,
                                      input-output crm.mostra).
                    end.
                END.
                if tt-filtro.descricao = "CIDADE"
                then do:
                    find tt-cidade where tt-cidade.cidade = crm.cidade
                                         no-error.
                    if avail tt-cidade
                    then do:
                        if not tt-cidade.marca 
                        then crm.mostra = no.
                    end.
                    else crm.mostra = no.
                   /* antonio */
                    if crm.mostra = no then next.
                   /**/
                end.

                if tt-filtro.descricao = "BAIRRO"
                then do:
                    find tt-bairro where tt-bairro.bairro = crm.bairro
                                         no-error.
                    if avail tt-bairro
                    then do:
                        if not tt-bairro.marca 
                        then crm.mostra = no.
                    end.
                    else crm.mostra = no.
                    /* antonio */
                    if crm.mostra = no then next.
                    /**/
                end.
                
                if tt-filtro.descricao = "PROFISSAO"
                then do:
                    find tt-profissao where 
                         tt-profissao.profissao = crm.profissao no-error.
                    if avail tt-profissao
                    then do:
                        if not tt-profissao.marca 
                        then crm.mostra = no.
                    end.
                    else crm.mostra = no.
                    /* antonio */
                    if crm.mostra = no then next.
                    /**/
                end.
                
                if tt-filtro.descricao = "ESTADO CIVIL"
                then do:
                    find tt-estciv where tt-estciv.estciv = crm.est-civ
                                         no-error.
                    if avail tt-estciv
                    then do:
                        if not tt-estciv.marca 
                        then crm.mostra = no.
                    end.
                    else crm.mostra = no.
                    /* antonio */
                    if crm.mostra = no then next.
                    /**/
                end.
                
                if tt-filtro.descricao = "AUMENTO DE LIMITE"
                then do:
                
                    assign  vcalclim    = 0
                            vpardias    = 0
                            vdisponivel = 0
                            crm.mostra  = no
                            vlim-antigo = 0
                            vlim-aux    = 0.
                    
                    if not connected("dragao")
                    then
                    connect dragao -H "erp.lebes.com.br" -S sdragao -N tcp
                              -ld dragao.

                    run calccredscore.p (input string(crm.etbcod),
                                         input recid(clien),
                                         output vcalclim,
                                         output vpardias,
                                         output vdisponivel).
                
                    if connected ("dragao")
                    then disconnect dragao.

                    assign vcalclim = round(vcalclim,2).
                    
                    /*
                    vcalclim = crm.limite.
                    */
                    
                    bl_busca_limite:
                    for each plani where plani.movtdc = 5
                                     and plani.desti = clien.clicod
                                            no-lock by plani.movtdc
                                                    by plani.desti
                                                    by plani.pladat desc:
                        
                        if acha ("limite-credito" , plani.notobs[1]) <> ""
                        then do:
                        
                            assign vlim-antigo
                               = dec(acha("limite-credito" , plani.notobs[1])).
                            
                            if vaumento-lim
                            then assign vlim-aux = vlim-antigo
                                    + (vlim-antigo * vperc-aumento / 100).
                            else assign vlim-aux = vlim-antigo + vval-aumento.
                             
                            if vcalclim > 0
                                and vcalclim >= vlim-aux
                            then crm.mostra = yes.

                            leave bl_busca_limite.
                                
                        end.             

                    end.
                    
                end.
                
                if tt-filtro.tipo = "PRODUTO"
                then do:
                    vok = yes.
                    run p-compras-cli (input crm.clicod,
                                       input vetbcod,
                                       input v-data-compr-ini,
                                       input v-data-compr-fim,
                                       input v-val-min-compra,
                                       input v-val-max-compra,
                                       input v-qtd-min-compra,
                                       input v-qtd-max-compra,
                                       input tt-filtro.descricao,
                                       output vok).
                    if not vok
                    then crm.mostra = no.
                    /* antonio */
                    if crm.mostra = no then next.
                    /**/
                end.
                
                if tt-filtro.tipo = "NAOCOMP"
                then do:

                    vok2 = yes.
                    run p-nao-comprou (input crm.clicod,
                                       input vetbcod,
                                       input vri[1],
                                       input vrf[5],
                                       input tt-filtro.descricao,
                                       output vok2).
                
                    if not vok2
                    then crm.mostra = no.
                    /* antonio */
                    if crm.mostra = no then next.
                    /**/
                    
                end.

            end.

        end.
        
        if crm.mostra = no
        then next.

        /* b-rfvtot.qtd-sel = b-rfvtot.qtd-sel + 1.    */
        
    end.

    for each crm where 
             crm.mostra = yes and
             crm.rfv    = b-rfvtot.rfv and
             crm.etbcod = if vetbcod = 0
                          then crm.etbcod
                          else vetbcod:

        b-rfvtot.qtd-sel = b-rfvtot.qtd-sel + 1.    

    end.   
    hide message no-pause.
    put screen row 15  column 1 fill(" ",80).
    put screen row 16  column 1 fill(" ",80). 
    put screen row 17  column 1 fill(" ",80).
end.

if connected ("dragao") 
then disconnect dragao.
 
 
end procedure.

procedure p-compras-cli:
    
    def input parameter p-clicod like clien.clicod.
    def input parameter p-etbcod like estab.etbcod.
    def input parameter p-dti as date format "99/99/9999".
    def input parameter p-dtf as date format "99/99/9999".
    def input parameter p-val-min-compra as decimal.
    def input parameter p-val-max-compra as decimal.
    def input parameter p-qtd-min-compra as integer.
    def input parameter p-qtd-max-compra as integer.
    def input parameter p-descricao as char.
    def output parameter p-ok as log.
    def var vdt-aux as date format "99/99/9999".
    def var cont    as integer.
    def var somaqtd as integer.
        
    /***/
    for each plani use-index plasai
           where plani.movtdc = 5
             and plani.desti  = p-clicod no-lock:
  
            if plani.pladat < p-dti or
               plani.pladat > p-dtf
            then next.
            
            if vetbcod <> 0
            then if plani.etbcod <> vetbcod
                 then next.
            
            if trim(p-descricao) = "FABRICANTE"
                or trim(p-descricao) = "DEPARTAMENTO"
                or trim(p-descricao) = "CLASSE"
                or trim(p-descricao) = "CARTAO LEBES"
            then do:
            
                if (p-val-min-compra >= 0 and p-val-max-compra > 0)
                    and (plani.platot < p-val-min-compra
                          or plani.platot > p-val-max-compra)
                then do:

                    next.

                end.
                                                    
            end.
            
            if p-descricao = "PLANO DE PAGAMENTO"
            then do:
                find first tt-plano
                     where tt-plano.fincod = plani.PedCod
                                      no-lock no-error.
                if not avail tt-plano
                then next.
            end.
            
            if trim(p-descricao) = "CARTAO LEBES"
            then do:
            
                if decimal(acha("cartao-lebes" , plani.notobs[1])) = 0
                then next.

            end.
            
            assign somaqtd = 0.
            
            for each movim where movim.etbcod = plani.etbcod
                             and movim.placod = plani.placod
                             and movim.movtdc = plani.movtdc
                             and movim.movdat = plani.pladat no-lock:
                
                find produ where produ.procod = movim.procod no-lock no-error.
                if not avail produ
                then next.
                
                if vcatcod <> 0 and produ.catcod <> vcatcod
                then next.

                /*** Compraram ***/
                if p-descricao = "PRODUTO"
                then do:
                    find first tt-produ 
                         where tt-produ.procod = produ.procod
                                                 no-lock no-error.
  
                    if not avail tt-produ
                    then next.
                end.

                if p-descricao = "DEPARTAMENTO"
                then do:

                     if vcatcod <> 0 and produ.catcod = vcatcod
                     then do:
                          cont = cont + 1.
                          leave.
                     end.
                     
                end.

                if p-descricao = "FABRICANTE"
                then do:
                    find first tt-forne
                         where tt-forne.forcod = produ.fabcod
                                                 no-lock no-error.
                    if not avail tt-forne
                    then next.
                    
                    if v-add-classe-fabri
                    then do:
                    
                        find first tt-clase
                             where tt-clase.clacod = produ.clacod
                                                 no-lock no-error.
                        if not avail tt-clase
                        then next.
                    
                    end.
                    
                end.
                if p-descricao = "CLASSE"
                then do:
                    find first tt-clase
                         where tt-clase.clacod = produ.clacod
                                                 no-lock no-error.
                    if not avail tt-clase 
                    then next.
                end.
                
                assign somaqtd = somaqtd + movim.movqtm.
                
            end.
            
            if (p-qtd-min-compra >= 0 and p-qtd-max-compra > 0)
            then do:
            
                if somaqtd >= p-qtd-min-compra and somaqtd <= p-qtd-max-compra
                then assign cont = cont + 1.
            
            end.
            else do:
            
                if somaqtd > 0
                then assign cont = cont + 1.
            
            end.
            
    end.
    /****/
    
/*    cont = 0.    redundancia */
/*****
    if p-descricao = "PRODUTO" or p-descricao = "DEPARTAMENTO"
    then do: 
        for each tt-produ:
            find first tt-produtos where 
                       tt-produtos.clicod = crm.clicod 
                   and tt-produtos.procod = tt-produ.procod no-error.
            if avail tt-produtos
            then assign cont = cont + 1.
        end.
    end.
    
    
    if p-descricao = "FABRICANTE" 
    then do: 
        for each tt-forne:
            find first tt-fabricantes where
                       tt-fabricantes.clicod = crm.clicod
                   and tt-fabricantes.fabcod = tt-forne.forcod no-error.
            if avail tt-fabricantes
            then assign cont = cont + 1.
        end.
    end.
    
    
    if p-descricao = "CLASSE"
    then do:
        for each tt-clase:
            find first tt-classes where
                       tt-classes.clicod = crm.clicod
                   and tt-classes.clacod = tt-clase.clacod no-error.    
            if avail tt-classes
            then assign cont = cont + 1.
        end.
    end.                                   

*********/    
    
    if cont > 0 
    then p-ok = yes.
    else p-ok = no.
    
end procedure.

/***/

procedure p-nao-comprou:
    def input parameter p-clicod like clien.clicod.
    def input parameter p-etbcod like estab.etbcod.
    def input parameter p-dti as date format "99/99/9999".
    def input parameter p-dtf as date format "99/99/9999".
    def input parameter p-descricao as char.
    def output parameter p-ok2 as log init yes.
    def var vdt-aux as date format "99/99/9999".
    def var cont as int.
     
    def var v-log as log init yes.
    

    /****/
    bl_plani:
    for each plani use-index plasai
           where plani.movtdc = 5
             and plani.desti  = p-clicod no-lock:
             
            if plani.pladat < vri[1] or
               plani.pladat > vrf[5]
            then next bl_plani.
 
         /*   
            if vetbcod <> 0
            then if plani.etbcod <> vetbcod
                 then next.
            */
            
            if p-descricao = "PLANO DE PAGAMENTO"
            then do:
            
                find first tt-nplano
                     where tt-nplano.fincod = plani.PedCod
                                    no-lock no-error.
                /*
                message " Plano: " plani.PedCod " Avail: " avail tt-nplano.
                */
                if avail tt-nplano
                then do:
                
                    assign p-ok2 = no.
                    return.
                
                end.
            end.
            
            for each movim where movim.etbcod = plani.etbcod
                             and movim.placod = plani.placod
                             and movim.movtdc = plani.movtdc
                             and movim.movdat = plani.pladat no-lock:
                find produ where produ.procod = movim.procod no-lock no-error.
                if not avail produ
                then next.

                if vncatcod <> 0 and produ.catcod <> vncatcod
                then next.
         
                if vncatcod <> 0 and produ.catcod = vncatcod
                 and p-descricao = "DEPARTAMENTO"
                 then do:
                      v-log = no.
                      p-ok2 = no.
                      end.
                
                /*** Nao Compraram ***/
                if p-descricao = "PRODUTO" or p-descricao = "DEPARTAMENTO"
                then do:
                    find first tt-nprodu 
                         where tt-nprodu.procod = produ.procod
                                                 no-lock no-error.
                    if avail tt-nprodu
                    then p-ok2 = no.
                end.

                if p-descricao = "FABRICANTE"
                then do:
                    find first tt-nforne
                         where tt-nforne.forcod = produ.fabcod
                                                 no-lock no-error.
                    if avail tt-nforne
                    then p-ok2 = no.
                    
                    if v-add-classe-fabri
                    then do:
                    
                        find first tt-nclase
                             where tt-nclase.clacod = produ.clacod
                                                no-lock no-error.
                        if avail tt-nclase
                        then p-ok2 = no.

                    end.
                    
                end.
                
                if p-descricao = "CLASSE"
                then do:
                    find first tt-nclase
                         where tt-nclase.clacod = produ.clacod
                                                 no-lock no-error.
                    if avail tt-nclase 
                    then p-ok2 = no.
                end.

            if p-ok2 = no then return. 
                
            end.
    end.
    /****/
    
    p-ok2 = yes.
    
    if p-descricao = "PRODUTO" or p-descricao = "DEPARTAMENTO" 
    then do:
        for each tt-nprodu:
            find first tt-produtos where
                       tt-produtos.clicod = crm.clicod
                   and tt-produtos.procod = tt-nprodu.procod no-error.
            if avail tt-produtos
            then p-ok2 = no.
        end.
    end.
    
    if p-descricao = "FABRICANTE"
    then do:
        for each tt-nforne:
            find first tt-fabricantes where
                       tt-fabricantes.clicod = crm.clicod
                   and tt-fabricantes.fabcod = tt-nforne.forcod no-error.
            if avail tt-fabricantes
            then p-ok2 = no. 
        end.
    end.
    
    if p-descricao = "CLASSE"
    then do:
        for each tt-nclase:
            find first tt-classes where
                       tt-classes.clicod = crm.clicod
                   and tt-classes.clacod = tt-nclase.clacod no-lock no-error.
            if avail tt-classes
            then p-ok2 = no.
        end.
    end.
      
  if v-log = no then p-ok2 = no.
    
    
end procedure.

procedure p-filtro-considerar.
    def var vini as int label "De".
    def var vfim as int label "Ate".
    def var vdti as date label "De" format "99/99/9999".
    def var vdtf as date label "Ate" format "99/99/9999".
    def var vpagas as int.

    if tt-filtro.descricao = "TIPOS DE PARCELAS"
    then do:
        update vtip-parc label "Tipo De Parcela (Aberta/Fechada)"
               with frame fparcela centered row 12 overlay side-labels width 45.
        hide frame fparcela no-pause.         
    end.
    if tt-filtro.descricao = "SEXO"
    then do:
             update vsexo as log format "Masculino/Feminino" label "Sexo"
             with frame fsexo centered row 12 overlay side-labels.
        hide frame fsexo no-pause.
        tt-filtro.log = vsexo.
    end.

    if tt-filtro.descricao = "ESTADO CIVIL"
    then do:
        run crm20-estc.p.
    end.
    /* antonio */
    if tt-filtro.descricao = "ANO DE NASCIMENTO"
    then do:
        update vano-nasc1 label "Ano de Nascimento Inicial" skip
               vano-nasc2 label "Ano de Nascimento Final  "
               with frame f-filt2 side-labels overlay.
        if vano-nasc2 < vano-nasc1
        then do:
               message "Ano Nascimento inicial maior que Ano Nascimento final"
                view-as alert-box.
               undo, retry. 
        end.
        hide frame f-filt2 no-pause.
    end.
    if tt-filtro.descricao = "DIA DE ANIVERSARIO"
    then do:
        
        update vdia-fil1 skip
               vdia-fil2 with frame f-filt1 side-labels overlay.
         
        if vdia-fil1 > 31 or vdia-fil1 < 1 or vdia-fil2 > 31 or vdia-fil2 < 1
        then do:
            message "Dia de Aniversario Invalido ! " view-as alert-box.
            undo, retry.
        end.

        if vdia-fil1 > vdia-fil2
        then do:
            message "Dia Final menor que o Inicial !" view-as alert-box.
            undo, retry.
        end.
        hide frame f-filt1 no-pause.
    end.
    
    /**/
    if tt-filtro.descricao = "FAIXA DE IDADE"
        or tt-filtro.descricao = "MES DE ANIVERSARIO"
    then do:
        /*def var vini as int label "De".
        def var vfim as int label "Ate".
        */
        update vini vfim
        with frame fint centered row 12 overlay side-labels.
        hide frame fint no-pause.
        tt-filtro.int[1] = vini.
        tt-filtro.int[2] = vfim.
    end.
    
    if tt-filtro.descricao = "ELEGIVEIS CARTAO"
    then do:
        DISP "Clientes com presta��es em aberto e ou quitadas"
                with frame f-car.
        repeat on error undo:
            update   vdti at 1 label "a partir de"
                    with frame f-car centered row 12 overlay side-labels
                    .
            if vdti = ? 
            then do:
                message "Periodo invalido." .
                pause.
                undo, retry.
            end.
            
            tt-filtro.data[1] = vdti.

            vpagas = 30.
            
            update vpagas at 1 label "Minimo parcelas pagas"
                with frame f-car.
            tt-filtro.int[1] = vpagas.
                
            update tt-filtro.log at 1 format "Sim/Nao" 
                        label "Considerar Nova��o?"  with frame f-car.
            if tt-filtro.log = yes
            then update tt-filtro.dec[1] label "% Quitado" format ">>9.99%"
                    with frame f-car.
                    
            leave.
        end.
        hide frame f-car no-pause.
    end.

    if tt-filtro.descricao = "COM DEPENDENTES"
    then do:
        /* Simplesmente Considera */
    end.
    if tt-filtro.descricao = "CIDADE"
    then do:
        run crm20-cid.p.
    end.
    if tt-filtro.descricao = "BAIRRO"
    then do:
        run crm20-bai.p.
    end.
    if tt-filtro.descricao = "POSSUI CELULAR"
    then do:
        /* Simplesmente Considera */
    end.
    if tt-filtro.descricao = "COM DEPENDENTES"
    then do:
        /* Simplismente Considera */
    end.
    if tt-filtro.descricao = "TIPO DE RESIDENCIA"
    then do:
             update vtiporesidencia as log format "Propria/Alugada"
                label "Tipo Residencia"
             with frame fres centered row 12 overlay side-labels.
        hide frame fres no-pause.             
        tt-filtro.log = vtiporesidencia.
    end.
    if tt-filtro.descricao = "CONSIDERAR SPC"
    then do:
        /* Simplesmente Considera */
    end.
    if tt-filtro.descricao = "PROFISSAO"
    then do:
        run crm20-prof.p.
    end.
    if tt-filtro.descricao = "RENDA MENSAL"
    then do:
        def var vdecini as int label "De".
        def var vdecfim as int label "Ate".
        update vdecini vdecfim
        with frame fdec centered row 12 overlay side-labels.
        hide frame fdec no-pause.
         tt-filtro.dec[1] = vdecini.
        tt-filtro.dec[2] = vdecfim.
    end.
    if tt-filtro.descricao = "POSSUI E-MAIL"
    then do:
        /* Simplesmente Considera */
    end.
    if tt-filtro.descricao = "POSSUI CARRO"
    then do:
        /* Simplesmente Considera */
    end.
    if tt-filtro.descricao = "LIMITE DE CREDITO"
    then do:
        update 
             vlimcre-de 
             vlimcre-ate 
             vcrepre-de 
             vcrepre-ate
             vpctpre-mais
             vparpag 
             vpontual
             with frame f-limcre. 
        /*
        tt-filtro.dec[1] = vdecini.
        tt-filtro.dec[2] = vdecfim.
        */
    end.
    
    if tt-filtro.descricao = "AUMENTO DE LIMITE"
    then do:
        
        message "Deseja filtrar por Percentual Valor de aumento no limite?" update vaumento-lim.
    
        if not vaumento-lim /* Valor de Aumento */
        then do:
        
          update vval-aumento
                  label "Valor m�nimo de Aumento" format ">>>>9.99"
                  with frame f-aument2 row 12 overlay
                      side-labels                                                                 centered title "Digite o Valor m�nimo de aumento do Limite.".

            
        end.
        else do:     /* Percentual de Aumento */
          update vperc-aumento
                  label "Perc. m�nimo de Aumento" format ">>>>9.99 %"
                  with frame f-aument row 12 overlay
                        side-labels
            centered title "Digite o Percentual m�nimo de aumento do Limite.".
        end.
        
        hide frame f-aument  no-pause.
        hide frame f-aument2 no-pause.
                            
    end.
    
    
    if tt-filtro.tipo = "PRODUTO" and tt-filtro.descricao = "PRODUTO"
    then do:
        run crm20-pro.p.
    end.
    if  tt-filtro.tipo = "PRODUTO" and  tt-filtro.descricao = "FABRICANTE"
    then do:
        run crm20-fab.p.
        
        assign v-add-classe-fabri = no.
        
        message "Deseja adicionar classes ao filtro de fabricantes?"
                                            update v-add-classe-fabri.
        
        if v-add-classe-fabri
        then run crm20-cla.p.

    end.
    if tt-filtro.tipo = "PRODUTO" and tt-filtro.descricao = "DEPARTAMENTO"
    then do on error undo:
        vcatcod = 0.
        update vcatcod with frame fcateg row 12 overlay side-labels centered.
        find categoria where categoria.catcod = vcatcod no-lock no-error.
        if not avail categoria
        then do:
            message "Categoria nao cadastrada" view-as alert-box.
            undo.
        end.
        hide frame f-categ.
    end.
    if  tt-filtro.tipo = "PRODUTO" and  tt-filtro.descricao = "PLANO DE PAGAMENTO"
    then do:
         run crm20-plan.p.
    end.
    if  tt-filtro.tipo = "PRODUTO" and tt-filtro.descricao = "CLASSE"
    then do:
    
        run crm20-cla.p.
        /*
        create tt-clase.
        update tt-clase.clacod
        with frame fcla centered row 12 overlay side-labels.
        hide frame fcla no-pause.
        */
    end.
    
    /* Nao Comprou */
    if tt-filtro.tipo = "NAOCOMP" and tt-filtro.descricao = "PRODUTO"
    then do:
        run crm20-npro.p.
    end.
    if  tt-filtro.tipo = "NAOCOMP" and  tt-filtro.descricao = "FABRICANTE"
    then do:
        run crm20-nfab.p.
        
        assign v-add-classe-fabri = no.
                
        message "Deseja adicionar classes ao filtro de fabricantes?"
                                           update v-add-classe-fabri.
                                            
        if v-add-classe-fabri
        then run crm20-ncla.p.
        
    end.
    if tt-filtro.tipo = "NAOCOMP" and tt-filtro.descricao = "DEPARTAMENTO"
    then do on error undo:
        vncatcod = 0.
        update vncatcod with frame fncateg row 12 overlay side-labels centered.
        find categoria where categoria.catcod = vncatcod no-lock no-error.
        if not avail categoria
        then do:
            message "Categoria nao cadastrada" view-as alert-box.
            undo.
        end.
        hide frame f-ncateg.
    end.
    if  tt-filtro.tipo = "NAOCOMP" and tt-filtro.descricao = "CLASSE"
    then do:
        run crm20-ncla.p.
        /*
        create tt-nclase.
        update tt-nclase.clacod
        with frame fcla.
        hide frame fcla no-pause.
        */
    end.
    if tt-filtro.tipo = "NAOCOMP"
        and  tt-filtro.descricao = "PLANO DE PAGAMENTO"
    then do:
        run crm20-nplan.p.
    end.

end procedure.


/* Antonio sol 26885*/


Procedure Pi-Processa-Limite.

def var vlimite-credito as dec.
def var vsaldo-aberto as dec.
find bclien where bclien.clicod = crm.clicod no-lock.

assign  vcalclim = 0
        vpardias = 0
        vdisponivel = 0.

if not connected("dragao")
then connect dragao -H "erp.lebes.com.br" -S sdragao -N tcp -ld dragao.
  
run calccredscore.p (input "",
                    input recid(bclien),
                    output vcalclim,
                    output vpardias,
                    output vdisponivel).

/* Luciane - 06/11/2009
assign vlimite-credito = vcalclim.

/*
vlimite-credito = crm.limcrd.
*/

run salabertocli.p ( input recid(bclien),
                     output vsaldo-aberto).

        b-rfvtot.lim-credito = b-rfvtot.lim-credito + vlimite-credito.
        if vlimite-credito > vsaldo-aberto
        then b-rfvtot.lim-disponivel = b-rfvtot.lim-disponivel +
                (vlimite-credito - vsaldo-aberto) .
*/
        b-rfvtot.lim-credito = b-rfvtot.lim-credito + vcalclim.
        b-rfvtot.lim-disponivel = b-rfvtot.lim-disponivel + vdisponivel.

end procedure.

/**/

