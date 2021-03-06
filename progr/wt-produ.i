/* 27/08/14 workfile definition for table produ */
/* {1} = "", "NEW" or "NEW SHARED" */
/* {2} = "" or "NO-UNDO" */

DEFINE {1} WORK-TABLE wprodu {2} /* LIKE produ */
  FIELD catcod        AS INTEGER     FORMAT ">>9" LABEL "Categoria"
  FIELD clacod        AS INTEGER     FORMAT ">>>>>>>>9" LABEL "Classe"
  FIELD codfis        AS INTEGER     FORMAT ">9" LABEL "codfis" COLUMN-LABEL "codfis"
  FIELD codori        AS INTEGER     FORMAT ">9" LABEL "codori" COLUMN-LABEL "codori"
  FIELD codtri        AS INTEGER     FORMAT ">>>>>>>9" LABEL "codtri" COLUMN-LABEL "codtri"
  FIELD corcod        AS CHARACTER   FORMAT "x(4)" LABEL "Cor"
  FIELD datexp        AS DATE        INITIAL today
  FIELD datFimVida    AS DATE        FORMAT "99/99/9999" LABEL "DatFimVida" COLUMN-LABEL "DatFimVida"
  FIELD descontinuado AS LOGICAL     FORMAT "Sim/Nao" INITIAL TRUE LABEL "Descontinuado" COLUMN-LABEL "Descontinuado"
  FIELD descRevista   AS CHARACTER   FORMAT "x(20)" LABEL "D.Revista" COLUMN-LABEL "D.Revista"
  FIELD etccod        AS INTEGER     FORMAT "9" LABEL "Estacao"
  FIELD exportado     AS LOGICAL     LABEL "Exportado" COLUMN-LABEL "Exportado"
  FIELD fabcod        AS INTEGER     FORMAT ">>>>99" LABEL "Fabricante" COLUMN-LABEL "Fab."
  FIELD itecod        AS INTEGER     FORMAT ">>>>99" LABEL "Item"
  FIELD opentobuy     AS LOGICAL     FORMAT "Sim/Nao" INITIAL TRUE LABEL "OpenToBuy" COLUMN-LABEL "OpenToBuy"
  FIELD proabc        AS CHARACTER   FORMAT "x" INITIAL "A" LABEL "Classe ABC" COLUMN-LABEL "ABC"
  FIELD procar        AS CHARACTER   FORMAT "x(20)" LABEL "Caracteristica"
  FIELD proclafis     AS CHARACTER   FORMAT "999.999.999" LABEL "Clas.Fiscal"
  FIELD procod        AS INTEGER     FORMAT ">>>>99" LABEL "Produto"
  FIELD procvcom      AS DECIMAL     DECIMALS 3 FORMAT ">>>,>>9.<<<" LABEL "Conversao"
  FIELD procvven      AS DECIMAL     DECIMALS 3 FORMAT ">>>,>>9.<<<" LABEL "Conversao"
  FIELD prodtcad      AS DATE        FORMAT "99/99/9999" INITIAL today LABEL "Data Cadastro"
  FIELD proindice     AS CHARACTER   FORMAT "x(15)" INITIAL ? LABEL "Cod"
  FIELD proipiper     AS DECIMAL     DECIMALS 2 FORMAT ">9.99 %" LABEL "Perc. IPI" COLUMN-LABEL "IPI %"
  FIELD proipival     AS DECIMAL     DECIMALS 2 FORMAT ">>>,>>>,>>9.99" LABEL "Valor IPI" COLUMN-LABEL "IPI Valor"
  FIELD pronom        AS CHARACTER   FORMAT "x(50)" LABEL "Nome Produto"
  FIELD pronomc       AS CHARACTER   FORMAT "x(20)" LABEL "Desc.Automacao"
  FIELD propag        AS INTEGER     FORMAT ">>9" LABEL "Pagina"
  FIELD prorefter     AS CHARACTER   FORMAT "x(15)" LABEL "Refer. Terceiros"
  FIELD proseq        AS INTEGER     FORMAT ">9" LABEL "Sequencial" COLUMN-LABEL "Seq"
  FIELD protam        AS CHARACTER   FORMAT "X(5)" LABEL "Tamanho" COLUMN-LABEL "Tam"
  FIELD prouncom      AS CHARACTER   FORMAT "xx" INITIAL "UN" LABEL "Unidade Compra" COLUMN-LABEL "UC"
  FIELD prounven      AS CHARACTER   FORMAT "xx" INITIAL "UN" LABEL "Unidade Venda" COLUMN-LABEL "UV"
  FIELD prozort       AS CHARACTER   FORMAT "x(40)"
  FIELD pvp           AS DECIMAL     DECIMALS 2 LABEL "PVP" COLUMN-LABEL "PVP"
  FIELD temp-cod      AS INTEGER     FORMAT "->>>>>>9" LABEL "TempCod" COLUMN-LABEL "TempCod".
