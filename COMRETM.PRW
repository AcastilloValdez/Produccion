/*
+----------------------------------------------------------------------------+
!                       FICHA TECNICA DEL PROGRAMA                           !
+----------------------------------------------------------------------------+
!DATOS DEL PROGRAMA                                                          !
+------------------+---------------------------------------------------------+
!Tipo              !  Comprobantes de Retencion                   !
+------------------+---------------------------------------------------------+
!Modulo            ! Facturacion                                                 !
+------------------+---------------------------------------------------------+
!Descripcion       ! Mantenimiento de Comprobantes de Retencion Manual             !
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
#include"Protheus.ch"
#Include"TOTVS.ch"
#Include "Rwmake.ch"
#Include "Topconn.ch"
/*
UPRGPTR Programa mantenimiento tabla ZFC
Uso NOBIS
Fecha : 23-06-2021
*/
User Function UCOMRETM()
	Private cCadastro 	:= "Comprobantes de Retencion Manual"
	Private aColor := {}
	Private aRotina 	:= MenuDef(@aColor)
	dbSelectArea("ZFC") /*ABRE UN ARCHIVO DE TRABAJO*/
	dbSetOrder(1) /*EN MI INDICE 1*/
	mBrowse(6,1,22,75,"ZFC", , , , , , aColor)
Return(nil)


Static Function MenuDef(aColor)
	Private aRotina     := {}
//	aAdd( aRotina, {"Busquedad" 	,'AxPesqui',0,1})
	aAdd( aRotina, {"Visualizar" 	,'AxVisual',0,2})
	aAdd( aRotina, {"Adicionar"       ,'AxInclui',0,3})
	aAdd( aRotina, {"Actualizar"      	,'AxAltera',0,4})
//aAdd( aRotina, {"Borrar"      	,'AxDeleta',0,5})
//leyenda de colores
Return(aRotina)
/*trigger de ejecucion para carga de estblecimiento*/
/*User Function ESTBL()
    Local cXFac := ALLTRIM(M->ZFC_XFAC) 
    Local cEstabl := "00"
    dbSelectArea("SF2") //ABRE UN ARCHIVO DE TRABAJO
	dbSetOrder(9) //EN MI INDICE 1//
    DBSeek(xFilial("SF2")+cXFac)
    If Found()
        cEstabl := SF2->F2_ESTABL
    EndIf
    
Return (cEstabl)
*/
/*User Function VALIZFC()
    Local cXFac := ALLTRIM(M->ZFC_XFAC) 
    dbSelectArea("ZFC") //ABRE UN ARCHIVO DE TRABAJO
	dbSetOrder(2) //EN MI INDICE 1
    DBSeek(xFilial("ZFC")+cXFac)
    If Found()
       MsgInfo("El número de documento "+cXFac+ " ya existe en el Sistema...","AVISO")
    EndIf
Return*/
