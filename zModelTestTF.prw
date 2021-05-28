#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Static cTitulo := "Familia y Grupos de Articulo"

User Function zModelTestTF()
    Local aCoors := FWGetDialogSize(oMainWnd) //Genera una pantalla de dialogo para personalizacion

    Local oPanelUp, oFWLayer, oPanelDown, oBrowseUp, oBrowseDown, oRelacZ12 //

    Private oDlgPrinc

    //Se define un plano a plasmar como el que se realiza cuando se utiliza la herramienta gaia para dise�ar
    Define MsDialog oDlgPrinc Title 'Cabecera y Detalle Teste' From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel

    oFWLayer := FWLayer():New() //Instancia una interfaz a la que se la personalizara
    oFWLayer:Init( oDlgPrinc, .F., .T. ) //Se inicia con el plano dado 

    oFWLayer:AddLine( 'UP', 50, .F. )//Se crea una linea que partira en 2, param1 identificador, param2 porcentaje de tama�o de pantalla
    oFWLayer:AddCollumn( 'ALL', 100, .T., 'UP' )//Se a�ade una columna dentro de la division que se genero, param1 identificador, param 2 porcentaje, param4 identificador que hace referencia la columna
    oPanelUp := oFWLayer:GetColPanel( 'ALL', 'UP' )//Se coloca en el panel la estructura con la que se generar�

    //Se aplica las mismas caracteristicas solo que aplicada al otro 50% restante de la parte de abajo
    oFWLayer:AddLine( 'DOWN', 50, .F. )
    oFWLayer:AddCollumn( 'ALL' , 100, .T., 'DOWN' )
    oPanelDown :=  oFWLayer:GetColPanel( 'ALL' , 'DOWN' )

    //Existen 2 Browse el primero es identificado para pertenecer en la parte superior y el segundo a la inferior
    oBrowseUp := FWMBrowse():New()//Se instancia el Browse perteneciente a totvs
    oBrowseUp:SetOwner(oPanelUp)//Se manda por parametros el panel en el que ya se encuentra plasmando
    oBrowseUp:SetDescription('Cabecera')//Se asigna un titulo que se mostrara en la pantalla
    oBrowseUp:SetAlias('Z98')//Se coloca el diccionario de datos que pertenecera dicha pantall
    oBrowseUp:SetOnlyFields({'Z98_COD', 'Z98_ENTE', 'Z98_MTOTAL'})//Coloca los campos que solo se mostraran en la vista o grid
    //oBrowseUp:AddLegend( "Z11_IDEST=='1'", "GREEN", "Activo" ) //Se a�ade una leyenda en caso de haber un campo que se necesite referenciar
    //oBrowseUp:AddLegend( "Z11_IDEST=='2'", "RED", "Inactivo" )
    oBrowseUp:DisableDetails()//Quita los detalles de los datos en las vistas
    oBrowseUp:DisableReport()//Deshabilita en el combo de "Otras acciones" la parte de generar reportes
    oBrowseUp:SetMenuDef('zModelTestTF')//El menu se aplica de acuerdo a la interfaz perteneciente a la funci�n

    oBrowseUp:SetProfileID( '1' )//Genera un ID que pertenece al orde de la pantalla
    oBrowseUp:ForceQuitButton()
    oBrowseUp:Activate()//Activa la interfaz

    oBrowseDown:= FWMBrowse():New()
    oBrowseDown:SetOwner( oPanelDown )
    oBrowseDown:SetDescription( 'Detalle de pagos' )
    oBrowseDown:SetMenuDef( 'Z99' )
    oBrowseDown:SetAlias( 'Z99' )
    oBrowseDown:SetOnlyFields({'Z99_CCTA', 'Z99_DCTA', 'Z99_PRECIO'})
    //oBrowseDown:AddLegend( "Z12_IDEST=='1'", "GREEN", "Activo" )
    //oBrowseDown:AddLegend( "Z12_IDEST=='2'", "RED", "Inactivo" )
    oBrowseDown:DisableDetails()
    oBrowseDown:DisableReport()
    oBrowseDown:DisableFilter()
    oBrowseDown:SetProfileID('2')
    oBrowseDown:Activate()

    oRelacZ12:= FWBrwRelation():New() //Se genera la relacion que existe entre cabecera y detalle en la vista para que exista dinamismo
    oRelacZ12:AddRelation( oBrowseUp , oBrowseDown , {{ 'Z99_CODC' , 'Z98_COD' }})//Se estable la relacion en las pantallas y en el param3 los campos que pertenecen a la relacion
    oRelacZ12:Activate()//Activa la relacion

    Activate MsDialog oDlgPrinc Center//Muestra el dise�o en la pantalla

