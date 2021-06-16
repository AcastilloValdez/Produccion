#Include "PROTHEUS.CH"
#Include "Rwmake.ch"
#Include "Topconn.ch"
#Include 'totvs.ch'

Static oBmpVerde    := LoadBitmap( GetResources(), "BR_VERDE_ESCURO")
Static oBmpVermelho := LoadBitmap( GetResources(), "BR_AZUL")
Static oBmpPreto    := LoadBitmap( GetResources(), "BR_PINK")
Static oOk			:= LoadBitmap( GetResources(), "LBOK" )
Static oNo			:= LoadBitmap( GetResources(), "LBNO" )
Static cBanc       := ""
Static cAgenc      := ""
Static cCta        := ""
Static dDati       := ""
Static dDatF       := ""
Static cNomBan     := ""
Static _CValExtr   := ""
Static _NumExtr    := ""
Static _aExtr      := ""
Static _uNoConc    := ""
Static _FiFlag    := "NO"

/*
+----------------------------------------------------------------------------+
!                       FICHA TECNICA DEL PROGRAMA                           !
+----------------------------------------------------------------------------+
!DATOS DEL PROGRAMA                                                          !
+------------------+---------------------------------------------------------+
!Tipo              ! Rutina para Conciliacion Bancaria Automatica para los   !
!                  ! bancos: Bancolombia, Occidente y Bogota.
+------------------+---------------------------------------------------------+
!Modulo            ! Financiero                                              !
+------------------+---------------------------------------------------------+
!Descripcion       ! Rutina para la conciliacion bancaria Automatica para    !
!                  ! Plos bancos Bancolombia, Occidente y Bogota, de acuerdo !
!                  ! a kos archivos multicahs suministrados por los bancos   !
!                  !                                                         !
+------------------+---------------------------------------------------------+
!Autor             ! Gabriel Alejandro Pulido                                !
+------------------+---------------------------------------------------------+
!Fecha creacion    ! 10/08/2020                                              !
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
*/

User Function uConciBanco()  

    Local oNewPag
    Local oStepWiz      := nil
    Local oDlg          := nil
    Local oPanelBkg
    Define Font oFont1 Name "Verdana" Size 6,17
    Define Font oFont2 Name "Verdana" Bold Size 6,15
    DEFINE DIALOG oDlg TITLE 'Conciliacion Bancaria Automatica CasaBlanca. | TOTVS | ' PIXEL STYLE nOR(  WS_VISIBLE ,  WS_POPUP )
    oDlg:nWidth         := 600
    oDlg:nHeight        := 520
    oPanelBkg           := tPanel():New(0,0,"",oDlg,,,,,,300,300)
    oPanelBkg:Align     := CONTROL_ALIGN_ALLCLIENT
    oStepWiz            := FWWizardControl():New(oPanelBkg)
    oStepWiz:ActiveUISteps()

    //----------------------
    // Pagina 1 - PARAMETROS
    //----------------------
    oNewPag             := oStepWiz:AddStep("1")
    oNewPag:SetStepDescription("Parametros.")
    oNewPag:SetConstruction({|Panel|cria_pg1(Panel, @cBanc, @cAgenc, @cCta, @dDatI, @dDatF )})
    oNewPag:SetNextAction({||valida_pg1( @cBanc, @cAgenc, @cCta, @dDatI, @dDatF)})
    oNewPag:SetCancelAction({||Alert("Cancelado por el Usuario"), .T., oDlg:End()})

    //---------------------------------------
    // Pagina 2 - MOVIMIENTOS BANCARIOS
    //---------------------------------------
    oNewPag             := oStepWiz:AddStep("2", {|Panel|cria_pg2(Panel)})
    oNewPag:SetStepDescription("Mvtos Bancarios.")
    oNewPag:SetNextAction({||valida_pg2()})
    oNewPag:SetCancelAction({||Alert("Cancelado por el usuario."), .T., oDlg:End()})
    oNewPag:SetPrevAction({|| .T.})
    oNewPag:SetPrevTitle("Regresar")

    //-------------------------------------
    // Pagina 3 - CARGUE DE EXTRAXTO
    //-------------------------------------
    oNewPag             := oStepWiz:AddStep("3", {|Panel|cria_pg3(Panel)})
    oNewPag:SetStepDescription("Cargue Extracto.")
    oNewPag:SetNextAction({||valida_pg3()})
    oNewPag:SetCancelAction({||.F.})
    oNewPag:SetPrevAction({|| _CancExtr() })
    oNewPag:SetPrevTitle("Regresar")

    //--------------------------------------
    // Pagina 4 - CONCILIACION  - FIN
    //--------------------------------------
    oNewPag             := oStepWiz:AddStep("4", {|Panel|cria_pg4(Panel)})
    oNewPag:SetStepDescription('Conciliacion')
    oNewPag:SetNextAction({|| IF(_FiFlag =="SI",(Aviso("Termino","Conciliacion Finalizado",{"Fechar"},1), .T., oDlg:End()),Alert("Documento No Guardado")) })
    oNewPag:SetCancelAction({||Alert("No puede cancelar la operacion actual "), .F.})
    oNewPag:SetPrevAction({||Alert("No puede regresar desde este punto."), .F.})
    oNewPag:SetCancelWhen({||.F.})
    oStepWiz:Activate()
    ACTIVATE DIALOG oDlg CENTER
    oStepWiz:Destroy()



