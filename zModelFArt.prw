#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Static cTitulo := "Familia y Grupos de Articulo"

User Function zModelFArt()

    Local aCoors := FWGetDialogSize(oMainWnd)

    Local oPanelUp, oFWLayer, oPanelDown, oBrowseUp, oBrowseDown, oRelacZ12

    Private oDlgPrinc

    Define MsDialog oDlgPrinc Title 'Familia y Grupos de Artículo' From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel

    oFWLayer := FWLayer():New()
    oFWLayer:Init( oDlgPrinc, .F., .T. )

    oFWLayer:AddLine( 'UP', 50, .F. )
    oFWLayer:AddCollumn( 'ALL', 100, .T., 'UP' )
    oPanelUp := oFWLayer:GetColPanel( 'ALL', 'UP' )

    oFWLayer:AddLine( 'DOWN', 50, .F. )
    oFWLayer:AddCollumn( 'ALL' , 100, .T., 'DOWN' )
    oPanelDown :=  oFWLayer:GetColPanel( 'ALL' , 'DOWN' )

    oBrowseUp := FWMBrowse():New()
    oBrowseUp:SetOwner(oPanelUp)
    oBrowseUp:SetDescription('Familia de Artículos')
    oBrowseUp:SetAlias('Z11')
    oBrowseUp:SetOnlyFields({'Z11_IDFAM', 'Z11_ITDESC'})
    oBrowseUp:AddLegend( "Z11_IDEST=='1'", "GREEN", "Activo" )
    oBrowseUp:AddLegend( "Z11_IDEST=='2'", "RED", "Inactivo" )
    oBrowseUp:DisableDetails()
    oBrowseUp:DisableReport()
    oBrowseUp:SetMenuDef('zModelFArt')

    oBrowseUp:SetProfileID( '1' )
    oBrowseUp:ForceQuitButton()
    oBrowseUp:Activate()

    oBrowseDown:= FWMBrowse():New()
    oBrowseDown:SetOwner( oPanelDown )
    oBrowseDown:SetDescription( 'Grupo de Artículos' )
    oBrowseDown:SetMenuDef( 'Z12' )
    oBrowseDown:SetAlias( 'Z12' )
    oBrowseDown:SetOnlyFields({'Z12_IDGRUP', 'Z12_GRUDES'})
    oBrowseDown:AddLegend( "Z12_IDEST=='1'", "GREEN", "Activo" )
    oBrowseDown:AddLegend( "Z12_IDEST=='2'", "RED", "Inactivo" )
    oBrowseDown:DisableDetails()
    oBrowseDown:DisableReport()
    oBrowseDown:DisableFilter()
    oBrowseDown:SetProfileID('2')
    oBrowseDown:Activate()

    oRelacZ12:= FWBrwRelation():New()
    oRelacZ12:AddRelation( oBrowseUp , oBrowseDown , {{ 'Z12_IDFAM' , 'Z11_IDFAM' }})
    oRelacZ12:Activate()

    Activate MsDialog oDlgPrinc Center

Return NIL
//10.120.0.61:1201

Static Function MenuDef()
    Local aRot := {}
    //ADD OPTION aRot TITLE 'Visualizar'          ACTION 'VIEWDEF.zModelFArt' OPERATION 2     ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE 'Nueva Familia'       ACTION 'VIEWDEF.zModelFArt' OPERATION 3     ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Modificar'           ACTION 'VIEWDEF.zModelFArt' OPERATION 4     ACCESS 0 //OPERATION 4
	ADD OPTION aRot TITLE 'Eliminar'            ACTION 'VIEWDEF.zModelFArt' OPERATION 5     ACCESS 0 //OPERATION 5
	ADD OPTION aRot TITLE 'Nuevo Grupo'         ACTION 'u_vGrpArt'          OPERATION 8     ACCESS 0 //OPERATION 5
	//ADD OPTION aRot TITLE 'Inserción Masiva de Familias'    ACTION 'u_fIMF'          OPERATION 8     ACCESS 0 //OPERATION 5
	//ADD OPTION aRot TITLE 'Inserción Masiva de Grupos'    ACTION 'u_fIMG'          OPERATION 8     ACCESS 0 //OPERATION 5
Return aRot

Static Function ModelDef()
    Local oStrZ11 := FWFormStruct(1,'Z11')
    Local oStrZ12 := FWFormStruct(1,'Z12')
    Local oModel
    Local aRel := {}

    //Variables para metodo
    Local cIDModel := "zModelM"
    Local cDesModel := "Modelo Familia de Articulo"
    Local cDesM1 := "Familia de Articulo"
    Local cDesM2 := "Grupo de Articulo"
    Private cIDMaster := "Z11MASTER"
    Private cIDDetail := "Z12DETAIL"
    Private cDic1 := 'Z11'

    //Relaciones
    AAdd(aRel,{"Z12_FILIAL","xFilial('Z12')"})
    AAdd(aRel,{"Z12_IDFAM","Z11_IDFAM"})
    
    //Propiedades del model
    oStrZ11:SetProperty('Z11_IDFAM', MODEL_FIELD_NOUPD, .T.)
    oStrZ12:SetProperty('Z12_IDGRUP', MODEL_FIELD_NOUPD, .T.)

    oModel := f_MPlanR2(cIDModel, oStrZ11, oStrZ12, cIDMaster, cIDDetail, aRel, cDesModel, cDesM1, cDesM2)

    //Personalizaciones del Model
    oModel:GetModel(cIDDetail):SetUniqueLine({'Z12_IDGRUP'})

Return oModel

Static Function ViewDef()
    Local oView
    Local oModel := FWLoadModel('zModelFArt')
    Local oStPadre := FWFormStruct(2,'Z11')
    Local oStHijo := FWFormStruct(2,'Z12')

    //Variables para la vista
    Local nSup := 40
    Local nInf := 60
    Local cIDView1 :=  "VIEW_Z11"
    Local cIDView2 := "VIEW_Z12"
    Local cV1Title := "Item Familia de Articulo"
    Local cV2Title := "Items Grupo de Articulo"
    Private cIDMaster := "Z11MASTER"
    Private cIDDetail := "Z12DETAIL"

    //Personalizaciones
    oStHijo:RemoveField('Z12_IDFAM')
    
    oView := f_VPlanR2(oModel, oStPadre, oStHijo, cIDView1, cIDView2, cIDMaster, cIDDetail, nSup, nInf, cV1Title, cV2Title)
    
Return oView


Static Function f_MPlanR2(cIDModel, oStrZ11, oStrZ12, cIDMaster, cIDDetail, aRel, cDesModel, cDesM1, cDesM2)
    Local oModel

    oModel := MPFormModel():New(cIDModel)
    oModel:AddFields(cIDMaster,,oStrZ11)
    oModel:AddGrid(cIDDetail, cIDMaster,oStrZ12)

    oModel:SetRelation(cIDDetail,aRel, Z12->(IndexKey(1))) //Z12
    
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
