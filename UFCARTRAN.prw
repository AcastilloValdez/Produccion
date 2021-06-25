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
!Fecha creacion    ! Junio/2021    22:33pm                                   !
+------------------+---------------------------------------------------------+
!   ATUALIZACIONES                                                           !
+-------------------------------------------+-----------+-----------+--------+
!Descripcion detallada de la actualizacion  !Nombre del ! Analista  !FEcha de!
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
! Mostrar Retenciones                       ! RFlores/MBalseca!     !24/06/2021 !
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
Static cDatos   := ""                         //Variable que tendra los datos para el rchivo .TXT
Static cEmpCod  := ""                         //Codigo de la empresa
Static oBmpOK := LoadBitmap(GetResource(),"LBOK") //Objeto tipo check OK
Static oBmpNo := LoadBitmap(GetResource(),"LBNO") //Objeto tipo check NO
Static nSecuCity := "00000000"
Static nSecuInter := "00"
Static nSecuBoli := "000000"
Static nSecuProdu :="0000000"
Static nSecuPichi := "0000000"
Static nTotalValor := 0
Static cSecmens := ""
User Function UFCARTRAN
    //Local lSigue 		:= .T.
    Local lSigue 		:= .F.
    Local lActive := .T.
    STATIC cPerg    := "UBANC01"
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
            MsgAlert("Campo requerido Fecha Inicial","A V I S O")
            lSigue := .T.
        End if
        If EMPTY(MV_PAR04)
            MsgAlert("Campo requerido Fecha Final", "A V I S O")
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
    UCABGRID()
Return
Static Function BuscBanco(nOp, cOrden, cTipoDoc, cTipo,cCuentaE,nValor,cTipoCu, cCuentaP,cRuc,cNombreP,dFechCart, Banco,cidBanco,cSecuAuxi,cCodAlt)
    Local cDirectorio
    StaTic cDir     := "\\vm02milfss04\Bancos\"  // Ruta donde debera quedar guardado el documento para procesamiento por SIPECOM        \\02milsas01\Documentos\T0201\Facturas
    cDir     += "T02"+cEmpCod +"\"
    cSecmens := cSecuAuxi
    cFileTxt := "T02"+cEmpCod+DTOS(MV_PAR05)+cSecuAuxi
    DO CASE
        CASE ALLTRIM(cidBanco) = "BOLIVARIANO" //BOLIVARIANO
            cDir     += "Bolivariano\"
            cDirectorio := "\\vm02milfss04\Bancos\" + "T02"+cEmpCod +"\" + "Bolivariano\"
            UBANKBOLIV(nOp, cOrden, cTipoDoc, cTipo,cCuentaE,nValor,cTipoCu, cCuentaP,cRuc,cNombreP,dFechCart, Banco,cDirectorio)
        CASE ALLTRIM(cidBanco) = "CITYBANK" //Citybank
            cDir     += "Citybank\"
            cDirectorio := "\\vm02milfss04\Bancos\" + "T02"+cEmpCod +"\" + "Citybank\"
            UPCITYBANK(nOp, cOrden, cTipoDoc, cTipo,cCuentaE,nValor,cTipoCu, cCuentaP,cRuc,cNombreP,dFechCart, Banco,cDirectorio,cCodAlt)
        CASE ALLTRIM(cidBanco) = "GUAYAQUIL" //Guayaquil
            cDir     += "Guayaqui\" 
            ALERT("NO SE HA DEFINIDO ESTRUCTURA DE ARCHIVO PARA ESTE BANCO...!!!")
        CASE ALLTRIM(cidBanco) = "INTERNACIONAL" //Internacional
            cDir     += "Internacional\"
            cDirectorio := "\\vm02milfss04\Bancos\" + "T02"+cEmpCod +"\" + "Internacional\"
            UBANKINTER(nOp, cOrden, cTipoDoc, cTipo,cCuentaE,nValor,cTipoCu, cCuentaP,cRuc,cNombreP,dFechCart,Banco,cDirectorio)
        CASE ALLTRIM(cidBanco) = "PACIFICO" //Pacifico
            cDir     += "Pacifico\"
            ALERT("NO SE HA DEFINIDO ESTRUCTURA DE ARCHIVO PARA ESTE BANCO...!!!")
        CASE ALLTRIM(cidBanco) = "PICHINCHA" //"PICHINCHA"
            cDir     += "Pichinch\"
            cDirectorio := "\\vm02milfss04\Bancos\" + "T02"+cEmpCod +"\" + "Pichinch\"
            UBANKPCHA(nOp, cOrden, cTipoDoc, cTipo,cCuentaE,nValor,cTipoCu, cCuentaP,cRuc,cNombreP,dFechCart,Banco,cDirectorio)
        CASE ALLTRIM(cidBanco) = "PRODUBANCO" //"PRODUBANCO"
            cDir     += "Produbanco\"
            cDirectorio := "\\vm02milfss04\Bancos\" + "T02"+cEmpCod +"\" + "Produbanco\"
            UPRODUBANK(nOp, cOrden, cTipoDoc, cTipo,cCuentaE,nValor,cTipoCu, cCuentaP,cRuc,cNombreP,dFechCart,Banco,cDirectorio)
    ENDCASE
    //Opcion = 1 El dato seleccionado del Grid obtenemos los campo y enviamos los datos para el proceso de concatenar el txt
    //Opcion = 2 Genera el archivo                                                                                       //Banco traer del Z41_CODBAN
