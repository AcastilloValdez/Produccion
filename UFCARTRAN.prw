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
//Define el cambio de linea para cambiar de renglon
#Define STR_PULA    Chr(13)+Chr(10)
#Define STR_TAB     Chr(9)

Static cFileTxt := ""                         //Nombre del archivo
StaTic cFileExt := ".txt"                     //Extencion del archivo plano
Static cDatos   := ""                         // Variable que tendra los datos para el rchivo .TXT
Static cEmpCod  := ""
Static oBmpOK := LoadBitmap(GetResource(),"LBOK") //Objeto tipo check OK
Static oBmpNo := LoadBitmap(GetResource(),"LBNO") //Objeto tipo check NO
Static cQueryCopia
Static nSecuencia:= "00000000"
User Function UFCARTRAN
    //Local lSigue 		:= .T.
    STATIC cPerg    := "UBANC01"
    //Local cFilCod   := FWCodFil()
    //PRIVATE cAliasSEK	:= 	GetNextAlias()//"SEK"
    //Private nTotReg 	:= 0
    cEmpCod   := FWCodEmp() //Obtiene el codigo de la empresa,
    If !Pergunte(cPerg,.T.) //Form de Visualizacion de Preguntas
        Return
    EndIf
    UCABGRID()
    If MV_PAR01 = ' '
        MsgAlert(MV_PAR01)
        //		lSigue := .F.
    End if
    //cSEK := RetSqlName('SEK')
    //cSA2 := RetSqlName('SA2')
 /*   
    cQuery := "SELECT SEK010.EK_ORDPAGO, SEK010.EK_NUM,     SEK010.EK_TIPO,"
    cQuery += "       SEK010.EK_VALOR,   SEK010.EK_FORNECE, SA2010.A2_NOME,"
    cQuery += "       SEK010.EK_EMISSAO, SEK010.EK_VENCTO,  SEK010.EK_FORNEPG, SEK010.EK_NATUREZ,"
    cQuery += "       FIL010.FIL_CONTA,  FIL010.FIL_TIPCTA, FIL010.FIL_TIPO,   FIL010.FIL_MOVCTO,"
    cQuery += "       SEK010.EK_BANCO,   SA6010.A6_NUMCON,  SA6010.A6_NREDUZ,  SA6010.A6_CONTATO,"
    cQuery += "       SEK010.EK_CONTA,   SEK010.EK_LA,      S.EK_NUM,          S.EK_FORNECE,"
    cQuery += "       S.EK_FORNEPG,      '' AS CODBANCO"
    cQuery += " FROM SEK010"
    cQuery += "     INNER JOIN SA2010 ON SEK010.EK_FORNECE = SA2010.A2_COD"
    cQuery += "                      AND SEK010.EK_LOJA    = SA2010.A2_LOJA"
    cQuery += "     INNER JOIN FIL010 ON FIL010.FIL_FORNEC = SEK010.EK_FORNECE"
    cQuery += "                      AND FIL010.FIL_TIPO   = '1'"
    cQuery += "     INNER JOIN SEK010 S ON S.EK_FILIAL = SEK010.EK_FILIAL"
    cQuery += "                      AND S.EK_ORDPAGO  = SEK010.EK_ORDPAGO"
    cQuery += "                      AND S.EK_TIPODOC  = 'CP'"
    cQuery += "     INNER JOIN SA6010 ON SA6010.A6_FILIAL   = S.EK_FILIAL"
    cQuery += "                       AND SA6010.A6_COD     = S.EK_BANCO"
    cQuery += "                       AND SA6010.A6_AGENCIA = 'BCO'"
    cQuery += " WHERE SEK010.EK_FILIAL  = '" +cEmpCod+ "'"
    cQuery += "  AND SEK010.EK_ORDPAGO = '000036'"
    cQuery += "  AND SEK010.EK_TIPODOC = 'TB'"
    cQuery += "  AND SEK010.EK_LA     <> 'C'"
    cQuery += "  AND SEK010.D_E_L_E_T_ <> '*' AND SA2010.D_E_L_E_T_ <> '*'"
    cQuery += "  AND S.D_E_L_E_T_ <> '*'"
    //ejecuto el sql para obterner los datos
    cQuery   := ChangeQuery(cQuery)
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'PAGOS',.T.,.T.)
    TCSetField( 'PAGOS', 'EK_EMISSAO', 'D',8, 0)
	TCSetField( 'PAGOS', 'EK_VALOR'  , 'N',15, 2)
    DbSelectArea("PAGOS")
	    Count To nTotReg
	DbGoTop()
    DbSelectArea("PAGOS")
	DbGoTop()*/
Return
Static Function BuscBanco(nOp, cOrden, cTipoDoc, cNum, cTipo,cCuentaE,nValor,cTipoCu, cCuentaP,cRuc,cNombreP,dFechCart, Banco,cidBanco)
    StaTic cDir     := "\\vm02milfss04\Bancos\"  // Ruta donde debera quedar guardado el documento para procesamiento por SIPECOM        \\02milsas01\Documentos\T0201\Facturas
    cFileTxt := "T02"+cEmpCod+DTOS(MV_PAR03)+AllTrim(MV_PAR02)
    cDir     += "T02"+cEmpCod +"\"
DO CASE
	CASE ALLTRIM(cidBanco) = "01" //BOLIVARIANO
            cDir     += "Bolivariano\"
            UBANKBOLIV(nOp, cOrden, cTipoDoc, cNum, cTipo,cCuentaE,nValor,cTipoCu, cCuentaP,cRuc,cNombreP,dFechCart, Banco)
	CASE ALLTRIM(cidBanco) = "02" //Citybank
            cDir     += "Citybank\"
           // UPCITYBANK()
            UPCITYBANK(nOp, cOrden, cTipoDoc, cNum, cTipo,cCuentaE,nValor,cTipoCu, cCuentaP,cRuc,cNombreP,dFechCart, Banco)
	CASE ALLTRIM(cidBanco) = "04" //Guayaquil
            cDir     += "Guayaqui\"
	CASE ALLTRIM(cidBanco) = "06" //Internacional
            cDir     += "Internacional\"
           // UBANKINTER()
           UBANKINTER(nOp, cOrden, cTipoDoc, cNum, cTipo,cCuentaE,nValor,cTipoCu, cCuentaP,cRuc,cNombreP,dFechCart,Banco)
	CASE ALLTRIM(cidBanco) = "08" //Pacifico
            cDir     += "Pacifico\"
	CASE ALLTRIM(cidBanco) = "09" //"PICHINCHA"
            cDir     += "Pichinch\"
            UBANKPCHA(nOp, cOrden, cTipoDoc, cNum, cTipo,cCuentaE,nValor,cTipoCu, cCuentaP,cRuc,cNombreP,dFechCart,Banco)          
	CASE ALLTRIM(cidBanco) = "10" //"PRODUBANCO"
            cDir     += "Produbanco\"
            UPRODUBANK(nOp, cOrden, cTipoDoc, cNum, cTipo,cCuentaE,nValor,cTipoCu, cCuentaP,cRuc,cNombreP,dFechCart,Banco)
