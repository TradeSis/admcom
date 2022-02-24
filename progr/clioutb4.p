def input  parameter vrecid  as recid.

def var vclicod like clien.clicod.
def buffer bclien for clien.

find clien where recid(clien) = vrecid .

clien.datexp = today.

if clien.tippes
then do:
    
    /* antonio - sol 26210 */                        
    run Pi-cic-number(input-output clien.ciccgc).    
    disp clien.ciccgc with frame f2.
    /**/                                             
    assign
        clien.nacion = "BRASILEIRA"
        clien.natur  = "RS".
    update clien.sexo          colon 14
           clien.estciv        colon 14
           clien.nacion        colon 14
           clien.natur         colon 14
           clien.dtnasc        colon 14 format "99/99/9999"
           clien.ciins label "Identidade" colon 14
           clien.ciccgc        colon 14
      /*   clien.numdep */
           with frame f2 row 10 side-label title " Dados Pessoais "
                color white/cyan.
end.
else
    update clien.nacion
           clien.ciins label "Insc.Estadual" format "x(11)"
           clien.ciccgc
           with 1 column frame f3 width 80  color white/cyan.
update clien.endereco[1] label "Rua"     colon 9 FORMAT "X(26)"
       clien.numero[1] label "Num."      colon 9
       clien.compl[1] label "Compl."     colon 9
       clien.bairro[1] label "Bairro"    colon 9
       clien.cidade[1] label "Cidade"    colon 9
       clien.ufecod[1] label "Estado"    colon 9
       clien.cep[1] label "CEP"          colon 9
       clien.fone                        colon 9
   /*  clien.tipres
       clien.vlalug
       clien.temres */
       with  frame fres column 43  row 10
            title " Informacoes Residenciais " side-labels color white/cyan.
update clien.pai
       clien.mae
       with frame fpai centered 1 column side-label row 18 overlay
            title " Filiacao ".

/* 
update clien.limcrd label "Limite" with 1 column centered color white/red frame
                    flimite row 14 overlay.
*/

/*
if clien.tippes
then
    update clien.proemp[1] label "Empresa"
           clien.protel[1] label "Telefone"
           clien.prodta[1] label "Data Admissao"
           clien.proprof[1] label "Profissao"
           clien.prorenda[1] label "Renda mensal"
           clien.endereco[2] label "Rua"
           clien.numero[2] label "Numero"
           clien.compl[2] label "Complemento"
           clien.bairro[2] label "Bairro"
           clien.cidade[2] label "Cidade"
           clien.ufecod[2] label "Estado"
           clien.cep[2] label "CEP"
           with 1 column width 80 frame finfpro
                title " Informacoes Profissionais ".

if clien.estciv = 2 and clien.tippes
then
    update clien.conjuge
           clien.nascon
           clien.conjpai
           clien.conjmae
           clien.proemp[2] label "Empresa"
           clien.protel[2] label "Telefone"
           clien.prodta[2] label "Data Admissao"
           clien.proprof[2] label "Profissao"
           clien.prorenda[2] label "Renda mensal"
           clien.endereco[3] label "Rua"
           clien.numero[3] label "Numero"
           clien.compl[3] label "Complemento"
           clien.bairro[3] label "Bairro"
           clien.cidade[3] label "Cidade"
           clien.ufecod[3] label "Estado"
           clien.cep[3] label "CEP"
           with 2 column width 80 frame fconj
                title " Informacoes do Conjuge ".

update clien.refcom[1] label "Ref.Comercial" colon 16
       clien.refcom[2] no-label  colon 18
       clien.refcom[3] no-label  colon 18
       clien.refcom[4] no-label  colon 18
       clien.refcom[5] no-label  colon 18
       with width 80 side-label
            frame f4 title " Referencias Comerciais ".

update clien.autoriza[1] label "Autorizados" colon 18
       clien.autoriza[2]   colon 20 no-label
       clien.autoriza[3]   colon 20 no-label
       clien.autoriza[4]   colon 20 no-label
       clien.autoriza[5]   colon 20 no-label
       with width 80 side-label frame f5 title " Autorizados ".
update clien.refnome
       clien.endereco[4] label "Rua" FORMAT "X(26)"
       clien.numero[4] label "Numero"
       clien.compl[4] label "Complemento"
       clien.bairro[4] label "Bairro"
       clien.cidade[4] label "Cidade"
       clien.ufecod[4] label "Estado"
       clien.cep[4] label "CEP"
       clien.reftel
       with 1 column width 80 frame fpess
            title " Referencia Pessoal " .
  */
Procedure Pi-cic-number.                                                    
                                                                            
def input-output  parameter p-ciccgc  like clien.ciccgc.                    
def var v-ciccgc like clien.ciccgc.                                         
def var jj          as int.                                                 
def var ii          as int.                                                 
def var v-carac     as char format "x(1)".                                  
                                                                            
                                                                            assign v-ciccgc = "".                                                       
do ii = 1 to length(p-ciccgc):                                              
   assign v-carac = string(substr(p-ciccgc,ii,1)).                          
      do jj = 1 to 10:                                                         
        if string(jj - 1) = v-carac then assign v-ciccgc = v-ciccgc + v-carac.
      end.                                                                     
end.                                                                        
assign p-ciccgc = v-ciccgc.                                                 
end procedure.                                                              
