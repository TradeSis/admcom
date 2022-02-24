/*
Programa:  atualizar_cep.p
Propósito: Exportador para atualização de CEP de clientes
Autor:     Lucas Leote
Data:      Dez/2016
*/

{admcab.i}

/* Definindo as variáveis */
def var i-flini as int format ">>9" no-undo.
def var i-flfim as int format ">>9" no-undo.
def var c-csv   as char no-undo format "x(50)".
def var c-bkp   as char no-undo.

/* Atribuindo os valores de diretório e nome dos arquivos gerados */
assign c-csv = "/admcom/import/clientes_cep.csv".
/*assign c-bkp = "/admcom/backupcep/clientes_cep.d".*/

/* Form que recebe os dados inputados pelo usuário */
update i-flini label "Filial inicial"
	   i-flfim label "Filial final"
	   c-csv label "Pasta e arquivo"
with 1 col frame f1 title "  Informe os dados abaixo  " centered width 80.

/* Validação dos dados inputados pelo usuário */
if i-flini < 1 or i-flfim > 999 then do:
	message "Filial invalida!".
	undo, retry.
end.

message "Gerando arquivos...".

/* Gerando CSV */
output to value(c-csv).
	for each clien where clien.etbcad >= i-flini and clien.etbcad <= i-flfim no-lock:
		put unformatted 
			clien.clicod ";"
			clien.bairro[1] ";"
			clien.cep[1] ";"
			clien.endereco[1] ";"
			clien.cidade[1] ";"
			clien.ufecod[1] skip.
	end.
output close.

/* Gerando os .d */
do i-flini = i-flini TO i-flfim:
    c-bkp = "/admcom/backupcep/clien_cep_FL" + string(i-flini) + ".d".
    output to value(c-bkp).
        for each clien where etbcad = i-flini no-lock.
            export clien.
        end.
    output close.
end.

/*unix silent sudo chmod 777 value(c-csv).
unix silent sudo chmod 777 value(c-bkp).*/

/* Msg de conclusão */
message "ARQUIVOS:" skip c-csv skip c-bkp skip "GERADOS COM SUCESSO!" view-as alert-box.