ENDCASE
   //Opcion = 1 El dato seleccionado del Grid obtenemos los campo y enviamos los datos para el proceso de concatenar el txt
            //Opcion = 2 Genera el archivo                                                                                       //Banco traer del Z41_CODBAN
Return    
//Genera archivo plano del banco BOLIVARIANO
Static Function UBANKBOLIV(Opcion, cOrden, cTipoDoc, cNum, cTipo,cCuentaE,nValor,cTipoCu, cCuentaP,cRuc,cNombreP,cFech,Banco)
    //Suma el total a pagar o transferir
    //WHILE !EOF()
    //    nTotPagos += PAGOS->EK_VALOR
    //DbSkip()
    //End DO
    /*
    cCtaCli     := Posicione("SA6",1,xFilial("SA6") + TRB->EK_BANCO + TRB->EK_AGENCIA + TRB->EK_CONTA,"A6_NUMCON")//Numero de cuenta el cliente pagador, numerico 10
    cFhPag      := DTOS(MV_PAR12)//Fecha de pago, fecha 6 AA/MM/D
    */
    /*
    cRuta := "C:\Temp\"+cFileTxt+".txt"
	While ( nHnd  := FCreate(cRuta) ) == -1
		If !MsgYesNo("No se puede Crear el Archivo "+Alltrim(cFileTxt)+Chr(13)+Chr(10)+"Continua?")
	      lSigue   := .F.
	      Exit
		EndIf
	End
    */
    //
    /*cDatos := ""
    DbSelectArea("PAGOS")
    DbGoTop()
    nTotPagos := 0
    nSecuencia:= "000000"*/
   // WHILE !EOF()
   If Opcion == 1
        cA01  := "BZDET"
        nSecuencia := soma1(nSecuencia)
        cA02  := nSecuencia
        cA03  := RTRIM(cRuc) + Replicate(" ", 18-Len(RTRIM(cRuc)))//ruc
        IF (LEN(ALLTRIM(cRuc))) == 13
            cA04  := "R"
        ELSEIF LEN(ALLTRIM(cRuc)) == 10
            cA04  := "C"
        ELSE
            cA04  := " "
        ENDIF
        cA05  := PadR(RTRIM(cRuc),14," ")
        cA06  := RTRIM(LEFT(cNombreP,60)) + REPLICATE(" ",60-Len(RTRIM(LEFT(cNombreP,60))))  //PadR(RTRIM(PAGOS->A2_NOME), 60," ")
        IF ALLTRIM(cTipo) == "CH"
            cA07  := "CHE"
        ELSEIF ALLTRIM(Banco) == "34"
            cA07  := "CUE"
        ELSE
            cA07  := "COB"
        ENDIF
        cA08  := "001"
        cA09  := Replicate(" ",2)
        cA10  := Replicate(" ",2)
        cA11  := Replicate(" ",20)
        IF ALLTRIM(cTipo) == "TF" //SI NC
            cA09 := ALLTRIM(Banco)
            cA10 := IIf(RTRIM(cTipoCu) == "1","03","04")
            cA11 := PadR(RTRIM(cCuentaP),20," ")
        ENDIF
        cA12  := "1"
        cA13  := StrZero(nValor,13,0)
        cA14  := PadR(RTRIM(cOrden),60," ")
        cA15  := PadL(RTRIM(cNum),15," ")
        cA16  := Replicate("0",15)
        cA17  := Replicate("0",15)
        cA18  := Replicate("0",20)
        cA19  := Replicate(" ",10)
        cA20  := Replicate(" ",50)
        cA21  := Replicate(" ",50)
        cA22  := Replicate(" ",20)
        cA23  := "PROD"
        cA24  := Replicate(" ",10)
        cA25  := Replicate(" ",10)
        cA26  := Replicate(" ",10)
        cA27  := " "
        cA28  := IIf(cEmpCod == "01", "00484", "     ")
        cA29  := Replicate(" ",6)
        cA30  := "RPA"
        cDatos += cA01+cA02+cA03+cA04+cA05+cA06+cA07+cA08+cA09+cA10+cA11+cA12+cA13+cA14+cA15+cA16+cA17+cA18+cA19+cA20+cA21+cA22+cA23+cA24+cA25+cA26+cA27+cA28+cA29+cA30 +STR_PULA
       // nTotPagos += nValor
      //  DbSkip()
    Else //End
    //genera archivo txt
        UGENFILE(cDir, cFileTxt, cFileExt, cDatos)
    EndIf
Return

