// ============================================================
// Created by UClasses - (C) 2000 by meltdown@thirdtower.com
// ============================================================

class bbCHSpectator expands CHSpectator;

// AntiSpam
var float zzLastView1,zzLastView2;
var int zzAdminLoginTries;

// Nice to have
var UTPure zzUTPure;

// Stats
var PureStats Stat;		// For player stats
var Class<PureStats> cStat;	// The class to use

var int   zzRecentDmgGiven, zzRecentTeamDmgGiven;
var float   zzLastHitSound, zzLastTeamHitSound, zzNextTimeTime;

var bool zzTrue,zzFalse;		// True & False

// Smooth ViewRotation when spectating in 1st person
struct PIDController {
    var int PrevErr;
    var float Integral;
};

var PIDController PitchController;
var PIDController YawController;
var rotator LastTargetViewRotation;
var rotator LastRotation;
var Actor LastViewTarget;

var Object ClientSettingsHelper;
var ClientSettings Settings;

var bool bPaused;
var float GRISecondCountOffset;
var float LastDeltaTime;

replication
{
	// Server -> Client
	reliable if (bNetOwner && ROLE == ROLE_Authority)
		Stat;
	// Client -> Server
	reliable if (ROLE < ROLE_Authority)
		ShowStats; //, xxServerActivateMover;

	unreliable if (RemoteRole == ROLE_AutonomousProxy)
		NewCAP;

	// Server->Client
	reliable if ( Role == ROLE_Authority )
		xxSetTimes, xxReceivePosition; //, xxClientActivateMover;

	reliable if ( (!bDemoRecording || (bClientDemoRecording && bClientDemoNetFunc) || (Level.NetMode==NM_Standalone)) && Role == ROLE_Authority )
		ReceiveWeaponEffect;
}

function ReceiveWeaponEffect(
	class<WeaponEffect> Effect,
	Actor Source,
	vector SourceLocation,
	vector SourceOffset,
	Actor Target,
	vector TargetLocation,
	vector TargetOffset,
	vector HitNormal
) {
	Effect.static.Play(self, Settings, Source, SourceLocation, SourceOffset, Target, TargetLocation, TargetOffset, Normal(HitNormal / 32767));
}

function SendWeaponEffect(
	class<WeaponEffect> Effect,
	Actor Source,
	vector SourceLocation,
	vector SourceOffset,
	Actor Target,
	vector TargetLocation,
	vector TargetOffset,
	vector HitNormal
) {
	ReceiveWeaponEffect(Effect, Source, SourceLocation, SourceOffset, Target, TargetLocation, TargetOffset, HitNormal * 32767);
}

simulated function xxReceivePosition( bbPlayer Other, vector Loc, vector Vel, bool bSet )
{
	local vector Diff;
	local float VS;

	if (Level.NetMode != NM_Client || Other == None)
		return;

	Diff = Loc - Other.Location;
	VS = VSize(Diff);
	if (VS < 50)
	{
		Other.zzLastLocDiff = 0;
		Other.Velocity = Vel;
	}
	else
	{
		Other.zzLastLocDiff += VS;
		if (bSet || Other.zzLastLocDiff > 9000 || !Other.FastTrace(Loc))	// IT'S OVER 9000!
		{
			Other.SetLocation(Loc);
			Other.Velocity = Vel;
			Other.zzLastLocDiff = 0;
		}
		else if (Other.zzLastLocDiff > 900)
		{
			Other.MoveSmooth(Diff);
			Other.Velocity = Vel;
			Other.zzLastLocDiff = 0;
		}
		else
		{
			Other.Velocity = Vel + Diff * 5;
		}
	}
}

function int NormRotDiff(int diff) {
    return (diff << 16) >> 16;
}

function int NormRot(int a) {
    return a & 0xFFFF;
}

function InitPID(out PIDController C) {
    C.Integral = 0;
    C.PrevErr = 0;
}

function int TickPID(out PIDController C, float DeltaTime, int Error) {
    local float Derivative;

    C.Integral += Error * DeltaTime;
    Derivative = (Error - C.PrevErr) / DeltaTime;
    C.PrevErr = Error;

    return NormRotDiff(
    	Settings.SmoothVRController.p * Error +
    	Settings.SmoothVRController.i * C.Integral +
    	Settings.SmoothVRController.d * Derivative);
}

