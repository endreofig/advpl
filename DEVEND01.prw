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
    Local _oFont1       := TFont():New("Calibri",,018,,.T.,,,,,.F.,.F.)
    Local _oFont2       := TFont():New("Calibri",,024,,.F.,,,,,.F.,.F.)
    Local oFont         := TFont():New('Courier new',,-14,.T.)
    Local _oGet1
    Local cGet1         := Space(50)
    Local dData         := DATE()
    Local ctime         := ""
    Local _oGroup
    Local oTimer1  
    Local _oSay1
    Local oTMsgBar
    Local oTMsgItem1
    Local oTMsgItem2
    Local cCodigo       := RetCodUsr()
    Local cNomeUsr      := UsrRetName(cCodigo)
    Local aCargoUsr     := UsrRetGrp(cCodigo)
    Local aButtons      := {}
    Local bError 
    Static oDlg

  // Recupera e/ou define um bloco de código para ser avaliado quando ocorrer um erro em tempo de execução
	bError := ErrorBlock( {|e| cError := e:Description } ) //, Break(e) } )

	// Inicia sequencia.
	BEGIN SEQUENCE

    DEFINE MSDIALOG oDlg TITLE "SEM TITULO" FROM 000, 000  TO 200, 500 COLORS 0, 16763742 PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )
    
      @ 000, 000 GROUP _oGroup TO 100, 255 OF oDlg COLOR 0, 16763742 PIXEL
      @ 061, 020 MSGET _oGet1 VAR cGet1 SIZE 207, 013 OF oDlg COLORS 0, 16777215 FONT _oFont1 PIXEL
      @ 041, 020 SAY _oSay1 PROMPT "Digite o nome da Função" SIZE 137, 014 OF oDlg FONT _oFont2 COLORS 0, 16763742 PIXEL
      EnchoiceBar(oDlg,{||EXECFUN(cGet1)},{||oDlg:End()},,@aButtons)

      // Cria barra de status
      oTMsgBar := TMsgBar():New(oDlg, '',.F.,.F.,.F.,.F., RGB(116,116,116),,oFont,.F.)
      // Cria itens
      oTMsgItem1 := TMsgItem():New( oTMsgBar, dData                        , 100,,,,.T., {||} )
      oTMsgItem2 := TMsgItem():New( oTMsgBar, cNomeUsr                     , 350,,,,.T., {||} )

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
	Local lSF2460I := ExistBlock(cGet1)

    If lSF2460I
      ExecBlock(cGet1,.F.,.F.)
    Else
      MsgInfo("A Função Executada Não esta Compilada!", "<b>Atenção !</b>")
    Endif  

Return
