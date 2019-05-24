#INCLUDE "TOTVS.CH"

#IFNDEF CRLF
	#DEFINE CRLF ( chr(13)+chr(10) )
#ENDIF	

/*/{Protheus.doc}
@description Funcao para consulta de Cep via webservice 
@type User Function DEVEND02
@author Endreo Figueiredo
@since 23/05/2019
@version 12.1.17
@param param, param_type, param_descr
@return Use um pouco de sua criatividade
@see Executar Função passando cep como parametro DEVEND02("78098-550")
/*/

User Function DEVEND02(p_cCep)
	Local oJson 		:= tJsonParser():New()
	Local cCep 			:= p_cCep
	Local cURL			:= "https://viacep.com.br/ws/"
	Local lenStrJson 	:= 0
	Local strJson		:= ''
	Local jsonfields 	:= {}
  	Local nRetParser 	:= 0
	Local lRet			:= .F.

	Local cRua 		:= ""
	Local cComple 	:= ""
	Local cBairro 	:= ""
	Local cCidade 	:= ""
	Local cUf 		:= ""
	Local cUnidad 	:= ""
	Local cCep2		:= ""
	Local cIbge		:= ""

	If ( ENDVLCEP(cCep) )

		cCep := StrTran(AllTrim(cCep),"-")+"/json/"

		MsgRun( "Aguarde..." , "Consultando CEP" , { || strJson := HTTPGET( cURL+cCep ) } )

		lenStrJson := Len(strJson)
		jsonfields := {}
		lRet := oJson:Json_Parser(strJson, lenStrJson, @jsonfields, @nRetParser)

			If ( !FWJsonDeserialize(strJson, @oJson) )

				MsgStop("Descupe houve um erro ao recuperar dados")

			ElseIf AttIsMemberOf(oJson,"ERRO")

				MsgStop("CEP inexistente na base de dados.")	
				
			Else
				//Somente exemplo de uso de retorno json 
				cRua 	:= DecodeUTF8(oJson:logradouro)
				cComple := DecodeUTF8(oJson:complemento)
				cBairro := DecodeUTF8(oJson:bairro)
				cCidade := DecodeUTF8(oJson:localidade)
				cUf 	:= DecodeUTF8(oJson:uf)
				cUnidad := DecodeUTF8(oJson:unidade)
				cCep2 	:= DecodeUTF8(oJson:cep)
				cIbge	:= DecodeUTF8(oJson:ibge)

				//Só para teste 
				MsgAlert("Rua: " + cRua + CRLF + " - Complemento: " + cComple + CRLF+ " - Bairro: " + cBairro + CRLF+ " - Cidade: " + cCidade + CRLF+ " - UF: " + cUf + CRLF+ " ","<b>Dados !</b>")

			EndIf
	Else

		MsgAlert("Verifique o CEP")

	EndIf

Return

/*/{Protheus.doc} ENDVLCEP
	Valida e remove caracteres especiais do CEP
	@type User Function DEVEND02
	@author Endreo Figueiredo
	@since 23/05/2019
	@version 12.1.17
	@param param, param_type, param_descr
	@return return, return_type, return_description
	@example
	Uso de função de ENDVLCEP("78098-550")
	@see (links_or_references)
	/*/
Static Function ENDVLCEP(p_cCep)
	Local cCep 	:= p_cCep
	Local lRet 	:= .F.
	Local nIfen	:= At("-",cCep,)
	Local nCar	:= Len(StrTran(AllTrim(cCep),"-")) // Dever ser 7 de qualquer forma

	If ( Empty(Alltrim(cCep)) )

		MsgAlert("CEP em branco verifique","<b>Informativo !</b>")

	Else

		IF ( Len(Alltrim(cCep)) < 8  )

			MsgAlert("Verifique o CEP informado","<b>Informativo !</b>")

		ElseIf ( nIfen == 6 .AND. nCar == 8 ) .OR. ( nIfen == 0 .AND. nCar == 8 )
			
			lRet := .T.

		Endif

	EndIf

Return ( lRet )
