ROUTINE IrisTest [Type=INC]
#; globals
#define ITestLibRoot 			^IrisTest
#define ITestLibReport			^IrisTest.UTReport
#define UTReport				^IrisTest.UTReport
#define UTRoot					^UnitTestRoot
#Define ITestLibVersion			^IrisTest.Version
#Define ITestLibHist			^IrisTest.History
#define ITestLibLogErr(%err)		Set ^IrisTest.Error($ZDT($NOW()),$USERNAME)=%err
#Define ITestLibLogHist(%username,%h,%cmd)  Set ^IrisTest.History(%username,%h)=%cmd
#define SysTempDir				^%SYS("TempDir")

#; colors
#define ControlSequence(%format) $C(27)_"["_%format_"m"

#define FormattedLine(%formatCode, %text) $$$ControlSequence(%formatCode)_%text_$$$ControlSequence($$$ResetAll)

#def1arg ReportCls(%format)		"IrisTest.Report."_%format
#Define ReportMethod			"Generate"

#def1arg IsClsExist(%cls)		##class(%Dictionary.CompiledClass).%ExistsId(%cls)

#; All font formats (bold, underline etc.)
#define Bold 1
#define Bright 1
#define Dim 2
#define Underlined 4
#define Blink 5
#define Reverse 7
#define Hidden 8

#; All text colors in foreground
#define Default 39
#define Black 30
#define Red 31
#define Green 32
#define Yellow 33
#define Blue 34
#define Magenta 35
#define Cyan 36
#define White 97
#define GreenHlght 42
#; All font format resets
#define ResetAll 0

#; default right margin
#define drm		80
#define dpz		24


#;
#define verticalBar $CHAR(9474)
#define TL			$CHAR(9581), $CHAR(9472)
#define TR			$CHAR(9472), $CHAR(9582)
#define BL			$CHAR(9584), $CHAR(9472)
#define BR			$CHAR(9472), $CHAR(9583)
#; light horizontal line
#define LHL			$CHAR(9472)
#; light vertical line
#define LVL 		$CHAR(9474)

#define IsHelp      "?"

#; string formats
#define NL              !
#def1arg Upper(%str)	$ZCVT(%str,"U")
#define DisableUndef    Do $ZUtil(18,2)
#; time
#define DTNOW			$ZDT($NOW())

#; versions

#define defaultVersion "0.1.0"
#define CurrentVersion	"0.1.0"
#define Instance		$P($SYSTEM,":",2)
#define System			$P($SYSTEM,":")
