/*
+----------------------------------------------------------------------------+
!                       FICHA TECNICA DEL PROGRAMA                           !
+----------------------------------------------------------------------------+
!DATOS DEL PROGRAMA                                                          !
+------------------+---------------------------------------------------------+
!Tipo              ! RUTINA DE CODANA MATA0410                     !
+------------------+---------------------------------------------------------+
!Modulo            ! FACTURACION                                                 !
+------------------+---------------------------------------------------------+
!Descripcion       !LIBERACION DE PRODUCTO            !
!                  ! AC.                                                   !
+------------------+---------------------------------------------------------+
!Autor             ! Anderson Castillo                                !
+------------------+---------------------------------------------------------+
!Fecha creacion    ! Junio/2021                                              !
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
// BIBLIOTECAS NECESSÁRIAS

#Include "TOTVS.ch"
#Include "TBICONN.ch"
#Include "Topconn.ch"
//Referencia Pregunta UOPAPESO, Consulta Estandar SC5_UP
User Function USC5APESO()
    STATIC cPerg    := "UOPAPESO"
    //Static cPedido := "000044"
    //Static cCliente := "1001024130"
    If !Pergunte(cPerg,.T.) //Form de Visualizacion de Preguntas
        Return
    EndIf
    //MV_PAR01 NUMERO DE PEDIDO
    If MsgYesNo("¿Estás seguro de ejecutar la rutina MATA410? ")
        Processa({|| TMATA410() }, "Ejecutando... Espere ....")
    EndIf
Return

Static Function TMATA410()
    Local cQuery
    //  Local nSecu := 0
    // Local nTotalItem :=0
    // Local cProrratear
    // Local nTotal := 0
    Local nOpr    := 4  // NÚMERO DE OPERACION (INCLUSION) 3
    Local aHeader := {} // INFORMACIONES DE CABECERA
    Local aLine   := {} // INFORMACIONES DE LINEAS
    Local aItems  := {} // CONJUNTO DE LINEAS
    Local aArea   := {} // ARMAZENA ÁREA CORRENTE
    Local cPedido := MV_PAR01 //NUMERO DE PEDIDO
    Local bconfir := .T.
    Private lMsErroAuto := .F.
    Private lMsHelpAuto := .T.
    Static nC5_XVOLALC := 0
    aArea := GetArea() // CAPTURA DA ÁREA PARA FUTURA RESTAURACION
    cQuery := "SELECT C6_ITEM, C6_PRODUTO, C6_QTDVEN, C6_PRCVEN, C6_VALOR, C6_TES, C6_QTDLIB, C6_CONCEPT " + CRLF
    cQuery += "FROM " + RetSQLName('SC6') + " SC6"                + CRLF
    cQuery += "WHERE SC6.C6_FILIAL = '" + FwxFilial('SC6') + "' AND SC6.C6_NUM = '"+ ALLTRIM(cPedido) +"' "   + CRLF
    cQuery += " AND SC6.D_E_L_E_T_ <> '*'"

    TCQuery cQuery new Alias 'QRY_SC6'

    /* If ! QRY_SC6->(EoF())
        QRY_SC6->(DbGoTop())
        While ('QRY_SC6')->(!Eof())
            nTotalItem +=  QRY_SC6->C6_QTDVEN
        EndDo
    EndIf
    Count To nTotal*/
    //RPCSetEnv("02", "01", NIL, NIL, "FAT", NIL, {"SC5", "SC6"}) // APERTURA DE AMBIENTE (REMOVER SE EXECUTADO VIA SMARTCLIENT)

    DbSelectArea('SC5')
    dbSetOrder(1)
    dbSeek(xFilial("SC5") + cPedido)
    // cNum := GetSXENum("SC5", "C5_NUM") // REMOVER PARA GENERACION DE NUMERACION AUTOMÁTICA DE LA ROTINA
    If FOUND() //VERIFICA SI ENCONTRO EL PEDIDO
        AAdd(aHeader, {"C5_NUM", cPedido, NIL}) // REMOVER PARA GENERACION DE NUMERACION AUTOMÁTICA DE LA ROTINA
        AAdd(aHeader, {"C5_TIPO", SC5->C5_TIPO, NIL})
        //AAdd(aHeader, {"C5_CLIENTE", "1001024130", NIL})
        AAdd(aHeader, {"C5_LOJACLI", SC5->C5_LOJACLI, NIL})
        AAdd(aHeader, {"C5_LOJAENT", SC5->C5_LOJAENT, NIL})
        AAdd(aHeader, {"C5_CONDPAG",  SC5->C5_CONDPAG, NIL})
        AAdd(aHeader, {"C5_TRANSP",  SC5->C5_TRANSP, NIL})
        AAdd(aHeader, {"C5_TPFRETE", SC5->C5_TPFRETE, NIL})
        If SC5->C5_XPEBRU == 0 .OR. SC5->C5_XPETARA == 0 .OR. SC5->C5_XPENETO == 0 .OR. SC5->C5_XTEMPER == 0 .OR. SC5->C5_XDENSAL == 0 .OR. SC5->C5_XVOLALC == 0 .OR. SC5->C5_XGRDALC == 0
            //HELP(' ',1,cabecalho ,,descricao,2,0,,,,,, solucao)
            MsgAlert("Algunos campos se encuentra vacios..","Campos Obligatorios")
            bconfir := .F.
        Else
            AAdd(aHeader, {"C5_XPEBRU",   SC5->C5_XPEBRU, NIL})
            AAdd(aHeader, {"C5_XPETARA",  SC5->C5_XPETARA, NIL})
            AAdd(aHeader, {"C5_XPENETO", SC5->C5_XPENETO, NIL})
            AAdd(aHeader, {"C5_XTEMPER", SC5->C5_XTEMPER, NIL})
            AAdd(aHeader, {"C5_XDENSAL", SC5->C5_XDENSAL, NIL})
            AAdd(aHeader, {"C5_XVOLALC", SC5->C5_XVOLALC, NIL})
            AAdd(aHeader, {"C5_XGRDALC", SC5->C5_XGRDALC, NIL})
            nC5_XVOLALC := SC5->C5_XVOLALC
            //cProrratear :=  "1" //SC5->C5_XPRORRA //1 prorratea 2 no prorratea
        EndIf
    Else
        DbCloseArea()
        MsgAlert("No se encontró el pedido...","A V I S O")
    EndIf

    // DATOS DEL DETALLE
    If ! QRY_SC6->(EoF()) .AND. bconfir
        QRY_SC6->(DbGoTop())
        While ('QRY_SC6')->(!Eof())
            aLine := {}
            nA01 := QRY_SC6->C6_ITEM
            nA02 := QRY_SC6->C6_PRODUTO
            nA03 := nC5_XVOLALC
            nA04 := QRY_SC6->C6_PRCVEN
            nA05 := QRY_SC6->C6_TES
            nA06 := nC5_XVOLALC
            nA07 := QRY_SC6->C6_CONCEPT
            nValorTotal := Round(nC5_XVOLALC*nA04,2) //QRY_SC6->C6_PRCVEN
            AAdd(aLine, {"C6_ITEM", nA01 , NIL}) //QRY_SC6->C6_ITEM
            AAdd(aLine, {"C6_PRODUTO", nA02, NIL}) //QRY_SC6->C6_PRODUTO
            AAdd(aLine, {"C6_QTDVEN", nA03, NIL}) //C5_XVOLALC
            AAdd(aLine, {"C6_PRCVEN", nA04, NIL}) //QRY_SC6->C6_PRCVEN
            AAdd(aLine, {"C6_VALOR", nValorTotal, NIL})
            AAdd(aLine, {"C6_TES", nA05, NIL}) //QRY_SC6->C6_TES
            AAdd(aLine, {"C6_QTDLIB", nA06, NIL}) //C5_XVOLALC nC5_XVOLALC
            AAdd(aLine, {"C6_CONCEPT", nA07, NIL}) //C6_CONCEPT CONCEPTO

            AAdd(aItems, aLine)
            QRY_SC6->(DbSkip())
        EndDo
        QRY_SC6->(DbCloseArea())

        Begin Transaction
            MsExecAuto({|x, y, z| MATA410(x, y, z)}, aHeader, aItems, nOpr)
            // VALIDACION DE ERROR
            If (lMsErroAuto)
                MostraErro()
                // RollbackSX8() // REMOVER PARA GENRACION DE NUMERACION AUTOMÁTICA DE LA ROTINA
                ConOut(Repl("-", 80))
                ConOut(PadC("MATA410 automatic routine ended with error", 80))
                ConOut(PadC("Ended at: " + Time(), 80))
                ConOut(Repl("-", 80))
                DisarmTransaction()
                Alert("Se produjo un error en la ejecucion de la Rutina ","A V I S O")
            Else
                // ConfirmSX8() // CONFIRMACION PARA GENERACION DE NUMERACION AUTOMÁTICA DE LA ROTINA
                ConOut(Repl("-", 80))
                ConOut(PadC("MATA410 automatic routine successfully ended", 80))
                ConOut(PadC("Ended at: " + Time(), 80))
                ConOut(Repl("-", 80))
                MsgInfo("La rutina automática MATA410 finalizó con éxito ","Mensaje")
            EndIf
            RestArea(aArea) // RESTAURACION DE ÁREA ANTERIOR
            // RPCClearEnv() // FECHAMENTO DE AMBIENTE (REMOVER SE EXECUTADO VIA SMARTCLIENT)
        End Transaction
    EndIf

