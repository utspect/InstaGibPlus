class MutWarmup extends Mutator;

var UTPure Pure;
var int GameTimeLimit;
var int GameFragLimit;
var StatLog GameLocalLog;
var StatLog GameWorldLog;

const MaxWeapons = 32;
var int WeaponCount;
var string WeaponsToGive[MaxWeapons];

var localized string ReadyText;
var localized color ReadyColor;
var localized string NotReadyText;
var localized color NotReadyColor;
var localized string WarmupText;

var PlayerPawn HUDOwner;
var bool bInWarmup;

replication {
	reliable if (Role == ROLE_Authority)
		bInWarmup;
}

simulated function PostRender(Canvas C) {
	local string Message;
	local color MessageColor;
	local float X, Y;

	if (NextHUDMutator != none)
		NextHUDMutator.PostRender(C);

	if (HUDOwner == none || bInWarmup == false)
		return;

	// Write WARMUP - READY or WARMUP - NOT READY on screen
	if (TournamentPlayer(HUDOwner).bReadyToPlay) {
		Message = WarmupText@"-"@ReadyText;
		MessageColor = ReadyColor;
	} else {
		Message = WarmupText@"-"@NotReadyText;
		MessageColor = NotReadyColor;
	}

	class'CanvasUtils'.static.SaveCanvas(C);

	C.Font = ChallengeHUD(HUDOwner.myHUD).MyFonts.GetBigFont(C.SizeX);
	C.DrawColor = MessageColor;
	C.TextSize(Message, X, Y);
	C.SetPos(C.SizeX*0.5 - X*0.5, C.SizeY*0.8);
	C.DrawText(Message);

	class'CanvasUtils'.static.RestoreCanvas(C);
}

state auto Warmup {
	function BeginState() {
		local DeathMatchPlus DMP;
		DMP = DeathMatchPlus(Level.Game);

		DMP.bRequireReady = true;
		DMP.CountDown = 0;
		GameTimeLimit = DMP.TimeLimit;
		DMP.TimeLimit = class'UTPure'.default.WarmupTimeLimit;
		DMP.RemainingTime = DMP.TimeLimit*60;
		GameFragLimit = DMP.FragLimit;
		DMP.FragLimit = 999;

		GameLocalLog = DMP.LocalLog;
		GameWorldLog = DMP.WorldLog;
		DMP.LocalLog = none;
		DMP.WorldLog = none;

		DetermineWeapons();
		SetTimer(Level.TimeDilation, true);

		bInWarmup = true;
	}

	function ModifyPlayer(Pawn P) {
		local DeathMatchPlus DMP;
		local int x;
		DMP = DeathMatchPlus(Level.Game);

		for (x = 0; x < WeaponCount; ++x) {
			DMP.GiveWeapon(P, WeaponsToGive[x]);
		}

		super.ModifyPlayer(P);
	}

	function Timer() {
		local DeathMatchPlus DMP;
		DMP = DeathMatchPlus(Level.Game);

		// deal with changing gamespeed
		if (TimerRate != Level.TimeDilation)
			SetTimer(Level.TimeDilation, true);

		ResetPlayers();
		ResetTeams();

		if (AreAllPlayersReady() || DMP.RemainingTime <= 10)
			GoToState('WarmupCountdown');
	}
}

state WarmupCountdown {
	function BeginState() {
		local Pawn P;
		local DeathMatchPlus DMP;
		DMP = DeathMatchPlus(Level.Game);

		foreach AllActors(class'Pawn', P) {
			if (P.IsA('Bot') || (P.IsA('PlayerPawn') && P.IsA('Spectator') == false)) {
				P.Health = 0;
				P.Died(P, 'Suicided', P.Location);
				P.PlayerReStartState = 'PlayerSpectating';
				//P.GoToState(P.PlayerReStartState);
				DMP.CountDown = 1;
				Level.Game.RestartPlayer(P);
				DMP.CountDown = 0;
			}
		}

		DMP.RemainingTime = 10;
		DMP.GameReplicationInfo.RemainingMinute = DMP.RemainingTime;

		ResetPlayers();
		ResetTeams();

		bInWarmup = false;
	}

	function Timer() {
		local DeathMatchPlus DMP;
		DMP = DeathMatchPlus(Level.Game);

		if (DMP.RemainingTime <= 1)
			GoToState('WarmupEnded');
	}
}

state WarmupEnded {
Begin:
	SetTimer(0.0, false);
	Reset();
	GoToState('');
}

