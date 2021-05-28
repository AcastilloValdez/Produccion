Static Function LogProceso(Parametros, Proceso) //Creacion de funcion estatica para su llamado
    Local cBan := ""
    Local nStatus := 0
    Do Case //Altera, Inclui y Exclui son variables booleanas globales que sirven para identificar que accion se realiza
        Case Altera
            cBan := "MOD"
        Case Inclui
            cBan := "ADD"
        Case Exclui
            cBan := "DEL"
    EndCase
    
    //Existen 2 maneras de ejecutar un query: 1 Usando el diccionario y RecLock. 2 Usando TCSqlExec que permite la ejecucion de query


    /*RecLock('Z00', .T.) //RecLock permite abrir la tabla, param1 va el diccionario, param2 recibira .T. para nuevo registro y .F. cuando se edita 
        Z00_EMP := FWCodEmp()
        Z00_SUC := FWFilial()
        Z00_FECPRO := Date()
        Z00_USERDB := cUserName
        Z00_USERNT := cUserName
        Z00_ANAME := cModulo
        Z00_HNAME := GetComputerName()
        Z00_PROCES := Proceso
        Z00_PARAM := Parametros
        Z00_TPROC := cBan
        Z00_FORMA := FunName()
    Z00->(MsUnlock())*/ //MsUnlock desbloque y permite el flujo y envio de la data
    
    
    TCLink() //Abre la conexion para usar TCSqlExec para ejecutar un query
    nStatus := TCSqlExec("INSERT INTO Z00010 (Z00_FECPRO, Z00_USERDB, Z00_USERNT, Z00_ANAME, Z00_HNAME, Z00_PROCES, Z00_PARAM, Z00_TPROC, Z00_FORMA, Z00_EMP, Z00_SUC, r_e_c_n_o_) VALUES ('"+DTOS(Date())+"','"+cUserName+"','"+cUserName+"','"+cModulo+"','"+GetComputerName()+"','"+Proceso+"','"+Parametros+"','"+cBan+"','"+FunName()+"','"+FWCodEmp()+"','"+FWFilial()+"',(SELECT MAX(R_E_C_N_O_)+1 FROM Z00010))")
    //El metodo retorna un estado -1 para un error dado durante la ejecucion y 1 para un error
    If nStatus < 0 
        Alert( "TCSQLError() " + TCSQLError())//TCSQLError abstrae el error permitiendo 
    Else
        Alert("Log Registrado") //Mostrar mensaje para en caso que funcione bien
    Endif

    TCUnlink()//Desconecta la instancia dada
Return
 