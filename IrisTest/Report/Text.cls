Class IrisTest.Report.Text Extends Base
{

Parameter FileExtension As STRING = "txt";

Method OnGenerate(Output fileName As %String = {..GetFileName()}) [ CodeMode = expression ]
{
##class(Utils).generateFile(..UnitTestId,fileName)
}

}
