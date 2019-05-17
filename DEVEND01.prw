#Include 'TOTVS.ch'
#Include 'ParmType.ch'
#Include 'HBUTTON.CH'

/*/{Protheus.doc}
@description description
@type User Function  DEVEND01
@author Endreo Figueiredo
@since 16/05/2019
@version 12.1.17
@param param, param_type, param_descr
@return return, return_type, return_description
@see (links_or_references)
/*/

User Function DEVEND01()                        
	Local oButton1
	Local oButton2
	Local oFont1 := TFont():New("Calibri",,023,,.T.,,,,,.F.,.F.)
	Local oFont2 := TFont():New("Calibri",,020,,.F.,,,,,.F.,.F.)
	Local oGet1
	Local cGet1 := Space(20)
	Local oSay1
	Local oSay2
	Local bError 
	Static oDlg
	

	// Recupera e/ou define um bloco de código para ser avaliado quando ocorrer um erro em tempo de execução
	bError := ErrorBlock( {|e| cError := e:Description } ) //, Break(e) } )

	// Inicia sequencia.
	BEGIN SEQUENCE

		DEFINE MSDIALOG oDlg TITLE "" FROM 000, 000  TO 220, 500 COLORS 0, 16777215 PIXEL

			@ 011, 061 SAY oSay1 PROMPT "Testar Função Customizada" SIZE 115, 013 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
			@ 046, 016 SAY oSay2 PROMPT "Nome da Função" 			SIZE 074, 012 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL

			@ 047, 095 MSGET oGet1 VAR cGet1 SIZE 099, 010 OF oDlg COLORS 0, 16777215 PIXEL

			@ 070, 144 BUTTON oButton1 PROMPT "Executar" 	SIZE 046, 018 OF oDlg ACTION EXECFUN(cGet1) PIXEL
			@ 070, 197 BUTTON oButton2 PROMPT "Sair" 		SIZE 046, 018 OF oDlg ACTION oDlg::End() 	PIXEL
			SET MESSAGE OF oDlg COLORS 0, 14215660

		ACTIVATE MSDIALOG oDlg CENTERED

	RECOVER
		
		// Recupera e apresenta o erro.
		ErrorBlock( bError )
		MsgStop( cError )
		
	END SEQUENCE

Return

/*/{Protheus.doc} nomeStaticFunction
	(long_description)
	@type  Static Function
	@author Endreo Figueiredo
	@since 16/05/2019
	@version 12.1.17
	@param param, param_type, param_descr
	@return return, return_type, return_description
	@detalhes: verifica se função existe e executa a função
/*/

Static Function EXECFUN(cGet1)
	LOCAL lSF2460I := ExistBlock(cGet1)

	IF lSF2460I
		ExecBlock(cGet1,.F.,.F.)
	ELSE
		MsgInfo("A Função Executada Não esta Compilada!", "Atenção !")
	ENDIF                    
Return