//Genera archivo plano del banco Produbanco
Static Function UPRODUBANK(Opcion, cOrden, cTipoDoc, cNum, cTipo,cCuentaE,nValor,cTipoCu, cCuentaP,cRuc,cNombreP,cFech,Banco)
   /* cDatos := ""
    DbSelectArea("PAGOS")
    DbGoTop()
    nTotPagos := 0
    nSecuencia:= "0000000"
    WHILE !EOF()*/
      /*
   cBancoN := aColsAux[nLinea][nPosCODBANCO]
            cOrden := aColsAux[nLinea][nPosEK_ORDPAGO]
            cTipoDoc := aColsAux[nLinea][nPosEK_TDOC]
            cNum := aColsAux[nLinea][nPosEK_NUM]
            cPref := aColsAux[nLinea][nPosEK_PREFIXO]
            cParcela := aColsAux[nLinea][nPosEK_PARCELA]
            cTipo :=  aColsAux[nLinea][nPosEK_TIPO]
            cSeq := aColsAux[nLinea][nPosEK_SEQ]
            cCuentaE := aColsAux[nLinea][nPosA6_NUMCON]
            nValor := aColsAux[nLinea][nPosEK_VALOR]
            cTipoCu := aColsAux[nLinea][nPosFIL_TIPCTA]
            cCuentaP := aColsAux[nLinea][nPosFIL_CONTA]
            cRuc := aColsAux[nLinea][nPosEK_FORNECE]
            cNombreP := aColsAux[nLinea][nPosA2_NOME]
*/
    If Opcion == 1
        nSecuencia := soma1(nSecuencia)
        cA01 := "PA"
        cA02 := PADL(RTRIM(cCuentaE),11,"0") //Cta empresa
        cA03 := nSecuencia
        cA04 := ""
        cA05 := ALLTRIM(cRuc) //ruc
        cA06 := "USD"
        cA07  := StrZero(nValor,13,0)
        IF ALLTRIM(cTipo) == "CH"
            cA08 := "CHQ"
            cA09 := ""
            cA10 := ""
        ELSE //FIL_TIPCTA:= [1:Corriente];[2:Ahorro]
            cA08 := "CTA"
            cA10 := IIF(RTRIM(cTipoCu)=="1","CTE","AHO")
            cA11 := PadL(RTRIM(cCuentaP),11,"0")
        ENDIF
        DO CASE
            CASE RTRIM(Banco)=="34"
                cA09 := PadL("37",4,"0")
            CASE RTRIM(Banco)=="37"
                cA09 := PadL("34",4,"0")
            OTHERWISE
                cA09 := PadL(Banco,4,"0")
        ENDCASE
        cA12 := IIF((LEN(ALLTRIM(cRuc))) == 13,"R","C")
        IF RTRIM(cTipo) == "CH" //SI ES CHQ
            cA09 := "0036"
        ENDIF
        cA13 := RTRIM(cRuc) //RUC,  PadR(RTRIM(PAGOS->EK_FORNECE),14," ")
        cA14 := RTRIM(cNombreP) + Replicate(" ", 60-Len(RTRIM(cNombreP)))  //NOMBRE,PadR(RTRIM(PAGOS->A2_NOME), 40," ")
        cA15 := ""
        cA16 := ""
        cA17 := "GUAYAQUIL"
        cA18 := RTRIM(cNum)
        cA19 := RTRIM(cOrden)
        cDatos += cA01 +STR_TAB+ cA02 +STR_TAB+ cA03 +STR_TAB+ cA04 +STR_TAB+ cA05 +STR_TAB+;
            cA06 +STR_TAB+ cA07 +STR_TAB+ cA08 +STR_TAB+ cA09 +STR_TAB+ cA10 +STR_TAB+;
            cA11 +STR_TAB+ cA12 +STR_TAB+ cA13 +STR_TAB+ cA14 +STR_TAB+ cA15 +STR_TAB+;
            cA16 +STR_TAB+ cA17 +STR_TAB+ cA18 +STR_TAB+ cA19 +STR_PULA
        //nTotPagos += nValor
       // DbSkip()
   Else// End
    //genera archivo txt
        UGENFILE(cDir, cFileTxt, cFileExt, cDatos)
  EndIf
Return

//Genera archivo plano del banco del pacifico
Static Function UBANKPCHA(Opcion, cOrden, cTipoDoc, cNum, cTipo,cCuentaE,nValor,cTipoCu, cCuentaP,cRuc,cNombreP,cFech,Banco)
   /* cDatos := ""
    DbSelectArea("PAGOS")
    DbGoTop()
    nTotPagos := 0
    nSecuencia:= "0000000"*/
    /*
(A001 Char(02), A002 Char(20), A003 Char(07), A004 Char(20), A005 Char(20), " & _
A006 Char(03), A007 Double,   A008 Char(03), A009 Char(10), A010 Char(03), " & _
A011 Char(20), A012 Char(01), A013 Char(14), A014 Char(40), A015 Char(40), " & _
A016 Char(20), A017 Char(20), A018 Char(20), A019 Char(200), A020 Char(100) ) "
    */
 //   WHILE !EOF()
 If Opcion == 1
        nSecuencia := soma1(nSecuencia)
        cA01 := "PA"
        cA02 := PADL(RTRIM(cCuentaE),11,"0") //Cta empresa
        cA03 := nSecuencia
        cA04 := ""
        cA05 := ALLTRIM(cRuc) //ruc
        cA06 := "USD"
        cA07  := StrZero(nValor,13,0)
        IF ALLTRIM(cTipo) == "CH"
            cA08 := "CHQ"
            cA09 := ""
            cA10 := ""
        ELSE //FIL_TIPCTA:= [1:Corriente];[2:Ahorro]
            cA08 := "CTA"
            cA10 := IIF(RTRIM(cTipoCu)=="1","CTE","AHO")
            cA11 := PadL(RTRIM(cCuentaP),11,"0")
        ENDIF
        DO CASE
            CASE RTRIM(Banco)=="34"
                cA09 := PadL("37",4,"0")
            CASE RTRIM(Banco)=="37"
                cA09 := PadL("34",4,"0")
            OTHERWISE
                cA09 := PadL(Banco,4,"0")
        ENDCASE
        cA12 := IIF((LEN(ALLTRIM(cRuc))) == 13,"R","C")
        IF RTRIM(cTipo) == "CH" //SI ES CHQ
            cA09 := "0036"
        ENDIF
        cA13 := RTRIM(cRuc) //RUC de proveedor,  PadR(RTRIM(PAGOS->EK_FORNECE),14," ")
        cA14 := RTRIM(cNombreP) + Replicate(" ", 60-Len(RTRIM(cNombreP)))//NOMBRE de proveedor,PadR(RTRIM(PAGOS->A2_NOME), 40," ")
        cA15 := ""
        cA15 := ""
        cA16 := ""
        cA17 := "GUAYAQUIL"
        cA18 := RTRIM(cNum) //numero de transaccion de la orden
        cA19 := RTRIM(cOrden) //orden de pago
        cDatos += cA01 +STR_TAB+ cA02 +STR_TAB+ cA03 +STR_TAB+ cA04 +STR_TAB+ cA05 +STR_TAB+;
            cA06 +STR_TAB+ cA07 +STR_TAB+ cA08 +STR_TAB+ cA09 +STR_TAB+ cA10 +STR_TAB+;
            cA11 +STR_TAB+ cA12 +STR_TAB+ cA13 +STR_TAB+ cA14 +STR_TAB+ cA15 +STR_TAB+;
            cA16 +STR_TAB+ cA17 +STR_TAB+ cA18 +STR_TAB+ cA19 +STR_PULA
       // nTotPagos += nValor
       // DbSkip()
  Else //  End
    //genera archivo txt
        UGENFILE(cDir, cFileTxt, cFileExt, cDatos)
  EndIf