function xxPlayerTickEvents()
{
	if (GameReplicationInfo != none && (bPaused ^^ (Level.Pauser != ""))) {
		bPaused = !bPaused;
		if (bPaused) {
			GRISecondCountOffset = Level.TimeSeconds - GameReplicationInfo.SecondCount;
		} else {
			GameReplicationInfo.SecondCount = Level.TimeSeconds - GRISecondCountOffset;
		}
	}
}

simulated function xxSetTimes(int RemainingTime, int ElapsedTime)
{
	if (GameReplicationInfo == None)
		return;
	GameReplicationInfo.RemainingTime = RemainingTime;
	GameReplicationInfo.ElapsedTime = ElapsedTime;
}

simulated function InitSettings() {
	local bbPlayer P;
	local bbCHSpectator S;

	if (Settings != none) return;

	foreach AllActors(class'bbPlayer', P)
		if (P.Settings != none) {
			Settings = P.Settings;
			break;
		}

	foreach AllActors(class'bbCHSpectator', S)
		if (S.Settings != none) {
			Settings = S.Settings;
			break;
		}

	if (Settings == none) {
		ClientSettingsHelper = new(none, 'InstaGibPlus') class'Object';
		Settings = new(ClientSettingsHelper, 'ClientSettings') class'ClientSettings';
		Settings.CheckConfig();
		Log("Loaded Settings!", 'IGPlus');
	}
}

event Possess()
{
	InitSettings();

	if ( Level.Netmode == NM_Client )
	{	// Only do this for clients.
		ClientSetMusic( Level.Song, Level.SongSection, Level.CdTrack, MTRAN_Fade );
	}
	else
	{
		GameReplicationInfo.RemainingTime = DeathMatchPlus(Level.Game).RemainingTime;
		GameReplicationInfo.ElapsedTime = DeathMatchPlus(Level.Game).ElapsedTime;
		xxSetTimes(GameReplicationInfo.RemainingTime, GameReplicationInfo.ElapsedTime);
	}
	Super.Possess();
}

auto state InvalidState
{
	event PlayerTick( float DeltaTime )
	{
		LastDeltaTime = DeltaTime;
		xxPlayerTickEvents();
		SmoothRotation(DeltaTime);
		Super.PlayerTick(DeltaTime);
	}
}

state FeigningDeath
{
	event PlayerTick( float DeltaTime )
	{
		LastDeltaTime = DeltaTime;
		xxPlayerTickEvents();
		SmoothRotation(DeltaTime);
		Super.PlayerTick(DeltaTime);
	}
}

state PlayerFlying
{
	event PlayerTick( float DeltaTime )
	{
		LastDeltaTime = DeltaTime;
		xxPlayerTickEvents();
		SmoothRotation(DeltaTime);
		Super.PlayerTick(DeltaTime);
	}
}

state PlayerWaiting
{
	event PlayerTick( float DeltaTime )
	{
		LastDeltaTime = DeltaTime;
		xxPlayerTickEvents();
		SmoothRotation(DeltaTime);
		Super.PlayerTick(DeltaTime);
	}
}

state PlayerSpectating
{
	event PlayerTick( float DeltaTime )
	{
		LastDeltaTime = DeltaTime;
		xxPlayerTickEvents();
		SmoothRotation(DeltaTime);
		Super.PlayerTick(DeltaTime);
	}
}

state PlayerWaking
{
	event PlayerTick( float DeltaTime )
	{
		LastDeltaTime = DeltaTime;
		xxPlayerTickEvents();
		SmoothRotation(DeltaTime);
		Super.PlayerTick(DeltaTime);
	}
}

state Dying
{
	event PlayerTick( float DeltaTime )
	{
		LastDeltaTime = DeltaTime;
		xxPlayerTickEvents();
		SmoothRotation(DeltaTime);
		Super.PlayerTick(DeltaTime);
	}
}

state GameEnded
{
	event PlayerTick( float DeltaTime )
	{
		LastDeltaTime = DeltaTime;
		xxPlayerTickEvents();
		SmoothRotation(DeltaTime);
		Super.PlayerTick(DeltaTime);
	}
}

