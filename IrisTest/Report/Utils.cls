Class IrisTest.Report.Utils Extends %RegisteredObject
{

ClassMethod UTIdExist(pUnitTestId) As %Status [ CodeMode = expression ]
{
##class(%UnitTest.Result.TestInstance).%ExistsId(pUnitTestId)
}

ClassMethod generateFile(pUnitTestId, fileName)
{
	Set file = ##Class(%Stream.FileBinary).%New()
	Set statusCode = file.LinkToFile(fileName)
	If ($System.Status.IsError(statusCode)) {
	  Do $System.Status.DisplayError(statusCode)
	  Return 1
	}
	Do file.WriteLine("SuiteName,TestCase,TestMethod,Counter,Status,Action,Description,Location")
	Set tResult = ..TestResultsByIdFunc(pUnitTestId)
	While tResult.%Next() {
		Do file.WriteLine(tResult.TestSuite_","_tResult.TestCaseName_","_tResult.TestMethodName_","_tResult.Counter_","_tResult.Status_","_tResult.Action_","_tResult.Description_","_tResult.Location)
	}
	Set sc = file.%Save()
	Return sc
}

Query UnitTestResultById(pUnitTestId As %Integer) As %SQLQuery
{
SELECT
  m.Name AS TestMethodName,
  c.Name AS TestCaseName,
  i.InstanceIndex,
  a.*
FROM %UnitTest_Result.TestAssert a
JOIN %UnitTest_Result.TestMethod m ON a.TestMethod = m.ID
JOIN %UnitTest_Result.TestCase c ON m.TestCase = c.ID
JOIN %UnitTest_Result.TestSuite s ON c.TestSuite = s.ID
JOIN %UnitTest_Result.TestInstance i ON s.TestInstance = i.ID
WHERE i.InstanceIndex =:pUnitTestId
}

Query TestResultsById(pUnitTestId As %Integer) As %SQLQuery
{
	SELECT
  i.InstanceIndex,
  s.Name As TestSuite,
  c.Name AS TestCaseName,
  m.Name AS TestMethodName,
  a.Action,
  a.Counter,
  CASE WHEN a.Status=1 THEN 'passed'
       WHEN a.Status=0 THEN 'failed'
       ELSE 'skipped'
  END As Status,
  a.Description,
  a.Location
FROM %UnitTest_Result.TestAssert a
JOIN %UnitTest_Result.TestMethod m ON a.TestMethod = m.ID
JOIN %UnitTest_Result.TestCase c ON m.TestCase = c.ID
JOIN %UnitTest_Result.TestSuite s ON c.TestSuite = s.ID
JOIN %UnitTest_Result.TestInstance i ON s.TestInstance = i.ID
WHERE i.InstanceIndex =:pUnitTestId
}

Query GetTestCaseStatus(pUnitTestId) As %SQLQuery
{

SELECT
    SUM(CASE WHEN m.Status = 0 THEN 1 ELSE 0 END) AS failed,
    SUM(CASE WHEN m.Status = 1 THEN 1 ELSE 0 END) AS passed,
    SUM(CASE WHEN m.Status = 2 THEN 1 ELSE 0 END) AS skipped

FROM %UnitTest_Result.TestMethod m
JOIN %UnitTest_Result.TestCase c ON m.TestCase = c.ID
JOIN %UnitTest_Result.TestSuite s ON c.TestSuite = s.ID
JOIN %UnitTest_Result.TestInstance i ON s.TestInstance = i.ID
WHERE i.InstanceIndex  = :pUnitTestId
}

}