Return

       
Static Function UPCITYBANK(Opcion, cOrden, cTipoDoc, cNum, cTipo,cCuentaE,nValor,cTipoCu, cCuentaP,cRuc,cNombreP,cFech,Banco)
  //  DbSelectArea("PAGOS")
 //   DbGoTop()
    nTotPagos := 0
// WHILE !EOF()
IF Opcion == 1
        nSecuencia := soma1(nSecuencia)
        cA01 := "PAY218" //fijo
        cA02 := PadL(cCuentaE,10,"0") //Cta empresa
        cFecha := DTOS(cFech)
        cA03 := SUBSTR(cFecha,3,6) //FECHA CARTA
        cA09 := "USD" //moneda
        cA07  := StrZero(nValor,13,0) //valor del orden de pago
        cA30 := "001" //fijo
        cA18_0 := "--"
        IF ALLTRIM(cTipo) == "CH" //
            cA05 := "077" //fijo
            cA17 := "02" //fijo
            cA26 := "nullCH"
        else
            DO CASE
                CASE RTRIM(Banco)<>"24"
                    cA05 := "071"//PadL("37",4,"0") //fijo
                    cA17 := "21" //fijo
                    cA24 :=  PadL(RTRIM(cCuentaP),11,"0")    //cuenta proveedor cA28
                    cA26 := "CDA" // codigo alterno Cod_Alterno(Trim(RsPagos!Codbanco))
                    cA29 := IIF(RTRIM(cTipoCu) == "1","01","02") //1:corriente, 2:ahorro
                CASE RTRIM(Banco)=="24"
                    cA05 := "072"//PadL("34",4,"0") fijo
                    cA17:= "01" //fijo
                    cA24 := "null24" //CUENTA PROVEEDOR
                    cA26 := "null" // codigo alterno Cod_Alterno(Trim(RsPagos!Codbanco))
                    cA29 := "null29"
                OTHERWISE
                    cA05 := "AAA"
                    cA17:= "PT"
                    cA24 :=  PadL(RTRIM(cCuentaP),11,"0")
                    cA29 := PadL(Banco,4,"0")
                    cA18_0 := "0-"
            ENDCASE
        ENDIF
        cA06 := RTRIM(cOrden) + Replicate(" ", 16-Len(RTRIM(cOrden)))//Audittrail orden de pago
        cA08 := nSecuencia //fijo Format(WNumRec, "####0") vendedor id si es 10 o 13 caracteres
        cA11:= ALLTRIM(cRuc) + Replicate(" ", 21-Len(RTRIM(cRuc))) //vendedor ID longitud 21 con cA08 incluido
        cA12:= Replicate(" ",5)
        cA13 := RTRIM(StrZero(nValor,21,0)) //valor de pago->(TRXAMNT)        //RTRIM(PAGOS->EK_FORNECE) //RUC,  PadR(RTRIM(PAGOS->EK_FORNECE),14," ")
        cA14 := "000"
        cRucP := RTRIM(cRuc)
        cOrdenPago := RTRIM(cOrden)
        cTransaccion := RTRIM(cNum)
        cUnion := cRucP + cOrdenPago + cTransaccion
        cA15 := PadR(RTRIM(cUnion),30," ") //REPARACION BOMBA INYECCION  //NOMBRE DESCRIPCION //NOMBRE,PadR(RTRIM(PAGOS->A2_NOME), 40," ")
        cA16 := Replicate(" ",10)
        cA16_1 := Replicate(" ",30)
        cA16_2 := Replicate(" ",30)
        cA16_3 := Replicate(" ",30)
        cA18 := "01" //fijo
        cA19:= PadR(RTRIM(cNombreP),65," ") //nombre del proveedor
        cA20 := "GUAYAQUIL" //fijo
        cA20_1 := Replicate(" ",61)
        cA21 := "PLAZA DEL SOL" //fijo
        cA21_1 := Replicate(" ",4)
        cA22 := RTRIM("000000000000")//fijo
        cA22_1 := Replicate(" ",20)
        cA23 := RTRIM("00000000")//fijo"00000000"
        cA23_1 := Replicate(" ",20)
        cA24_1 := Replicate(" ",20)
        cA24_2 := Replicate(" ",30)
        cA24_3 := Replicate(" ",40)
        cA25 := "999999999999999" //fijo
        cA27 := "2"
        cAdicional := Replicate(" ",30)
        cDatos += cA01+cA02+cA03+cA05+cA06+cA08+cA11+cA09+cA11+cA12+;
            cA13+cA14+cA15+cA16+cA16_1+cA16_2+cA16_3+cA18_0+cA17+cA18+cA19+;
            cA20+cA20_1+cA21+cA21_1+cA22+cA22_1+cA23+cA23_1+cA29+cA24+cA24_1+cA30+cA24_2+cA24_3+;
            cA25+cA27+cAdicional+STR_PULA
       // nTotPagos += nValor
     //   DbSkip()
   // End
    //DbCloseArea("PAGOS")
    //genera archivo txt
Else
  UGENFILE(cDir, cFileTxt, cFileExt, cDatos)
EndIf
Return

