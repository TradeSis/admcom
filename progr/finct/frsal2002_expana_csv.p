def var vdtref as date.
vdtref = 06/30/2021.
update vdtref.

def temp-table tttitulo no-undo
    field titnum like titulo.titnum
    field titpar  like titulo.titpar    
    field titdtemi like titulo.titdtemi
    field titdtpag like titulo.titdtpag
    field titvlcob like titulo.titvlcob
    field cobcod    like titulo.cobcod
    field modcod    like titulo.modcod
    field tpcontrato like titulo.tpcontrato
    field etbcod    like titulo.etbcod
    field produto   as char
    index x is unique primary titnum asc titpar asc.


def temp-table ttcontrato no-undo
    field titnum like titulo.titnum
    field titdtemi like titulo.titdtemi
    field titdtpag like titulo.titdtpag
    field titvlcob like titulo.titvlcob
    field cobcod    like titulo.cobcod
    field modcod    like titulo.modcod
    field tpcontrato like titulo.tpcontrato
    field etbcod    like titulo.etbcod
    field vencini         like titulo.titdtven
    field vencfim         like titulo.titdtven
    field produto as char
    index x is unique primary titnum asc cobcod asc.

def var vqtdtotal as int init 0.
def var vtotal    as dec init 0.
def var voktotal    as dec init 0.
def var vctrtotal    as dec init 0.
def var xtime as int.
def var vimport as int.
def var vimportar as int.
xtime = time.
vimportar = 0.
input through value("wc -l /admcom/helio/ctb/carteira/parcelas_" + string(vdtref,"99999999") + ".csv").
repeat.
    import vimportar.  
end.
input close.
message vimportar.
input from value("/admcom/helio/ctb/carteira/parcelas_" + string(vdtref,"99999999") + ".csv").
repeat.
    create tttitulo.
    import delimiter ";" tttitulo.
    vimport = vimport + 1.
    if vimport = 1 or vimport mod 1000 = 0
    then do:
        hide message no-pause.
        message vimport "/" vimportar string(vimport / vimportar * 100,">>>9,99%") string(time - xtime,"HH:MM:SS").
    end.
    vtotal = vtotal + tttitulo.titvlcob.

    find contrato where contrato.contnum = int(tttitulo.titnum) no-lock no-error.
    if not avail contrato 
    then do: 
        delete tttitulo. 
        next.
    end.
    find titulo where titulo.empcod = 19 and titulo.titnat = no and
            titulo.clifor = contrato.clicod and titulo.etbcod = contrato.etbcod and
            titulo.modcod = contrato.modcod and titulo.titnum = tttitulo.titnum and
            titulo.titpar = tttitulo.titpar and titulo.titdtemi = tttitulo.titdtemi
        no-lock no-error.
    if not avail titulo 
    then do: 
        delete tttitulo. 
        next.
    end.
    
    voktotal = voktotal + tttitulo.titvlcob.
                  
            find first ttcontrato where 
                    ttcontrato.titnum = titulo.titnum and 
                    ttcontrato.cobcod = tttitulo.cobcod 
                no-error.
            if not avail ttcontrato
            then do:     
                create ttcontrato.
                    ttcontrato.titnum = titulo.titnum.
                    ttcontrato.cobcod = tttitulo.cobcod.
                    ttcontrato.etbcod = titulo.etbcod.
                    ttcontrato.modcod = titulo.modcod.
                    ttcontrato.tpcontrato = tttitulo.tpcontrato.
                    ttcontrato.titdtemi = titulo.titdtemi.
                    ttcontrato.produto  = tttitulo.produto.
            end.     
            ttcontrato.titdtpag = if tttitulo.titdtpag = ?
                                  then ?
                                  else max(ttcontrato.titdtpag,tttitulo.titdtpag).
            ttcontrato.titvlcob = ttcontrato.titvlcob + tttitulo.titvlcob.
            
                    ttcontrato.vencini    = if ttcontrato.vencini = ?
                                              then titulo.titdtven
                                              else min(ttcontrato.vencini,titulo.titdtven).
                    ttcontrato.vencfim    = if ttcontrato.vencfim = ?
                                              then titulo.titdtven
                                              else max(ttcontrato.vencfim,titulo.titdtven).
    
    delete tttitulo.    

    
    
