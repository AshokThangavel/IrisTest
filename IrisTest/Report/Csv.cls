Class IrisTest.Report.Csv Extends Base
{

Parameter FileExtension As STRING = "csv";

Method OnGenerate(Output fileName As %String = {..GetFileName()}) [ CodeMode = expression ]
{
##class(Utils).generateFile(..UnitTestId,fileName)
}

}
