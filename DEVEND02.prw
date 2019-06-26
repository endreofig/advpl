#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} DEVEND02
	@description Funcao para consulta de Cep via webservice 
	@type User Function DEVEND02
	@author Endreo Figueiredo
	@since 26/06/2019
	@param param, param_type, param_descr
	@return Use um pouco de sua criatividade
	@see Executar Função passando cep como parametro DEVEND02("78098-550")
/*/

User Function DEVEND02(p_cCep)
	
	Private oJson 		  := JsonObject():New()
	Private lRet		  := ENDVLCEP(p_cCep)
	oJson['URLCONSULTA']  	  := "https://viacep.com.br/ws/"+lRet[2]+"/json/"

	IF lRet[1]
	 	oJson:fromJSON(HTTPGET(oJson['URLCONSULTA'])) 
			If !Empty(oJson:GetJsonText("erro"))
				MsgAlert("CEP Inexistente")
			Else
				MsgAlert(DecodeUTF8("Rua : "+oJson['logradouro']+" em "+oJson['localidade']))
			EndIf
	Else 
		MsgInfo("CPF Incorreto")
	EndIf
		
	FreeObj(oJson)	

Return

/*/{Protheus.doc} ENDVLCEP
	(Verifica se CEP tem quantidade caracteres correta e remove ifem)
	@type  Static Function
	@author Endreo Figueiredo	
	@since 26/06/2019
	@version 2.0
	@param param, param_type, param_descr
	@return return, return_type, return_description
/*/

Static Function ENDVLCEP(p_cCep)
	Local lRet 	:= {.F., ""}
	oJson['CEPINFORMADO'] 	  := Alltrim(p_cCep)
	oJson['CONTEMIFEM'] 	  := At("-",p_cCep,)
	oJson['NUMEROCARACTERES'] := Len(StrTran(AllTrim(p_cCep),"-"))

	If  Empty(oJson['CEPINFORMADO']) .And. ( oJson['NUMEROCARACTERES'] < 8 )
		
		MsgAlert("Verifique o CEP informado","<b>Informativo !</b>")

	ElseIf ( oJson['CONTEMIFEM'] == 6 .AND. oJson['NUMEROCARACTERES'] == 8 ) .OR. ( oJson['CONTEMIFEM'] == 0 .AND. oJson['NUMEROCARACTERES'] == 8 )
		
		lRet[1] := .T.
		lRet[2] := StrTran(AllTrim(p_cCep),"-")
	
	Endif

Return ( lRet )

