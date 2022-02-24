/*
Programa:  atualizar_cep2.p
Propósito: Importar para atualização de CEP de clientes
Autor:     Lucas Leote
Data:      Dez/2016
*/

{admcab.i}

/* Definindo variáveis e temp-table */
def temp-table tt-clien
	field clicod   as int format ">>>>>>>999" 
	field bairro   as char format "x(20)"
	field cep      as char format "x(10)"
	field endereco as char format "x(40)"
	field cidade   as char format "x(25)"
	field ufecod   as char format "x(2)".

def var c-csv   as char no-undo format "x(50)".

/* Atribuindo diretório e nome do arquivo recebido */
assign c-csv = "/admcom/import/clientes_cep.csv".

/* Form que recebe os dados inputados pelo usuário */
update c-csv label "Pasta e arquivo"
with 1 col frame f1 title "  Informe os dados abaixo  " centered width 80.

message "Atualizando dados...".

/* Lendo o arquivo e gravando na temp-table */
input from value(c-csv) no-convert.
	repeat:
		create tt-clien.
		import delimiter ";" tt-clien no-error.
	end.
input close.

/* Percorrendo a temp-table */
for each tt-clien where tt-clien.clicod > 0:
	/*disp
		tt-clien.clicod
		tt-clien.bairro
		tt-clien.cep
		tt-clien.endereco
		tt-clien.cidade
		tt-clien.ufecod
		with 1 col.*/

	find clien where clien.clicod = tt-clien.clicod no-error.
		if not avail clien then next.
		/*disp
			clien.clicod
			clien.bairro[1]
			clien.cep[1]
			clien.endereco[1]
			clien.cidade[1]
			clien.ufecod[1]
			with 1 col.*/

		assign clien.bairro[1]   = tt-clien.bairro.
		assign clien.cep[1]      = tt-clien.cep.
		assign clien.endereco[1] = tt-clien.endereco.
		assign clien.cidade[1]   = tt-clien.cidade.
		assign clien.ufecod[1]   = tt-clien.ufecod.
end.

message "Dados atualizados!" view-as alert-box.