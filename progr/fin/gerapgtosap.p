
def var vdtini as date format "99/99/9999".
def var vgeral as log  format "Todos/Novos".

vgeral = no. /* so sobe atualizacoes */
def var vtoday as date.
vtoday = today.
vdtini = date(month(vtoday),01,year(vtoday)) - 1. /* 04032021 helio */
vdtini = date(month(vdtini),01,year(vdtini)).

run /admcom/barramento/async/gerapagtorecebido.p   (vdtini,vgeral).

message "geracao Encerrada".