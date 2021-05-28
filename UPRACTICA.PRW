#include"Protheus.ch"
/*
UPRGPTR Programa mantenimiento tabla ZZ1
Uso NOBIS
Fecha : 23-02-2021
*/
User Function UPRACTICA()
	Private cCadastro 	:= "Call Center - Mantenimiento."
	Private aColor := {}
	Private aRotina 	:= MenuDef(@aColor)
	dbSelectArea("ZZ1") /*ABRE UN ARCHIVO DE TRABAJO*/
	dbSetOrder(1) /*EN MI INDICE 1*/
	mBrowse(6,1,22,75,"ZZ1", , , , , , aColor)
Return(nil)


Static Function MenuDef(aColor)
	Private aRotina     := {}
	aAdd( aRotina, {"Búsqueda" 	,'AxPesqui',0,1})
	aAdd( aRotina, {"Visualizar" 	,'AxVisual',0,2})
	aAdd( aRotina, {"Adicionar"       ,'AxInclui',0,3})
	aAdd( aRotina, {"Actualizar"      	,'AxAltera',0,4})
//aAdd( aRotina, {"Borrar"      	,'AxDeleta',0,5})
	aAdd( aRotina, {"Otro"      	,'U_UFUNC1',0,8})
	aAdd( aRotina, {"Prodcutos"      	,'MATA010',0,8})
//leyenda de colores
	aadd(aColor,{"ZZ1_ESTADO == '1' ","BR_AZUL"})
	aadd(aColor,{"ZZ1_ESTADO == '2' ","BR_VERDE"})
Return(aRotina)


User Function UFUNC1()
	Aviso("Titulo","Aqui va un programa adicional desarrrolado")
return
