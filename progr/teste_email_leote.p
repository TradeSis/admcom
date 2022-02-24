    def var varqmail as char.
    def var vassunto as char.
    def var varquivo as char.
    def var vdestino as char.
    def var comando as char.
     
    assign
        vassunto = "Teste email Leote" 
        vdestino = "lucas.leote@lebes.com.br"
        vdestino = "leote.vasconcellos@gmail.com;"
        varquivo = "/admcom/relat/email_leote" + string(time) + ".html".

    output to value(varquivo).
    put "<html>" skip
        "<head>" skip
        "<meta http-equiv=~"Content-Languag~" content=~"pt-br~">" skip
        "<meta name=~"GENERATOR~" content=~"Microsoft FrontPage 5.0~">" skip
        "<meta name=~"ProgId~" content=~"FrontPage.Editor.Document~">" skip
        "<meta http-equiv=~"Content-Type~" content=~"text/html; ".
    put "charset=windows-1252~">" skip
        "<title>Nova pagina</title>" skip
        "</head>" skip
        "<body>" skip.
    put unformatted
        "<h1>Teste de e-mail</h1></p>"
        /*unix silent value("more /admcom/work/processo-call-center.17062015")*/
        "<b>Por:</b> Lucas Leote</p></p>"
        "<br>outra linha". 
    put "</body>" skip.
    put "</html>" skip.
    
    output close.
        
    varqmail = "/admcom/progr/mail.sh " +
                        " ~"" + vassunto + "~"" +
                        " ~"" + varquivo + "~"" +
                        " ~"" + vdestino + "~"" +
                        " ~"" + vdestino + "~"" +
                        " ~"text/html~"". 
    unix silent value(varqmail).