Return
//Genera archivo plano del banco BOLIVARIANO
Static Function UBANKBOLIV(Opcion, cOrden, cTipoDoc, cTipo,cCuentaE,nValor,cTipoCu, cCuentaP,cRuc,cNombreP,cFech,Banco, cDirectorio)

    If Opcion == 1
        cA01  := "BZDET"
        nSecuBoli := soma1(nSecuBoli)
        cA02  := nSecuBoli
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
        IF ALLTRIM(cTipo) != "NCP" //SI NC
            cA09 := ALLTRIM(Banco)
            cA10 := IIf(RTRIM(cTipoCu) == "1","03","04")
            cA11 := PadR(RTRIM(cCuentaP),20," ")
        ENDIF
        cA12  := "1"
        formato := TRANSFORM(nValor, "@E 999999.99")
        unirValor := Val(StrTran(formato,".",""))
        cA13  := StrZero(unirValor,15,0)
        cOpago := RTRIM("OPAGO") + RTRIM(cOrden)
        cA14  := PadR(cOpago,60," ")
        cA15  := PadL(RTRIM(cOrden),15," ") //reemplazo de cnum CMTRXNUM de numero transaccion a cruc
        cA16  := Replicate("0",15)
        cA17  := Replicate("0",15)
        cA18  := Replicate("0",20)
        cA19  := Replicate(" ",10)
        cA20  := Replicate(" ",50)
        cA21  := Replicate(" ",50)
        cA22  := Replicate(" ",20)
        cA23  := "PRO"
        cA24  := Replicate(" ",10)
        cA25  := Replicate(" ",10)
        cA26  := Replicate(" ",10)
        cA27  := " "
        cA28  := IIf(cEmpCod == "01", "00484", "     ")
        cA29  := Replicate(" ",6)
        cA30  := "RPA"
        cDatos += cA01+cA02+cA03+cA04+cA05+cA06+cA07+cA08+cA09+cA10+cA11+cA12+cA13+cA14+cA15+cA16+cA17+cA18+cA19+cA20+cA21+cA22+cA23+cA24+cA25+cA26+cA27+cA28+cA29+cA30 +STR_PULA
    Else //End
        UGENFILE(cDirectorio, cFileTxt, ".BIZ", cDatos)
    EndIf
Return

//Genera archivo plano del banco Produbanco
Static Function UPRODUBANK(Opcion, cOrden, cTipoDoc, cTipo,cCuentaE,nValor,cTipoCu, cCuentaP,cRuc,cNombreP,cFech,Banco,cDirectorio)

    If Opcion == 1
        nSecuProdu := soma1(nSecuProdu)
        cA01 := "PA"
        cA02 := PADL(RTRIM(cCuentaE),11,"0") //Cta empresa
        cA03 := nSecuProdu
        cA04 := ""
        cA05 := ALLTRIM(cRuc) //ruc
        cA06 := "USD"
        formato := TRANSFORM(nValor, "@E 999999.99")
        unirValor := Val(StrTran(formato,".",""))
        cA07  := StrZero(unirValor,13,0)
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
        cA14 := SUBSTR(RTRIM(cNombreP),0,60) + Replicate(" ", 60-Len(RTRIM(cNombreP)))  //NOMBRE,PadR(RTRIM(PAGOS->A2_NOME), 40," ")
        cA15 := ""
        cA16 := ""
        cA160 := ""
        cA17 := "GUAYAQUIL"
        cA18 := RTRIM(cOrden) //CMTrxNum
        cA19 := "OPAGO" + RTRIM(cOrden)
        cDatos += cA01 +STR_TAB+ cA02 +STR_TAB+ cA03 +STR_TAB+ cA04 +STR_TAB+ cA05 +STR_TAB+;
            cA06 +STR_TAB+ cA07 +STR_TAB+ cA08 +STR_TAB+ cA09 +STR_TAB+ cA10 +STR_TAB+;
            cA11 +STR_TAB+ cA12 +STR_TAB+ cA13 +STR_TAB+ cA14 +STR_TAB+ cA15 +STR_TAB+;
            cA16 +STR_TAB+ cA160 +STR_TAB+ cA17 +STR_TAB+ cA18 +STR_TAB+ cA19 +STR_PULA
    Else// End
        UGENFILE(cDirectorio, cFileTxt, cFileExt, cDatos)
    EndIf
Return

//Genera archivo plano del banco del pichincha
Static Function UBANKPCHA(Opcion, cOrden, cTipoDoc, cTipo,cCuentaE,nValor,cTipoCu, cCuentaP,cRuc,cNombreP,cFech,Banco,cDirectorio)

    If Opcion == 1
        nSecuPichi := soma1(nSecuPichi)
        cA01 := "PA"
        cA02 := PADL(RTRIM(cCuentaE),11,"0") //Cta empresa
        cA03 := nSecuPichi
        cA04 := ""
        cA05 := ALLTRIM(cRuc) //ruc
        cA06 := "USD"
        formato := TRANSFORM(nValor, "@E 999999.99")
        unirValor := Val(StrTran(formato,".",""))
        cA07  := StrZero(unirValor,13,0)
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
        cA14 := SUBSTR(RTRIM(cNombreP),0,40) + Replicate(" ", 40-Len(RTRIM(cNombreP)))//NOMBRE de proveedor,PadR(RTRIM(PAGOS->A2_NOME), 40," ")
        cA15 := ""
        cA16 := ""
        cA17 := ""
        cA18 := "GUAYAQUIL"
        cA19 := "OP" + RTRIM(cOrden) // CMTrxNum numero de transaccion cNum CAMBIA A LA ORDEN DE PAGO cOrden
        cA20 := "REF-" + RTRIM(cOrden) //orden de pago
        cDatos += cA01 +STR_TAB+ cA02 +STR_TAB+ cA03 +STR_TAB+ cA04 +STR_TAB+ cA05 +STR_TAB+;
            cA06 +STR_TAB+ cA07 +STR_TAB+ cA08 +STR_TAB+ cA09 +STR_TAB+ cA10 +STR_TAB+;
            cA11 +STR_TAB+ cA12 +STR_TAB+ cA13 +STR_TAB+ cA14 +STR_TAB+ cA15 +STR_TAB+;
            cA16 +STR_TAB+ cA17 +STR_TAB+ cA18 +STR_TAB+ cA19 +STR_TAB+ cA20 +STR_PULA
    Else //  End
        UGENFILE(cDirectorio, cFileTxt, cFileExt, cDatos)
    EndIf
