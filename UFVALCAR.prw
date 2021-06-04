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
