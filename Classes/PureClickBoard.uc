class PureClickBoard extends Mutator;
// Description="<Internal>"

var PureFlag FakeFlag;

function bool AlwaysKeep(Actor Other)
{
	if (Other.IsA('PureFlag'))
		return true;

	return Super.AlwaysKeep(Other);
}

auto state Initial {
Begin:
	if (Level.NetMode == NM_DedicatedServer)
		Sleep(0.001);

	Initialize();
}

function Initialize() {
	local class<ScoreBoard> ScoreBoardType;
	local DeathMatchPlus DMP;

	DMP = DeathMatchPlus(Level.Game);
	if (DMP == none || DMP.bTournament == false) {
		Disable('Tick');
		return;
	}

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
		ScoreBoardType = Level.Game.ScoreBoardType;
		Log("Unknown ScoreBoardType "@Level.Game.ScoreBoardType, 'UTPure');
	}

	Log("Used ScoreBoard is "@String(ScoreBoardType));

	if (ScoreBoardType != None)
	{
		Level.Game.ScoreBoardType = ScoreBoardType;
		// Also create a fake flag to transmit clicked status
		CreateFakeFlag();

		if (FakeFlag != None) {
			Log("PureClickBoard Set", 'UTPure');
			// Start a timer to check for Clicked status
			SetTimer(1.0, true);
		} else {
			Log("We don't have a fake flag! :(", 'UTPure');
			Log("Failed to Initialize PureClick Environment", 'UTPure');
		}
	}
}

function CreateFakeFlag()
{
	local Actor A;

	foreach AllActors(class'Actor', A) {
		FakeFlag = Spawn(class'PureFlag', None,, A.Location);
		if (FakeFlag != None) {
			FakeFlag.bHidden = true;
			FakeFlag.SetTimer(0.0, false);	// Make sure it doesnt try to Send Home
			return;
		}
	}

	Log("CreateFakeFlag() failed :(", 'UTPure');
}

event Timer() {
	local PlayerPawn P;
	local DeathMatchPlus DMP;

	DMP = DeathMatchPlus(Level.Game);
	if (DMP != none && DMP.CountDown > 0) {
		foreach Level.AllActors(class'PlayerPawn', P) {
			if (!P.IsA('Spectator') && P.PlayerReplicationInfo != none) {
				if (P.bReadyToPlay) {
					P.PlayerReplicationInfo.HasFlag = FakeFlag;
				} else {
					P.PlayerReplicationInfo.HasFlag = none;
				}
			}
		}
	}
}

event Tick(Float delta)
{
	local PlayerReplicationInfo PRI;
	local DeathMatchPlus DMP;

	// If Game has started, cleanup all the flags assigned
	DMP = DeathMatchPlus(Level.Game);

	if (DMP != None && DMP.CountDown <= 0) {
		foreach AllActors(class'PlayerReplicationInfo', PRI)
			if (PRI.HasFlag == FakeFlag)
				PRI.HasFlag = None;

		if (FakeFlag != None)
			FakeFlag.Destroy();

		FakeFlag = None;
		SetTimer(0.0, false);
		Disable('Tick');
	}
}

defaultproperties
{
}