function bool AreAllPlayersReady() {
	local PlayerPawn P;

	if (Level.Game.NumPlayers == Level.Game.MaxPlayers) {
		foreach AllActors(class'PlayerPawn', P) {
			if (P.IsA('Spectator') == false && P.bReadyToPlay == false) {
				return false;
			}
		}
		return true;
	}

	return false;
}

function Reset() {
	ResetPlayers();
	ResetPickups();
	ResetCarcasses();
	ResetProjectiles();
	ResetObjectives();
	ResetGame(DeathMatchPlus(Level.Game));
}

function ResetGame(DeathMatchPlus G) {
	local PlayerPawn PP;
	local TournamentGameReplicationInfo TGRI;

	TGRI = TournamentGameReplicationInfo(G.GameReplicationInfo);

	G.bOvertime = false;
	G.bRequireReady = true;
	G.CountDown = 0;
	G.TimeLimit = GameTimeLimit;
	G.RemainingTime = GameTimeLimit*60;
	G.FragLimit = GameFragLimit;
	G.LocalLog = GameLocalLog;
	G.WorldLog = GameWorldLog;

	foreach AllActors(class'PlayerPawn', PP) {
		if (G.LocalLog != none)
			G.LocalLog.LogPlayerConnect(PP);
		if (G.WorldLog != none)
			G.WorldLog.LogPlayerConnect(PP);
	}

	G.StartMatch();
}

function ResetPlayers() {
	local PlayerReplicationInfo PRI;

	foreach AllActors(class'PlayerReplicationInfo', PRI) {
		PRI.Score = 0;
		PRI.Deaths = 0;
	}
}

function ResetTeams() {
	local TeamInfo T;
	foreach AllActors(class'TeamInfo', T) {
		T.Score = 0;
	}
}

function ResetObjectives() {
	local CTFFlag F;
	local ControlPoint CP;
	local FortStandard FS;

	foreach AllActors(class'CTFFlag', F) {
		F.SendHome();
	}

	foreach AllActors(Class'ControlPoint', CP) {
		CP.Enable('Touch');
	}

	foreach AllActors(Class'FortStandard', FS) {
		FS.Enable('Touch');
		FS.Enable('Trigger');
		FS.SetCollision(true, false, false);
	}
}

function ResetPickups() {
	local Inventory I;

	foreach AllActors(class'Inventory', I) {
		if (I.bTossedOut || I.bHeldItem)
			I.Destroy();
		else if (I.IsInState('Sleeping'))
			I.GotoState('Pickup');
	}
}

function ResetCarcasses() {
	local Carcass C;

	foreach AllActors(class'Carcass', C) {
		if (!C.bStatic && !C.bNoDelete) {
			C.Destroy();
		}
	}
}

function ResetProjectiles() {
	local Projectile P;

	foreach AllActors(class'Projectile', P) {
		if (!P.bStatic && !P.bNoDelete) {
			P.Destroy();
		}
	}
}

function AddWeaponToGive(string WeaponClassName) {
	local int x;
	for (x = 0; x < WeaponCount; ++x)
		if (WeaponsToGive[x] ~= WeaponClassName)
			return;

	if (WeaponCount >= MaxWeapons) {
		Log("Too many Weapons on map! Discarding"@WeaponClassName, 'IGPlus');
		return;
	}

	WeaponsToGive[WeaponCount++] = WeaponClassName;
}

function DetermineWeapons() {
	local Weapon W;

	if (Level.Game.BaseMutator != None)
		AddWeaponToGive(string(Level.Game.BaseMutator.MutatedDefaultWeapon()));

	// Find the rest of the weapons around the map.
	foreach AllActors(Class'Weapon', W)
		AddWeaponToGive(string(W.Class));
}

simulated function PostBeginPlay() {
	local PlayerPawn P;

	Super.PostBeginPlay();

	RegisterHUDMutator();

	foreach AllActors(class'PlayerPawn', P) {
		if (P.Role == ROLE_Authority && P.RemoteRole == ROLE_SimulatedProxy)
			HUDOwner = P;
		if (P.Role == ROLE_AutonomousProxy)
			HUDOwner = P;
	}
}

defaultproperties {
	ReadyText="READY"
	ReadyColor=(R=255,G=255,B=255,A=255)
	NotReadyText="NOT READY"
	NotReadyColor=(R=255,G=255,B=255,A=255)
	WarmupText="Warmup"
	bInWarmup=True
	bAlwaysRelevant=True
}
