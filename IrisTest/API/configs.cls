Class IrisTest.API.configs Extends %RegisteredObject
{
    ClassMethod Enable()
{
	Try{
		//$$$ThrowOnError(..CreateRESTApp())
		$$$ThrowOnError(..CreateWebApplication())
	}
	Catch tException {
		Write !, tException.DisplayString()
	}
	Quit
}

ClassMethod CreateWebApplication()
{
	Set oldNamespace = $Namespace
	New $Namespace
	Set $Namespace = "%SYS"
	set name="/iristest"
	If ##class(Security.Applications).%ExistsId(name) Quit 1
	kill prop
	Set prop("AutheEnabled") = 32 ; password
	Set prop("DispatchClass") = "IrisTest.API.Dispatch"
	Set prop("NameSpace") = oldNamespace
	Set prop("Enabled") = 1
	Set prop("Description") = "iristest unit test library"
	Set sc=##class(Security.Applications).Create(name, .prop)
	Return sc
}

ClassMethod CreateRESTApp()
{
	Set swagger = {"swagger":"2.0","info":{"title":"iristest unit test api","description":"iristest unit test api","version":"1.0.0"},"basePath":"/iristest/ut","produces":["application/json","applcication/xml"],"consumes":["application/json","application/xml"],"paths":{"/{id}":{"get":{"summary":"get unit test report","operationId":"GetUnitTestReport","x-ISC_CORS":true,"x-ISC_ServiceMethod":"GetUnitTestReport","parameters":[{"name":"id","in":"path","type":"integer","description":"user to add to the system","required":true}]}}}}
	Do ##class(%REST.Spec).%CreateRESTApplication("IrisTest1.API",swagger,,.status)
	Quit status
}

}