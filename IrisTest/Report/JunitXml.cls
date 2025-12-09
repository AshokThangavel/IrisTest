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
		Write $System.OBJ.DisplayError(st) Quit st
	}
	If '##class(Utils).UTIdExist(pUnitTestId) Goto End

	Set utinfo = @..#UTGBL@(pUnitTestId)
	&SQL(Select Status,Duration,Name,ErrorDescription INTO :Status,:Duration,:TestSuiteName,:ErrorDescription from %UnitTest_Result.TestSuite where TestInstance=:pUnitTestId)

	Do file.WriteLine("<?xml version=""1.0"" encoding=""UTF-8""?>")
	;testsuites begin
	Do file.WriteLine("<testsuites time="""">")
	;;test suite
	Do file.WriteLine($Char(9)_"<testsuite name="""_TestSuiteName_""" time="""_Duration_""">")
	Do file.WriteLine("<properties>")
	For prop="Status","Duration","Name","ErrorDescription" {
		Do file.WriteLine("<property  name="""_prop_""" value="""_$Get(@prop)_"""/>")
	}
	Do file.WriteLine("</properties>")

	;testcase
	Set testCase=""
	For {
		Set testCase=$Order(@..#UTGBL@(pUnitTestId,TestSuiteName,testCase),1,data) Quit:testCase=""
		Do file.WriteLine(" <testcase name="""_testCase_""">")
		Do file.WriteLine(" <system-out><![CDATA[")
		;
		Set status = ..Status($ListGet(data,1))
		;test method and test result
		Set testMethod="", data=""
		For {
			Set testMethod = $Order(@..#UTGBL@(pUnitTestId,TestSuiteName,testCase,testMethod),1,data) Quit:testMethod=""
			Set mstatus = ..Status($ListGet(data))
			Do file.WriteLine("<testmethod name="""_testMethod_""" duration="""_$ListGet(data,2)_""">")
			Do file.WriteLine("Counter | Action | Status | Description | Location ")
			Do file.WriteLine($ListToString(data))
			Set (testAssert,data)=""
			For {
				Set testAssert=$Order(@..#UTGBL@(pUnitTestId,TestSuiteName,testCase,testMethod,testAssert),1,data) Quit:testAssert=""
				Set mstatus = ..Status($ListGet(data))
				Do file.WriteLine(mstatus_ $Translate($ListToString($List(data,2,4)),","," "))
			}
		}
		Do file.WriteLine("</testmethod>")
		;
		Do file.WriteLine("  ]]></system-out>")
		Do file.WriteLine(" </testcase>")
	}
	;test suite ends
	Do file.WriteLine($Char(9)_"</testsuite>")
	;testsuites ends
	Do file.WriteLine("</testsuites>")
End
	Quit st
}

/// setup file generated path
ClassMethod SetFilePath(path = "C:\InterSystems\IRISHealthComm\unittest_reports\xml\junit\")
{
	Set $$$ITestLibReport(..#FileExtension,"junit") = $ListBuild(path,$ZDatetime($Now()))
}

ClassMethod GetFilePath() [ CodeMode = expression ]
{
$ListGet($$$ITestLibReport(..#FileExtension,"junit"))
}

}