function SmoothRotation(float DeltaTime)
{
	local bbPlayer P;
	local int Pitch, Yaw;
	local int DeltaPitch, DeltaYaw;

	P = bbPlayer(ViewTarget);
	if (P != none) {
		if (P != LastViewTarget) {
			LastRotation = TargetViewRotation;
			LastViewTarget = P;
		}
		if (LastRotation.Pitch != TargetViewRotation.Pitch || LastRotation.Yaw != TargetViewRotation.Yaw) {
			LastTargetViewRotation = TargetViewRotation;
			TargetViewRotation = LastRotation;
		}

		Pitch = LastTargetViewRotation.Pitch;
		Yaw = LastTargetViewRotation.Yaw;

		DeltaPitch = TickPID(PitchController, DeltaTime, NormRotDiff(Pitch - TargetViewRotation.Pitch));
		DeltaYaw = TickPID(YawController, DeltaTime, NormRotDiff(Yaw - TargetViewRotation.Yaw));

		TargetViewRotation.Pitch = NormRot(TargetViewRotation.Pitch + DeltaPitch);
		TargetViewRotation.Yaw = NormRot(TargetViewRotation.Yaw + DeltaYaw);
		TargetViewRotation.Roll = 0;

		LastRotation = TargetViewRotation;
	}
}

event PlayerTick( float DeltaTime )
{
	LastDeltaTime = DeltaTime;
	xxPlayerTickEvents();
	SmoothRotation(DeltaTime);
}

event PostBeginPlay()
{
	ForEach AllActors(Class'UTPure', zzUTPure)
		break;

	if (cStat != None)
		Stat = Spawn(cStat, Self);

	Super.PostBeginPlay();

	InitSettings();
}

event PostNetBeginPlay() {
	super.PostNetBeginPlay();

	InitSettings();
}

event PostRender( canvas Canvas )
{
	local int CH;

	if ((MyHud == none) && (Viewport(Player) != None) && (HUDType != None))
		MyHud = spawn(HUDType, self);

	if (Settings.bUseCrosshairFactory) {
		CH = MyHud.Crosshair;
		MyHud.Crosshair = ChallengeHUD(MyHud).CrosshairCount;
	}
	MyHud.PostRender(Canvas);
	if (Settings.bUseCrosshairFactory) {
		if (ChallengeHUD(MyHud).bShowInfo == false &&
			bShowScores == false &&
			ChallengeHUD(MyHud).bForceScores == false &&
			bBehindView == false &&
			Level.LevelAction == LEVACT_None
		) {
			class'bbPlayerStatics'.static.DrawCrosshair(Canvas, Settings);
		}
		MyHud.Crosshair = CH;
	}

	class'bbPlayerStatics'.static.DrawFPS(Canvas, MyHud, Settings, LastDeltaTime);
	class'bbPlayerStatics'.static.DrawHitMarker(Canvas, Settings, LastDeltaTime);

	if (Stat != None && Stat.bShowStats)
	{
		Stat.PostRender( Canvas );
		return;
	}
}

function xxCalcBehindView(out vector CameraLocation, out rotator CameraRotation, float Dist)
{
	local vector View,HitLocation,HitNormal;
	local float ViewDist;

	CameraRotation = ViewRotation;
	View = vect(1,0,0) >> CameraRotation;
	if( Trace( HitLocation, HitNormal, CameraLocation - (Dist + 30) * vector(CameraRotation), CameraLocation ) != None )
		ViewDist = FMin( (CameraLocation - HitLocation) Dot View, Dist );
	else
		ViewDist = Dist;
	CameraLocation -= (ViewDist - 30) * View;
}