end.
input close.
message vtotal voktotal vimport string(time - xtime,"HH:MM:SS").
pause 1.

def var vqtdarq   as dec.  

vqtdtotal = 0.
for each ttcontrato.
    vqtdtotal = vqtdtotal + 1.
end.    


def var vqtdarqint as int.
vqtdarq = vqtdtotal / 1048570.
vqtdarqint = int(round(vqtdarq,0)).
vqtdarq = vqtdarq - vqtdarqint.
if vqtdarq > 0
then vqtdarqint = vqtdarqint + 1.


hide message no-pause.
message vimport vqtdtotal "Contratos" vqtdarqint "Arquivos Csv".

def var varquivos as char.
    def var ccarteira as char.
    def var cmodnom   as char.
   def var vi as int. def var ctpcontrato as char.
    
   def var varq as char format "x(76)".
   def var vcp  as char init ";".
    varq = ("../helio/ctb/carteira/Hposicao_analitica_" + string(vdtref,"99999999") + ".csv").
   
/*    pause 0.
    update skip(2) varq skip(2)
        with
        centered 
        overlay
        color messages
        no-labels
        row 8
        title string(vqtdarqint) + " arquivo de saida".
  */
  
def var vregistros as int.     
   
    for each ttcontrato.
        if vregistros = 0
        then do:
            vi = vi + 1.
            varquivos = replace(varq,".csv","_arq") + string(vi) + ".csv".
            
            output to value(varquivos).    
                vregistros = vregistros + 1.    
                put unformatted
                "Codigo" vcp
                "Nome"   vcp
                "CPF"    vcp 
                "Contrato" vcp    
                "Carteira" vcp    
                "Valor"   vcp
                "Emissão" vcp
                "Vencimento_inicial"  vcp
                "Vencimento_final"    vcp
                "Modalidade"  vcp
                "Filial"  vcp
                "Tipo de cobrança" vcp
                "Data Referencia" vcp
                "Produto" vcp
                skip.
                vregistros = vregistros + 1.    
        end.
        
        find contrato where contrato.contnum = int(ttcontrato.titnum) no-lock no-error.
            if not avail contrato then next.
        find clien where clien.clicod = contrato.clicod no-lock no-error.
        
        
        find cobra where cobra.cobcod = ttcontrato.cobcod no-lock no-error.
        find modal where modal.modcod = contrato.modcod no-lock no-error.
        ccarteira = (if ttcontrato.cobcod <> ? 
                 then string(ttcontrato.cobcod) + if avail cobra 
                                           then ("-" + cobra.cobnom)
                                           else ""
                 else "-").

        ctpcontrato = ttcontrato.tpcontrato.

        cmodnom = if contrato.modcod <> ? 
                then contrato.modcod + if avail modal then "-" + modal.modnom else ""
                else "-".
        
        put unformatted
            
            contrato.clicod     vcp
            if avail clien then clien.clinom else "-"       vcp
            if avail clien then clien.ciccgc else "-"       vcp
            contrato.contnum    vcp
            ccarteira           vcp
            ttcontrato.titvlcob    vcp
            contrato.dtinicial  vcp
            ttcontrato.vencini    vcp
            ttcontrato.vencfim   vcp    
            cmodnom             vcp
            contrato.etbcod     vcp
            ctpcontrato         vcp
            vdtref              vcp
            ttcontrato.produto vcp
               skip.
        vregistros = vregistros + 1.
        vctrtotal = vctrtotal + ttcontrato.titvlcob.
        if vregistros = 1048570
        then do:
            output close.
            vregistros = 0.
        end.
    end.
    
    output close.




message voktotal vtotal vctrtotal  vimport string(time - xtime,"HH:MM:SS").
.
pause.
