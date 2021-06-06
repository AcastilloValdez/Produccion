/*
+----------------------------------------------------------------------------+
!                       FICHA TECNICA DEL PROGRAMA                           !
+----------------------------------------------------------------------------+
!DATOS DEL PROGRAMA                                                          !
+------------------+---------------------------------------------------------+
!Tipo              ! Carta de transferencia                     !
+------------------+---------------------------------------------------------+
!Modulo            ! FINANCIERO                                                 !
+------------------+---------------------------------------------------------+
!Descripcion       ! Generacion de Carta de Transferencia             !
!                  ! AC.                                                   !
+------------------+---------------------------------------------------------+
!Autor             ! Anderson Castillo                                !
+------------------+---------------------------------------------------------+
!Fecha creacion    ! Mayo/2021                                              !
+------------------+---------------------------------------------------------+
!   ATUALIZACIONES                                                           !
+-------------------------------------------+-----------+-----------+--------+
!Descripcion detallada de la actualizacion  !Nombre del ! Analista  !FEcha de!
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+--------+
.________________________________________________________________________________________.
|   //////  //////  //////  //    //  //////  | Developed For Protheus by TOTVS          |
|    //    //  //    //     //   //  //       | ADVPL                                    |
|   //    //  //    //      // //   //////    | TOTVS Technology                         |
|  //    //  //    //       ////       //     | Anderson Castillo.|
| //    //////    //        //    //////      | acastillo@valdez.com.ec                 |
|_____________________________________________|__________________________________________|
|                          _==/                             \==                          |
|                         /XX/            |\___/|            \XX\                        |
|                       /XXXX\            |XXXXX|            /XXXX\                      |
|                      |XXXXXX\_         _XXXXXXX_         _/XXXXXX|                     |
|                      XXXXXXXXXXXxxxxxxxXXXXXXXXXXXxxxxxxxXXXXXXXXXXX                   |
|                     |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX|                  |
|                     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                  |
|                     |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX|                  |
|                      XXXXXX/^^^^"\XXXXXXXXXXXXXXXXXXXXX/^^^^^\XXXXXX                   |
|                      |XXX|       \XXX/^^\XXXXX/^^\XXX/       |XXX|                     |
|                        \XX\       \X/    \XXX/    \X/       /XX/                       |
|                           "\       "      \X/      "       /"                          |
|________________________________________________________________________________________|
|                          //       ////    //   //   //////   //                        |
|                        // //     //  //   //  //   //  //   //                         |
|                       //  //    //  //    // //   //////   //                          |
|                      ///////   //  //     ////   //       //                           |
|                     //    //  ////        //    //       ///////                       |
|_______________________________________________________________________________________*/
#INCLUDE "PROTHEUS.CH"
#Include "TOTVS.ch"
#Include "Rwmake.ch"
#Include "Topconn.ch"
#include 'fileio.ch'
#Include 'FWMVCDEF.CH'

Static cEmpCod  := ""
Static oBmpOK := LoadBitmap(GetResource(),"LBOK") //Objeto tipo check OK
Static oBmpNo := LoadBitmap(GetResource(),"LBNO") //Objeto tipo check NO
Static nTotalValor := 0

User Function SEKLIBCART
    Local lSigue 		:= .F.
    Local lActive := .T.
    STATIC cPerg    := "UBANC02"
    cEmpCod   := FWCodEmp() //Obtiene el codigo de la empresa,
    If !Pergunte(cPerg,.T.) //Form de Visualizacion de Preguntas
        Return
    EndIf
    While lActive
        lSigue := .F.
        If MV_PAR01 = ' '
            MsgAlert("Campo requerido Codigo de Banco", "A V I S O")
            lSigue := .T.
        End if
        If EMPTY(MV_PAR03)
            MsgAlert("Campo requerido Secuencia de Carta","A V I S O")
            lSigue := .T.
        End if
        If lSigue
            If !Pergunte(cPerg,.T.) //Form de Visualizacion de Preguntas
                Return
            EndIf
        else
            lActive := .F.
        EndIf
    End
    SEKHEADGRID()
Return