// Fix the "roll" (upside/sideway view) bug.
event PlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
{
	local Pawn PTarget;

	if ( ViewTarget != None )
	{
		ViewActor = ViewTarget;
		CameraLocation = ViewTarget.Location;
		CameraRotation = ViewTarget.Rotation;
		PTarget = Pawn(ViewTarget);
		if ( PTarget != None )
		{
			if ( Level.NetMode == NM_Client )
			{
				if ( PTarget.bIsPlayer ) {
					PTarget.ViewRotation = TargetViewRotation;
				}
				PTarget.EyeHeight = TargetEyeHeight;
				if ( PTarget.Weapon != None )
					PTarget.Weapon.PlayerViewOffset = TargetWeaponViewOffset;
			}
			if ( PTarget.bIsPlayer )
				CameraRotation = PTarget.ViewRotation;
			CameraLocation.Z += PTarget.EyeHeight;
		}
		CameraRotation.Roll = 0;

		if ( bBehindView )
			xxCalcBehindView(CameraLocation, CameraRotation, 180);
		return;
	}

	ViewActor = Self;
	CameraLocation = Location;
	CameraLocation.Z += EyeHeight;

	if( bBehindView ) { //up and behind
		xxCalcBehindView(CameraLocation, CameraRotation, 150);
	} else {
		// First-person view.
		CameraRotation = ViewRotation;
		CameraLocation += WalkBob;
	}
}

exec function Jump( optional float F )
{
	if (zzLastView2 != Level.TimeSeconds)
	{
		ViewClass(class'SpectatorCam', true);
		While ( (ViewTarget != None) && ViewTarget.IsA('SpectatorCam') && SpectatorCam(ViewTarget).bSkipView )
			ViewClass(class'SpectatorCam', true);
		if ( ViewTarget != None && ViewTarget.IsA('SpectatorCam') )
			bBehindView = false;
		zzLastView2 = Level.TimeSeconds;
	}
}

function NewCAP(float TimeStamp, name NewState, EPhysics NewPhysics) {
	if (CurrentTimeStamp >= TimeStamp) return;
	CurrentTimeStamp = TimeStamp;

	if (IsInState(NewState) == false)
		GotoState(NewState);

	SetPhysics(NewPhysics);

	bUpdatePosition = true;
}

auto state CheatFlying
{
	ignores Speech,ShowInventory,ShowPath,Profile,ServerTaunt;

	function ForceOldServerMove() {
		local ENetRole R;
		R = Level.Role;
		Level.Role = ROLE_Authority;
		Level.SetPropertyText("ServerMoveVersion", "0");
		Level.Role = R;
	}

	event PlayerTick( float DeltaTime )
	{
		LastDeltaTime = DeltaTime;
		ForceOldServerMove();
		xxPlayerTickEvents();
		SmoothRotation(DeltaTime);
		Super.PlayerTick(DeltaTime);
	}

	function ClientUpdatePosition()
    {
        local SavedMove CurrentMove;
        local int realbRun, realbDuck;
        local bool bRealJump;

        local float TotalTime;

        bUpdatePosition = false;
        realbRun= bRun;
        realbDuck = bDuck;
        bRealJump = bPressedJump;
        CurrentMove = SavedMoves;
        bUpdating = true;
        while ( CurrentMove != None )
        {
            if ( CurrentMove.TimeStamp <= CurrentTimeStamp )
            {
                SavedMoves = CurrentMove.NextMove;
                CurrentMove.NextMove = FreeMoves;
                FreeMoves = CurrentMove;
                FreeMoves.Clear();
                CurrentMove = SavedMoves;
            }
            else
            {
                TotalTime += CurrentMove.Delta;
                CurrentMove = CurrentMove.NextMove;
            }
        }
        bUpdating = false;
        bDuck = realbDuck;
        bRun = realbRun;
        bPressedJump = bRealJump;
    }

	function ServerMove(
		float TimeStamp,
		vector InAccel,
		vector ClientLoc,
		bool NewbRun,
		bool NewbDuck,
		bool NewbJumpStatus,
		bool bFired,
		bool bAltFired,
		bool bForceFire,
		bool bForceAltFire,
		eDodgeDir DodgeMove,
		byte ClientRoll,
		int View,
		optional byte OldTimeDelta,
		optional int OldAccel
	) {
		// If this move is outdated, discard it.
		if ( CurrentTimeStamp >= TimeStamp )
			return;

		bJumpStatus = NewbJumpStatus;

		// handle firing and alt-firing
		if ( bFired )
		{
			if ( bForceFire && (Weapon != None) )
				Weapon.ForceFire();
			else if ( bFire == 0 )
				Fire(0);
			bFire = 1;
		}
		else
			bFire = 0;


		if ( bAltFired )
		{
			if ( bForceAltFire && (Weapon != None) )
				Weapon.ForceAltFire();
			else if ( bAltFire == 0 )
				AltFire(0);
			bAltFire = 1;
		}
		else
			bAltFire = 0;

		CurrentTimeStamp = TimeStamp;
		ServerTimeStamp = Level.TimeSeconds;

		SetLocation(ClientLoc);

		NewCAP(TimeStamp, GetStateName(), Physics);
	}
}

