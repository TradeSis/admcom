def var d-valorparcela    as dec no-undo.                        
def var d-valortotal      as dec no-undo.                        
def var i-nroparcela as int no-undo. 
def var d-precoatual like estoq.estven.

def var i-real    as int no-undo.
def var d-centavo as dec decimals 2 no-undo.  

def var i-novoreal    as int no-undo.
def var d-novocentavo as dec decimals 2 no-undo.

def var d-novaparcela like estoq.estven.
def var d-novototal   like estoq.estven.  

output to /admcom/TI/leote/produtos_planos.csv.  

put "etbcod;procod;estoq;precoatual;placod;planom;nroparcela;vlparcela" skip.                  
                                                            
for each estoq where estatual > 0 and etbcod = 1 no-lock:
    if estproper > 0 then d-precoatual = estproper.
    if estproper = 0 then d-precoatual = estven.

    for each finan where finfat < 2 no-lock:                
        d-valorparcela = d-precoatual * finfat.                     
        
		if finent = yes then i-nroparcela = finnpc + 1.                                                     
        if finent = no then i-nroparcela = finnpc.                                                          
        
		d-valortotal = d-valorparcela * i-nroparcela. 

        i-real = truncate(d-valorparcela,0).
        d-centavo = d-valorparcela - i-real.

        if d-centavo >= 50 then d-novocentavo = 0.90.
        if d-centavo < 50 then do:
            d-novocentavo = 0.90.
            i-novoreal = i-real - 1.
        end.

        d-novaparcela = i-novoreal + d-novocentavo.
        d-novototal = d-novaparcela * i-nroparcela.

        if d-novaparcela < 0 then d-novaparcela = 0.
        
		put
            etbcod ";"                                               
            procod ";"  
            estatual ";"                                        
            /*estven*/                                          
            d-precoatual format ">>>,>>9.99" ";"                   
			fincod ";"        
            finnom ";"         
            /*finfat*/         
            i-nroparcela ";"  
            /*finent         
            d-valorparcela      
            d-valortotal 
            i-real
            d-centavo*/       
            d-novaparcela /*column-label "d-novaparcela"*/ skip
            /*d-novototal   column-label "d-novototal"*/.
    end.                   
end.
output close.                       