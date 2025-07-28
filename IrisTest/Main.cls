Include IrisTest

Class IrisTest.Main Extends %RegisteredObject
{

/// Intractive shell
ClassMethod Shell()
{
	$$$DisableUndef
	Do ..DrawBorder(..BuildWelcomMsg())
G1	Write $$$NL, ..TerminalPrompt()
	Read tCommand
	Set tCommand = $$$Upper(tCommand)
	If tCommand=""!(tCommand?1(1"Q",1"QUIT")) Write $$$NL Quit
	If ..CheckIsCommnads(tCommand) GoTo G1
	Do ..Execute(tCommand)
	GoTo G1
}

ClassMethod CheckIsCommnads(pShellCmd As %String = "")
{
	If pShellCmd=$$$IsHelp Set pShellCmd="HELP"
	Set pShellCmd = $$$Upper(pShellCmd)
	If ##class(%Dictionary.MethodDefinition).%ExistsId($classname()_"||"_$P(pShellCmd," ")){
		If $Length(pShellCmd," ")>1 {
			for i=2:1:$L(pShellCmd," ") {
				Set pArgs($Increment(ic))=$Piece(pShellCmd," ",i)
			}
			Do $ClassMethod(,$Piece(pShellCmd," "),.pArgs)
		}
		Else {
			Do $ClassMethod(,$Piece(pShellCmd," "))
		}
		$$$ITestLibLogHist($USERNAME,$H,pShellCmd)
		Return $$$OK
	}
	Return 0
}

ClassMethod ParseShellCommands(pCommand, Output pFlags)
{
	Set cmdList = $LFS($$$Upper(pCommand)," ")
	Set ptr = 0
	While $ListNext(cmdList,ptr,cmd) {
		Set:cmd?1.E pFlags($TRanslate($Piece(cmd,"="),"-"))=$Piece(cmd,"=",2)
	}
}

/// Set pCommand = "ID=90 OUTPUT=ALLURE"
ClassMethod Execute(pCommand)
{
	#dim tException As %Exception.AbstractException
	Try {
		Do ..ParseShellCommands(pCommand,.flgs)
		;
		Set id = $Get(flgs("ID"), $Get(flgs("I"), ""))
		Set format = $LFS($Get(flgs("OUTPUT"), $Get(flgs("O"), "")))
		Set fileDir = $Get(flgs("OUTPUTDIR"), $Get(flgs("D"), ""))
		;
		If id="" Write $$$NL, "Unit testId flag is missing" Return
		If format="" Write $$$NL, "Atleast one output is required" Return
		Do ..ValidateFormats(format,.supportedFormats)
		If supportedFormats="" Return $$$OK
		$$$ITestLibLogHist($USERNAME,$H,pCommand)
		Do ##class(IrisTest.Report).Run(id, format, fileDir)
	}
	Catch tException {
		$$$ITestLibLogErr(tException.BinDisplayString())
	}
	Return $$$OK
}

ClassMethod ValidateFormats(pFromats As %List, Output SupportedFormats As %List)
{
	Set ptr = 0
	While $ListNext(pFromats,ptr,format) {
		If '..Formats(format) {
			Write !, $$$FormattedLine($$$Red,"Error: "_ format_ " format is currently not supported." )
			Continue
		}
		Set $List(SupportedFormats,$I(I))=format
	}
}

ClassMethod Formats(pFromat As %String) As %Status [ CodeMode = expression ]
{
$LF($LB("HTML","ALLURE","JUNITXML","SHELL","XML","JSON","TAP","TEXT","CSV"),pFromat)
}

ClassMethod RUN(pShellCmd) [ CodeMode = expression ]
{
1
}

