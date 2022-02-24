    def var varqmail as char.
    def var vassunto as char.
    def var varquivo as char.
    def var vdestino as char.
    def var comando as char.
     
    assign
        vassunto = "Teste email Leote" 
        vdestino = "lucas.leote@lebes.com.br;felipe.trojack@lebes.com.br;"
        varquivo = "/admcom/relat/email_leote" + string(time) + ".html".

    output to value(varquivo).
    unix silent value("more /admcom/work/processo-call-center.17062015").
    output close.
        
    varqmail = "/admcom/progr/mail.sh " +
                        " ~"" + vassunto + "~"" +
                        " ~"" + varquivo + "~"" +
                        " ~"" + vdestino + "~"" +
                        " ~"" + vdestino + "~"" +
                        " ~"text/html~"". 
    unix silent value(varqmail).