Return
//--------------------------
// Construccion  da página 1
//--------------------------
Static Function cria_pg1(oPanel,  cBanc, cAgenc, cCta, dDatI, dDatF)
    Local oTGet1
    Local oTGet3
    Local oTGet4
    dDatI               := CTOD("//")
    dDatF               := CTOD("//")
    oSay1               := TSay():New(10,10,{||'PROGRAMA DE CONCILIACION BANCARIA AUTOMATICA'},oPanel,,oFont2,,,,.T.,,,400,20)
    oSay3               := TSay():New(20,10,{||'Este programa realiza una conciliacion bancaria / manual de acuerdo a los parametros seleccionados'},oPanel,,oFont1,,,,.T.,,,400,20)
    oSay4               := TSay():New(30,10,{||'asi como segun la informacion que se carga mediante archivo plano con el extracto del banco.'},oPanel,,oFont1,,,,.T.,,,400,20)
    oSay2               := TSay():New(46,10,{||'Para iniciar con el proceso de conciliacion por favor informe los siguientes campos:'},oPanel,,oFont2,,,,.T.,,,400,20)
    oSay5               := TSay():New(60,10,{||'Banco a Conciliar:'},oPanel,,oFont2,,,,.T.,,,400,20)
    oTGet1              := TGet():New(57,60,{|x| If(PCount() > 0,cBanc := x,cBanc)},oPanel,50,07,PesqPict("SA6","A6_COD"),{|| CTValBan(@cBanc,@cAgenc, @cCta, @cNomBan)},,,/*font*/,,,.T.,,,{|| .T.},,,/*change*/,.F.,.F.,,"cBanc")
    oTGet1:bF3          := &('{|| IIf(ConPad1(,,,"SA6",,,.F.),Eval({|| cBanc := SA6->A6_COD, cAgenc := SA6->A6_AGENCIA,  cCta := SA6->A6_NUMCON , oTGet1:Refresh()}),.T.)}')
    oSay6               := TSay():New(75,10,{|| IIf(!Empty(cBanc),'Banco:'+AllTrim(cNomBan),cNomBan   := Space(15))      },oPanel,,oFont1,,,,.T.,CLR_BLACK,CLR_WHITE,200,30)
    oSay7               := TSay():New(85,10,{|| IIf(!Empty(cBanc),'Agencia: '+AllTrim(cAgenc),cNomBan := Space(15))      },oPanel,,oFont1,,,,.T.,CLR_BLACK,CLR_WHITE,200,30)
    oSay8               := TSay():New(95,10,{|| IIf(!Empty(cBanc),'Cuenta: '+AllTrim(cCta),cNomBan := Space(15))        },oPanel,,oFont1,,,,.T.,CLR_BLACK,CLR_WHITE,200,30)
    oSay9               := TSay():New(110,10,{|| 'De Fecha: '},oPanel,,,,,,.T.,,,30,20)
    oTGet3              := tGet():New(110,60,{|u| if(PCount()>0,dDatI:=u,dDatI)}, oPanel ,50,9,"@D",{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,"dDatI")
    oSay10              := TSay():New(125,10,{|| 'A Fecha: '},oPanel,,,,,,.T.,,,30,20)
    oTGet4              := tGet():New(125,60,{|u| if(PCount()>0,dDatF:=u,dDatF)}, oPanel ,50,9,"@D",{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,"dDatF")
Return


//--------------------------
// Construccion da página 2
//--------------------------
Static Function cria_pg2(oPanel)

    Local oBtnPanel     := TPanel():New(0,0,"",oPanel,,,,,,40,40)
    oBtnPanel:Align     := CONTROL_ALIGN_ALLCLIENT
    oSay1               := TSay():New(10,10,{||'Movimientos Bancarios del Sistema'},oPanel,,oFont2,,,,.T.,,,400,20)
    oSay3               := TSay():New(20,10,{||'Para ver los movimientos Bancarios del sistema a Conciliar seleccione "Ver Movimientos'},oPanel,,oFont1,,,,.T.,,,400,20)
    oSay3               := TSay():New(30,10,{||'Para cargar el extracto bancario haga clic en Avanzar '},oPanel,,oFont1,,,,.T.,,,400,20)
    oTButton1           := TButton():New( 50, 010, "Ver Movimientos" ,oBtnPanel,{|| _cONSmv() }  , 80,20,,,.F.,.T.,.F.,,.F.,,,.F. )

Return

//--------------------------
// Construção da página 3
//--------------------------
Static Function cria_pg3(oPanel)
    Local oBtnPanel     := TPanel():New(0,0,"",oPanel,,,,,,40,40)
    oBtnPanel:Align     := CONTROL_ALIGN_ALLCLIENT
    oSay1               := TSay():New(10,10,{||'Extracto Bancario'},oPanel,,oFont2,,,,.T.,,,400,20)
    oSay3               := TSay():New(20,10,{||'Por favor seleccione el archivo del extyracto bancario para conciliar.' },oPanel,,oFont1,,,,.T.,,,400,20)
    oSay3               := TSay():New(30,10,{||'Una vez cargado el extracto por favor haga clic en Avanzar '},oPanel,,oFont1,,,,.T.,,,400,20)
    oTButton1           := TButton():New( 060, 010, "Cargar Extracto" ,oBtnPanel,{|| _CarEXt() } , 80,20,,,.F.,.T.,.F.,,.F.,,,.F. )
Return

//--------------------------
// Construção da página 4
//--------------------------
Static Function cria_pg4(oPanel,_NumExtr)
    Local oBtnPanel     := TPanel():New(0,0,"",oPanel,,,,,,40,40)
    oBtnPanel:Align     := CONTROL_ALIGN_ALLCLIENT
    oTButton2           := TButton():New( 040, 010, "Conciliacion Automatica",oBtnPanel,{|| _UFinCo(_NumExtr) }, 80,20,,,.F.,.T.,.F.,,.F.,,,.F. )
Return


//----------------------------------------------------
// Disparador datos del banco para poner en pantalla
//----------------------------------------------------
Static Function CTValBan(cBanc,cAgenc,cCta, cNomBan)
    Local _cBanc        := cBanc
    Local _cAgenc       := cAgenc
    Local _cCta         := cCta
    Local aArea         := GetArea()
    Local lRet          := .F.
    dbSelectArea("SA6")
    SA6->(dbSetOrder(1))
    If SA6->(dbSeek(xFilial("SA6")+_cBanc+_cAgenc+_cCta))
        lRet                := .T.
        cNomBan             := SA6->A6_NOME
    Else
        lRet                := .F.
    EndIf
    RestArea(aArea)
Return



//----------------------------------------------------
// Validacion de no pemite cancelar la operacion
//----------------------------------------------------
Static  function _CancExtr()
    Local lRet  := .T.
    IF _CValExtr = ''
        lRet:= .T.
    else
        Alert("No puede cancelar la Operacion ")
        lRet:= .F.
        Return (lRet)
    EndIf
Return (lRet)

//----------------------------------------------------
// Validacion de Primera pagina boton de avazar
//----------------------------------------------------
Static Function valida_pg1(cBanc, cAgenc, cCta, dDatI, dDatF)
    Local lRet          := .T.
    Local aArea         := GetArea()
    Local cDatMB        := criatrab(nil,.f.)
    Local cQryMV
    If empty(cBanc) .or. empty(cAgenc) .or. empty(cCta) .or. empty(dDatI) .or. empty(dDatF)
        Aviso(" N O  H A Y  P A R A M E T R O S.","Por favor complete los datos de los parametros para continucar.")
        lRet                := .F.
        Return lRet
    else
        cQryMV  := " SELECT   A6_NOME NOM, A6_COD BAN, A6_AGENCIA AGE, A6_NUMCON CUE, E5_DTDISPO FEC, E5_HISTOR HIS, E5_DOCUMEN DOC, E5_PREFIXO PREX,  " + CRLF
        cQryMV  += " E5_NUMERO NUM, E5_TIPODOC TDOC, E5_RECPAG TIP, E5_VALOR VAL, E5_MOEDA MOE, E5_CLIFOR CLF, E5_LOJA TIE, E5_RECONC CONC, E5_TIPO TIPO " + CRLF
        cQryMV  += " FROM " + RetSQLName('SE5') + " SE5  "       + CRLF
        cQryMV  += " LEFT JOIN SA6010 SA6 ON (E5_BANCO 	= A6_COD AND E5_AGENCIA	= A6_AGENCIA AND E5_CONTA 	= A6_NUMCON)   "       + CRLF
        cQryMV  += " WHERE   E5_RECONC = '' AND    "       + CRLF
        cQryMV  += " A6_FILIAL 	= '"+xFIlial("SA6")+"' AND    "       + CRLF
        cQryMV  += " E5_BANCO 	   = '" +cBanc+ "'   AND   "       + CRLF
        cQryMV  += " E5_AGENCIA    ='" +cAgenc+ "'  AND   "       + CRLF
        cQryMV  += " E5_CONTA 	   = '" +cCta+ "'  AND	   "       + CRLF
        cQryMV  += " NOT (E5_MOEDA IN ('C1','C2','C3','C4','C5','CH') AND E5_NUMCHEQ = '               ' AND (E5_TIPODOC NOT IN('TR','TE')))   "       + CRLF
        cQryMV  += " AND	E5_SITUACA <> 'C' AND  "       + CRLF
        cQryMV  += " E5_VALOR   <> 0 AND   "       + CRLF
        cQryMV  += " NOT(E5_NUMCHEQ BETWEEN '*              ' AND '*ZZZZZZZZZZZZZZ') AND  "       + CRLF
        cQryMV  += " E5_DTDISPO >= '" +DTOS(dDatI)+ "'   AND E5_DTDISPO <='" +DTOS(dDatF)+ "'    AND  "       + CRLF
        cQryMV  += " SE5.D_E_L_E_T_ = '' AND "       + CRLF
        cQryMV  += " SA6.D_E_L_E_T_ = '' "       + CRLF
        cQryMV              := ChangeQuery(cQryMV)
        DbUseArea(.T.,"TopCann",TcGenQry(,,cQryMV),cDatMB,.T.,.T.)
        If ((cDatMB)->(eof()))
            Aviso(" A V I S O","No hay movimientos bancarios por conciliar para los datos ingresados, revise los parametros de busqueda")
            lRet                := .F.
            Return lRet
        Else
            (cDatMB)->(DbCloseArea())
            RestArea(aArea)
        EndIf
    EndIf
Return (lRet)



//-------------------------------------------------------------------------
// Validacion de Segunda pagina boton de avanzar  NO REQUIERE VALIDACION
//--------------------------------------------------------------------------
Static Function valida_pg2()
    lRet                := .T.
Return(lRet)


//-------------------------------------------------------------------------
// Validacion de TERCERA pagina boton de avanzar, REQUIERE CARQUE EXTRACTO
//--------------------------------------------------------------------------
Static Function valida_pg3()
    lRet                := .T.
    IF  Empty(_CValExtr)
        Alert("Por favor primero realice la importacion y guardado del extracto bancario.")
        lRet := .F.
        Return (lRet)
    else
        lRet  := .T.
    EndIf
Return(lRet)

//-------------------------------------------------------------------------
// Pantalla de consulta de los movimientos bancarios que se conciliaran
//--------------------------------------------------------------------------
Static function _cONSmv()
    Local cArea         := GetArea()
    Local oBtnFech
    Local oBtnLege
    Local nJanLarg      := 1320
    Local nJanAltu      := 610
    Local cFontUti      := "Tahoma"
    Local oFontSub      := TFont():New(cFontUti,,-14)
    Local oFontBtn      := TFont():New(cFontUti,,-12)
    Private oDlgPvt
    Private oMsGetSA6
    Private aHeadSA6    := {}
    Private aColsSA6    := {}
    aAdd(aHeadSA6, {"Re/Pa",           "XX_COR",   "@BMP",                         002,                   0,                        ".F.",              "   ", "C", "",    "V",     "",      "",        "", "V"})
    aAdd(aHeadSA6, {"Banco",            "NOM",       "",                            15,  		     	  0,                        ".T.",              ".T.", "C", "",    "" } )
    aAdd(aHeadSA6, {"Cod Ban",          "BAN",       "",                            6,  				  0,                        ".T.",              ".T.", "C", "",    "" } )
    aAdd(aHeadSA6, {"Agencia",          "AGE",       "",                            6,  				  0,                        ".T.",              ".T.", "C", "",    "" } )
    aAdd(aHeadSA6, {"Cuenta",           "CUE",       "",                            8, 					  0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHeadSA6, {"Fecha",            "FEC",       "",                            10,  				  0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHeadSA6, {"Historial",        "HIS",       "",                            20, 				  0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHeadSA6, {"Documentp",        "DOC",       "",                            8, 					  0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHeadSA6, {"Prefijo",          "PREX",      "",                            4,  				  0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHeadSA6, {"Numero",           "NUM",       "",                            8,  				  2,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHeadSA6, {"Tip Doc",          "TDOC",      "",                            4, 					  0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHeadSA6, {"Tipo",             "TIP",       "",                            4, 					  0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHeadSA6, {"Valor",            "VAL",       "@E 999,999,999,999,999.99",   17, 		    	  0,                        ".T.",              ".T.", "N", "",    ""} )
    aAdd(aHeadSA6, {"Moneda",           "MOE",       "",                            5, 					  0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHeadSA6, {"Tercero",          "CLF",       "",                            15, 				  0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHeadSA6, {"Tienda",           "TIE",       "",                            5, 					  0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHeadSA6, {"Estado",           "CONC",      "",                            1, 					  0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHeadSA6, {"Tipo",             "TIPO",      "",                            5, 					  0,                        ".T.",              ".T.", "C", "",    ""} )
    Processa({|| _CarDat() }, "Cargando ... Espere ....")
    DEFINE MSDIALOG oDlgPvt TITLE "Movimientos Bancarios Protheus SIN CONCILIAR | TOTVS | " FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
    @ 004, 001 SAY " Movimientos SIN CONCILIAR EN SISTEMA" SIZE 200, 030 FONT oFontSub  OF oDlgPvt COLORS RGB(031,073,125) PIXEL
    @ 006, (nJanLarg/2-001)-(0052*01) BUTTON oBtnFech  PROMPT "Cerrar"        SIZE 040, 018 OF oDlgPvt ACTION (oDlgPvt:End())                               FONT oFontBtn PIXEL
    @ 006, (nJanLarg/2-001)-(0052*02) BUTTON oBtnLege  PROMPT "Leyenda"       SIZE 040, 018 OF oDlgPvt ACTION (fLegenda())                                  FONT oFontBtn PIXEL
    oMsGetSA6           := MsNewGetDados():New(  029,;                //nTop      - Linha Inicial
        003,;                //nLeft     - Coluna Inicial
        (nJanAltu/2)-3,;     //nBottom   - Linha Final
        (nJanLarg/2)-3,;     //nRight    - Coluna Final
        ,;                   //nStyle    - Estilos para edição da Grid (GD_INSERT = Inclusão de Linha; GD_UPDATE = Alteração de Linhas; GD_DELETE = Exclusão de Linhas)
        "AllwaysTrue()",;    //cLinhaOk  - Validação da linha
        ,;                   //cTudoOk   - Validação de todas as linhas
        "",;                 //cIniCpos  - Função para inicialização de campos
        ,;                   //aAlter    - Colunas que podem ser alteradas
        ,;                   //nFreeze   - Número da coluna que será congelada
        9999,;               //nMax      - Máximo de Linhas
        ,;                   //cFieldOK  - Validação da coluna
        ,;                   //cSuperDel - Validação ao apertar '+'
        ,;                   //cDelOk    - Validação na exclusão da linha
        oDlgPvt,;            //oWnd      - Janela que é a dona da grid
        aHeadSA6,;           //aHeader   - Cabeçalho da Grid
        aColsSA6)            //aCols     - Dados da Grid
    ACTIVATE MSDIALOG oDlgPvt CENTERED
    RestArea(cArea)
Return
//-------------------------------------------------------------------------
// cargue de los movimientos bancarios que se conciliaran
//--------------------------------------------------------------------------
Static Function _CarDat()
    Local bArea         := GetArea()
    Local cQryMV        := ""
    Local nAtual        := 0
    Local nTotal        := 0
    Local oBmpAux
    cQryMV  := " SELECT   A6_NOME NOM, A6_COD BAN, A6_AGENCIA AGE, A6_NUMCON CUE, CONVERT(CHAR(10),CONVERT(datetime,E5_DTDISPO,103),103) FEC, E5_HISTOR HIS, E5_DOCUMEN DOC, E5_PREFIXO PREX,  " + CRLF
    cQryMV  += " E5_NUMERO NUM, E5_TIPODOC TDOC, E5_RECPAG TIP, E5_VALOR VAL, E5_MOEDA MOE, E5_CLIFOR CLF, E5_LOJA TIE, E5_RECONC CONC, E5_TIPO TIPO " + CRLF
    cQryMV  += " FROM " + RetSQLName('SE5') + " SE5  "       + CRLF
    cQryMV  += " LEFT JOIN SA6010 SA6 ON (E5_BANCO 	= A6_COD AND E5_AGENCIA	= A6_AGENCIA AND E5_CONTA 	= A6_NUMCON)   "       + CRLF
    cQryMV  += " WHERE   E5_RECONC = '' AND    "       + CRLF
    cQryMV  += " A6_FILIAL 	= '"+xFIlial("SA6")+"' AND    "       + CRLF
    cQryMV  += " E5_BANCO 	   = '" +cBanc+ "'   AND   "       + CRLF
    cQryMV  += " E5_AGENCIA    ='" +cAgenc+ "'  AND   "       + CRLF
    cQryMV  += " E5_CONTA 	   = '" +cCta+ "'  AND	   "       + CRLF
    cQryMV  += " NOT (E5_MOEDA IN ('C1','C2','C3','C4','C5','CH') AND E5_NUMCHEQ = '               ' AND (E5_TIPODOC NOT IN('TR','TE')))   "       + CRLF
    cQryMV  += " AND	E5_SITUACA <> 'C' AND  "       + CRLF
    cQryMV  += " E5_VALOR   <> 0 AND   "       + CRLF
    cQryMV  += " NOT(E5_NUMCHEQ BETWEEN '*              ' AND '*ZZZZZZZZZZZZZZ') AND  "       + CRLF
    cQryMV  += " E5_DTDISPO >= '" +DTOS(dDatI)+ "'   AND E5_DTDISPO <='" +DTOS(dDatF)+ "'    AND  "       + CRLF
    cQryMV  += " SE5.D_E_L_E_T_ = '' AND "       + CRLF
    cQryMV  += " SA6.D_E_L_E_T_ = '' "       + CRLF
    TCQuery cQryMV New Alias "QRY_SA6"
    Count To nTotal
    ProcRegua(nTotal)
    QRY_SA6->(DbGoTop())
    While ! QRY_SA6->(EoF())
        nAtual++
        IncProc("Agregando " + Alltrim(QRY_SA6->NOM) + " (" + cValToChar(nAtual) + " de " + cValToChar(nTotal) + ")...")
        oBmpAux             := oBmpPreto
        If QRY_SA6->TIP == 'P'
            oBmpAux             := oBmpVerde
        ElseIf QRY_SA6->TIP == 'R'
            oBmpAux             := oBmpVermelho
        EndIf
        aAdd(aColsSA6, { ;
            oBmpAux,;
            QRY_SA6->NOM,;
            QRY_SA6->BAN,;
            QRY_SA6->AGE,;
            QRY_SA6->CUE,;
            QRY_SA6->FEC,;
            QRY_SA6->HIS,;
            QRY_SA6->DOC,;
            QRY_SA6->PREX,;
            QRY_SA6->NUM,;
            QRY_SA6->TDOC,;
            QRY_SA6->TIP,;
            QRY_SA6->VAL,;
            QRY_SA6->MOE,;
            QRY_SA6->CLF,;
            QRY_SA6->TIE,;
            QRY_SA6->CONC,;
            QRY_SA6->TIPO,;
            .F.;
            })
        QRY_SA6->(DbSkip())
    EndDo
    QRY_SA6->(DbCloseArea())
    RestArea(bArea)
Return

//-------------------------------------------------------------------------
// Leyenda de la ventan de los movimientos bancarios.
//--------------------------------------------------------------------------
Static Function fLegenda()
    Local aLegenda      := {}
    aAdd(aLegenda, {"BR_VERDE_ESCURO",    "Movimiento PAGAR"})
    aAdd(aLegenda, {"BR_AZUL", "Movimiento COBRAR"})
    BrwLegenda("Movimiento Bancario / Tipo de Movimiento", "Leyenda", aLegenda)
Return



//-------------------------------------------------------------------------
// Pantalla para realizar el cargue del extracto banario
//--------------------------------------------------------------------------
Static Function _CarEXt()
    Local oButton1
    Local oButton2
    Local oSim          := LoadBitmap(GetResources(), "ENABLE")
    Local oNao          := LoadBitmap(GetResources(), "DISABLE")
    Local oCidade
    Local oCNPJ
    Local oEmpresa
    Local oEndereco
    Local oPedido
    Local _cCodi        := cBanc    //Space(3)
    Local _cNoban       := cNomBan  //Space(3)
    Local _cAgenc       := cAgenc   //Space(10)
    Local _cCuent       := cCta         //Space(10)
    Private oPedidos
    Private cNoCon      := Space(10)
    Private cCObEx      := Space(4)
    Private cCoCue      := Space(10)
    Private cNoExt      := Space(6)
    Private aItens      := {}
    Private aPedidos    := {}
    Private _CUSUA      := cUserName
    Private _cFecha
    Private _cHora
    Private  oDlCargEX
    DEFINE MSDIALOG oDlCargEX TITLE "CARGUE DE EXTRACTO BANCARIO PARA CONCILIACION. " FROM 000, 000  TO 400, 1200 PIXEL
    @ 003, 005 SAY oSay1 PROMPT  "No Conciliacion:" SIZE 040, 007 OF oDlCargEX PIXEL
    @ 011, 005 MSGET oPedido VAR cNoCon SIZE 056, 010 OF oDlCargEX   READONLY PIXEL
    @ 003, 070 SAY oSay2 PROMPT  "Codigo" SIZE 025, 007 OF oDlCargEX PIXEL
    @ 011, 070 MSGET oCNPJ VAR   _cCodi SIZE 040, 010 OF oDlCargEX  READONLY PIXEL
    @ 003, 132 SAY oSay3 PROMPT  "Banco" SIZE 025, 007 OF oDlCargEX PIXEL
    @ 011, 132 MSGET oEmpresa VAR _cNoban SIZE 131, 010 OF oDlCargEX READONLY PIXEL
    @ 024, 005 SAY oSay4 PROMPT "Agencia" SIZE 025, 007 OF oDlCargEX PIXEL
    @ 031, 005 MSGET oEndereco VAR _cAgenc SIZE 060, 010 OF oDlCargEX READONLY  PIXEL
    @ 024, 070 SAY oSay5 PROMPT "Cuenta" SIZE 025, 007 OF oDlCargEX PIXEL
    @ 031, 070 MSGET oCidade VAR _cCuent SIZE 070, 010 OF oDlCargEX READONLY PIXEL
    @ 024, 150 SAY oSay4 PROMPT "Cod Ban Ext" SIZE 035, 007 OF oDlCargEX PIXEL
    @ 031, 150 MSGET oEndereco VAR cCObEx SIZE 060, 010 OF oDlCargEX  READONLY PIXEL
    @ 024, 220 SAY oSay5 PROMPT "Cuenta Ban Ext" SIZE 035, 007 OF oDlCargEX PIXEL
    @ 031, 220 MSGET oCidade VAR cCoCue SIZE 030, 010 OF oDlCargEX  READONLY PIXEL
    @ 024, 270 SAY oSay5 PROMPT "No Extracto" SIZE 035, 007 OF oDlCargEX PIXEL
    @ 031, 270 MSGET oCidade VAR cNoExt  SIZE 030, 010 OF oDlCargEX  READONLY  PIXEL
    oPedidos := TCBrowse():New(050, 005,560, 120,,,,oDlCargEX,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
    oPedidos:AddColumn(TCColumn():New(" "       	, {|| If(aPedidos[oPedidos:nAt,01],oSim,oNao) },,,,,,.T.,.F.,,,,.F., ) )
    oPedidos:AddColumn(TCColumn():New("Fec. Afectacion. "  	, {|| aPedidos[oPedidos:nAt,02]},"@D",,,"CENTER", 010,.F.,.F.,,{|| .F. },,.F., ) )
    oPedidos:AddColumn(TCColumn():New("Fec. Movimiento."  	, {|| aPedidos[oPedidos:nAt,03]},"@D",,,"CENTER", 01,.F.,.F.,,{|| .F. },,.F., ) )
    oPedidos:AddColumn(TCColumn():New("Valor Movimiento."  	, {|| aPedidos[oPedidos:nAt,04]},"@E 999,999,999,999,999.99",,,"LEFT", 080,.F.,.F.,,{|| .F. },,.F., ) )
    oPedidos:AddColumn(TCColumn():New("Num CH."  	    	, {|| aPedidos[oPedidos:nAt,05]},"@!",,,"CENTER", 010,.F.,.F.,,{|| .F. },,.F., ) )
    oPedidos:AddColumn(TCColumn():New("Cod Tran."  		    , {|| aPedidos[oPedidos:nAt,06]},"@!",,,"CENTER", 010,.F.,.F.,,{|| .F. },,.F., ) )
    oPedidos:AddColumn(TCColumn():New("Num NIT."  		    , {|| aPedidos[oPedidos:nAt,07]},"@!",,,"CENTER", 020,.F.,.F.,,{|| .F. },,.F., ) )
    oPedidos:AddColumn(TCColumn():New("Nom Pagador."        , {|| aPedidos[oPedidos:nAt,08]},"@!",,,"CENTER", 080,.F.,.F.,,{|| .F. },,.F., ) )
    oPedidos:AddColumn(TCColumn():New("Nom Archivo."        , {|| aPedidos[oPedidos:nAt,09]},"@!",,,"CENTER", 100,.F.,.F.,,{|| .F. },,.F., ) )
    oPedidos:AddColumn(TCColumn():New("Usuario."            , {|| aPedidos[oPedidos:nAt,10]},"@!",,,"CENTER", 100,.F.,.F.,,{|| .F. },,.F., ) )
    oPedidos:AddColumn(TCColumn():New("Fec Ejecu."          , {|| aPedidos[oPedidos:nAt,11]},"@!",,,"CENTER", 100,.F.,.F.,,{|| .F. },,.F., ) )
    oPedidos:AddColumn(TCColumn():New("Hora Ejec."          , {|| aPedidos[oPedidos:nAt,12]},"@!",,,"CENTER", 100,.F.,.F.,,{|| .F. },,.F., ) )
    oPedidos:SetArray(aPedidos)  //Define um array para o browse
    oPedidos:bWhen      := { || Len(aPedidos) > 0 } //Se o array estiver vazio, o browse fica desabilitado
    oPedidos:Refresh()
    IF _cCodi == '001' .or.  _cCodi == '002' //BANCOLOMBIA
        @ 003, 337 BITMAP oBitmap1 SIZE 250, 045  FILENAME "\img\bancos\Bancolombia.bmp" OF oDlCargEX NOBORDER PIXEL
    ELSEIF _cCodi == '011'.or. _cCodi == '012' //BOGOTA
        @ 003, 337 BITMAP oBitmap1 SIZE 250, 045  FILENAME "\img\bancos\Bogota.bmp" OF oDlCargEX NOBORDER PIXEL
    ELSEIF _cCodi == '021'  //OCCIDENTE
        @ 003, 337 BITMAP oBitmap1 SIZE 250, 045  FILENAME "\img\bancos\Occidente.bmp" OF oDlCargEX NOBORDER PIXEL
    ENDIF
    @ 181, 097 BUTTON oButton1 PROMPT "Importar" SIZE 037, 012 OF oDlCargEX ACTION Processa({|| _ImpoEXT()},"Espere...") PIXEL
    @ 181, 157 BUTTON oButton1 PROMPT "Grabar" SIZE 037, 012 OF oDlCargEX ACTION Processa({|| _GrabEXT()},"Espere...") PIXEL
    @ 181, 217 BUTTON oButton2 PROMPT "Cerrar" SIZE 037, 012 OF oDlCargEX ACTION oDlCargEX:End() PIXEL
    ACTIVATE MSDIALOG oDlCargEX CENTERED
Return



//-----------------------------------------------------------------------------
// carga los datos de extracto en grid
//-----------------------------------------------------------------------------
Static Function _ImpoEXT()
    Local nCont         := 0
    Local i             := 0
    Local nLinhas       := 0
    Local _aStr         := {{"Texto","C",1000,0}}
    Local _cTmp         := CriaTrab(NIL,.F.)
    Local nValor        := 0
    Private cArquivo    := cGetFile("Arquivo TXT (*.TXT) |*.TXT|","Por favor seleccione el Extracto ...",2,'C:\',.T.,GETF_LOCALHARD+GETF_NETWORKDRIVE,.F.,.F.)
    if !file(Alltrim(cArquivo))
        Alert("Arquivo "+Alltrim(cArquivo)+" Archivo no Valido!"+CRLF+"Cancelando Importe !")
        Return
    Endif
    dbCreate(_cTmp,_aStr)
    IF SELECT("TRB") # 0
        TRB->(dbCloseArea())
    ENDIF
    DBUseArea(.T.,,_cTmp,"TRB",.F.,.F.)
    if AT(":\",cArquivo)>0
        CpyT2S( cArquivo, GetSrvProfString("Startpath","") )
    Else
        CpyT2S( cArquivo, GetSrvProfString("Startpath","") )
    endif
    Append From &cArquivo SDF
    TRB->(dbGoTop())
    nLinhas             := TRB->(RecCount())
    ProcRegua(nLinhas)
    aPedidos            := {}
    While TRB->(!Eof())
        nCont++
        If lEnd
            MsgInfo("Cancelado!","Finalizado")
            exit
        Endif
        IF nCont > nLinhas
            exit
        endif
        IncProc("Leyendo Archivo...Linea No "+Alltrim(str(nCont)))
        cLinha              := ALLTRIM(UPPER(TRB->Texto))
        if !empty(cLinha)
            aadd(aItens,Separa(cLinha,";",.T.))
        endif
        DbSkip()
    EndDo
    TRB->(dbCloseArea())
    Ferase(_cTmp+".DBF")
    IF LEN(aItens[1]) < 22
        Alert("Estructura del archivo invalida")
        Return .F.
    Else
        if len(aItens) > 0
            M->cCObEx           := aItens[1][1]
            M->cCoCue           := aItens[1][2]
            M->cNoExt           := aItens[1][3]
        Endif
        For i := 1 to len(aItens)
            IncProc("Insertando registros item "+ Alltrim(aItens[i,1])+"...")
            nValor              := Val(aItens[i,11])
            _cFecha             := date()
            _cHora              := GetRmtTime()
            lLege               := .T.
            IF nValor > 0
                lLege               := .T.
            Else
                lLege               := .F.
            EndIf
            aadd(aPedidos,{lLege,;
                aItens[i][4],;
                aItens[i][14],;
                nValor,;
                aItens[i][6],;
                aItens[i][7],;
                aItens[i][17],;
                aItens[i][22],;
                cArquivo,;
                _CUSUA,;
                _cFecha,;
                _cHora ;
                })
        Next
    endif
    oPedidos:SetArray(aPedidos)
    Ferase(GetSrvProfString("Startpath","")+cArquivo)
Return


//-----------------------------------------------------------------------------
// Guarda los datos del grid del extracto en tabla ZZD
//-----------------------------------------------------------------------------
Static Function _GrabEXT()
    Local _NForI
    Local _cCodi        := cBanc
    Local _cAgenc       := cAgenc
    Local _cCuent       := cCta
    Local _cNoban       := cNomBan
    Local aArea         := GetArea()
    Local cQryZZD       := ""
    Local nTotal        := 0
    Local _CArcq        := cNoExt
    X31UPDTABLE("ZZD")
    //Se debe adicionar validacion si el archivo esta vacio, para que no truene
    IF Empty(_CArcq)
        Aviso("A V I S O","No puede grabar registros por que no se a importado ningun extracto."    ,{"Ok"})
        Return .F.
    else
        _aExtr        := aItens[1][3]
        Begin Transaction
            _uNoConc := GetSXENum('ZZD','ZZD_XNUCO')
            If MsgYesNo("Confirmar el guarado del Extracto Bancario en el Sistema", "A V I S O")
                cQryZZD  := " SELECT  * " + CRLF
                cQryZZD  += " FROM " + RetSQLName('ZZD') + " ZZD  "       + CRLF
                cQryZZD  += " WHERE   ZZD_FILIAL =  '"+xFIlial("ZZD")+"' AND    "       + CRLF
                cQryZZD  += " ZZD_XCOBAN 	= '" +_cCodi+ "'  AND    "       + CRLF
                cQryZZD  += " ZZD_XAGEN    ='" +_cAgenc+ "'  AND   "       + CRLF
                cQryZZD  += " ZZD_XCUENT 	   = '" +_cCuent+ "'  AND	   "       + CRLF
                cQryZZD  += " ZZD_XNOEX 	   = '" +_aExtr+ "'  AND	   "       + CRLF
                cQryZZD  += " D_E_L_E_T_ = '' "       + CRLF
                TCQuery cQryZZD New Alias "QRY_ZZD"
                Count To nTotal
                ProcRegua(nTotal)
                QRY_ZZD->(DbGoTop())
                IF !QRY_ZZD->(EoF())
                    MSGINFO("El extracto cargado ya existe en el sistema","Extracto ya cargado")
                    RollBackSX8()
                    QRY_ZZD->(DbSkip())
                    QRY_ZZD->(DbCloseArea())
                    RestArea(aArea)
                    Return .F.
                ELSE
                    _CValExtr           := aItens[1][3]
                    For _NforI = 1 to len(aItens)
                        _nVaExtr            := Val(aItens[_NforI,11])
                        RecLock("ZZD", .T.)
                        ZZD->ZZD_FILIAL     := xFIlial("ZZD")
                        ZZD->ZZD_XNUCO      := _uNoConc
                        ZZD->ZZD_XCOBAN     := _cCodi
                        ZZD->ZZD_XNOMBA     := _cNoban
                        ZZD->ZZD_XAGEN      := _cAgenc
                        ZZD->ZZD_XCUENT     := _cCuent
                        ZZD->ZZD_XCOBAE     := aItens[_NforI][1]
                        ZZD->ZZD_XCUEXT     := aItens[_NforI][2]
                        ZZD->ZZD_XNOEX      := aItens[_NforI][3]
                        ZZD->ZZD_XFEAFE     := aItens[_NforI][4]
                        ZZD->ZZD_XFECMO     := aItens[_NforI][14]
                        ZZD-> ZZD_XVALOR    := _nVaExtr
                        ZZD->ZZD_XNUMCH     := aItens[_NforI][6]
                        ZZD->ZZD_XCODTR     := aItens[_NforI][7]
                        ZZD->ZZD_XNIT       := aItens[_NforI][17]
                        ZZD->ZZD_XNOMPG     := aItens[_NforI][22]
                        ZZD->ZZD_XNOMAR     := aPedidos[1][9]
                        ZZD->ZZD_XUSUAR     := _CUSUA
                        ZZD->ZZD_XFECH      := _cFecha
                        ZZD->ZZD_XHORA      := _cHora
                        ZZD->(MSUNLOCK())
                    Next
                    Aviso("Extracto Guardado","Extracto guardado correctamente en el sistema " ,{"Ok"})
                    ConfirmSX8()
                    oDlCargEX:End()
                    QRY_ZZD->(DbSkip())
                    QRY_ZZD->(DbCloseArea())
                    RestArea(aArea)
                ENDIF
            ELSE
                RollBackSX8()
            ENDIF
            RestArea(aArea)
            DBCloseArea()
        End Transaction
    EndIf
    _NumExtr := cNoExt
Return (_aExtr)



//-----------------------------------------------------------------------------
// PANTALLA DE LA CONCILIACION DE DATOS SISTEMA VS EXTRACTO
//-----------------------------------------------------------------------------
Static Function _UFinCo(_NumExtr)
    Local lFlag := .F.
    Local nDiGra   := 0
    nDiGra  := GETMV("MV_XGRACON")
    Private oDlg_FinCb
    Private oLbx1,oLbx2
    Private oFld
    Private oBtn
    Private cFontUti  := "Tahoma"
    Private oFontSub  := TFont():New(cFontUti,,-14)
    Private oFontSubN := TFont():New(cFontUti,,-14,,.T.)
    Private oFontBtn  := TFont():New(cFontUti,,-12)
    Private oFontAviso  := TFont():New(cFontUti,,-24)
    Private oFont1	:= TFont():New( "Calibri",0,16,,.T.,0,,700,.T.,.F.,,,,,, )
    Private oFont2	:= TFont():New( "Arial",0,24,,.T.,,,,.F.,.F.,,,,,, )
    Private aDatMB	:= {}
    Private aExtMB	:= {}
    Private cTexto  := ""
    Private nDifer  := 0
    Private oGet1
    Private nGet1 := 0
    Private oGet2
    Private nGet2 := 0
    Private oGet3
    Private nGet3 := 0
    Private oGet4
    Private nGet4 := 0
    Private oGet5
    Private nGet5 := 0
    Private oGet6
    Private nGet6 := 0
    DEFINE MSDIALOG oDlg_FinCb TITLE "CONCILIACION BANCARIA AUTOMATICA" FROM 000, 000  TO 605, 1220 COLORS 0, 16777215 PIXEL
    @ 005, 004 GROUP oGroup1 TO 297, 600 PROMPT "Conciliacion Bancaria Automatica" OF oDlg_FinCb COLOR 0, 16777215 PIXEL
    @ 014, 010 SAY "Programa de Conciliacion Bancaria Sistema Vs. Extracto Bancario. (Los movimientos que el sistema detecto automaticamente los marca como conciliados)"   SIZE 600, 030 FONT oFontSub  OF oDlg_FinCb COLORS RGB(031,073,125) PIXEL
    @ 027, 015 SAY "MOVIMIENTOS DEL SISTEMA"        SIZE 200, 030 FONT oFontSubN  OF oDlg_FinCb COLORS RGB(031,073,125) PIXEL
    @ 027, 301 SAY "EXTRACTO BANCARIO"        SIZE 200, 030 FONT oFontSubN  OF oDlg_FinCb COLORS RGB(031,073,125) PIXEL
    @ 038,012 LISTBOX oLbx1 FIELDS HEADER "Conci ?","Tip Mov","Valor","Cod. Banco.","Agencia.","Cuenta.","Nombre.","Fecha.","Historial.", "R_E_C_N_O_" SIZE 268,169 PIXEL ON DBLCLICK (_UMarMB(oLbx1,@aDatMB,@oDlg_FinCb),oLbx1:nColPos:= 1, oLbx1:Refresh()) NOSCROLL //"Campo: "
    @ 038,295 LISTBOX oLbx2 FIELDS HEADER "Conci ?","Tip Mov","Valor","Cod. Banco.","Agencia.","Cuenta.","Nombre.","Fecha.","R_E_C_N_O_"  SIZE 268,169 PIXEL ON DBLCLICK (_UExtMa(oLbx2,@aExtMB,@oDlg_FinCb),oLbx2:nColPos:= 1, oLbx2:Refresh()) NOSCROLL //"Campo: "
    Carr_MB(aDatMB)
    Carr_EX(aExtMB,@_aExtr)
    oLbx1:SetArray(aDatMB)
    oLbx1:bLine := { || { aDatMB[oLbx1:nAt,01],;
        aDatMB[oLbx1:nAt,02],;
        transform(aDatMB[oLbx1:nAt,03],"@E 999,999,999,999,999.99"),;
        aDatMB[oLbx1:nAt,04],;
        aDatMB[oLbx1:nAt,05],;
        aDatMB[oLbx1:nAt,06],;
        aDatMB[oLbx1:nAt,07],;
        aDatMB[oLbx1:nAt,08],;
        aDatMB[oLbx1:nAt,09],;
        aDatMB[oLbx1:nAt,10] } }
    oLbx2:SetArray(aExtMB)
    oLbx2:bLine := { || { aExtMB[oLbx2:nAt,01],;
        aExtMB[oLbx2:nAt,02],;
        transform(aExtMB[oLbx2:nAt,03],"@E 999,999,999,999,999.990"),;
        aExtMB[oLbx2:nAt,04],;
        aExtMB[oLbx2:nAt,05],;
        aExtMB[oLbx2:nAt,06],;
        aExtMB[oLbx2:nAt,07],;
        aExtMB[oLbx2:nAt,08],;
        aExtMB[oLbx2:nAt,09],;
        aExtMB[oLbx2:nAt,10]} }
    _uValMB (@oGet1,@nGet1,@oGet2,@nGet2,@oGet3,@nGet3,@oDlg_FinCb,@aDatMB)
    _uValExt(@oGet4,@nGet4,@oGet5,@nGet5,@oGet6,@nGet6,@oDlg_FinCb, @aExtMB)
    @ 210, 055 SAY "TOTALES SISTEMA" SIZE 200, 030 FONT oFontSubN  OF oDlg_FinCb COLORS RGB(031,073,125) PIXEL
    @ 220, 060 SAY "ENTRADAS:"       SIZE 200, 030 FONT oFontSub  OF oDlg_FinCb COLORS RGB(031,073,125) PIXEL
    @ 220, 130 MSGET oGet1 VAR transform(nGet1,"@E 999,999,999,999.99") SIZE 068, 008 OF oDlg_FinCb COLORS 0, 15394764 READONLY PIXEL
    @ 230, 060 SAY "SALIDAS:"        SIZE 200, 030 FONT oFontSub  OF oDlg_FinCb COLORS RGB(031,073,125) PIXEL
    @ 230, 130 MSGET oGet2 VAR transform(nGet2,"@E 999,999,999,999.99") SIZE 068, 008 OF oDlg_FinCb COLORS 0, 15394764 READONLY PIXEL
    @ 240, 060 SAY "VALOR CONCILIADO:" SIZE 200, 030 FONT oFontSub  OF oDlg_FinCb COLORS RGB(031,073,125) PIXEL
    @ 240, 130 MSGET oGet3 VAR transform(nGet3,"@E 999,999,999,999.99")  SIZE 068, 008 OF oDlg_FinCb COLORS 0, 15394764 READONLY PIXEL
    @ 225, 215 BUTTON oButREcMB PROMPT "Recalcular MOVIMIENTO" SIZE 064, 017  OF oDlg_FinCb ACTION Processa({||  _uValCon(@oDlg_FinCb, @nGet3, @nGet6, @lFlag, @cTexto, @nDifer), oDlg_FinCb:Refresh() },"Espere...")  PIXEL
    @ 210, 360 SAY "TOTALES EXTRACTO"        SIZE 200, 030 FONT oFontSubN  OF oDlg_FinCb COLORS RGB(031,073,125) PIXEL
    @ 220, 365 SAY "ENTRADAS:"        SIZE 200, 030 FONT oFontSub  OF oDlg_FinCb COLORS RGB(031,073,125) PIXEL
    @ 220, 435 MSGET oGet4 VAR transform(nGet4,"@E 999,999,999,999.99") SIZE 068, 008 OF oDlg_FinCb COLORS 0, 15394764 READONLY PIXEL
    @ 230, 365 SAY "SALIDAS:"        SIZE 200, 030 FONT oFontSub  OF oDlg_FinCb COLORS RGB(031,073,125) PIXEL
    @ 230, 435 MSGET oGet5 VAR transform(nGet5,"@E 999,999,999,999.99") SIZE 068, 008 OF oDlg_FinCb COLORS 0, 15394764 READONLY PIXEL
    @ 240, 365 SAY "VALOR CONCILIADO: "        SIZE 200, 030 FONT oFontSub  OF oDlg_FinCb COLORS RGB(031,073,125) PIXEL
    @ 240, 435 MSGET oGet6 VAR transform(nGet6,"@E 999,999,999,999.99") SIZE 068, 008 OF oDlg_FinCb COLORS 0, 15394764 READONLY PIXEL
    @ 225, 519 BUTTON oButRExt PROMPT "Recalcular EXTRACTO" SIZE 064, 017  OF oDlg_FinCb  ACTION Processa({||  _uValCon(@oDlg_FinCb, @nGet3, @nGet6, @lFlag, @cTexto, @nDifer),  oDlg_FinCb:Refresh() },"Espere...")  PIXEL
    //Valida la diferencia entre los valores
    _uValCon(@oDlg_FinCb, @nGet3, @nGet6, @lFlag, @cTexto, @nDifer)
    @ 265, 350 BUTTON oButton2 PROMPT "GUARDAR" SIZE 044, 017  OF oDlg_FinCb  ACTION Processa({||  _UGravDat(@oDlg_FinCb, @nGet3, @nGet6, @lFlag, @aDatMB , @aExtMB, @cTexto, @nDifer )  },"Espere...")    PIXEL
    @ 265, 400 BUTTON oButton2 PROMPT "LEYENDA " SIZE 044, 017  OF oDlg_FinCb ACTION Processa({|| _uLeyCO() },"Espere...")  PIXEL
    @ 265, 450 BUTTON oButton2 PROMPT "SALIR" SIZE 044, 017  OF oDlg_FinCb  ACTION {|| IF(_FiFlag =="SI",oDlg_FinCb:End(), uRolBak(_uNoConc)   )} PIXEL
    @ 265, 550 BUTTON oButton2 PROMPT "VALOR GRACIA" SIZE 044, 017  OF oDlg_FinCb  ACTION {|| Aviso("VALOR DE GRACIA PARA CONCILIACION.","El valor de Gracias configurado en el parametro para la conciliacion es de : "+STR(nDiGra) )} PIXEL
    ACTIVATE MSDIALOG oDlg_FinCb
Return
oDlg_FinCb:End()


//-----------------------------------------------------------------------------
// Marca o desmarca los movimientos del sistema
//-----------------------------------------------------------------------------
Static Function _UMarMB( oLbx1 , aListBox , oDlg_FinCb )
    IF  aListBox[ oLbx1:nAt , 1 ] == oOk
        IF MsgYesNo("¨Cambiar Estado ?")
            aListBox[ oLbx1:nAt , 1 ] := oNo
            _uValMB (@oGet1,@nGet1,@oGet2,@nGet2,@oGet3,@nGet3,@oDlg_FinCb,@aDatMB)
        EndIf
    ElseIf aListBox[ oLbx1:nAt , 1 ] == oNo
        aListBox[ oLbx1:nAt , 1 ] := oOk
        _uValMB(@oGet1,@nGet1,@oGet2,@nGet2,@oGet3,@nGet3,@oDlg_FinCb,@aDatMB)
    EndIF
    oLbx1:Refresh()
    oDlg_FinCb:Refresh()
Return( NIL )


//-----------------------------------------------------------------------------
// Marca o desmarca los Extractos del banco
//-----------------------------------------------------------------------------
Static Function _UExtMa( oLbx2 , aExtBox , oDlg_FinCb )
    IF  aExtBox[ oLbx2:nAt , 1 ] == oOk
        IF MsgYesNo("¨Cambiar Estado ?")
            aExtBox[ oLbx2:nAt , 1 ] := oNo
            _uValExt(@oGet4,@nGet4,@oGet5,@nGet5,@oGet6,@nGet6,@oDlg_FinCb, @aExtMB)
        Endif
    ElseIf aExtBox[ oLbx2:nAt , 1 ] == oNo
        aExtBox[ oLbx2:nAt , 1 ] := oOk
        _uValExt(@oGet4,@nGet4,@oGet5,@nGet5,@oGet6,@nGet6,@oDlg_FinCb, @aExtMB)
    EndIF
    oLbx2:Refresh()
    oDlg_FinCb:Refresh()
Return( NIL )


//-----------------------------------------------------------------------------
// Carga en el grid los datos de los movimientos del sistrema
//-----------------------------------------------------------------------------
Static Function Carr_MB(aDatMB)
    Local bArea         := GetArea()
    Local cQryMV        := ""
    Local nAtual        := 0
    Local nTotal        := 0
    Local nValGra       := GETMV("MV_XCOBAV")
    Local nI            := 0
    cQryMV  := " SELECT   A6_NOME NOM, A6_COD BAN, A6_AGENCIA AGE, A6_NUMCON CUE, CONVERT(CHAR(10),CONVERT(datetime,E5_DTDISPO,103),103) FEC, E5_HISTOR HIS, E5_DOCUMEN DOC, E5_PREFIXO PREX,  " + CRLF
    cQryMV  += " E5_NUMERO NUM, E5_TIPODOC TDOC, E5_RECPAG TIP, E5_VALOR VAL, E5_MOEDA MOE, E5_CLIFOR CLF, E5_LOJA TIE, E5_RECONC CONC, E5_TIPO TIPO," + CRLF
    cQryMV  += " CASE  WHEN E5_RECPAG = 'P' AND (E5_VALOR) * -1 IN (SELECT (ZZD_XVALOR )FROM " + RetSQLName('ZZD') + " ZZD     WHERE D_E_L_E_T_ =''  AND  ZZD_FILIAL= '"+xFIlial("ZZD")+"' AND   ZZD_XCOBAN = '" +cBanc+ "'   AND ZZD_XAGEN    ='" +cAgenc+ "'  AND  ZZD_XCUENT 	   = '" +cCta+ "'  AND ZZD_XRECON = ''      ) " + CRLF
    cQryMV  += " THEN 'CONCILIADO'  "       + CRLF
    For nI = 0 To nValGra
        cQryMV  += " WHEN E5_RECPAG = 'P' AND (E5_VALOR) * -1 IN (SELECT (ZZD_XVALOR + '"+transform(nI,"@E 9")+"' ) FROM " + RetSQLName('ZZD') + " ZZD   WHERE D_E_L_E_T_ =''  AND  ZZD_FILIAL= '"+xFIlial("ZZD")+"' AND   ZZD_XCOBAN = '" +cBanc+ "'   AND ZZD_XAGEN    ='" +cAgenc+ "'  AND  ZZD_XCUENT 	   = '" +cCta+ "' AND ZZD_XRECON = ''      ) " + CRLF
        cQryMV  += " THEN 'CONCILIADO'  "       + CRLF
        //Adicionado marzo 2021
        cQryMV  += " WHEN E5_RECPAG = 'P' AND ((E5_VALOR) * -1) / 2 IN (SELECT (ZZD_XVALOR + '"+transform(nI,"@E 9")+"' ) FROM " + RetSQLName('ZZD') + " ZZD   WHERE D_E_L_E_T_ =''  AND  ZZD_FILIAL= '"+xFIlial("ZZD")+"' AND   ZZD_XCOBAN = '" +cBanc+ "'   AND ZZD_XAGEN    ='" +cAgenc+ "'  AND  ZZD_XCUENT 	   = '" +cCta+ "' AND ZZD_XRECON = ''      ) " + CRLF
        cQryMV  += " THEN 'CONCILIADO'  "       + CRLF
    Next  nI
    For nI = 0 To nValGra
        cQryMV  += " WHEN E5_RECPAG = 'P' AND (E5_VALOR) * -1 IN (SELECT (ZZD_XVALOR - '"+transform(nI,"@E 9")+"' ) FROM " + RetSQLName('ZZD') + " ZZD   WHERE D_E_L_E_T_ =''  AND  ZZD_FILIAL= '"+xFIlial("ZZD")+"' AND   ZZD_XCOBAN = '" +cBanc+ "'   AND ZZD_XAGEN    ='" +cAgenc+ "'  AND  ZZD_XCUENT 	   = '" +cCta+ "' AND ZZD_XRECON = ''       ) " + CRLF
        cQryMV  += " THEN 'CONCILIADO'  "       + CRLF
        //Adicionado marzo 2021
        cQryMV  += " WHEN E5_RECPAG = 'P' AND ((E5_VALOR) * -1) / 2 IN (SELECT (ZZD_XVALOR - '"+transform(nI,"@E 9")+"' ) FROM " + RetSQLName('ZZD') + " ZZD   WHERE D_E_L_E_T_ =''  AND  ZZD_FILIAL= '"+xFIlial("ZZD")+"' AND   ZZD_XCOBAN = '" +cBanc+ "'   AND ZZD_XAGEN    ='" +cAgenc+ "'  AND  ZZD_XCUENT 	   = '" +cCta+ "'  AND ZZD_XRECON = ''      ) " + CRLF
        cQryMV  += " THEN 'CONCILIADO'  "       + CRLF
    Next  nI
    cQryMV  += " WHEN E5_RECPAG = 'R' AND (E5_VALOR)  IN (SELECT (ZZD_XVALOR ) FROM " + RetSQLName('ZZD') + " ZZD   WHERE D_E_L_E_T_ =''  AND  ZZD_FILIAL= '"+xFIlial("ZZD")+"' AND   ZZD_XCOBAN = '" +cBanc+ "'   AND ZZD_XAGEN    ='" +cAgenc+ "'  AND  ZZD_XCUENT 	   = '" +cCta+ "'  AND ZZD_XRECON = ''     ) " + CRLF
    cQryMV  += " THEN 'CONCILIADO'  "       + CRLF
    //Adicionado marzo 2021
    cQryMV  += " WHEN E5_RECPAG = 'R' AND (E5_VALOR) / 2  IN (SELECT (ZZD_XVALOR ) FROM " + RetSQLName('ZZD') + " ZZD   WHERE D_E_L_E_T_ =''  AND  ZZD_FILIAL= '"+xFIlial("ZZD")+"' AND   ZZD_XCOBAN = '" +cBanc+ "'   AND ZZD_XAGEN    ='" +cAgenc+ "'  AND  ZZD_XCUENT 	   = '" +cCta+ "' AND ZZD_XRECON = ''     ) " + CRLF
    cQryMV  += " THEN 'CONCILIADO'  "       + CRLF
    For nI = 0 To nValGra
        cQryMV  += " WHEN E5_RECPAG = 'R' AND (E5_VALOR)  IN (SELECT (ZZD_XVALOR  - '"+transform(nI,"@E")+"'  ) FROM " + RetSQLName('ZZD') + " ZZD   WHERE D_E_L_E_T_ =''  AND  ZZD_FILIAL= '"+xFIlial("ZZD")+"' AND   ZZD_XCOBAN = '" +cBanc+ "'   AND ZZD_XAGEN    ='" +cAgenc+ "'  AND  ZZD_XCUENT 	   = '" +cCta+ "'  AND ZZD_XRECON = ''     ) " + CRLF
        cQryMV  += " THEN 'CONCILIADO'  "       + CRLF
        //Adicionado marzo 2021
        cQryMV  += " WHEN E5_RECPAG = 'R' AND (E5_VALOR) / 2 IN (SELECT (ZZD_XVALOR  - '"+transform(nI,"@E")+"'  ) FROM " + RetSQLName('ZZD') + " ZZD   WHERE D_E_L_E_T_ =''  AND  ZZD_FILIAL= '"+xFIlial("ZZD")+"' AND   ZZD_XCOBAN = '" +cBanc+ "'   AND ZZD_XAGEN    ='" +cAgenc+ "'  AND  ZZD_XCUENT 	   = '" +cCta+ "'  AND ZZD_XRECON = ''     ) " + CRLF
        cQryMV  += " THEN 'CONCILIADO'  "       + CRLF
    Next  nI
    For nI = 0 To nValGra
        cQryMV  += " WHEN E5_RECPAG = 'R' AND (E5_VALOR)  IN (SELECT (ZZD_XVALOR  + '"+transform(nI,"@E")+"'  ) FROM " + RetSQLName('ZZD') + " ZZD   WHERE D_E_L_E_T_ =''  AND  ZZD_FILIAL= '"+xFIlial("ZZD")+"' AND   ZZD_XCOBAN = '" +cBanc+ "'   AND ZZD_XAGEN    ='" +cAgenc+ "'  AND  ZZD_XCUENT 	   = '" +cCta+ "'   AND ZZD_XRECON = ''       ) " + CRLF
        cQryMV  += " THEN 'CONCILIADO'  "       + CRLF
        //Adicionado marzo 2021
        cQryMV  += " WHEN E5_RECPAG = 'R' AND (E5_VALOR) / 2 IN (SELECT (ZZD_XVALOR  + '"+transform(nI,"@E")+"'  ) FROM " + RetSQLName('ZZD') + " ZZD   WHERE D_E_L_E_T_ =''  AND  ZZD_FILIAL= '"+xFIlial("ZZD")+"' AND   ZZD_XCOBAN = '" +cBanc+ "'   AND ZZD_XAGEN    ='" +cAgenc+ "'  AND  ZZD_XCUENT 	   = '" +cCta+ "'   AND ZZD_XRECON = ''       ) " + CRLF
        cQryMV  += " THEN 'CONCILIADO'  "       + CRLF
    Next  nI
    cQryMV  += " END AS ESTADO, SE5.R_E_C_N_O_  CONS"       + CRLF
    cQryMV  += " FROM " + RetSQLName('SE5') + " SE5  "       + CRLF
    cQryMV  += " LEFT JOIN SA6010 SA6 ON (E5_BANCO 	= A6_COD AND E5_AGENCIA	= A6_AGENCIA AND E5_CONTA 	= A6_NUMCON)   "       + CRLF
    cQryMV  += " WHERE   E5_RECONC = '' AND    "       + CRLF
    cQryMV  += " A6_FILIAL 	= '"+xFIlial("SA6")+"' AND    "       + CRLF
    cQryMV  += " E5_BANCO 	   = '" +cBanc+ "'   AND   "       + CRLF
    cQryMV  += " E5_AGENCIA    ='" +cAgenc+ "'  AND   "       + CRLF
    cQryMV  += " E5_CONTA 	   = '" +cCta+ "'  AND	   "       + CRLF
    cQryMV  += " NOT (E5_MOEDA IN ('C1','C2','C3','C4','C5','CH') AND E5_NUMCHEQ = '               ' AND (E5_TIPODOC NOT IN('TR','TE')))   "       + CRLF
    cQryMV  += " AND	E5_SITUACA <> 'C' AND  "       + CRLF
    cQryMV  += " E5_VALOR   <> 0 AND   "       + CRLF
    cQryMV  += " NOT(E5_NUMCHEQ BETWEEN '*              ' AND '*ZZZZZZZZZZZZZZ') AND  "       + CRLF
    cQryMV  += " E5_DTDISPO >= '" +DTOS(dDatI)+ "'   AND E5_DTDISPO <='" +DTOS(dDatF)+ "'    AND  "       + CRLF
    cQryMV  += " SE5.D_E_L_E_T_ = '' AND "       + CRLF
    cQryMV  += " SA6.D_E_L_E_T_ = ''  ORDER BY E5_VALOR ASC "       + CRLF
    TCQuery cQryMV New Alias "QRY_MB"
    Count To nTotal
    ProcRegua(nTotal)
    QRY_MB->(DbGoTop())
    While ! QRY_MB->(EoF())
        nAtual++
        IncProc("Agregando " + Alltrim(QRY_MB->NOM) + " (" + cValToChar(nAtual) + " de " + cValToChar(nTotal) + ")...")
        oBmpAux := oBmpPreto
        If QRY_MB->TIP == 'P'
            oBmpAux := oBmpVerde
        ElseIf QRY_MB->TIP == 'R'
            oBmpAux := oBmpVermelho
        EndIf
        aAdd(aDatMB, { ;
            IF(QRY_MB->ESTADO == 'CONCILIADO',oOk,oNo),;
            oBmpAux,;
            QRY_MB->VAL,;
            QRY_MB->BAN,;
            QRY_MB->AGE,;
            QRY_MB->CUE,;
            QRY_MB->NOM,;
            QRY_MB->FEC,;
            QRY_MB->HIS,;
            QRY_MB->CONS,;
            .F.;
            })
        QRY_MB->(DbSkip())
    EndDo
    QRY_MB->(DbCloseArea())
    RestArea(bArea)
Return (aDatMB)


//-----------------------------------------------------------------------------
// Carga en el grid los datos de del extracto del banco cargado
//-----------------------------------------------------------------------------
Static Function Carr_EX(aExtMB,_aExtr)
    Local bArea         := GetArea()
    Local cQryEXT        := ""
    Local nAtual        := 0
    Local nTotal        := 0
    Local nValGra       := GETMV("MV_XCOBAV")
    Local nI            := 0
    cQryEXT  := " SELECT ZZD_XVALOR VAL,   ZZD_XCOBAN BAN ,   ZZD_XAGEN AGE,   ZZD_XCUENT CUE ,   ZZD_XNOMBA NOMBA ,  ZZD_XFEAFE FEC, " + CRLF
    cQryEXT  += " CASE  WHEN ZZD_XVALOR < 0 AND (ZZD_XVALOR) * -1 IN (SELECT (E5_VALOR )FROM " + RetSQLName('SE5') + " SE5   WHERE D_E_L_E_T_ =''  AND E5_FILIAL= '"+xFIlial("SE5")+"' AND   E5_BANCO  = '" +cBanc+ "'   AND E5_AGENCIA    ='" +cAgenc+ "'  AND  E5_CONTA 	   = '" +cCta+ "'  ) " + CRLF
    cQryEXT  += " THEN 'CONCILIADO' " + CRLF
    For nI = 0 to nValGra
        cQryEXT  += "  WHEN ZZD_XVALOR < 0 AND (ZZD_XVALOR) * -1 IN (SELECT (E5_VALOR  + '"+transform(nI,"@E 9")+"' ) FROM " + RetSQLName('SE5') + " SE5   WHERE D_E_L_E_T_ =''  AND E5_FILIAL= '"+xFIlial("SE5")+"' AND   E5_BANCO  = '" +cBanc+ "'   AND E5_AGENCIA    ='" +cAgenc+ "'  AND  E5_CONTA 	   = '" +cCta+ "'  ) " + CRLF
        cQryEXT  += " THEN 'CONCILIADO' " + CRLF
        //Adicionado marzo 2021
        cQryEXT  += "  WHEN ZZD_XVALOR < 0 AND ((ZZD_XVALOR) * -1) * 2 IN (SELECT (E5_VALOR  + '"+transform(nI,"@E 9")+"' ) FROM " + RetSQLName('SE5') + " SE5   WHERE D_E_L_E_T_ =''  AND E5_FILIAL= '"+xFIlial("SE5")+"' AND   E5_BANCO  = '" +cBanc+ "'   AND E5_AGENCIA    ='" +cAgenc+ "'  AND  E5_CONTA 	   = '" +cCta+ "'  ) " + CRLF
        cQryEXT  += " THEN 'CONCILIADO' " + CRLF
    Next  nI
    For nI = 0 to nValGra
        cQryEXT  += " WHEN ZZD_XVALOR < 0 AND (ZZD_XVALOR) * -1 IN (SELECT (E5_VALOR  - '"+transform(nI,"@E 9")+"' ) FROM " + RetSQLName('SE5') + " SE5   WHERE D_E_L_E_T_ =''  AND E5_FILIAL= '"+xFIlial("SE5")+"' AND   E5_BANCO  = '" +cBanc+ "'   AND E5_AGENCIA    ='" +cAgenc+ "'  AND  E5_CONTA 	   = '" +cCta+ "'  ) " + CRLF
        cQryEXT  += " THEN 'CONCILIADO' " + CRLF
        //Adicionado marzo 2021
        cQryEXT  += " WHEN ZZD_XVALOR < 0 AND ((ZZD_XVALOR) * -1) * 2 IN (SELECT (E5_VALOR  - '"+transform(nI,"@E 9")+"' ) FROM " + RetSQLName('SE5') + " SE5   WHERE D_E_L_E_T_ =''  AND E5_FILIAL= '"+xFIlial("SE5")+"' AND   E5_BANCO  = '" +cBanc+ "'   AND E5_AGENCIA    ='" +cAgenc+ "'  AND  E5_CONTA 	   = '" +cCta+ "'  ) " + CRLF
        cQryEXT  += " THEN 'CONCILIADO' " + CRLF
    Next  nI

    For nI = 0 to nValGra
        cQryEXT  += "  WHEN ZZD_XVALOR > 0 AND (ZZD_XVALOR)  IN (SELECT (E5_VALOR  + '"+transform(nI,"@E 9")+"' ) FROM " + RetSQLName('SE5') + " SE5   WHERE D_E_L_E_T_ =''  AND E5_FILIAL= '"+xFIlial("SE5")+"' AND   E5_BANCO  = '" +cBanc+ "'   AND E5_AGENCIA    ='" +cAgenc+ "'  AND  E5_CONTA 	   = '" +cCta+ "'  ) " + CRLF
        cQryEXT  += " THEN 'CONCILIADO' " + CRLF
        //Adicionado marzo 2021
        cQryEXT  += "  WHEN ZZD_XVALOR > 0 AND (ZZD_XVALOR) * 2 IN (SELECT (E5_VALOR  + '"+transform(nI,"@E 9")+"' ) FROM " + RetSQLName('SE5') + " SE5   WHERE D_E_L_E_T_ =''  AND E5_FILIAL= '"+xFIlial("SE5")+"' AND   E5_BANCO  = '" +cBanc+ "'   AND E5_AGENCIA    ='" +cAgenc+ "'  AND  E5_CONTA 	   = '" +cCta+ "'  ) " + CRLF
        cQryEXT  += " THEN 'CONCILIADO' " + CRLF
    Next  nI
    For nI = 0 to nValGra
        cQryEXT  += " WHEN ZZD_XVALOR > 0 AND (ZZD_XVALOR)  IN (SELECT (E5_VALOR  - '"+transform(nI,"@E 9")+"' ) FROM " + RetSQLName('SE5') + " SE5   WHERE D_E_L_E_T_ =''  AND E5_FILIAL= '"+xFIlial("SE5")+"' AND   E5_BANCO  = '" +cBanc+ "'   AND E5_AGENCIA    ='" +cAgenc+ "'  AND  E5_CONTA 	   = '" +cCta+ "'  ) " + CRLF
        cQryEXT  += " THEN 'CONCILIADO' " + CRLF
        //Adicionado marzo 2021
        cQryEXT  += " WHEN ZZD_XVALOR > 0 AND (ZZD_XVALOR) * 2  IN (SELECT (E5_VALOR  - '"+transform(nI,"@E 9")+"' ) FROM " + RetSQLName('SE5') + " SE5   WHERE D_E_L_E_T_ =''  AND E5_FILIAL= '"+xFIlial("SE5")+"' AND   E5_BANCO  = '" +cBanc+ "'   AND E5_AGENCIA    ='" +cAgenc+ "'  AND  E5_CONTA 	   = '" +cCta+ "'  ) " + CRLF
        cQryEXT  += " THEN 'CONCILIADO' " + CRLF
    Next  nI
    cQryEXT  += " END AS ESTADO , R_E_C_N_O_ CONS"       + CRLF
    cQryEXT  += " FROM " + RetSQLName('ZZD') + " ZZD  "       + CRLF
    cQryEXT  += " WHERE    D_E_L_E_T_ = ''  AND    "       + CRLF
    cQryEXT  += " ZZD_FILIAL 	= '"+xFIlial("ZZD")+"' AND    "       + CRLF
    cQryEXT  += " ZZD_XCOBAN 	   = '" +cBanc+ "'   AND   "       + CRLF
    cQryEXT  += " ZZD_XAGEN    ='" +cAgenc+ "'  AND   "       + CRLF
    cQryEXT  += " ZZD_XCUENT 	   = '" +cCta+ "'  	   "       + CRLF
    cQryEXT  += "AND ZZD_XRECON = ''   ORDER BY  ZZD_XVALOR ASC  "       + CRLF
    TCQuery cQryEXT New Alias "QRY_EXT"
    Count To nTotal
    ProcRegua(nTotal)
    QRY_EXT->(DbGoTop())
    While ! QRY_EXT->(EoF())
        nAtual++
        IncProc("Agregando " + Alltrim(QRY_EXT->BAN) + " (" + cValToChar(nAtual) + " de " + cValToChar(nTotal) + ")...")
        oBmpAux := oBmpPreto
        If QRY_EXT->VAL < 1
            oBmpAux := oBmpVerde
        ElseIf  QRY_EXT->VAL > 1
            oBmpAux := oBmpVermelho
        EndIf
        aAdd(aExtMB, { ;
            IF(QRY_EXT->ESTADO == 'CONCILIADO',oOk,oNo),;
            oBmpAux,;
            QRY_EXT->VAL,;
            QRY_EXT->BAN,;
            QRY_EXT->AGE,;
            QRY_EXT->CUE,;
            QRY_EXT->NOMBA,;
            QRY_EXT->FEC,;
            QRY_EXT->CONS,;
            .F.;
            })
        QRY_EXT->(DbSkip())
    EndDo
    QRY_EXT->(DbCloseArea())
    RestArea(bArea)
Return (aExtMB)


//-----------------------------------------------------------------------------
// Valida y recalcula los valores de los movimientos del sistema
//-----------------------------------------------------------------------------
Static Function _uValMB(oGet1,nGet1,oGet2,nGet2,oGet3,nGet3,oDlg_FinCb,aDatMB)
    Local nI
    nGet1 := 0
    nGet2 := 0
    nGet3 := 0
    //Entradas
    For nI = 1 to len(aDatMB)
        IF aDatMB[nI,2] = oBmpVermelho
            nGet1 +=   aDatMB[nI,3]
        EndIf
    End
    //SAlidas
    For nI = 1 to len(aDatMB)
        IF aDatMB[nI,2] =  oBmpVerde
            nGet2 +=   aDatMB[nI,3]
        EndIf
    end
    //conciliado
    For nI = 1 to len(aDatMB)
        IF aDatMB[nI,1] = oOk
            nGet3 +=   aDatMB[nI,3]
        EndIf
    end
    nGet2 := nGet2 * -1
    M->oGet1 := transform(nGet1,"@E 999,999,999,999.99")
    M->oGet2 := transform(nGet2,"@E 999,999,999,999.99")
    M->oGet3 := transform(nGet3,"@E 999,999,999,999.99")
    oDlg_FinCb:Refresh()

Return


//-----------------------------------------------------------------------------
// Valida y recalcula los valores del extracto bancario
//-----------------------------------------------------------------------------
Static Function _uValExt(oGet4,nGet4,oGet5,nGet5,oGet6,nGet6,oDlg_FinCb,aExtMB)
    Local nJ
    nGet4 := 0
    nGet5 := 0
    nGet6 := 0
    //Entradas
    For nJ = 1 to len(aExtMB)
        IF aExtMB[nJ,2] == oBmpVermelho
            nGet4 +=   aExtMB[nJ,3]
        EndIf
    end
    //Salidas
    For nJ = 1 to len(aExtMB)
        IF aExtMB[nJ,2] ==  oBmpVerde
            nGet5 +=   aExtMB[nJ,3]
        EndIf
    end
    //Conciliados
    For nJ = 1 to len(aExtMB)
        IF aExtMB[nJ,1] == oOk
            IF aExtMB[nJ,3] < 0
                nGet6 +=    aExtMB[nJ,3] * -1
            Else
                nGet6 +=    aExtMB[nJ,3]
            Endif
        EndIf
    end
    M->oGet4 := transform(nGet4,"@E 999,999,999,999.99")
    M->oGet5 := transform(nGet5,"@E 999,999,999,999.99")
    M->oGet6 := transform(nGet6,"@E 999,999,999,999.99")
    oDlg_FinCb:Refresh()

Return



//-------------------------------------------------------------------------
// Leyenda de la Ventana de Conciliaion Bancaria
//-------------------------------------------------------------------------
Static Function _uLeyCO()
    Local aLegenda      := {}
    aAdd(aLegenda, {"BR_VERDE_ESCURO",    "Movimiento PAGAR"})
    aAdd(aLegenda, {"BR_AZUL", "Movimiento COBRAR"})
    BrwLegenda("Tipo de Movimiento SISTEMA / EXTRACTO", "L E Y E N D A", aLegenda)
Return


//-------------------------------------------------------------------------
// Refresca los valores y valida nuevamente si hay diferencias
//-------------------------------------------------------------------------
Static Function _uValCon(oDlg_FinCb, nGet3, nGet6, lFlag, cTexto, nDifer)
    Local cVal := 0
    Local nDiGra    := GETMV("MV_XGRACON")
    cVal = nGet3 - nGet6
    If cVal <= nDiGra
        IF cVal  >= nDiGra * -1
            nDifer  := cVal
            cTexto := "CONCILIADO"
            @ 260, 142 SAY "Diferencia: $"  SIZE 200, 030 FONT oFontAviso  OF oDlg_FinCb COLORS RGB(031,073,125) PIXEL
            @ 260, 198 SAY transform(nDifer,"@E 999,999,999,999.99")  SIZE 200, 030 FONT oFontAviso  OF oDlg_FinCb COLORS RGB(031,073,125) PIXEL
            @ 260, 012 SAY cTexto  SIZE 200, 030 FONT oFontAviso  OF oDlg_FinCb COLORS RGB(031,073,125) PIXEL
            lFlag := .T.
            oDlg_FinCb:Refresh()
        else
            nDifer  := cVal
            cTexto := "NO CONCILIADO"
            @ 260, 142 SAY "Diferencia: $"  SIZE 200, 030 FONT oFontAviso  OF oDlg_FinCb COLORS RGB(031,073,125) PIXEL
            @ 260, 198 SAY transform(nDifer,"@E 999,999,999,999.99")   SIZE 200, 030 FONT oFontAviso  OF oDlg_FinCb COLORS RGB(031,073,125) PIXEL
            @ 260, 012 SAY cTexto  SIZE 200, 030 FONT oFontAviso  OF oDlg_FinCb COLORS RGB(031,073,125) PIXEL
            lFlag := .F.
            oDlg_FinCb:Refresh()

        eNDIF
    Else
        nDifer  := cVal
        cTexto := "NO CONCILIADO"
        @ 260, 142 SAY "Diferencia: $"  SIZE 200, 030 FONT oFontAviso  OF oDlg_FinCb COLORS RGB(031,073,125) PIXEL
        @ 260, 198 SAY transform(nDifer,"@E 999,999,999,999.99")   SIZE 200, 030 FONT oFontAviso  OF oDlg_FinCb COLORS RGB(031,073,125) PIXEL
        @ 260, 012 SAY cTexto  SIZE 200, 030 FONT oFontAviso  OF oDlg_FinCb COLORS RGB(031,073,125) PIXEL
        lFlag := .F.
        oDlg_FinCb:Refresh()
    EndIF
    oDlg_FinCb:Refresh()
Return (lFlag)



//-------------------------------------------------------------------------
//Si conciliado procede a realizar el guardado de datos
//-------------------------------------------------------------------------
Static Function _UGravDat(oDlg_FinCb, nGet3, nGet6, lFlag, aDatMB , aExtMB,  cTexto, nDifer)

    Local cVal := 0
    Local cRecno := ""
    Local nI := 0
    Local nJ := 0
    cVal = nGet3 - nGet6
    If  lFlag  // Si flag es verdadero pasa
        If cVal <= 100  //Validamos que no haya error en los checks
            IF cVal  >= -100 //Validamos que no haya error en los checks   se debe indicar cuanto va a ser el valor de diferencia permitido
                //Procede a realizar el guardado de datos proceso final de la conciliacion.
                // UPDATE SE5010
                For nI = 1 to len(aDatMB)
                    cRecno := aDatMB[nI,10]
                    cUpdSE5 := " UPDATE "+RetSqlName("SE5")+" SET  E5_RECONC = 'S', E5_XCONCIL = 'S', E5_XNUCO = '"+_uNoConc+"' "
                    cUpdSE5 += " WHERE R_E_C_N_O_ = '"+ALLTRIM(transform(cRecno,"@E 9999999999"))+"'  "
                    cUpdSE5 += " AND E5_FILIAL =  '"+xFIlial("SE5")+"'  "
                    TcSqlExec(cUpdSE5)
                    lResult := TCSQLEXEC(cUpdSE5)
                    If lResult < 0
                        Return MsgStop("Error durante la actualizacion, consulte con el administrador: " + TCSQLError())
                    EndIf
                Next nI
                //UPDATE ZZD010
                For nJ = 1 to len(aExtMB)
                    cRecno := aExtMB[nJ,9]
                    cUpdZZD := " UPDATE "+RetSqlName("ZZD")+" SET  ZZD_XRECON = 'S' "
                    cUpdZZD += " WHERE R_E_C_N_O_ = '"+ALLTRIM(transform(cRecno,"@E 9999999999"))+"'  "
                    cUpdZZD += " AND  ZZD_FILIAL = '"+xFIlial("ZZD")+"'  "
                    TcSqlExec(cUpdZZD)
                    lResult := TCSQLEXEC(cUpdZZD)
                    If lResult < 0
                        Return MsgStop("Error durante la actualizacion, consulte con el administrador: " + TCSQLError())
                    EndIf
                Next nI
                Aviso("E X I T O S O","Conciliacion No: '"+_uNoConc+"'  guardada con exito en el sistema",{"Ok"})
                _FiFlag := "SI"
                oDlg_FinCb:End()
            else
                Alert("ElDocumento no se encuentra cuadrado, no procede guardado")
                oDlg_FinCb:Refresh()
                Return .F.
            Endif
        else
            Alert("ElDocumento no se encuentra cuadrado, no procede guardado")
            oDlg_FinCb:Refresh()
            Return .F.
        Endif
    else
        Alert ("La conciliacion actualmente presenta una diferencia no permitida")
        Return .F.
        oDlg_FinCb:Refresh()
    Endif
Return

//Funcion adicionada para validar el borrado de los datos del extracto en caso de que se desee salir.
Static Function uRolBak(_uNoConc)
Local cNume := _uNoConc
	IF MsgNoYes("Documento  no guardado, ¿ Desea SALIR ?","A V I S O")
		DbSelectArea("ZZD")
		ZZD->(DbSetOrder(2)) //Filial+Ordem Producao
		if ZZD->(DbSeek(xFilial("ZZD")+cNume)) .And. ZZD->ZZD_XRECON != '1'  
			While ZZD->(!EoF()) 
				ZZD->(RecLock("ZZD",.F.))
				ZZD->(DbDelete())
				ZZD->(MsUnLock())
				ZZD->(DbSkip(1))
			EndDo
			Aviso("A V I S O","Registros del Extracto Borrados")
            oDlg_FinCb:End()
		EndIf
	else
		Return .F.
	EndIF
Return