ClassMethod CONFIG(pShellCmd)
{
	If '$Data($$$UTRoot) {
		Write $$$NL, "No Unit test file directory defined"
	}
	Else {
		Write $$$NL, "Unit test file directory: "_$$$UTRoot
	}
	;
	Write $$$NL
	Write $$$NL,"UnitTest Management Portal URL: ", ..GetURL()
	;
	Write $$$NL
	If '$Data($$$UTReport) {
		Write $$$NL, "No output directories defined for reports yet"
		Quit
	}
	Write $$$NL, "File output directories"
	Set format=""
	For {
		Set format = $O($$$UTReport(format),1,data) Quit:format=""
		Write $$$NL, $J(format,10),"  : ",$LG(data)
		If $Data($$$UTReport(format))>1 {
			Set format1 = $O($$$UTReport(format,""))
			Write $$$NL, $J(format1,10),"  : ",$LG(data)
		}
	}
}

ClassMethod GetURL()
{
	#; No need for URL in tut environment
	If $get(^ISC.TutCheckTest) RETURN
	Set s = ##class(%RoutineMgr).GetWebServerPort(.p, .h, .up, .url)
	if $E(url,*)="/" {
		set url=$E(url,1,*-1)
	}
	If ($$$ISERR(s)) || ($G(url)="") Set url = "http://127.0.0.1:57772"
	set url=url_$$getDefaultApp^%SYS.cspServer2("%SYS")
	Return url_"/%25UnitTest.Portal.Home.cls?$NAMESPACE="_$zconvert($namespace,"O","URL")
}

ClassMethod HIST(pArgs)
{
	Set date=""
	Set input = $$$Upper(pArgs(1))
	If input="CLEAR"!(input="C") Kill $$$ITestLibHist Quit
	If input="TODAY"!(input["T") {
		If input?1"T-".N {
			Set endDate = $H-$P(input,"-",2)
		}
		Else{
			Set endDate=+$H
		}
	}
	Set date=""
	For i=1:1{
		Set date = $O($$$ITestLibHist($USERNAME,date),-1,data) Quit:date=""
		If endDate'="" continue:+date'=endDate
		If $ISVALIDNUM(input) Quit:i>=input
		Write $$$NL, "[ "_$ZDT(date)_" ]     ",data
	}
}

ClassMethod RUNALL(pShellCmd) [ CodeMode = expression ]
{
##class(IrisTest.UnitTest.Run).RunAll()
}

/// List All unit tests
ClassMethod SHOWALL() [ CodeMode = expression ]
{
##class(IrisTest.UnitTest.Display).ListAll()
}

ClassMethod SHOW(pArgs)
{
	Set id = $$$Upper(pArgs(1))
	If id= "ALL" {
		Do ..SHOWALL()
		Quit
	}
	Else {
		Do ##class(IrisTest.UnitTest.Display).UnitTestResultById(id)
	}
}

ClassMethod DEL(pArgs)
{
	Write !, "Are you sure? [N]: "
	Read ans#1
	If '$Find("Yy",ans) Quit
	F I=1:1:$Length(pArgs(1),",") {
		Set id = $P(pArgs(1),",",I)
		Do ##class(IrisTest.UnitTest.Run).DeleteById(id)
		Write $$$NL,"Unit test result "_id_" has been deleted"
	}
}

ClassMethod CLEAR()
{
	W #
	Q
}

ClassMethod TerminalPrompt() As %String
{
	Set tp=##class(%SYSTEM.Process).TerminalPrompt()
	Set prompt=$$$FormattedLine(35,"ZIRISTEST:")_$NAMESPACE_">"
	Return prompt
}

ClassMethod BuildWelcomMsg()
{
	Set systemMode = ..GetSystemMode()
	Set instance      =  "➤ Instance      : "_$$$Instance
	If systemMode = "" {
		Set systemMode = "➤ System Mode   : <unset>"
	} Else {
		Set systemMode = "➤ System Mode   : " _ systemMode
	}
	Set currentUser =    "➤ Logged in     : "_$USERNAME
	Set System=          "➤ System        : "_$$$System
	Set session =        "➤ Session Start : "_$ZDT($NOW(),3)
	Set msg = $ListBuild(
		"Welcome to iristest shell "_$$$FormattedLine($$$GreenHlght,..GetIrisTestVersion()),
		"Enter 'q' or 'quit' to exit the shell. Enter '?' or 'help' to view available commands",
		"",
		instance,
		System,
		systemMode,
		currentUser,
		session
	)
	Quit msg
}

ClassMethod GetSystemMode()
{
	New $Namespace
	Set $Namespace = "%SYS"
	If $$$ISOK(##class(Config.Startup).Get(.tProperties)) {
		Quit $Get(tProperties("SystemMode"))
	}
	Quit "<unset>"
}

ClassMethod INFO()
{
	Write !!,$$$FormattedLine($$$Underlined,"System Information:"),!
	Write !, "  Shell Name     : ziristest"
	Write !, "  Version        : "_..GetIrisTestVersion()
	Write !, "  Mode           : "_..GetSystemMode()
	Write !, "  Instance       : "_$$$Instance
	Write !, "  Namespace      : "_$NAMESPACE
	Write !, "  User           : ",$USERNAME
	Write !, "  Hostname       : ",$$$System
	Write !, "  OS             : ",##Class(%SYSTEM.Version).GetBuildOS()
	;W !, "  Started At     : "_$ZDT($NOW(),3)
}

ClassMethod GetIrisTestVersion()
{
	If '$D($$$ITestLibVersion) {
		Set $$$ITestLibVersion=$$$defaultVersion
	}
	Return $$$ITestLibVersion
}

