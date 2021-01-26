class bbPlayerStatics extends Actor;

var float AverageDeltaTime;
var float HitMarkerLifespan;
var float HitMarkerSize;

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

static function DrawCrosshair(Canvas C, ClientSettings Settings) {
	local float X, Y;
	local float XLength, YLength;
	local CrosshairLayer L;

	X = C.ClipX / 2;
	Y = C.ClipY / 2;

	class'CanvasUtils'.static.SaveCanvas(C);

	for (L = Settings.BottomLayer; L != none; L = L.Next) {
		XLength = L.ScaleX * L.Texture.USize;
		YLength = L.ScaleY * L.Texture.VSize;
		C.Style = L.Style;

		C.bNoSmooth = (L.bSmooth == false);
		C.SetPos(
			X - 0.5 * XLength + L.OffsetX,
			Y - 0.5 * YLength + L.OffsetY);
		C.DrawColor = L.Color;
		C.DrawTile(L.Texture, XLength, YLength, 0, 0, L.Texture.USize, L.Texture.VSize);
	}

	class'CanvasUtils'.static.RestoreCanvas(C);
}

static function PlayHitMarker(ClientSettings Settings, float Damage) {
	local float Size;
	Size = (FClamp(Damage/150, 0.0, 1.0) * 0.75 + 0.25) * Settings.HitMarkerSize;
	if (Size >= default.HitMarkerSize || default.HitMarkerLifespan == 0.0) {
		default.HitMarkerLifespan = Settings.HitMarkerDuration;
		default.HitMarkerSize = Size;
	}
}

static function DrawHitMarker(Canvas C, ClientSettings Settings, float DeltaTime) {
	local float MarkerSize;
	local float MarkerOffset;

	if (Settings.bEnableHitMarker == false) return;

	class'CanvasUtils'.static.SaveCanvas(C);

	MarkerSize = default.HitMarkerSize;
	MarkerOffset = Settings.HitMarkerOffset;

	C.Style = ERenderStyle.STY_Translucent;
	C.bNoSmooth = false;
	C.DrawColor = Settings.HitMarkerColor * ((default.HitMarkerLifespan/Settings.HitMarkerDuration) ** Settings.HitMarkerDecayExponent);
	C.SetPos(C.SizeX/2 - MarkerOffset - MarkerSize, C.SizeY/2 - MarkerOffset - MarkerSize);
	C.DrawTile(texture'HitMarkerArrow', MarkerSize, MarkerSize, 0, 0, 512, 512);
	C.SetPos(C.SizeX/2 + MarkerOffset, C.SizeY/2 - MarkerOffset - MarkerSize);
	C.DrawTile(texture'HitMarkerArrow', MarkerSize, MarkerSize, 0, 0, -512, 512);
	C.SetPos(C.SizeX/2 - MarkerOffset - MarkerSize, C.SizeY/2 + MarkerOffset);
	C.DrawTile(texture'HitMarkerArrow', MarkerSize, MarkerSize, 0, 0, 512, -512);
	C.SetPos(C.SizeX/2 + MarkerOffset, C.SizeY/2 + MarkerOffset);
	C.DrawTile(texture'HitMarkerArrow', MarkerSize, MarkerSize, 0, 0, -512, -512);

	class'CanvasUtils'.static.RestoreCanvas(C);

	default.HitMarkerLifespan = FMax(0.0, default.HitMarkerLifespan - DeltaTime);
}

/**
 * Plays response to client-side hits
 */
static function PlayClientHitResponse(
	Pawn Instigator,
	Actor Victim,
	float Damage,
	name DamageType
) {
	local bbPlayer P;

	if (Victim.IsA('Pawn') == false)
		return;

	if (Instigator.IsA('bbPlayer') == false)
		return;

	if (Instigator.Level.Game.GameReplicationInfo.bTeamGame == true &&
		Instigator.PlayerReplicationInfo.Team == Pawn(Victim).PlayerReplicationInfo.Team)
		return;

	P = bbPlayer(Instigator);
	if (P.Settings.HitMarkerSource == 1)
		PlayHitMarker(P.Settings, Damage);

	if (P.Settings.bEnableHitSounds)
		P.ClientPlaySound(P.playedHitSound);
}
