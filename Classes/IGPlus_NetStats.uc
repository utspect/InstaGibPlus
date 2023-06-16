class IGPlus_NetStats extends Actor;

#EXEC LOAD FILE="Textures/IGPlusNetStats.utx" PACKAGE=InstaGibPlus.NetStats

var ScriptedTexture Tex[2];

var float LocationError;
var float UnconfirmedTime;
var bool bInstantRelocation;

var float LocErrScale;
var float UnconfirmedTimeScale;

var int IndexNew;
var int IndexOld;

var int Yellow;
var int Blue;
var int Red;

function PostBeginPlay() {
	Tex[0].bMasked = true;
	Tex[1].bMasked = true;
	Tex[0].NotifyActor = self;
	Tex[1].NotifyActor = self;
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

	if (T != Tex[IndexNew])
		return;

	OldT = Tex[IndexOld];
	X = T.USize-2;
	YL = T.VSize-1;

	LocErrOffset = YL;
	LocErr = Min(1 + int(LocationError / LocErrScale), 50);

	MoveTimeOffset = YL - 60;
	MoveTime = Min(1 + int(UnconfirmedTime / UnconfirmedTimeScale), 60);
	if (MoveTime < 15) {
		MoveTimeColor = Blue;
	} else if (MoveTime < 40) {
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

function PostRender(Canvas C) {
	local int Temp;

	class'CanvasUtils'.static.SaveCanvas(C);
	
	C.Style = ERenderStyle.STY_Masked;
	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;
	C.DrawColor.A = 255;

	C.SetPos((C.SizeX - Tex[IndexNew].USize) * 0.5, 0);
	C.DrawTile(Tex[IndexNew], Tex[IndexNew].USize-1, Tex[IndexNew].VSize-1, 0, 0, Tex[IndexNew].USize-1, Tex[IndexNew].VSize-1);

	class'CanvasUtils'.static.RestoreCanvas(C);

	Temp = IndexOld;
	IndexOld = IndexNew;
	IndexNew = Temp;

	bInstantRelocation = false;
}

defaultproperties {
	LocErrScale=1.0
	UnconfirmedTimeScale=0.005

	Tex(0)=ScriptedTexture'NetStats0';
	Tex(1)=ScriptedTexture'NetStats1';
	IndexNew=0
	IndexOld=1
	Yellow=3
	Blue=1
	Red=2

	DrawType=DT_None
	bHidden=True
	RemoteRole=ROLE_None
}
