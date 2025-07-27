Include IrisTest

Class IrisTest.Report.Base Extends %RegisteredObject
{

Parameter FileExtension As STRING;

Parameter UTGBL As STRING = "^UnitTest.Result";

Property UnitTestId As %Integer;

/// File path taken from the GetFilePath Method and if incase it's empty then will set the system temp directory
Property FileDirectory As %String;

Property FileNames [ MultiDimensional ];

Method %OnNew(pUnitTestId As %Integer = "", FileDir As %String = "") As %Status
{
	Set ..UnitTestId = pUnitTestId 
	Set:FileDir="" FileDir=..GetFilePath()
	Set ..FileDirectory = FileDir
	Return $$$OK
}

Method Generate(FileNames) [ CodeMode = expression ]
{
..OnGenerate(.FileNames)
}

Method OnGenerate(Output fileName As %String)
{
	Return $$$OK
}

ClassMethod GenerateFile(pUnitTestId, FileNames)
{
	Set obj = ..%New(pUnitTestId, FileNames)
	Return obj.Generate()
}

/// setup file generated path for each file format
ClassMethod SetFilePath(path = "")
{
	Set $$$ITestLibReport(..#FileExtension) = $LB(path,$$$DTNOW)
}

ClassMethod GetFilePath() [ CodeMode = expression ]
{
$S($Data($$$ITestLibReport(..#FileExtension)):$LG($$$ITestLibReport(..#FileExtension)),1:$$$SysTempDir)
}

ClassMethod Status(status As %Integer) [ CodeMode = expression ]
{
$Case(status,0:"failed",1:"passed",:"skipped")
}

Method GetFileName() [ CodeMode = expression ]
{
..FileDirectory_..UnitTestId_"_"_$TRanslate($ZDT($H,3)," -:")_"."_..#FileExtension
}

/// Write the contents of xData tag
ClassMethod XDataRead(Const As %String) As %Status
{
    Set obj = ##class(%Dictionary.CompiledXData).%OpenId($classname()_"||"_Const)
    Return:(obj = "") ""
    set xdata = obj.Data
    Set xData=""
    Set status = ##class(%XML.TextReader).ParseStream(xdata, .textreader)
    while textreader.Read() { 
    	If (textreader.NodeType="chars") {
        	Set xData= xData_textreader.Value
    	} 
    }
    Return xData
}

}
