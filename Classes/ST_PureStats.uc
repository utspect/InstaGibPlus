// ===============================================================
// Stats.S_Player: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_PureStats extends PureStats
	config(PureStats);

//	Stat Board:	Shots	Shots	Shot	Damage	Damage				Team		Special
// Ind.	Weapon Name	Fired	Hit	Hit%	Given	Taken	Kills	Deaths	Suici	Kills	Special	Desc
// 00	Unknown											x	Fall Damages
// 01	IH											x	Deflections
// 02	Transloc	(ok)	(kill)		-	-
// 03	Enforcer	25	12	48%	124	436	4	8			x	Dual Shots
// 04	Bio											x	Direct
// 05	Shock Pri										x	Excellent
// 06	Shock Sec										x	Blocked (blocked shots?)
// 07	Shock Combo										x	Standstill :X
// 08	SuperShock										x	Duo Airgibs (both in air)
// 09	Pulse Pri
// 10	Pulse Sec										x	Overload
// 11	Ripper Pri										x	Headshot
// 12	Ripper Sec										x	Direct
// 13	Minigun											x	8 Hit Streak.
// 14	Flak Chunk										x	Perfect +8
// 15	Flak Slug										x	Direct
// 16	Rocket											x	Direct
// 17	Pipe											x	Flying (Direct without bounce)
// 18	Sniper		135	55	40%	2520	1356	34	14			x	Headshot
// 19	Redeemer										x	Driven
//

//	Stat Board:			Special
// Ind. Item Name	Pickups	Spec.	Description
// 00	Unknown		0	?	?
// 01	Body Armor
// 02	Thigh Pads
// 03	Shieldbelt
// 04	Jumpboots			Kills
// 05	Dam. Amp.		x	Kills
// 06	Invisibility			Kills
// 07	Health +20
// 08	Health +5
// 09	Health +100
// 10	Relic: Death			Kills
// 11	Relic: Defense			Kills
// 12	Relic: Redeem			Kills
// 13	Relic: Regen			Kills
// 14	Relic: Speed			Kills
// 15	Relic: Strength			Kills

//	Spree board:
// Ind.	Spree Type	Count
// 00	Killing Spree	x
// 01	Rampage		x
// 02	Dominating	x
// 03	Unstoppable	x
// 04	Godlike		x

//	Multi board:
// Ind.	Multi Type	Count
// 00	Double		x
// 01	Multi		x
// 02	Ultra		x
// 03	Monster		x

//	CTF Board:			Special
// Ind.	CTF Event	Count	Spec.	Description
// 00	Flag Pickup	x	x	First Pickup	(ie, not takeover)
// 01	Flag Drops	x	x	By Death
// 02	Flag Kills	x
// 03	Flag Returns	x
// 04	Flag Assists	x
// 05	Flag Capture	x	x	Solo Run

// Let players choose some options
var config bool bNewMessages;
var config bool bTransparent;
var config color HeaderColor, DataColor[2], FontColor;

// Teh ownar
var PlayerPawn PPOwner;
var string ViewPlayerName;
var bool bReplicateStats;

// Teh Mutator stuff
var ST_Mutator STM;
var string PlayerName;		// Incase a player dis/reconnects.

// WEAPON VARIABLES (MAX 32)
const WeaponCount = 32;

struct WeaponStat {
	var int Fired, Hits;
	var int Given, Taken;
	var int Kills, Deaths, Suicides, TeamKills;
	var int Special;
};

var WeaponStat WeaponStats[32];
var int WeaponDisplay;		// Bitmapped int to decide if weapon should be displayed or not
var string DamageNames[32];
var string SpecialName[32];

var config int LastMonth;
var config WeaponStat CurrentStats[32], MonthlyStats[32], AllTimeStats[32];

// PICKUP VARIABLES (MAX 32)
const PickupCount = 32;

struct PickupStat {
	var int Pickups, Special;
};

var PickupStat PickupStats[32];
var Inventory HasInv[32];
var string PickupNames[32];
var string SpecialPName[32];
var PickupStat CurrentPStats[32];

// SPREE VARIABLES (5)
const SprCount = 5;

var int SpreeLevel;
var int SpreeCount[5];			// 0 = Killing, 1 = Rampage, 2 = Dominating, 3 = Unstoppable, 4 = Godlike
var config int CurrentSpreeCount[5], MonthlySpreeCount[5], AllTimeSpreeCount[5];
var string SpreeNames[5];

// MULTI VARIABLES (4)
const MultCount = 4;

var int MultiLevel;
var float LastMultiKill;
var int MultiCount[4];			// 0 = Double, 1 = Multi, 2 = Ultra, 3 = MONSTER
var config int CurrentMultiCount[4], MonthlyMultiCount[4], AllTimeMultiCount[4];
var string MultiNames[4];

// CTF VARIABLES (6)
const CTFCount = 6;

struct CTFStat {
	var int Count, Special;
};

var CTFStat CTFStats[6];
var config CTFStat CurrentCTFStats[6], MonthlyCTFStats[6], AllTimeCTFStats[6];
var string CTFNames[6];
var string CTFSName[6];
var bool bCTFGame;

// So we have something to display those funkeh numbers with
var FontInfo MyFonts;
var Texture BGTex;
var float OldClipX, FontHeight;

