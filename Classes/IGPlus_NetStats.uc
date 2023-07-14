class IGPlus_NetStats extends Actor;

#EXEC LOAD FILE="Textures/IGPlusNetStats.utx" PACKAGE=InstaGibPlus.NetStats

var ScriptedTexture OldTex;
var ScriptedTexture NewTex;

var float LocationError;
var float UnconfirmedTime;
var bool bInstantRelocation;

var float LocErrScale;
var float UnconfirmedTimeScale;

var int Yellow;
var int Blue;
var int Red;

function PostBeginPlay() {
	OldTex.bMasked = true;
	NewTex.bMasked = true;
	OldTex.NotifyActor = self;
	NewTex.NotifyActor = self;
}

function RenderTexture(ScriptedTexture T) {
	local Texture OldT;
	local float X;
	local float YL;

	local int LocErrOffset;
	local int LocErr;

	local int MoveTimeOffset;
	local int MoveTime;
	local int MoveTimeColor;

	if (T != NewTex)
		return;

	OldT = OldTex;
	X = T.USize-2;
	YL = T.VSize-1;

	LocErrOffset = YL;
	LocErr = Min(1 + int(LocationError / LocErrScale), 50);

	MoveTimeOffset = YL - 60;
	MoveTime = Min(1 + int(UnconfirmedTime / UnconfirmedTimeScale), 68);
	if (MoveTime < 15) {
		MoveTimeColor = Blue;
	} else if (MoveTime < 30) {
		MoveTimeColor = Yellow;
	} else {
		MoveTimeColor = Red;
	}
	
	// move everything over 1 pixel
	T.DrawTile(0, 0, X, OldT.VSize, 1,0, X, OldT.VSize, OldT, false);
	// clear the entire vertical line
	T.DrawTile(X, 0, 1, T.VSize, 0, 0, 1, 1, Texture'NetStatsBase', false);

	// draw new stuff
	if (bInstantRelocation) {
		T.DrawTile(X, LocErrOffset - 50, 1, 50, Red, 0, 1, 1, Texture'NetStatsBase', false);
	} else {
		T.DrawTile(X, LocErrOffset - LocErr, 1, LocErr, Blue, 0, 1, 1, Texture'NetStatsBase', false);
	}

	T.DrawTile(X, MoveTimeOffset - MoveTime, 1, MoveTime, MoveTimeColor, 0, 1, 1, Texture'NetStatsBase', false);
}

function PostRender(Canvas C, ClientSettings Settings) {
	local ScriptedTexture Temp;

	if (Settings.bEnableNetStats) {
		class'CanvasUtils'.static.SaveCanvas(C);
		
		C.Style = ERenderStyle.STY_Masked;
		C.DrawColor.R = 255;
		C.DrawColor.G = 255;
		C.DrawColor.B = 255;
		C.DrawColor.A = 255;

		C.SetPos((C.SizeX - NewTex.USize) * 0.5, 0);
		C.DrawTile(NewTex, NewTex.USize-1, NewTex.VSize-1, 0, 0, NewTex.USize-1, NewTex.VSize-1);

		class'CanvasUtils'.static.RestoreCanvas(C);
	}

	Temp = OldTex;
	OldTex = NewTex;
	NewTex = Temp;

	bInstantRelocation = false;
}

defaultproperties {
	OldTex=ScriptedTexture'NetStats0';
	NewTex=ScriptedTexture'NetStats1';
	
	LocErrScale=1.0
	UnconfirmedTimeScale=0.005

	Yellow=3
	Blue=1
	Red=2

	DrawType=DT_None
	bHidden=True
	RemoteRole=ROLE_None
}