Return


Static Function UPCITYBANK(Opcion, cOrden, cTipoDoc, cTipo,cCuentaE,nValor,cTipoCu, cCuentaP,cRuc,cNombreP,cFech,Banco,cDirectorio,cCodAlt)

    IF Opcion == 1
        nSecuCity := soma1(nSecuCity)
        cA01 := "PAY"
        cA02 := "218"
        cA03 := PadL(cCuentaE,10,"0")            //Trim(RsPagos!Bnkactnm) //Cta empresa
        cFecha := cFech
        cA04 := SUBSTR(cFecha,3,6)    //Format(RsPagos!Feccarta, "yymmdd")
        If  ALLTRIM(cTipo) == "CH"            // RsPagos!Formapago = "CH"
            cA05 := "077"
            cA17 := "02"
            cA26 := ""
            cA28 := ""
            cA29 := ""
            cA39 := ""
            cA40 := ""
        Else
            If  RTRIM(Banco) <> "24"       //Trim(RsPagos!Codbanco) <> "24"
                cA05 := "071"
                cA17 := "21"
                cA26 := cCodAlt      //Cod_Alterno(Trim(RsPagos!Codbanco))
                cA28 := PadL(RTRIM(cCuentaP),11,"0")                //RsPagos!Numcta
                cA29 := IIF(RTRIM(cTipoCu) == "1","01","02") //1:corriente, 2:ahorro
                cA39 := ""
                cA40 := ""
            EndIf
            If  RTRIM(Banco) == "24"                 //Trim(RsPagos!Codbanco) = "24"
                cA05 := "072"
                cA17 := "01"
                cA26 := ""
                cA28 := ""
                cA29 := ""
                cA39 := PadL(RTRIM(cCuentaP),11,"0")               //Trim(RsPagos!Numcta)
                cA40 := IIF(RTRIM(cTipoCu) == "1","01","02")
            EndIf
        EndIf
        cA06 := "PMPAY" + RTRIM(cOrden) + Replicate(" ", 16-Len(RTRIM(cOrden)))        //Trim(RsPagos!Audittrail)
        formato := TRANSFORM(nValor, "@E 999999.99")
        unirValor := Val(StrTran(formato,".",""))
        cA07 :=  nSecuCity //Format(WNumRec, "####0")
        cA08 :=  ALLTRIM(cRuc) + Replicate(" ", 21-Len(RTRIM(cRuc)))  //Trim(WsRucpro)
        cA09 := "USD"
        cA10 :=  RTRIM(cRuc)  + Replicate(" ", 21-Len(RTRIM(cRuc))) //Trim(WsRucpro)
        cA11 :=  StrZero(unirValor,15,0)  //Round(RsPagos!Trxamnt, 2)  //valor del orden de pago
        cA12 := "000000"
        cRucP := RTRIM(cRuc)
        cOrdenPago := RTRIM(cOrden)
        cUnion := "OPAGO" + cRucP + cOrdenPago
        cA13 :=  PadR(RTRIM(cUnion),30," ")       //Trim(RsPagos!DSCRIPTN)
        cA14 := ""
        cA15 := ""
        cA16 := ""
        cA18 := "01"
        cA19 := PadR(SUBSTR(RTRIM(cNombreP),0,80),80," ")       //Left(Trim(WsNompro), 80)
        cA20 := "GUAYAQUIL"
        cA21 := Replicate(" ",51)
        cA22 := ""
        cA22 := "PLAZA DEL SOL"
        cA23 := Replicate(" ",4)
        cA24 := "000000000000"
        cA25 :=  Replicate(" ",19)//d
        cA27 := "00000000"
        cA30 :=  Replicate(" ",20)
        cA31 :=  Replicate(" ",20)
        cA32 :=  Replicate(" ",30)
        cA33 :=  Replicate(" ",30)
        cA34 :=  Replicate(" ",20)
        cA35 :=  Replicate(" ",20)
        cA36 := ""
        cA37 := ""
        cA38 := ""
        cA41 := "001"
        cA42 :=  Replicate(" ",40)
        cA43 :=  Replicate(" ",30)
        cA44 :=  Replicate(" ",10)
        cA45 := "999999999999999"
        cA46 := "2"
        cA47 :=  Replicate(" ",30)
        cA48 :=  Replicate(" ",30)
        cA49 :=  Replicate(" ",30)
        cDatos += cA01 + cA02 + cA03 + cA04 + cA05 + cA06 + cA07 + cA08 + cA09 + cA10+;
            cA11 + cA12 + cA13 + cA14 + cA15 + cA16 + cA17 + cA18 + cA19 + cA20+;
            cA21 + cA22 + cA23 + cA24 + cA25 + cA26 + cA27 + cA28 + cA29 + cA30+;
            cA31 + cA32 + cA33 + cA34 + cA35 + cA36 + cA37 + cA38 + cA39 + cA40+;
            cA41 + cA42 + cA43 + cA44 + cA45 + cA46 + cA47 + cA48 + cA49 +STR_PULA
        nTotalValor += unirValor
    Else
        cDatos += "TRL" + StrZero(Val(nSecuCity),15)  +StrZero(nTotalValor,15,0) + "000000000000000" + StrZero(Val(nSecuCity),15)
        UGENFILE(cDirectorio, cFileTxt, cFileExt, cDatos) //Llama la funcion para crear el archivo
    EndIf

Return