// WeaponStat display variables
var float wsName, wsFired, wsHit, wsHitP, wsGiven, wsTaken, wsKills, wsDeaths, wsSuici, wsTK, wsSpecial, wsSpecialName, wsWidth;

// PickupStat display variables
var float psName, psPickups, psSpecial, psSpecialName, psWidth;

// Spree display variables
var float spName, spCount, spWidth;

// Multi display variables
var float muName, muCount, muWidth;

// CTF display variables
var float ctName, ctCount, ctSpecial, ctSpecialName, ctWidth;

// To make sure everything is done replicating.
var bool bLastData;
var bool bSaveDataPending;

replication
{
	// Replicated variables Server -> Client, only when client wants stats displayed!
	reliable if (bNetOwner && ROLE == ROLE_Authority && bReplicateStats)	// Disabled for now, since I'm not entirely sure how it will affect end of game.
		ViewPlayerName, WeaponStats, PickupStats, SpreeCount, MultiCount, CTFStats, WeaponDisplay, bCTFGame, bLastData;
	// Replicated functions Server -> Client
	reliable if (ROLE == ROLE_Authority)
		SaveStats;
}

simulated function DoScreenSetup(Canvas Canvas)
{
	local float cDelta;

	OldClipX = Canvas.ClipX;

//				Shots	Shots	Shot	Damage	Damage				Team		Special
// (blank)	Weapon Name	Fired	Hit	Hit%	Given	Taken	Kills	Deaths	Suici	Kills	Special	Desc	(blank)
// 0.5x		3x		1x	1x	1x	1.5x	1.5x	1x	1x	1x	1x	1x	2x	0.5x	= 17
	cDelta = Canvas.ClipX / 17.0;	// 0.5 + 3.0 + 1.0 + 1.0 + 1.0 + 1.0 + 1.5 + 1.5 + 1.0 + 1.0 + 1.0 + 1.0 + 1.0 + 2.0 + 0.5

	wsName = cDelta * 0.5;
	wsFired = wsName + cDelta * 3.0;
	wsHit = wsFired + cDelta * 1.0;
	wsHitP = wsHit + cDelta * 1.0;
	wsGiven = wsHitP + cDelta * 1.0;
	wsTaken = wsGiven + cDelta * 1.5;
	wsKills = wsTaken + cDelta * 1.5;
	wsDeaths = wsKills + cDelta * 1.0;
	wsSuici = wsDeaths + cDelta * 1.0;
	wsTK = wsSuici + cDelta * 1.0;
	wsSpecial = wsTK + cDelta * 1.0;
	wsSpecialName = wsSpecial + cDelta * 1.0;
	wsWidth = wsSpecialName + cDelta * 2.0 - wsName;

//		Stat Board:			Special
// (blank)	Item Name	Pickups	Spec.	Description
// 0.5x		3x		1x	1x	2x
	psName = wsName;
	psPickups = wsFired;
	psSpecial = wsHit;
	psSpecialName = wsHitP;
	psWidth = cDelta * 7.0;

//		Spree board:, 0.5x beside Pickupstats.
// (blank)	Spree Type	Count	(blank)
// 0.5x		3x		1x	0.5

	spName = psName + psWidth + cDelta * 0.5;
	spCount = spName + cDelta * 3.0;
	spWidth = cDelta * 4.0;

//		Multi board:, 0.5x beside Spree board.
// (blank)	Multi Type	Count	(blank)
// 0.5x		3x		1x	0.5

	muName = spName + spWidth + cDelta * 0.5;
	muCount = muName + cDelta * 3.0;
	muWidth = cDelta * 4.0;

//		CTF Board:	(same position as Pickup stats, just lower)
// (blank)	CTF Event	Count	Spec.	Description
// 0.5x		3x		1x	1x	2x
	ctName = psName;
	ctCount = psPickups;
	ctSpecial = psSpecial;
	ctSpecialName = psSpecialName;
	ctWidth = psWidth;
}