Return NIL


Static Function MenuDef()
    Local aRot := {}
    //ADD OPTION aRot TITLE 'Visualizar'          ACTION 'VIEWDEF.zModelFArt' OPERATION 2     ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE 'Nueva Prueba'        ACTION 'VIEWDEF.zModelTestTF'   OPERATION 3     ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Modificar'           ACTION 'VIEWDEF.zModelTestTF'   OPERATION 4     ACCESS 0 //OPERATION 4
	ADD OPTION aRot TITLE 'Eliminar'            ACTION 'VIEWDEF.zModelTestTF'   OPERATION 5     ACCESS 0 //OPERATION 5
	//ADD OPTION aRot TITLE 'Testeo'              ACTION 'u_TestNPC'             OPERATION 8     ACCESS 0 //OPERATION 8
	//ADD OPTION aRot TITLE 'Nuevo Grupo'         ACTION 'u_vGrpArt'          OPERATION 8     ACCESS 0 //OPERATION 8
	//ADD OPTION aRot TITLE 'Inserci�n Masiva de Familias'    ACTION 'u_fIMF'          OPERATION 8     ACCESS 0 //OPERATION 8
	//ADD OPTION aRot TITLE 'Inserci�n Masiva de Grupos'    ACTION 'u_fIMG'          OPERATION 8     ACCESS 0 //OPERATION 8
Return aRot

Static Function ModelDef()
    Local oStrZ98 := FWFormStruct(1,'Z98')//Genera una estructura en la que se define cada una en diferentes parametros
    Local oStrZ99 := FWFormStruct(1,'Z99')
    Local oModel
    Local aRel := {}

    //Variables para metodo
    Local cIDModel := "zModelM"
    Local cDesModel := "Modelo Familia de Articulo"
    Local cDesM1 := "Cabecera"
    Local cDesM2 := "Detalle"
    Private cIDMaster := "Z98MASTER"
    Private cIDDetail := "Z99DETAIL"
    Private cDic1 := 'Z98'

    //Relaciones
    AAdd(aRel,{"Z99_FILIAL","xFilial('Z99')"})
    AAdd(aRel,{"Z99_CODC","Z98_COD"})
    
    //Propiedades del model
    //oStrZ11:SetProperty('Z_IDFAM', MODEL_FIELD_NOUPD, .T.)
    //oStrZ12:SetProperty('Z12_IDGRUP', MODEL_FIELD_NOUPD, .T.)

    //La funcion f_MPlanR2 es una funcion la cual solo recibe parametros para su correcto funcionamiento
    oModel := f_MPlanR2(cIDModel, oStrZ98, oStrZ99, cIDMaster, cIDDetail, aRel, cDesModel, cDesM1, cDesM2)
    //Personalizaciones del Model
    oModel:GetModel(cIDDetail):SetUniqueLine({'Z99_CCTA'})
    
Return oModel

Static Function ViewDef()
    Local oView
    Local oModel := FWLoadModel('zModelTestTF')//Carga de modelo 
    Local oStPadre := FWFormStruct(2,'Z98')//Abre una nueva estructura para la Vista que es 2 como parametro
    Local oStHijo := FWFormStruct(2,'Z99')

    //Testeo
    //oStHijo:AddField()
    //Variables para la vista
    Local nSup := 40
    Local nInf := 60
    Local cIDView1 :=  "VIEW_Z98"
    Local cIDView2 := "VIEW_Z99"
    Local cV1Title := "Cabecera"
    Local cV2Title := "Detalle"
    Private cIDMaster := "Z98MASTER"
    Private cIDDetail := "Z99DETAIL"

    //Personalizaciones
    //Remueve el campo para que no se ingrese ya que por la relacion se colocara automaticamente
    oStHijo:RemoveField('Z99_CODC')
    
    oView := f_VPlanR2(oModel, oStPadre, oStHijo, cIDView1, cIDView2, cIDMaster, cIDDetail, nSup, nInf, cV1Title, cV2Title)
    
Return oView


