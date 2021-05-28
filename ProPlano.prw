#INCLUDE 'FILEIO.CH' //Libreria causante de la generacion de archivos planos

Static Function ProPlano(cArcData)
    Local cRandom := ""
    Local nHandle
    cRandom := STRZERO(Random(1,1000),5,0) //STRZERO permite pasar de num a string con una cantidad estatica de espacios, param1 numero a cambiar, param2 cantidad de espacios, param3 en caso de decimales cuantos

    nHandle := FCREATE( "C:\Users\ACASTILLO\Documents\Protheus\"+cRandom+".TXT" ) //FCreate crea un archivo y toma como unico parametro una direccion
    If !FCLOSE(nHandle) //FClose tiene como dato devolver un booleano si se puede cerrar
        Conout( "Error al cerrar el archivo, Error numero: ", FERROR() ) //Muestra el resultado del archivo
    Endif
    nHandle := fOpen('C:\Users\ACASTILLO\Documents\Protheus\'+cRandom+'.TXT' , FO_READWRITE + FO_SHARED ) //Abre el archivo de acuerdo a una direccion, param2 se coloca para leer y escribir junto con la comparticion
    If nHandle == -1 //Devuelve un error en caso de haberlo
	    MsgStop('Error de abertura: Error ' + Str(fError(), 4), 'TOTVS' )
    Else
    
        FSeek(nHandle, 0, FS_END)			// Se posiciona al final del archivo
        FWrite(nHandle, cArcData)           // Envia datos al txt
    
        fclose(nHandle) // Cierra el archivo
        Alert("Archivo creado con exito")
    
    Endif
Return