Static Function UBANKINTER(Opcion, cOrden, cTipoDoc, cTipo,cCuentaE,nValor,cTipoCu, cCuentaP,cRuc,cNombreP,cFech,Banco,cDirectorio)
    If Opcion == 1
        nSecuInter := soma1(nSecuInter)
        cA01  := "PA" //CODIGO FIJO
        cA02 := Replicate(" ",10)
        cA03  := PadL(RTRIM(cCuentaE),10,"0")//cuenta de la empresa
        cA04 := Replicate(" ",3)
        cA05  := ALLTRIM(Str(Val(nSecuInter))) //SECUENCIA 1,2,3....
        cA06 := Replicate(" ",10)
        cA07 :=  RTRIM(cOrden) //NUMERO DE TRASACCION cNum CMTRXNUM de la orden se reemplaza por orden de pago cOrden
        cA08 := Replicate(" ",2)
        cA09  := RTRIM(cRuc) + Replicate(" ", 16-Len(RTRIM(cRuc)))//ruc de proveedor
        cA10 := Replicate(" ",10)
        cA11 := "USD" //MONEDA
        cA12 := Replicate(" ",4)
        cA13 := Replicate(" ",2)
        formato := TRANSFORM(nValor, "@E 999999.99")
        unirValor := StrTran(formato,".","")
        cA14 := PadR(unirValor,8," ") //valor de la orden de pago TRXAMNT
        cA15 := Replicate(" ",4)
        cA16 := "CTA" //FIJO
        cA17 := Replicate(" ",4)
        cA18 := Replicate(" ",2)
        cA19 := IIF(RTRIM(Banco)=="34","37",Banco) //asignacion codigo de banco RTRIM(PAGOS->CODBANCO)
        cA20 := Replicate(" ",10)
        cA21 := IIF(RTRIM(cTipoCu)=="1","CTE","AHO") //asignacion de cuenta //FIL_TIPCTA:= [1:Corriente];[2:Ahorro]
        cA22 := Replicate(" ",10)
        cA23 := Replicate(" ",10)
        cA24 := PadL(RTRIM(cCuentaP),11," ") //numero de cuenta del proveedor
        cA25 := Replicate(" ",10)
        cA26 := Replicate(" ",4)
        cA27 := IIF(Len(RTRIM(cRuc))==10,"C","R") //ruc del proveedor
        cA28 := Replicate(" ",10)
        cA29 := Replicate(" ",10)
        cA30 := RTRIM(cRuc) + Replicate(" ", 16-Len(RTRIM(cRuc))) //ruc del proveedor
        cA31 := Replicate(" ",10)
        cA32 := Replicate(" ",10)
        cA33 := PadR(SUBSTR(RTRIM(cNombreP),0,40),40," ") //nombre del proveedor
        cA34 := Replicate(" ",10)
        cA35 := "OPAGO" + PadR(RTRIM(cOrden),30," ") //orden de pago
        cA36 :=  "REF" + RTRIM(cRuc) + "-" + RTRIM(cOrden) //+  RTRIM(cNum) //remplaza por el nombre de la actividad
        cDatos += cA01 +STR_TAB+ cA03 +STR_TAB+ cA05 +STR_TAB+ cA07 +STR_TAB+ cA09 +STR_TAB+;
            cA11 +STR_TAB+ cA14 +STR_TAB+ cA16 +STR_TAB+ cA19 +STR_TAB+ cA21 +STR_TAB+;
            cA24 +STR_TAB+ cA27 +STR_TAB+ cA30 +STR_TAB+ cA33 +STR_TAB+ cA29 +STR_TAB+;
            cA31 +STR_TAB+ cA32 +STR_TAB+ cA34 +STR_TAB+ cA35 +STR_TAB+ cA36 +STR_PULA
    Else
        UGENFILE(cDirectorio, cFileTxt, cFileExt, cDatos)
    EndIf
Return

Static Function UGENFILE(cDirec, cFileTxt, cFileExt, cDatos)
    Local nHandle := 0
    //Local cRoute  := "c:\temp\"+cFileTxt+cFileExt
    Local cRoute  := cDirec+cFileTxt+cFileExt
    nHandle       := FCreate(cRoute,FC_NORMAL,0,.F.)

    If nHandle < 0
        MsgAlert("El archivo no se creó:" + STR(FERROR()))
    Else
        FWrite(nHandle,cDatos)
        FClose(nHandle)
        MsgInfo("Archivo Generado correctamente...  Su numero de Carta: " + cSecmens,"Carta de Transferencia")
    EndIf
Return


