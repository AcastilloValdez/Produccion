/* ===
    Esse é um exemplo disponibilizado no Terminal de Informação
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2016/09/29/vd-advpl-022/
    Caso queira ver outros conteúdos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include 'Protheus.ch'
#Include 'FwMVCDef.ch'


User Function zMkMVC()
	Private oMark
	//Criando o MarkBrow
	oMark := FWMarkBrowse():New()
    //ejecuto el sql para obterner los datos
  
	oMark:SetAlias('SA1')
	
	//Setando semáforo, descrição e campo de mark
	oMark:SetSemaphore(.T.)
	oMark:SetDescription('Seleção do Cadastro de Artistas')
	oMark:SetFieldMark('A1_RESFAT') 
	
	//Setando Legenda
	//oMark:AddLegend( "ZZ1->ZZ1_COD <= '000005'", "GREEN",	"Menor ou igual a 5" )
	//oMark:AddLegend( "ZZ1->ZZ1_COD >  '000005'", "RED",	"Maior que 5" )
	
	//Ativando a janela
	oMark:Activate()
Return NIL

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Criação do menu MVC                                          |
 *---------------------------------------------------------------------*/
 
Static Function MenuDef()
	Local aRotina := {}
	
	//Criação das opções
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.zModel1' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.zModel1' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Processar'  ACTION 'u_zMarkProc'     OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Legenda'    ACTION 'u_zMod1Leg'      OPERATION 2 ACCESS 0
Return aRotina

/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Criação do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/
 
Static Function ModelDef()
Return FWLoadModel('zModel1')

/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Criação da visão MVC                                         |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()
Return FWLoadView('zModel1')

User Function zMarkProc()
	Local aArea    := GetArea()
	Local cMarca   := oMark:Mark()
	Local lInverte := oMark:IsInvert()
	Local nCt      := 0
	
	//Percorrendo os registros da ZZ1
	SA1->(DbGoTop())
	While !SA1->(EoF())
		//Caso esteja marcado, aumenta o contador
		If oMark:IsMark(cMarca)
			nCt++
			
			//Limpando a marca
			RecLock('SA1', .F.)
				A1_RESFAT := ''
			SA1->(MsUnlock())
		EndIf
		
		//Pulando registro
		SA1->(DbSkip())
	EndDo
	
	//Mostrando a mensagem de registros marcados
	MsgInfo('Foram marcados <b>' + cValToChar( nCt ) + ' artistas</b>.', "Atenção")
	
	//Restaurando área armazenada
	RestArea(aArea)
Return NIL
