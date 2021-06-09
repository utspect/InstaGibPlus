// ===============================================================
// UTPureStats7A.ST_PureStatsSpec: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_PureStatsSpec extends ST_PureStats;

// A Gross hack to make it possible to spectate other peoples stats...

var ST_PureStats StatSource;

simulated function SaveStats();		// Nono.

simulated function PostNetBeginPlay()
{
	// First load a nice clientside font. Helps displaying things.
	MyFonts = FontInfo(spawn(Class<Actor>(DynamicLoadObject(class'ChallengeHUD'.default.FontInfoClass, class'Class'))));

	SetTimer(1.0, True);
}

function PostBeginPlay()
{
	SetTimer(1.0, True);

	// Find master Mutator
	ForEach AllActors(Class'ST_Mutator', STM)
		break;

	Super.PostBeginPlay();
}

simulated function Timer()
{
	local int x;

	if (ROLE < ROLE_Authority)
	{	// Client
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
	}
	else
	{	// Server
		FindStatSource();
		if (StatSource == None)
			return;

		for (x = 0; x < WeaponCount; x++)
			StatSource.CopyWS(x, WeaponStats[x]);

		for (x = 0; x < PickupCount; x++)
			StatSource.CopyPS(x, PickupStats[x]);

		for (x = 0; x < SprCount; x++)
			StatSource.CopySpree(x, SpreeCount[x]);

		for (x = 0; x < MultCount; x++)
			StatSource.CopyMulti(x, MultiCount[x]);

		for (x = 0; x < CTFCount; x++)
			StatSource.CopyCTF(x, CTFStats[x]);
		
		WeaponDisplay = STM.WeaponDisplay;
	}
}

function FindStatSource()
{	// Find out who we are spectating, and try to hijack the stats for watching.
	local bbCHSpectator Me;
	local ST_PureStats OldPS;
	
	Me = bbCHSpectator(Owner);
	if (Me == None)		// I'm a nobody?!?
	{
		Destroy();
		return;
	}
	
	OldPS = StatSource;

	if (Pawn(Me.ViewTarget) != None)
	{
		if (Me.ViewTarget.IsA('bbPlayer'))
		{
			StatSource = ST_PureStats(bbPlayer(Me.ViewTarget).GetStats());
		}
		else if (Me.ViewTarget.IsA('ST_HumanBotPlus'))
		{
			StatSource = ST_PureStats(ST_HumanBotPlus(Me.ViewTarget).GetStats());
		}
		ViewPlayerName = Pawn(Me.ViewTarget).PlayerReplicationInfo.PlayerName;
//		Log("StatSource is"@StatSource.Owner);
		// It will now return to Timer() to copy
		return;
	}
	StatSource = None;
}


defaultproperties {
}