Static Function UCABGRID()
    Local aArea := GetArea()
    Local oPedido
    Local cCodBanco := MV_PAR01
    Local cDescripcion := MV_PAR02
    Local cFechIni := MV_PAR03 
    Local cFechFin := MV_PAR04
    Local cFechCar := MV_PAR05
    Local cDiri := MV_PAR06
    Local cNombre := MV_PAR07

    //cVar1 := DTOS(MV_PAR02) //Convierte fecha a caracter con un formato ejemplo 23/04/2021 a 20210423 tipo caracter
    // M + posicion 7 hasta 2 caracter al extraer el |03| dia 202104|03-> dia
    //cFech := "M" + SUBSTR(cVar1,7,2) + SUBSTR(cVar1,5,2) +  SUBSTR(cVar1,3,2)
    // cAno := SUBSTR(cVar1,3,2)
    //cMes := SUBSTR(cVar1,5,2)
    //  cdia := SUBSTR(cVar1,7,2)
    // cUnion := "M" + cdia + cMes + cAno
    //Objetos de la ventana
    Private oDlgPvt
    Private oMsGetPAG
    Private aHead := {}
    Private aCols := {}
    Private oBtnProc
    Private oBtnCerrar
    Private oBtnCalcular
    //Tamaño de la ventana
    Private    nJanLarg    := 700
    Private    nJanAltu    := 500
    //Fuentes
    Private    cFontUti   := "Tahoma"
    Private    oFontAno   := TFont():New(cFontUti,,-38)
    Private    oFontSub   := TFont():New(cFontUti,,-20)
    Private    oFontSubN  := TFont():New(cFontUti,,-20,,.T.)
    Private    oFontAviso  := TFont():New(cFontUti,,-24)
    Private    oFontBtn   := TFont():New(cFontUti,,-14)


    Static bVerificar := .F.
    //              Título               Campo                    Máscara                        Tamaño                   Decimal                   Valid               Usado  Tipo F3     Combo

    aAdd(aHead, {"",                 "CHECK",                      "@BMP",                           2,                      0,                        ".F.",              "   ", "C", "",    "V",     "",      "",        "", "V"})
    aAdd(aHead, {"Ruc",              "EK_FORNECE",                   "",                            15,  				     0,                        ".T.",              ".T.", "C", "",    "" } )
    aAdd(aHead, {"Proveedor",        "A2_NOME",                      "",                            35,  				     0,                        ".T.",              ".T.", "C", "",    "" } )
    aAdd(aHead, {"Valor Creditar",   "EK_VALOR",           "@E 999,999,999,999,999.99",             10, 		    	     0,                        ".T.",              ".T.", "N", "",    ""} )
    aAdd(aHead, {"Retencion",        "E2_RETENCION",       "@E 999,999,999,999,999.99",             10, 		    	     0,                        ".T.",              ".T.", "N", "",    ""} )
    aAdd(aHead, {"Cuenta Proveedor", "FIL_CONTA",                    "",                            11, 				     0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHead, {"Banco Proveedor",  "Z41_DESCRI",                   "",                            24, 				     0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHead, {"Tipo Cuenta",      "FIL_TIPCTA",                   "",                            20, 				     0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHead, {"Cuenta Empresa",   "A6_NUMCON",                    "",                            20, 				     0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHead, {"#Transaccion",     "EK_NUM",                       "",                            13,  				     0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHead, {"Orden",            "EK_ORDPAGO",                   "",                            15, 					 0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHead, {"Tipo",             "EK_TIPO",                      "",                            10,  				     0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHead, {"Tipo Dcto",        "TDOC",                         "",                             2, 				     0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHead, {"Prefijo Titulo",   "EK_PREFIXO",                   "",                             3, 				     0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHead, {"Cuota",            "EK_PARCELA",                   "",                             3, 				     0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHead, {"Sec.Registro",     "EK_SEQ",                       "",                             3, 			         0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHead, {"Banco",            "BANCO",                        "",                             3,  		     	     0,                        ".T.",              ".T.", "C", "",    "" } )
    Processa({|| UDETGRID() }, "Cargando ... Espere ....")
    //Creación de la pantalla con los datos a informar
    DEFINE MSDIALOG oDlgPvt TITLE "CARTA TRANSFERENCIA" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
    //Labels gerais
    @ 004, 005 SAY oSay1 PROMPT  "Codigo:" SIZE 040, 007 OF oDlgPvt PIXEL
    @ 011, 005 MSGET oPedido VAR cCodBanco SIZE 045, 010 OF oDlgPvt   READONLY PIXEL
    @ 004, 070 SAY oSay2 PROMPT  "Fecha Carta:" SIZE 040, 007 OF oDlgPvt PIXEL
    @ 011, 070 MSGET oPedido VAR  cFechCar SIZE 040, 010 OF oDlgPvt  READONLY PIXEL
    @ 004, 132 SAY oSay3 PROMPT  "Banco:" SIZE 025, 007 OF oDlgPvt PIXEL
    @ 011, 132 MSGET oPedido VAR cDescripcion SIZE 131, 010 OF oDlgPvt READONLY PIXEL
    @ 024, 005 SAY oSay4 PROMPT "Fecha Inicial:" SIZE 040, 007 OF oDlgPvt PIXEL
    @ 031, 005 MSGET oPedido VAR cFechIni SIZE 060, 010 OF oDlgPvt READONLY  PIXEL
    @ 024, 070 SAY oSay5 PROMPT "Fecha Final:" SIZE 040, 007 OF oDlgPvt PIXEL
    @ 031, 070 MSGET oPedido VAR cFechFin SIZE 070, 010 OF oDlgPvt READONLY PIXEL
    @ 024, 150 SAY oSay4 PROMPT "Dirigido:" SIZE 037, 007 OF oDlgPvt PIXEL
    @ 031, 150 MSGET oPedido VAR cDiri SIZE 070, 010 OF oDlgPvt  READONLY PIXEL
    @ 024, 220 SAY oSay5 PROMPT "Nombre:" SIZE 035, 007 OF oDlgPvt PIXEL
    @ 031, 220 MSGET oPedido VAR cNombre SIZE 115, 010 OF oDlgPvt  READONLY PIXEL
    //Botones
    @ 008, (nJanLarg/2-001)-(0080*01) BUTTON oBtnCerrar  PROMPT "Cerrar"   SIZE 040, 015 OF oDlgPvt ACTION (oDlgPvt:End()) FONT oFontBtn PIXEL
    If bVerificar
        @ 008, (nJanLarg/2-001)-(0037*01) BUTTON oBtnProc  PROMPT "Procesar"   SIZE 040, 015 OF oDlgPvt ACTION (Processa({|| Proccess() },"Espere..."))  FONT oFontBtn PIXEL
    endIf
    If bVerificar
     @ 044, (nJanLarg/2-001)-(0080*01) BUTTON oBtnCalcular  PROMPT "Calcular"   SIZE 040, 015 OF oDlgPvt ACTION (Processa({|| _calcular(@oDlgPvt), oDlgPvt:Refresh() },"Espere...")) FONT oFontBtn PIXEL
    endIf
    //Grid dos grupos
    oMsGetPAG := MsNewGetDados():New(    060,;                //nTop      - Linea Inicial
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
    If bVerificar
        oMsGetPAG:oBrowse:bLDblClick := {|| oMsGetPAG:EditCell(), oMsGetPAG:aCols[oMsGetPAG:nAt,1] := iif(oMsGetPAG:aCols[oMsGetPAG:nAt,1] == oBmpNo,oBmpOK,oBmpNo)}
    endIf
    //aCols     - Datos del Grid
    //Desativa las manipulaciones
    oMsGetPAG:lActive := .F.

    ACTIVATE MSDIALOG oDlgPvt CENTERED
    RestArea(aArea)
Return

Static Function UDETGRID()
    Local aArea  := GetArea()
    Local cQuery   := ""
    Local nTotal := 0
    cQuery := "SELECT SEK.EK_ORDPAGO, SEK.EK_NUM,  SEK.EK_TIPO, SEK.EK_TIPODOC AS TDOC, SEK.EK_PREFIXO, SEK.EK_PARCELA, SEK.EK_SEQ,"      + CRLF
    cQuery += "       SEK.EK_VALOR, (SE2.E2_VALIMP2+SE2.E2_VALIMP6) AS E2_RETENCION,"                + CRLF
    cQuery += "       SEK.EK_FORNECE, SA2.A2_NOME,"                                                  + CRLF
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
    cQuery += "                       AND SA6.A6_AGENCIA = S.EK_AGENCIA"                             + CRLF
    cQuery += "     LEFT JOIN  "+RetSQLName('SE2')+ " SE2 " + " ON SE2.E2_FILIAL  = SEK.EK_FILIAL"   + CRLF
    cQuery += "                         AND SE2.E2_FORNECE = SEK.EK_FORNECE"                         + CRLF
    cQuery += "                         AND SE2.E2_LOJA    = SEK.EK_LOJA"                            + CRLF
    cQuery += "                         AND SE2.E2_PREFIXO = SEK.EK_PREFIXO"                         + CRLF
    cQuery += "                         AND SE2.E2_NUM     = SEK.EK_NUM"                             + CRLF
    cQuery += "                         AND SE2.E2_ORDPAGO = SEK.EK_ORDPAGO"                         + CRLF
    cQuery += "                         AND SE2.E2_TIPO   IN('NF','PA','NDP') "                      + CRLF
    cQuery += " WHERE SEK.EK_TIPODOC IN('PA','TB') "                                                 + CRLF
    cQuery += "  AND SEK.EK_TIPO IN('PA','NF','NDP') "                                               + CRLF
    cQuery += "  AND SEK.EK_FILIAL  = '01'"                                                          + CRLF
    cQuery += "  AND SA6.A6_COD = '" +MV_PAR01+ "' AND SA6.A6_NREDUZ = '" +ALLTRIM(MV_PAR02)+ "'"    + CRLF
    cQuery += "  AND SEK.EK_LA <> 'C'"                                                               + CRLF
    cQuery += "  AND SEK.EK_EMISSAO BETWEEN '" + DTOS(MV_PAR03) + "' AND '"+DTOS(MV_PAR04)+"'"       + CRLF
    cQuery += "  AND SEK.D_E_L_E_T_ <> '*' AND SA2.D_E_L_E_T_ <> '*' AND SA6.D_E_L_E_T_ <> '*'"      + CRLF
    cQuery += "  AND S.D_E_L_E_T_ <> '*'   AND FIL.D_E_L_E_T_ <> '*' AND SE2.D_E_L_E_T_ <> '*'"      + CRLF
    cQuery += "  AND SEK.EK_CANCEL = 'F' "                                                           + CRLF
    cQuery += "  AND SEK.EK_XCARSTS <> 'P' "                                                         + CRLF
    cQuery += "  AND SEK.EK_NATUREZ <> '201003' "                                                    + CRLF
    cQuery += "  ORDER BY SA2.A2_NOME ASC "

    TCQuery cQuery New Alias "QRY_SEK"

    Count To nTotal
    ProcRegua(nTotal) //Calcula cuantas informacion existe
    //Se posiciona en el primer registro
    QRY_SEK->(DbGoTop())

    If ! QRY_SEK->(EoF())
        bVerificar := .T.
    EndIf


    While ! QRY_SEK->(EoF())
        //Adiciona o item no aCols
        aAdd(aCols, { ;
            oBmpOK,;
            QRY_SEK->EK_FORNECE,;
            QRY_SEK->A2_NOME,;
            QRY_SEK->EK_VALOR,;
            QRY_SEK->E2_RETENCION,;
            QRY_SEK->FIL_CONTA,;
            QRY_SEK->Z41_DESCRI,;
            QRY_SEK->FIL_TIPCTA,;
            QRY_SEK->A6_NUMCON,;
            QRY_SEK->EK_NUM,;
            QRY_SEK->EK_ORDPAGO,;
            QRY_SEK->EK_TIPO,;
            QRY_SEK->TDOC,;
            QRY_SEK->EK_PREFIXO,;
            QRY_SEK->EK_PARCELA,;
            QRY_SEK->EK_SEQ,;
            QRY_SEK->CODBANCO,;
            .F. ;
            })

        QRY_SEK->(DbSkip())
    EndDo
    QRY_SEK->(DbCloseArea())

    RestArea(aArea) //Restaura un entorno grabado anteriormente por la función GETAREA()
Return

Static Function Proccess()
    Local aColsAux  := oMsGetPAG:aCols //Objeto de MsNewGetDatos del Grid para la carga de informacion detalle
    Local cCodBanco := MV_PAR01
    Local cNREDUZ   := MV_PAR02
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
    Local dFechCart := MV_PAR05
    Local cSecuAuxi := ""
    Static cAgencia := ""
    Static cNumCon := ""
    Static  cCod := ""
    Static cValor := ""
    Static nContador := 1
    If MsgYesNo("Confirmacion de Pago.. "+ "Desea Continuar?")
        DbSelectArea('SEK')
        cUser := FwGetUserName(RetCodUsr()) //Obtiene el usuario del programa
        //Convierte fecha a caracter con un formato ejemplo 23/04/2021 a 20210423 tipo caracter
        // M + posicion 7 hasta 2 caracter al extraer el |03| dia 202104|03-> dia
        cVar1 := DTOS(dFechCart)
        cFech := cCharBanco(MV_PAR02) + SUBSTR(cVar1,7,2) + SUBSTR(cVar1,5,2) +  SUBSTR(cVar1,3,2)
        //Recorriendo lineas del Grid
        // Begin Transaction
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
                //  BuscBanco(1, cOrden, cTipoDoc, cNum, cTipo,cCuentaE,nValor,cTipoCu, cCuentaP,cRuc,cNombreP,dFechCart, cBancoN,cCodBanco)
                If nContador == 1
                    cSecTran := Consecu(cCodBanco,cNREDUZ,1,0) //OBTIENE EL CONSECUTIVO DE LA SA6 POR BANCO
                    cValor := StrZero(cSecTran,5,0)
                EndIf
                dbSetOrder(1)      // EK_FILIAL+EK_ORDPAGO+EK_TIPODOC+EK_PRFIXO+EK_NUM+EK_PARCELA+EK_TIPO+EK_SEQ
                dbSeek(xFilial("SEK") + cOrden+cTipoDoc+cPref+cNum+cParcela+cTipo+cSeq)     // Busca exacta

                IF FOUND()    // Evalúa la devolución de la búsqueda realizada.
                    RecLock("SEK", .F.)
                    SEK->EK_XCARFEC :=  dFechCart
                    SEK->EK_XCARSTS := 'P'
                    SEK->EK_XCARUSR := FwGetUserName(RetCodUsr())
                    SEK->EK_XNUMCAR := cFech + cValor//SEK->EK_XNUMCAR := cSecTran
                    SEK->(MsUnlock())

                    dbSeek(xFilial("SEK") + cOrden+'CP')     // Busca exacta
                    IF FOUND()    // Evalúa la devolución de la búsqueda realizada.
                        RecLock("SEK", .F.)
                        SEK->EK_XCARFEC :=  dFechCart
                        SEK->EK_XCARSTS := 'P'
                        SEK->EK_XCARUSR := FwGetUserName(RetCodUsr())
                        SEK->EK_XNUMCAR := cFech + cValor //SEK->EK_XNUMCAR := cSecTran
                        SEK->(MsUnlock()) //Destraba el registro
                    ENDIF
                    IF  nContador == 1
                        cResul := Consecu(cCodBanco,cNREDUZ,2,cSecTran)
                        nContador := 2
                    EndIf
                ENDIF

            EndIf
        Next
        DBCloseArea()
        //End Transaction
        cSecuAuxi := cFech + cValor
        Agrupar(cSecuAuxi)
    EndIf
    oDlgPvt:End() //Cierra la Venta de Dialogo
Return

Static Function Consecu(cCodBanco,cNREDUZ,nOpcion,nSecTran)
    Local cQuery
    Local nSecu := 0
    Local aArea := GetArea()
    cQuery := "SELECT A6_COD, A6_XSEQTRA, A6_AGENCIA, A6_NUMCON " + CRLF
    cQuery += "FROM " + RetSQLName('SA6') + " SA6"                + CRLF
    cQuery += "WHERE SA6.A6_FILIAL = '" + FwxFilial('SA6') + "' AND SA6.A6_COD = '"+ cCodBanco +"' "   + CRLF
    cQuery += "  AND SA6.A6_NREDUZ  = '"+ ALLTRIM(cNREDUZ) +"' "   + CRLF
    cQuery += "  AND SA6.D_E_L_E_T_ <> '*'"
    TCQuery cQuery new Alias 'TMP_SA6'
    IF nOpcion == 1 //Si es 1 Obtiene el consecutivo
        TMP_SA6->(DbGoTop())
        While ('TMP_SA6')->(!Eof())
            nSecu := TMP_SA6->A6_XSEQTRA
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
            nSecTran := nSecTran + 1
            RecLock("SA6",.F.)
            A6_XSEQTRA := nSecTran //GUARDA EL CONSECUTIVO EN LA TABLA
            SA6->(MsUnlock())
        EndIf
        TMP_SA6->(DbCloseArea())
        RestArea(aArea)
    EndIf
Return nSecu

Static Function Agrupar(cSecuAuxi)
    Local aArea  := GetArea()
    Local cQuery   := ""
    //cCodBanco := MV_PAR01
    cCodBanco := MV_PAR02 //Nombre del Banco en el parametro 2 NEDRUZ
    cQuery := "SELECT SEK.EK_ORDPAGO, SEK.EK_TIPO, SEK.EK_TIPODOC, SEK.EK_XCARFEC, SEK.EK_SEQ, "     + CRLF
    cQuery += "       SUM(SEK.EK_VALOR) AS VALOR, SUM(SE2.E2_VALIMP2 + SE2.E2_VALIMP6) AS RETENCION,"                     + CRLF
    cQuery += "       SEK.EK_FORNECE, SA2.A2_NOME, "                     + CRLF
    cQuery += "       FIL.FIL_CONTA,  FIL.FIL_TIPCTA, FIL.FIL_TIPO, "                                + CRLF
    cQuery += "       SA6.A6_NUMCON, "                                                               + CRLF
    cQuery += "       Z41.Z41_CODBAN AS CODBANCO, Z41.Z41_CODALT"                                    + CRLF
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
    cQuery += "                       AND SA6.A6_AGENCIA = S.EK_AGENCIA"                             + CRLF
    cQuery += "     LEFT JOIN  "+RetSQLName('SE2')+ " SE2 " + " ON SE2.E2_FILIAL  = SEK.EK_FILIAL"   + CRLF
    cQuery += "                        AND SE2.E2_FORNECE = SEK.EK_FORNECE"                          + CRLF
    cQuery += "                        AND SE2.E2_LOJA    = SEK.EK_LOJA"                             + CRLF
    cQuery += "                        AND SE2.E2_PREFIXO = SEK.EK_PREFIXO"                          + CRLF
    cQuery += "                        AND SE2.E2_NUM     = SEK.EK_NUM"                              + CRLF
    cQuery += "                        AND SE2.E2_ORDPAGO = SEK.EK_ORDPAGO"                          + CRLF
    cQuery += "                        AND SE2.E2_TIPO   IN('NF','PA','NDP')"                        + CRLF    
    cQuery += " WHERE SEK.EK_TIPODOC IN('PA','TB') "                                                 + CRLF
    cQuery += "  AND SEK.EK_TIPO IN('PA','NF','NDP') "                                               + CRLF
    cQuery += "  AND SEK.EK_FILIAL  = '01'"                                                          + CRLF
    cQuery += "  AND SA6.A6_COD = '" +MV_PAR01+ "' AND SA6.A6_NREDUZ = '" +ALLTRIM(MV_PAR02)+ "'"    + CRLF
    cQuery += "  AND SEK.EK_LA <> 'C'"                                                               + CRLF
    cQuery += "  AND SEK.EK_EMISSAO BETWEEN '" + DTOS(MV_PAR03) + "' AND '"+DTOS(MV_PAR04)+"'"       + CRLF
    cQuery += "  AND SEK.D_E_L_E_T_ <> '*' AND SA2.D_E_L_E_T_ <> '*' AND SA6.D_E_L_E_T_ <> '*'"      + CRLF
    cQuery += "  AND S.D_E_L_E_T_ <> '*'   AND FIL.D_E_L_E_T_ <> '*' AND SE2.D_E_L_E_T_ <> '*'"                                + CRLF
    cQuery += "  AND SEK.EK_CANCEL = 'F' "                                                           + CRLF
    cQuery += "  AND SEK.EK_XCARSTS = 'P' "                                                          + CRLF
    cQuery += "  AND SEK.EK_XNUMCAR = '" +cSecuAuxi+ "'"                                             + CRLF
    cQuery += "  AND SEK.EK_NATUREZ <> '201003' "                                                    + CRLF
    cQuery += "  GROUP BY SEK.EK_ORDPAGO, SEK.EK_TIPO, SEK.EK_TIPODOC,  SEK.EK_XCARFEC,"             + CRLF
    cQuery += "  SEK.EK_SEQ, SEK.EK_FORNECE, SA2.A2_NOME, FIL.FIL_CONTA, FIL.FIL_TIPCTA, FIL.FIL_TIPO, " + CRLF
    cQuery += "  SA6.A6_NUMCON, Z41.Z41_CODBAN, Z41.Z41_CODALT"                                          + CRLF

    TCQuery cQuery New Alias "Q_SEK"
    Q_SEK->(DbGoTop())
    While ! Q_SEK->(EoF())

        cOrden :=    Q_SEK->EK_ORDPAGO
        cTipoDoc :=  Q_SEK->EK_TIPODOC
        cTipo :=     Q_SEK->EK_TIPO
        cCuentaE :=  Q_SEK->A6_NUMCON
        nValor :=    Q_SEK->VALOR
        nTipoCu :=   Q_SEK->FIL_TIPCTA
        cCuentaP :=  Q_SEK->FIL_CONTA
        cRuc :=      Q_SEK->EK_FORNECE
        cNombreP :=  Q_SEK->A2_NOME
        dFechCart := Q_SEK->EK_XCARFEC
        cBancoN :=   Q_SEK->CODBANCO
        cCodAlt :=   Q_SEK->Z41_CODALT
        BuscBanco(1, cOrden, cTipoDoc, cTipo,cCuentaE,nValor,nTipoCu, cCuentaP,cRuc,cNombreP,dFechCart, cBancoN,cCodBanco,"",cCodAlt)
        Q_SEK->(DbSkip())
    EndDo
    Q_SEK->(DbCloseArea())
    BuscBanco(2, "","","","","","","","","","","",cCodBanco,cSecuAuxi,"")
    RestArea(aArea)
Return

Static Function _calcular(oDlgPvt)
    Local aColsAux := oMsGetPAG:aCols //Objeto de MsNewGetDatos del Grid para la carga de informacion detalle
    Local bPosCheck  := aScan(aHead, {|x| Alltrim(x[2]) == "CHECK"})
    Local nPosEK_VALOR  := aScan(aHead, {|x| Alltrim(x[2]) == "EK_VALOR"})
    Local nLinea   := 0
    Local nValor :=0
    Local nValorTotal :=0
    
    For nLinea := 1 To Len(aColsAux)
        If  aColsAux[nLinea][bPosCheck] == oBmpOK
              nValor := aColsAux[nLinea][nPosEK_VALOR] 
              nValorTotal += nValor   
        EndIf
    Next
    /*
        @ 044, 90 SAY "Total: $"  SIZE 200, 030 FONT oFontAviso  OF oDlgPvt COLORS RGB(031,073,125) PIXEL
        @ 044, 140 SAY transform(nValorTotal,"@E 999,999,999,999.99")  SIZE 200, 030 FONT oFontAviso  OF oDlgPvt COLORS RGB(031,073,125) PIXEL
        oDlgPvt:Refresh()*/
    MsgInfo(Transform(nValorTotal,"@E 999,999,999,999.99"),"Total")
    //ALERT(Transform(nValorTotal,"@E 999,999,999,999.99"))
Return

Static Function cCharBanco(cBancoDescri)
  Local cCharBan := ""
   Do Case
        Case ALLTRIM(cBancoDescri) = "BOLIVARIANO" //BOLIVARIANO
             cCharBan := "B"
        Case ALLTRIM(cBancoDescri) = "CITYBANK" //Citybank
             cCharBan := "C"
        Case ALLTRIM(cBancoDescri) = "GUAYAQUIL" //Guayaquil
             cCharBan := "G"
        Case ALLTRIM(cBancoDescri) = "INTERNACIONAL" //Internacional
             cCharBan := "I"
        Case ALLTRIM(cBancoDescri) = "PACIFICO" //Pacifico
             cCharBan := "F"
        Case ALLTRIM(cBancoDescri) = "PICHINCHA" //"PICHINCHA"
             cCharBan := "P"
        Case ALLTRIM(cBancoDescri) = "PRODUBANCO" //"PRODUBANCO"
             cCharBan := "U"
    EndCase

Return (cCharBan)