Return (NIL)

Static Function fMontaPed(aRegs, aCabec, aItens, nOpc, cPedido, lReprocess, nValPed)
    Local aAreas	:= {}
    Local aLinha	:= {}
    //Local aOriDes	:= {}
    //Local aOrigem	:= {}
    //Local aDestino	:= {}
    Local cNum 	:= ""
    Local cNumSZ1	:= "" //Num CTE sem série
    Local cItem	:= ""
    Local cCondPag	:= ""
    Local cTES		:= ""
    Local cNatureza	:= ""
    Local nI		:= 0
    Local nMoeda	:= 0
    Local nQtde	:= 1
    Local nTotPed	:= 0 //Usado em um reprocessamento
    Default cPedido	:= ""
    Default lReprocess 	:= .F.
    Default nValPed 	:= 0
    Aadd(aAreas, GetArea())
    Aadd(aAreas, SZ1->(GetArea()))
    Aadd(aAreas, SZ2->(GetArea()))
    Aadd(aAreas, SA1->(GetArea()))
    Aadd(aAreas, SB1->(GetArea()))
    Aadd(aAreas, SC5->(GetArea()))
    Aadd(aAreas, SC6->(GetArea()))
    DbSelectArea("SZ1") ; SZ1->(DbSetOrder(1)) // Z1_FILIAL+Z1_IDIMP
    DbSelectArea("SZ2") ; SZ2->(DbSetOrder(1)) // Z2_FILIAL+Z2_IDIMP+Z2_ITEM
    DbSelectArea("SC5") ; SC5->(DbSetOrder(1)) // C5_FILIAL+C5_NUM
    DbSelectArea("SC6") ; SC6->(DbSetOrder(1)) //
    If nOpc == 4
        If SC5->(DbSeek(xFilial("SC5") + cPedido))
            For nI := 1 To Len(aRegs)
                dDataBase  := SC5->C5_EMISSAO
                Aadd(aCabec, {"C5_NUM"	, SC5->C5_NUM	, Nil})
                Aadd(aCabec, {"C5_TIPO" 	, SC5->C5_TIPO	, Nil})
                Aadd(aCabec, {"C5_CLIENTE"	, SC5->C5_CLIENTE	, Nil})
                Aadd(aCabec, {"C5_LOJACLI"	, SC5->C5_LOJACLI	, Nil})
                Aadd(aCabec, {"C5_CLIENT"	, SC5->C5_CLIENT	, Nil})
                Aadd(aCabec, {"C5_LOJAENT"	, SC5->C5_LOJAENT	, Nil})
                Aadd(aCabec, {"C5_EMISSAO"	, SZ1->Z1_EMISSAO	, Nil})
                Aadd(aCabec, {"C5_CONDPAG"	, cCondPag	,Nil})
                Aadd(aCabec, {"C5_MOEDA"	, nMoeda		, Nil})
                Aadd(aCabec, {"C5_PEDECOM"	, cNumSZ1		, Nil})
                Aadd(aCabec, {"C5_NATUREZ"	, cNatureza	, Nil})
            Next nI
            If SC6->(DbSeek(xFilial("SC6") + SC5->C5_NUM))

                While !SC6->(EoF()) .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == SC5->C5_NUM
                    aLinha := {}
                    nTotPed += SC6->C6_VALOR
                    Aadd(aLinha, {"LINPOS", "C6_ITEM", SC6->C6_ITEM})
                    Aadd(aLinha, {"C6_PRODUTO"	, SC6->C6_PRODUTO	, Nil})
                    Aadd(aLinha, {"C6_QTDVEN"	, SC6->C6_QTDVEN	, Nil})
                    Aadd(aLinha, {"C6_PRCVEN"	, SC6->C6_PRCVEN	, Nil})
                    Aadd(aLinha, {"C6_PRUNIT"	, SC6->C6_PRUNIT	, Nil})
                    Aadd(aLinha, {"C6_VALOR"	, SC6->C6_VALOR 	, Nil})
                    Aadd(aLinha, {"C6_TES", SC6->C6_TES		, Nil})
                    Aadd(aLinha, {"C6_PEDCLI", SC6->C6_PEDCLI	, Nil})
                    Aadd(aLinha, {"AUTDELETA", "S"			, Nil})
                    cCCusto := SC6->C6_CCUSTO
                    Aadd(aItens,aLinha)
                    SC6->(DbSkip())
                EndDo
            EndIf
            DbSelectArea("SZ1")
            cItem := StrZero(0, TamSX3("C6_ITEM")[1])
            For nI := 1 To Len(aRegs)
                SZ1->(DbGoTo(aRegs[nI]))
                If SZ1->(Recno()) == aRegs[nI]
                    If SZ2->(DbSeek(xFilial("SZ2") + SZ1->Z1_IDIMP))
                        While !SZ2->(EoF()) .And. SZ2->Z2_FILIAL == xFilial("SZ2")
                            cItem := Soma1(cItem)
                            cTES := fDefTes(SZ1->Z1_CFOP)
                            aLinha := {}
                            Aadd(aLinha, {"C6_ITEM", cItem, 		Nil})
                            Aadd(aLinha, {"C6_PRODUTO", SZ2->Z2_PRODUTO,     Nil})
                            Aadd(aLinha, {"C6_QTDVEN", nQtde, 		Nil})
                            Aadd(aLinha, {"C6_PRCVEN", SZ2->Z2_PRCVEN, 	Nil})
                            Aadd(aLinha, {"C6_PRUNIT", SZ2->Z2_PRCVEN, 	Nil})
                            Aadd(aLinha, {"C6_VALOR", nQtde * SZ2->Z2_PRCVEN,Nil})
                            Aadd(aLinha, {"C6_TES", cTES, 			Nil})
                            Aadd(aLinha, {"C6_PEDCLI", SZ1->Z1_NUMERO, 	Nil})
                            cCCusto := SZ1->Z1_CCUSTO
                            Aadd(aItens,aLinha)
                            SZ2->(DbSkip())
                        EndDo
                    EndIf
                EndIf
            Next nI
        EndIf
    EndIf
    fRestAreas(aAreas)
Return(cNum)
