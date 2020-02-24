class Checker extends StatLogFile;

var string CLogFile, LogBuffer, PName;
var float SinceCLog;

function PostBeginPlay()
{
    local int i;
    local string tmpName, tmpChar;
	
	if (Owner != None)
	{
		tmpName = Pawn(Owner).PlayerReplicationInfo.PlayerName;
		for (i = 0; i < Len(tmpName); ++i)
		{
			tmpChar = Mid(tmpName, i, 1);
			if (InStr("ABCDEFGHIJKLMNOPQRSTUVWXYZ", Caps(tmpChar)) < 0)
				PName = PName$"_";
			else
				PName = PName$tmpChar;
		}
		CLogFile = "Checker-"$PName$"-"$GetShortAbsoluteTime()$".log";
	}
    InitWriter(CLogFile, "../Logs");
}

function InitWriter(string FileName, string FilePath)
{
    StatLogFile  = FilePath $ "/" $ FileName $ ".tmp";
    StatLogFinal = FilePath $ "/" $ FileName;
    OpenLog();
}

function WriteBuffer()
{
    local int i, outChar;
    local string tmpChar, outBuffer;
	
	if (Len(LogBuffer) == 0)
		return;
	
    for (i = 0; i < Len(LogBuffer); ++i)
    {
        tmpChar = Mid(LogBuffer, i, 1);

        if (i % 2 == 0)
        {
            outChar = Asc(tmpChar);
        }
        else
        {
            outChar   = outChar + (Asc(tmpChar) << 8);
            outBuffer = outBuffer $ chr(outChar);
            outChar   = 0;
        }
    }
	
    if (outChar != 0)
    {
        outChar   = outChar + (32 << 8);
        outBuffer = outBuffer $ chr(outChar);
    }

    Log("Logging " $ Len(outBuffer) $ " bytes.");
    FileLog(outBuffer);
    FlushLog();
	LogBuffer = "";
}

function CloseWriter()
{
	WriteBuffer();
    CloseLog();
}

simulated function Tick ( float DeltaTime )
{
	if (Pawn(Owner) == None)
	{
		Destroy();
		return;
	}
	
	SinceCLog += DeltaTime;
	if (SinceCLog > 5)
		WriteBuffer();
}

simulated function Destroyed()
{
	CLog("Stopped checking"@PName@"at"@GetShortAbsoluteTime()$".");
    LogBuffer = LogBuffer $ chr(13) $ chr(10) $ chr(13) $ chr(10) $ chr(13) $ chr(10); // append CR, LF
	CloseWriter();
}

function Timer(){}

function CLog(string Line)
{
	SinceCLog = 0;
	if (Instigator != None)
		Instigator.ClientMessage(PName$":"@Line);
    LogBuffer = LogBuffer $ Line $ chr(13) $ chr(10); // append CR, LF
}

defaultproperties
{
     CLogFile="Checker.log"
}
