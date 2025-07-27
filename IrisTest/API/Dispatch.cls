Class IrisTest.API.Dispatch Extends %CSP.REST
{
    XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
	<Route Url="/report/:id" Method="GET" Cors="true" Call="GenerateReports"/>
	<Route Url="/:id" Method="GET" Cors="true" Call="SendUnitTestResults"/>
	</Routes>
}

ClassMethod GenerateReports(pUnitTestId As %Integer)
{
	#dim %request as %CSP.Request
	Try {
		Set outputs = $LFS(%request.Get("output"))
		Do ##class(%REST.Impl).%SetContentType(..#CONTENTTYPEJSON)
		Do ##class(%REST.Impl).%WriteResponse(##class(IrisTest.Report).GenerateReport(pUnitTestId, outputs))
	}
	Catch ex {
		Do ##class(%REST.Impl).%ReportRESTError(..#HTTP500INTERNALSERVERERROR,ex.AsStatus())
	}
	Return $$$OK
}

ClassMethod SendUnitTestResults(pUnitTestId As %Integer)
{
	#dim %request as %CSP.Request
	Try {
		Set outputs = $LFS(%request.Get("output"))
		Do ##class(%REST.Impl).%SetContentType(..#CONTENTTYPEJSON)
		Do ##class(%REST.Impl).%WriteResponse(##class(IrisTest.Report).GenerateReport(pUnitTestId, outputs))
	}
	Catch ex {
		Do ##class(%REST.Impl).%ReportRESTError(..#HTTP500INTERNALSERVERERROR,ex.AsStatus())
	}
	Return $$$OK
}
}