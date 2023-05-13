// ===============================================================
// UTPureRC7A.PureAutoPause: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

// Changelog:

// Pure7A: - Created
// Pure7D: - Fixed slow countdown

class PureAutoPause extends Info config(InstaGibPlus);

// config variables
var globalconfig int PauseTotalTime;	// Total amount of Seconds a team may pause a game.
var globalconfig int PauseTime;		// Amount of seconds a team may pause pr pause/timeout.
var globalconfig int Timeouts;		// Max amount of times a team may take timeouts. (for Coaches)

// Team variables - Only 2 teams supported. Should be fairly simple to expand to 4 if people need.
var int TeamSize[2];			// How many players should be on a team. if less, we pause (if allowed)
var int TeamPauseLeft[2];		// Number of seconds a team has left to pause.
var int TeamCurPauseLeft[2];		// Number of seconds this team has left of current pause.
var int TeamTimeoutLeft[2];		// Number of timeouts a team has left.

// Autopause important variables. Very important. VERY!
var TeamGamePlus TGP;
var int CountDownCounter;		// I love typing.

function PostBeginPlay()
{
	TGP = TeamGamePlus(Level.Game);
	if (TGP == None || !TGP.bTournament)
	{
		Destroy();		// Don't like myself :(
		return;
	}
	SaveConfig();			// Make the entries for easier modification later.

	TeamPauseLeft[0] = PauseTotalTime;
	TeamCurPauseLeft[0] = PauseTime;
	TeamTimeoutLeft[0] = Timeouts;

	TeamPauseLeft[1] = PauseTotalTime;
	TeamCurPauseLeft[1] = PauseTime;
	TeamTimeoutLeft[1] = Timeouts;
}

// Player wants AutoPause to keep on
function bool PlayerGo(PlayerReplicationInfo PRI)
{
	local bool bGone;

	if (PRI == None || !PRI.bAdmin)
		return False;				// Only admins are allowed to use this.

	if (TeamMissing(0))
	{
		TeamSize[0] = GetTeamSize(0);
		bGone = True;
	}
	if (TeamMissing(1))
	{
		TeamSize[1] = GetTeamSize(1);
		bGone = True;
	}

	if (bGone)
		BroadcastMessage(PRI.PlayerName@"forced game to continue!", True);
	return bGone;
}

// Player (admin only here) may give more time to teams that are missing players
function bool PlayerHold(PlayerReplicationInfo PRI)
{
	local bool bHeld;

	if (PRI == None || !PRI.bAdmin)
		return False;				// Only admins plz.

	if (TeamMissing(0))
	{
		TeamCurPauseLeft[0] = PauseTime;
		TeamPauseLeft[0] = Min(PauseTotalTime, TeamPauseLeft[0] + PauseTime);
		bHeld = True;
	}
	if (TeamMissing(1))
	{
		TeamCurPauseLeft[1] = PauseTime;
		TeamPauseLeft[1] = Min(PauseTotalTime, TeamPauseLeft[1] + PauseTime);
		bHeld = True;
	}

	if (bHeld)
		BroadcastMessage(PRI.PlayerName@"gave"@NiceTime(PauseTime)@"more time!", True);
	return bHeld;
}

// Use states to avoid one huge giant big unreadable tick.
auto state WaitForGame
{
	function Tick(float deltaTime)
	{
		if (TGP.CountDown != 10)
		{
			TeamSize[0] = GetTeamSize(0);
			TeamSize[1] = GetTeamSize(1);
			GotoState('CountdownGame');
		}
	}
}

// Counting down.
state CountdownGame
{	// No handling of leaving players here. It will just get annoying. Better to pause immediately after game starts.
	function Tick(float deltaTime)
	{
		if (TGP.CountDown <= 0)
		{
			ClearProgress();
			GotoState('PlayingGame');
		}
	}

	function BeginState()
	{
		BroadcastMessage("PureAutoPause enabled! Pausetimes: per="$NiceTime(PauseTime)@"total="$NiceTime(PauseTotalTime));
	}
}

