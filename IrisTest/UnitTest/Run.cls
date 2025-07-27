Class IrisTest.UnitTest.Run Extends %RegisteredObject
{

ClassMethod ShowUnitTestCases(UTFiles)
{
	Set dir=##class(%File).NormalizeDirectory(^UnitTestRoot)
	Set result=##class(%ResultSet).%New("%File:FileSet")
	Do result.Execute(dir,pMask)
	While result.Next() {
		Set UTFiles($I(I))=$LB(result.GetDataByName("ItemName"),result.GetDataByName("Name"))
	}
}

ClassMethod RunAll() [ CodeMode = expression ]
{
##class(IrisTest.UnitTest.Manager).RunAllTestCases()
}

ClassMethod OldRunAll(IsPrint) [ Deprecated ]
{
	Do ..ShowUnitTestCases(.Files)

	Set id=""
	For {
		Set id= $O(Files(id),1,file) q:id=""
		Write !, "Started running Testcase: "_$LG(Files(id))
		Hang 0.3
		Set sc = ..RunOneUnitTest($P($LG(Files(id)),"."),IsPrint)
		If $$$ISOK(sc) {
			Write !, " Testcase run successfully"
		}
		Else {
			write !, " Failed to run"
		}
	}
}

ClassMethod Run()
{
	Write !,"Test Directory: "_^UnitTestRoot,!
st	Do ..ShowUnitTestCases(.Files)
	Write !, "Available Files:"
	Set id=""
	For {
		Set id= $O(Files(id),1,file) q:id=""
		Write !, id_". ", $LG(file,1)
	}
	Write !
f1	Write !, "Select a file by number, or (Q) to quit:"
	Read fileId#$L($O(Files("")))
	If $ZCVT(fileId,"U")="Q" Quit 1
	If '$D(Files(fileId)) {
		GoTo f1
		Quit 1
	}
	Write !,"Print result? (Y/N) [Y]: "
	Read isPrint#1:30
	Set isPrint=$ZCVT(isPrint,"U")
	Set isPrint = $S(isPrint=""!(isPrint'="N")!(isPrint="Y"):1,1:0)
	Write !, "Started Executing..."
	;
	Set sc = ..RunOneUnitTest($LG(Files(fileId)),isPrint)
	If $$$ISOK(sc) {
		Write !, "Testcase run successfully"
	}
	Else {
		Write !, "Faile to run"
	}
	GoTo st
	Return 1
}

ClassMethod RunOneUnitTest(File, IsPrintLog)
{
	Return ##class(Manager).RunOneTest(File,IsPrintLog)
}

ClassMethod DeleteById(Id As %Integer)
{

	Return ##class(%UnitTest.Result.TestInstance).%DeleteId(Id)
}

}