simulated function WeaponStatDraw(Canvas Canvas, out float LocY)
{
	local int iFired, iHit, iGiven, iTaken, iKills, iDeaths, iSuici, iTK;
	local float fY;
	local int Line, x, Col;
	local WeaponStat Disp;
	local int DispW;

//		Shots	Shots	Shot	Damage	Damage				Team		Special
// Weapon Name	Fired	Hit	Hit%	Given	Taken	Kills	Deaths	Suici	Kills	Special	Desc
	Canvas.DrawColor = HeaderColor;
	fY = LocY;
	Canvas.SetPos(wsName,fY);
	Canvas.DrawTile(BGTex, wsWidth, FontHeight * 2.0, 0.0, 0.0, BGTex.USize, BGTex.VSize);
	Canvas.DrawColor = FontColor;
	Canvas.SetPos(wsFired, fY);
	Canvas.DrawText("Shots");
	Canvas.SetPos(wsHit, fY);
	Canvas.DrawText("Shots");
	Canvas.SetPos(wsHitP, fY);
	Canvas.DrawText("Shots");
	Canvas.SetPos(wsGiven, fY);
	Canvas.DrawText("Damage");
	Canvas.SetPos(wsTaken, fY);
	Canvas.DrawText("Damage");
	Canvas.SetPos(wsTK, fY);
	Canvas.DrawText("Team");
	Canvas.SetPos(wsSpecialName, fY);
	Canvas.DrawText("Special");

	fY += FontHeight;
	Canvas.SetPos(wsName, fY);
	Canvas.DrawText("Weapon Name");
	Canvas.SetPos(wsFired, fY);
	Canvas.DrawText("Fired");
	Canvas.SetPos(wsHit, fY);
	Canvas.DrawText("Hit");
	Canvas.SetPos(wsHitP, fY);
	Canvas.DrawText("Hit%");
	Canvas.SetPos(wsGiven, fY);
	Canvas.DrawText("Given");
	Canvas.SetPos(wsTaken, fY);
	Canvas.DrawText("Taken");
	Canvas.SetPos(wsKills, fY);
	Canvas.DrawText("Kills");
	Canvas.SetPos(wsDeaths, fY);
	Canvas.DrawText("Dead");
	Canvas.SetPos(wsSuici, fY);
	Canvas.DrawText("Suic.");
	Canvas.SetPos(wsTK, fY);
	Canvas.DrawText("Kills");
	Canvas.SetPos(wsSpecial, fY);
	Canvas.DrawText("Spec.");
	Canvas.SetPos(wsSpecialName, fY);
	Canvas.DrawText("Description");

	if (WhichStat == 0) DispW = WeaponDisplay;
	else DispW = 0xffffffff;			// Display all :P

	while (Line < WeaponCount && DamageNames[Line] != "")
	{
		if ((DispW & (1 << Line)) == 0)
		{	// Ignore this weapon
			Line++;
			Continue;
		}

		fY += FontHeight;	// Next line.

		if (WhichStat == 0) Disp = CurrentStats[Line];
		else if (WhichStat == 1) Disp = MonthlyStats[Line];
		else Disp = AllTimeStats[Line];

		// Render the background line.
		Canvas.DrawColor = DataColor[Col];
		Col = 1 - Col;
		Canvas.SetPos(wsName, fY);
		Canvas.DrawTile(BGTex, wsWidth, FontHeight, 0.0, 0.0, BGTex.USize, BGTex.VSize);
		// Now draw funneh text.
		Canvas.DrawColor = FontColor;
		Canvas.SetPos(wsName, fY);
		Canvas.DrawText(DamageNames[Line]);
		Canvas.SetPos(wsFired, fY);
		x = Disp.Fired;
		Canvas.DrawText(x);
		iFired += x;
		Canvas.SetPos(wsHit, fY);
		x = Disp.Hits;
		Canvas.DrawText(x);
		iHit += x;
		Canvas.SetPos(wsHitP, fY);
		if (Disp.Fired == 0)
			x = 0;
		else
			x = (Disp.Hits * 100) / Disp.Fired;
		Canvas.DrawText(x$"%");
		Canvas.SetPos(wsGiven, fY);
		x = Disp.Given;
		Canvas.DrawText(x);
		iGiven += x;
		Canvas.SetPos(wsTaken, fY);
		x = Disp.Taken;
		Canvas.DrawText(x);
		iTaken += x;
		Canvas.SetPos(wsKills, fY);
		x = Disp.Kills;
		Canvas.DrawText(x);
		iKills += x;
		Canvas.SetPos(wsDeaths, fY);
		x = Disp.Deaths;
		Canvas.DrawText(x);
		iDeaths += x;
		Canvas.SetPos(wsSuici, fY);
		x = Disp.Suicides;
		Canvas.DrawText(x);
		iSuici += x;
		Canvas.SetPos(wsTK, fY);
		x = Disp.TeamKills;
		Canvas.DrawText(x);
		iTK += x;
		Canvas.SetPos(wsSpecial, fY);
		Canvas.DrawText(Disp.Special);
		Canvas.SetPos(wsSpecialName, fY);
		Canvas.DrawText(SpecialName[Line]);
		Line++;
	}

	Canvas.DrawColor = HeaderColor;
	fY += FontHeight;
	Canvas.SetPos(wsName,fY);
	Canvas.DrawTile(BGTex, wsWidth, FontHeight, 0.0, 0.0, BGTex.USize, BGTex.VSize);

	Canvas.DrawColor = FontColor;
	Canvas.SetPos(wsName, fY);
	Canvas.DrawText("SUMS");
	Canvas.SetPos(wsFired, fY);
	Canvas.DrawText(iFired);
	Canvas.SetPos(wsHit, fY);
	Canvas.DrawText(iHit);
	Canvas.SetPos(wsHitP, fY);
	if (iFired == 0)
		x = 0;
	else
		x = (iHit * 100) / iFired;
	Canvas.DrawText(x$"%");
	Canvas.SetPos(wsGiven, fY);
	Canvas.DrawText(iGiven);
	Canvas.SetPos(wsTaken, fY);
	Canvas.DrawText(iTaken);
	Canvas.SetPos(wsKills, fY);
	Canvas.DrawText(iKills);
	Canvas.SetPos(wsDeaths, fY);
	Canvas.DrawText(iDeaths);
	Canvas.SetPos(wsSuici, fY);
	Canvas.DrawText(iSuici);
	Canvas.SetPos(wsTK, fY);
	Canvas.DrawText(iTK);
	Canvas.SetPos(wsSpecial, fY);
	x = iKills + iDeaths + iSuici + iTK;
	if (x != 0)
		x = (iKills * 100) / x;
	Canvas.DrawText(x$"%");
	Canvas.SetPos(wsSpecialName, fY);
	Canvas.DrawText("Efficiency");

	LocY = fY + FontHeight * 2.0;
}

