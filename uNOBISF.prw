#Include"protheus.ch"
#Include"TOTVS.ch"
#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
Programa uNobis 
pantalla multiples opciones para validar conceptos aprendidos
@Nobis Ecu *** Valdez
@25-02-2021
*/


//Funcion de pantalla principal
User Function uNobisF()
	Static oDlgPrin   // Objeto de la ventana principal
	Static oBitmap1  // objeto de imagen
	Static oButton1
	Static oButton2
	Static oButton3
	Static cFontPr       := "Arial"
	Static oFont1        := TFont():New(cFontPr,,-14)
	Static oFont2        := TFont():New(cFontPr,,-13)
	Static oGroup1
	Static oSay1
	DEFINE MSDIALOG oDlgPrin TITLE "Pantalla multiples opciones Valdez | TOTVS | " FROM 000, 000  TO 300, 500 COLORS 0, 16777215 PIXEL
	oMsgBar01  := TMsgBar():New(oDlgPrin, "TOTVS ANDINA | Ecuador |", .F.,.F.,.F.,.F.,RGB(116,116,116),,oFont1,.F.)
	oMsgItem01 := TMsgItem():New( oMsgBar01,'es.totvs.com', 100,oFont1,CLR_WHITE,,.T., {|| ShellExecute('OPEN','https://es.totvs.com/','','', 3 ) } )
	@ 012, 155 BITMAP oBitmap1 SIZE 087, 045 FILENAME "\img\logo.bmp" NOBORDER  ADJUST  PIXEL  NOBORDER PIXEL

	@ 009, 005 GROUP oGroup1 TO 121, 148 PROMPT "" OF oDlgPrin COLOR RGB(031,073,125)  PIXEL
	@ 024, 008 SAY oSay1 PROMPT "Programa de multiples opciones para validar los conceptos aprendidos en ADVPL" SIZE 125, 081 OF oDlgPrin FONT oFont2 COLORS RGB(031,073,125) PIXEL
	@ 061, 160 BUTTON oButton1 PROMPT "Mod" SIZE  059, 015 ACTION   processa ({|| uFunzz1() }) OF oDlgPrin FONT oFont1   PIXEL
	@ 080, 160 BUTTON oButton2 PROMPT "Grid Cli" SIZE    059, 015 ACTION   processa ({||  uGriCl() }) OF oDlgPrin FONT oFont1   PIXEL
	@ 100, 160 BUTTON oButton3 PROMPT "Salir" SIZE    055, 015   ACTION   oDlgPrin:End() OF oDlgPrin FONT oFont1 PIXEL
	ACTIVATE MSDIALOG oDlgPrin CENTERED
Return



Static Function uFunzz1 ()
	Static oDlg
	Static oButton1
	Static oButton2
	Static oButton3
	Static oGet1
	Static cGet1 := "         "
	Static oGet2
	Static cGet2 := "          "
	Static oGet3
	Static cGet3 := "           "
	Static oGet4
	Static cGet4 := "             "
	Static oGet5
	Static cGet5 := "               "
	Static oGet6
	Static nGet6 := 0
	Static oGroup1
	Static oSay1
	Static oSay2
	Static oSay3
	Static oSay4
	Static oSay5
	Static oSay6
	Static oSay7

	DEFINE MSDIALOG oDlg TITLE "Catalogo de ZZ1" FROM 000, 000  TO 500, 500 COLORS 0, 16777215 PIXEL

	@ 003, 008 GROUP oGroup1 TO 156, 225 PROMPT "Formuladio de ZZ1  Tabla de Otros.   " OF oDlg COLOR 0, 16777215 PIXEL
	@ 022, 019 SAY oSay1 PROMPT "Codigo ?" SIZE 028, 009 OF oDlg COLORS 0, 16777215 PIXEL
	@ 021, 044 MSGET oGet1 VAR cGet1 SIZE 062, 010 OF oDlg COLORS 0, 16777215 F3 "ZZ1" VALID udatos()  PIXEL
	@ 041, 051 MSGET oGet2 VAR cGet2 SIZE 091, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 043, 019 SAY oSay2 PROMPT "Decripcion" SIZE 026, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 057, 020 SAY oSay3 PROMPT "Direccion" SIZE 026, 008 OF oDlg COLORS 0, 16777215 PIXEL
	@ 056, 050 MSGET oGet3 VAR cGet3 SIZE 091, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 072, 019 SAY oSay4 PROMPT "Telefono" SIZE 027, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 072, 049 MSGET oGet4 VAR cGet4 SIZE 092, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 093, 091 SAY oSay5 PROMPT "Mail" SIZE 023, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 102, 048 MSGET oGet5 VAR cGet5 SIZE 102, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 010, 019 SAY oSay6 PROMPT "Formulario de consulta de datos de la tabla zz1" SIZE 138, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 118, 081 SAY oSay7 PROMPT "Saldo" SIZE 036, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 126, 048 MSGET oGet6 VAR nGet6 SIZE 100, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 013, 174 BUTTON oButton1 PROMPT "modificar" SIZE 028, 011 ACTION    processa ({|| uModzz1() }) OF oDlg PIXEL
	@ 032, 174 BUTTON oButton2 PROMPT "Nuevo" SIZE 028, 011 OF oDlg PIXEL
	@ 053, 174 BUTTON oButton3 PROMPT "Salir" SIZE 028, 011   ACTION odlg:end() OF oDlg PIXEL
	ACTIVATE MSDIALOG oDlg

