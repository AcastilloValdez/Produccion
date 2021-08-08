#INCLUDE 'PROTHEUS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LOCXPE33  ºAutor  ³Juan Pablo Astorga  ºFecha ³  20/04/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Carga campos personalizados en encabezado de documentos  º±±
±±º          ³   de entrada y salida.                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß   
// ===================================================================================== //
// 1	NF	Nota fiscal de Vendas	Cliente	Faturamento
// 2	NDC	Nota de débito cliente	Cliente	Faturamento                         
// 3	NCE	Nota de crédito externa	Cliente	Faturamento
// 4	NCC	Nota de crédito cliente	Cliente	Faturamento
// 5	NDE	Nota de débito externa	Cliente	Faturamento
// 6	NDI	Nota de débito interna	Fornecedor	Compras
// 7	NCP	Nota de crédito fornecedor	Fornecedor	Compras
// 8	NCI	Nota de crédito Interna	Fornecedor	Compras
// 9	NDP	Nota de débito fornecedor	Fornecedor	Compras
// 10	NF	Nota Fiscal de compras	Fornecedor	Compras
// 11	NF	Nota fiscal de Beneficiamento	Fornecedor	Faturamento
// 12	NF	Nota fiscal de Beneficiamento	Cliente	Compras
// 13	NF	Nota Fiscal de despesas de importação	Fornecedor	Compras
// 14	NF	Nota Fiscal de frete	Fornecedor	Compras
// 15	REC	Recibo	Fornecedor	Compras
// 50	RFN	Remito faturamento normal	Cliente	Faturamento
// 51	RFD	Remito faturamento Devolução (Documento próprio)	Cliente	Faturamento
// 52	RFB	Remito faturamento Beneficiamento	Fornecedor	Faturamento
// 53	RFD	Remito faturamento Devolução (Documento não próprio)	Cliente	Faturamento
// 54	RTS	Envio de remito de transferencia	Fornecedor	Estoques
// 60	RCN	Remito compras normal	Fornecedor	Compras
// 61	RCD	Remito compras Devolução	Fornecedor	Compras
// 62	RCB	Remito compras Beneficiamento	Cliente	Compras
// 63	RET	Retorno Simbólico (consignação)	Cliente	Faturamento
// 64	RTE	Recebemento de remito de transferencia	Fornecedor	Estoques
// ===================================================================================== //
*/
User function LOCXPE33()
	Local aArea := GetArea()
	Local aCposNF := ParamIxb[1]
	Local nTipo := ParamIxb[2]
	Local aDetalles := {}
	Local nNuevoElem := 0
	Local nPosCpo := 0
	Local nL      := 0
	Local aCposNCC := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Usuario debe definir nuevos Tipos...                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	If nTipo == 7 // NCP nota de credito proveedor
		//Detalles,      Campo       Usado  Obligatorio  Visual
		AADD(aDetalles,{"F2_XGLOSA"  ,  .T.      ,.F.      ,.F.   })
	Endif

	If nTipo == 54 // RTS Transferencia entre sucursal
		//Detalles,      Campo       Usado  Obligatorio  Visual
		AADD(aDetalles,{"F2_XPEBRU"  ,  .T.      ,.F.      ,.F.   })
		AADD(aDetalles,{"F2_XPETARA"  ,  .T.      ,.F.      ,.F.   })
		AADD(aDetalles,{"F2_XPENETO"  ,  .T.      ,.F.      ,.F.   })
		AADD(aDetalles,{"F2_XPLACA"  ,  .T.      ,.F.      ,.F.   })
		AADD(aDetalles,{"F2_XRUTA"  ,  .T.      ,.F.      ,.F.   })
		AADD(aDetalles,{"F2_XDEST"  ,  .T.      ,.F.      ,.F.   })
		AADD(aDetalles,{"F2_XCONDUC"  ,  .T.      ,.F.      ,.F.   })
		AADD(aDetalles,{"F2_XCODFOR"    ,.T.      	,.F.      ,.F.   })
		AADD(aDetalles,{"F2_XTIENDA"    ,.T.      	,.F.      ,.F.   })

	Endif


	If nTipo ==50 // RFN	Remito faturamento normal	Cliente	Faturamento

		if cEmpAnt=="01"

			AADD(aDetalles,{"F2_XPEBRU"  ,  .T.      ,.F.      ,.F.   })
			AADD(aDetalles,{"F2_XPETARA"  ,  .T.      ,.F.      ,.F.   })
			AADD(aDetalles,{"F2_XPENETO"  ,  .T.      ,.F.      ,.F.   })
			AADD(aDetalles,{"F2_XPLACA"    ,.T.      	,.F.      ,.F.   })
			AADD(aDetalles,{"F2_XRUTA"    ,.T.      	,.F.      ,.F.   })
			AADD(aDetalles,{"F2_XDEST"    ,.T.      	,.F.      ,.F.   })
			AADD(aDetalles,{"F2_XCONDUC"    ,.T.      	,.F.      ,.F.   })
			AADD(aDetalles,{"F2_XCODFOR"    ,.T.      	,.F.      ,.F.   })
			AADD(aDetalles,{"F2_XTIENDA"    ,.T.      	,.F.      ,.F.   })
		EndIF

		if cEmpAnt=="02"

			AADD(aDetalles,{"F2_XPEBRU"  ,  .T.      ,.F.      ,.F.   })
			AADD(aDetalles,{"F2_XPETARA"  ,  .T.      ,.F.      ,.F.   })
			AADD(aDetalles,{"F2_XPENETO"  ,  .T.      ,.F.      ,.F.   })
			AADD(aDetalles,{"F2_XPLACA"    ,.T.      	,.F.      ,.F.   })
			AADD(aDetalles,{"F2_XRUTA"    ,.T.      	,.F.      ,.F.   })
			AADD(aDetalles,{"F2_XDEST"    ,.T.      	,.F.      ,.F.   })
			AADD(aDetalles,{"F2_XCONDUC"    ,.T.      	,.F.      ,.F.   })
			AADD(aDetalles,{"F2_XCODFOR"    ,.T.      	,.F.      ,.F.   })
			AADD(aDetalles,{"F2_XTIENDA"    ,.T.      	,.F.      ,.F.   })
			AADD(aDetalles,{"F2_XMOTIVO"    ,.T.      	,.F.      ,.F.   })

		EndIF

	Endif


	If nTipo == 9 	// Nota de debito proveedor
		//   Detalles,      Campo       Usado  Obligatorio  Visual
		AADD(aDetalles,{"F1_XGLOSA" , .T.      ,.F.      ,.F.   })
	Endif

	If nTipo == 10   // Factura de entrada proveedor normal
		//   Detalles,      Campo       Usado  Obligatorio  Visual
		AADD(aDetalles,{"F1_XGLOSA"    ,.T.      	,.F.      ,.F.   })
		AADD(aDetalles,{"F1_FECAUT"    ,.T.      	,.F.      ,.F.   })
		AADD(aDetalles,{"F1_MOTIVO"    ,.T.      	,.F.      ,.F.   })
	Endif

	If nTipo == 1   // Factura de Venta
		//   Detalles,      Campo       Usado  Obligatorio  Visual
		AADD(aDetalles,{"F2_NUMORC"  ,.T.      	,.F.      ,.F.   })
		AADD(aDetalles,{"F2_XGLOSA"  ,.T.      	,.F.      ,.F.   })
		AADD(aDetalles,{"F2_XPLACA"  ,  .T.      ,.F.      ,.F.   })
		AADD(aDetalles,{"F2_XCONDUC"  ,  .T.      ,.F.      ,.F.   })
		if cEmpAnt=="03"
			AADD(aDetalles,{"F2_XEND"  ,.T.      	,.F.      ,.F.   })
		EndIF
	Endif

	If nTipo == 1 .or. nTipo ==50
		SX3->(MsSeek("F2_XOBSERV"))
		AAdd(aCposNF,{X3Titulo(),X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, "", X3_USADO, X3_TIPO, "SF2", X3_CONTEXT,,,,,, X3_F3,""})
		SX3->(MsSeek("F2_XNOTA"))
		AAdd(aCposNF,{X3Titulo(),X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, "", X3_USADO, X3_TIPO, "SF2", X3_CONTEXT,,,,,, X3_F3,""})
	EndIF

	If nTipo ==2  //   Nota de Debito Cliente
		//Detalles,      Campo       Usado  Obligatorio  Visual
		SX3->(MsSeek("F2_XNOTA"))
		AAdd(aCposNF,{X3Titulo(),X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, "", X3_USADO, X3_TIPO, "SF2", X3_CONTEXT,,,,,, X3_F3,""})
	EndIF

	IF CESPECIE='NCC'  // Nota de Credito de Cliente - NCC
		//   Detalles,      Campo   Usado  Obligatorio  Visual
		SX3->(MsSeek("F1_XNOTA"))
		AAdd(aCposNF,{X3Titulo(),X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, "", X3_USADO, X3_TIPO, "SF1", X3_CONTEXT,,,,,, X3_F3,""})
	Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ No cambiar dentro del Loop For...Next, llamar AC/Localizaciones ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nL := 1 To Len(aDetalles)
		If (nPosCpo := Ascan(aCposNF,{|x| x[2] == aDetalles[nL][1] })) > 0
			aCposNF[nPosCpo][13] := aDetalles[nL][3] 				   // Obligatorio
			If Len(aCposNF[nPosCpo]) == 16
				SX3->(DbSetOrder(2))
				SX3->(DbSeek(AllTrim(aDetalles[nL][1])))
				aCposNF[nPosCpo] := {X3Titulo(),X3_CAMPO,,,,,,,,,,,aDetalles[nL][3],,,,If(aDetalles[nL][4],".F.",".T.")}
			EndIf
			aCposNF[nPosCpo][17] := If(aDetalles[nL][4],".F.",".T.")   // Desabilita el campo
			If !aDetalles[nL][2]
				ADel(aCposNF,nPosCpo) 								   // Quita el campo
				ASize(aCposNF,Len(aCposNF)-1)                          // Ajusta Array
			EndIf
		Else
			DbSelectArea("SX3")
			DbSetOrder(2)
			If DbSeek( aDetalles[nL][1] )
				nNuevoElem := Len(aCposNF)+1
				aCposNF := aSize(aCposNF,nNuevoElem)
				aIns(aCposNF,nNuevoElem)
				aCposNF[nNuevoElem] := {X3Titulo(),X3_CAMPO,,,,,,,,,,,aDetalles[nL][3],,,,If(aDetalles[nL][4],".F.",".T.")}
			EndIf
		EndIf

	Next nL
	RestArea(aArea)

Return( aCposNF )
