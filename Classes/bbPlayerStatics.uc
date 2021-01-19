class bbPlayerStatics extends Actor;

var float AverageDeltaTime;

static function DrawFPS(Canvas C, HUD MyHud, ClientSettings Settings, float DeltaTime) {
	local string FPS;
	local float X,Y;

	if (Settings.bShowFPS == false) return;

	default.AverageDeltaTime = (default.AverageDeltaTime * float(Settings.FPSCounterSmoothingStrength - 1) + DeltaTime) / float(Settings.FPSCounterSmoothingStrength);

	class'CanvasUtils'.static.SaveCanvas(C);

	FPS = class'StringUtils'.static.FormatFloat(MyHud.Level.TimeDilation/default.AverageDeltaTime, 1);
	C.Style = ERenderStyle.STY_Translucent;
	C.DrawColor = ChallengeHud(MyHud).WhiteColor;
	C.Font = ChallengeHud(MyHud).MyFonts.GetSmallFont(C.ClipX);
	C.TextSize(FPS, X, Y);
	C.SetPos(C.ClipX - X, 0);
	C.DrawText(FPS);

	class'CanvasUtils'.static.RestoreCanvas(C);
}