Return


//Funcion para el cargue de datos de la ventana de zz1
Static Function uDatos()
	lRet := .F.
	if Empty(cGet1)
		Alert("Por favor ingrese un dato")
		lRet := .F.
	else
		dbselectarea("ZZ1")
		DBSetOrder(1)
		IF (DBSeek(xFilial("Z11") + cGet1))
			cDesc:= ZZ1->ZZ1_DESC
			cDire := ZZ1->ZZ1_DIRE
			cTel := ZZ1->ZZ1_TEL
			cMail := ZZ1->ZZ1_MAIL
			nSald := ZZ1->ZZ1_SALDO
			DbcloseArea("ZZ1")
			cGet2 := cDesc
			oGet2:Refresh()
			cGet3 := cDire
			oGet3:Refresh()
			cGet4:= cTel
			oGet4:Refresh()
			cGet5:=cMail
			oGet5:Refresh()
			nGet6:=Transform(nSald,"@E 999,999,999.9")
			oGet6:Refresh()
			lRet := .T.
		else
			Alert("Regsitro no encontrado")
			lRet := .F.
		Endif


	Endif

Return lRet


Static function uModzz1()
	Local cDesc, cDire, cTel, cMail, nSald := 0
	Local cCod := cGet1
	IF MsgNoYes("Desea Actuaizar los nuevos valores ?","A V I S O")
		dbselectarea("ZZ1")
		DBSetOrder(1)
		IF (DBSeek(xFilial("Z11") + cCod))
			cDesc := cGet2
			cDire := cGet3
			cTel  := cGet4
			cMail := cGet5
			nSald := nGet6
			RecLock("ZZ1",.F.)
			ZZ1->ZZ1_DESC :=  cDEsc
			ZZ1->ZZ1_DIRE :=  cDire
			ZZ1->ZZ1_TEL :=  cTel
			ZZ1->ZZ1_MAIL := cMail
			//ZZ1->ZZ1_SALDO := str(nSald)
			MsUnlock("ZZ1")
			Alert("Datos Modificados")
			DBCloseArea()
		EndIF
	Endif
return