state PlayerWalking
{
	function BeginState()
	{
		GotoState('CheatFlying');
	}

	event PlayerTick( float DeltaTime )
	{
		LastDeltaTime = DeltaTime;
		xxPlayerTickEvents();
		SmoothRotation(DeltaTime);
		Super.PlayerTick(DeltaTime);
	}
}

state PlayerSwimming
{
	function BeginState()
	{
		GotoState('CheatFlying');
	}

	event PlayerTick( float DeltaTime )
	{
		LastDeltaTime = DeltaTime;
		xxPlayerTickEvents();
		SmoothRotation(DeltaTime);
		Super.PlayerTick(DeltaTime);
	}
}

exec function ViewPlayerNum(optional int num)
{
	if (zzLastView1 != Level.TimeSeconds)
	{
		DoViewPlayerNum(num);
		zzLastView1 = Level.TimeSeconds;
	}
}

function DoViewPlayerNum(int num)
{
	local Pawn P;

	if ( num >= 0 )
	{
		P = Pawn(ViewTarget);
		if ( (P != None) && P.bIsPlayer && (P.PlayerReplicationInfo.PlayerID == num) )
		{
			ViewTarget = None;
			bBehindView = false;
			return;
		}
		for ( P=Level.PawnList; P!=None; P=P.NextPawn )
			if ( (P.PlayerReplicationInfo != None)
				&& !P.PlayerReplicationInfo.bIsSpectator
				&& (P.PlayerReplicationInfo.PlayerID == num) )
			{
				if ( P != self )
				{
					ViewTarget = P;
					bBehindView = true;
				}
				return;
			}
		return;
	}
	if ( Role == ROLE_Authority )
	{
		DoViewClass(class'Pawn', true);
		While ( (ViewTarget != None)
				&& (!Pawn(ViewTarget).bIsPlayer || Pawn(ViewTarget).PlayerReplicationInfo.bIsSpectator) )
			DoViewClass(class'Pawn', true);

		if ( ViewTarget != None )
			ClientMessage(ViewingFrom@Pawn(ViewTarget).PlayerReplicationInfo.PlayerName, 'Event', true);
		else
			ClientMessage(ViewingFrom@OwnCamera, 'Event', true);
	}
}

exec function ViewPlayer( string S )
{
	if (zzLastView1 != Level.TimeSeconds)
	{
		Super.ViewPlayer(S);
		zzLastView1 = Level.TimeSeconds;
	}
}

exec function ViewClass( class<actor> aClass, optional bool bQuiet )
{
	if (zzLastView2 != Level.TimeSeconds)
	{
		DoViewClass(aClass,bQuiet);
		zzLastView2 = Level.TimeSeconds;
	}
}

function DoViewClass( class<actor> aClass, optional bool bQuiet )
{
	local actor other, first;
	local bool bFound;

	if ( (Level.Game != None) && !Level.Game.bCanViewOthers )
		return;

	first = None;
	ForEach AllActors( aClass, other )
	{
		if ( (first == None) && (other != self)
			 && ( (bAdmin && Level.Game==None) || Level.Game.CanSpectate(self, other) ) )
		{
			first = other;
			bFound = true;
		}
		if ( other == ViewTarget )
			first = None;
	}

	if ( first != None )
	{
		if ( !bQuiet )
		{
			if ( first.IsA('Pawn') && Pawn(first).bIsPlayer && (Pawn(first).PlayerReplicationInfo.PlayerName != "") )
				ClientMessage(ViewingFrom@Pawn(first).PlayerReplicationInfo.PlayerName, 'Event', true);
			else
				ClientMessage(ViewingFrom@first, 'Event', true);
		}
		ViewTarget = first;
	}
	else
	{
		if ( !bQuiet )
		{
			if ( bFound )
				ClientMessage(ViewingFrom@OwnCamera, 'Event', true);
			else
				ClientMessage(FailedView, 'Event', true);
		}
		ViewTarget = None;
	}

	bBehindView = ( ViewTarget != None );
	if ( bBehindView )
		ViewTarget.BecomeViewTarget();
}