// Normal game is playing state.
state PlayingGame
{
	function Tick(float deltaTime)
	{
		if (TGP.bGameEnded)
		{
			GotoState('EndedGame');			// Game ended, no more need for pausing.
			return;
		}
		if (Level.Pauser != "")
		{
			GotoState('PausedGame');		// Something external paused the game.
			return;
		}
		if (TeamCanPause(0) && TeamMissing(0))		// Pause if team still can pause and missing players
			PauseGame();
		if (TeamCanPause(1) && TeamMissing(1))
			PauseGame();
	}
}

function PauseGame()
{
	GotoState('AutoPausedGame');
	Pause();
}

// This state is used when something else than AutoPause paused the game, to avoid AutoPause messing things up.
// Should only be reachable via admins, so no GO/HOLD functionality.
state PausedGame
{
	function Tick(float deltaTime)
	{
		if (Level.Pauser == "")
		{
			Pause();
			GotoState('UnpauseCountdown');
		}
	}
}

// This is the state used when AutoPause has paused the game.
state AutoPausedGame
{
	function bool PlayerGo(PlayerReplicationInfo PRI)
	{	// Override this to allow players to be nice to eachother
		local int Team;

		if (PRI == None)
			return False;

		if (Global.PlayerGo(PRI))
			return True;			// If super handled return.

		Team = PRI.Team;
		if (TeamMissing(Team))
		{
			TeamSize[Team] = GetTeamSize(Team);
			BroadcastMessage(PRI.PlayerName@"allowed game to continue!", True);
			return True;
		}
		return False;				// Nothing done
	}

	function bool PlayerHold(PlayerReplicationInfo PRI)
	{	// And this one.
		local int Team;

		if (PRI == None)
			return False;

		if (Global.PlayerHold(PRI))
			return True;			// Super handled it.

		Team = 1 - PRI.Team;			// Get *OTHER* team :X
		if (TeamMissing(Team))
		{
			TeamCurPauseLeft[Team] = PauseTime;
			TeamPauseLeft[Team] = Min(PauseTotalTime, TeamPauseLeft[Team] + PauseTime);
			BroadcastMessage(PRI.PlayerName@"gave"@NiceTime(PauseTime)@"more time!", True);
			return True;
		}
		return False;				// Nothing done.
	}

	function Tick(float deltaTime)
	{
		if (Level.Pauser == "")
		{	// Forced unpause (By external). Update team sizes and keep at it.
			ForcedUnpause();
			return;
		}
		if (!TeamMissing(0) && !TeamMissing(1))
			GotoState('UnpauseCountdown');		// Both teams are now full again. Start counting down to unpause.
	}

	function Timer()
	{
		if (Level.Pauser == "")
		{	// External unpause. Very nasty sob.
			ForcedUnpause();
			return;
		}

		HandleAutoPause(True);
	}

	function ForcedUnpause()
	{
		TeamSize[0] = GetTeamSize(0);
		TeamSize[1] = GetTeamSize(1);
		Pause();					// Repause and let the countdown happen.
		GotoState('UnpauseCountdown');
	}

	function HandleAutoPause(bool bDecrease)
	{	// Decrease Pause Time Left, and also display somewhat descriptive messages to players
		local int x;

		ClearProgress();
		SetProgressTime(10.0);
		SetProgress("The game is automatically paused!", 0);

		for (x = 0; x < 2; x++)
		{
			if (TeamMissing(x))
			{
				SetProgress("Time remaining for"@TGP.Teams[x].TeamName$":"@NiceTime(TeamCurPauseLeft[x])@"("$NiceTime(TeamPauseLeft[x])$")", 2+x);
				SetProgressTeam(x, "To stop waiting type: 'go'", 5);
				SetProgressTeam(1-x, "To give more time type: 'hold'", 6);
				if (bDecrease)
				{
					if (TeamCurPauseLeft[x] <= 0)
						TeamSize[x] = GetTeamSize(x);
					else
						TeamCurPauseLeft[x]--;
					if (TeamPauseLeft[x] <= 0)
						TeamSize[x] = GetTeamSize(x);
					else
						TeamPauseLeft[x]--;
				}
			}
		}
	}

	function BeginState()
	{
		TeamCurPauseLeft[0] = Min(PauseTime, TeamPauseLeft[0]);
		TeamCurPauseLeft[1] = Min(PauseTime, TeamPauseLeft[1]);
		HandleAutoPause(False);
		SetTimer(Level.TimeDilation, True);
	}

	function EndState()
	{
		ClearProgress();
	}
}