simulated function PickupStatDraw(Canvas Canvas, out float LocY)
{
	local float fY;
	local int Line, Col;

	if (WhichStat != 0)
		return;			// Only show PickupStats for current match.

//					Special
//	Item Name	Pickups	Spec.	Description

	fY = LocY;
	Canvas.DrawColor = HeaderColor;
	Canvas.SetPos(psName, fY);
	Canvas.DrawTile(BGTex, psWidth, FontHeight * 2.0, 0.0, 0.0, BGTex.USize, BGTex.VSize);
	Canvas.DrawColor = FontColor;
	Canvas.SetPos(psSpecialName, fY);
	Canvas.DrawText("Special");

	fY += FontHeight;
	Canvas.SetPos(psName, fY);
	Canvas.DrawText("Item Name");
	Canvas.SetPos(psPickups, fY);
	Canvas.DrawText("Pickups");
	Canvas.SetPos(psSpecial, fY);
	Canvas.DrawText("Spec.");
	Canvas.SetPos(psSpecialName, fY);
	Canvas.DrawText("Description");

	while (Line < PickupCount && PickupNames[Line] != "")
	{
		if (CurrentPStats[Line].Pickups == 0)
		{
			Line++;
			continue;
		}
		fY += FontHeight;


		// Draw Background tile
		Canvas.DrawColor = DataColor[Col];
		Col = 1 - Col;
		Canvas.SetPos(psName, fY);
		Canvas.DrawTile(BGTex, psWidth, FontHeight, 0.0, 0.0, BGTex.USize, BGTex.VSize);

		Canvas.DrawColor = FontColor;
		Canvas.SetPos(psName, fY);
		Canvas.DrawText(PickupNames[Line]);
		Canvas.SetPos(psPickups, fY);
		Canvas.DrawText(CurrentPStats[Line].Pickups);
		Canvas.SetPos(psSpecial, fY);
		Canvas.DrawText(CurrentPStats[Line].Special);
		Canvas.SetPos(psSpecialName, fY);
		Canvas.DrawText(SpecialPName[Line]);

		Line++;
	}

	LocY = fY + FontHeight * 2.0;
}

simulated function SpreeStatDraw(Canvas Canvas, out float LocY)
{
	local float fY;
	local int Line, Col, Disp;

//	Spree Type	Count

	fY = LocY;
	Canvas.DrawColor = HeaderColor;
	Canvas.SetPos(spName, fY);
	Canvas.DrawTile(BGTex, spWidth, FontHeight , 0.0, 0.0, BGTex.USize, BGTex.VSize);
	Canvas.DrawColor = FontColor;
	Canvas.SetPos(spName, fY);
	Canvas.DrawText("Spree Name");
	Canvas.SetPos(spCount, fY);
	Canvas.DrawText("Count");

	while (Line < SprCount)
	{
		fY += FontHeight;

		if (WhichStat == 0) Disp = CurrentSpreeCount[Line];
		else if (WhichStat == 1) Disp = MonthlySpreeCount[Line];
		else Disp = AllTimeSpreeCount[Line];

		// Draw Background tile
		Canvas.DrawColor = DataColor[Col];
		Col = 1 - Col;
		Canvas.SetPos(spName, fY);
		Canvas.DrawTile(BGTex, spWidth, FontHeight, 0.0, 0.0, BGTex.USize, BGTex.VSize);

		Canvas.DrawColor = FontColor;
		Canvas.SetPos(spName, fY);
		Canvas.DrawText(SpreeNames[Line]);
		Canvas.SetPos(spCount, fY);
		Canvas.DrawText(Disp);

		Line++;
	}

	LocY = fY + FontHeight * 2.0;
}

simulated function MultiStatDraw(Canvas Canvas, out float LocY)
{
	local float fY;
	local int Line, Col, Disp;

//	Multi Type	Count

	fY = LocY;
	Canvas.DrawColor = HeaderColor;
	Canvas.SetPos(muName, fY);
	Canvas.DrawTile(BGTex, muWidth, FontHeight , 0.0, 0.0, BGTex.USize, BGTex.VSize);

	Canvas.DrawColor = FontColor;
	Canvas.SetPos(muName, fY);
	Canvas.DrawText("Multi Name");
	Canvas.SetPos(muCount, fY);
	Canvas.DrawText("Count");

	while (Line < MultCount)
	{
		fY += FontHeight;

		if (WhichStat == 0) Disp = CurrentMultiCount[Line];
		else if (WhichStat == 1) Disp = MonthlyMultiCount[Line];
		else Disp = AllTimeMultiCount[Line];

		// Draw Background tile
		Canvas.DrawColor = DataColor[Col];
		Col = 1 - Col;
		Canvas.SetPos(muName, fY);
		Canvas.DrawTile(BGTex, muWidth, FontHeight, 0.0, 0.0, BGTex.USize, BGTex.VSize);

		Canvas.DrawColor = FontColor;
		Canvas.SetPos(muName, fY);
		Canvas.DrawText(MultiNames[Line]);
		Canvas.SetPos(muCount, fY);
		Canvas.DrawText(Disp);

		Line++;
	}

	LocY = fY + FontHeight * 2.0;

}

