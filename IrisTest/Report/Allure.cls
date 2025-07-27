Class IrisTest.Report.Allure Extends Base
{

Parameter FileExtension As STRING = "json";

Method OnGenerate(Output FileNames As %String)
{
	Quit:'##class(Utils).UTIdExist(..UnitTestId) ""
	Set pUnitTestId = ..UnitTestId
	Set testSuite = $Order(@..#UTGBL@(pUnitTestId,""))
	Set testCase = $Order(@..#UTGBL@(pUnitTestId,testSuite,""))
	Set TestMethod=""
	Set UTGBL=$NAme(@..#UTGBL@(pUnitTestId,testSuite,testCase))
	For {
		Set TestMethod=$Order(@UTGBL@(TestMethod),1,testCaseData) Quit:TestMethod=""
		;
		Set testMethodId = $Order(@UTGBL@(TestMethod,""))
		Set allureTestCase=..AllureJSON(testSuite,testCase,TestMethod,testMethodId,$ListGet(testCaseData))
		;
		Set testMethodId=""
		Set allureTestCase.steps = []
		For {
			Set testMethodId=$Order(@UTGBL@(TestMethod,testMethodId),1,testMethodData) Quit:testMethodId=""
			Do allureTestCase.steps.%Push(..AllureStepsJSON(testMethodId,testMethodData))	
		}	
		Set fileName = ..FileDirectory_$$$LOWER($system.Util.CreateGUID())_"-result.json"
		Set FileNames(fileName)=""
		Set file = ##class(%File).%New(fileName)
		Set st = file.Open("NW")
		Do file.Write(allureTestCase.%ToJSON())
		Do file.Close()
	}
	Return $$$OK
}

/*
| Key                | Description                                            |
| ------------------ | ------------------------------------------------------ |
| `uuid`             | Unique test case ID (UUID)                             |
| `historyId`        | Hash to track test history                             |
| `testCaseId`       | Another ID for history tracking                        |
| `status`           | Test status: `passed`, `failed`, `skipped`             |
| `statusDetails`    | Detailed failure message and stack trace if any        |
| `stage`            | Test lifecycle stage: `running`, `finished`            |
| `name`             | Test name                                              |
| `description`      | Plain text description (optional)                      |
| `descriptionHtml`  | HTML formatted description (optional)                  |
| `fullName`         | Fully qualified test name (e.g. module#function)       |
| `labels`           | Array of metadata labels (suite, host, severity, etc.) |
| `links`            | Related issue or TMS links                             |
| `parameters`       | Test parameters (e.g. browser=Chrome)                  |
| `start`            | Test start timestamp (epoch ms)                        |
| `stop`             | Test stop timestamp (epoch ms)                         |
| `steps`            | Array of test steps (recursive)                        |
| `attachments`      | Files attached to the test (screenshots, logs)         |
| `befores`          | Setup steps                                            |
| `afters`           | Teardown steps                                         |
| `testCaseStarted`  | Timestamp when test started                            |
| `testCaseFinished` | Timestamp when test finished                           |

*/
ClassMethod AllureStepsJSON(step, TestResult) [ Internal ]
{
	return {
      "name": ("Step "_step_": "_$TR($LTS($Li(TestResult,2,3)),","," ")),
      "status": (..Status($LG(TestResult))),
      "start": 1752202252027,
      "stop": 1752202252027,
      "steps": []
    }
}

ClassMethod AllureJSON(testSuite, testCase, TestMethod, TestId, TestStatus) [ Internal ]
{
	
	Return {
	"name": (TestMethod),
	"status": (..Status(TestStatus)),
	//"stage": "finished",
  
  "statusDetails": {
    "message": "AssertionError: assert (5 - 3) == 211",
    "trace": "def test_subtraction12():\n>       assert 5 - 3 == 211\nE       assert (5 - 3) == 211\n\ntesti.py:19: AssertionError"
  },
  "start": 1752202251027,
  "stop": 1752202252027,
  "uuid": ($$$LOWER($system.Util.CreateGUID())),
  "historyId": (TestMethod_"-"_TestId),
  "testCaseId": (TestMethod_"-"_TestId),
  "fullName": (testSuite_"."_testCase),
  
  ;"description": "",
  ;"descriptionHtml": "",
  
  "labels": [
    { "name": "suite", "value": (testSuite) },
    { "name": "language", "value": "ObjectScript" },
    { "name": "framework", "value": "iristest" },
    { "name": "testClass", "value": (testCase) },
    { "name": "testMethod", "value": (TestMethod) },
    { "name": "package", "value": "testi" }
    ;
    ;{ "name": "package", "value": "testi" },
    ;{ "name": "host", "value": "C5V3W44" },
    ;{ "name": "thread", "value": "26920-MainThread" },
    ;{ "name": "framework", "value": "pytest" },
    ;{ "name": "severity", "value": "normal" },
    ;{ "name": "feature", "value": "Feature Name" },
    ;{ "name": "story", "value": "Story Name" },
    ;{ "name": "owner", "value": "owner-name" },
   ; { "name": "tag", "value": "smoke" }
  ]
  /*,"links": [
    {
      "name": "JIRA-123",
      "url": "https://jira.example.com/browse/JIRA-123",
      "type": "issue"
    },
    {
      "name": "TMS-456",
      "url": "https://tms.example.com/testcase/456",
      "type": "tms"
    }
  ],
  "parameters": [
    {
      "name": "param1",
      "value": "value1"
    },
    {
      "name": "param2",
      "value": "value2"
    }
  ],
  */
  ,
  /*
  "attachments": [
    {
      "source": "log-12345.txt",
      "type": "text/plain",
      "name": "Log Output"
    }
  ],
  "parameters": [
    {
      "name": "browser",
      "value": "Chrome"
    }
  ],
  "attachments": [
    {
      "source": "screenshot-123.png",
      "type": "image/png",
      "name": "Failure Screenshot"
    }
  ],
  "befores": [
    {
      "name": "Setup environment",
      "status": "passed",
      "start": 1752202250000,
      "stop": 1752202250500
    }
  ],
  "afters": [
    {
      "name": "Cleanup",
      "status": "passed",
      "start": 1752202252100,
      "stop": 1752202252500
    }
  ],*/
  
  "testCaseStarted": 1752202251000,
  "testCaseFinished": 1752202252027
	}
}

/// setup file generated path
ClassMethod SetFilePath(path = "")
{
	Set $$$ITestLibReport(..#FileExtension,"allure") = $LB(path,$ZDT($NOW()))
}

ClassMethod GetFilePath() [ CodeMode = expression ]
{
$LG($$$ITestLibReport(..#FileExtension, "allure"))
}

XData Sampleallure [ MimeType = application/json ]
{
{"uuid":"adf87631-781c-459d-8708-b3a660e3b1b3","historyId":"715bd660d7f9cd8ccab1dfb6ecf36535","testCaseId":"715bd660d7f9cd8ccab1dfb6ecf36535","status":"passed","statusDetails":{"message":"","trace":""},"stage":"finished","name":"test_subtraction1","description":"Optional description of the test","descriptionHtml":"<p>Optional description of the test</p>","fullName":"testi#test_subtraction1","labels":[{"name":"suite","value":"testi"},{"name":"host","value":"C5V3W44"},{"name":"thread","value":"26920-MainThread"},{"name":"framework","value":"pytest"},{"name":"language","value":"cpython3"},{"name":"package","value":"testi"},{"name":"testClass","value":"TestClassName"},{"name":"testMethod","value":"test_subtraction1"},{"name":"severity","value":"normal"},{"name":"feature","value":"Feature Name"},{"name":"story","value":"Story Name"},{"name":"owner","value":"owner-name"},{"name":"tag","value":"smoke"}],"links":[{"name":"JIRA-123","url":"https://jira.example.com/browse/JIRA-123","type":"issue"},{"name":"TMS-456","url":"https://tms.example.com/testcase/456","type":"tms"}],"parameters":[{"name":"browser","value":"Chrome"}],"start":1752202251027,"stop":1752202252027,"steps":[{"name":"Step 1: Prepare data","status":"passed","start":1752202251027,"stop":1752202251527,"steps":[],"attachments":[{"source":"image-12345.png","type":"image/png","name":"Screenshot"}]},{"name":"Step 2: Execute test","status":"passed","start":1752202251528,"stop":1752202252027,"steps":[],"attachments":[]}],"attachments":[{"source":"screenshot-123.png","type":"image/png","name":"Failure Screenshot"}],"befores":[{"name":"Setup environment","status":"passed","start":1752202250000,"stop":1752202250500}],"afters":[{"name":"Cleanup","status":"passed","start":1752202252100,"stop":1752202252500}],"testCaseStarted":1752202251000,"testCaseFinished":1752202252027}
}

}
