class PureHUDHelper extends Actor;

var bool bInOvertime;
var int OvertimeOffset;

static function int GetClockTime(HUD H) {
	local int Rem;
	local TournamentGameReplicationInfo TGRI;

	TGRI = TournamentGameReplicationInfo(H.PlayerOwner.GameReplicationInfo);
	Rem = TGRI.RemainingTime;
	if (Rem == 0) {
		if (TGRI.TimeLimit <= 0)
			return TGRI.ElapsedTime;

		if (default.bInOvertime == false)
			default.OvertimeOffset = TGRI.ElapsedTime;

		default.bInOvertime = true;
		return TGRI.ElapsedTime - default.OvertimeOffset;
	} else {
		default.bInOvertime = false;
	}

	return Rem;
}

static function DrawTime(ChallengeHUD H, Canvas C, float X, float Y) {
	local int Min, Sec;
	local float FullSize;
	local float XL;
	local int Seconds;

	C.DrawColor = H.HUDColor;

	Seconds = GetClockTime(H);

	XL = 0;
	if (Seconds >= 200*60)
		XL = 25;
	else if (Seconds >= 100*60)
		XL = 15;

	if (H.bHideStatus && H.bHideAllWeapons) {
		X = 0.5*C.ClipX - 384*H.Scale - XL*H.Scale;
		Y = C.ClipY - 64*H.Scale;
	} else {
		X = C.ClipX - 128*H.StatusScale*H.Scale - 140*H.Scale - XL*H.Scale;
		Y = 128*H.Scale;
	}

	C.SetPos(X,Y);
	C.DrawTile(Texture'PureTimeBG', 128*H.Scale + XL * H.Scale, 64*H.Scale, 0, 0, 128.0, 64.0);
	C.Style = H.Style;
	C.DrawColor = H.WhiteColor;

	Min = Seconds / 60;
	Sec = Seconds % 60;
	X += XL * H.Scale;

	if (H.Level.bHighDetailMode)
		C.Style = ERenderStyle.STY_Translucent;

	FullSize = 25 * H.Scale * 4 + 16 * H.Scale; //At least 4 digits and : (extra size not counted)

	C.SetPos( X + 64 * H.Scale, Y + 12 * H.Scale);
	C.CurX -= (FullSize / 2);
	if (Min >= 100) {
		C.CurX -= XL * H.Scale;
		C.DrawTile(Texture'BotPack.HudElements1', H.Scale*XL, 64*H.Scale, ((Min / 100)%10) * 25 + (25 - XL), 0, XL, 64.0);
	}
	C.DrawTile(Texture'BotPack.HudElements1', H.Scale*25, 64*H.Scale, ((Min/10)%10) *25, 0, 25.0, 64.0);
	C.DrawTile(Texture'BotPack.HudElements1', H.Scale*25, 64*H.Scale, (Min%10)*25, 0, 25.0, 64.0);
	C.CurX -= 6 * H.Scale;
	C.DrawTile(Texture'BotPack.HudElements1', H.Scale*25, 64*H.Scale, 25, 64, 25.0, 64.0); //DOUBLE DOT HERE
	C.CurX -= 6 * H.Scale;
	C.DrawTile(Texture'BotPack.HudElements1', H.Scale*25, 64*H.Scale, ((Sec/10)%10) *25, 0, 25.0, 64.0);
	C.DrawTile(Texture'BotPack.HudElements1', H.Scale*25, 64*H.Scale, (Sec%10)*25, 0, 25.0, 64.0);
}