// This state readies the players for unpause.
state UnpauseCountdown
{
	function Tick(float deltaTime)
	{
		if (Level.Pauser == "")
			AbortCountdown();			// Someone panicking?

		if (TeamCanPause(0) && TeamMissing(0))		// Incase players leave during countdown :(
			GotoState('AutoPausedGame');
		if (TeamCanPause(1) && TeamMissing(1))
			GotoState('AutoPausedGame');
	}

	function Timer()
	{
		if (Level.Pauser == "")
			AbortCountdown();			// Now what?

		if (CountDownCounter == 0)
		{
			Unpause();
			GotoState('PlayingGame');
		}
		else
		{
			DisplayCountdown();
		}
	}

	function AbortCountdown()
	{
		Pause();
		GotoState('PausedGame');			// Someone panicked? Go back into pause.
	}

	function DisplayCountdown()
	{
		ClearProgress();
		SetProgressTime(10.0);
		SetProgress("Game resuming in...", 0);
		BroadcastLocalizedMessage(Class'TimeMessage', 16 - CountdownCounter);
		CountdownCounter--;
	}

	function BeginState()
	{
		CountDownCounter = 5;
		DisplayCountdown();
		SetTimer(Level.TimeDilation, True);
	}

	function EndState()
	{
		ClearProgress();
	}

}

state EndedGame
{	// Nice empty state to do nothing at all in

}

// Formats time in a nicer way
function string NiceTime(int Time)
{
	local int Seconds, Minutes;
	local string Result;

	Minutes = Time / 60;
	Seconds = Time % 60;

	Result = string(Minutes)$":";

	if (Seconds < 10)
		Result = Result$"0";
	return Result$string(Seconds);
}

function ClearProgress()
{	// Clear progress messages for all players
	local Pawn P;

	for (P = Level.PawnList; P != None; P = P.NextPawn)
		if (P.IsA('PlayerPawn'))
			PlayerPawn(P).ClearProgressMessages();
}

function SetProgressTime(float Time)
{	// Set the progress message "timeout" for all players
	local Pawn P;

	for (P = Level.PawnList; P != None; P = P.NextPawn)
		if (P.IsA('PlayerPawn'))
			PlayerPawn(P).SetProgressTime(Time);
}

function SetProgress(string Msg, int Index)
{	// Set Progress messages for all
	local Pawn P;

	for (P = Level.PawnList; P != None; P = P.NextPawn)
		if (P.IsA('PlayerPawn'))
			PlayerPawn(P).SetProgressMessage(Msg, Index);
}

function SetProgressTeam(int Team, string Msg, int Index)
{	// Set Progress for a specific team.
	local Pawn P;

	for (P = Level.PawnList; P != None; P = P.NextPawn)
		if (P.PlayerReplicationInfo != none && P.PlayerReplicationInfo.Team == Team && P.IsA('PlayerPawn'))
			PlayerPawn(P).SetProgressMessage(Msg, Index);
}

// Returns the # of players in that team
function int GetTeamSize(int Team)
{
	local bbPlayer bbP;
	local Pawn P;
	local int Result;

	for (P = Level.PawnList; P != None; P = P.NextPawn)
	{
		bbP = bbPlayer(P);
		if (bbP != None && bbP.PlayerReplicationInfo.Team == Team)
			Result++;
	}

	return Result;
}

// Returns True if Team is missing a player. Also updates if a team suddenly gets a new player.
function bool TeamMissing(int Team)
{
	local int CurSize;

	CurSize = GetTeamSize(Team);

	if (CurSize > TeamSize[Team])
		TeamSize[Team] = CurSize;	// Team has grown since last check. Update.

	return (CurSize < TeamSize[Team]);	// True if team is missing players
}

// Returns True if Team still can pause.
function bool TeamCanPause(int Team)
{
	return (TeamPauseLeft[Team] > 0);	// Allowed if they have time left.
}

// Does majix!
function Pause()
{
	Level.Pauser = "PureAutoPause";
}

// Does more majix.
function Unpause()
{
	Level.Pauser = "";
}

defaultproperties
{
     PauseTotalTime=300
     pausetime=60
     bAlwaysTick=True
}
