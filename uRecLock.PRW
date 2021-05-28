//Bibliotecas
#Include "Protheus.ch"

/*/
Exemplo de gravação de dados via RecLock
/*/

User Function uRECLOCK()
	Local aArea := GetArea()/*Esta función se utiliza para proteger y 
    preservar el entorno activo cuando hay necesidad de algún procesamiento específico.
     Para grabar otra área de trabajo (alias), que no sea la activa, la función GetArea()
    debe ejecutarse dentro del alias. Por ejemplo: SA1->(GetArea()).
*/
	DbSelectArea('ZA1')
	ZA1->(DbSetOrder(1)) //indice ZA1_FILIAL + ZA1_COD POSICIONA COMO ESTA EN EL CFG
	ZA1->(DbGoTop()) //Mueve el cursor del área de trabajo activa al primer registro 
    //lógico del archivo de datos. Por lo tanto, el archivo de datos se ubica al inicio
	
	Begin Transaction
		MsgInfo("Antes del Cambio", "Atencion de Informacion")
		//Busca el codigo de la tabla ZA1 ZA1_COD='001'
		If ZA1->(DbSeek(FWxFilial('ZA1') + '001'))
			//Cuando paso .F. en RecLock, el registro está bloqueado para cambiar
			RecLock('ZA1', .F.)
				ZA1_DIREC := "XXX"
				ZA1_EMP := ZA1->ZA1_EMP + "."
			ZA1->(MsUnlock())
		EndIf	
		//Cuando paso .T. en RecLock, el registro está bloqueado para inclusión
		RecLock('ZA1', .T.)
			ZA1_FILIAL := FWxFilial('ZA1')
		ZA1->(MsUnlock())
		MsgInfo("Adios del Cambio!", "Atencion")
		//Al desarmar la transacción, se cancela toda manipulación de datos
		DisarmTransaction()
	End Transaction
	//Busca el codigo de la tabla ZA1 ZA1_COD='001'
	If ZA1->(DbSeek(FWxFilial('ZA1') + '001'))
		//Cuando hago el cambio fuera de una transacción, los datos se guardan automáticamente
		RecLock('ZA1', .F.)
			ZA1_EMP := Alltrim(ZA1->ZA1_EMP) + ";:"
		ZA1->(MsUnlock())
	EndIf
	RestArea(aArea)/*  // Regresa al entorno anterior*/
Return