simulated function CTFStatDraw(Canvas Canvas, out float LocY)
{
	local float fY;
	local int Line, Col;
	local CTFStat Disp;

//	CTF Board:			Special
// 	CTF Event	Count	Spec.	Description

	fY = LocY;
	Canvas.DrawColor = HeaderColor;
	Canvas.SetPos(ctName, fY);
	Canvas.DrawTile(BGTex, ctWidth, FontHeight * 2.0, 0.0, 0.0, BGTex.USize, BGTex.VSize);
	Canvas.DrawColor = FontColor;
	Canvas.SetPos(ctSpecialName, fY);
	Canvas.DrawText("Special");

	fY += FontHeight;
	Canvas.SetPos(ctName, fY);
	Canvas.DrawText("CTF Event");
	Canvas.SetPos(ctCount, fY);
	Canvas.DrawText("Count");
	Canvas.SetPos(ctSpecial, fY);
	Canvas.DrawText("Spec.");
	Canvas.SetPos(ctSpecialName, fY);
	Canvas.DrawText("Description");

	while (Line < CTFCount)
	{
		fY += FontHeight;

		if (WhichStat == 0) Disp = CurrentCTFStats[Line];
		else if (WhichStat == 1) Disp = MonthlyCTFStats[Line];
		else Disp = AllTimeCTFStats[Line];

		// Draw Background tile
		Canvas.DrawColor = DataColor[Col];
		Col = 1 - Col;
		Canvas.SetPos(ctName, fY);
		Canvas.DrawTile(BGTex, ctWidth, FontHeight, 0.0, 0.0, BGTex.USize, BGTex.VSize);

		Canvas.DrawColor = FontColor;
		Canvas.SetPos(ctName, fY);
		Canvas.DrawText(CTFNames[Line]);
		Canvas.SetPos(ctCount, fY);
		Canvas.DrawText(Disp.Count);
		Canvas.SetPos(ctSpecial, fY);
		Canvas.DrawText(Disp.Special);
		Canvas.SetPos(ctSpecialName, fY);
		Canvas.DrawText(CTFSName[Line]);

		Line++;
	}

	LocY = fY + FontHeight * 2.0;
}


simulated function PostRender(Canvas Canvas)
{
	local float YPos, YRem, YMax;
	local string TopInfo;
	local float tiOff;
	// Setup Style (Should perhaps use HUDs renderstyle?) ATM forced translucent
	Canvas.Font = MyFonts.GetSmallestFont(Canvas.ClipX);
	if (bTransparent)
		Canvas.Style = ERenderStyle.STY_Translucent;
	else
		Canvas.Style = ERenderStyle.STY_Normal;

	if (Canvas.ClipX != OldClipX)		// If screen size change, must recalc setup
		DoScreenSetup(Canvas);

	Canvas.DrawColor = HeaderColor;
	Canvas.SetPos(0, 0);
	Canvas.DrawTile(BGTex, Canvas.ClipX, FontHeight, 0.0, 0.0, BGTex.USize, BGTex.VSize);
	Canvas.DrawColor = FontColor;
	TopInfo = ViewPlayerName@"on"@Level.Title;
	if (PlayerPawn(Owner) != None)
		TopInfo = TopInfo$","@PlayerPawn(Owner).GameReplicationInfo.ServerName;
	Canvas.StrLen(TopInfo, tiOff, FontHeight);
	Canvas.SetPos((Canvas.ClipX - tiOff) * 0.5, 0);
	Canvas.DrawText(TopInfo);

	YPos = FontHeight * 2.0;
	// Draw Le Weapon Stats.
	WeaponStatDraw(Canvas, YPos);
	YRem = YPos;
	PickupStatDraw(Canvas, YPos);
	YMax = YPos;
	YPos = YRem;
	SpreeStatDraw(Canvas, YPos);
	if (YPos > YMax)
		YMax = YPos;
	YPos = YRem;
	MultiStatDraw(Canvas, YPos);
	if (YPos < YMax)
		YPos = YMax;
	if (bCTFGame)
		CTFStatDraw(Canvas, YPos);
}

function PostBeginPlay()
{
	if (ROLE == ROLE_Authority)	// Game doesn't exist on clients.
		bCTFGame = Level.Game.IsA('CTFGame');
	PPOwner = PlayerPawn(Owner);
	if (PPOwner != None)
		ViewPlayerName = PPOwner.PlayerReplicationInfo.PlayerName;
	Super.PostBeginPlay();
}

