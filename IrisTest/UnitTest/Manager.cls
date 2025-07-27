Class IrisTest.UnitTest.Manager Extends %UnitTest.Manager
{

ClassMethod RunAllTestCases()
{
	Set unitTestMgr = ##class(IrisTest.UnitTest.Manager).%New()
	Quit unitTestMgr.RunTest()
}

ClassMethod RunOneTest(pClass, IsPrintLog)
{
	Set unitTestMgr = ##class(IrisTest.UnitTest.Manager).%New()
	Set:IsPrintLog unitTestMgr.Display="log"
	Set unitTestMgr.LoadXML=1
	;Set sc=$$$qualifierParseAlterDefault("UnitTest","/keepsource",.qspec,.qstruct) q:$$$ISERR(sc) sc
	Set qstruct("load")=1
	Return unitTestMgr.RunOneTestSuite(^UnitTestRoot,pClass,,.qstruct)
}

}
