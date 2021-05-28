#include"Protheus.ch"
/*
UPRGPTR Programa mantenimiento tabla ZZ1
Uso NOBIS
Fecha : 23-02-2021
*/
User Function CAPACI ()
Private cCadastro 	:= "Maestro de Rutina OTROS."
Private aColor := {}
Private aRotina 	:= MenuDef(@aColor)
dbSelectArea("ZZ1")
dbSetOrder(1)
mBrowse(6,1,22,75,"ZZ1", , , , , , aColor)
Return(nil)


Static Function MenuDef(aColor)
Private aRotina     := {}
aAdd( aRotina, {"Buscar" 	,'AxPesqui',0,1})
aAdd( aRotina, {"Visualizar" 	,'AxVisual',0,2})
aAdd( aRotina, {"Incluir"       ,'AxInclui',0,3})
aAdd( aRotina, {"Modificar"      	,'AxAltera',0,4})
//aAdd( aRotina, {"Borrar"      	,'AxDeleta',0,5})
aAdd( aRotina, {"BeginSQL"      	,'u_uOtrSQL',0,8})
aAdd( aRotina, {"TCQuery"      	,'u_uQuery',0,8}) 
aAdd( aRotina, {"ADVPL Datos"      	,'u_uBanco',0,8}) 
aAdd( aRotina, {"MSEXcecAuto"      	,'u_uExecAuto',0,8}) 
aAdd( aRotina, {"ReckLock"      	,'u_uRECLOCK',0,8}) 
aAdd( aRotina, {"Saldo Ini"      	,'u_uGenSB9',0,8}) 
aAdd( aRotina, {"Sudoku"      	,'u_sudoku',0,8}) 
aAdd( aRotina, {"pantalla"      	,'U_UTESTE01',0,8}) 
aAdd( aRotina, {"importa"      	,'u_uImpCsv',0,8}) 
aAdd( aRotina, {"Barra Prog"      	,'u_zTstBar',0,8}) 
//zMVCMdX
aAdd( aRotina, {"__MVC1"      	,'u_uMVC1',0,8}) 
aAdd( aRotina, {"xx MVC2"       	,'u_zMVCMd1',0,8}) 
aAdd( aRotina, {"vv  MVC3"      	,'u_umvtest3',0,8}) 
aAdd( aRotina, {"dd  MVCX"      	,'u_uXmvtes',0,8}) 
aAdd( aRotina, {"Grid1 2"      	,'u_zGrid3',0,8}) 
//

aAdd( aRotina, {"busca "      	,'u_zSearch',0,8}) 
aAdd( aRotina, {"Graficos"      	,'u_uChart',0,8}) 
aAdd( aRotina, {"_VALDEZ_"      	,'u_uNobisF',0,8}) 
aAdd( aRotina, {"Posicione"      	,'U_uIndPos',0,8}) 
aAdd( aRotina, {"Graficos II"      	,'u_tstFactory',0,8}) 
aAdd( aRotina, {"Ventana"      	,'u_Umsdlg',0,8}) 
aAdd( aRotina, {"Prodcutos"      	,'MATA010',0,8}) 
//leyenda de colores
aadd(aColor,{"ZZ1_ESTADO == '1' ","BR_PRETO"})
aadd(aColor,{"ZZ1_ESTADO == '2' ","BR_VERDE"})
Return(aRotina)


User Function UCAPA2()
Aviso("Titulo","Aqui va un programa adicional desarrrolado")
return 
