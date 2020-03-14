// ====================================================================
//  Class:  UTPureRC4d.PureClickBoard
//  Parent: Engine.Mutator
//
//  <Enter a description here>
// ====================================================================

class PureClickBoard extends Mutator;

var PureFlag		zzFakeFlag;

function bool AlwaysKeep(Actor Other)
{
	if (Other.IsA('PureFlag'))
		return true;

	return Super.AlwaysKeep(Other);
}

event PreBeginPlay()
{
local class<scoreboard>		  ScoreBoardType;

	Log("PreBeginPlay PureClickBoard!", 'UTPure');

	Super.PreBeginPlay();

	if (Level.Game.IsA('DeathMatchPlus') && DeathMatchPlus(Level.Game).bTournament)
	{
		// First, make sure the player uses a ScoreBoard that can show clicked status
		if (Level.Game.ScoreBoardType == class'Botpack.TournamentScoreBoard')
			ScoreBoardType = Class'PureScoreBoard';
		else if (Level.Game.ScoreBoardType == Class'Botpack.TeamScoreBoard')
			ScoreBoardType = Class'PureTeamScoreBoard';
		else if (Level.Game.ScoreBoardType == Class'Botpack.AssaultScoreboard')
			ScoreBoardType = Class'PureAssaultScoreBoard';
		else if (Level.Game.ScoreBoardType == Class'Botpack.UnrealCTFScoreboard')
			ScoreBoardType = Class'PureCTFScoreBoard';
		else if (Level.Game.ScoreBoardType == Class'Botpack.DominationScoreboard')
			ScoreBoardType = Class'PureDOMScoreBoard';
		else {
			ScoreBoardType = Class'PureCTFScoreBoard';
			Log("Unknown Scoreboard type?", 'UTPure');
		}

		Log("Level is a "@String(ScoreBoardType));

		if (ScoreBoardType != None)
		{
			Level.Game.ScoreBoardType = ScoreBoardType;
			// Also create a fake flag to transmit clicked status
			CreateFakeFlag();
			if (zzFakeFlag == None)
				Log("We don't have a fake flag! :(", 'UTPure');
			if (zzFakeFlag != None)
			{
				Log("PureClickBoard Set", 'UTPure');
				zzFakeFlag.bHidden = true;		// See if it prevents it from replicating
				zzFakeFlag.SetTimer(0.0, false);	// Make sure it doesnt try to Send Home
				// Start a timer to check for Clicked status
				SetTimer(1.0, true);
			}
			else
				Log("Failed to Initialize PureClick Environment", 'UTPure');
		}
	}
}

function CreateFakeFlag()
{
local NavigationPoint zznav;
local Actor zzA;

	// First, go thru all Navigation Points to find a valid spot
	for (zznav = Level.NavigationPointList; zznav != None; zznav = zznav.nextNavigationPoint)
	{
		zzFakeFlag = Spawn(class'PureFlag', None,,zznav.Location);
		if (zzFakeFlag != None) {
			Log("We have a fake flag!", 'UTPure');
			return;
		}
			
	}

	// Still havent found one ? .. Try AllActors
	foreach AllActors(class'Actor', zzA)
	{
		zzFakeFlag = Spawn(class'PureFlag', None,, zzA.Location);
		if (zzFakeFlag != None) {
			Log("We have a fake flag!", 'UTPure');
			return;
		}
			
	}
	// Oh Well, forget it, we wont make it.
	Log("CreateFakeFlag() failed :(", 'UTPure');
}

event Timer()
{
local Pawn zzP;
local bbPlayer zzbbP;
local DeathMatchPlus zzDMP;

	// If Game has started, cleanup all the flags assigned
	zzDMP = DeathMatchPlus(Level.Game);

	//Log("On PureClickBoard Timer");

	if (zzDMP.CountDown > 0)
	{
		if (zzFakeFlag == None)
			zzFakeFlag = spawn(class'PureFlag');

		if (zzFakeFlag == None)
			Log("Failed once more in Timer");
		else
		{
			/* // Check all player for their clicked status
			for (zzP = Level.PawnList; zzP != None; zzP = zzP.NextPawn)
			{
				if (zzP.IsA('PlayerPawn') || zzP.IsA('bbPlayer') && !zzP.IsA('Spectator') && zzP.PlayerReplicationInfo != None)
				{
				    zzP = bbPlayer(zzP);
					if (bbPlayer(zzP).bReadyToPlay && zzP.PlayerReplicationInfo.HasFlag == None)
						zzP.PlayerReplicationInfo.HasFlag = zzFakeFlag;
					else if (!bbPlayer(zzP).bReadyToPlay && zzP.PlayerReplicationInfo.HasFlag == zzFakeFlag)
						zzP.PlayerReplicationInfo.HasFlag = None;
				}
			} */

			foreach Level.AllActors(class'bbPlayer', zzbbP) {
				if (!zzbbP.IsA('Spectator') && zzbbP.PlayerReplicationInfo != none) {
			        if (zzbbP.bReadyToPlay && zzbbP.PlayerReplicationInfo.HasFlag == none) {
			            zzbbP.PlayerReplicationInfo.HasFlag = zzFakeFlag;
                    } else if (!zzbbP.bReadyToPlay && zzbbP.PlayerReplicationInfo.HasFlag == zzFakeFlag) {
                        zzbbP.PlayerReplicationInfo.HasFlag = none;
                    }
                }
           }
		}
	}
}

event Tick(Float delta)
{
local Pawn zzP;
local DeathMatchPlus zzDMP;

	// If Game has started, cleanup all the flags assigned
	zzDMP = DeathMatchPlus(Level.Game);

	if (zzDMP != None && zzDMP.CountDown <= 0)
	{
		for (zzP = Level.PawnList; zzP != None; zzP = zzP.NextPawn)
			if (zzP.PlayerReplicationInfo.HasFlag == zzFakeFlag)
				zzP.PlayerReplicationInfo.HasFlag = None;

		if (zzFakeFlag != None)
			zzFakeFlag.Destroy();

		zzFakeFlag = None;
		SetTimer(0.0, false);
		Disable('Tick');
	}
}

defaultproperties
{
}
