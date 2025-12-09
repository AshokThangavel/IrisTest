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
	Set testSuite = $Order(@..#UTGBL@(pUnitTestId,""))
	Set testCase = $Order(@..#UTGBL@(pUnitTestId,testSuite,""))
	Set UTGBL=$Name(@..#UTGBL@(pUnitTestId,testSuite,testCase))

	;
	Set case=""
	For {
		Set case=$Order(@UTGBL@(case),1,data) Quit:case=""
		Set caseDetails=""
		For {
				Set caseDetails=$Order(@UTGBL@(case,caseDetails),1,data) Quit:caseDetails=""
				;Set mstatus = ..Status($LG(data))
				Write !, $Translate($ListToString($List(data,2,4)),","," ")
				If pageSize=$Increment(cPage) {
					Write !,"(M)ore, (L)ine, (S)croll, (Q)uit? M => ",*-1 Read opt#1 Write $Char(13),?IOM
					Set:opt="" opt="M"
					Set opt = $$$Upper(opt)
					If opt="L"!(opt="S") Set cPage=pageSize+1
					If opt="M" Set cPage=0
					If opt="Q" Return 1

				}
			}
	}
	;
	Quit 1
}

}