ClassMethod DrawBorder(pLineList As %Library.List)
{
	// Find longest line in list
	Set ptr = 0
	Set maxLength = 0
	While $ListNext(pLineList, ptr, line) {
		Set lineLength = $Length(line)
		If (lineLength > maxLength) {
			Set maxLength = lineLength
		}
	}

	Set verticalBorderCharacter = "||"
	;Set verticalBorderCharacter = "║"
	;Set horizonatalBorderCharacter = "="
	Set horizonatalBorderCharacter = "═"

	Set horizontalBorder = ""
	For i=1:1:(maxLength + 6) {
		Set horizontalBorder = horizontalBorder _ horizonatalBorderCharacter
	}

	Write $$$NL, horizontalBorder
	Set ptr = 0
	While $ListNext(pLineList, ptr, line) {
		Write $$$NL, verticalBorderCharacter_" ", line, ?(maxLength + 4), " "_verticalBorderCharacter
	}
	Write $$$NL, horizontalBorder
	Write $$$NL
}

ClassMethod HELPMSG(pHelpText = "")
{
	Set HelpxData=##class(%Dictionary.XDataDefinition).%OpenId($classname()_"||HelpText")
	Write HelpxData.Data.Read()
	Quit
	Write $$$NL
	Write "Usage:",$$$NL
	Write "  ziristest [OPTIONS]",$$$NL
	Write !
	Write "Options:",!
	Write "-i, --id <TestRunID>            Specify a unique ID for the test run (e.g. 40)",!
	Write "-o, --output <FORMAT>           Specify one or more output formats.",!
	Write "                                  Supported formats: ",!
	Write "                                   html, xml, junitxml, allure,",!
	Write "                                   shell, json, xml, TAP",!
	Write "-d=<DIR>, --output-dir=<DIR>    Directory to save generated reports (e.g. /tmp/test or C:/test)",!
	Write "                                Multiple formats can be comma-separated:",!
	Write "                                e.g. html, allure, junitxml",!
	Write !
	Write "-h, --help                      Show this help message and exit",!
	Write !
	Write "Examples:",!
	Write "  ziristest "_$$$FormattedLine($$$Bold,"--id=123 --output=html"),!
	Write "  ziristest "_$$$FormattedLine($$$Bold,"-i=123 -o=html, xml, junitxml"),!
}

