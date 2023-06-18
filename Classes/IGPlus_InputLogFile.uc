class IGPlus_InputLogFile extends StatLogFile;

var string LogId;
var bool bStarted;

event BeginPlay() {
    // empty to override StatLog
}

function string PadTo2Digits(int A) {
    if (A < 10)
        return "0"$A;
    return string(A);
}

function StartLog() {
    local string FileName;

    bWorld = false;
    FileName = "../Logs/"$LogId$"_"$Level.Year$PadTo2Digits(Level.Month)$PadTo2Digits(Level.Day)$"_"$PadTo2Digits(Level.Hour)$PadTo2Digits(Level.Minute);
    StatLogFile = FileName$".tmp.csv";
    StatLogFinal = FileName$".csv";

    OpenLog();

    // header
    FileLog("Type|TimeStamp|Delta|Forw|Back|Left|Right|Walk|Duck|Jump|Dodge|Fire|AltFire|ViewRot|Location|Velocity");

    bStarted = true;
}

function StopLog() {
	if (bStarted == false)
		return;
	FlushLog();
	CloseLog();
	bStarted = false;
}

function LogInput(IGPlus_SavedInput I) {
	if (bStarted == false)
		StartLog();

	FileLog("Input|"$I.TimeStamp$"|"$I.Delta$"|"$I.bForw$"|"$I.bBack$"|"$I.bLeft$"|"$I.bRigh$"|"$I.bWalk$"|"$I.bDuck$"|"$I.bJump$"|"$I.bDodg$"|"$I.bFire$"|"$I.bAFir$"|"$(I.SavedViewRotation.Pitch&0xFFFF)$","$(I.SavedViewRotation.Yaw&0xFFFF)$"|"$I.SavedLocation$"|"$I.SavedVelocity);
}

function LogCAP(float TimeStamp, vector Loc, vector Vel, Actor NewBase) {
	if (bStarted == false)
		StartLog();
	
	if (Mover(NewBase) != none)
		Loc += NewBase.Location;

	FileLog("CAP|"$TimeStamp$"|||||||||||||"$Loc$"|"$Vel);
}

function LogInputReplay(IGPlus_SavedInput I) {
	if (bStarted == false)
		StartLog();

	FileLog("Replay|"$I.TimeStamp$"|"$I.Delta$"|"$I.bForw$"|"$I.bBack$"|"$I.bLeft$"|"$I.bRigh$"|"$I.bWalk$"|"$I.bDuck$"|"$I.bJump$"|"$I.bDodg$"|"$I.bFire$"|"$I.bAFir$"|"$(I.SavedViewRotation.Pitch&0xFFFF)$","$(I.SavedViewRotation.Yaw&0xFFFF)$"|"$I.SavedLocation$"|"$I.SavedVelocity);
}