Static Function SEKHEADGRID()
    Local aArea := GetArea()
    Local oCarta
    Local cCodBanco := MV_PAR01
    Local cDescripcion := MV_PAR02
    Private oDlgPvt
    Private oMsGetPAG
    Private aHead := {}
    Private aCols := {}
    Private oBtnProc
    Private oBtnCerrar
    //Tamaño de la ventana
    Private    nJanLarg    := 630
    Private    nJanAltu    := 300
    //Fuentes
    Private    cFontUti   := "Tahoma"
    Private    oFontAno   := TFont():New(cFontUti,,-38)
    Private    oFontSub   := TFont():New(cFontUti,,-20)
    Private    oFontSubN  := TFont():New(cFontUti,,-20,,.T.)
    Private    oFontBtn   := TFont():New(cFontUti,,-14)

    Static bVeficar := .F.
    //              Título               Campo        Máscara                        Tamaño                   Decimal                   Valid               Usado  Tipo F3     Combo

    aAdd(aHead, {"",                    "CHECK",       "@BMP",                            2,                          0,                        ".F.",              "   ", "C", "",    "V",     "",      "",        "", "V"})
    aAdd(aHead, {"Codigo B",            "CODBANCO",         "",                           3,  		     	        0,                        ".T.",              ".T.", "C", "",    "" } )
    aAdd(aHead, {"Descripcion",         "BANCO",   "",                                   24, 				        0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHead, {"Sec. Carta",          "SEC",         "",                             12, 				        0,                        ".T.",              ".T.", "D", "",    ""} )
    aAdd(aHead, {"Fecha Carta",         "FECHACARTA",         "",                              8, 				            0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHead, {"Total",               "TOTAL",    "@E 999,999,999,999,999.99",    10, 		    	        0,                        ".T.",              ".T.", "N", "",    ""} )
    Processa({|| SEKDETGRID() }, "Cargando ... Espere ....")
    //Creación de la pantalla con los datos a informar
    DEFINE MSDIALOG oDlgPvt TITLE "CARTA TRANSFERENCIA" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
    //Labels gerais
    @ 004, 001 SAY " LIBERACION DE CARTA" SIZE 200, 030 FONT oFontSub  OF oDlgPvt COLORS RGB(031,073,125) PIXEL
    @ 024, 010 SAY oSay1 PROMPT  "Codigo:" SIZE 040, 007 OF oDlgPvt PIXEL
    @ 031, 010 MSGET oCarta VAR cCodBanco SIZE 045, 010 OF oDlgPvt   READONLY PIXEL
    @ 024, 080 SAY oSay2 PROMPT  "Banco:" SIZE 040, 007 OF oDlgPvt PIXEL
    @ 031, 080 MSGET oCarta VAR cDescripcion SIZE 0100, 010 OF oDlgPvt   READONLY PIXEL
    //Botones
    @ 008, (nJanLarg/2-001)-(0080*01) BUTTON oBtnCerrar  PROMPT "Cerrar"   SIZE 040, 015 OF oDlgPvt ACTION (oDlgPvt:End()) FONT oFontBtn PIXEL
    if bVeficar
        @ 008, (nJanLarg/2-001)-(0037*01) BUTTON oBtnProc  PROMPT "Liberar"   SIZE 040, 015 OF oDlgPvt ACTION (Processa({|| SEKPROCCESS() },"Espere..."))  FONT oFontBtn PIXEL
    EndIf
    //Grid dos grupos
    oMsGetPAG := MsNewGetDados():New(    045,;                //nTop      - Linea Inicial
        003,;                //nLeft     - Colunma Inicial
        (nJanAltu/2)-3,;     //nBottom   - Linea Final
        (nJanLarg/2)-3,;     //nRight    - Columna Final
        GD_UPDATE,;           //nStyle    - Estilos para ediçion del Grid (GD_INSERT = Inclusion de Linea; GD_UPDATE = Alteraçion de Linea; GD_DELETE = Exclusivo de Lineas)
        "AllwaysTrue()",;    //cLinhaOk  - Validacion de lineas
        ,;                   //cTudoOk   - Validacion de todas las lineas
        "",;                 //cIniCpos  - Funcion para inicializacion de campos
        {'CHECK'},;           //aAlter    - Columnas que puede ser alteradas
        ,;                   //nFreeze   - Número da columna que será congelada
        9999,;               //nMax      - Máximo de Lineas
        ,;                   //cFieldOK  - Validacion de columna
        ,;                   //cSuperDel - Validacion de operador '+'
        ,;                   //cDelOk    - Validacion al borrar la linea
        oDlgPvt,;            //oWnd      - Ventana que posee la cuadricula
        aHead,;           //aHeader   - Cabecera del Grid
        aCols)
    if bVeficar
        oMsGetPAG:oBrowse:bLDblClick := {|| oMsGetPAG:EditCell(), oMsGetPAG:aCols[oMsGetPAG:nAt,1] := iif(oMsGetPAG:aCols[oMsGetPAG:nAt,1] == oBmpNo,oBmpOK,oBmpNo)}
    EndIf
    //aCols     - Datos del Grid
    //Desativa las manipulaciones
    oMsGetPAG:lActive := .F.

    ACTIVATE MSDIALOG oDlgPvt CENTERED
    RestArea(aArea)
Return


Static Function SEKDETGRID()
    Local aArea  := GetArea()
    Local cQuery   := ""
    Local nTotal := 0
    cQuery := "SELECT SA6.A6_COD AS CODBANCO, SA6.A6_NOME AS BANCO, SEK.EK_XNUMCAR AS SEC, SEK.EK_XCARFEC AS FECHACARTA ,SUM(SEK.EK_VALOR) AS TOTAL "      + CRLF
    cQuery += " FROM  " + RetSQLName('SEK') + " SEK"                                                 + CRLF
    cQuery += "     INNER JOIN "+RetSQLName('SA2')+ " SA2" +" ON SEK.EK_FORNECE = SA2.A2_COD"        + CRLF
    cQuery += "                      AND SEK.EK_LOJA    = SA2.A2_LOJA"                               + CRLF
    cQuery += "     INNER JOIN "+RetSQLName('FIL')+ " FIL" + " ON FIL.FIL_FORNEC = SEK.EK_FORNECE"   + CRLF
    cQuery += "                      AND FIL.FIL_TIPO   = '1'"                                       + CRLF
    cQuery += "     INNER JOIN "+RetSQLName('Z41')+ " Z41" + " ON Z41.Z41_BANCO = FIL.FIL_BANCO "    + CRLF
    cQuery += "     INNER JOIN "+RetSQLName('SEK')+ " S " + " ON S.EK_FILIAL = SEK.EK_FILIAL"        + CRLF
    cQuery += "                      AND S.EK_ORDPAGO  = SEK.EK_ORDPAGO"                             + CRLF
    cQuery += "                      AND S.EK_TIPODOC  = 'CP'"                                       + CRLF
    cQuery += "     INNER JOIN  "+RetSQLName('SA6')+ " SA6 " + " ON SA6.A6_FILIAL   = S.EK_FILIAL"   + CRLF
    cQuery += "                       AND SA6.A6_COD     = S.EK_BANCO"                               + CRLF
    cQuery += "                       AND SA6.A6_AGENCIA = 'BCO'"                                    + CRLF
    cQuery += " WHERE SEK.EK_TIPODOC IN('PA','TB') "                                                 + CRLF
    cQuery += "  AND SEK.EK_TIPO IN('PA','NF') "                                                     + CRLF
    cQuery += "  AND SEK.EK_FILIAL  = '" +cEmpCod+ "'"                                               + CRLF
    //  cQuery += "  AND SA6.A6_COD = '" +MV_PAR01+ "'"                                                     + CRLF
    cQuery += "  AND SA6.A6_COD = '01' "                                                                    + CRLF
    cQuery += "  AND SEK.EK_LA <> 'C'"                                                                      + CRLF
    cQuery += "  AND SEK.D_E_L_E_T_ <> '*' AND SA2.D_E_L_E_T_ <> '*'"                                       + CRLF
    cQuery += "  AND S.D_E_L_E_T_ <> '*'"                                                                   + CRLF
    cQuery += "  AND SEK.EK_CANCEL = 'F' "                                                                  + CRLF
    cQuery += "  AND SEK.EK_XCARSTS = 'P' "                                                                + CRLF
    cQuery += "  AND SEK.EK_NATUREZ <> '201003' "                                                         + CRLF
    cQuery += "  AND SEK.EK_XNUMCAR = '" +MV_PAR03+ "'"                                                     + CRLF
    cQuery += "  GROUP BY SA6.A6_COD, SA6.A6_NOME ,SEK.EK_XNUMCAR, SEK.EK_XCARFEC"                    + CRLF
    TCQuery cQuery New Alias "SQL_SEK"

    Count To nTotal
    ProcRegua(nTotal) //Calcula cuantas informacion existe
    //Se posiciona en el primer registro
    SQL_SEK->(DbGoTop())

    If ! SQL_SEK->(EoF())
        bVeficar := .T.
    EndIf
    While ! SQL_SEK->(EoF())
        //Adiciona o item no aCols
        aAdd(aCols, { ;
            oBmpOK,;
            SQL_SEK->CODBANCO,;
            SQL_SEK->BANCO,;
            SQL_SEK->SEC,;
            SQL_SEK->FECHACARTA,;
            SQL_SEK->TOTAL,;
            .F. ;
            })

        SQL_SEK->(DbSkip())
    EndDo
    SQL_SEK->(DbCloseArea())

    RestArea(aArea) //Restaura un entorno grabado anteriormente por la función GETAREA()
Return

Static Function SEKPROCCESS()
    Local aColsAux := oMsGetPAG:aCols //Objeto de MsNewGetDatos del Grid para la carga de informacion detalle
    Local bPosCheck  := aScan(aHead, {|x| Alltrim(x[2]) == "CHECK"})
    Local nPosCODBANCO  := aScan(aHead, {|x| Alltrim(x[2]) == "CODBANCO"})
    Local nLinea   := 0
    Local cQuery   := ""
    Local nTotal := 0
    cQuery := "SELECT SEK.EK_ORDPAGO, SEK.EK_NUM,  SEK.EK_TIPO, SEK.EK_TIPODOC AS TDOC, SEK.EK_PREFIXO, SEK.EK_PARCELA, SEK.EK_SEQ,"      + CRLF
    cQuery += "       SEK.EK_VALOR, SEK.EK_FORNECE, SA2.A2_NOME,"                                    + CRLF
    cQuery += "       SEK.EK_EMISSAO, SEK.EK_VENCTO,  SEK.EK_FORNEPG, SEK.EK_NATUREZ,"               + CRLF
    cQuery += "       FIL.FIL_CONTA,  FIL.FIL_TIPCTA, FIL.FIL_TIPO,   FIL.FIL_MOVCTO,"               + CRLF
    cQuery += "       SEK.EK_BANCO,   SA6.A6_NUMCON,  SA6.A6_NREDUZ,  SA6.A6_CONTATO,"               + CRLF
    cQuery += "       SEK.EK_CONTA,   SEK.EK_LA,      S.EK_NUM,          S.EK_FORNECE,"              + CRLF
    cQuery += "       S.EK_FORNEPG,   Z41.Z41_CODBAN AS CODBANCO, Z41.Z41_CODALT, Z41.Z41_DESCRI"    + CRLF
    cQuery += " FROM  " + RetSQLName('SEK') + " SEK"                                                 + CRLF
    cQuery += "     INNER JOIN "+RetSQLName('SA2')+ " SA2" +" ON SEK.EK_FORNECE = SA2.A2_COD"        + CRLF
    cQuery += "                      AND SEK.EK_LOJA    = SA2.A2_LOJA"                               + CRLF
    cQuery += "     INNER JOIN "+RetSQLName('FIL')+ " FIL" + " ON FIL.FIL_FORNEC = SEK.EK_FORNECE"   + CRLF
    cQuery += "                      AND FIL.FIL_TIPO   = '1'"                                       + CRLF
    cQuery += "     INNER JOIN "+RetSQLName('Z41')+ " Z41" + " ON Z41.Z41_BANCO = FIL.FIL_BANCO "    + CRLF
    cQuery += "     INNER JOIN "+RetSQLName('SEK')+ " S " + " ON S.EK_FILIAL = SEK.EK_FILIAL"        + CRLF
    cQuery += "                      AND S.EK_ORDPAGO  = SEK.EK_ORDPAGO"                             + CRLF
    cQuery += "                      AND S.EK_TIPODOC  = 'CP'"                                       + CRLF
    cQuery += "     INNER JOIN  "+RetSQLName('SA6')+ " SA6 " + " ON SA6.A6_FILIAL   = S.EK_FILIAL"   + CRLF
    cQuery += "                       AND SA6.A6_COD     = S.EK_BANCO"                               + CRLF
    cQuery += "                       AND SA6.A6_AGENCIA = 'BCO'"                                    + CRLF
    cQuery += " WHERE SEK.EK_TIPODOC IN('PA','TB') "                                                 + CRLF
    cQuery += "  AND SEK.EK_TIPO IN('PA','NF') "                                                     + CRLF
    cQuery += "  AND SEK.EK_FILIAL  = '" +cEmpCod+ "'"                                               + CRLF
    //  cQuery += "  AND SA6.A6_COD = '" +MV_PAR01+ "'"                                                     + CRLF
    cQuery += "  AND SA6.A6_COD = '01' "                                                                    + CRLF
    cQuery += "  AND SEK.EK_LA <> 'C'"                                                                      + CRLF
    cQuery += "  AND SEK.D_E_L_E_T_ <> '*' AND SA2.D_E_L_E_T_ <> '*'"                                       + CRLF
    cQuery += "  AND S.D_E_L_E_T_ <> '*'"                                                                   + CRLF
    cQuery += "  AND SEK.EK_CANCEL = 'F' "                                                                  + CRLF
    cQuery += "  AND SEK.EK_XCARSTS = 'P' "                                                                + CRLF
    cQuery += "  AND SEK.EK_XNUMCAR = '" +ALLTRIM(MV_PAR03)+ "'"                                                         + CRLF
    cQuery += "  AND SEK.EK_NATUREZ <> '201003' "                                                         + CRLF
    cQuery += "  ORDER BY SA2.A2_NOME ASC "

    TCQuery cQuery New Alias "SQL_SEK"

    Count To nTotal
    ProcRegua(nTotal) //Calcula cuantas informacion existe
    //Se posiciona en el primer registro
    If MsgYesNo("Confirmar de Liberacion de Carta..? ")
        DbSelectArea('SEK')
        //Recorriendo lineas del Grid
        // Begin Transaction
        For nLinea := 1 To Len(aColsAux)
            //Posicion del Grid
            If aColsAux[nLinea][bPosCheck] == oBmpOK
                cBancoN := aColsAux[nLinea][nPosCODBANCO]
                dbSetOrder(1)
                SQL_SEK->(DbGoTop())
                While ! SQL_SEK->(EoF())

                    // EK_FILIAL+EK_ORDPAGO+EK_TIPODOC+EK_PRFIXO+EK_NUM+EK_PARCELA+EK_TIPO+EK_SEQ
                    dbSeek(xFilial("SEK") + SQL_SEK->EK_ORDPAGO+SQL_SEK->TDOC+SQL_SEK->EK_PREFIXO+SQL_SEK->EK_NUM+SQL_SEK->EK_PARCELA+SQL_SEK->EK_TIPO+SQL_SEK->EK_SEQ)     // Busca exacta
                    IF FOUND()    // Evalúa la devolución de la búsqueda realizada.
                        RecLock("SEK", .F.)
                        SEK->EK_XCARSTS := 'L'
                        SEK->EK_XCARUSR := FwGetUserName(RetCodUsr())
                        SEK->(MsUnlock())

                        dbSeek(xFilial("SEK") + SQL_SEK->EK_ORDPAGO + 'CP')     // Busca exacta
                        IF FOUND()    // Evalúa la devolución de la búsqueda realizada.
                            RecLock("SEK", .F.)
                            SEK->EK_XCARSTS := 'L'
                            SEK->EK_XCARUSR := FwGetUserName(RetCodUsr())
                            SEK->(MsUnlock()) //Destraba el registro
                        ENDIF
                    ENDIF
                    SQL_SEK->(DbSkip())
                EndDo
                SQL_SEK->(DbCloseArea())
            EndIf
        Next
        DBCloseArea()
        //End Transaction
    EndIf
    MsgInfo("Liberacion Exitosa..!","A V I S O")
    oDlgPvt:End() //Cierra la Venta de Dialogo
Return
