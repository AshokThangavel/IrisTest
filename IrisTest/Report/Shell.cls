Class IrisTest.Report.Shell Extends Base
{

Method OnGenerate(Output fileName As %String)
{
	Set pUnitTestId = ..UnitTestId
	Set pageSize=25,IOM=120
	If '$Data(@..#UTGBL@(pUnitTestId),utinfo) {
		Write !, "No test result found for id "_pUnitTestId
		Quit 0
	}
	Set utinfo = @..#UTGBL@(pUnitTestId)
	Set testSuite = $O(@..#UTGBL@(pUnitTestId,""))
	Set testCase = $O(@..#UTGBL@(pUnitTestId,testSuite,""))
	Set UTGBL=$NAme(@..#UTGBL@(pUnitTestId,testSuite,testCase))

	;
	Set case=""
	For {
		Set case=$O(@UTGBL@(case),1,data) Quit:case=""
		Set caseDetails=""
		For {
				Set caseDetails=$O(@UTGBL@(case,caseDetails),1,data) Quit:caseDetails=""
				;Set mstatus = ..Status($LG(data))
				Write !, $TR($LTS($Li(data,2,4)),","," ")
				If pageSize=$I(cPage) {
					Write !,"(M)ore, (L)ine, (S)croll, (Q)uit? M => ",*-1 r opt#1 w $c(13),?IOM
					Set:opt="" opt="M"
					Set opt = $$$Upper(opt)
					If opt="L"!(opt="S") S cPage=pageSize+1
					If opt="M" Set cPage=0
					If opt="Q" Return 1

				}
			}
	}
	;
	Q 1
}

}