Static Function uGriCl()
	Local aArea          := GetArea()
	Private oDlgPvt
	Private oMsGetSBM
	Private aHeader     := {}
	Private aCols     := {}
	Private oBtnSalv
	Private oBtnFech
	Private oBtnLege

	Private    nJanLarg  := 1300
	Private    nJanAltu  := 500
	Private    cFontUti  := "Lucida"
	Private    oFontSub  := TFont():New(cFontUti,,-10)
	Private    oFontSubN := TFont():New(cFontUti,,-10,,.T.)
	Private    oFontBtn  := TFont():New(cFontUti,,-09)


	//Cabecera del Grid
	//              Título               Campo        Máscara                         Tamanho                   Decimal                   Valid               Usado  Tipo  F3     Contex   Combo
	aAdd(aHeader, {"Codigo",            "ZZ1_COD",      "",                            TamSX3("ZZ1_COD")[01],     0,                        "",              ".T.", "C", "",    "" } )
	aAdd(aHeader, {"Descripcion",       "ZZ1_DESC",     "",                            TamSX3("ZZ1_DESC")[01],    0,                        "",              ".T.", "C", "",    ""} )
	aAdd(aHeader, {"Direccion",  	      "ZZ1_DIRE",     "",                            TamSX3("ZZ1_DIRE")[01],    0,                        "",              ".T.", "C", "",    ""} )
	aAdd(aHeader, {"Telefono",  	      "ZZ1_TEL",      "",                            TamSX3("ZZ1_TEL")[01],     0,                        "",              ".T.", "C", "",    ""} )
	aAdd(aHeader, {"Mail",              "ZZ1_MAIL",     "",                            TamSX3("ZZ1_MAIL")[01],    0,                        "",              ".T.", "C", "",    ""} )
	aAdd(aHeader, {"Saldo",             "ZZ1_SALDO",     "",                            10,                        2,                        "",              ".T.", "N", "",    ""} )
	//Adicion de Columas Adicionales
	aAdd(aHeader, {"Adicional1",        "Codigo",       "",                            TamSX3("ZZ1_COD")[01],       0,                      "",              ".T.", "C", "PPRODU",    ""} )
	aAdd(aHeader, {"Adicional2",        "Fecha",       "",                             8,                         0,                        "",              ".T.", "D", "",    ""} )
  aAdd(aHeader, {"Estado",            "Estado",      "",                             1,                         0,                        "Pertence('12')",   ".T.", "C", "",    "", "1=OpcionA;2=Opcionb" ,"" ,"", ""}  )

	Processa({|| uCargCol()}, "Cargando")

	DEFINE MSDIALOG oDlgPvt TITLE "Pantalla GRID ZZ1 | TOTVS | " FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL

	@ 004, 001 SAY "Programa Consulta"        SIZE 200, 030 FONT oFontSub  OF oDlgPvt COLORS RGB(031,073,125) PIXEL
	@ 014, 001 SAY "Tabla ZZ1" SIZE 200, 030 FONT oFontSubN OF oDlgPvt COLORS RGB(031,073,125) PIXEL
	@ 006, (nJanLarg/2-001)-(0052*01) BUTTON oBtnFech  PROMPT "Cerrar"        SIZE 040, 018 OF oDlgPvt ACTION (oDlgPvt:End())                               FONT oFontBtn PIXEL
	@ 006, (nJanLarg/2-001)-(0052*03) BUTTON oBtnSalv  PROMPT "Guardar"       SIZE 040, 018 OF oDlgPvt ACTION (fSalvar())                                   FONT oFontBtn PIXEL
	oMsGetSBM            := MsNewGetDados():New(   049,;                //nTop      - Linha Inicial
	003,;                //nLeft     - Coluna Inicial
	(nJanAltu/2)-3,;     //nBottom   - Linha Final
	(nJanLarg/2)-3,;     //nRight    - Coluna Final
	GD_INSERT+GD_UPDATE+GD_DELETE,;          //nStyle    - Estilos para edição da Grid (GD_INSERT = Inclusão de Linha; GD_UPDATE = Alteração de Linhas; GD_DELETE = Exclusão de Linhas)
	/*funcion de validacion de linea*/,;    //cLinhaOk  - Validação da linha
	/* validar todas las lineas */,;                   //cTudoOk   - Validação de todas as linhas
	"",;                 //cIniCpos  - Função para inicialização de campos
	{"ZZ1_DESC","ZZ1_DIRE","ZZ1_TEL","ZZ1_MAIL","ZZ1_SALDO","Codigo","Fecha","Estado"} ,;     //aAlter    - Colunas que podem ser alteradas
	,;                   //nFreeze   - Número da coluna que será congelada
	9999,;               //nMax      - Máximo de Linhas
	,;                   //cFieldOK  - Validação da coluna
	/* Funcion al intentar Adicionar nuema liena */,;                   //cSuperDel - Validação ao apertar '+'
	/*funcion de borrar linea  */,;                   //cDelOk    - Validação na exclusão da linha
	oDlgPvt,;            //oWnd      - Janela que é a dona da grid
	aHeader,;           //aHeader   - Cabeçalho da Grid
	aCols)            //aCols     - Dados da Grid


	ACTIVATE MSDIALOG oDlgPvt CENTERED
	RestArea(aArea)


Return




Static Function uCargCol()
  Local aArea          := GetArea()
  Local cQry           := ""
  Local nAtual         := 0
  Local nTotal         := 0

  cQry := " SELECT ZZ1_COD, ZZ1_DESC, ZZ1_DIRE, ZZ1_TEL, ZZ1_MAIL, ZZ1_SALDO " + CRLF
  cQry += " FROM "                                                                          + CRLF
  cQry += "     " + RetSQLName('ZZ1') + " ZZ1  "          + CRLF
  cQry += "     WHERE "                                                                     + CRLF
  cQry += "     ZZ1.D_E_L_E_T_ = ' ' "                                                  + CRLF
  TCQuery cQry New Alias "QRY_ZZ1"
  Count To nTotal
  ProcRegua(nTotal)
  QRY_ZZ1->(DbGoTop())
  While ! QRY_ZZ1->(EoF())
   nAtual++
    IncProc("Agregando " + Alltrim(QRY_ZZ1->ZZ1_COD) + " (" + cValToChar(nAtual) + " de " + cValToChar(nTotal) + ")...")
     aAdd(aCols, { ;
      QRY_ZZ1->ZZ1_COD,;
      QRY_ZZ1->ZZ1_DESC,;
      QRY_ZZ1->ZZ1_DIRE,;
      QRY_ZZ1->ZZ1_TEL,;
      QRY_ZZ1->ZZ1_MAIL,;
      QRY_ZZ1->ZZ1_SALDO,;
      "",;
	  Date(),;
	  "",;
	 })

    QRY_ZZ1->(DbSkip())
  EndDo
  QRY_ZZ1->(DbCloseArea())

  RestArea(aArea)
Return


User Function Uvalid()
AVISO("A V I S O","Aqui puede ir una consulta externa SQL")
Return