Static Function UBANKINTER(Opcion, cOrden, cTipoDoc, cNum, cTipo,cCuentaE,nValor,cTipoCu, cCuentaP,cRuc,cNombreP,cFech,Banco)
  If Opcion == 1
        nSecuencia := soma1(nSecuencia)
        cA01  := "PA" //CODIGO FIJO
        cA02 := Replicate(" ",10)
        cA03  := PadL(RTRIM(cCuentaE),10,"0")//RUC DEL PROVEEDOR
        cA04 := Replicate(" ",3)
        cA05  := nSecuencia //SECUENCIA 1,2,3....
        cA06 := Replicate(" ",10)
        cA07 :=  RTRIM(cNum) //NUMERO DE TRASACCION de la orden
        cA08 := Replicate(" ",2)
        cA09  := RTRIM(cRuc) + Replicate(" ", 16-Len(RTRIM(cRuc)))//ruc de proveedor
        cA10 := Replicate(" ",10)
        cA11 := "USD" //MONEDA
        cA12 := Replicate(" ",4)
        cA13 := Replicate(" ",2)
        cA14 := PadR(nValor,8," ") //valor de la orden de pago
        cA15 := Replicate(" ",4)
        cA16 := "CTA" //FIJO
        cA17 := Replicate(" ",4)
        cA18 := Replicate(" ",2)
        cA19 := IIF(RTRIM(Banco)=="34","37","BAN") //asignacion codigo de banco RTRIM(PAGOS->CODBANCO)
        cA20 := Replicate(" ",10)
        cA21 := IIF(RTRIM(cTipoCu)=="1","CTE","AHO") //asignacion de cuenta //FIL_TIPCTA:= [1:Corriente];[2:Ahorro]
        cA22 := Replicate(" ",10)
        cA23 := Replicate(" ",10)
        cA24 := PadL(RTRIM(cCuentaP),10," ") //numero de cuenta del proveedor
        cA25 := Replicate(" ",10)
        cA26 := Replicate(" ",4)
        cA27 := IIF(Len(RTRIM(cRuc))==10,"C","R") //ruc del proveedor
        cA28 := Replicate(" ",10)
        cA29 := Replicate(" ",10)
        cA30 := RTRIM(cRuc) + Replicate(" ", 16-Len(RTRIM(cRuc))) //ruc del proveedor
        cA31 := Replicate(" ",10)
        cA32 := Replicate(" ",10)
        cA33 := PadR(RTRIM(cNombreP),48," ") //nombre del proveedor
        cA34 := Replicate(" ",10)
        cA35 := PadR(RTRIM(cOrden),30," ") //orden de pago
        cA36 :=  RTRIM(cRuc) + RTRIM(cOrden) +  RTRIM(cNum) //remplaza por el nombre de la actividad
        cDatos += cA01+STR_TAB+cA03+STR_TAB+cA05+STR_TAB+cA07+cA08+;
            cA09+cA10+STR_TAB+cA14+STR_TAB+cA16+STR_TAB+;
            cA19+STR_TAB+cA21+STR_TAB+cA24+STR_TAB+cA27+STR_TAB+;
            cA30+cA31+cA32+cA33+cA34+cA35+cA36 +STR_PULA
  Else
    UGENFILE(cDir, cFileTxt, cFileExt, cDatos)
EndIf
Return

Static Function UGENFILE(cDir, cFileTxt, cFileExt, cDatos)
    Local nHandle := 0
    //cRandom - STRZERO permite pasar de num a string con una cantidad estatica de espacios,
    // param1 numero a cambiar, param2 cantidad de espacios, param3 en caso de decimales cuantos
    //cRandom := STRZERO(Random(1,1000),5,0)
    Local cRoute  := "c:\Temp\"+cFileTxt+cFileExt
    nHandle       := FCreate(cRoute,FC_NORMAL,0,.F.)

    If nHandle < 0
        MsgAlert("El archivo no se creó:" + STR(FERROR()))
    Else
        FWrite(nHandle,cDatos)
        FClose(nHandle)
        MsgInfo("Archivo Generado correctamente...","Carta de Transferencia")
    EndIf
Return