simulated function PostNetBeginPlay()
{
	// Here we will copy last game into recent month, recent month into all time high, and save.
	local int x;

	PPOwner = PlayerPawn(Owner);

	// First load a nice clientside font. Helps displaying things.
	MyFonts = FontInfo(spawn(Class<Actor>(DynamicLoadObject(class'ChallengeHUD'.default.FontInfoClass, class'Class'))));

	for (x = 0; x < WeaponCount; x++)
	{
		MonthlyStats[x].Fired += CurrentStats[x].Fired;
		CurrentStats[x].Fired = 0;
		MonthlyStats[x].Hits += CurrentStats[x].Hits;
		CurrentStats[x].Hits = 0;
		MonthlyStats[x].Given += CurrentStats[x].Given;
		CurrentStats[x].Given = 0;
		MonthlyStats[x].Taken += CurrentStats[x].Taken;
		CurrentStats[x].Taken = 0;
		MonthlyStats[x].Kills += CurrentStats[x].Kills;
		CurrentStats[x].Kills = 0;
		MonthlyStats[x].Deaths += CurrentStats[x].Deaths;
		CurrentStats[x].Deaths = 0;
		MonthlyStats[x].Suicides += CurrentStats[x].Suicides;
		CurrentStats[x].Suicides = 0;
		MonthlyStats[x].TeamKills += CurrentStats[x].TeamKills;
		CurrentStats[x].TeamKills = 0;
		MonthlyStats[x].Special += CurrentStats[x].Special;
		CurrentStats[x].Special = 0;
	}

	for (x = 0; x < SprCount; x++)
	{
		MonthlySpreeCount[x] += CurrentSpreeCount[x];
		CurrentSpreeCount[x] = 0;
	}

	for (x = 0; x < MultCount; x++)
	{
		MonthlyMultiCount[x] += CurrentMultiCount[x];
		CurrentMultiCount[x] = 0;
	}

	for (x = 0; x < CTFCount; x++)
	{
		MonthlyCTFStats[x].Count += CurrentCTFStats[x].Count;
		CurrentCTFStats[x].Count = 0;
		MonthlyCTFStats[x].Special += CurrentCTFStats[x].Special;
		CurrentCTFStats[x].Special = 0;
	}

	if (Level.Month != LastMonth)
	{
		for (x = 0; x < WeaponCount; x++)
		{
			AllTimeStats[x].Fired += MonthlyStats[x].Fired;
			MonthlyStats[x].Fired = 0;
			AllTimeStats[x].Hits += MonthlyStats[x].Hits;
			MonthlyStats[x].Hits = 0;
			AllTimeStats[x].Given += MonthlyStats[x].Given;
			MonthlyStats[x].Given = 0;
			AllTimeStats[x].Taken += MonthlyStats[x].Taken;
			MonthlyStats[x].Taken = 0;
			AllTimeStats[x].Kills += MonthlyStats[x].Kills;
			MonthlyStats[x].Kills = 0;
			AllTimeStats[x].Deaths += MonthlyStats[x].Deaths;
			MonthlyStats[x].Deaths = 0;
			AllTimeStats[x].Suicides += MonthlyStats[x].Suicides;
			MonthlyStats[x].Suicides = 0;
			AllTimeStats[x].TeamKills += MonthlyStats[x].TeamKills;
			MonthlyStats[x].TeamKills = 0;
			AllTimeStats[x].Special += MonthlyStats[x].Special;
			MonthlyStats[x].Special = 0;
		}

		for (x = 0; x < SprCount; x++)
		{
			AllTimeSpreeCount[x] += MonthlySpreeCount[x];
			MonthlySpreeCount[x] = 0;
		}

		for (x = 0; x < MultCount; x++)
		{
			AllTimeMultiCount[x] += MonthlyMultiCount[x];
			MonthlyMultiCount[x] = 0;
		}

		for (x = 0; x < CTFCount; x++)
		{
			AllTimeCTFStats[x].Count += MonthlyCTFStats[x].Count;
			MonthlyCTFStats[x].Count = 0;
			AllTimeCTFStats[x].Special += MonthlyCTFStats[x].Special;
			MonthlyCTFStats[x].Special = 0;
		}
	}
	LastMonth = Level.Month;

	SaveConfig();

	SetTimer(1.0, True);
}

simulated function Timer()
{
	local int x;
	local bool bSaveNow;

	bSaveNow = bSaveDataPending && bLastData;	// Pending save, and last data has arrived (HOPEFULLY!!!)

	if (!bShowStats && !bSaveNow)
		return;

	for (x = 0; x < WeaponCount; x++)
		CurrentStats[x] = WeaponStats[x];

	for (x = 0; x < PickupCount; x++)
		CurrentPStats[x] = PickupStats[x];

	for (x = 0; x < SprCount; x++)
		CurrentSpreeCount[x] = SpreeCount[x];

	for (x = 0; x < MultCount; x++)
		CurrentMultiCount[x] = MultiCount[x];

	for (x = 0; x < CTFCount; x++)
		CurrentCTFStats[x] = CTFStats[x];

	if (bSaveNow)
	{
		bSaveDataPending = False;
		SaveConfig();
	}
}
/*
function Tick(float deltaTime)
{
	if (Owner == None)
		Destroy();
}
*/

function SetState(byte b)
{	// This enables replication of stat data to client.
	Super.SetState(b);
	bReplicateStats = bShowStats || bLastData;
}

function CopyWS(int Index, out WeaponStat WS)
{
	WS = WeaponStats[Index];
}

function CopyPS(int Index, out PickupStat PS)
{
	PS = PickupStats[Index];
}

function CopySpree(int Index, out int Spree)
{	// ugh, dumb, but try to keep a style :x
	Spree = SpreeCount[Index];
}

function CopyMulti(int Index, out int Multi)
{
	Multi = MultiCount[Index];
}

function CopyCTF(int Index, out CTFStat CTF)
{
	CTF = CTFStats[Index];
}


