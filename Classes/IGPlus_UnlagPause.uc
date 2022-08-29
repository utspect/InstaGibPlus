class IGPlus_UnlagPause extends Actor
	transient;

var string LastPauser;
var float LevelNetUpdFreq;
var float LevelNetPrio;

event Tick(float DeltaTime) {
	if (Level.Pauser != LastPauser) {
		LastPauser = Level.Pauser;
		LevelNetUpdFreq = Level.NetUpdateFrequency;
		LevelNetPrio = Level.NetPriority;
		Level.NetUpdateFrequency = 1000;
		Level.NetPriority *= 2;
		SetTimer(0.5 * Level.TimeDilation, false);
	}
}

event Timer() {
	Level.NetUpdateFrequency = LevelNetUpdFreq;
	Level.NetPriority = LevelNetPrio;
}

defaultproperties {
	bHidden=True
	DrawType=DT_None
	RemoteRole=ROLE_None
	bAlwaysTick=True
}
