Class IrisTest.UnitTest.Display Extends %RegisteredObject
{

ClassMethod ListAll()
{
	Set pageSize=25
	Set id = "",IOM=120
	Write !, "Id",?9,"Status",?23,"DateTime",?53,"Duration"
	Write !, "--",?9,"------",?23,"--------",?53,"--------"
	Set tReslt = ##class(%SQL.Statement).%ExecDirect(,"Select ID,ID as Status,ID as DeleteSuite,DateTime,Duration,MachineName,ConfigurationName,Namespace,Version from %UnitTest_Result.TestInstance Order By ID Desc")
	While tReslt.%Next() {
		Write !, "| ",tReslt.ID,?7," |",?9,tReslt.Status,?21," |",tReslt.DateTime,?50," |",?52,tReslt.Duration,?62," |"
		If pageSize=$I(cPage) {
			
			;Write !, "M)ore,(L)ine, (Q)uit? M =>"
			w !,"(M)ore, (L)ine, (S)croll, (Q)uit? M => ",*-1 r opt#1 w $c(13),?IOM
			;Read opt#1
			Set:opt="" opt="M"
			If opt="L" S cPage=pageSize+1
			Set opt = $$$UPPER(opt)
			If opt="M" Set cPage=0
			If opt="Q" Return 1
			
		}
	}
	Return 1
}

ClassMethod UnitTestResultById(Id)
{
	#define hl(%str) $C(27)_"[7m"_%str_$C(27)_"[0m"
	Set pageSize=25,IOM=120
	Quit:Id="" ""
	Set testSuite = $O(^UnitTest.Result(Id,""))
	Set testCase = $O(^UnitTest.Result(Id,testSuite,""))
	Set TestCaseId = Id_"||"_testSuite_"||"_testCase
	Set tReslt = ##class(%SQL.Statement).%ExecDirect(,"Select ID,Name as TestMethod,Status,ErrorDescription,Duration from %UnitTest_Result.TestMethod where TestCase=?",TestCaseId)
	While tReslt.%Next() {
		Write !, "| ",$$$hl(tReslt.ID),?7," |",?9,$$$hl(tReslt.TestMethod),?21," |",$$$hl(tReslt.Status),?50," |",?52,$$$hl(tReslt.ErrorDescription),?62," |",?80,$$$hl(tReslt.Duration)
		Set TestMethod = TestCaseId_"||"_tReslt.TestMethod
		Set tResult1 = ##class(%SQL.Statement).%ExecDirect(, "Select ID,Counter,Action,Status,Description,Location from %UnitTest_Result.TestAssert where TestMethod=?",TestMethod)
		While tResult1.%Next() {
			Write !, "| ",tResult1.Counter,?7," |",?9,tResult1.Action,?21," |",tResult1.Status,?50," |",?52,tResult1.Description,?62," |",?80,tResult1.Location
			If pageSize=$I(cPage) {
				w !,"(M)ore, (L)ine, (S)croll, (Q)uit? M => ",*-1 r ans#1 w $c(13),?IOM
				Set:ans="" ans="M"
				If $f("Qq",ans)>1 Return 1
				If ans="L" S cPage=pageSize+1
				Set ans = $$$UPPER(ans)
				If ans="M" Set cPage=0
				/*
				If $f("Qq",ans)>1 Set POP=1 q  
             If $f("Ss",ans)>1 Set nomore=1 q
             If $f("Mm",ans)>1 s $Y=0 q
             If $f("Ll ",ans)>1 q*/		
			}
		}
	}
	Return 1
}

}
