Class IrisTest.Report.Junitxml Extends Base
{

Parameter FileExtension As STRING = "xml";

Method OnGenerate(Output fileName As %String) [ CodeMode = expression ]
{
..JunitXML(.fileName)
}

Method JunitXML(Output fileName)
{
	#dim st As %Status = $$$OK
	Set pUnitTestId =..UnitTestId
	Set fileName = ..GetFileName()
	Set file = ##class(%File).%New(fileName)
	Set st= file.Open("NW")
	If $$$ISERR(st) {
		Write $SYSTEM.OBJ.DisplayError(st) Quit st
	}
	If '##class(Utils).UTIdExist(pUnitTestId) GoTo End

	Set utinfo = @..#UTGBL@(pUnitTestId)
	&SQL(Select Status,Duration,Name,ErrorDescription INTO :Status,:Duration,:TestSuiteName,:ErrorDescription from %UnitTest_Result.TestSuite where TestInstance=:pUnitTestId)

	Do file.WriteLine("<?xml version=""1.0"" encoding=""UTF-8""?>")
	;testsuites begin
	Do file.WriteLine("<testsuites time="""">")
	;;test suite
	Do file.WriteLine($C(9)_"<testsuite name="""_TestSuiteName_""" time="""_Duration_""">")
	Do file.WriteLine("<properties>")
	For prop="Status","Duration","Name","ErrorDescription" {
		Do file.WriteLine("<property  name="""_prop_""" value="""_$Get(@prop)_"""/>")
	}
	Do file.WriteLine("</properties>")

	;testcase
	Set testCase=""
	For {
		Set testCase=$O(@..#UTGBL@(pUnitTestId,TestSuiteName,testCase),1,data) Quit:testCase=""
		Do file.WriteLine(" <testcase name="""_testCase_""">")
		Do file.WriteLine(" <system-out><![CDATA[")
		;
		Set status = ..Status($LG(data,1))
		;test method and test result
		Set testMethod="", data=""
		For {
			Set testMethod = $O(@..#UTGBL@(pUnitTestId,TestSuiteName,testCase,testMethod),1,data) Quit:testMethod=""
			Set mstatus = ..Status($LG(data))
			Do file.WriteLine("<testmethod name="""_testMethod_""" duration="""_$LG(data,2)_""">")
			Do file.WriteLine("Counter | Action | Status | Description | Location ")
			Do file.WriteLine($LTS(data))
			Set (testAssert,data)=""
			For {
				Set testAssert=$O(@..#UTGBL@(pUnitTestId,TestSuiteName,testCase,testMethod,testAssert),1,data) Quit:testAssert=""
				Set mstatus = ..Status($LG(data))
				Do file.WriteLine(mstatus_ $TR($LTS($Li(data,2,4)),","," "))
			}
		}
		Do file.WriteLine("</testmethod>")
		;
		Do file.WriteLine("  ]]></system-out>")
		Do file.WriteLine(" </testcase>")
	}
	;test suite ends
	Do file.WriteLine($C(9)_"</testsuite>")
	;testsuites ends
	Do file.WriteLine("</testsuites>")
End
	Quit st
}

/// setup file generated path
ClassMethod SetFilePath(path = "C:\InterSystems\IRISHealthComm\unittest_reports\xml\junit\")
{
	Set $$$ITestLibReport(..#FileExtension,"junit") = $LB(path,$ZDT($NOW()))
}

ClassMethod GetFilePath() [ CodeMode = expression ]
{
$LG($$$ITestLibReport(..#FileExtension,"junit"))
}

}