Static Function f_MPlanR2(cIDModel, oStrZ98, oStrZ99, cIDMaster, cIDDetail, aRel, cDesModel, cDesM1, cDesM2)
    Local oModel
    Local bVldPos := {|| u_zM1bPos()}

    oModel := MPFormModel():New(cIDModel,,bVldPos,,)
    oModel:AddFields(cIDMaster,,oStrZ98)
    oModel:AddGrid(cIDDetail, cIDMaster,oStrZ99)

    oModel:SetRelation(cIDDetail,aRel, Z99->(IndexKey(1))) //Z99
    
    oModel:SetPrimaryKey({})

    oModel:SetDescription(cDesModel)
    
    oModel:GetModel(cIDMaster):SetDescription(cDesM1)
    oModel:GetModel(cIDDetail):SetDescription(cDesM2)
Return oModel

Static Function f_VPlanR2(oModel, oStPadre, oStHijo, cIDView1, cIDView2, cIDMaster, cIDDetail, nSup, nInf, cV1Title, cV2Title)
    Local oView
    oView := FWFormView():New()
    oView:SetModel(oModel)

    oView:AddField(cIDView1, oStPadre, cIDMaster)
    oView:AddGrid(cIDView2, oStHijo, cIDDetail)

    oView:CreateHorizontalBox('SUPERIOR',nSup)
    oView:CreateHorizontalBox('INFERIOR',nInf)

    oView:SetOwnerView(cIDView1, 'SUPERIOR')
    oView:SetOwnerView(cIDView2, 'INFERIOR')

    oView:EnableTitleView(cIDView1, cV1Title)
    oView:EnableTitleView(cIDView2, cV2Title)

    oView:SetCloseOnOk({||.T.})
Return oView

User Function zM1bPos()
	Local oModelPad  := FWModelActive()
    Local cArcData    := ""
    Local oGrid      := oModelPad:GetModel('Z99DETAIL')//Abstrae el modelo segun el identificador
    Local nX

    //Carga da parametros para enviarlo por StaticCall a un archivo plano
    //Rtrim quita los espacios de la derecha
    //oModelPad Abstrae el modelo actual para andar en los datos
        //GetValue = Trae datos segun su campo y el identificador en el cual se encuentra
	Local cParams    := "Cod: "+Rtrim(oModelPad:GetValue('Z98MASTER', 'Z98_COD'))
    cParams += " Ente: "+Rtrim(oModelPad:GetValue('Z98MASTER', 'Z98_ENTE'))
    cParams += " Usuario: "+Rtrim(oModelPad:GetValue('Z98MASTER', 'Z98_USR'))
    cParams += " PC: "+Rtrim(oModelPad:GetValue('Z98MASTER', 'Z98_PC'))
    cParams += " TOTAL: "+Rtrim(STRZERO(oModelPad:GetValue('Z98MASTER', 'Z98_MTOTAL'),10,0))

    //Funcion que sirve para llamar a metodos estaticos junto con parametros
    StaticCall(LogProceso,LogProceso,cParams,"Mant. Tester")
/*
    cArcData := "VE|COMPROBANTE|07|1.0.0|"+Chr(13) + Chr(10)+;
                "IC|"+Rtrim(oModelPad:GetValue('Z98MASTER', 'Z98_COD'))+"|"+;
                trim(oModelPad:GetValue('Z98MASTER', 'Z98_ENTE'))+"|"+;
                Rtrim(oModelPad:GetValue('Z98MASTER', 'Z98_USR'))+"|"+;
                Rtrim(oModelPad:GetValue('Z98MASTER', 'Z98_PC'))+"|"+Chr(13) + Chr(10)+;
                "T|"+Rtrim(STRZERO(oModelPad:GetValue('Z98MASTER', 'Z98_MTOTAL'),10,0))+"|"+Chr(13) + Chr(10)
  */
    //Concatenacion de los registros que se encuentran en el grid
    /*For nX := 1 To oGrid:GetQtdLine()
        oGrid:GoLine(nX)
        cArcData += "TIR|"+Rtrim(oGrid:GetValue('Z99_CCTA'))+"|"+;
                    Rtrim(oGrid:GetValue('Z99_DCTA'))+"|"+;
                    Rtrim(STRZERO(oGrid:GetValue('Z99_PRECIO'),10,0))+"|"+Chr(13) + Chr(10)
    Next
*/
    For nX := 1 To oGrid:GetQtdLine()
        oGrid:GoLine(nX)
        cArcData += Rtrim(oGrid:GetValue('Z99_CCTA'))+SPACE(20)+;
                    Rtrim(oGrid:GetValue('Z99_DCTA'))+SPACE(20)+;
                    Rtrim(STRZERO(oGrid:GetValue('Z99_PRECIO'),13,0))+""+Chr(10)
    Next
    StaticCall(ProPlano,ProPlano,cArcData)
Return .T.