function ClearStats()
{
	local int x;

	for (x = 0; x < WeaponCount; x++)
	{
		WeaponStats[x].Fired = 0;
		WeaponStats[x].Hits = 0;
		WeaponStats[x].Given = 0;
		WeaponStats[x].Taken = 0;
		WeaponStats[x].Kills = 0;
		WeaponStats[x].Deaths = 0;
		WeaponStats[x].Suicides = 0;
		WeaponStats[x].TeamKills = 0;
		WeaponStats[x].Special = 0;
	}

	for (x = 0; x < PickupCount; x++)
	{
		PickupStats[x].Pickups = 0;
		PickupStats[x].Special = 0;
	}

	for (x = 0; x < SprCount; x++)
		SpreeCount[x] = 0;

	for (x = 0; x < MultCount; x++)
		MultiCount[x] = 0;

	for (x = 0; x < CTFCount; x++)
	{
		CTFStats[x].Count = 0;
		CTFStats[x].Special = 0;
	}
}

simulated function SaveStats()
{
	if (Level.NetMode != NM_DedicatedServer)
		bSaveDataPending = True;
}

// These functions register stats. Since the WeaponStats array is too big, we have to provide functions to modify them :/
function RegisterShot(int Index)
{
	WeaponStats[Index].Fired++;
}

function UnregisterShot(int Index)
{	// For Combo's, need to unregister a ball & beam while doing combo.
	WeaponStats[Index].Fired--;
}

function RegisterSpecial(int Index)
{
	SendSpecialMessage(Index);
	WeaponStats[Index].Special++;
}

function RegisterGivenDamage(int Index, int Damage)
{	// Registers Damage given to others.
	WeaponStats[Index].Hits++;
	WeaponStats[Index].Given += Damage;
}

function RegisterTakenDamage(int Index, int Damage)
{	// Damage you are on the receiving end of.
	WeaponStats[Index].Taken += Damage;
}

function RegisterKill(int Index)
{	// Registers kills on others.
	local int x;

	WeaponStats[Index].Kills++;

	for (x = 0; x < PickupCount; x++)
		if (HasInv[x] != None)
			PickupStats[x].Special++;

	RegisterSpreeAdd();
}

function RegisterKillSelf(int Index)
{
	WeaponStats[Index].Suicides++;
	RegisterSpreeEnd();
}

function RegisterKillTeam(int Index)
{
	WeaponStats[Index].TeamKills++;
	RegisterSpreeAdd();
}

function RegisterDeath(int Index)
{
	WeaponStats[Index].Deaths++;
	RegisterSpreeEnd();
}

function RegisterPickup(Inventory Inv)
{
	local bool bKnow;
	local int Index;

	if (Inv.IsA('Weapon') || Inv.IsA('Ammo'))
		return;		// Ignore weapons and their ammo.

	Switch(Inv.Class.Name)		// Use .Name to allow support for other unknown (Not in editpackages) inventory.
	{
		Case 'Armor2':			Index = 1;
						break;
		Case 'ThighPads':		Index = 2;
						break;
		Case 'UT_Shieldbelt':		Index = 3;
						break;
		Case 'UT_Jumpboots':		Index = 4;
						bKnow = True;
						break;
		Case 'UDamage':			Index = 5;
						bKnow = True;
						break;
		Case 'UT_invisibility':		Index = 6;
						bKnow = True;
						break;
		Case 'MedBox':			if (Pawn(Owner).Health >= 100)
							return;
						Index = 7;
						break;
		Case 'HealthVial':		if (Pawn(Owner).Health >= 199)
							return;
						Index = 8;
						break;
		Case 'HealthPack':		if (Pawn(Owner).Health >= 199)
							return;
						Index = 9;
						break;
		Case 'RelicDeathInventory':	Index = 10;
						bKnow = True;
						break;
		Case 'RelicDefenseInventory':	Index = 11;
						bKnow = True;
						break;
		Case 'RelicRedemptionInventory':Index = 12;
						bKnow = True;
						break;
		Case 'RelicRegenInventory':	Index = 13;
						bKnow = True;
						break;
		Case 'RelicSpeedInventory':	Index = 14;
						bKnow = True;
						break;
		Case 'RelicStrengthInventory':	Index = 15;
						bKnow = True;
						break;
	}

	PickupStats[Index].Pickups++;
	if (bKnow)		// Want to remember this.
		HasInv[Index] = Inv;
}

function RegisterSpreeAdd()
{
	local int x;

	if (++SpreeLevel > 4)
	{
		switch (SpreeLevel)
		{
			Case 25: x++;
			Case 20: x++;
			Case 15: x++;
			Case 10: x++;
			Case 5: x++;
		}
		if (x != 0)
		{
			if (--x != 0)
				SpreeCount[x - 1]--;	// Remove 1 from level below.
			SpreeCount[x]++;		// And add one to this level.
		}
	}

	if (Level.TimeSeconds - LastMultiKill < 3.0)	// Less than 3 seconds since last.
	{
		if (MultiLevel != 0)
			MultiCount[MultiLevel - 1]--;	// Remove one from level below
		MultiCount[MultiLevel]++;		// And add one to this level
		MultiLevel++;				// And go up one multilevel
	}
	else
		MultiLevel = 0;				// Otherwise reset multi level.
	LastMultiKill = Level.TimeSeconds;
}

function RegisterSpreeEnd()
{
	SpreeLevel = 0;
	MultiLevel = 0;
	LastMultiKill = 0.0;
}

function RegisterFlagPickup(bool bFirst)
{
	CTFStats[0].Count++;
	if (bFirst)
		CTFStats[0].Special++;
}

function RegisterFlagDrop(bool bByDeath)
{
	CTFStats[1].Count++;
	if (bByDeath)
		CTFStats[1].Special++;
}

