
def var vtipo as char.
vtipo = "PAGTO".
def var varquivo as char.

{csl/cybcab.i}

def shared var v-today as date.
def shared var v-time as int.
def shared temp-table ttcontrato no-undo
    field contnum as int format ">>>>>>>>>>>>>9"
    index cont is unique primary contnum asc.

def var vsequencia                  as int.
def var vqtd_registros              as int.
def var vchave_contrato             as char.
def var vtitdtpag                   as char.
def var vtitdtven                   as char.
def var vtitvlpag                   as dec.
def var vcod_transacao as char.
def var vok as log.

vsequencia = v-time.

{cslre/arquivo.i  ""pagamentos""}

message vtipo varq vsequencia.
output to value(varq).
/* HEADER */
put unformatted
    "H"               format "x"          /* TIPO              0001 - 0001 */ 
    "2"               format "x"          /* PRODUTO           0002 - 0031 */
    "CYBER"           format "x(8)"       /* EMPRESA           0032 - 0039 */ 
    "PGTO"            format "x(30)"      /* ARQUIVO           0040 - 0069 */
    vdata_geracao     format "xxxxxxxx"   /* DATA DE GERACAO   0070 - 0077 */ 
    vsequencia        format "9999999999" /* SEQUENCIA ARQUIVO 0078 - 0087 */
    fill(" ",18  )    format "x(46)"    /* FILLER            0088 - 3208 */
    skip.
vqtd_registros = vqtd_registros + 1.

for each ttcontrato.

    find contrato of ttcontrato no-lock no-error.
    vcod_transacao = "".
    vok = no.
    
    vchave_contrato = string(contrato.etbcod ,"999") +
                      string(contrato.contnum,"99999999999"). 
     

    if avail contrato /* #1 */
    then do.
        for each titulo where 
                    titulo.empcod = 19 and 
                    titulo.titnat = no and 
                    titulo.modcod = contrato.modcod and 
                    titulo.etbcod = contrato.etbcod and 
                    titulo.clifor = contrato.clicod and 
                    titulo.titnum = string(contrato.contnum) 
            no-lock.
            if titulo.titpar = 0 then next.
            if titulo.titsit = "PAG"
            then do:
                vtitdtpag = formatadata(titulo.titdtpag).
                vtitdtven = formatadata(titulo.titdtven).
                vtitvlpag = titulo.titvlpag.
                vcod_transacao = string(titulo.titpar,"999999").
                run exporta.
                vok = yes.
            end.
        end.
    end. /* avail */

end.

/* TRAILER */
vqtd_registros = vqtd_registros + 1.
put unformatted
    "T"               format "x"          /* TIPO              0001 - 0001 */ 
    vdata_geracao     format "xxxxxxxx"   /* DATA DE GERACAO   0002 - 0009 */ 
    vqtd_registros    format "9999999999" /* QUANTIDADE DE REGISTROS ARQUIVO
                                                               0010 - 0019 */
    vsequencia        format "9999999999" /* SEQUENCIA ARQUIVO 0020 - 0029 */
    fill(" ",75)      format "x(75)"      /* FILLER            0030 - 3208 */
    skip.

output close.
{csl/arquivozip.i}


procedure exporta.

    put unformatted
        "500"  /* tipo registro */           format "x(3)"    /* Obrigatorio */
        "2"    /* grupo */                   format "x(1)"    /* Obrigatorio */
        vchave_contrato                      format "x(25)"   /* obrigatorio */
    
        vtitdtpag                            format "x(8)"    /* obrigatorio */
        vtitdtpag                            format "x(8)"    /* obrigatorio */
        vtitvlpag  * 100                     format "999999999999999"
        vtitvlpag  * 100                     format "999999999999999"
        ""                                   format "x(15)"
        vcod_transacao                       format "x(6)"        
        ""                                   format "x(8)"
        vtitdtven                            format "xxxxxxxx" /* 93 */
        
        skip.        
        vqtd_registros = vqtd_registros + 1.

end procedure.
