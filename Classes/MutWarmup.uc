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
var localized string NotReadyText;
var localized string WarmupText;

var PlayerPawn HUDOwner;

state auto Warmup {
	function BeginState() {
		local DeathMatchPlus DMP;
		DMP = DeathMatchPlus(Level.Game);

		DMP.bRequireReady = false;
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
		SetTimer(1.0, true);
	}

	simulated function PostRender(Canvas C) {
		if (NextHUDMutator != none)
			NextHUDMutator.PostRender(C);

		if (HUDOwner == none)
			return;

		// Write WARMUP - READY or WARMUP - NOT READY on screen
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
		ResetPlayers();
		ResetTeams();

		if (AreAllPlayersReady())
			GoToState('WarmupEnded');
	}

	function bool HandleEndGame() {
		super.HandleEndGame();
		GoToState('WarmupEnded');
		return true;
	}
}

state WarmupEnded {
Begin:
	SetTimer(-1.0, false);
	Sleep(0.0);
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
	ResetGame(DeathMatchPlus(Level.Game));
	ResetPlayers();
	ResetPickups();
	ResetCarcasses();
	ResetProjectiles();
	ResetObjectives();
}

function ResetGame(DeathMatchPlus G) {
	local Pawn P;
	local PlayerPawn PP;
	foreach AllActors(class'Pawn', P) {
		if (P.IsA('Bot') || (P.IsA('PlayerPawn') && P.IsA('Spectator') == false)) {
			P.Health = 0;
			P.Died(P, 'Suicided', P.Location);
		}
	}

	G.bOvertime = false;
	G.bRequireReady = true;
	G.TimeLimit = GameTimeLimit;
	G.RemainingTime = GameTimeLimit*60;
	G.FragLimit = GameFragLimit;
	G.LocalLog = GameLocalLog;
	G.WorldLog = GameWorldLog;

	foreach AllActors(class'PlayerPawn', PP) {
		if (G.LocalLog != none)
			G.LocalLog.LogPlayerConnect(P);
		if (G.WorldLog != none)
			G.WorldLog.LogPlayerConnect(P);
	}
}

function ResetPlayers() {
	local PlayerReplicationInfo PRI;
	local bbPlayerReplicationInfo bbPRI;
	foreach AllActors(class'PlayerReplicationInfo', PRI) {
		PRI.Score = 0;
		PRI.Deaths = 0;

		if (PRI.IsA('bbPlayerReplicationInfo')) {
			bbPRI = bbPlayerReplicationInfo(PRI);

			if (bbPRI.PlayerName == "")
				// Lets hope this is temporary
				continue;

			if (IsInState('Warmup')) {
				if (InStr(bbPRI.PlayerName, " - "$NotReadyText) < 0 && InStr(bbPRI.PlayerName, " - "$ReadyText) < 0) {
					bbPRI.OriginalName = bbPRI.PlayerName;
				}

				if (PlayerPawn(bbPRI.Owner).bReadyToPlay == false) {
					if (Len(bbPRI.OriginalName) > 32 - (Len(NotReadyText) + 4)) {
						bbPRI.PlayerName = Left(bbPRI.OriginalName, 32 - (Len(NotReadyText) + 7))$"... - "$NotReadyText;
					} else {
						bbPRI.PlayerName = bbPRI.OriginalName$" - "$NotReadyText;
					}
				} else {
					if (Len(bbPRI.OriginalName) > 32 - (Len(ReadyText) + 4)) {
						bbPRI.PlayerName = Left(bbPRI.OriginalName, 32 - (Len(ReadyText) + 7))$"... - "$ReadyText;
					} else {
						bbPRI.PlayerName = bbPRI.OriginalName$" - "$ReadyText;
					}
				}
			} else {
				bbPRI.PlayerName = bbPRI.OriginalName;
			}
		}
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
	NotReadyText="NOT READY"
	WarmupText="Warmup"
}