function RegisterFlagKill()
{
	CTFStats[2].Count++;
}

function RegisterFlagReturn(float Distance)
{
	CTFStats[3].Count++;
	if (Distance < 900.0)
	{
		SendSpecialMessage(102);
		CTFStats[3].Special++;
	}
}

function RegisterFlagAssist()
{
	SendSpecialMessage(100);
	CTFStats[4].Count++;
}

function RegisterFlagCap(bool bSolo)
{
	CTFStats[5].Count++;
	if (bSolo)
	{
		SendSpecialMessage(101);
		CTFStats[5].Special++;
	}
}

function SendSpecialMessage(int Index) {
	local Pawn P;
	if (PPOwner != None)
		PPOwner.ReceiveLocalizedMessage(Class'ST_SpecialMessage', Index, , , Self);

	for (P = Level.PawnList; P != none; P = P.NextPawn)
		if (P.IsA('PlayerPawn') && PlayerPawn(P).ViewTarget == PPOwner && P != PPOwner)
			P.ReceiveLocalizedMessage(Class'ST_SpecialMessage', Index, , , Self);
}

defaultproperties {
	bNewMessages=False
	bTransparent=False
	HeaderColor=(R=192,G=192,B=192)
	DataColor(0)=(G=192)
	DataColor(1)=(R=192)
	FontColor=(R=255,G=255,B=255)
	DamageNames(0)="Other/Special"
	SpecialName(0)="Fall Damage"
	DamageNames(1)="Impact Hammer"
	SpecialName(1)="Deflections"
	DamageNames(2)="Translocator"
	SpecialName(2)=""
	DamageNames(3)="Enforcer"
	SpecialName(3)="Dual Shots"
	DamageNames(4)="Bio Rifle"
	SpecialName(4)="Direct Hits"
	DamageNames(5)="Shock Beam"
	SpecialName(5)="Excellent"
	DamageNames(6)="Shock Ball"
	SpecialName(6)="Blocked"
	DamageNames(7)="Shock Combo"
	SpecialName(7)="Standstill"
	DamageNames(8)="Super Shock"
	SpecialName(8)="Dual Airgib"
	DamageNames(9)="Plasma Sphere"
	SpecialName(9)=""
	DamageNames(10)="Plasma Shaft"
	SpecialName(10)="Overload"
	DamageNames(11)="Razor Blade"
	SpecialName(11)="Headshots"
	DamageNames(12)="Razor Alt."
	SpecialName(12)="Direct Hits"
	DamageNames(13)="Minigun"
	SpecialName(13)="8 Hit Streaks"
	DamageNames(14)="Flak Chunk"
	SpecialName(14)="Perfect +8"
	DamageNames(15)="Flak Slug"
	SpecialName(15)="Direct Hits"
	DamageNames(16)="Rocket"
	SpecialName(16)="Direct Hits"
	DamageNames(17)="Grenade"
	SpecialName(17)="Flying Hits"
	DamageNames(18)="Sniper"
	SpecialName(18)="Headshots"
	DamageNames(19)="Redeemer"
	SpecialName(19)="Driven"
	PickupNames(0)="Other/Special"
	SpecialPName(0)=""
	PickupNames(1)="Body Armor"
	SpecialPName(1)=""
	PickupNames(2)="Thigh Pads"
	SpecialPName(2)=""
	PickupNames(3)="Shieldbelt"
	SpecialPName(3)=""
	PickupNames(4)="Jumpboots"
	SpecialPName(4)="Kills"
	PickupNames(5)="Dam. Amp."
	SpecialPName(5)="Kills"
	PickupNames(6)="Invisibility"
	SpecialPName(6)="Kills"
	PickupNames(7)="Health +20"
	SpecialPName(7)=""
	PickupNames(8)="Health +5"
	SpecialPName(8)=""
	PickupNames(9)="Health +100"
	SpecialPName(9)=""
	PickupNames(10)="Relic: Death"
	SpecialPName(10)="Kills"
	PickupNames(11)="Relic: Defense"
	SpecialPName(11)="Kills"
	PickupNames(12)="Relic: Redeem"
	SpecialPName(12)="Kills"
	PickupNames(13)="Relic: Regen"
	SpecialPName(13)="Kills"
	PickupNames(14)="Relic: Speed"
	SpecialPName(14)="Kills"
	PickupNames(15)="Relic: Strength"
	SpecialPName(15)="Kills"
	SpreeNames(0)="Killing Spree"
	SpreeNames(1)="Rampage"
	SpreeNames(2)="Dominating"
	SpreeNames(3)="Unstoppable"
	SpreeNames(4)="Godlike"
	MultiNames(0)="Double Kills"
	MultiNames(1)="Multi Kills"
	MultiNames(2)="Ultra Kills"
	MultiNames(3)="MONSTER KILLS"
	CTFNames(0)="Flag Pickups"
	CTFSName(0)="First Pickups"
	CTFNames(1)="Flag Drops"
	CTFSName(1)="By Death"
	CTFNames(2)="Flag Kills"
	CTFSName(2)=""
	CTFNames(3)="Flag Returns"
	CTFSName(3)="Close Calls!"
	CTFNames(4)="Flag Assists"
	CTFSName(4)=""
	CTFNames(5)="Flag Captures"
	CTFSName(5)="Solo Caps"
	BGTex=Texture'PureSWT'
}