// Admin stuff
exec function Admin( string CommandLine )
{
	local string Result;
	if( bAdmin )
		Result = ConsoleCommand( CommandLine );
	else
		Result = "You are not administrator!";

	if( Result!="" )
		ClientMessage( Result );
}


exec function AdminLogin( string Password )
{
	zzAdminLoginTries++;
	Level.Game.AdminLogin( Self, Password );
	if (bAdmin)
	{
		zzAdminLoginTries = 0;
		Log("Admin is"@PlayerReplicationInfo.PlayerName, 'UTPure');
	}
	else if (zzAdminLoginTries == 5)
	{
		ClientMessage("Adminlogin failed, you have been removed from server!");
		Log(PlayerReplicationInfo.PlayerName@"failed to adminlogin 5 times, kicked!", 'UTPureCheat');
		Destroy();
	}
}

exec function AdminLogout()
{
	Level.Game.AdminLogout( Self );
	Log("Admin was"@PlayerReplicationInfo.PlayerName);
}

event ReceiveLocalizedMessage( class<LocalMessage> Message, optional int Sw, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
	if (Message == class'CTFMessage2' && RelatedPRI_1 != None && PureFlag(RelatedPRI_1.HasFlag) != None)
		return;

	// Handle hitsounds properly here before huds get it. Remove damage except if demoplayback :P
	if (Message == class'PureHitSound')
	{
		if (RelatedPRI_1 == None)
			return;

		if (RelatedPRI_1.Owner == ViewTarget && RelatedPRI_2 != none) {
			class'bbPlayerStatics'.static.PlayHitMarker(self, Settings, Abs(Sw), RelatedPRI_2.Team, RelatedPRI_1.Team);
			class'bbPlayerStatics'.static.PlayHitSound(self, Settings, Abs(Sw), RelatedPRI_2.Team, RelatedPRI_1.Team);
		}

		return;
	}

	Super.ReceiveLocalizedMessage(Message, Sw, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

exec function HitSounds(int b)
{
	Settings.HitSound = b;
	Settings.SaveConfig();
	if (b == 0)
		ClientMessage("HitSounds: Off");
	else if (b == 1)
		ClientMessage("HitSounds: Classic Stinger");
	else if (b == 2)
		ClientMessage("HitSounds: Dynamic Cowbell (BWOOM BWOOM BWANG BWANG)");
	else if (b == 3)
		ClientMessage("HitSounds: Ouchies!");
}

exec function TeamHitSounds(int b)
{
	Settings.TeamHitSound = b;
	Settings.SaveConfig();
	if (b == 0)
		ClientMessage("TeamHitSounds: Off");
	else if (b == 1)
		ClientMessage("TeamHitSounds: Classic Stinger");
	else if (b == 2)
		ClientMessage("TeamHitSounds: Dynamic Cowbell (BWOOM BWOOM BWANG BWANG)");
	else if (b == 3)
		ClientMessage("TeamHitSounds: Ouchies!");
}

exec function FindFlag()
{
	local PlayerReplicationInfo zzPRI,zzLastFC,zzFC;
	local PlayerPawn zzPP;

	zzPP = PlayerPawn(ViewTarget);

	if (zzPP != None && CTFFlag(zzPP.PlayerReplicationInfo.HasFlag) != None)
		zzLastFC = zzPP.PlayerReplicationInfo;

	ForEach AllActors(Class'PlayerReplicationInfo',zzPRI)
	{
		if (CTFFlag(zzPRI.HasFlag) != None)
		{
			zzFC = zzPRI;
			if (zzFC != zzLastFC) break;
		}
	}

	if (zzFC == None)
		ViewClass(Class'CTFFlag');
	else
		ViewPlayerNum(zzFC.PlayerID);
}

exec function ShowStats()
{
}

exec function ShowFPS() {
	Settings.bShowFPS = !Settings.bShowFPS;
	Settings.SaveConfig();
	if (Settings.bShowFPS)
		ClientMessage("FPS shown!", 'IGPlus');
	else
		ClientMessage("FPS hidden!", 'IGPlus');
}

defaultproperties
{
}
