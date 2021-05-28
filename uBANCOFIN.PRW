#Include"Protheus.ch"
#Include"TOTVS.ch"
#Include "Rwmake.ch"
#Include "Topconn.ch"

//Funcion de pantalla principal
User Function uBANCOFIN ()
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

	DEFINE MSDIALOG oDlg TITLE "Banco de Datos" FROM 000, 000  TO 500, 500 COLORS 0, 16777215 PIXEL

	@ 003, 008 GROUP oGroup1 TO 156, 225 PROMPT "Ventana de Dialogo de Banco SA6 " OF oDlg COLOR 0, 16777215 PIXEL
	@ 022, 019 SAY oSay1 PROMPT "Codigo BancoO?" SIZE 050, 011 OF oDlg COLORS 0, 16777215 PIXEL
	@ 021, 044 MSGET oGet1 VAR cGet1 SIZE 062, 010 OF oDlg COLORS 0, 16777215 F3 "SA6" VALID uBandodt()  PIXEL
	@ 041, 051 MSGET oGet2 VAR cGet2 SIZE 091, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 043, 019 SAY oSay2 PROMPT "Fecha" SIZE 026, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 056, 020 SAY oSay3 PROMPT "Direccion" SIZE 026, 008 OF oDlg COLORS 0, 16777215 PIXEL
	@ 056, 050 MSGET oGet3 VAR cGet3 SIZE 091, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 072, 019 SAY oSay4 PROMPT "Nombre" SIZE 027, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 072, 049 MSGET oGet4 VAR cGet4 SIZE 092, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 093, 091 SAY oSay5 PROMPT "Opcion" SIZE 023, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 102, 048 MSGET oGet5 VAR cGet5 SIZE 102, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 010, 019 SAY oSay6 PROMPT "Consulta de Datos Tabla SA6" SIZE 138, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 013, 174 BUTTON oButton1 PROMPT "Proccesar" SIZE 028, 011 ACTION    processa ({|| uBancoSA6() }) OF oDlg PIXEL
	@ 053, 174 BUTTON oButton3 PROMPT "Salir" SIZE 028, 011   ACTION odlg:end() OF oDlg PIXEL
	ACTIVATE MSDIALOG oDlg

Return


//Funcion para el cargue de datos de la ventana de SA6
Static Function uBandodt()
	lRet := .F.
	if Empty(cGet1)
		Alert("Por favor ingrese un dato")
		lRet := .F.
	else
		dbselectarea("SA6")
		DBSetOrder(1)
		IF (DBSeek(xFilial("SA6") + cGet1))
			cDesc:= SA6->A6_DESC
			cDire := SA6->ZZ1_DIRE
			cTel := SA6->ZZ1_TEL
			cMail := SA6->ZZ1_MAIL
			nSald := SA6->ZZ1_SALDO
			DbcloseArea("SA6")
			cGet2 := cDesc
			oGet2:Refresh()
			cGet3 := cDire
			oGet3:Refresh()
			cGet4:= cTel
			oGet4:Refresh()
			cGet5:=cMail
			oGet5:Refresh()
			lRet := .T.
		else
			Alert("Regsitro no encontrado")
			lRet := .F.
		Endif


	Endif

Return lRet


Static function uBancoSA6()
	Local cDesc, cDire, cTel, cMail, nSald := 0
	Local cCod := cGet1
	IF MsgNoYes("Desea Actuaizar los nuevos valores ?","A V I S O")
		dbselectarea("SA6")
		DBSetOrder(1)
		IF (DBSeek(xFilial("SA6") + cCod))
			cDesc := cGet2
			cDire := cGet3
			cTel  := cGet4
			cMail := cGet5
			nSald := nGet6
			RecLock("SA6",.F.)
			ZZ1->ZZ1_DESC :=  cDEsc
			ZZ1->ZZ1_DIRE :=  cDire
			ZZ1->ZZ1_TEL :=  cTel
			ZZ1->ZZ1_MAIL := cMail
			//ZZ1->ZZ1_SALDO := str(nSald)
			MsUnlock("SA6")
			Alert("Datos Modificados")
			DBCloseArea()
		EndIF
	Endif
return




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


User Function Uvalid33()
AVISO("A V I S O","Aqui puede ir una consulta externa SQL")
Return