ClassMethod ShowShellCommands()
{
	Write $$$NL,$$$FormattedLine($$$Underlined,"Available commands:"),!
	Set maxLen = 0
	Do ..GetCommands(.commands)
    Set cmd=""
    For {
        Set cmd = $Order(commands(cmd))
        Quit:cmd=""
        Set maxLen = $Select($Length(cmd)>maxLen:$Length(cmd), 1:maxLen)
    }

    Set cmd=""
    For {
        Set cmd = $Order(commands(cmd))
        Quit:cmd=""
        Write "  ", cmd
        Write $Justify("", maxLen - $Length(cmd) + 2) // padding
        Write commands(cmd), $$$NL
    }
}

ClassMethod %DispatchClassMethod(pClass, pMethod, pArgs...)
{

	Write $$$NL, pMethod_" Command is not available"
	Q
}

ClassMethod HELP()
{
	Do ..HELPMSG()
	Do ..ShowShellCommands()
}

ClassMethod PrintCmds()
{

	do ..GetCommands(.commands)

	Set $P(lhl,$$$LHL,80)=""
	Write $$$NL,$$$TL, "Commands",lhl,$$$TR
	Set ptr = 0
	 Set cmd=""
    For {
        Set cmd = $Order(commands(cmd))
        Quit:cmd=""
        Set cmd1 = $J(cmd,10)_"   "_commands(cmd)
        w $$$NL,$$$LVL,cmd1,$J($$$LVL,89-$L(cmd1))
        ;Write !,$$$LVL,cmd1, $J($$$LVL,90)
    }
    Set $P(lhl,$$$LHL,88)=""
	Write $$$NL,$$$BL,lhl,$$$BR
}

ClassMethod GetCommands(commands)
{
    // Define commands in a structured way
    Set commands("CLEAR") = "Clear the shell"
    Set commands("CONFIG") = "Configuration details"
    Set commands("DEL") = "Delete the specific Unit test result"_$C(13,10)_$C(9,9)_"- DEL 10 → deletes unit test case with ID 10"_$C(13,10)_$C(9,9)_"- DEL 1,2,4 → deletes unit test cases with IDs 1, 2, and 4 (comma-separated)"
    Set commands("HELP") = "Show this help message"
    Set commands("HIST") = "Show command history"_$C(13,10)_$C(9,9)_"- HIST → Full history"_$C(13,10)_$C(9,9)_"- HIST 10 → Last 10 commands "_$C(13,10)_$C(9,9)_"- HIST (T)ODAY → Today’s commands only  "_$C(13,10)_$C(9,9)_"- HIST T-1 → Yesterday commands only  "_$C(13,10)_$C(9,9)_"- HIST (C)LEAR → Clear history"
    Set commands("QUIT") = "Exit the shell"
    Set commands("INFO") = "Show system or shell version info"

    ;Set commands("RUN") = "Run the selected test or test suite"
    Set commands("RUNALL") = "Run all test cases"
    Set commands("SHOW") = "Show detailed results for a specific test run"
    Set commands("SHOWALL") = "List all Unit Test results"
}

XData HelpText [ MimeType = application/text ]
{

 Usage:
   ziristest [OPTIONS]

 Options:
   -i, --id <TestRunID>            Specify a unique ID for the test run (e.g. 40)
   -o, --output <FORMAT>           Specify one or more output formats.
                                  Supported formats:
                                   html, xml, junitxml, allure,
                                   shell, json, xml, text, csv

   -d=<DIR>, --output-dir=<DIR>    Directory to save generated reports (e.g. /tmp/test or C:/test)
                                Multiple formats can be comma-separated:
                                e.g. html, allure, junitxml

   -h, --help                      Show this help message and exit

  Examples:
    ziristest --id=123 --output=html
    ziristest -i=123 -o=html, xml, junitxml
    ziristest -i=123 -o=html, xml, junitxml --output-dir=./reports
}

}
