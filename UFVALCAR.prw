/*
+----------------------------------------------------------------------------+
!                       FICHA TECNICA DEL PROGRAMA                           !
+----------------------------------------------------------------------------+
!DATOS DEL PROGRAMA                                                          !
+------------------+---------------------------------------------------------+
!Tipo              ! Carta de transferencia Validacion de Campos             !
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
#Include "Topconn.ch"




User Function UFVALCAR()
 //MsgInfo("Codigo Banco no existe..!", "A V I S O")
    Local aArea  := GetArea()
  //  Local cQuery   := ""
//ExistChav("Z41",M->FIL_BANCO,1)                                                                                                 
     DbSelectArea('Z41')
     DbSetOrder(1)
     DbSeek(xFilial("Z41") + M->FIL_BANCO)
     If	!Found()
		  MsgAlert("Codigo Banco no existe..!", "A V I S O")
		Return .F.
	EndIf
	RestArea(aArea)
Return .T.






















    IF Opcion == 1
        nSecuCity := soma1(nSecuCity)
        cA01 := "PAY218" //fijo
        cA02 := PadL(cCuentaE,10,"0") //Cta empresa
        cFecha := cFech
        cA03 := SUBSTR(cFecha,3,6) //FECHA CARTA
        cA30 := "001" //fijo
        cA18_0 := ""
        IF ALLTRIM(cTipo) == "CH" //
            cA05 := "077" //fijo
            cA17 := "02" //fijo
            cA26 := ""
        else
            DO CASE
                CASE RTRIM(Banco)<>"24"
                    cA05 := "071"//PadL("37",4,"0") //fijo
                    cA17 := "21" //fijo
                    cA26 := cCodAlt // codigo alterno Cod_Alterno(Trim(RsPagos!Codbanco))
                    cA24 :=  PadL(RTRIM(cCuentaP),11,"0")    //cuenta proveedor cA28
                    cA29 := IIF(RTRIM(cTipoCu) == "1","01","02") //1:corriente, 2:ahorro
                CASE RTRIM(Banco)=="24"
                    cA05 := "072"//PadL("34",4,"0") fijo
                    cA17:= "01" //fijo
                    cA24 := PadL(RTRIM(cCuentaP),11,"0")  //cA39
                    cA26 := ""
                    cA29 := ""
                OTHERWISE
                    cA05 := "AAA"
                    cA17:= "PT"
                    cA24 :=  PadL(RTRIM(cCuentaP),11,"0")
                    cA29 := PadL(Banco,4,"0")
                    cA18_0 := ""
            ENDCASE
        ENDIF
        cA06 := "PMPAY" + RTRIM(cOrden) + Replicate(" ", 16-Len(RTRIM(cOrden)))//Audittrail orden de pago
        formato := TRANSFORM(nValor, "@E 999999.99")
        unirValor := Val(StrTran(formato,".",""))
        cA07  := StrZero(unirValor,15,0) //valor del orden de pago
        cA08 := nSecuCity //fijo Format(WNumRec, "####0") vendedor id si es 10 o 13 caracteres
        cA09 := "USD" //moneda
        cA11:= ALLTRIM(cRuc) + Replicate(" ", 21-Len(RTRIM(cRuc))) //vendedor ID longitud 21 con cA08 incluido
        cA12:= Replicate(" ",5)
        cA13 := RTRIM(StrZero(nValor,15,0)) //valor de pago->(TRXAMNT)        //RTRIM(PAGOS->EK_FORNECE) //RUC,  PadR(RTRIM(PAGOS->EK_FORNECE),14," ")
        cA14 := "000000"
        cRucP := RTRIM(cRuc)
        cOrdenPago := RTRIM(cOrden)
        // cTransaccion := RTRIM(cNum)
        cUnion := "OPAGO" + cRucP + cOrdenPago //+ cTransaccion
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
            cA20+cA20_1+cA21+cA21_1+cA22+cA22_1+cA23+cA23_1+cA29+/*cA24*+*/cA24_1+cA30+cA24_2+cA24_3+;
            cA25+cA27+cAdicional+STR_PULA
    Else
        UGENFILE(cDirectorio, cFileTxt, cFileExt, cDatos) //Llamoa la funcion para crear el archivo
    EndIf













