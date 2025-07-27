Class IrisTest.Report.Json Extends Base
{

Parameter FileExtension As STRING = "json";

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
	Set json = ##class(%ZEN.Auxiliary.altJSONProvider).%ObjectToAET(unitTestObj, .pVisited, 0, "aceloqstw")
	Do file.Write(json.%ToJSON())
	Set sc = file.%Save()
	Return sc
}

}
