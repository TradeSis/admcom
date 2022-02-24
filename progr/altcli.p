{admcab.i}
repeat with side-label width 80 row 3.
    prompt-for clien.clicod colon 20.
    find clien using clien.clicod.
    do with frame f-altera row 5 centered OVERLAY 2 COLUMNS SIDE-LABELS.
	update clien.clinom
	       clien.tippes with color white/cyan.
	run clioutb4.p (input recid(clien)) .
    end.
end.
