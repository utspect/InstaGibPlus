class IGPlus_NetStats extends Actor;

var ScriptedTexture OldTex;
var ScriptedTexture NewTex;

var float LocationError;
var float UnconfirmedTime;
var bool bInstantRelocation;
var float FrameTime;

var float LocErrScale; // pixel per uu
var float LocErrSize; // in pixel
var float UnconfirmedTimeScale; // pixel per second
var float UnconfirmedTimeSize; // in pixel
var float UnconfirmedTimeMinYellow; // in seconds
var float UnconfirmedTimeMinRed; // in seconds
var float FrameTimeScale; // pixel per second
var float FrameTimeSize; // in pixel
var float FrameTimeMinYellow; // in seconds
var float FrameTimeMinRed; // in seconds

var int Yellow;
var int Blue;
var int Red;
var int Green;

var transient ClientSettings Settings;

function PostBeginPlay() {
	OldTex.bMasked = true;
	NewTex.bMasked = true;
	OldTex.NotifyActor = self;
	NewTex.NotifyActor = self;
}

function DrawBar(ScriptedTexture T, float Y, float YL, int ColorIndex) {
	if (Y >= T.VSize)
		return;
	YL = FClamp(FMin(YL, T.VSize - Y), 0, T.VSize);
	T.DrawTile(T.USize - 2, Y, 1, YL, ColorIndex, 0, 1, 1, Texture'NetStatsBase', false);
}

function RenderTexture(ScriptedTexture T) {
	local float X;
	local float Y;

	local int LocErr;

	local int MoveTime;
	local int MoveTimeColor;

	local int FT;
	local int FTColor;

	if (T != NewTex)
		return;

	X = T.USize-2;
	Y = 0;

	// move everything over 1 pixel
	T.DrawTile(0, 0, X, OldTex.VSize, 1,0, X, OldTex.VSize, OldTex, false);
	// clear the entire vertical line
	DrawBar(T, 0, T.VSize, 0);

	if (Settings.bNetStatsUnconfirmedTime) {
		MoveTime = Min(int(UnconfirmedTime * UnconfirmedTimeScale), UnconfirmedTimeSize);
		if (UnconfirmedTime >= UnconfirmedTimeMinRed) {
			MoveTimeColor = Red;
		} else if (UnconfirmedTime >= UnconfirmedTimeMinYellow) {
			MoveTimeColor = Yellow;
		} else {
			MoveTimeColor = Blue;
		}

		Y += UnconfirmedTimeSize;
		DrawBar(T, Y - MoveTime, MoveTime, MoveTimeColor);
		Y += 10.0;
	}

	if (Settings.bNetStatsLocationError) {
		LocErr = Min(int(LocationError * LocErrScale), LocErrSize);

		if (bInstantRelocation) {
			DrawBar(T, Y, LocErrSize, Red);
		} else {
			DrawBar(T, Y+LocErrSize-LocErr, LocErr, Blue);
		}
		Y += LocErrSize;
		Y += 10.0;
	}

	if (Settings.bNetStatsFrameTime) {
		FT = Min(int(FrameTime * FrameTimeScale), FrameTimeSize);
		if (FrameTime >= FrameTimeMinRed)
			FTColor = Red;
		else if (FrameTime >= FrameTimeMinYellow)
			FTColor = Yellow;
		else
			FTColor = Green;

		DrawBar(T, Y+FrameTimeSize-FT, FT, FTColor);
		Y += FrameTimeSize;
		Y += 10.0;
	}
}

function PostRender(Canvas C, ClientSettings S) {
	local ScriptedTexture Temp;
	local int Width;
	local int Height;

	Settings = S;

	if (Settings.bEnableNetStats) {
		class'CanvasUtils'.static.SaveCanvas(C);
		
		C.Style = ERenderStyle.STY_Masked;
		C.DrawColor.R = 255;
		C.DrawColor.G = 255;
		C.DrawColor.B = 255;
		C.DrawColor.A = 255;

		Width = Clamp(Settings.NetStatsWidth, 1, NewTex.USize-1);
		Height = NewTex.VSize-1;

		C.SetPos((C.SizeX - Width) * Settings.NetStatsLocationX, (C.SizeY - Height) * Settings.NetStatsLocationY);
		C.DrawTile(NewTex, Width, Height, NewTex.USize-1-Width, 0, Width, Height);

		class'CanvasUtils'.static.RestoreCanvas(C);

		Temp = OldTex;
		OldTex = NewTex;
		NewTex = Temp;
	}

	bInstantRelocation = false;
}

defaultproperties {
	OldTex=ScriptedTexture'NetStats0';
	NewTex=ScriptedTexture'NetStats1';
	
	LocErrScale=1.0
	LocErrSize=50.0
	UnconfirmedTimeScale=200.0
	UnconfirmedTimeSize=68.0
	UnconfirmedTimeMinYellow=0.075
	UnconfirmedTimeMinRed=0.150
	FrameTimeScale=2500.0
	FrameTimeSize=50.0
	FrameTimeMinYellow=0.00833333333
	FrameTimeMinRed=0.01666666666

	Yellow=44
	Blue=32
	Red=40
	Green=48

	DrawType=DT_None
	bHidden=True
	RemoteRole=ROLE_None
}
