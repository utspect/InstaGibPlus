class bbPlayerStatics extends Actor;

var float AverageDeltaTime;
var float HitMarkerLifespan;
var float HitMarkerSize;
var color HitMarkerColor;
var color HitMarkerTeamColors[4];

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

static function PlayHitMarker(PlayerPawn Me, ClientSettings Settings, float Damage, int OwnTeam, int EnemyTeam) {
	local float Size;
	local color HMColor;
	local bool bEnable;

	Size = (FClamp(Damage/150, 0.0, 1.0) * 0.75 + 0.25) * Settings.HitMarkerSize;
	bEnable = Settings.bEnableHitMarker;
	if (Me.GameReplicationInfo.bTeamGame == false) {
		HMColor = Settings.HitMarkerColor;
	} else {
		if (OwnTeam == EnemyTeam)
			bEnable = Settings.bEnableTeamHitMarker;

		if (Settings.HitMarkerColorMode == 0) {
			if (OwnTeam == EnemyTeam) {
				HMColor = Settings.HitMarkerTeamColor;
			} else {
				HMColor = Settings.HitMarkerColor;
			}
		} else if (Settings.HitMarkerColorMode == 1) {
			if (EnemyTeam >= 0 && EnemyTeam < arraycount(default.HitMarkerTeamColors)) {
				HMColor = default.HitMarkerTeamColors[EnemyTeam];
			} else {
				HMColor = Settings.HitMarkerColor;
			}
		}
	}

	if (bEnable && (Size >= default.HitMarkerSize || default.HitMarkerLifespan == 0.0)) {
		default.HitMarkerLifespan = Settings.HitMarkerDuration;
		default.HitMarkerSize = Size;
		default.HitMarkerColor = HMColor;
	}
}

static function DrawHitMarker(Canvas C, ClientSettings Settings, float DeltaTime) {
	local float MarkerSize;
	local float MarkerOffset;

	class'CanvasUtils'.static.SaveCanvas(C);

	MarkerSize = default.HitMarkerSize;
	MarkerOffset = Settings.HitMarkerOffset;

	C.Style = ERenderStyle.STY_Translucent;
	C.bNoSmooth = false;
	C.DrawColor = default.HitMarkerColor * ((default.HitMarkerLifespan/Settings.HitMarkerDuration) ** Settings.HitMarkerDecayExponent);
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
	local int InstigatorTeam, VictimTeam;

	if (Victim.IsA('Pawn') == false)
		return;

	if (Instigator.IsA('bbPlayer') == false)
		return;

	InstigatorTeam = Instigator.PlayerReplicationInfo.Team;
	VictimTeam = Pawn(Victim).PlayerReplicationInfo.Team;

	P = bbPlayer(Instigator);
	if (P.Settings.HitMarkerSource == 1)
		PlayHitMarker(P, P.Settings, Damage, InstigatorTeam, VictimTeam);

	if (Instigator.Level.Game.GameReplicationInfo.bTeamGame == true &&
		InstigatorTeam == VictimTeam)
		return;

	if (P.Settings.bEnableHitSounds)
		P.ClientPlaySound(P.playedHitSound);
}

defaultproperties {
	HitMarkerTeamColors(0)=(R=255,G=0,B=0,A=255)
	HitMarkerTeamColors(1)=(R=0,G=0,B=255,A=255)
	HitMarkerTeamColors(2)=(R=0,G=255,B=0,A=255)
	HitMarkerTeamColors(3)=(R=255,G=200,B=0,A=255)
}
