class PureHUDHelper extends Actor;

var bool bInOvertime;
var int OvertimeOffset;
var int EndOfGameTime;
var bool bPaused;
var float GRISecondCountOffset;

static function int GetClockTime(HUD H) {
	local int Rem;
	local TournamentGameReplicationInfo TGRI;

	TGRI = TournamentGameReplicationInfo(H.PlayerOwner.GameReplicationInfo);

	if (TGRI != none && (default.bPaused ^^ (H.Level.Pauser != ""))) {
		default.bPaused = !default.bPaused;
		if (default.bPaused) {
			default.GRISecondCountOffset = H.Level.TimeSeconds - TGRI.SecondCount;
		} else {
			TGRI.SecondCount = H.Level.TimeSeconds - default.GRISecondCountOffset;
		}
	}

	if (TGRI.GameEndedComments == "") {
		// game hasnt ended yet
		Rem = TGRI.RemainingTime;
		if (Rem == 0) {
			if (TGRI.TimeLimit <= 0) {
				// playing with score limit
				default.EndOfGameTime = TGRI.ElapsedTime;
			} else {
				// regular play-time is over
				if (default.bInOvertime == false)
					default.OvertimeOffset = TGRI.ElapsedTime;

				default.bInOvertime = true;
				default.EndOfGameTime = TGRI.ElapsedTime - default.OvertimeOffset;
			}
		} else {
			// playing with time limit
			default.bInOvertime = false;
			default.EndOfGameTime = Rem;
		}
	}

	return default.EndOfGameTime;
}

static function DrawTime(ChallengeHUD H, Canvas C) {
	local int Min, Sec;
	local float FullSize;
	local float X, Y;
	local float XL;
	local int Seconds;
	local float CharX, CharY;
	local float CharXScaled, CharYScaled;

	CharX = 25.0;
	CharY = 64.0;
	CharXScaled = CharX * H.Scale;
	CharYScaled = CharY * H.Scale;

	C.DrawColor = H.HUDColor;

	Seconds = GetClockTime(H);
	Min = Seconds / 60;
	Sec = Seconds % 60;

	if (Min >= 200)
		XL = 25; // extra full 7-Seg char
	else if (Min >= 100)
		XL = 15; // extra 1 as 7-Seg char
	else
		XL = 0;

	if (H.bHideStatus) {
		if (H.bHideAllWeapons) {
			X = 0.5*C.ClipX - 384*H.Scale - XL*H.Scale;
			Y = C.ClipY - 64*H.Scale;
		} else {
			X = C.ClipX - 140*H.Scale - XL*H.Scale;
			Y = 128*H.Scale;
		}
	} else {
		X = C.ClipX - 128*H.StatusScale*H.Scale - 140*H.Scale - XL*H.Scale;
		Y = 128*H.Scale;
	}

	C.SetPos(X,Y);
	C.DrawTile(Texture'PureTimeBG', 128*H.Scale + XL * H.Scale, 64*H.Scale, 0, 0, 128.0, 64.0);
	C.Style = H.Style;
	C.DrawColor = H.WhiteColor;

	X += XL * H.Scale;

	if (H.Level.bHighDetailMode)
		C.Style = ERenderStyle.STY_Translucent;

	FullSize = CharXScaled * 4 + 12 * H.Scale; //At least 4 digits and : (extra size not counted)

	C.SetPos( X + 64 * H.Scale, Y + 12 * H.Scale);
	C.CurX -= (FullSize / 2);
	if (Min >= 100) {
		C.CurX -= XL * H.Scale;
		C.DrawTile(Texture'BotPack.HudElements1', H.Scale*XL, CharYScaled, ((Min/100)%10)*CharX + (CharX - XL), 0, XL, CharY);
		Min = Min%100;
	}
	C.DrawTile(Texture'BotPack.HudElements1', CharXScaled, CharYScaled, (Min/10)*CharX, 0, CharX, CharY);
	C.DrawTile(Texture'BotPack.HudElements1', CharXScaled, CharYScaled, (Min%10)*CharX, 0, CharX, CharY);
	C.CurX -= 7 * H.Scale;
	C.DrawTile(Texture'BotPack.HudElements1', CharXScaled, CharYScaled, 25, 64, CharX, CharY); //DOUBLE DOT HERE
	C.CurX -= 6 * H.Scale;
	C.DrawTile(Texture'BotPack.HudElements1', CharXScaled, CharYScaled, (Sec/10)*CharX, 0, CharX, CharY);
	C.DrawTile(Texture'BotPack.HudElements1', CharXScaled, CharYScaled, (Sec%10)*CharX, 0, CharX, CharY);
}