Static Function UCABGRID()
    Local aArea := GetArea()
    Local oPedido
    Local cCodBanco := MV_PAR01
    Local cFechIni := MV_PAR02
    Local cFechFin := MV_PAR03
    Local cFechCar := MV_PAR04
    Local cDiri := MV_PAR05
    Local cNombre := MV_PAR06

    cVar1 := DTOS(MV_PAR02) //Convierte fecha a caracter con un formato ejemplo 23/04/2021 a 20210423 tipo caracter
    // M + posicion 7 hasta 2 caracter al extraer el |03| dia 202104|03-> dia
    cFech := "M" + SUBSTR(cVar1,7,2) + SUBSTR(cVar1,5,2) +  SUBSTR(cVar1,3,2)
    // cAno := SUBSTR(cVar1,3,2)
    //cMes := SUBSTR(cVar1,5,2)
    //  cdia := SUBSTR(cVar1,7,2)
    // cUnion := "M" + cdia + cMes + cAno

    cNoCon := "PICHINCHA"
    //Objetos da Janela
    Private oDlgPvt
    Private oMsGetPAG
    Private aHead := {}
    Private aCols := {}
    Private oBtnProc
    //Tamanho da Janela
    Private    nJanLarg    := 700
    Private    nJanAltu    := 500
    //Fontes
    Private    cFontUti   := "Tahoma"
    Private    oFontAno   := TFont():New(cFontUti,,-38)
    Private    oFontSub   := TFont():New(cFontUti,,-20)
    Private    oFontSubN  := TFont():New(cFontUti,,-20,,.T.)
    Private    oFontBtn   := TFont():New(cFontUti,,-14)

    //              Título               Campo        Máscara                        Tamanho                   Decimal                   Valid               Usado  Tipo F3     Combo

    aAdd(aHead, {"",            "CHECK",       "@BMP",                              2,                   0,                        ".F.",              "   ", "C", "",    "V",     "",      "",        "", "V"})
    aAdd(aHead, {"Banco",            "BANCO",        "",                            15,  		     	  0,                        ".T.",              ".T.", "C", "",    "" } )
    aAdd(aHead, {"Ruc",              "EK_FORNECE",   "",                            21,  				  0,                        ".T.",              ".T.", "C", "",    "" } )
    aAdd(aHead, {"Proveedor",        "A2_NOME",      "",                            30,  				  0,                        ".T.",              ".T.", "C", "",    "" } )
    aAdd(aHead, {"Orden",            "EK_ORDPAGO",   "",                            15, 					  0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHead, {"Tipo",             "EK_TIPO",      "",                            10,  				  0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHead, {"Cuenta Proveedor", "FIL_CONTA",   "",                            20, 				  0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHead, {"Tipo Cuenta",      "FIL_TIPCTA",   "",                            20, 				  0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHead, {"Tipo Dcto",        "TDOC",   "",                                  2, 				  0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHead, {"Prefijo Titulo",   "EK_PREFIXO",   "",                            3, 				  0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHead, {"Cuota",            "EK_PARCELA",   "",                            3, 				  0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHead, {"Sec.Registro",     "EK_SEQ",   "",                                2, 				  0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHead, {"Cuenta Empresa",     "A6_NUMCON",    "",                           20, 					  0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHead, {"#Transaccion",     "EK_NUM",       "",                            13,  				  0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHead, {"Valor",            "EK_VALOR",    "@E 999,999,999,999,999.99",    18, 		    	  0,                        ".T.",              ".T.", "N", "",    ""} )

    Processa({|| UDETGRID() }, "Cargando ... Espere ....")
    //Criação da tela com os dados que serão informados
    DEFINE MSDIALOG oDlgPvt TITLE "CARTA TRANSFERENCIA" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
    //Labels gerais
    @ 004, 005 SAY oSay1 PROMPT  "Codigo:" SIZE 040, 007 OF oDlgPvt PIXEL
    @ 011, 005 MSGET oPedido VAR cCodBanco SIZE 045, 010 OF oDlgPvt   READONLY PIXEL
    @ 004, 070 SAY oSay2 PROMPT  "Fecha Carta:" SIZE 040, 007 OF oDlgPvt PIXEL
    @ 011, 070 MSGET oPedido VAR  cFechCar SIZE 040, 010 OF oDlgPvt  READONLY PIXEL
   /* @ 004, 132 SAY oSay3 PROMPT  "Banco:" SIZE 025, 007 OF oDlgPvt PIXEL
    @ 011, 132 MSGET oPedido VAR cNoCon SIZE 131, 010 OF oDlgPvt READONLY PIXEL*/
    @ 024, 005 SAY oSay4 PROMPT "Fecha Inicial:" SIZE 040, 007 OF oDlgPvt PIXEL
    @ 031, 005 MSGET oPedido VAR cFechIni SIZE 060, 010 OF oDlgPvt READONLY  PIXEL
    @ 024, 070 SAY oSay5 PROMPT "Fecha Final:" SIZE 040, 007 OF oDlgPvt PIXEL
    @ 031, 070 MSGET oPedido VAR cFechFin SIZE 070, 010 OF oDlgPvt READONLY PIXEL
    @ 024, 150 SAY oSay4 PROMPT "Dirigido:" SIZE 035, 007 OF oDlgPvt PIXEL
    @ 031, 150 MSGET oPedido VAR cDiri SIZE 065, 010 OF oDlgPvt  READONLY PIXEL
    @ 024, 220 SAY oSay5 PROMPT "Nombre:" SIZE 035, 007 OF oDlgPvt PIXEL
    @ 031, 220 MSGET oPedido VAR cNombre SIZE 125, 010 OF oDlgPvt  READONLY PIXEL
    //Botones
    @ 008, (nJanLarg/2-001)-(0067*01) BUTTON oBtnProc  PROMPT "Procesar"   SIZE 045, 015 OF oDlgPvt ACTION (Proccess())  FONT oFontBtn PIXEL

    //Grid dos grupos
    oMsGetPAG := MsNewGetDados():New(    045,;                //nTop      - Linha Inicial
        003,;                //nLeft     - Coluna Inicial
        (nJanAltu/2)-3,;     //nBottom   - Linha Final
        (nJanLarg/2)-3,;     //nRight    - Coluna Final
        GD_UPDATE,;                   //nStyle    - Estilos para edição da Grid (GD_INSERT = Inclusão de Linha; GD_UPDATE = Alteração de Linhas; GD_DELETE = Exclusão de Linhas)
        "AllwaysTrue()",;    //cLinhaOk  - Validação da linha
        ,;                   //cTudoOk   - Validação de todas as linhas
        "",;                 //cIniCpos  - Função para inicialização de campos
        {'CHECK'},;                 //aAlter    - Colunas que podem ser alteradas
        ,;                   //nFreeze   - Número da coluna que será congelada
        9999,;               //nMax      - Máximo de Linhas
        ,;                   //cFieldOK  - Validação da coluna
        ,;                   //cSuperDel - Validação ao apertar '+'
        ,;                   //cDelOk    - Validação na exclusão da linha
        oDlgPvt,;            //oWnd      - Janela que é a dona da grid
        aHead,;           //aHeader   - Cabeçalho da Grid
        aCols)
    oMsGetPAG:oBrowse:bLDblClick := {|| oMsGetPAG:EditCell(), oMsGetPAG:aCols[oMsGetPAG:nAt,1] := iif(oMsGetPAG:aCols[oMsGetPAG:nAt,1] == oBmpNo,oBmpOK,oBmpNo)}
    //aCols     - Dados da Grid
    //Desativa as manipulações
    oMsGetPAG:lActive := .F.

    ACTIVATE MSDIALOG oDlgPvt CENTERED
    RestArea(aArea)
Return

Static Function UDETGRID()
    Local aArea  := GetArea()
    Local cQuery   := ""
    Local nTotal := 0
    cQuery := "SELECT SEK.EK_ORDPAGO, SEK.EK_NUM,  SEK.EK_TIPO, SEK.EK_TIPODOC AS TDOC, SEK.EK_PREFIXO, SEK.EK_PARCELA, SEK.EK_SEQ, SEK.EK_XCARFEC, SEK.EK_XCARSTS, SEK.EK_XCARUSR, "      + CRLF
    cQuery += "       SEK.EK_VALOR, SEK.EK_FORNECE, SA2.A2_NOME,"                                    + CRLF
    cQuery += "       SEK.EK_EMISSAO, SEK.EK_VENCTO,  SEK.EK_FORNEPG, SEK.EK_NATUREZ,"               + CRLF
    cQuery += "       FIL.FIL_CONTA,  FIL.FIL_TIPCTA, FIL.FIL_TIPO,   FIL.FIL_MOVCTO,"               + CRLF
    cQuery += "       SEK.EK_BANCO,   SA6.A6_NUMCON,  SA6.A6_NREDUZ,  SA6.A6_CONTATO,"               + CRLF
    cQuery += "       SEK.EK_CONTA,   SEK.EK_LA,      S.EK_NUM,          S.EK_FORNECE,"              + CRLF
    cQuery += "       S.EK_FORNEPG,   Z41.Z41_CODBAN AS CODBANCO, Z41.Z41_CODALT"                    + CRLF
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
    cQuery += "  AND SA6.A6_COD = '" +MV_PAR01+ "'"                                                     + CRLF
    cQuery += "  AND SEK.EK_LA <> 'C'"                                                               + CRLF
    cQuery += "  AND SEK.EK_EMISSAO BETWEEN '" + DTOS(MV_PAR02) + "' AND '"+DTOS(MV_PAR03)+"'" + CRLF
    cQuery += "  AND SEK.D_E_L_E_T_ <> '*' AND SA2.D_E_L_E_T_ <> '*'"                                + CRLF
    cQuery += "  AND S.D_E_L_E_T_ <> '*'"                                                            + CRLF
    cQuery += "  AND SEK.EK_CANCEL = 'F' "                                                            + CRLF
    cQuery += "  ORDER BY SEK.EK_ORDPAGO ASC "

    TCQuery cQuery New Alias "QRY_SEK"

    Count To nTotal
    ProcRegua(nTotal) //Calcula cuantas informacion existe
    //Se posiciona en el primer registro
    QRY_SEK->(DbGoTop())
    While ! QRY_SEK->(EoF())
        //Adiciona o item no aCols
        aAdd(aCols, { ;
            oBmpOK,;
            QRY_SEK->CODBANCO,;
            QRY_SEK->EK_FORNECE,;
            QRY_SEK->A2_NOME,;
            QRY_SEK->EK_ORDPAGO,;
            QRY_SEK->EK_TIPO,;
            QRY_SEK->FIL_CONTA,;
            QRY_SEK->FIL_TIPCTA,;
            QRY_SEK->TDOC,;
            QRY_SEK->EK_PREFIXO,;
            QRY_SEK->EK_PARCELA,;
            QRY_SEK->EK_SEQ,;
            QRY_SEK->A6_NUMCON,;
            QRY_SEK->EK_NUM,;
            QRY_SEK->EK_VALOR,;
            .F. ;
            })

        QRY_SEK->(DbSkip())
    EndDo
    QRY_SEK->(DbCloseArea())

    RestArea(aArea) //Restaura un entorno grabado anteriormente por la función GETAREA()
Return

Static Function Proccess()
    Local aColsAux := oMsGetPAG:aCols //Objeto de MsNewGetDatos del Grid para la carga de informacion detalle
    Local cCodBanco := MV_PAR01
    Local bPosCheck  := aScan(aHead, {|x| Alltrim(x[2]) == "CHECK"})
    Local nPosCODBANCO  := aScan(aHead, {|x| Alltrim(x[2]) == "BANCO"}) //YA
    Local nPosEK_ORDPAGO  := aScan(aHead, {|x| Alltrim(x[2]) == "EK_ORDPAGO"}) //YA
    Local nPosEK_TDOC  := aScan(aHead, {|x| Alltrim(x[2]) == "TDOC"}) //YA
    Local nPosEK_TIPO  := aScan(aHead, {|x| Alltrim(x[2]) == "EK_TIPO"}) //YA
    Local nPosEK_PREFIXO  := aScan(aHead, {|x| Alltrim(x[2]) == "EK_PREFIXO"}) //NO
    Local nPosEK_NUM  := aScan(aHead, {|x| Alltrim(x[2]) == "EK_NUM"})   //YA
    Local nPosEK_PARCELA  := aScan(aHead, {|x| Alltrim(x[2]) == "EK_PARCELA"}) //NO
    Local nPosEK_SEQ  := aScan(aHead, {|x| Alltrim(x[2]) == "EK_SEQ"}) //NO
    Local nPosA6_NUMCON  := aScan(aHead, {|x| Alltrim(x[2]) == "A6_NUMCON"}) //YA
    Local nPosEK_VALOR  := aScan(aHead, {|x| Alltrim(x[2]) == "EK_VALOR"}) //YA
    Local nPosFIL_TIPCTA  := aScan(aHead, {|x| Alltrim(x[2]) == "FIL_TIPCTA"}) //YA
    Local nPosFIL_CONTA  := aScan(aHead, {|x| Alltrim(x[2]) == "FIL_CONTA"}) //YA
    Local nPosEK_FORNECE  := aScan(aHead, {|x| Alltrim(x[2]) == "EK_FORNECE"})
    Local nPosA2_NOME  := aScan(aHead, {|x| Alltrim(x[2]) == "A2_NOME"})
    Local nLinea   := 0
    Local dFechCart := MV_PAR04
    Static cAgencia := ""
    Static cNumCon := ""
    Static  cCod := ""
    Static cValor := ""
    Static nContador := 1
  
    DbSelectArea('SEK')
    cUser := FwGetUserName(RetCodUsr()) //Obtiene el usuario del programa
    //Convierte fecha a caracter con un formato ejemplo 23/04/2021 a 20210423 tipo caracter
                // M + posicion 7 hasta 2 caracter al extraer el |03| dia 202104|03-> dia   
    cVar1 := DTOS(dFechCart)
    cFech := "M" + SUBSTR(cVar1,7,2) + SUBSTR(cVar1,5,2) +  SUBSTR(cVar1,3,2)
  //Recorriendo lineas del Grid
   For nLinea := 1 To Len(aColsAux)
        //Posicion del Grid
        If aColsAux[nLinea][bPosCheck] == oBmpOK
//OBTENER DATOS DEL GRID LOS QUE SON SELEECIONADOS PARA GUARDAR EN EL TXT 
            cBancoN := aColsAux[nLinea][nPosCODBANCO]
            cOrden := aColsAux[nLinea][nPosEK_ORDPAGO]
            cTipoDoc := aColsAux[nLinea][nPosEK_TDOC]
            cNum := aColsAux[nLinea][nPosEK_NUM]
            cPref := aColsAux[nLinea][nPosEK_PREFIXO]
            cParcela := aColsAux[nLinea][nPosEK_PARCELA]
            cTipo :=  aColsAux[nLinea][nPosEK_TIPO]
            cSeq := aColsAux[nLinea][nPosEK_SEQ]
            cCuentaE := aColsAux[nLinea][nPosA6_NUMCON]
            nValor := aColsAux[nLinea][nPosEK_VALOR]
            cTipoCu := aColsAux[nLinea][nPosFIL_TIPCTA]
            cCuentaP := aColsAux[nLinea][nPosFIL_CONTA]
            cRuc := aColsAux[nLinea][nPosEK_FORNECE]
            cNombreP := aColsAux[nLinea][nPosA2_NOME]
            BuscBanco(1, cOrden, cTipoDoc, cNum, cTipo,cCuentaE,nValor,cTipoCu, cCuentaP,cRuc,cNombreP,dFechCart, cBancoN,cCodBanco)
            If nContador == 1
                cSecTran := Consecu(cCodBanco,1,0) //OBTIENE EL CONSECUTIVO DE LA SA6 POR BANCO
                cValor := StrZero(Val(cSecTran),4,0) 
            EndIf
            dbSetOrder(1)      // EK_FILIAL+EK_ORDPAGO+EK_TIPODOC+EK_PRFIXO+EK_NUM+EK_PARCELA+EK_TIPO+EK_SEQ
            dbSeek(xFilial("SEK") + cOrden+cTipoDoc+cPref+cNum+cParcela+cTipo+cSeq)     // Busca exacta
            //  IF  ALLTRIM(cOrden) != cOrdenPagoAuxiliar
            //        nContador :=1
            //   IF nContador == 1
            //      cOrdenPagoAuxiliar := cOrden
            //EndIf
            IF FOUND()    // Evalúa la devolución de la búsqueda realizada.
                RecLock("SEK", .F.)
                SEK->EK_XCARFEC :=  dFechCart
                SEK->EK_XCARSTS := 'P'
                SEK->EK_XCARUSR := FwGetUserName(RetCodUsr())
                SEK->EK_OBSBCO := cFech + cValor//SEK->EK_XNUMCAR := cSecTran
                SEK->(MsUnlock())

                dbSeek(xFilial("SEK") + cOrden+'CP')     // Busca exacta
                IF FOUND()    // Evalúa la devolución de la búsqueda realizada.
                    RecLock("SEK", .F.)
                    SEK->EK_XCARFEC :=  dFechCart
                    SEK->EK_XCARSTS := 'P'
                    SEK->EK_XCARUSR := FwGetUserName(RetCodUsr())
                     SEK->EK_OBSBCO := cFech + cValor //SEK->EK_XNUMCAR := cSecTran
                    SEK->(MsUnlock()) //Destraba el registro
                ENDIF
                IF  nContador == 1
                    cResul := Consecu(cCodBanco,2,cSecTran)
                    nContador := 2
                EndIf
            ENDIF

        EndIf
    Next
    /*Opcion 2 genera el archivo*/
    BuscBanco(2, "","","","","","","","","","","","",cCodBanco)
    //UFSEKCAB(cOrden,dFechCart)
    MsgInfo("Proceso Exitoso...!", "Atencion")
    oDlgPvt:End() //Cierra la Venta de Dialogo
Return

Static Function Consecu(cCodBanco,nOpcion,nSecTran)
    Local cQuery
    Local nSecu := 0
    Local aArea  := GetArea()
    cQuery := "SELECT A6_COD, A6_BAIRRO, A6_AGENCIA, A6_NUMCON " + CRLF
    cQuery += "FROM " + RetSQLName('SA6') + " SA6"        + CRLF
    cQuery += "WHERE SA6.A6_FILIAL = '" + FwxFilial('SA6') + "' AND SA6.A6_COD = '"+ cCodBanco +"' "   + CRLF
    cQuery += "AND SA6.D_E_L_E_T_ <> '*'"
    TCQuery cQuery new Alias 'TMP_SA6'
    IF nOpcion == 1 //Si es 1 Obtiene el consecutivo
        TMP_SA6->(DbGoTop())
        While ('TMP_SA6')->(!Eof())
            nSecu := TMP_SA6->A6_BAIRRO
            cAgencia :=  TMP_SA6->A6_AGENCIA
            cNumCon :=  TMP_SA6->A6_NUMCON
            cCod := TMP_SA6->A6_COD
            TMP_SA6->(DbSkip())
        EndDo
        TMP_SA6->(DbCloseArea())
        RestArea(aArea)
    Else //Falso, va actualizar el consecutivo mas 1
        /**/     DbSelectArea('SA6')
        dbSetOrder(1)
        // cCod := ALLTRIM(CodBanco)
        dbSeek(xFilial("SA6") + cCod + cAgencia + cNumCon/*+ "BCO" + "0005119480"*/) //A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON
        If FOUND()
            nSecTran := Val(nSecTran) + 1
            RecLock("SA6",.F.)
            A6_BAIRRO := STR(nSecTran) //GUARDA EL CONSECUTIVO EN LA TABLA
            SA6->(MsUnlock())
        EndIf
        TMP_SA6->(DbCloseArea())
        RestArea(aArea)
    EndIf
Return nSecu




/*
Static Function UFSEKCAB(cOrdenP,dFechCart)
    Local cQuery
    Local cFech := DTOS(dFechCart)
    Local aArea  := GetArea()
	cQuery := "SELECT EK_FILIAL, EK_ORDPAGO ,EK_TIPODOC, EK_TIPO, EK_XCARFEC, EK_XCARSTS, EK_XCARUSR" + CRLF
	cQuery += "FROM " + RetSQLName('SEK') + " SEK"        + CRLF
	cQuery += "WHERE SEK.EK_FILIAL = '" + FwxFilial('SEK') + "' AND SEK.EK_ORDPAGO = '"+ cOrdenP +"' "           + CRLF
	cQuery += "AND SEK.EK_TIPODOC = 'CP' AND SEK.EK_TIPO = 'TF' AND SEK.D_E_L_E_T_ <> '*'"
	TCQuery cQuery new Alias 'SEK_CAB'
	SEK_CAB->(DbGoTop())
	While ('SEK_CAB')->(!Eof())
		RecLock("SEK_CAB",.F.)
		SEK_CAB->EK_XCARFEC := cFech
		SEK_CAB->EK_XCARSTS := 'P'
		SEK_CAB->EK_XCARUSR := FwGetUserName(RetCodUsr())
		SEK_CAB->(MsUnlock())

		SEK_CAB->(DbSkip())
	EndDo
	SEK_CAB->(DbCloseArea())
    RestArea(aArea)
Return
/*

STATIC FUNCTION AjustaSX1(cPerg)
	Local aArea := GetArea()
	Local aRegs := {}, i, j

	cPerg := Padr(cPerg,Len(SX1->X1_GRUPO))

	DbSelectArea("SX1")
	DbSetOrder(1)

	aAdd(aRegs,{cPerg,"01","Banco ?"         ,"Banco ?"          ,"Banco ?"        ,"mv_ch1","C",06,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SA6","",""})
	aAdd(aRegs,{cPerg,"02","Orde de Pago # ?","Orde de Pago # ? ","Order de Pago ?","mv_ch2","C",06,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","" } )
	aAdd(aRegs,{cPerg,"06","Fecha de Carta  ","Fecha de Carta"   ,"Fecha Carta"    ,"mv_ch3","D",08,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","" } )
	aAdd(aRegs,{cPerg,"04","Dirigido A "     ,"Dirigido A"       ,"Dirigido A"     ,"mv_ch4","C",30,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","","" } )
	aAdd(aRegs,{cPerg,"05","Nombre"          ,"Nombre"           ,"Nombre"         ,"mv_ch5","C",30,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","" } )
	aAdd(aRegs,{cPerg,"06","Atención"        ,"Atención"         ,"Atención"       ,"mv_ch6","C",30,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","","","" } )
	//DIRECTOR DE SERVICIOS BANCIARIOS
	//	aAdd(aRegs,{cPerg,"07","Descrip Propósito Trans","Descrip Propósito Trans","Descrip Propósito Trans","mv_chB","C",10,0,0,"G","","MV_PAR11","","","","PAGO PROV ","","","","","","","","","","","","","","","","","","","","","","","" } )


	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next

	RestArea(aArea)
Return


ULTIMO
