//Factura en la que solo se muestra los datos de la cabecera
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

Static cTitulo := "Composicion de factura"

User Function zModel2()
    Local aArea := GetArea()
    Local oBrowse

    //Instancia FWMBrowse con solo diccionario de datos
    oBrowse := FWMBrowse():New()

    //Se define el area "ZZ1 o ZZ3"
    oBrowse:SetAlias('ZZ2')

    //Definicion de titulo usando SetDescription
    oBrowse:SetDescription(cTitulo)

    //Activacion
    oBrowse:Activate()

    RestArea(aArea)

Return Nil

Static Function MenuDef()


    Local aRot := {}

    //Adicion de opciones
    //                                        'VIEWDEF.NombreDelArchivo
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.zModel2' OPERATION MODEL_OPERATION_VIEW      ACCESS 0
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.zModel2' OPERATION MODEL_OPERATION_INSERT    ACCESS 0
    ADD OPTION aRot TITLE 'Modificar'  ACTION 'VIEWDEF.zModel2' OPERATION MODEL_OPERATION_UPDATE    ACCESS 0
    ADD OPTION aRot TITLE 'Eliminar'   ACTION 'VIEWDEF.zModel2' OPERATION MODEL_OPERATION_DELETE    ACCESS 0

Return aRot

//Creacion de modelado de los datos
Static Function ModelDef()
    Local oStruZZ2 := FWFormStruct(1, 'ZZ2') //Cabecera de modelo
    Local oStruZZ3 := FWFormStruct(1, 'ZZ3') //Detalle de modelo
    Local oModel
    Local aZZ3Rel := {}
    Local aTrigger := {}

    //Para añadir dinamismo se coloca Trigger y se empieza a generar la estructura en FwStruTrigger
    //Param1 se coloca el campo que ejecutara el trigger
    //Param2 va el campo resultante de la operacion
    //Param3 va el metodo a ejecutar si es externo perteneciente a otro archivo se usa StaticCall
    aAdd(aTrigger, FwStruTrigger('ZZ2_STOTAL','ZZ2_IMP','StaticCall(zModel2M,fImp)',.F.,"",,,,))
    aAdd(aTrigger, FwStruTrigger('ZZ2_IMP','ZZ2_TOTAL','StaticCall(zModel2M,fTotal)',.F.,"",,,,))

    //Se agrega cada una de las estructura de trigger a la principal
    //Este apartado implementa todos los triggers que se genero automaticamente a la estructura
        For nActual := 1 To Len(aTrigger)
        oStruZZ2:AddTrigger(aTrigger[nActual][01],;
                            aTrigger[nActual][02],;
                            aTrigger[nActual][03],;
                            aTrigger[nActual][04])

    oModel := MPFormModel():New('zModel2M')
    oModel:AddFields('ZZ2MASTER',,oStruZZ2)
    oModel:AddGrid('ZZ3DETAIL','ZZ2MASTER',oStruZZ3)

    //Generando relaciones
    aAdd(aZZ3Rel, {'ZZ2_FILIAL', 'ZZ3_FILIAL'})
    aAdd(aZZ3Rel, {'ZZ2_FACTURA', 'ZZ3_FACTURA'})

    oModel:SetRelation('ZZ3DETAIL', aZZ3Rel,ZZ3->(IndexKey(1)))
    oModel:GetModel('ZZ3DETAIL'):SetUniqueLine({"ZZ3_IDPRO"}) //Definiendo como unico ingreso al ID
    
    //PrimaryKey no es necesario ya que la relacion se data antes
    oModel:SetPrimaryKey({})

    //Titulo general 
    oModel:SetDescription('Modelo de Factura')

    //Coloca titulo a los Modelos
    oModel:GetModel('ZZ2MASTER','Cabecera de Factura')
    oModel:GetModel('ZZ3DETAIL','Detalle de Factura')

    //Adicionando contadores
    oModel:AddCalc('TOTALES','ZZ1MASTER','ZZ2DETAIL','ZZ2_PEXT','XX_TOTAL','SUM',,,'SubToTal')

Return oModel

 //Creacion de la vista de los datos
 Static Function ViewDef()
    Local oView := Nil
    Local oModel := FWLoadModel('zModel2')
    Local oStPadre := FWFormStruct(2,'ZZ2')
    Local oStHijo := FWFormStruct(2,'ZZ3')

    //Creando la vista
    oView := FWFormView():New()
    oView:SetModel(oModel)

    //Creacion de componentes
    //Formularios AddField
    oView:AddField('VIEW_ZZ2',oStPadre,'ZZ2MASTER')
    //Grid AddGrid
    oView:AddGrid('VIEW_ZZ3',oStPadre,'ZZ3DETAIL')

    //Creacion de dimensiones
    oView:CreateHorizontalBox('SUPERIOR',30)
    oView:CreateHorizontalBox('INFERIOR',70)
    //Relacionando dimensiones con un modelo
    oView:SetOwnerView('VIEW_ZZ2','SUPERIOR')
    oView:SetOwnerView('VIEW_ZZ3','INFERIOR')
    //Habilitando titulos
    oView:EnableTitleView('VIEW_ZZ2','Cabecera de Factura')
    oView:EnableTitleView('VIEW_ZZ3','Detalle de Factura')

    //Obligacion de cierre de pantalla tras su confirmacion
    oView::SetCloseOnOK({||.T.})

    //Remover fields
    //oView:RemoveField('ZZ3_DESC')
    //oView:RemoveField('ZZ3_COD')
    Return oView

Static Function fImp()
    Local nSTotal := Val("ZZ2_STOTAL")
    Local nImp := 0.12
    Local nTImp := nSTotal * nImp
Return Str(nTImp)

Static Function fTotal()
    Local nSTotal := Val("ZZ2_STOTAL")
    Local nImp := Val("ZZ2_IMP")
    Local nTotal := nSTotal + nImp
Return Str(nTImp)
