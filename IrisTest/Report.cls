Include IrisTest

Class IrisTest.Report Extends %RegisteredObject
{

ClassMethod Run(pUnitTestId As %Integer, Format As %List, OPFileDirectory)
{
	Set ptr = 0
	While $ListNext(Format,ptr,output) {
		Do $ClassMethod(, "RunReport", $ZCVT(output,"W"), pUnitTestId, OPFileDirectory)
	}
	Return $$$OK
}

/// For REST API
ClassMethod GenerateReport(pUnitTestId As %Integer, Format As %List) As %DynamicArray
{
	Set response = ##class(%DynamicArray).%New()	
	Set ptr = 0
	While $ListNext(Format,ptr,output) {
		Set output = $ZCVT(output,"W")
		Set reportObj = $ClassMethod($$$ReportCls(output), "%New", pUnitTestId)
		Set sc = $Method(reportObj, $$$ReportMethod, .FileNames)
		Set json = {"format":(output),"fileName":[]}
		If $Data(FileNames)>1 {
			Set file=""
			For {
				Set file = $O(FileNames(file)) Q:file=""
				Do json.fileName.%Push(file)
			}
		}
		ElseIf $Data(FileNames)=1{
			Do json.fileName.%Push(FileNames)
		}
		Do response.%Push(json)
	}
	Return response
}

ClassMethod RunReport(pReportFormat As %String = "", pUnitTestId As %Integer, OPFileDirectory) [ Internal ]
{
	Set obj = $ClassMethod($$$ReportCls(pReportFormat),"%New", pUnitTestId, OPFileDirectory)
	Set sc = $Method(obj, $$$ReportMethod, .FileNames)
	If sc {
		Write !,pReportFormat, " report successfully generated at:"
		If $Data(FileNames)>1 {
			Set file=""
			For {
				Set file = $O(FileNames(file)) Q:file=""
				Write !, ?3,"-"_file
			}
		}
		ElseIf $Data(FileNames)=1{
			Write !, ?3,"-",FileNames
		}
	}
}

ClassMethod %DispatchClassMethod(Class As %String, Method As %String, Args...) As %Status
{
}

}
