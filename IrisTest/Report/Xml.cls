Class IrisTest.Report.Xml Extends Base
{

Parameter FileExtension As STRING = "xml";

Method OnGenerate(Output fileName As %String)
{
	Set file = ##Class(%Stream.FileBinary).%New()
	Set fileName = ..GetFileName()
	Set statusCode = file.LinkToFile(fileName)
	If ($System.Status.IsError(statusCode)) {
	  Do $System.Status.DisplayError(statusCode)
	  Return 1
	}
	Set unitTestObj = ##class(%UnitTest.Result.TestInstance).%OpenId(..UnitTestId)
	Quit:'$IsObject(unitTestObj) ""
	Do unitTestObj.XMLExportToStream(.xmlstream)
	Do file.CopyFrom(xmlstream)
	Set st=file.%Save()
	Quit st
}

}
