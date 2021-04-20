class bbPlayer extends TournamentPlayer
	config(User) abstract;

var int bReason;
// Client Config
var bool bNewNet;	// if Client wants new or old netcode. (default true)

// Replicated settings Client -> Server
var int		zzNetspeed;		// The netspeed this client is using
var bool	zzbDemoRecording;	// True if client is recording demos.
var bool bIsFinishedLoading;

// Replicated settings Server -> Client
var int		zzTrackFOV;		// Track FOV ?
var bool	zzCVDeny;		// Deny CenterView ?
var float	zzCVDelay;		// Delay for CenterView usage
var int		zzMinimumNetspeed;	// Default 10000, it's the minimum netspeed a client may have.
var int		zzMaximumNetspeed;	// Default 25000, it's the maximum netspeed a client may have.
var float	zzWaitTime;		// Used for diverse waiting.
var int		zzForceSettingsLevel;	// The Anti-Default/Ini check force.
var bool	zzbForceModels;		// Allow/Enable/Force Models for clients.
var bool	zzbForceDemo;		// Set true by server to force client to do demo.
var bool	zzbGameStarted;	// Set to true when Pawn spawns first time (ModifyPlayer)
var byte	HUDInfo;		// 0 = Off, 1 = boots/timer, 2 = Team Info too.

// Debug Stuff
var bool bDrawDebugData;
var vector debugNewAccel;
var vector debugPlayerLocation;
var vector debugClientHitLocation;
var vector debugClientHitNormal;
var vector debugClientHitDiff;
var vector debugClientEnemyHitLocation;
var vector clientForcedPosition;
var bool bClientPawnHit;
var float debugClientLocError;
var bool debugClientForceUpdate;
var bool debugClientbMoveSmooth;
var vector debugPlayerServerLocation;
var int debugNumOfForcedUpdates;
var int debugNumOfIgnoredForceUpdates;
var int debugClientPing;
var float clientLastUpdateTime;
var int debugServerMoveCallsSent;
var int debugServerMoveCallsReceived;

// Control stuff
var PureInfo zzInfoThing;	// Registers diverse stuff.
var float	zzTick;			// The Length of Last Tick
var bool	zzbNoMultiWeapon;	// Server-Side only! tells if multiweapon bug can be used.
var int     zzThrowVelocity;
var bool	zzbDemoPlayback;	// Is currently a demo playback (via xxServerMove detection)
var bool	zzbGotDemoPlaybackSpec;
var CHSpectator zzDemoPlaybackSpec;
var bbClientDemoSN zzDemoPlaybackSN;
var bool bIsAlive;

// Stuff
var float	zzDesiredFOV;		// Needed ?
var float	zzOrigFOV;		// Original FOV for TrackFOV = 1
var string	FakeClass;		// Class that the model replaces
var string	zzMyPacks;		// Defined only for defaults
var bool	zzbBadGuy;		// BadGuy! (Avoid kick spamming)
var int		zzOldForceSettingsLevel;	// Kept to see if things change.
var int     zzRecentDmgGiven, zzRecentTeamDmgGiven, TeleRadius;
var name    zzDefaultWeapon;
var float   zzLastHitSound, zzLastTeamHitSound;
var Projectile zzNN_Projectiles[256];
var vector zzNN_ProjLocations[256];
var int     zzFRVI, zzNN_FRVI, FRVI_length, zzVRVI, zzNN_VRVI, VRVI_length, zzNN_ProjIndex, NN_ProjLength, zzEdgeCount, zzCheckedCount;
var rotator zzNN_ViewRot;
var actor   zzNN_HitActor, zzOldBase;
var Vector  zzNN_HitLoc, zzClientHitNormal, zzClientHitLocation, zzNN_HitDiff, zzNN_HitLocLast, zzNN_HitNormalLast, zzNN_ClientLoc, zzNN_ClientVel;
var bool    zzbIsWarmingUp, zzbFakeUpdate, zzbForceUpdate, zzbNN_Special, zzbNN_ReleasedFire, zzbNN_ReleasedAltFire;
var float   zzNN_Accuracy, zzLastStuffUpdate, zzNextTimeTime, zzLastFallVelZ, zzLastClientErr, zzForceUpdateUntil, zzIgnoreUpdateUntil, zzLastLocDiff, zzSpawnedTime;
var TournamentWeapon zzGrappling;
var float zzGrappleTime;
var Weapon zzKilledWithWeapon;
var Pawn zzLastKilled;
var vector zzLast10Positions[10];	// every 50ms for half a second of backtracking
var bbOldMovementInfo OldestMI, NewestMI;
var int zzPositionIndex;
var float zzNextPositionTime;
var bool zzbNN_Tracing;
var Weapon zzPendingWeapon;
var bool bJustRespawned;
var float LastCAPTime; // ServerTime when last CAP was sent
var float NextRealCAPTime;
var decoration carriedFlag;

// HUD stuff
var Mutator	zzHudMutes[50];		// Accepted Hud Mutators
var Mutator	zzWaitMutes[50];	// Hud Mutes waiting to be accepted
var float	zzWMCheck[50];		// Key value
var int		zzFailedMutes;		// How many denied Mutes have been tried to add
var int		zzHMCnt;		// Counts of HudMutes and WaitMutes
var int		zzHUDWarnings;		// Counts the # of times the HUD has been changed

// Logo Display
var bool	zzbLogoDone;		// Are we done with the logo ?
var float	zzLogoStart;		// Start of logo display

var int		zzSMCnt;		// ServerMove Count
var bool	bMenuFixed;		// Fixed Menu item
var float	zzCVTO;			// CenterView Time out.

// Anti Timing Variables
var Inventory	zzAntiTimerList[32];
var int		zzAntiTimerListState;
var int		zzAntiTimerListCount;
var int		zzAntiTimerFlippedCount;

// duh:
var bool zzTrue,zzFalse;		// True & False
var int zzNull;				// == 0

// Avoiding spam:		// How many times has name been changed
var Class<ChallengeVoicePack> zzDelayedVoice;
var float zzDelayedStartTime;
var float zzLastSpeech;
var float zzLastTaunt;
var float zzLastView,zzLastView2;
var int zzKickReady;
var int zzAdminLoginTries;
var int zzOldNetspeed,zzNetspeedChanges;

// Fixing demo visual stuff
var int zzRepVRYaw, zzRepVRPitch;
var float zzRepVREye;
var bool zzbRepVRData;

// ConsoleCommand/INT Reader/Key+Alias Handling
var string zzRemResult;		// Temporary Variable to store ConsoleCommands
var string zzRemCmd;		// The command the server sent.
var bool bRemValid;		// True when valid.

var UTPure zzUTPure;		// The UTPure mutator.

var bool zzbDoScreenshot;	// True when we are about to do screenshot
var bool zzbReportScreenshot;	// True when reporting the screenshot.
var string zzMagicCode;		// The magic code to display.

var string zzPrevClientMessage;	// To log client messages...

var PureStats zzStat;		// For player stats
var PureStatMutator zzStatMut;	// The mutator that receives special calls

var PureLevelBase PureLevel;	// And Level.
var PurePlayer PurePlayer;	// And player.
var bool bDeterminedLocalPlayer;
var PlayerPawn LocalPlayer;

var TranslocatorTarget zzClientTTarget, TTarget;
var float LastTick, AvgTickDiff;

var bool SetPendingWeapon;
var bool bUseFastWeaponSwitch;

// Net Updates
var float TimeBetweenNetUpdates;
var bool bForcePacketSplit;
var int PingAverage;
var int PingCurrentAveragingSecond;
var float PingRunningAverage;
var int PingRunningAverageCount;
var float FakeCAPInterval; // Send a FakeCAP after no CAP has been sent for this amount of time
var float ExtrapolationDelta;
var bool bExtrapolatedLastUpdate;
struct SavedData {
	var() vector Location;
	var() vector Velocity;
	var() vector Acceleration;
	var() name State;
	var() EPhysics Physics;
	var() EDodgeDir DodgeDir;
};
var SavedData Saved;
var bool bIs469Server;
var bool bIs469Client;

// Clientside smoothing of position adjustment.
var vector IGPlus_PreAdjustLocation;
var vector IGPlus_AdjustLocationOffset;
var float IGPlus_AdjustLocationAlpha;
var bool IGPlus_AdjustLocationOverride;

struct ServerMoveParams {
	var float ClientDeltaTime;
	var float ServerDeltaTime;
	var vector Location;
	var vector Velocity;
	var Actor Base;
	var EPhysics Physics;
	var int TlocCounter;
};
var bool bHaveReceivedServerMove;
var ServerMoveParams LastServerMoveParams;
var int TlocCounter;
var vector TlocPrevLocation;
var bool IGPlus_DidTranslocate;
var bool IGPlus_NotifiedTranslocate;
var bool IGPlus_WantCAP;

// SSR Beam
var float LastWeaponEffectCreated;

//
var int CompressedViewRotation; // Compressed Pitch/Yaw
// 31               16               0
// +----------------+----------------+
// |     Pitch      |      Yaw       |
// +----------------+----------------+

var bool bWasPaused;

struct AddVelocityCall {
	var vector Momentum;
	var float TimeStamp;
};

var AddVelocityCall AddVelocityCalls[16];
var int LastAddVelocityIndex;
var int LastAddVelocityAppliedIndex;

// EyeHeight related variables
var bool bForceZSmoothing;
var int IgnoreZChangeTicks;
var EPhysics OldPhysics;
var float OldZ;
var float OldShakeVert;
var float OldBaseEyeHeight;
var float EyeHeightOffset;

var bool bEnableSingleButtonDodge;
var input byte bDodge;
var byte bOldDodge;
var bool bPressedDodge;
var transient float LastTimeForward, LastTimeBack, LastTimeLeft, LastTimeRight;
var transient float TurnFractionalPart, LookUpFractionalPart;
var float DuckFraction; // 0 = Not Ducking, 1 = Ducking
var float DuckTransitionTime; // Time to go from ducking to not-ducking

var float AverageServerDeltaTime;
var float TimeDead;
var float RealTimeDead;
var Pawn LastKiller;
var rotator KillCamTargetRotation;
var float KillCamDelay;
var float KillCamDuration;
var bool bKillCamWanted;
var float RespawnDelay;

var float DodgeSpeedXY;
var float DodgeSpeedZ;
var float SecondaryDodgeSpeedXY;
var float SecondaryDodgeSpeedZ;
var float DodgeEndVelocity;
var float JumpEndVelocity;
var bool bJumpingPreservesMomentum;
var bool bUseFlipAnimation;
var bool bCanWallDodge;
var bool bDodging;
var bool bDodgePreserveZMomentum;
var int MultiDodgesRemaining;

var bool bAppearanceChanged;
var bool bClientDead;

var Object ClientSettingsHelper;
var ClientSettings Settings;

var int FrameCount;

var int BrightskinMode;
var NavigationPoint DelayedNavPoint;

var float OffsetZBeforeTeleporter;
var vector VelocityBeforeTeleporter;
var rotator RotationBeforeTeleporter;
var Teleporter LastTouchedTeleporter;

var int HitMarkerTestDamage;
var int HitMarkerTestTeam;

var bbServerMove FirstServerMove;
var bbServerMove LatestServerMove;
var bbServerMove FreeServerMove;

var Utilities Utils;
var StringUtils StringUtils;
var bbPlayerStatics PlayerStatics;

replication
{
	//	Client->Demo
	unreliable if ( bClientDemoRecording )
		ClientDemoMessage,
		xxClientLogToDemo,
		xxReplicateVRToDemo;

	reliable if (bClientDemoRecording && !bClientDemoNetFunc)
		xxClientDemoFix,
		xxClientDemoBolt;

	reliable if ((Role == ROLE_Authority) && !bClientDemoRecording)
		xxNN_ClientProjExplode;

	// Server->Client
	unreliable if ( bNetOwner && Role == ROLE_Authority )
		bEnableSingleButtonDodge,
		bIs469Server,
		KillCamDelay,
		KillCamDuration,
		LastKiller,
		zzAntiTimerList,
		zzAntiTimerListCount,
		zzAntiTimerListState,
		zzCVDelay,
		zzCVDeny,
		zzMaximumNetspeed,
		zzMinimumNetspeed,
		zzStat,
		zzTrackFOV,
		zzWaitTime;

	// Server->Client
	reliable if ( bNetOwner && Role == ROLE_Authority )
		HUDInfo,
		zzbForceDemo,
		zzbGameStarted,
		zzForceSettingsLevel;

	// Server->Client
	reliable if ( Role == ROLE_Authority )
		bCanWallDodge,
		bDodgePreserveZMomentum,
		bIsAlive,
		bJumpingPreservesMomentum,
		BrightskinMode,
		bUseFastWeaponSwitch,
		bUseFlipAnimation,
		DuckFraction,
		Ready,
		RespawnDelay,
		SetPendingWeapon,
		TimeBetweenNetUpdates,
		xxClientKicker,
		xxClientSwJumpPad,
		xxSetDefaultWeapon,
		xxSetPendingWeapon,
		xxSetSniperSpeed,
		xxSetTeleRadius,
		xxSetTimes,
		zzbForceModels,
		zzbIsWarmingUp;

	// Client->Server
	reliable if ( Role == ROLE_AutonomousProxy )
		bDrawDebugData,
		FakeCAPInterval;

	// Server->Client debug data
	unreliable if ( Role == ROLE_Authority && bDrawDebugData && RemoteRole == ROLE_AutonomousProxy )
		ClientDebugMessage,
		clientForcedPosition,
		clientLastUpdateTime,
		debugClientbMoveSmooth,
		debugClientForceUpdate,
		debugClientLocError,
		debugClientPing,
		debugNumOfForcedUpdates,
		debugPlayerServerLocation,
		debugServerMoveCallsReceived,
		ExtrapolationDelta;

	// Server->Client function reliable.. no demo propogate! .. bNetOwner? ...
	reliable if ( RemoteRole == ROLE_AutonomousProxy && !bDemoRecording )
		xxCheatFound,
		xxClientConsole,
		xxClientDoEndShot,
		xxClientDoScreenshot,
		xxClientKeys,
		xxClientReadINT,
		xxClientSet;

	// Server->Client function.
	unreliable if (RemoteRole == ROLE_AutonomousProxy)
		ClientAddMomentum,
		xxCAP,
		xxCAPLevelBase,
		xxCAPWalking,
		xxCAPWalkingWalking,
		xxCAPWalkingWalkingLevelBase,
		xxClientResetPlayer,
		xxFakeCAP;

	reliable if (RemoteRole == ROLE_AutonomousProxy)
		xxClientReStart;

	// Client->Server
	unreliable if ( Role < ROLE_Authority )
		bIsFinishedLoading,
		PingAverage,
		xxServerCheater,
		xxServerMove,
		xxServerMoveDead,
		zzbDemoRecording,
		zzFalse,
		zzNetspeed,
		zzTrue;

	// Client->Server
	reliable if ( Role < ROLE_Authority )
		DropFlag,
		Go,
		Hold,
		ShowStats,
		xxExplodeOther,
		xxNN_AltFire,
		xxNN_Fire,
		xxSendDeathMessageToSpecs,
		xxSendHeadshotToSpecs,
		xxSendMultiKillToSpecs,
		xxSendSpreeToSpecs,
		xxServerAckScreenshot,
		xxServerDemoReply,
		xxServerReceiveConsole,
		xxServerReceiveINT,
		xxServerReceiveKeys,
		xxServerReceiveMenuItems,
		xxServerReceiveStuff,
		xxServerSetForceModels,
		xxServerSetMinDodgeClickTime,
		xxServerSetReadyToPlay,
		xxServerSetTeamInfo,
		xxSetNetUpdateRate;

	reliable if ((Role < ROLE_Authority) && !bClientDemoRecording)
		xxNN_ProjExplode,
		xxNN_ReleaseAltFire,
		xxNN_ReleaseFire;

	// Server->Client
	unreliable if (Role == ROLE_Authority && RemoteRole < ROLE_AutonomousProxy && bViewTarget)
		CompressedViewRotation;

	reliable if ( (!bDemoRecording || (bClientDemoRecording && bClientDemoNetFunc) || (Level.NetMode==NM_Standalone)) && Role == ROLE_Authority )
		ReceiveWeaponEffect;
	reliable if (bClientDemoRecording)
		DemoReceiveWeaponEffect;

	reliable if (Role == ROLE_AutonomousProxy || RemoteRole <= ROLE_SimulatedProxy)
		bIs469Client;
}

//XC_Engine interface
native(1719) final function bool IsInPackageMap( optional string PkgName, optional bool bServerPackagesOnly);

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

simulated function DemoReceiveWeaponEffect(
	class<WeaponEffect> Effect,
	Actor Source,
	vector SourceLocation,
	vector SourceOffset,
	Actor Target,
	vector TargetLocation,
	vector TargetOffset,
	vector HitNormal
) {
	if (LastWeaponEffectCreated >= 0) return;
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
	LastWeaponEffectCreated = Level.TimeSeconds;
	DemoReceiveWeaponEffect(Effect, Source, SourceLocation, SourceOffset, Target, TargetLocation, TargetOffset, HitNormal * 32767);
}

/* More crash fix bs */
simulated function bool xxGarbageLocation(actor Other)
{
	return (InStr(Caps(string(Other.Location.X)), "N") > -1 ||
		InStr(Caps(string(Other.Location.Y)), "N") > -1 ||
		InStr(Caps(string(Other.Location.Z)), "N") > -1);
}

exec function Fly()
{
	zzForceUpdateUntil = Level.TimeSeconds + 0.5;
	zzbForceUpdate = true;
	Super.Fly();
}

exec function Ghost()
{
	zzForceUpdateUntil = Level.TimeSeconds + 0.5;
	zzbForceUpdate = true;
	Super.Ghost();
}

simulated event Destroyed() {
	if (Role == ROLE_Authority && zzUTPure != none) {
		zzUTPure.ModifyLogout(self);
	}
	super.Destroyed();
}

// Return true to override Teleporter
simulated event bool PreTeleport(Teleporter T) {
	local vector D;
	D = Location - T.Location;
	if (VSize(D * vect(1,1,0)) > CollisionRadius + T.CollisionRadius ||
		Abs(D.Z) > CollisionHeight + T.CollisionHeight
	) {
		// Were not touching the teleporter just yet.
		// Do nothing and
		return true;
	}

	OffsetZBeforeTeleporter = Location.Z - T.Location.Z;
	VelocityBeforeTeleporter = Velocity;
	RotationBeforeTeleporter = Rotation;
	LastTouchedTeleporter = T;
	bForcePacketSplit = true;
	return false;
}

simulated function Touch( actor Other )
{
	if(Level.NetMode != NM_Client)
	{
		if (Class'UTPure'.Default.ShowTouchedPackage)
		{
			ClientMessage(class'StringUtils'.static.PackageOfObject(Other));
		}

		if ((Other.IsA('Kicker') && Other.Class.Name != 'NN_Kicker')) {
			ClientDebugMessage("Touch forced updates");
			zzForceUpdateUntil = Level.TimeSeconds + 0.15 + float(Other.GetPropertyText("ToggleTime"));
			zzbForceUpdate = true;
		} else if (Other.IsA('JumpPadDM')) {
			ClientDebugMessage("Touch forced updates");
			zzForceUpdateUntil = Level.TimeSeconds + 0.0011*PlayerReplicationInfo.Ping*Level.TimeDilation;
		}
	}
	if (Other.IsA('Kicker') || Other.IsA('NN_swJumpPad'))
		bForcePacketSplit = true;
	if (Other.IsA('bbPlayer') && bbPlayer(Other).Health > 0)
		zzIgnoreUpdateUntil = ServerTimeStamp + 0.15;
	if (Other.IsA('Teleporter'))
		IgnoreZChangeTicks = 2;
	Super.Touch(Other);
}


simulated function bool xxNewSetLocation(vector NewLoc, vector NewVel)
{
	if (!SetLocation(NewLoc))
		return false;
	Velocity = NewVel;
	return true;
}

simulated function bool xxNewMoveSmooth(vector NewLoc)
{
	return MoveSmooth(NewLoc - Location);
}

simulated function xxClientKicker(
	float KCollisionRadius,
	float KCollisionHeight,
	vector KLocation,
	int KRotationYaw,
	int KRotationPitch,
	int KRotationRoll,
	name KTag,
	name KEvent,
	float KKickVelocityX,
	float KKickVelocityY,
	float KKickVelocityZ,
	name KKickedClasses,
	bool KbKillVelocity,
	bool KbRandomize
) {
	local Kicker K;
	local AttachMover AM;
	local rotator KRotation;
	local vector KKickVelocity;

	if(Level.NetMode != NM_Client)
		return;

	KRotation.Yaw = KRotationYaw;
	KRotation.Pitch = KRotationPitch;
	KRotation.Roll = KRotationRoll;
	KKickVelocity.X = KKickVelocityX;
	KKickVelocity.Y = KKickVelocityY;
	KKickVelocity.Z = KKickVelocityZ;

	K = Spawn(class'NN_Kicker', Self, , KLocation, KRotation);
	K.SetCollisionSize(KCollisionRadius, KCollisionHeight);
	K.Tag = KTag;
	K.Event = KEvent;
	K.KickVelocity = KKickVelocity;
	K.KickedClasses = KKickedClasses;
	K.bKillVelocity = KbKillVelocity;
	K.bRandomize = KbRandomize;

	if(K.Tag != '')
		foreach AllActors(class'AttachMover', AM)
			if(AM.AttachTag == K.Tag) {
				K.SetBase(AM);
				break;
			}
}

function xxClientSwJumpPad(
	name TTag,
	name TEvent,
	vector TLocation,
	vector TRotation,
	vector TCollJA,
	string TURL,
	int MiscData,
	vector MiscData2,
	vector TTargetRand,
	string JumpEffect,
	string JumpPlayerEffect,
	string JumpEvent,
	string JumpSound,
	vector TargetLocation,
	vector TargetCollision
) {
	local NN_swJumpPad J;
	local AttachMover AM;
	local rotator TRot;
	local NN_swJumpPad_DestinationDummy Target;

	if (Level.NetMode != NM_Client)
		return;

	TRot.Pitch = int(TRotation.X) & 0xFFFF;
	TRot.Yaw = int(TRotation.Y) & 0xFFFF;
	TRot.Roll = int(TRotation.Z) & 0xFFFF;
	J = Spawn(class'NN_swJumpPad', Self, TTag, TLocation, TRot);
	J.SetCollisionSize(TCollJA.X / 10.0, TCollJA.Y / 10.0);
	J.Event = TEvent;
	J.URL = TURL;
	J.JumpAngle = TCollJA.Z / 256.0;
	J.TeamNumber = MiscData & 0xFF;
	J.bTeamOnly = (MiscData & 0x100) != 0;
	J.TargetZOffset = MiscData2.X;
	J.TargetRand = TTargetRand;
	J.bTraceGround = (MiscData & 0x200) != 0;
	J.bDisabled = (MiscData & 0x400) != 0;
	J.AngleRand = MiscData2.Y / 256.0;
	J.SetPropertyText("AngleRandMode", string((MiscData >> 12) & 3));
	J.SetPropertyText("JumpEffect", JumpEffect);
	J.SetPropertyText("JumpPlayerEffect", JumpPlayerEffect);
	J.SetPropertyText("JumpEvent", JumpEvent);
	J.SetPropertyText("JumpSound", JumpSound);
	J.bClientSideEffects = false;
	J.JumpWait = MiscData2.Z / 50.0;

	Target = Spawn(class'NN_swJumpPad_DestinationDummy', self,, TargetLocation);
	Target.SetCollisionSize(TargetCollision.X*0.1, TargetCollision.Y*0.1);
	J.JumpTarget = Target;

	if(J.Tag != '')
		foreach AllActors(class'AttachMover', AM)
			if(AM.AttachTag == J.Tag) {
				J.SetBase(AM);
				break;
			}
}

function vector ParseVector(string s) {
	local vector V;

	s = Mid(s, InStr(s, "=")+1, Len(s));
	V.X = float(s);
	s = Mid(s, InStr(s, "=")+1, Len(s));
	V.Y = float(s);
	s = Mid(s, InStr(s, "=")+1, Len(s));
	V.Z = float(s);

	return V;
}

function ReplicateSwJumpPad(Teleporter T) {
	local vector RotV;
	local vector CollJA;
	local int MiscData;
	local vector MiscData2;
	local Actor Target;
	local vector TargetCollision;

	RotV.X = T.Rotation.Pitch << 16 >> 16;
	RotV.Y = T.Rotation.Yaw << 16 >> 16;
	RotV.Z = T.Rotation.Roll << 16 >> 16;

	CollJA.X = T.CollisionRadius * 10;
	CollJA.Y = T.CollisionHeight * 10;

	CollJA.Z = float(T.GetPropertyText("JumpAngle")) * 256;

	MiscData = MiscData | (int(T.GetPropertyText("TeamNumber")) & 0xFF);
	if (T.GetPropertyText("bTeamOnly") ~= "true")
		MiscData = MiscData | 0x100;
	if (T.GetPropertyText("bTraceGround") ~= "true")
		MiscData = MiscData | 0x200;
	if (T.GetPropertyText("bDisabled") ~= "true")
		MiscData = MiscData | 0x400;
	if (T.GetPropertyText("bClientSideEffects") ~= "true")
		MiscData = MiscData | 0x800;
	MiscData = MiscData | (int(T.GetPropertyText("AngleRandMode")) << 12);

	MiscData2.X = float(T.GetPropertyText("TargetZOffset"));
	MiscData2.Y = float(T.GetPropertyText("AngleRand")) * 256.0;
	MiscData2.Z = float(T.GetPropertyText("JumpWait")) * 50.0;

	foreach AllActors(class'Actor', Target)
		if (string(Target.Tag) ~= T.URL && Target != T)
			break;

	if (Target != none && string(Target.Tag) ~= T.URL && Target != T) {}
	else {
		// invalid target for swJumpPad
		return;
	}

	TargetCollision.X = Target.CollisionRadius*10;
	TargetCollision.Y = Target.CollisionHeight*10;

	xxClientSwJumpPad(
		T.Tag,
		T.Event,
		T.Location,
		RotV,
		CollJA,
		T.URL,
		MiscData,
		MiscData2,
		ParseVector(T.GetPropertyText("TargetRand")),
		T.GetPropertyText("JumpEffect"),
		T.GetPropertyText("JumpPlayerEffect"),
		T.GetPropertyText("JumpEvent"),
		T.GetPropertyText("JumpSound"),
		Target.Location,
		TargetCollision
	);
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
		ClientSettingsHelper = new(none, 'InstaGibPlus') class'Object'; // object name = INI file name
		Settings = new(ClientSettingsHelper, 'ClientSettings') class'ClientSettings'; // object name = Section name
		Settings.CheckConfig();
		Log("Loaded Settings!", 'IGPlus');
	}
}

event PostBeginPlay()
{
	local int TickRate;
	Super.PostBeginPlay();
	InitSettings();

	if ( Level.NetMode != NM_Client )
	{
		zzMinimumNetspeed = Class'UTPure'.Default.MinClientRate;
		zzMaximumNetspeed = Class'UTPure'.Default.MaxClientRate;
		zzWaitTime = 5.0;
	}
	SetPendingWeapon = class'UTPure'.Default.SetPendingWeapon;

	TickRate = int(ConsoleCommand("get ini:Engine.Engine.NetworkDevice NetServerMaxTickRate"));
	TickRate = ++TickRate / 2;
	Log("Creating"@TickRate@"MovementInfo blocks", 'IGPlus');
	while(TickRate > 0) {
		if (OldestMI == none) {
			OldestMI = new(none) class'bbOldMovementInfo';
			NewestMI = OldestMI;
		} else {
			NewestMI.Next = new(none) class'bbOldMovementInfo';
			NewestMI = NewestMI.Next;
		}
		NewestMI.Save(self);
		TickRate--;
	}
}

// called after PostBeginPlay on net client
simulated event PostNetBeginPlay()
{
	InitSettings();

	if ( Role != ROLE_SimulatedProxy )	// Other players are Simulated, local player is Autonomous or Authority (if listen server which pure doesn't support anyway :P)
	{
		return;
	}

	if ( bIsMultiSkinned )
	{
		if ( MultiSkins[1] == None )
		{
			if ( bIsPlayer && PlayerReplicationInfo != None)
				SetMultiSkin(self, "","", PlayerReplicationInfo.team);
			else
				SetMultiSkin(self, "","", 0);
		}
	}
	else if ( Skin == None )
		Skin = Default.Skin;


	if ( (PlayerReplicationInfo != None)
		&& (PlayerReplicationInfo.Owner == None) )
		PlayerReplicationInfo.SetOwner(self);
}

static function SetMultiSkin(Actor SkinActor, string SkinName, string FaceName, byte TeamNum) {
	local PlayerPawn P;
	local bbPlayerReplicationInfo bbPRI;
	P = PlayerPawn(SkinActor);
	if (P != none) {
		bbPRI = bbPlayerReplicationInfo(P.PlayerReplicationInfo);
		if (P.Role == ROLE_Authority && bbPRI != none) {

			bbPRI.SkinName = SkinName;
			bbPRI.FaceName = FaceName;
		}
	}
	super.SetMultiSkin(SkinActor, SkinName, FaceName, TeamNum);
}

event Possess()
{
	local Kicker K;

	Utils = new(none) class'Utilities';
	StringUtils = new(none) class'StringUtils';
	PlayerStatics = Spawn(class'bbPlayerStatics');

	InitSettings();

	if ( Level.Netmode == NM_Client )
	{	// Only do this for clients.
		SetTimer(3, false);
		Log("Possessed PlayerPawn (bbPlayer) by InstaGib Plus");
		zzTrue = !zzFalse;
		zzInfoThing = Spawn(Class'PureInfo');
		SetNetUpdateRate(Settings.DesiredNetUpdateRate);
		xxServerSetForceModels(Settings.bForceModels);
		xxServerSetTeamInfo(Settings.bTeamInfo);
		xxServerSetMinDodgeClickTime(Settings.MinDodgeClickTime);
		if (class'UTPlayerClientWindow'.default.PlayerSetupClass != class'UTPureSetupScrollClient')
			class'UTPlayerClientWindow'.default.PlayerSetupClass = class'UTPureSetupScrollClient';
		// This blocks silly set commands by kicking player, after resetting them.
		if (	Class'ZoneInfo'.Default.AmbientBrightness != 0		||
			Class'ZoneInfo'.Default.AmbientSaturation != 255	||
			Class'LevelInfo'.Default.AmbientBrightness != 0		||
			Class'LevelInfo'.Default.AmbientSaturation != 255	||
			Class'WaterZone'.Default.AmbientBrightness != 0		||
			Class'WaterZone'.Default.AmbientSaturation != 255)
		{
			Class'ZoneInfo'.Default.AmbientBrightness = 0;
			Class'ZoneInfo'.Default.AmbientSaturation = 255;
			Class'LevelInfo'.Default.AmbientBrightness = 0;
			Class'LevelInfo'.Default.AmbientSaturation = 255;
			Class'WaterZone'.Default.AmbientBrightness = 0;
			Class'WaterZone'.Default.AmbientSaturation = 255;
			xxServerCheater(chr(90)$chr(68));		// ZD
		}
		if (	Class'WaterTexture'.Default.bInvisible		||
			Class'Actor'.Default.Fatness != 128		||
			Class'PlayerShadow'.Default.DrawScale != 0.5	||
			Class'PlayerShadow'.Default.Texture != Texture'Botpack.EnergyMark')
		{
			Class'WaterTexture'.Default.bInvisible = False;
			Class'Actor'.Default.Fatness = 128;
			Class'PlayerShadow'.Default.DrawScale = 0.5;
			Class'PlayerShadow'.Default.Texture = Texture'Botpack.EnergyMark';
			xxServerCheater(chr(90)$chr(69));		// ZE
		}
		SetPropertyText("PureLevel", GetPropertyText("xLevel"));
		FakeCAPInterval = Settings.FakeCAPInterval;
		ClientSetMusic( Level.Song, Level.SongSection, Level.CdTrack, MTRAN_Fade );

		bIs469Client = int(Level.EngineVersion) >= 469;
	}
	else
	{
		TeleRadius = zzUTPure.Default.TeleRadius;
		xxSetTeleRadius(TeleRadius);

		BrightskinMode = class'UTPure'.default.BrightskinMode;

		xxSetSniperSpeed(class'UTPure'.default.SniperSpeed);
		xxSetDefaultWeapon(Level.Game.BaseMutator.MutatedDefaultWeapon().name);

		GameReplicationInfo.RemainingTime = DeathMatchPlus(Level.Game).RemainingTime;
		GameReplicationInfo.ElapsedTime = DeathMatchPlus(Level.Game).ElapsedTime;
		xxSetTimes(GameReplicationInfo.RemainingTime, GameReplicationInfo.ElapsedTime);

		KillCamDelay = FMax(0.0, class'UTPure'.default.KillCamDelay);
		KillCamDuration = class'UTPure'.default.KillCamDuration;
		bJumpingPreservesMomentum = class'UTPure'.default.bJumpingPreservesMomentum;
		bEnableSingleButtonDodge = class'UTPure'.default.bEnableSingleButtonDodge;
		bUseFlipAnimation = class'UTPure'.default.bUseFlipAnimation;
		bCanWallDodge = class'UTPure'.default.bEnableWallDodging;
		bDodgePreserveZMomentum = class'UTPure'.default.bDodgePreserveZMomentum;
		bUseFastWeaponSwitch = class'UTPure'.default.bUseFastWeaponSwitch;

		if(!zzUTPure.bExludeKickers)
		{
			ForEach AllActors(class'Kicker', K)
			{
				if (K.Class.Name != 'Kicker')
					continue;

				xxClientKicker(
					K.CollisionRadius, K.CollisionHeight,
					K.Location,
					K.Rotation.Yaw, K.Rotation.Pitch, K.Rotation.Roll,
					K.Tag, K.Event,
					K.KickVelocity.X, K.KickVelocity.Y, K.KickVelocity.Z,
					K.KickedClasses,
					K.bKillVelocity,
					K.bRandomize
				);
			}

			DelayedNavPoint = Level.NavigationPointList;
		}

		bIs469Server = int(Level.EngineVersion) >= 469;
		if (RemoteRole != ROLE_AutonomousProxy)
			bIs469Client = bIs469Server;
	}

	Super.Possess();
}

function Timer() {

	if (bReason == 1) {
		bReason = 0;
		reconnectClient();
		return;
	}

	if (bIsFinishedLoading == false) {
		bIsFinishedLoading = true;
		ClientMessage("[IG+] To view available commands type 'mutate playerhelp' in the console");
	}
}

function ClientSetLocation( vector zzNewLocation, rotator zzNewRotation )
{
	local bbSavedMove M;
	local int Pitch;

	zzNewRotation.Roll = 0;
	Pitch = Clamp(Utils.RotU2S(zzNewRotation.Pitch), -16384, 16383);
	zzNewRotation.Pitch = Utils.RotS2U(Pitch);
	ViewRotation = zzNewRotation;
	zzNewRotation.Pitch = Utils.RotS2U(Clamp(Pitch, -RotationRate.Pitch, RotationRate.Pitch));
	SetRotation( zzNewRotation );
	SetLocation( zzNewLocation );

	// Clean up moves
	if (PendingMove != none) {
		PendingMove.NextMove = FreeMoves;
		bbSavedMove(PendingMove).Clear2();
		FreeMoves = PendingMove;
		PendingMove = none;
	}

	while(SavedMoves != none) {
		M = bbSavedMove(SavedMoves);
		SavedMoves = M.NextMove;
		M.NextMove = FreeMoves;
		M.Clear2();
		FreeMoves = M;
	}
}

function xxClientReStart(EPhysics phys, vector NewLocation, rotator NewRotation) {
	ClientSetLocation(NewLocation, NewRotation);
	ClientReStart();
	SetPhysics(phys);
}

event ReceiveLocalizedMessage( class<LocalMessage> Message, optional int Sw, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
	if (Message == class'CTFMessage2' && PureFlag(PlayerReplicationInfo.HasFlag) != None)
		return;

	// Handle hitsounds properly here before huds get it. Remove damage except if demoplayback :P
	if (Message == class'PureHitSound')
	{
		if (RelatedPRI_1 == None)
			return;

		if (Settings.HitMarkerSource == 0 && RelatedPRI_2 != none)
			class'bbPlayerStatics'.static.PlayHitMarker(self, Settings, Abs(Sw), RelatedPRI_2.Team, RelatedPRI_1.Team);

		if (Settings.HitSoundSource == 0 && RelatedPRI_2 != none)
			class'bbPlayerStatics'.static.PlayHitSound(self, Settings, Abs(Sw), RelatedPRI_2.Team, RelatedPRI_1.Team);

		return;
	}
	else if (Message == class'DecapitationMessage')
	{
		xxSendHeadshotToSpecs(Sw, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	}
	else if (RelatedPRI_1 == PlayerReplicationInfo || RelatedPRI_2 == PlayerReplicationInfo)
	{
		if (ClassIsChildOf(Message, class'DeathMessagePlus') || Message.Name == 'DDeathMessagePlus')
			xxSendDeathMessageToSpecs(Sw, RelatedPRI_1, RelatedPRI_2, OptionalObject);
		else if (ClassIsChildOf(Message, class'MultiKillMessage') || Message.Name == 'MMultiKillMessage')
			xxSendMultiKillToSpecs(Sw, RelatedPRI_1, RelatedPRI_2, OptionalObject);
		else if (ClassIsChildOf(Message, class'KillingSpreeMessage'))
			xxSendSpreeToSpecs(Sw, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	}

	Super.ReceiveLocalizedMessage(Message, Sw, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

function xxSendHeadshotToSpecs(optional int Sw, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	local Pawn P;
	for ( P=Level.PawnList; P!=None; P=P.NextPawn )
		if (P.IsA('bbCHSpectator') && bbCHSpectator(P).ViewTarget == Self)
			P.ReceiveLocalizedMessage( class'DecapitationMessage', Sw, RelatedPRI_1, RelatedPRI_2, OptionalObject );
}

function xxSendDeathMessageToSpecs(optional int Sw, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	local Pawn P;
	for ( P=Level.PawnList; P!=None; P=P.NextPawn )
		if (P.IsA('bbCHSpectator') && bbCHSpectator(P).ViewTarget == Self)
			P.ReceiveLocalizedMessage( class'SpecMessagePlus', Sw, RelatedPRI_1, RelatedPRI_2, OptionalObject );
}

function xxSendMultiKillToSpecs(optional int Sw, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	local Pawn P;
	for ( P=Level.PawnList; P!=None; P=P.NextPawn )
		if (P.IsA('bbCHSpectator') && bbCHSpectator(P).ViewTarget == Self)
			P.ReceiveLocalizedMessage( class'MultiKillMessage', Sw, RelatedPRI_1, RelatedPRI_2, OptionalObject );
}

function xxSendSpreeToSpecs(optional int Sw, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	local Pawn P;
	for ( P=Level.PawnList; P!=None; P=P.NextPawn )
		if (P.IsA('bbCHSpectator') && bbCHSpectator(P).ViewTarget == Self)
			P.ReceiveLocalizedMessage( class'SpecSpreeMessage', Sw, RelatedPRI_1, RelatedPRI_2, OptionalObject );
}

event PlayerTick( float Time )
{
	xxPlayerTickEvents(Time);
	zzTick = Time;
}

simulated function ClientDemoMessage(coerce string S, optional name Type, optional bool bBeep)
{
	if (S == zzPrevClientMessage)
		return;
	ClientMessage(S, Type, bBeep);
}

event ClientMessage(coerce string zzS, optional Name zzType, optional bool zzbBeep)
{
	zzPrevClientMessage = zzS;
	Super.ClientMessage(zzS, zzType, zzbBeep);
	zzPrevClientMessage = "";
	if (Settings.bLogClientMessages) {
		if (zzType == 'IGPlusDebug') {
			Log(zzS, zzType);
		} else {
			Log("["$FrameCount@Level.TimeSeconds$"]"@zzS, zzType);
		}
	}
}

function ClientDebugMessage(coerce string S, optional name Type, optional bool bBeep) {
	if (Level.NetMode == NM_DedicatedServer || Role < ROLE_AutonomousProxy)
		return;

	if (Type == '')
		Type = 'IGPlusDebug';

	if (bDrawDebugData) {
		ClientMessage("["$FrameCount@Level.TimeSeconds$"] "$S, Type, bBeep);
	} else {
		zzPrevClientMessage = "["$FrameCount@Level.TimeSeconds$"] "$S;
		ClientDemoMessage(zzPrevClientMessage, Type, bBeep);
		zzPrevClientMessage = "";
	}
}

function rotator GR()
{
	return ViewRotation;
}

event UpdateEyeHeight(float DeltaTime)
{
	local float DeltaZ;

	// smooth up/down stairs, landing, dont smooth ramps
	if ((Physics == PHYS_Walking && bJustLanded == false) ||
		// Smooth out stepping up onto unwalkable ramps
		(OldPhysics == PHYS_Walking && Physics == PHYS_Falling)
	) {
		DeltaZ = Location.Z - OldZ;

		// remove lifts from the equation.
		if (Base != none)
			DeltaZ -= DeltaTime * Base.Velocity.Z;

		// stair detection heuristic
		if (IgnoreZChangeTicks == 0 && (Abs(DeltaZ) > DeltaTime * GroundSpeed || bForceZSmoothing))
			EyeHeightOffset += FClamp(DeltaZ, -MaxStepHeight, MaxStepHeight);
		bForceZSmoothing = false;
	} else if (bJustLanded) {
		// Always smooth out landing, because you apparently are not considered
		// to have landed until you penetrate the ground by at least 1% of Velocity.Z.
		bForceZSmoothing = true;
	}

	if (IgnoreZChangeTicks > 0) IgnoreZChangeTicks--;
	bJustLanded = false;
	OldPhysics = Physics;
	OldZ = Location.Z;

	EyeHeightOffset += ShakeVert - OldShakeVert;
	OldShakeVert = ShakeVert;

	EyeHeightOffset += BaseEyeHeight - OldBaseEyeHeight;
	OldBaseEyeHeight = BaseEyeHeight;

	EyeHeightOffset = EyeHeightOffset * Exp(-9.0 * DeltaTime);
	EyeHeight = ShakeVert + BaseEyeHeight - EyeHeightOffset;

	// teleporters affect your FOV, so adjust it back down
	if (FOVAngle != DesiredFOV) {
		if (FOVAngle > DesiredFOV)
			FOVAngle = FOVAngle - FMax(7, 0.9 * DeltaTime * (FOVAngle - DesiredFOV));
		else
			FOVAngle = FOVAngle - FMin(-7, 0.9 * DeltaTime * (FOVAngle - DesiredFOV));
		if (Abs(FOVAngle - DesiredFOV) <= 10)
			FOVAngle = DesiredFOV;
	}

	// adjust FOV for weapon zooming
	if (bZooming) {
		ZoomLevel += DeltaTime * 1.0;
		if (ZoomLevel > 0.9)
			ZoomLevel = 0.9;
		DesiredFOV = FClamp(90.0 - (ZoomLevel * 88.0), 1, 170);
	}

	xxCheckFOV();
}

event Landed(vector HitNormal)
{
	//Note - physics changes type to PHYS_Walking by default for landed pawns
	if ( bUpdating )
		return;
	PlayLanded(Velocity.Z);
	LandBob = FMin(50, Bob * Velocity.Z);
	TakeFallingDamage();
	bJustLanded = true;
}

function xxCheckFOV()
{
	if (zzTrackFOV == 1)
	{
		if (zzOrigFOV < 80)
		{
			if (DesiredFOV < 80)
				DesiredFOV = 90;
			zzOrigFOV = DesiredFOV;
		}
		if (zzOrigFOV != DesiredFOV && (Weapon == None || !Weapon.IsA('SniperRifle')))
		{
			DesiredFOV = zzOrigFOV;
			FOVAngle = zzOrigFOV;
		}
	}
	else if (zzTrackFOV == 2)
	{
		if ((DesiredFOV < 80 || FOVAngle < 80) && (Weapon == None || !Weapon.IsA('SniperRifle')))
		{
			if (zzOrigFOV < 80)
			{
				if (DesiredFOV < 80)
					DesiredFOV = 90;
				zzOrigFOV = DesiredFOV;
			}
			DesiredFOV = zzOrigFOV;
			FOVAngle = zzOrigFOV;
		}
	}
}

event PlayerInput( float DeltaTime )
{
	local float Now, SmoothTime, FOVScale, MouseScale, AbsSmoothX, AbsSmoothY, MouseTime;
	local bool bOldWasForward, bOldWasBack, bOldWasLeft, bOldWasRight;

	Now = Level.TimeSeconds;

	// Check for Dodge move
	// flag transitions
	bOldWasForward = bWasForward;
	bOldWasBack = bWasBack;
	bOldWasLeft = bWasLeft;
	bOldWasRight = bWasRight;
	bWasForward = (aBaseY >= 1);
	bWasBack = (aBaseY <= -1);
	bWasLeft = (aStrafe >= 1);
	bWasRight = (aStrafe <= -1);
	bEdgeForward = bOldWasForward != bWasForward;
	bEdgeBack = bOldWasBack != bWasBack;
	bEdgeLeft = bOldWasLeft != bWasLeft;
	bEdgeRight = bOldWasRight != bWasRight;
	if (Settings.bDebugMovement && (bEdgeForward || bEdgeBack || bEdgeLeft || bEdgeRight))
		ClientDebugMessage("BaseY:"@aBaseY@"Strafe:"@aStrafe@bWasForward@bWasBack@bWasLeft@bWasRight);

	bPressedDodge = (bDodge != bOldDodge) && (bDodge > 0);
	bOldDodge = bDodge;

	// Smooth and amplify mouse movement
	SmoothTime = FMin(0.2, 3 * DeltaTime * Level.TimeDilation);
	FOVScale = DesiredFOV * 0.01111;
	MouseScale = MouseSensitivity * FOVScale;

	aMouseX *= MouseScale;
	aMouseY *= MouseScale;

//************************************************************************

	AbsSmoothX = SmoothMouseX;
	AbsSmoothY = SmoothMouseY;
	if (Settings.bNoSmoothing) {
		SmoothMouseX = aMouseX;
		SmoothMouseY = aMouseY;
		BorrowedMouseX = 0;
		BorrowedMouseY = 0;
	} else {
		MouseTime = (Level.TimeSeconds - MouseZeroTime)/Level.TimeDilation;
		if ( bMaxMouseSmoothing && (aMouseX == 0) && (MouseTime < MouseSmoothThreshold) )
		{
			SmoothMouseX = 0.5 * (MouseSmoothThreshold - MouseTime) * AbsSmoothX/MouseSmoothThreshold;
			BorrowedMouseX += SmoothMouseX;
		}
		else
		{
			if ( (SmoothMouseX == 0) || (aMouseX == 0)
					|| ((SmoothMouseX > 0) != (aMouseX > 0)) )
			{
				SmoothMouseX = aMouseX;
				BorrowedMouseX = 0;
			}
			else
			{
				SmoothMouseX = 0.5 * (SmoothMouseX + aMouseX - BorrowedMouseX);
				if ( (SmoothMouseX > 0) != (aMouseX > 0) )
				{
					if ( AMouseX > 0 )
						SmoothMouseX = 1;
					else
						SmoothMouseX = -1;
				}
				BorrowedMouseX = SmoothMouseX - aMouseX;
			}
			AbsSmoothX = SmoothMouseX;
		}
		if ( bMaxMouseSmoothing && (aMouseY == 0) && (MouseTime < MouseSmoothThreshold) )
		{
			SmoothMouseY = 0.5 * (MouseSmoothThreshold - MouseTime) * AbsSmoothY/MouseSmoothThreshold;
			BorrowedMouseY += SmoothMouseY;
		}
		else
		{
			if ( (SmoothMouseY == 0) || (aMouseY == 0)
					|| ((SmoothMouseY > 0) != (aMouseY > 0)) )
			{
				SmoothMouseY = aMouseY;
				BorrowedMouseY = 0;
			}
			else
			{
				SmoothMouseY = 0.5 * (SmoothMouseY + aMouseY - BorrowedMouseY);
				if ( (SmoothMouseY > 0) != (aMouseY > 0) )
				{
					if ( AMouseY > 0 )
						SmoothMouseY = 1;
					else
						SmoothMouseY = -1;
				}
				BorrowedMouseY = SmoothMouseY - aMouseY;
			}
			AbsSmoothY = SmoothMouseY;
		}
	}
	if ( (aMouseX != 0) || (aMouseY != 0) )
		MouseZeroTime = Level.TimeSeconds;

	// adjust keyboard and joystick movements
	aLookUp *= FOVScale;
	aTurn   *= FOVScale;

	// Remap raw x-axis movement.
	if( bStrafe!=0 )
	{
		// Strafe.
		aStrafe += aBaseX + SmoothMouseX;
		aBaseX   = 0;
	}
	else
	{
		// Forward.
		aTurn  += aBaseX * FOVScale + SmoothMouseX;
		aBaseX  = 0;
	}

	// Remap mouse y-axis movement.
	if( (bStrafe == 0) && (bAlwaysMouseLook || (bLook!=0)) )
	{
		// Look up/down.
		if ( bInvertMouse )
			aLookUp -= SmoothMouseY;
		else
			aLookUp += SmoothMouseY;
	}
	else
	{
		// Move forward/backward.
		aForward += SmoothMouseY;
	}
	SmoothMouseX = AbsSmoothX;
	SmoothMouseY = AbsSmoothY;

	if ( bSnapLevel != 0 && !bAlwaysMouseLook && !zzCVDeny && (Level.TimeSeconds - zzCVTO) > zzCVDelay )
	{
		zzCVTO = Level.TimeSeconds;
		bCenterView = true;
		bKeyboardLook = false;
	}
	else if (aLookUp != 0)
	{
		bCenterView = false;
		bKeyboardLook = true;
	}

	// Remap other y-axis movement.
	if ( bFreeLook != 0 )
	{
		bKeyboardLook = true;
		aLookUp += 0.5 * aBaseY * FOVScale;
	}
	else
		aForward += aBaseY;

	aBaseY = 0;

	// Handle walking.
	HandleWalking();
}

function ServerMove
(
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
)
{
	if (zzSMCnt == 0)
		Log("SM Attempt to cheat by"@PlayerReplicationInfo.PlayerName, 'UTCheat');

	zzSMCnt++;
	if (zzSMCnt > 30)
	{
		xxServerCheater("SM");
	}
}

// ClientAdjustPosition - pass newloc and newvel in components so they don't get rounded

function ClientAdjustPosition
(
	float TimeStamp,
	name newState,
	EPhysics newPhysics,
	float NewLocX,
	float NewLocY,
	float NewLocZ,
	float NewVelX,
	float NewVelY,
	float NewVelZ,
	Actor NewBase
)
{
}

// OLD STYLE (3xfloat) CAP

function xxCAP(float TimeStamp, name newState, int MiscData,
			float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase)
{
	local vector Loc,Vel;
	Loc.X = NewLocX; Loc.Y = NewLocY; Loc.Z = NewLocZ;
	Vel.X = NewVelX; Vel.Y = NewVelY; Vel.Z = NewVelZ;
	xxPureCAP(TimeStamp, newState, MiscData,Loc,Vel,NewBase);
}

function xxCAPLevelBase(float TimeStamp, name newState, int MiscData,
			float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ)
{
	local vector Loc,Vel;
	Loc.X = NewLocX; Loc.Y = NewLocY; Loc.Z = NewLocZ;
	Vel.X = NewVelX; Vel.Y = NewVelY; Vel.Z = NewVelZ;
	xxPureCAP(TimeStamp,newState,MiscData,Loc,Vel,Level);
}

function xxCAPWalking(float TimeStamp, int MiscData,
			float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase)
{
	local vector Loc,Vel;
	Loc.X = NewLocX; Loc.Y = NewLocY; Loc.Z = NewLocZ;
	Vel.X = NewVelX; Vel.Y = NewVelY; Vel.Z = NewVelZ;
	xxPureCAP(TimeStamp,'PlayerWalking',MiscData,Loc,Vel,NewBase);
}

function xxCAPWalkingWalkingLevelBase(float TimeStamp, int MiscData,
			float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ)
{
	local vector Loc,Vel;
	Loc.X = NewLocX; Loc.Y = NewLocY; Loc.Z = NewLocZ;
	Vel.X = NewVelX; Vel.Y = NewVelY; Vel.Z = NewVelZ;
	MiscData = MiscData | (/*PHYS_Walking*/(1) << 2);
	xxPureCAP(TimeStamp,'PlayerWalking',MiscData,Loc,Vel,Level);
}

function xxCAPWalkingWalking(float TimeStamp, int MiscData,
			float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase)
{
	local vector Loc,Vel;
	Loc.X = NewLocX; Loc.Y = NewLocY; Loc.Z = NewLocZ;
	Vel.X = NewVelX; Vel.Y = NewVelY; Vel.Z = NewVelZ;
	MiscData = MiscData | (/*PHYS_Walking*/(1) << 2);
	xxPureCAP(TimeStamp,'PlayerWalking',MiscData,Loc,Vel,NewBase);
}

simulated function xxPureCAP(float TimeStamp, name newState, int MiscData, vector NewLoc, vector NewVel, Actor NewBase)
{
	local Decoration Carried;
	local vector OldLoc;

	if ( CurrentTimeStamp > TimeStamp )
		return;
	CurrentTimeStamp = TimeStamp;

	// Higor: keep track of Position prior to adjustment
	// and stop current smoothed adjustment (if in progress).
	IGPlus_PreAdjustLocation = Location;
	if ( IGPlus_AdjustLocationAlpha > 0 )
	{
		IGPlus_AdjustLocationAlpha = 0;
		IGPlus_AdjustLocationOffset = vect(0,0,0);
	}
	IGPlus_AdjustLocationOverride = (TlocCounter != (MiscData&3));

	SetPhysics(GetPhysics((MiscData >> 2) & 0xF));
	TlocCounter = MiscData & 3;

	SetBase(NewBase);
	if ( Mover(NewBase) != None )
		NewLoc += NewBase.Location;

	if ( !IsInState(newState) )
		GotoState(newState);

	Carried = CarriedDecoration;
	OldLoc = Location;

	bCanTeleport = false;
	SetLocation(NewLoc);
	bCanTeleport = true;
	Velocity = NewVel;

	if ( Carried != None )
	{
		CarriedDecoration = Carried;
		CarriedDecoration.SetLocation(NewLoc + CarriedDecoration.Location - OldLoc);
		CarriedDecoration.SetPhysics(PHYS_None);
		CarriedDecoration.SetBase(self);
	}

	zzbFakeUpdate = false;
	bUpdatePosition = true;
}

function xxFakeCAP(float TimeStamp)
{
	if ( CurrentTimeStamp > TimeStamp )
		return;
	CurrentTimeStamp = TimeStamp;

	bUpdatePosition = true;
}

function IGPlus_ClientReplayMove(bbSavedMove M) {
	local int MergeCount, MoveIndex;
	local float dt;
	local bool bDoJump;
	local EDodgeDir DoDodge;
	local bool bDoRun;
	local bool bDoDuck;

	SetRotation(M.Rotation);
	ViewRotation = M.IGPlus_SavedViewRotation;

	if (M.Momentum != vect(0,0,0)) {
		if (Physics == PHYS_Walking)
			SetPhysics(PHYS_Falling);
		Velocity += M.Momentum;
	}

	MergeCount = M.IGPlus_MergeCount + 1;
	dt = M.Delta / MergeCount;
	for (MoveIndex = 0; MoveIndex < MergeCount; MoveIndex++) {
		if (MoveIndex == M.JumpIndex)
			bDoJump = M.bPressedJump;
		else
			bDoJump = false;

		if (MoveIndex == M.DodgeIndex)
			DoDodge = M.DodgeMove;
		else
			DoDodge = DODGE_None;

		bDoRun = (MoveIndex < M.RunChangeIndex) ^^ M.bRun;
		bDoDuck = (MoveIndex < M.DuckChangeIndex) ^^ M.bDuck;

		IGPlus_MoveAutonomous(dt, bDoRun, bDoDuck, bDoJump, DoDodge, M.Acceleration, rot(0,0,0));
	}

	M.IGPlus_SavedLocation = Location;
	M.IGPlus_SavedVelocity = Velocity;
}

function IGPlus_CleanSavedMoves(float TimeStamp) {
	local bbSavedMove CurrentMove;
	CurrentMove = bbSavedMove(SavedMoves);

	while (CurrentMove != none && CurrentMove.TimeStamp <= TimeStamp) {
		SavedMoves = CurrentMove.NextMove;
		CurrentMove.NextMove = FreeMoves;
		FreeMoves = CurrentMove;
		CurrentMove.Clear2();
		CurrentMove = bbSavedMove(SavedMoves);
	}
}

function ClientUpdatePosition()
{
	local bbSavedMove CurrentMove;
	local int realbRun, realbDuck;
	local bool bRealJump;
	local rotator RealViewRotation, RealRotation;

	local float AdjustDistance;
	local vector PostAdjustLocation;

	bUpdatePosition = false;
	realbRun = bRun;
	realbDuck = bDuck;
	bRealJump = bPressedJump;
	RealRotation = Rotation;
	RealViewRotation = ViewRotation;
	bUpdating = true;

	IGPlus_CleanSavedMoves(CurrentTimeStamp);

	if (zzbFakeUpdate == false) {
		CurrentMove = bbSavedMove(SavedMoves);
		while (CurrentMove != none) {
			IGPlus_ClientReplayMove(CurrentMove);
			CurrentMove = bbSavedMove(CurrentMove.NextMove);
		}

		// stijn: The original code was not replaying the pending move
		// here. This was a huge oversight and caused non-stop resynchronizations
		// because the playerpawn position would be off constantly until the player
		// stopped moving!
		if (PendingMove != none) {
			IGPlus_ClientReplayMove(bbSavedMove(PendingMove));
		}

		// Higor: evaluate location adjustment and see if we should either
		// - Discard it
		// - Negate and process over a certain amount of time.
		// - Keep adjustment as is (instant relocation)
		// Deaod: On second thought, lets never discard adjustments.
		IGPlus_AdjustLocationOffset = (Location - IGPlus_PreAdjustLocation);
		AdjustDistance = VSize(IGPlus_AdjustLocationOffset);
		IGPlus_AdjustLocationAlpha = 0;
		if ((AdjustDistance < 50) &&
			FastTrace(Location,IGPlus_PreAdjustLocation) &&
			IGPlus_AdjustLocationOverride == false
		) {
			// Undo adjustment and re-enact smoothly
			PostAdjustLocation = Location;
			MoveSmooth(-IGPlus_AdjustLocationOffset);
			IGPlus_AdjustLocationAlpha = FMax(0.1, PlayerReplicationInfo.Ping*0.001);
			IGPlus_AdjustLocationOffset = (PostAdjustLocation - Location) / IGPlus_AdjustLocationAlpha;
		}
	}

	bUpdating = false;
	bDuck = realbDuck;
	bRun = realbRun;
	bPressedJump = bRealJump;
	SetRotation( RealRotation);
	ViewRotation = RealViewRotation;
	zzbFakeUpdate = true;

	UpdatePing();
}

function UpdatePing() {
	local int CurrentSecond;

	CurrentSecond = int(Level.TimeSeconds);

	if (CurrentSecond != PingCurrentAveragingSecond) {
		PingCurrentAveragingSecond = CurrentSecond;
		PingAverage = int(1000 * PingRunningAverage / Level.TimeDilation);
		PingRunningAverage = Level.TimeSeconds - CurrentTimeStamp;
		PingRunningAverageCount = 1;
	} else {
		PingRunningAverage = (PingRunningAverage * PingRunningAverageCount) + (Level.TimeSeconds - CurrentTimeStamp);
		PingRunningAverageCount++;
		PingRunningAverage = PingRunningAverage / PingRunningAverageCount;
	}
}

function xxServerReceiveStuff( vector TeleLoc, vector TeleVel )
{
	local Inventory inv;
	local Translocator TLoc;

	if (Level.NetMode == NM_Client || IsInState('Dying'))
		return;

	if ((TeleLoc dot TeleLoc) > 0 && TTarget != None && VSize(TeleLoc - TTarget.Location) < class'UTPure'.default.MaxPosError)
	{
		TLoc = Translocator(Weapon);
		if (TLoc == None)
		{
			for (inv=Inventory; inv!=None; inv=inv.Inventory)
			{
				TLoc = Translocator(inv);
				if (TLoc != None)
					break;
			}
		}
		TTarget.MoveSmooth(TeleLoc - TTarget.Location);
		TTarget.Velocity = TeleVel;
	}

}

function TakeFallingDamage()
{
	if (Velocity.Z < -1.4 * JumpZ)
	{
		if (JumpZ != 0)
			MakeNoise(-0.5 * Velocity.Z/(FMax(JumpZ, 150.0)));
		if (Velocity.Z <= -750 - JumpZ)
		{
			if (zzLastFallVelZ <= -750 - JumpZ)
			{
				if ( (zzLastFallVelZ < -1650 - JumpZ) && (ReducedDamageType != 'All') )
					TakeDamage(1000, None, Location, vect(0,0,0), 'Fell');
				else if ( Role == ROLE_Authority )
					TakeDamage(-0.15 * (zzLastFallVelZ + 700 + JumpZ), None, Location, vect(0,0,0), 'Fell');
				ShakeView(0.175 - 0.00007 * zzLastFallVelZ, -0.85 * zzLastFallVelZ, -0.002 * zzLastFallVelZ);
			}
		}
	}
	else if ( Velocity.Z > 0.5 * Default.JumpZ )
		MakeNoise(0.35);
	zzLastFallVelZ = 0;
}

function xxSetPendingWeapon(Weapon W)
{
	PendingWeapon = W;
}

/**
 * Corrects velocity after going through Teleporters
 */
function CorrectTeleporterVelocity() {
	local rotator Delta;
	local Teleporter T;

	if (LastTouchedTeleporter != none &&
		(
			LastTouchedTeleporter.Class == class'Teleporter' ||
			LastTouchedTeleporter.Class == class'VisibleTeleporter'
		)
	) {
		// only deal with base game teleporters
		// other classes might do weird custom stuff

		// find destination
		foreach RadiusActors(class'Teleporter', T, 32.0)
			break;

		T.Disable('Touch');
		MoveSmooth(vect(0,0,1)*OffsetZBeforeTeleporter);
		T.Enable('Touch');

		if (T.bChangesVelocity) {
			Velocity = T.TargetVelocity;
		} else {
			Delta = rotator(VelocityBeforeTeleporter) - RotationBeforeTeleporter;
			// Teleporter doesnt change velocity, so we can do it ourselves
			Velocity = vector(Rotation+Delta) * VSize(VelocityBeforeTeleporter*vect(1,1,0)) * vect(1,1,0);
			Velocity.Z = VelocityBeforeTeleporter.Z;
		}
	}
}

function IGPlus_MoveAutonomous(
	float DeltaTime,
	bool NewbRun,
	bool NewbDuck,
	bool NewbPressedJump,
	eDodgeDir DodgeMove,
	vector newAccel,
	rotator DeltaRot
) {
	LastTouchedTeleporter = none;
	MoveAutonomous(DeltaTime, NewbRun, NewbDuck, NewbPressedJump, DodgeMove, newAccel, DeltaRot);
	CorrectTeleporterVelocity();
}

/**
 * Splits a large DeltaTime into chunks reasonable enough for MoveAutonomous,
 * so players dont warp through walls
 */
function SimMoveAutonomous(float DeltaTime) {
	local int SimSteps;
	local float SimTime;

	SimSteps = Max(1, int(DeltaTime / AverageServerDeltaTime)); // handle (DeltaTime < AverageServerDeltaTime)
	SimTime = DeltaTime / SimSteps;
	while(SimSteps > 0) {
		IGPlus_MoveAutonomous(SimTime, bRun>0, bDuck>0, false, DODGE_None, Acceleration, rot(0,0,0));
		SimSteps--;
	}
}

function ExtrapolationSaveData() {
	Saved.Location = Location;
	Saved.Velocity = Velocity;
	Saved.Acceleration = Acceleration;
	Saved.State = GetStateName();
	Saved.Physics = Physics;
	Saved.DodgeDir = DodgeDir;
}

function ExtrapolationRestoreData() {
	local vector OldLoc;
	local Decoration Carried;

	if (FastTrace(Saved.Location)) {
		xxNewMoveSmooth(Saved.Location);
	} else {
		Carried = CarriedDecoration;
		OldLoc = Location;

		bCanTeleport = false;
		xxNewSetLocation(Saved.Location, Saved.Velocity);
		bCanTeleport = true;

		if (Carried != None) {
			CarriedDecoration = Carried;
			CarriedDecoration.SetLocation(Saved.Location + CarriedDecoration.Location - OldLoc);
			CarriedDecoration.SetPhysics(PHYS_None);
			CarriedDecoration.SetBase(self);
		}
	}
	Velocity = Saved.Velocity;
	Acceleration = Saved.Acceleration;
	if (Saved.State == GetStateName()) {
		SetPhysics(Saved.Physics);
		DodgeDir = Saved.DodgeDir;
	}
}

function ExtrapolationDiscardData() {
	bExtrapolatedLastUpdate = false;
}

function WarpCompensation(float DeltaTime) {
	if (Level.Pauser == "" && !bWasPaused) {
		if (class'UTPure'.default.bEnableServerExtrapolation &&
			bExtrapolatedLastUpdate == false && ExtrapolationDelta > AverageServerDeltaTime
		) {
			bExtrapolatedLastUpdate = true;
			ExtrapolationSaveData();
			SimMoveAutonomous(ExtrapolationDelta);
			ClientDebugMessage("Extrapolation"@ExtrapolationDelta);
		}
		ExtrapolationDelta *= Exp(-2.0 * DeltaTime);
	} else {
		bWasPaused = true;
	}
}

function ClearLastServerMoveParams() {
	bHaveReceivedServerMove = false;
	LastServerMoveParams.ClientDeltaTime = 0.0;
	LastServerMoveParams.ServerDeltaTime = 0.0;
	LastServerMoveParams.Location = vect(0.0, 0.0, 0.0);
	LastServerMoveParams.Velocity = vect(0.0, 0.0, 0.0);
	LastServerMoveParams.Physics = PHYS_None;
	LastServerMoveParams.Base = none;
	LastServerMoveParams.TlocCounter = 0;
}

function IGPlus_ProcessRemoteMovement() {
	IGPlus_ApplyAllServerMoves();

	if (class'UTPure'.default.bEnableLoosePositionCheck)
		IGPlus_LooseCheckClientError();
	else
		IGPlus_CheckClientError();

	if (((ServerTimeStamp - LastCAPTime) / Level.TimeDilation) > FakeCAPInterval && ServerTimeStamp >= NextRealCAPTime) {
		xxFakeCAP(CurrentTimeStamp);
		LastCAPTime = ServerTimeStamp;
	}
}

function IGPlus_ApplyAllServerMoves() {
	local bbServerMove SM;

	if (FirstServerMove == none) return;

	for (SM = FirstServerMove; SM.Next != none; SM = SM.Next)
		IGPlus_ApplyServerMove(SM);

	IGPlus_ApplyServerMove(SM);

	IGPlus_DestroyServerMoveChain(FirstServerMove, SM);
	FirstServerMove = none;
}

function IGPlus_ApplyMomentum(vector Momentum) {
	if ( Momentum == vect(0,0,0) )
		return;

	if (Physics == PHYS_Walking) {
		Momentum.Z = FMax(Momentum.Z, 0.4 * VSize(Momentum));
		SetPhysics(PHYS_Falling);
	}

	if ( (Velocity.Z > 380) && (Momentum.Z > 0) )
		Momentum.Z *= 0.5;

	Velocity += Momentum;
}

function IGPlus_BeforeTranslocate() {
	TlocPrevLocation = Location;
}

function IGPlus_AfterTranslocate() {
	IGPlus_DidTranslocate = (VSize(Location - TlocPrevLocation) > 1);
	if (IGPlus_DidTranslocate) {
		ExtrapolationDiscardData();
		IGPlus_NotifiedTranslocate = false;
	}
}

function IGPlus_ApplyServerMove(bbServerMove SM) {
	local int i;
	local float ServerDeltaTime;
	local float DeltaTime;
	local float SimStep;
	local rotator DeltaRot;
	local rotator Rot;
	local int maxPitch;
	local int ViewPitch;
	local int ViewYaw;
	local vector ClientLocAbs;
	local int ClientTlocCounter;
	local bool NewbPressedJump;
	local bool NewbRun;
	local bool NewbDuck;
	local bool NewbJumpStatus;
	local bool bFired;
	local bool bAltFired;
	local bool bForceFire;
	local bool bForceAltFire;
	local EDodgeDir DodgeMove;
	local EPhysics ClientPhysics;
	local byte ClientRoll;
	local int MergeCount;
	local int MoveIndex;

	local int AddVelocityId;

	local int JumpIndex;
	local float JumpPos;
	local bool bDoJump;

	local int DodgeIndex;
	local float DodgePos;
	local EDodgeDir DoDodge;

	local int RunChangeIndex;
	local float RunChangePos;
	local bool bRunActual;

	local int DuckChangeIndex;
	local float DuckChangePos;
	local bool bDuckActual;

	debugServerMoveCallsReceived += 1;

	if (bDeleteMe) {
		ClientDebugMessage("Reject Irrelevant Move");
		return;
	}

	if (Role < ROLE_Authority) {
		zzbLogoDone = True;
		zzTrackFOV = 0;
		zzbDemoPlayback = True;
		return;
	}

	zzKickReady = Max(zzKickReady - 1,0);
	bJustRespawned = false;

	if (SM.TimeStamp > Level.TimeSeconds)
		SM.TimeStamp = Level.TimeSeconds;

	if (CurrentTimeStamp >= SM.TimeStamp) {
		ClientDebugMessage("Reject Outdated Move:"@CurrentTimeStamp@SM.TimeStamp);
		return;
	}

	ClientTlocCounter =          (SM.MiscData & 0x60000000) >> 29;
	bFired         =             (SM.MiscData & 0x10000000) != 0;
	bAltFired      =             (SM.MiscData & 0x08000000) != 0;
	bForceFire     =             (SM.MiscData & 0x04000000) != 0;
	bForceAltFire  =             (SM.MiscData & 0x02000000) != 0;
	MergeCount     =             (SM.MiscData & 0x00F80000) >> 19;
	NewbRun        =             (SM.MiscData & 0x00040000) != 0;
	NewbDuck       =             (SM.MiscData & 0x00020000) != 0;
	NewbJumpStatus =             (SM.MiscData & 0x00010000) != 0;
	ClientPhysics  =  GetPhysics((SM.MiscData & 0x0000F000) >> 12);
	DodgeMove      = GetDodgeDir((SM.MiscData & 0x00000F00) >> 8);
	ClientRoll     =             (SM.MiscData & 0x000000FF);

	AddVelocityId   = (SM.MiscData2 & 0x00F00000) >> 20;
	DuckChangeIndex = (SM.MiscData2 & 0x000F8000) >> 15;
	RunChangeIndex  = (SM.MiscData2 & 0x00007C00) >> 10;
	DodgeIndex      = (SM.MiscData2 & 0x000003E0) >> 5;
	JumpIndex       = (SM.MiscData2 & 0x0000001F);

	if (DodgeMove > DODGE_None && DodgeMove < DODGE_Active)
		ClientDebugMessage("Received Dodge"@DodgeMove@SM.TimeStamp);

	if (SM.ClientBase == none)
		ClientLocAbs = SM.ClientLocation;
	else
		ClientLocAbs = SM.ClientLocation + SM.ClientBase.Location;

	if ((SM.OldMoveData1 & 0x3FF) != 0)
		if (IGPlus_OldServerMove(SM.TimeStamp, SM.OldMoveData1, SM.OldMoveData2)) {
			xxFakeCAP(CurrentTimeStamp);
			LastCAPTime = Level.TimeSeconds;
		}

	if (ServerTimeStamp == 0.0) {
		ServerDeltaTime = SM.MoveDeltaTime;
		DeltaTime = SM.MoveDeltaTime;
	} else {
		ServerDeltaTime = Level.TimeSeconds - ServerTimeStamp;
		DeltaTime = SM.TimeStamp - CurrentTimeStamp;

		if (Level.Pauser == "" && bWasPaused) {
			ServerDeltaTime = FMin(ServerDeltaTime, SM.MoveDeltaTime);
			DeltaTime = FMin(DeltaTime, SM.MoveDeltaTime);
		}
	}

	ExtrapolationDelta += (ServerDeltaTime - DeltaTime);

	if ( ServerTimeStamp > 0 ) {
		// allow 1% error
		TimeMargin += DeltaTime - 1.01 * ServerDeltaTime;
		if ( TimeMargin > MaxTimeMargin ) {
			// player is too far ahead
			TimeMargin -= DeltaTime;
			if ( TimeMargin < 0.5 )
				MaxTimeMargin = Default.MaxTimeMargin;
			else
				MaxTimeMargin = 0.5;
			DeltaTime = 0;
			Log("["$Level.TimeSeconds$"]"@PlayerReplicationInfo.PlayerName@"MaxTimeMargin exceeded ("$TimeMargin$")", 'IGPlus');
		}
	}

	bHaveReceivedServerMove = true;
	LastServerMoveParams.ClientDeltaTime += DeltaTime;
	LastServerMoveParams.ServerDeltaTime += ServerDeltaTime;
	LastServerMoveParams.Location = SM.ClientLocation;
	LastServerMoveParams.Velocity = SM.ClientVelocity;
	LastServerMoveParams.Base = SM.ClientBase;
	LastServerMoveParams.Physics = ClientPhysics;
	LastServerMoveParams.TlocCounter = ClientTlocCounter;

	// View components
	CompressedViewRotation = SM.View;
	ViewPitch = (SM.View >>> 16);
	ViewYaw = (SM.View & 0xFFFF);

	NewbPressedJump = (bJumpStatus != NewbJumpStatus);
	bJumpStatus = NewbJumpStatus;

	if ((Level.Pauser == "") && (DeltaTime > 0)) {
		UndoExtrapolation();

		if (bHidden && (IsInState('PlayerWalking') || IsInState('PlayerSwimming'))) {
			bClientDead = false;
			bHidden = false;
			SetCollision(true, true, true);
		}
	}

	if (bUseFastWeaponSwitch && PendingWeapon != None)
		ChangedWeapon();

	// handle firing and alt-firing
	if (bFired) {
		if (bForceFire && (Weapon != None))
			Weapon.ForceFire();
		else if (bFire == 0)
			Fire(0);
		bFire = 1;
	} else {
		bFire = 0;
	}

	if (bAltFired) {
		if (bForceAltFire && (Weapon != None))
			Weapon.ForceAltFire();
		else if (bAltFire == 0)
			AltFire(0);
		bAltFire = 1;
	} else {
		bAltFire = 0;
	}

	if (IGPlus_DidTranslocate) {
		TlocCounter = (TlocCounter + 1) & 3;
		IGPlus_DidTranslocate = false;
	}

	CurrentTimeStamp = SM.TimeStamp;
	ServerTimeStamp = Level.TimeSeconds;
	Rot.Roll = ClientRoll << 8;
	Rot.Yaw = ViewYaw;
	if ((Physics == PHYS_Swimming) || (Physics == PHYS_Flying))
		maxPitch = 2 * RotationRate.Pitch;
	else
		maxPitch = RotationRate.Pitch;

	Rot.Pitch = Clamp((ViewPitch << 16) >> 16, -maxPitch, maxPitch) & 0xFFFF;

	DeltaRot = (Rotation - Rot);
	ViewRotation.Pitch = ViewPitch;
	ViewRotation.Yaw = ViewYaw;
	ViewRotation.Roll = 0;
	SetRotation(Rot);

	if (SM.ClientVelocity.Z < 0)
		zzLastFallVelZ = SM.ClientVelocity.Z;

	// Apply momentum as it was applied on client
	if (((AddVelocityId - LastAddVelocityAppliedIndex) & 0xF) > ((LastAddVelocityIndex - LastAddVelocityAppliedIndex) & 0xF))
		AddVelocityId = LastAddVelocityIndex;

	for (i = LastAddVelocityAppliedIndex; i != AddVelocityId; i = (i+1) & 0xF) {
		IGPlus_ApplyMomentum(AddVelocityCalls[i].Momentum);
		AddVelocityCalls[i].Momentum = vect(0,0,0);
	}

	LastAddVelocityAppliedIndex = AddVelocityId;

	// Predict new position
	if ((Level.Pauser == "") && (DeltaTime > 0)) {
		MergeCount++;

		SimStep = DeltaTime / float(MergeCount);

		if (bIs469Server == false && SimStep < 0.005) {
			JumpPos = float(JumpIndex) / float(MergeCount);
			DodgePos = float(DodgeIndex) / float(MergeCount);
			RunChangePos = float(RunChangeIndex) / float(MergeCount);
			DuckChangePos = float(DuckChangeIndex) / float(MergeCount);

			MergeCount = int(DeltaTime * 100) + 1;
			SimStep = DeltaTime / float(MergeCount);

			JumpIndex = int(JumpPos * MergeCount);
			DodgeIndex = int(DodgePos * MergeCount);
			RunChangeIndex = int(RunChangePos * MergeCount);
			DuckChangeIndex = int(DuckChangePos * MergeCount);
		}

		for (MoveIndex = 0; MoveIndex < MergeCount; MoveIndex++) {
			if (MoveIndex == JumpIndex)
				bDoJump = NewbPressedJump;
			else
				bDoJump = false;

			if (MoveIndex == DodgeIndex)
				DoDodge = DodgeMove;
			else
				DoDodge = DODGE_None;

			bRunActual = (MoveIndex < RunChangeIndex) ^^ NewbRun;
			bDuckActual = (MoveIndex < DuckChangeIndex) ^^ NewbDuck;

			IGPlus_MoveAutonomous(SimStep, bRunActual, bDuckActual, bDoJump, DoDodge, SM.ClientAcceleration, DeltaRot / MergeCount);
		}

		bWasPaused = false;
	}

	if (IGPlus_WantCAP || class'UTPure'.default.bEnableLoosePositionCheck == false)
		return;

	IGPlus_WantCAP = IGPlus_IsCAPNecessary();
}

function IGPlus_CheckClientError() {
	local vector ClientLoc;
	local vector ClientVel;
	local EPhysics ClientPhysics;
	local vector ClientLocAbs;
	local int ClientTlocCounter;
	local vector LocDelta;
	local float ClientLocError;
	local float MaxLocError;
	local bool bForceUpdate;

	if (bHaveReceivedServerMove == false)
		return;

	ClientLoc = LastServerMoveParams.Location;
	ClientVel = LastServerMoveParams.Velocity;
	ClientPhysics = LastServerMoveParams.Physics;
	ClientLocAbs = ClientLoc;
	if (LastServerMoveParams.Base != none)
		ClientLocAbs += LastServerMoveParams.Base.Location;
	ClientTlocCounter = LastServerMoveParams.TlocCounter;

	LocDelta = Location - ClientLocAbs;
	ClientLocError = LocDelta Dot LocDelta;
	debugClientLocError = ClientLocError;

	// Apply momentum that the client never got around to
	while(LastAddVelocityAppliedIndex != LastAddVelocityIndex && AddVelocityCalls[LastAddVelocityAppliedIndex].TimeStamp < ServerTimeStamp) {
		IGPlus_ApplyMomentum(AddVelocityCalls[LastAddVelocityAppliedIndex].Momentum);
		AddVelocityCalls[LastAddVelocityAppliedIndex].Momentum = vect(0,0,0);
		zzbForceUpdate = true;
		LastAddVelocityAppliedIndex = (LastAddVelocityAppliedIndex+1) & 0xF;
	}

	// Calculate how far off we allow the client to be from the predicted position
	MaxLocError = 3.0;

	clientLastUpdateTime = ServerTimeStamp;
	ClearLastServerMoveParams();

	bForceUpdate = zzbForceUpdate || (zzForceUpdateUntil >= ServerTimeStamp) ||
		(ClientLocError > MaxLocError && ServerTimeStamp >= NextRealCAPTime) ||
		(ClientTlocCounter != TlocCounter && IGPlus_NotifiedTranslocate == false);

	debugClientForceUpdate = bForceUpdate;

	if (bForceUpdate)
		IGPlus_SendCAP();
}

function IGPlus_LooseCheckClientError() {
	if (IGPlus_WantCAP) {
		ClearLastServerMoveParams();
		IGPlus_SendCAP();
	}
}

function bool IGPlus_IsCAPNecessary() {
	local vector ClientLoc;
	local vector ClientVel;
	local EPhysics ClientPhysics;
	local vector ClientLocAbs;
	local int ClientTlocCounter;
	local vector LocDelta;
	local float ClientLocError;
	local float MaxLocError;
	local bool bServerOnMover;
	local bool bClientOnMover;
	local bool bForceUpdate;
	local bool bCanTraceNewLoc;
	local bool bMovedToNewLoc;
	local Decoration Carried;
	local vector OldLoc;

	if (bHaveReceivedServerMove == false)
		return false;

	ClientLoc = LastServerMoveParams.Location;
	ClientVel = LastServerMoveParams.Velocity;
	ClientPhysics = LastServerMoveParams.Physics;
	ClientLocAbs = ClientLoc;
	if (LastServerMoveParams.Base != none)
		ClientLocAbs += LastServerMoveParams.Base.Location;
	ClientTlocCounter = LastServerMoveParams.TlocCounter;

	LocDelta = Location - ClientLocAbs;
	ClientLocError = LocDelta Dot LocDelta;
	debugClientLocError = ClientLocError;

	// Apply momentum that the client never got around to
	while(LastAddVelocityAppliedIndex != LastAddVelocityIndex && AddVelocityCalls[LastAddVelocityAppliedIndex].TimeStamp < ServerTimeStamp) {
		IGPlus_ApplyMomentum(AddVelocityCalls[LastAddVelocityAppliedIndex].Momentum);
		AddVelocityCalls[LastAddVelocityAppliedIndex].Momentum = vect(0,0,0);
		zzbForceUpdate = true;
		LastAddVelocityAppliedIndex = (LastAddVelocityAppliedIndex+1) & 0xF;
	}

	// Calculate how far off we allow the client to be from the predicted position
	MaxLocError = 3.0;
	if (LastServerMoveParams.ClientDeltaTime > 0) {
		MaxLocError = CalculateLocError(
			LastServerMoveParams.ClientDeltaTime,
			LastServerMoveParams.Physics,
			ClientVel
		);
		MaxLocError = MaxLocError * MaxLocError;
	}

	bServerOnMover = Mover(Base) != None;
	bClientOnMover = Mover(LastServerMoveParams.Base) != none;
	if ((bServerOnMover && bClientOnMover) || OtherPawnAtLocation(ClientLocAbs)) {
		// Ping is in milliseconds, convert to seconds
		// 10% slack to account for jitter
		zzIgnoreUpdateUntil = ServerTimeStamp + (PlayerReplicationInfo.Ping * 0.0011 * Level.TimeDilation);
	}
	if (zzIgnoreUpdateUntil <= ServerTimeStamp &&
		ServerTimeStamp - zzIgnoreUpdateUntil <= LastServerMoveParams.ServerDeltaTime &&
		Physics == PHYS_Falling
	) {
		// extending ignore time until landing (probably from a lift jump)
		zzIgnoreUpdateUntil = ServerTimeStamp;
	}

	bForceUpdate = zzbForceUpdate || ClientTlocCounter != TlocCounter || (zzForceUpdateUntil >= ServerTimeStamp) ||
		(ClientLocError > MaxLocError && zzIgnoreUpdateUntil < ServerTimeStamp);

	clientLastUpdateTime = ServerTimeStamp;
	debugClientForceUpdate = bForceUpdate;

	ClearLastServerMoveParams();

	if (bForceUpdate) {
		ClientDebugMessage("Send CAP:"@CurrentTimeStamp@Physics@ClientPhysics@ClientLocError@MaxLocError);
		return true;
	}

	if (zzLastClientErr == 0 || ClientLocError < zzLastClientErr)
		zzLastClientErr = ClientLocError;

	bCanTraceNewLoc = FastTrace(ClientLocAbs);
	if (bCanTraceNewLoc) {
		clientForcedPosition = ClientLocAbs;
		zzLastClientErr = 0;
		bMovedToNewLoc = xxNewMoveSmooth(ClientLocAbs);
		if (bMovedToNewLoc && ClientPhysics == Physics)
			Velocity = ClientVel;
	}
	if (bCanTraceNewLoc == false) {
		Carried = CarriedDecoration;
		OldLoc = Location;

		bCanTeleport = false;
		if (SetLocation(ClientLocAbs) && ClientPhysics == Physics)
			Velocity = ClientVel;
		bCanTeleport = true;

		if (Carried != None) {
			CarriedDecoration = Carried;
			CarriedDecoration.SetLocation(ClientLocAbs + CarriedDecoration.Location - OldLoc);
			CarriedDecoration.SetPhysics(PHYS_None);
			CarriedDecoration.SetBase(self);
		}

		zzLastClientErr = 0;
	}

	return false;
}

function IGPlus_SendCAP() {
	local vector ClientLoc;
	local int CAPMiscData;

	debugNumOfForcedUpdates++;
	zzbForceUpdate = false;

	if ( Mover(Base) != None )
		ClientLoc = Location - Base.Location;
	else
		ClientLoc = Location;

	CAPMiscData = TlocCounter & 0x0003;

	if (GetStateName() == 'PlayerWalking') {
		if (Physics == PHYS_Walking) {
			if (Base == Level) {
				xxCAPWalkingWalkingLevelBase(CurrentTimeStamp, CAPMiscData, ClientLoc.X, ClientLoc.Y, ClientLoc.Z, Velocity.X, Velocity.Y, Velocity.Z);
			} else {
				xxCAPWalkingWalking(CurrentTimeStamp, CAPMiscData, ClientLoc.X, ClientLoc.Y, ClientLoc.Z, Velocity.X, Velocity.Y, Velocity.Z, Base);
			}
		} else {
			xxCAPWalking(CurrentTimeStamp, CAPMiscData | (Physics << 2), ClientLoc.X, ClientLoc.Y, ClientLoc.Z, Velocity.X, Velocity.Y, Velocity.Z, Base);
		}
	} else if (Base == Level)
		xxCAPLevelBase(CurrentTimeStamp, GetStateName(), CAPMiscData | (Physics << 2), ClientLoc.X, ClientLoc.Y, ClientLoc.Z, Velocity.X, Velocity.Y, Velocity.Z);
	else
		xxCAP(CurrentTimeStamp, GetStateName(), CAPMiscData | (Physics << 2), ClientLoc.X, ClientLoc.Y, ClientLoc.Z, Velocity.X, Velocity.Y, Velocity.Z, Base);

	LastCAPTime = ServerTimeStamp;
	NextRealCAPTime = ServerTimeStamp + PlayerReplicationInfo.Ping * 0.001 * Level.TimeDilation + AverageServerDeltaTime;
	zzLastClientErr = 0;
	IGPlus_WantCAP = false;
}

function UndoExtrapolation() {
	if (bExtrapolatedLastUpdate) {
		bExtrapolatedLastUpdate = false;

		ExtrapolationRestoreData();
	}
}

function EDodgeDir GetDodgeDir(int dir) {
	switch(dir) {
		case 0: return DODGE_None;
		case 1: return DODGE_Left;
		case 2: return DODGE_Right;
		case 3: return DODGE_Forward;
		case 4: return DODGE_Back;
		case 5: return DODGE_Active;
		case 6: return DODGE_Done;
	}
	return DODGE_None;
}

function EPhysics GetPhysics(int phys) {
	switch(phys) {
		case 0: return PHYS_None;
		case 1: return PHYS_Walking;
		case 2: return PHYS_Falling;
		case 3: return PHYS_Swimming;
		case 4: return PHYS_Flying;
		case 5: return PHYS_Rotating;
		case 6: return PHYS_Projectile;
		case 7: return PHYS_Rolling;
		case 8: return PHYS_Interpolating;
		case 9: return PHYS_MovingBrush;
		case 10: return PHYS_Spider;
		case 11: return PHYS_Trailer;
	}
	return PHYS_None;
}

function bool IGPlus_OldServerMove(float TimeStamp, int OldMoveData1, int OldMoveData2) {
	local vector Accel;
	local float OldTimeStamp;
	local bool OldRun;
	local bool OldDuck;
	local bool OldJump;
	local EDodgeDir DodgeMove;

	OldTimeStamp = TimeStamp - (float(OldMoveData1 & 0x3FF) * 0.001);
	if (CurrentTimeStamp + 0.001 >= OldTimeStamp) {
		return false;
	}

	OldJump   = (OldMoveData1 & 0x0400) != 0;
	OldRun    = (OldMoveData1 & 0x0800) != 0;
	OldDuck   = (OldMoveData1 & 0x1000) != 0;
	DodgeMove = GetDodgeDir((OldMoveData1 >> 13) & 7);
	Accel.X   = (OldMoveData1 >> 16) * 0.1;
	Accel.Y   = (OldMoveData2 << 16 >> 16) * 0.1;
	Accel.Z   = (OldMoveData2 >> 16) * 0.1;

	if (DodgeMove > DODGE_None && DodgeMove < DODGE_Active)
		ClientDebugMessage("Received Old Dodge"@DodgeMove@CurrentTimeStamp@OldTimeStamp);

	UndoExtrapolation();
	IGPlus_MoveAutonomous(OldTimeStamp - CurrentTimeStamp, OldRun, OldDuck, OldJump, DodgeMove, Accel, rot(0,0,0));
	CurrentTimeStamp = OldTimeStamp;

	return true;
}

function bbServerMove IGPlus_CreateServerMove() {
	local bbServerMove F;
	if (FreeServerMove != none) {
		F = FreeServerMove;
		FreeServerMove = F.Next;
		F.Next = none;
		return F;
	}

	return Spawn(class'bbServerMove', self);
}

function IGPlus_DestroyServerMove(bbServerMove SM) {
	if (SM == none) return;
	SM.Next = FreeServerMove;
	FreeServerMove = SM;
}

function IGPlus_DestroyServerMoveChain(bbServerMove Head, bbServerMove Tail) {
	if (Head == none) return;

	if (Tail == none) {
		Tail = Head;
		while(Tail.Next != none)
			Tail = Tail.Next;
	}

	Tail.Next = FreeServerMove;
	FreeServerMove = Head;
}

function IGPlus_InsertServerMove(bbServerMove SM) {
	local bbServerMove I;

	if (FirstServerMove == none) {
		FirstServerMove = SM;
		LatestServerMove = SM;
		return;
	}

	if (FirstServerMove.TimeStamp > SM.TimeStamp) {
		SM.Next = FirstServerMove;
		FirstServerMove = SM;
		return;
	}

	if (LatestServerMove.TimeStamp < SM.TimeStamp) {
		LatestServerMove.Next = SM;
		LatestServerMove = SM;
		return;
	}

	I = FirstServerMove;
	while(I.Next != none && I.Next.TimeStamp < SM.TimeStamp) {
		I = I.Next;
	}
	SM.Next = I.Next;
	I.Next = SM;
}

function xxServerMove(
	float TimeStamp,
	float MoveDeltaTime,
	float AccelX,
	float AccelY,
	float AccelZ,
	float ClientLocX,
	float ClientLocY,
	float ClientLocZ,
	vector ClientVel,
	int MiscData,
	int MiscData2,
	int View,
	Actor ClientBase,
	optional int OldMoveData1,
	optional int OldMoveData2
) {
	local bbServerMove SM;

	SM = IGPlus_CreateServerMove();

	SM.TimeStamp = TimeStamp;
	SM.MoveDeltaTime = MoveDeltaTime;
	SM.ClientAcceleration.X = AccelX;
	SM.ClientAcceleration.Y = AccelY;
	SM.ClientAcceleration.Z = AccelZ;
	SM.ClientLocation.X = ClientLocX;
	SM.ClientLocation.Y = ClientLocY;
	SM.ClientLocation.Z = ClientLocZ;
	SM.ClientVelocity = ClientVel;
	SM.MiscData = MiscData;
	SM.MiscData2 = MiscData2;
	SM.View = View;
	SM.ClientBase = ClientBase;
	SM.OldMoveData1 = OldMoveData1;
	SM.OldMoveData2 = OldMoveData2;

	if (class'UTPure'.default.bEnableServerPacketReordering) {
		IGPlus_InsertServerMove(SM);
	} else {
		IGPlus_ApplyServerMove(SM);
		IGPlus_DestroyServerMove(SM);
	}
}

function xxServerMoveDead(
	float TimeStamp,
	float MoveDeltaTime,
	int View
) {
	local float ServerDeltaTime;
	local float DeltaTime;

	if (bDeleteMe)
		return;

	if (Role < ROLE_Authority) {
		zzbLogoDone = True;
		zzTrackFOV = 0;
		zzbDemoPlayback = True;
		return;
	}

	zzKickReady = Max(zzKickReady - 1,0);

	if (TimeStamp > Level.TimeSeconds)
		TimeStamp = Level.TimeSeconds;

	if (CurrentTimeStamp >= TimeStamp)
		return;

	ServerDeltaTime = Level.TimeSeconds - ServerTimeStamp;
	if (ServerDeltaTime > 0.9)
		ServerDeltaTime = FMin(ServerDeltaTime, MoveDeltaTime);
	DeltaTime = TimeStamp - CurrentTimeStamp;
	if (DeltaTime > 0.9)
		DeltaTime = FMin(DeltaTime, MoveDeltaTime);

	ExtrapolationDelta += (ServerDeltaTime - DeltaTime);

	if ( ServerTimeStamp > 0 ) {
		// allow 1% error
		TimeMargin += DeltaTime - 1.01 * ServerDeltaTime;
		if ( TimeMargin > MaxTimeMargin ) {
			// player is too far ahead
			TimeMargin -= DeltaTime;
			if ( TimeMargin < 0.5 )
				MaxTimeMargin = Default.MaxTimeMargin;
			else
				MaxTimeMargin = 0.5;
			DeltaTime = 0;
			Log("["$Level.TimeSeconds$"]"@PlayerReplicationInfo.PlayerName@"MaxTimeMargin exceeded ("$TimeMargin$")", 'IGPlus');
		}
	}

	CurrentTimeStamp = TimeStamp;
	ServerTimeStamp = Level.TimeSeconds;

	LastUpdateTime = ServerTimeStamp;
	clientLastUpdateTime = LastUpdateTime;

	if (bClientDead == false) {
		bClientDead = true;
		bFire = 0;
		bAltFire = 0;
	}

	Acceleration = vect(0,0,0);
	Velocity = vect(0,0,0);

	ViewRotation.Yaw = View & 0xFFFF;
	ViewRotation.Pitch = View >>> 16;
}

function float CalculateLocError(float DeltaTime, EPhysics Phys, vector ClientVel) {
	local vector ClientVelCalc;
	local float PosErrFactor;

	// limit ClientVelocity
	switch (Phys) {
	case PHYS_Walking:
		ClientVel = Normal(ClientVel) * FMin(VSize(ClientVel), GroundSpeed);
		break;
	case PHYS_Swimming:
		ClientVel = Normal(ClientVel) * FMin(VSize(ClientVel), WaterSpeed);
		break;
	}

	// Maximum of old and new velocity
	// Ensures we dont force updates when slowing down or speeding up
	ClientVelCalc.X = FMax(ClientVel.X, Velocity.X);
	ClientVelCalc.Y = FMax(ClientVel.Y, Velocity.Y);
	ClientVelCalc.Z = FMax(ClientVel.Z, Velocity.Z);

	PosErrFactor = FMin(DeltaTime, class'UTPure'.default.MaxJitterTime);

	switch (Phys) {
	case PHYS_Walking:
		return
			3 // constant part
			+ PosErrFactor * VSize(ClientVel - Velocity) // velocity
			// bound acceleration by how much we can still speed up
			+ FMin(1.0, FMax(0, GroundSpeed - VSize(ClientVelCalc*vect(1,1,0))) / (AccelRate * PosErrFactor))
				// acceleration
				* 0.5 * AccelRate * PosErrFactor * PosErrFactor;
	case PHYS_Falling:
		return
			3
			+ PosErrFactor * VSize(ClientVel - Velocity)
			+ FMin(1.0, FMax(0, AirControl*GroundSpeed - VSize(ClientVelCalc*vect(1,1,0))) / (AccelRate * AirControl * PosErrFactor))
				* 0.5 * AccelRate * AirControl * PosErrFactor * PosErrFactor;
	case PHYS_Swimming:
		return
			3
			+ PosErrFactor * VSize(ClientVel - Velocity)
			+ FMin(1.0, FMax(0, WaterSpeed - VSize(ClientVelCalc)) / (AccelRate * PosErrFactor))
				* 0.5 * AccelRate * PosErrFactor * PosErrFactor;
	default:
		return 3;
	}
}

function bool OtherPawnAtLocation(vector Loc) {
	local Pawn P;
	local vector RadiusDelta;
	local float HeightDelta;

	foreach RadiusActors(class'Pawn', P, 2*(CollisionRadius+CollisionHeight)) {
		if (P == self) continue;
		if (P.Health <= 0) continue;
		if (P.IsA('Spectator')) continue;

		RadiusDelta = vect(1,1,0) * (P.Location - Loc);
		if (VSize(RadiusDelta) >= 2*CollisionRadius) continue;

		HeightDelta = P.Location.Z - Loc.Z;
		if (Abs(HeightDelta) >= 2*CollisionHeight) continue;

		return true;
	}

	return false;
}

function xxRememberPosition()
{
	local float Now;

	NewestMI.Next = OldestMI;
	OldestMI = OldestMI.Next;
	NewestMI = NewestMI.Next;
	NewestMI.Next = none;

	NewestMI.Save(self);

	Now = Level.TimeSeconds;
	if (Now < zzNextPositionTime)
		return;

	zzLast10Positions[zzPositionIndex] = Location;
	zzPositionIndex++;
	if (zzPositionIndex >= arraycount(zzLast10Positions))
		zzPositionIndex = 0;
	zzNextPositionTime = Now + 0.05;

}

function bool xxCloseEnough(vector HitLoc, optional int HitRadius)
{
	local int i, MaxHitError;
	local vector Loc;
	local bbOldMovementInfo MI;

	MaxHitError = zzUTPure.default.MaxHitError + HitRadius;

	if (VSize(HitLoc - Location) < MaxHitError)
		return true;

	for (i = 0; i < 10; i++)
	{
		Loc = zzLast10Positions[i];
		if (VSize(HitLoc - Loc) < MaxHitError)
			return true;
	}

	MI = OldestMI;
	while (MI != none) {
		if (VSize(HitLoc - MI.Loc) < MaxHitError)
			return true;
		MI = MI.Next;
	}

	return false;

}

function xxServerReceiveMenuItems(string zzMenuItem, bool zzbLast)
{
	Mutate("PMI"@zzMenuItem@byte(zzbLast));
}

function bool xxWeaponIsNewNet( optional bool bAlt )
{
	if (Weapon == None)
		return false;

	return (Weapon.IsA('NN_ShockRifle')
		|| Weapon.IsA('NN_SuperShockRifle')
		|| Weapon.IsA('NN_SniperRifle')
		|| Weapon.IsA('NN_ASMD')
	);
}

simulated function actor NN_TraceShot(out vector HitLocation, out vector HitNormal, vector EndTrace, vector StartTrace, Pawn TheOwner)
{
	local vector realHit;
	local actor Other;
	if (!zzbNN_Tracing)
	{
		zzbNN_Tracing = true;
		xxEnableCarcasses();
	}
	Other = TheOwner.Trace(HitLocation,HitNormal,EndTrace,StartTrace,True);
	if ( Pawn(Other) != None )
	{
		realHit = HitLocation;
		if ( bbPlayer(Other) != None && !bbPlayer(Other).ClientAdjustHitLocation(HitLocation, EndTrace - StartTrace) )
			Other = NN_TraceShot(HitLocation,HitNormal,EndTrace,realHit,Pawn(Other));
	}
	if (zzbNN_Tracing)
	{
		zzbNN_Tracing = false;
		xxDisableCarcasses();
	}
	return Other;
}

simulated function xxEnableCarcasses()
{
	local Carcass C;

	if (!Settings.bShootDead)
		return;

	ForEach AllActors(class'Carcass', C)
		if (C.Physics != PHYS_Falling)
		{
			C.SetCollision(C.Default.bCollideActors, C.Default.bBlockActors, false);
			C.SetCollisionSize(C.Default.CollisionRadius, C.Default.CollisionHeight);
		}
}

simulated function xxDisableCarcasses()
{
	local Carcass C;

	if (!Settings.bShootDead)
		return;

	ForEach AllActors(class'Carcass', C)
		if (C.Physics != PHYS_Falling)
			C.SetCollision(false, false, false);

}

exec function Fire( optional float F )
{
	if (TournamentWeapon(Weapon) != none && TournamentWeapon(Weapon).FireAdjust != 1.0) {
		xxServerCheater("FA");
		TournamentWeapon(Weapon).FireAdjust = 1.0;
	}

	xxEnableCarcasses();
	if (Weapon != none)
		ClientDebugMessage("Fire"@Weapon.Name@ViewRotation);
	if (!bNewNet || !xxWeaponIsNewNet()) {
		if (xxCanFire())
			Super.Fire(F);
	} else if (Role < ROLE_Authority && GameReplicationInfo.GameEndedComments == "") {
		if (Weapon != none)
			Weapon.ClientFire(1);
	} else {
		Super.Fire(F);
	}
	xxDisableCarcasses();
}

function xxNN_Fire( int ProjIndex, vector ClientLoc, vector ClientVel, rotator ViewRot, optional actor HitActor, optional vector HitLoc, optional vector HitDiff, optional bool bSpecial, optional int ClientFRVI, optional float ClientAccuracy )
{
	local ImpactHammer IH;
	local float TradeTimeMargin;

	if (!bNewNet || !xxWeaponIsNewNet() || Role < ROLE_Authority)
		return;

	xxEnableCarcasses();
	zzNN_ProjIndex = ProjIndex;
	zzNN_ClientLoc = ClientLoc;
	zzNN_ClientVel = ClientVel;
	zzNN_ViewRot = ViewRot;
	zzNN_HitActor = HitActor;
	zzNN_HitLoc = HitLoc;
	zzNN_HitDiff = HitDiff;
	zzNN_FRVI = ClientFRVI;
	zzFRVI = ClientFRVI;
	zzNN_Accuracy = ClientAccuracy;
	zzbNN_ReleasedFire = false;
	zzbNN_ReleasedAltFire = false;
	zzbNN_Special = bSpecial;

	IH = ImpactHammer(Weapon);

	if (IH != None)
	{
		if (bSpecial)
			IH.TraceFire(1);
		else
			IH.TraceFire(2);
		IH.PlayFiring();
		IH.GoToState('FireBlast');
	}
	else if (xxCanFire())
	{
		if (class'UTPure'.default.bRestrictTrading && IsInState('Dying')) {
			if (bbPlayer(LastKiller) != none)
				TradeTimeMargin = FMin(
					class'UTPure'.default.MaxTradeTimeMargin,
					((AverageServerDeltaTime + TimeBetweenNetUpdates)/Level.TimeDilation +
					0.0005 * PlayerReplicationInfo.Ping * class'UTPure'.default.TradePingMargin +
					0.0005 * (PlayerReplicationInfo.Ping - bbPlayer(LastKiller).PlayerReplicationInfo.Ping))
				);
			else
				TradeTimeMargin = class'UTPure'.default.MaxTradeTimeMargin;

			if (RealTimeDead < TradeTimeMargin) {
				Log("["$Level.TimeSeconds$"] Traded! TradeTimeMargin="$TradeTimeMargin@"RealTimeDead="$RealTimeDead, 'IGPlus');
				Super.Fire(1);
			} else {
				Log("["$Level.TimeSeconds$"] Rejected Trade! TradeTimeMargin="$TradeTimeMargin@"RealTimeDead="$RealTimeDead, 'IGPlus');
			}
		} else {
			if (IsInState('Dying'))
				Log("["$Level.TimeSeconds$"] Traded! RealTimeDead="$RealTimeDead, 'IGPlus');
			Super.Fire(1);
		}
	}
	zzNN_HitActor = None;
	zzbNN_Special = false;
	xxDisableCarcasses();
}

exec function AltFire( optional float F )
{
	xxEnableCarcasses();
	if (!bNewNet || !xxWeaponIsNewNet(true))
	{
		if (xxCanFire())
			Super.AltFire(F);
	}
	else if (Role < ROLE_Authority)
	{
		Weapon.ClientAltFire(1);
	}
	xxDisableCarcasses();
}

function xxNN_AltFire( int ProjIndex, vector ClientLoc, vector ClientVel, rotator ViewRot, optional actor HitActor, optional vector HitLoc, optional vector HitDiff, optional bool bSpecial, optional int ClientFRVI, optional float ClientAccuracy )
{
	if (!bNewNet || !xxWeaponIsNewNet(true) || Role < ROLE_Authority)
		return;

	xxEnableCarcasses();
	zzNN_ProjIndex = ProjIndex;
	zzNN_ClientLoc = ClientLoc;
	zzNN_ClientVel = ClientVel;
	zzNN_ViewRot = ViewRot;
	zzNN_HitActor = HitActor;
	zzNN_HitLoc = HitLoc;
	zzNN_HitDiff = HitDiff;
	zzNN_FRVI = ClientFRVI;
	zzFRVI = ClientFRVI;
	zzNN_Accuracy = ClientAccuracy;
	zzbNN_ReleasedFire = false;
	zzbNN_ReleasedAltFire = false;
	zzbNN_Special = bSpecial;

	if (xxCanFire())
	{
		Super.AltFire(1);
	}
	zzNN_HitActor = None;
	zzbNN_Special = false;
	xxDisableCarcasses();
}

function xxNN_ReleaseFire( int ProjIndex, vector ClientLoc, vector ClientVel, rotator ViewRot, optional int ClientFRVI )
{
	if (!bNewNet || !xxWeaponIsNewNet() || Role < ROLE_Authority)
		return;

	zzNN_ProjIndex = ProjIndex;
	zzNN_ClientLoc = ClientLoc;
	zzNN_ClientVel = ClientVel;
	zzNN_ViewRot = ViewRot;
	zzNN_FRVI = ClientFRVI;
	zzFRVI = ClientFRVI;
	zzbNN_ReleasedFire = true;
}

function xxNN_ReleaseAltFire( int ProjIndex, vector ClientLoc, vector ClientVel, rotator ViewRot, optional int ClientFRVI )
{
	if (!bNewNet || !xxWeaponIsNewNet(true) || Role < ROLE_Authority)
		return;

	zzNN_ProjIndex = ProjIndex;
	zzNN_ClientLoc = ClientLoc;
	zzNN_ClientVel = ClientVel;
	zzNN_ViewRot = ViewRot;
	zzNN_FRVI = ClientFRVI;
	zzFRVI = ClientFRVI;
	zzbNN_ReleasedAltFire = true;
}

simulated function int xxNN_AddProj(Projectile Proj)
{
	local int ProjIndex;

	if (Proj == None || zzNN_ProjIndex < 0)
		return -1;

	zzNN_Projectiles[zzNN_ProjIndex] = Proj;

	ProjIndex = zzNN_ProjIndex;
	zzNN_ProjIndex++;
	if (zzNN_ProjIndex >= NN_ProjLength)
		zzNN_ProjIndex = 0;

	return ProjIndex;
}

simulated function xxNN_RemoveProj(int ProjIndex, optional vector HitLocation, optional vector HitNormal, optional bool bCombo)
{
	if (zzNN_Projectiles[ProjIndex] == None || xxGarbageLocation(zzNN_Projectiles[ProjIndex]))
		return;

	zzNN_ProjLocations[ProjIndex] = zzNN_Projectiles[ProjIndex].Location;
	zzNN_Projectiles[ProjIndex] = None;

	if (Level.NetMode == NM_Client)
		xxNN_ProjExplode(ProjIndex, HitLocation, HitNormal, bCombo);
	else
		xxNN_ClientProjExplode(ProjIndex, HitLocation, HitNormal, bCombo);
}

simulated function xxNN_ProjExplode( int ProjIndex, optional vector HitLocation, optional vector HitNormal, optional bool bCombo )
{
	local Projectile Proj;

	if (Level.NetMode == NM_Client)
		return;

	xxEnableCarcasses();
	if (ProjIndex < 0)
	{
		ProjIndex = -1*(ProjIndex + 1);
		Proj = zzNN_Projectiles[ProjIndex];
		if (Proj != None && !xxGarbageLocation(Proj))
		{
			zzNN_ProjLocations[ProjIndex] = Proj.Location;
			Proj.Destroy();
		}
	}
	else
	{
		Proj = zzNN_Projectiles[ProjIndex];
		if (Proj != None && !xxGarbageLocation(Proj))
		{
			zzNN_ProjLocations[ProjIndex] = Proj.Location;
			if (bCombo && Proj.IsA('ShockProj'))
			{
				if (IsInState('Dying'))
					ShockProj(Proj).SuperExplosion();
			}
			else
			{
				Proj.Explode(HitLocation, HitNormal);
			}
		}
	}
	xxDisableCarcasses();
}

simulated function xxNN_ClientProjExplode( int ProjIndex, optional vector HitLocation, optional vector HitNormal, optional bool bCombo )
{
	local Projectile Proj;

	if (Level.NetMode != NM_Client)
		return;

	xxEnableCarcasses();
	if (ProjIndex < 0)
	{
		ProjIndex = -1*(ProjIndex + 1);
		Proj = zzNN_Projectiles[ProjIndex];
		if (Proj != None && !xxGarbageLocation(Proj))
		{
			zzNN_ProjLocations[ProjIndex] = Proj.Location;
			Proj.Destroy();
		}
	}
	else
	{
		Proj = zzNN_Projectiles[ProjIndex];
		if (Proj != None && !xxGarbageLocation(Proj))
		{
			zzNN_ProjLocations[ProjIndex] = Proj.Location;
			if (bCombo && Proj.IsA('ShockProj'))
			{
				if (IsInState('Dying'))
					ShockProj(Proj).SuperExplosion();
			}
			else
			{
				Proj.Explode(HitLocation, HitNormal);
			}
		}
	}
	xxDisableCarcasses();
}

// Think about what you're doing.  Look at the bigger picture of it all, if you're able to.  This is a 15+ year old video game.
// Is this really the legacy you want to leave behind?  You'll never amount to anything if you keep this up.
// Seriously.  Do something good with your time.  Build something that improves lives.
// I understand that you are bitter, but you'll feel better if you listen to me.
// Doing good things will make you feel good.

simulated function xxSetTeleRadius(int newRadius)
{
	TeleRadius = newRadius;
}

simulated function xxSetDefaultWeapon(name W)
{
	zzDefaultWeapon = W;
}

simulated function xxSetSniperSpeed(float SniperSpeed)
{
	class'UTPure'.default.SniperSpeed = SniperSpeed;
}

simulated function xxSetTimes(int RemainingTime, int ElapsedTime)
{
	if (GameReplicationInfo == None)
		return;
	GameReplicationInfo.RemainingTime = RemainingTime;
	GameReplicationInfo.ElapsedTime = ElapsedTime;
}


function ReplicateMove
(
	float DeltaTime,
	vector NewAccel,
	eDodgeDir DodgeMove,
	rotator DeltaRot
)
{
	xxServerCheater("RM");
}

function bbSavedMove xxGetFreeMove() {
	local bbSavedMove s;

	if ( FreeMoves == None )
		return Spawn(class'bbSavedMove');
	else
	{
		s = bbSavedMove(FreeMoves);
		FreeMoves = FreeMoves.NextMove;
		s.NextMove = None;
		s.Clear2();
		return s;
	}
}

function bbSavedMove PickRedundantMove(bbSavedMove Old, bbSavedMove M, vector Accel, EDodgeDir DodgeMove) {
	if (M.bPressedJump || (bDodging && M.DodgeMove >= DODGE_Left && M.DodgeMove <= DODGE_Back)) {
		return M;
	}
	if (VSize(Accel - M.Acceleration) > 0.125 * AccelRate) {
		if (Old == none || (Old.bPressedJump == false && (Old.DodgeMove < DODGE_Left || Old.DodgeMove > DODGE_Back)))
			return M;
	}
	return Old;
}

function bool CanMergeMove(bbSavedMove Pending, vector Accel) {
	if (Pending.IGPlus_MergeCount >= 31)
		return false;

	if (bIs469Server || Pending.Delta >= 0.005) // only 469 servers like updates for <5ms
		return bForcePacketSplit == false &&
			(VSize(Accel - Pending.Acceleration) < 1 || Normal(Accel) dot Normal(Pending.Acceleration) > 0.95) &&
			Pending.bForceFire == false && Pending.bForceAltFire == false &&
			Pending.bPressedJump == false && (Pending.DodgeMove == DODGE_None || Pending.DodgeMove >= DODGE_Active) &&
			LastAddVelocityAppliedIndex == LastAddVelocityIndex;

	return true;
}

function xxReplicateMove(
	float DeltaTime,
	vector NewAccel,
	eDodgeDir DodgeMove,
	rotator DeltaRot
) {
	local bbSavedMove NewMove, OldMove, LastMove, PendMove;
	local float TotalTime;
	local EPhysics OldPhys;
	local float AdjustAlpha;
	local float RealDelta;
	local vector PrevVelocity;
	local vector OldAccel;

	// Higor: process smooth adjustment.
	if (IGPlus_AdjustLocationAlpha > 0)
	{
		AdjustAlpha = FMin(IGPlus_AdjustLocationAlpha, DeltaTime);
		MoveSmooth(IGPlus_AdjustLocationOffset * AdjustAlpha);
		IGPlus_AdjustLocationAlpha -= AdjustAlpha;
	}

	if ( VSize(NewAccel) > 3072)
		NewAccel = 3072 * Normal(NewAccel);
	OldAccel = Acceleration;

	if (bDrawDebugData) {
		debugNewAccel = Normal(NewAccel);
		debugPlayerLocation = Location;
	}

	// Get a SavedMove actor to store the movement in.
	if ( PendingMove != None )
	{
		PendMove = bbSavedMove(PendingMove);
		if (CanMergeMove(PendMove, NewAccel)) {
			//add this move to the pending move
			PendMove.TimeStamp = Level.TimeSeconds;
			PendMove.IGPlus_MergeCount += 1;

			TotalTime = PendMove.Delta + DeltaTime;
			if (TotalTime != 0)
				PendMove.Acceleration = (DeltaTime * NewAccel + PendMove.Delta * PendMove.Acceleration)/TotalTime;

			// Set this move's data.
			if ( PendMove.DodgeMove == DODGE_None ) {
				PendMove.DodgeMove = DodgeMove;
				if (DodgeMove > DODGE_None && DodgeMove < DODGE_Active && PendMove.DodgeIndex < 0) {
					PendMove.DodgeIndex = PendMove.IGPlus_MergeCount;
				}
			}

			if (PendMove.bPressedJump == false && bPressedJump && PendMove.JumpIndex < 0)
				PendMove.JumpIndex = PendMove.IGPlus_MergeCount;
			PendMove.bPressedJump = bPressedJump || PendMove.bPressedJump;

			if ((bRun > 0) != PendMove.bRun) {
				if (PendMove.RunChangeIndex < 0)
					PendMove.RunChangeIndex = PendMove.IGPlus_MergeCount;
				else
					// if we changed bRun before, ignore running/walking for a very short time
					PendMove.RunChangeIndex = -1;
			}
			PendMove.bRun = (bRun > 0);

			if ((bDuck > 0) != PendMove.bDuck) {
				if (PendMove.DuckChangeIndex < 0)
					PendMove.DuckChangeIndex = PendMove.IGPlus_MergeCount;
				else
					// if we changed bDuck before, ignore ducking/standing for a very short time
					PendMove.DuckChangeIndex = -1;
			}
			PendMove.bDuck = (bDuck > 0);

			PendMove.bFire = PendMove.bFire || bJustFired || (bFire != 0);
			PendMove.bForceFire = PendMove.bForceFire || bJustFired;
			PendMove.bAltFire = PendMove.bAltFire || bJustAltFired || (bAltFire != 0);
			PendMove.bForceAltFire = PendMove.bForceAltFire || bJustAltFired;
			PendMove.Delta = TotalTime;
		} else {
			SendSavedMove(PendMove);
			ClientUpdateTime = FClamp((PendMove.Delta/Level.TimeDilation) - TimeBetweenNetUpdates + ClientUpdateTime, -TimeBetweenNetUpdates, TimeBetweenNetUpdates);;

			if (SavedMoves == none) {
				SavedMoves = PendingMove;
			} else {
				LastMove = bbSavedMove(SavedMoves);
				while(LastMove.NextMove != none)
					LastMove = bbSavedMove(LastMove.NextMove);

				LastMove.NextMove = PendingMove;
			}
			PendingMove = none;
		}
	}
	if ( SavedMoves != None )
	{
		LastMove = bbSavedMove(SavedMoves);
		while (LastMove.NextMove != none) {
			LastMove.Age += DeltaTime;
			OldMove = PickRedundantMove(OldMove, LastMove, NewAccel, DodgeMove);
			LastMove = bbSavedMove(LastMove.NextMove);
		}
		LastMove.Age += DeltaTime;
		OldMove = PickRedundantMove(OldMove, LastMove, NewAccel, DodgeMove);
	}

	if ( PendingMove == None ) {
		NewMove = xxGetFreeMove();
		NewMove.Delta = DeltaTime;
		NewMove.Acceleration = NewAccel;

		while (LastAddVelocityAppliedIndex != LastAddVelocityIndex) {
			PrevVelocity = Velocity;
			IGPlus_ApplyMomentum(AddVelocityCalls[LastAddVelocityAppliedIndex].Momentum);
			AddVelocityCalls[LastAddVelocityAppliedIndex].Momentum = vect(0,0,0);
			NewMove.Momentum += (Velocity - PrevVelocity);

			LastAddVelocityAppliedIndex = (LastAddVelocityAppliedIndex+1) & 0xF;
		}
		NewMove.AddVelocityId = LastAddVelocityAppliedIndex;

		// Set this move's data.
		NewMove.DodgeMove = DodgeMove;
		if (DodgeMove > DODGE_None && DodgeMove < DODGE_Active)
			NewMove.DodgeIndex = 0;
		NewMove.TimeStamp = Level.TimeSeconds;
		NewMove.bRun = (bRun > 0);
		NewMove.bDuck = (bDuck > 0);
		NewMove.bPressedJump = bPressedJump;
		if (bPressedJump)
			NewMove.JumpIndex = 0;
		NewMove.bFire = (bJustFired || (bFire != 0));
		NewMove.bAltFire = (bJustAltFired || (bAltFire != 0));
		NewMove.bForceFire = bJustFired;
		NewMove.bForceAltFire = bJustAltFired;
		if ( Weapon != None ) // approximate pointing so don't have to replicate
			Weapon.bPointing = ((bFire != 0) || (bAltFire != 0));

		PendingMove = NewMove;
	} else {
		NewMove = bbSavedMove(PendingMove);
	}

	bJustFired = false;
	bJustAltFired = false;
	OldPhys = Physics;

	LastTouchedTeleporter = none;

	// Simulate the movement locally.
	ProcessMove(DeltaTime, NewAccel, DodgeMove, DeltaRot);
	AutonomousPhysics(DeltaTime);

	CorrectTeleporterVelocity();

	NewMove.SetRotation( Rotation );
	NewMove.IGPlus_SavedViewRotation = ViewRotation;
	NewMove.IGPlus_SavedLocation = Location;
	NewMove.IGPlus_SavedVelocity = Velocity;

	// Decide whether to hold off on move
	// send if dodge, jump, or fire unless really too soon, or if newmove.delta big enough
	// on client side, save extra buffered time in LastUpdateTime
	RealDelta = PendingMove.Delta / Level.TimeDilation;

	if (RealDelta < TimeBetweenNetUpdates - ClientUpdateTime && CanMergeMove(NewMove, OldAccel))
		return;

	bForcePacketSplit = false;
	ClientUpdateTime = FClamp(RealDelta - TimeBetweenNetUpdates + ClientUpdateTime, -TimeBetweenNetUpdates, TimeBetweenNetUpdates);
	if ( SavedMoves == None )
		SavedMoves = PendingMove;
	else
		LastMove.NextMove = PendingMove;
	PendingMove = None;

	SendSavedMove(NewMove, OldMove);
}

function SendSavedMove(bbSavedMove Move, optional bbSavedMove OldMove) {
	local int MiscData, MiscData2;
	local vector RelLoc;
	local int OldMoveData1, OldMoveData2;

	if (Move.bPressedJump) bJumpStatus = !bJumpStatus;

	if (Base == none)
		RelLoc = Location;
	else
		RelLoc = Location - Base.Location;

	MiscData = MiscData | (TlocCounter << 29);
	if (Move.bFire) MiscData = MiscData | 0x10000000;
	if (Move.bAltFire) MiscData = MiscData | 0x08000000;
	if (Move.bForceFire) MiscData = MiscData | 0x04000000;
	if (Move.bForceAltFire) MiscData = MiscData | 0x02000000;
	// 0x01000000 unused
	MiscData = MiscData | ((Move.IGPlus_MergeCount & 0x1F) << 19);
	if (Move.bRun) MiscData = MiscData | 0x40000;
	if (Move.bDuck) MiscData = MiscData | 0x20000;
	if (bJumpStatus) MiscData = MiscData | 0x10000;
	MiscData = MiscData | (int(Physics) << 12);
	MiscData = MiscData | (int(Move.DodgeMove) << 8);
	MiscData = MiscData | ((Rotation.Roll >> 8) & 0xFF);

	if (Move.JumpIndex > 0)       MiscData2 = MiscData2 | (Move.JumpIndex & 0x1F);
	if (Move.DodgeIndex > 0)      MiscData2 = MiscData2 | (Move.DodgeIndex & 0x1F) << 5;
	if (Move.RunChangeIndex > 0)  MiscData2 = MiscData2 | (Move.RunChangeIndex & 0x1F) << 10;
	if (Move.DuckChangeIndex > 0) MiscData2 = MiscData2 | (Move.DuckChangeIndex & 0x1F) << 15;
	                              MiscData2 = MiscData2 | (Move.AddVelocityId & 0xF) << 20;

	if (OldMove != none) {
		OldMoveData1 = Min(0x3FF, int(OldMove.Age * 1000.0));
		if (OldMove.bPressedJump) OldMoveData1 = OldMoveData1 | 0x0400;
		if (OldMove.bRun) OldMoveData1 = OldMoveData1 | 0x0800;
		if (OldMove.bDuck) OldMoveData1 = OldMoveData1 | 0x1000;
		OldMoveData1 = OldMoveData1 | (int(OldMove.DodgeMove) << 13);
		OldMoveData1 = OldMoveData1 | (int(OldMove.Acceleration.X * 10.0) << 16);
		OldMoveData2 = OldMoveData2 | (int(OldMove.Acceleration.Y * 10.0) & 0xFFFF);
		OldMoveData2 = OldMoveData2 | (int(OldMove.Acceleration.Z * 10.0) << 16);
	}

	xxServerMove(
		Move.TimeStamp,
		Move.Delta,
		Move.Acceleration.X,
		Move.Acceleration.Y,
		Move.Acceleration.Z,
		RelLoc.X,
		RelLoc.Y,
		RelLoc.Z,
		Velocity,
		MiscData,
		MiscData2,
		((Move.IGPlus_SavedViewRotation.Pitch & 0xFFFF) << 16) | (Move.IGPlus_SavedViewRotation.Yaw & 0xFFFF),
		Base,
		OldMoveData1,
		OldMoveData2
	);

	debugServerMoveCallsSent += 1;

	if ( (Weapon != None) && !Weapon.IsAnimating() )
	{
		if ( (Weapon == ClientPending) || (Weapon != OldClientWeapon) )
		{
			if ( Weapon.IsInState('ClientActive') )
				AnimEnd();
			else
				Weapon.GotoState('ClientActive');

			if ( (Weapon != OldClientWeapon) && (OldClientWeapon != None) )
				OldClientWeapon.GotoState('');

			ClientPending = None;
			bNeedActivate = false;
		}
		else
		{
			Weapon.GotoState('');
			Weapon.TweenToStill();
		}
	}
	OldClientWeapon = Weapon;
}

simulated function bool xxUsingDefaultWeapon()
{
	local int x;
	local name W;

	if (Weapon == None || zzUTPure == None)
		return false;

	if (Weapon.IsA(zzDefaultWeapon))
		return true;

	for (x = 0; x < 8; x++)
	{
		W = zzUTPure.zzDefaultWeapons[x];
		if (W == '')
			continue;
		if (Weapon.Class.Name == W)
			return true;
	}

	return false;
}

exec function ThrowWeapon()
{
	if( Level.NetMode == NM_Client )
		return;

	if( Weapon==None || (Weapon.Class==Level.Game.BaseMutator.MutatedDefaultWeapon())
		|| !Weapon.bCanThrow || Weapon.IsInState('Idle') == false )
		return;

	Weapon.Velocity = Vector(ViewRotation) * vect(1,1,0) * zzThrowVelocity + vect(0,0,220);
	Weapon.bTossedOut = true;
	TossWeapon();
	if ( Weapon == None )
		SwitchToBestWeapon();
}

// toss out the weapon currently held
function TossWeapon()
{
	local vector X,Y,Z;
	if ( Weapon == None )
		return;
	GetAxes(Rotation.Yaw*rot(0,1,0),X,Y,Z);
	Weapon.DropFrom(Location + (CollisionRadius+Weapon.CollisionRadius) * X - 0.5 * CollisionRadius * Y);
}


function string forcedModelToString(int fm) {
	switch(fm) {
		case 0:
			return "Class: Female Commando, Skin: Aphex, Face: Idina";
		case 1:
			return "Class: Female Commando, Skin: Commando, Face: Anna";
		case 2:
			return "Class: Female Commando, Skin: Mercenary, Face: Jayce";
		case 3:
			return "Class: Female Commando, Skin: Necris, Face: Cryss";
		case 4:
			return "Class: Female Soldier, Skin: Marine, Face: Annaka";
		case 5:
			return "Class: Female Soldier, Skin: Metal Guard, Face: Isis";
		case 6:
			return "Class: Female Soldier, Skin: Soldier, Face: Lauren";
		case 7:
			return "Class: Female Soldier, Skin: Venom, Face: Athena";
		case 8:
			return "Class: Female Soldier, Skin: War Machine, Face: Cathode";
		case 9:
			return "Class: Male Commando, Skin: Commando, Face: Blake";
		case 10:
			return "Class: Male Commando, Skin: Mercenary, Face: Boris";
		case 11:
			return "Class: Male Commando, Skin: Necris, Face: Grail";
		case 12:
			return "Class: Male Soldier, Skin: Marine, Face: Malcolm";
		case 13:
			return "Class: Male Soldier, Skin: Metal Guard, Face: Drake";
		case 14:
			return "Class: Male Soldier, Skin: RawSteel, Face: Arkon";
		case 15:
			return "Class: Male Soldier, Skin: Soldier, Face: Brock";
		case 16:
			return "Class: Male Soldier, Skin: War Machine, Face: Matrix";
		case 17:
			return "Class: Boss, Skin: Boss, Face: Xan";
	}
}

exec function enableDebugData(bool b) {
	bDrawDebugData = b;
	if (b) {
		ClientMessage("Debug data: on");
	} else {
		ClientMessage("Debug data: off");
	}
}

exec function EnableHitSound(bool b) {
	Settings.bEnableHitSounds = b;
	Settings.SaveConfig();
	if (b) {
		ClientMessage("HitSound: on");
	} else {
		ClientMessage("HitSound: off");
	}
}

exec function EnableTeamHitSound(bool b) {
	Settings.bEnableTeamHitSounds = b;
	Settings.SaveConfig();
	if (b) {
		ClientMessage("Team HitSound: on");
	} else {
		ClientMessage("Team HitSound: off");
	}
}

exec function setForcedSkins(int maleSkin, int femaleSkin) {
	local bool error;
	if (maleSkin < -1 || maleSkin == 0 || maleSkin > 18) {
		ClientMessage("Invalid maleSkin, please input a value between 1 and 18, or -1 to disable");
		error = true;
	}
	if (femaleSkin < -1 || femaleSkin == 0 || femaleSkin > 18) {
		ClientMessage("Invalid femaleSkin, please input a value between 1 and 18, or -1 to disable");
		error = true;
	}

	if (error) {
		ClientMessage("Usage: setForcedSkins <maleSkin> <femaleSkin>");
		return;
	}

	Settings.desiredSkin = maleSkin - 1;
	Settings.desiredSkinFemale = femaleSkin - 1;
	Settings.SaveConfig();
	ClientMessage("Forced enemy skin set!");
}

exec function setForcedTeamSkins(int maleSkin, int femaleSkin) {
	local bool error;
	if (maleSkin < -1 || maleSkin == 0 || maleSkin > 18) {
		ClientMessage("Invalid maleSkin, please input a value between 1 and 18, or -1 to disable");
		error = true;
	}
	if (femaleSkin < -1 || femaleSkin == 0 || femaleSkin > 18) {
		ClientMessage("Invalid femaleSkin, please input a value between 1 and 18, or -1 to disable");
		error = true;
	}

	if (error) {
		ClientMessage("Usage: setForcedTeamSkins <maleSkin> <femaleSkin>");
		return;
	}

	Settings.desiredTeamSkin = maleSkin - 1;
	Settings.desiredTeamSkinFemale = femaleSkin - 1;
	Settings.SaveConfig();
	ClientMessage("Forced team skin set!");
}

exec function SetHitSound(byte hs) {
	if (hs >= 0 && hs < 16) {
		Settings.SelectedHitSound = hs;
		class'bbPlayerStatics'.default.PlayedHitSound = none;
		Settings.SaveConfig();
		ClientMessage("HitSound set!");
	} else {
		ClientMessage("Please input a value from 0 to 15");
	}
}

exec function SetTeamHitSound(byte hs) {
	if (hs >= 0 && hs < 16) {
		Settings.SelectedTeamHitSound = hs;
		class'bbPlayerStatics'.default.PlayedTeamHitSound = none;
		Settings.SaveConfig();
		ClientMessage("Team HitSound set!");
	} else {
		ClientMessage("Please input a value from 0 to 15");
	}
}

exec function setShockBeam(int sb) {
	if (sb > 0 && sb <= 4) {
		Settings.cShockBeam = sb;
		Settings.SaveConfig();
		ClientMessage("Shock beam set!");
	} else
		ClientMessage("Please input a value between 1 and 4");
}

exec function setBeamScale(float bs) {
	if (bs >= 0.1 && bs <= 1.0) {
		Settings.BeamScale = bs;
		Settings.SaveConfig();
		ClientMessage("Beam scale set!");
	} else
		ClientMessage("Please input a value between 0.1 and 1.0");
}

exec function listSkins() {
	ClientMessage("Skin List:");
	ClientMessage("Input the desired number with the SetForcedSkins command");
	ClientMessage("-1 - Dont force this type of skin");
	ClientMessage("1 - Class: Female Commando, Skin: Aphex, Face: Idina");
	ClientMessage("2 - Class: Female Commando, Skin: Commando, Face: Anna");
	ClientMessage("3 - Class: Female Commando, Skin: Mercenary, Face: Jayce");
	ClientMessage("4 - Class: Female Commando, Skin: Necris, Face: Cryss");
	ClientMessage("5 - Class: Female Soldier, Skin: Marine, Face: Annaka");
	ClientMessage("6 - Class: Female Soldier, Skin: Metal Guard, Face: Isis");
	ClientMessage("7 - Class: Female Soldier, Skin: Soldier, Face: Lauren");
	ClientMessage("8 - Class: Female Soldier, Skin: Venom, Face: Athena");
	ClientMessage("9 - Class: Female Soldier, Skin: War Machine, Face: Cathode");
	ClientMessage("10 - Class: Male Commando, Skin: Commando, Face: Blake");
	ClientMessage("11 - Class: Male Commando, Skin: Mercenary, Face: Boris");
	ClientMessage("12 - Class: Male Commando, Skin: Necris, Face: Grail");
	ClientMessage("13 - Class: Male Soldier, Skin: Marine, Face: Malcolm");
	ClientMessage("14 - Class: Male Soldier, Skin: Metal Guard, Face: Drake");
	ClientMessage("15 - Class: Male Soldier, Skin: RawSteel, Face: Arkon");
	ClientMessage("16 - Class: Male Soldier, Skin: Soldier, Face: Brock");
	ClientMessage("17 - Class: Male Soldier, Skin: War Machine, Face: Matrix");
	ClientMessage("18 - Class: Boss, Skin: Boss, Face: Xan");
}

exec function MyIGSettings() {
	local string Dump;
	local int lf;
	Dump = Settings.DumpSettings();

	lf = InStr(Dump, Chr(10));
	while(lf >= 0) {
		ClientMessage(Left(Dump, lf), 'IGPlus');
		Dump = Mid(Dump, lf+1, Len(Dump));
		lf = InStr(Dump, Chr(10));
	}

	ClientMessage(Dump, 'IGPlus');
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

event PlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
{
	local Pawn PTarget;
	local bbPlayer bbP;

	if (zzInfoThing != None)
			zzInfoThing.zzPlayerCalcViewCalls--;

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
					bbP = bbPlayer(PTarget);
					if (bbp != none) {
						PTarget.ViewRotation.Pitch = bbP.CompressedViewRotation >>> 16;
						PTarget.ViewRotation.Yaw = bbP.CompressedViewRotation & 0xFFFF;
						PTarget.ViewRotation.Roll = 0;
					} else {
						PTarget.ViewRotation = TargetViewRotation;
					}
				}
				PTarget.EyeHeight = TargetEyeHeight;
				if ( PTarget.Weapon != None )
					PTarget.Weapon.PlayerViewOffset = TargetWeaponViewOffset;
			}
			if ( PTarget.bIsPlayer )
				CameraRotation = PTarget.ViewRotation;
			CameraLocation.Z += PTarget.EyeHeight;
		}
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
		if (zzbRepVRData) {
			// Received data through demo replication.
			CameraRotation.Yaw = zzRepVRYaw;
			CameraRotation.Pitch = zzRepVRPitch;
			CameraRotation.Roll = 0;
			EyeHeight = zzRepVREye;
		} else {
			CameraRotation = ViewRotation;
		}
		CameraLocation += WalkBob;
	}
}

function ViewShake(float DeltaTime)
{
	local int Roll;

	if (shaketimer > 0.0) //shake view
	{
		shaketimer -= DeltaTime;
		if ( verttimer == 0 )
		{
			verttimer = 0.1;
			ShakeVert = -1.1 * maxshake;
		}
		else
		{
			verttimer -= DeltaTime;
			if ( verttimer < 0 )
			{
				verttimer = 0.2 * FRand();
				shakeVert = (2 * FRand() - 1) * maxshake;
			}
		}
		ViewRotation.Roll = ViewRotation.Roll & 65535;
		if (bShakeDir)
		{
			ViewRotation.Roll += Int( 10 * shakemag * FMin(0.1, DeltaTime));
			bShakeDir = (ViewRotation.Roll > 32768) || (ViewRotation.Roll < (0.5 + FRand()) * shakemag);
			if ( (ViewRotation.Roll < 32768) && (ViewRotation.Roll > 1.3 * shakemag) )
			{
				ViewRotation.Roll = 1.3 * shakemag;
				bShakeDir = false;
			}
			else if (FRand() < 3 * DeltaTime)
				bShakeDir = !bShakeDir;
		}
		else
		{
			ViewRotation.Roll -= Int( 10 * shakemag * FMin(0.1, DeltaTime));
			bShakeDir = (ViewRotation.Roll > 32768) && (ViewRotation.Roll < 65535 - (0.5 + FRand()) * shakemag);
			if ( (ViewRotation.Roll > 32768) && (ViewRotation.Roll < 65535 - 1.3 * shakemag) )
			{
				ViewRotation.Roll = 65535 - 1.3 * shakemag;
				bShakeDir = true;
			}
			else if (FRand() < 3 * DeltaTime)
				bShakeDir = !bShakeDir;
		}
	}
	else
	{
		ShakeVert = 0;
		Roll = Utils.RotU2S(ViewRotation.Roll);
		if (Roll > 0) {
			Roll -= Max(Roll, 500) * 10 * FMin(0.1, DeltaTime);
			if (Roll < 0) Roll = 0;
		} else if (Roll < 0) {
			Roll -= Min(Roll, -500) * 10 * FMin(0.1, DeltaTime);
			if (Roll > 0) Roll = 0;
		}
		ViewRotation.Roll = Utils.RotS2U(Roll);
	}
}

function UpdateRotation(float DeltaTime, float maxPitch);

function xxUpdateRotation(float DeltaTime, float maxPitch)
{
	local rotator newRotation;
	local float PitchDelta, YawDelta;

	DesiredRotation = ViewRotation; //save old rotation

	PitchDelta = 32.0 * DeltaTime * aLookUp + LookUpFractionalPart;
	ViewRotation.Pitch += int(PitchDelta);
	if (!Settings.bUseOldMouseInput)
		LookUpFractionalPart = PitchDelta - int(PitchDelta);

	ViewRotation.Pitch = Utils.RotS2U(Clamp(Utils.RotU2S(ViewRotation.Pitch), -16384, 16383));

	YawDelta = 32.0 * DeltaTime * aTurn + TurnFractionalPart;
	ViewRotation.Yaw += int(YawDelta);
	if (!Settings.bUseOldMouseInput)
		TurnFractionalPart = YawDelta - int(YawDelta);

	ViewShake(deltaTime);		// ViewRotation is fuked in here.
	ViewFlash(deltaTime);

	newRotation = Rotation;
	newRotation.Yaw = ViewRotation.Yaw;
	newRotation.Pitch = Utils.RotS2U(Clamp(
		Utils.RotU2S(ViewRotation.Pitch),
		-maxPitch * RotationRate.Pitch,
		maxPitch * RotationRate.Pitch));
	setRotation(newRotation);

	if (!zzbRepVRData)
	{
		xxReplicateVRToDemo(ViewRotation.Yaw, ViewRotation.Pitch, EyeHeight);
		zzbRepVRData = False;		// When xxReplicateVRToDemo is executed, this var is set to true
	}
}

function xxReplicateVRToDemo(int zzYaw, int zzPitch, float zzEye)
{	// This is called before tick in a demo, but in xxUpdateRotation during creating.
	zzRepVRYaw = zzYaw;
	zzRepVRPitch = zzPitch;
	zzRepVREye = zzEye;
	zzbRepVRData = True;
}

function SendVoiceMessage(PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name messagetype, byte messageID, name broadcasttype)
{
	if (Sender == PlayerReplicationInfo)
		super.SendVoiceMessage(PlayerReplicationInfo, Recipient, MessageType, MessageID,broadcasttype);  //lame anti-cheat :P
}

function ServerTaunt(name Sequence )
{
	if (Level.TimeSeconds - zzLastTaunt > 1.0)
	{
		if ( GetAnimGroup(Sequence) == 'Gesture' )
			PlayAnim(Sequence, 0.7, 0.2);
	}
	else
		zzKickReady++;
	zzLastTaunt = Level.TimeSeconds;
}

simulated function bool AdjustHitLocation(out vector HitLocation, vector TraceDir)
{
	local float adjZ, maxZ;

	TraceDir = Normal(TraceDir);
	HitLocation = HitLocation + 0.5 * CollisionRadius * TraceDir;

	maxZ = Location.Z + (1.0 - 0.7 * DuckFraction) * CollisionHeight;
	if ( HitLocation.Z <= maxZ )
		return true;

	if ( TraceDir.Z >= 0 )
		return false;

	adjZ = (maxZ - HitLocation.Z)/TraceDir.Z;
	HitLocation.Z = maxZ;
	HitLocation.X = HitLocation.X + TraceDir.X * adjZ;
	HitLocation.Y = HitLocation.Y + TraceDir.Y * adjZ;

	if ( VSize((HitLocation - Location)*vect(1,1,0)) > CollisionRadius )
		return false;

	return true;
}

simulated function bool ClientAdjustHitLocation(out vector HitLocation, vector TraceDir)
{
	/**
	 * @Author: spect
	 * @Modified Date: 2020-02-22 02:08:45
	 * @Desc: Reduced the hitboxes slightly
	 * @Feedback: Positive
	 */

	local float adjZ, maxZ;
	local vector delta;

	maxZ = Location.Z + (1.0 - 0.7 * DuckFraction) * CollisionHeight; // default game is 0.25
	if ( HitLocation.Z <= maxZ )
		return true;

	if ( TraceDir.Z >= 0 )
		return false;

	TraceDir = Normal(TraceDir);
	adjZ = (maxZ - HitLocation.Z)/TraceDir.Z;
	HitLocation.Z = maxZ;
	HitLocation.X = HitLocation.X + TraceDir.X * adjZ;
	HitLocation.Y = HitLocation.Y + TraceDir.Y * adjZ;
	delta = (HitLocation - Location) * vect(1,1,0);
	if (delta dot delta > CollisionRadius * CollisionRadius)
		return false;
}

simulated function AddVelocity( vector NewVelocity )
{
	if (!bNewNet || Level.NetMode == NM_Client)
		Super.AddVelocity(NewVelocity);
	else if (Level.NetMode != NM_Client)
		ServerAddMomentum(NewVelocity);
}

simulated function ClientAddMomentum(vector Momentum, float TimeStamp, int Index) {
	local int Next;
	if (TimeStamp <= AddVelocityCalls[LastAddVelocityIndex].TimeStamp)
		return; // too old

	Next = (Index+1) & 0xF;
	if (((Next - LastAddVelocityAppliedIndex) & 0xF) > ((LastAddVelocityIndex - LastAddVelocityAppliedIndex) & 0xF))
		LastAddVelocityIndex = Next;

	AddVelocityCalls[Index].Momentum = Momentum;
	AddVelocityCalls[Index].TimeStamp = TimeStamp;
}

function ServerAddMomentum(vector Momentum) {
	local int Next;

	if (class'UTPure'.default.bEnableLoosePositionCheck) {
		if (Momentum == vect(0,0,0))
			return;

		Next = (LastAddVelocityIndex+1) & 0xF;
		if (Next == LastAddVelocityAppliedIndex)
			return; // full

		AddVelocityCalls[LastAddVelocityIndex].Momentum = Momentum;
		AddVelocityCalls[LastAddVelocityIndex].TimeStamp = Level.TimeSeconds + 0.5*Level.TimeDilation;
		ClientAddMomentum(Momentum, Level.TimeSeconds, LastAddVelocityIndex);

		LastAddVelocityIndex = Next;
	} else {
		Super.AddVelocity(Momentum);
	}
}

simulated function NN_Momentum( Vector momentum, name DamageType )
{
	local bool bPreventLockdown;		// Avoid the lockdown effect.

	if (DamageType == 'shot' || DamageType == 'zapped')
		bPreventLockdown = true;

	if (Base != None)
		momentum.Z = FMax(momentum.Z, 0.4 * VSize(momentum));

	if (Mass != 0)
		momentum = momentum/Mass;

	if (!bPreventLockdown)	// FIX BY LordHypnos, http://forums.prounreal.com/viewtopic.php?t=34676&postdays=0&postorder=asc&start=0
		AddVelocity( momentum );
}

function TakeDamage( int Damage, Pawn InstigatedBy, Vector HitLocation,
						Vector momentum, name damageType)
{
	local int actualDamage;
	local bool bAlreadyDead;
	local int ModifiedDamage1, ModifiedDamage2, RecentDamage;
	local Pawn P;
	local Inventory Inv;

	if ( Role < ROLE_Authority )
	{
		Log(Self@"client damage type"@damageType@"by"@InstigatedBy);
		return;
	}

	bAlreadyDead = (Health <= 0);

	if (Physics == PHYS_None)
		SetMovementPhysics();
	if ( InstigatedBy == self )
		momentum *= 0.6;
	if (Mass != 0)
		momentum = momentum/Mass;

	actualDamage = Level.Game.ReduceDamage(Damage, DamageType, self, InstigatedBy);
						// ReduceDamage handles HardCore mode (*1.5) and Damage Scaling (Amp, etc)
	ModifiedDamage1 = actualDamage;		// In team games it also handles team scaling.

	if ( bIsPlayer )
	{
		if (ReducedDamageType == 'All') //God mode
			actualDamage = 0;
		else if (Inventory != None) //then check if carrying armor
			actualDamage = Inventory.ReduceDamage(actualDamage, DamageType, HitLocation);
		else
			actualDamage = Damage;
	}
	else if ( (InstigatedBy != None) &&
				(InstigatedBy.IsA(Class.Name) || self.IsA(InstigatedBy.Class.Name)) )
		ActualDamage = ActualDamage * FMin(1 - ReducedDamagePct, 0.35);
	else if ( (ReducedDamageType == 'All') ||
		((ReducedDamageType != '') && (ReducedDamageType == damageType)) )
		actualDamage = float(actualDamage) * (1 - ReducedDamagePct);

	ModifiedDamage2 = actualDamage;		// This is post-armor and such.

	if ( Level.Game.DamageMutator != None )
		Level.Game.DamageMutator.MutatorTakeDamage( ActualDamage, Self, InstigatedBy, HitLocation, Momentum, DamageType );

	if (zzStatMut != None)
	{	// Damn epic. Damn Damn. Why is armor handled before mutator gets it? Instead of doing it simple, I now have
		// to do all this magic. :/
		// If epic hadn't done this mess, I could have done this entirely in a mutator. GG epic.
		// Also must limit damage incase player has Health < Damage
		ModifiedDamage1 -= (ModifiedDamage2 - actualDamage);
		zzStatMut.PlayerTakeDamage(Self, InstigatedBy, Min(Health, ModifiedDamage1), damageType);
	}

	if (InstigatedBy != Self && PlayerPawn(InstigatedBy) != None)
	{	// Send the hitsound local message.

		RecentDamage = 1;
		for ( Inv = InstigatedBy.Inventory; Inv != None; Inv = Inv.Inventory )
			if (Inv.IsA('UDamage'))
			{
				RecentDamage = 3;
				break;
			}
		RecentDamage = RecentDamage * 1.5 * Damage;

		PlayerPawn(InstigatedBy).ReceiveLocalizedMessage(Class'PureHitSound', RecentDamage, PlayerReplicationInfo, InstigatedBy.PlayerReplicationInfo);
		for (P = Level.PawnList; P != None; P = P.NextPawn)
		{
			if (P.IsA('bbCHSpectator') && bbCHSpectator(P).ViewTarget == InstigatedBy)
				bbCHSpectator(P).ReceiveLocalizedMessage(Class'PureHitSound', RecentDamage, PlayerReplicationInfo, InstigatedBy.PlayerReplicationInfo);
		}
	}

	ServerAddMomentum(momentum);
	Health -= actualDamage;

	if (CarriedDecoration != None)
		DropDecoration();
	if ( HitLocation == vect(0,0,0) )
		HitLocation = Location;
	if (Health > 0)
	{
		if ( (InstigatedBy != None) && (InstigatedBy != Self) )
			damageAttitudeTo(InstigatedBy);
		PlayHit(actualDamage, HitLocation, damageType, Momentum);
	}
	else if ( !bAlreadyDead )
	{
		NextState = '';
		PlayDeathHit(actualDamage, HitLocation, damageType, Momentum);
		if ( actualDamage > mass )
			Health = -1 * actualDamage;
		if ( (InstigatedBy != None) && (InstigatedBy != Self) )
			damageAttitudeTo(InstigatedBy);
		Died(InstigatedBy, damageType, HitLocation);
	}
	else
	{
		if ( bIsPlayer )
		{
			HidePlayer();
			GotoState('Dying');
		}
		else
			Destroy();
	}
	MakeNoise(1.0);
}

function GiveHealth( int Damage, bbPlayer InstigatedBy, Vector HitLocation,
						Vector momentum, name damageType)
{
	local int actualDamage;
	local bool bAlreadyDead;
	local int ModifiedDamage1, ModifiedDamage2, RecentDamage;
	local bool bPreventLockdown;		// Avoid the lockdown effect.
	local Pawn P;
	local Inventory Inv;

	if ( Role < ROLE_Authority )
	{
		Log(Self@"client damage type (GiveHealth)"@damageType@"by"@InstigatedBy);
		return;
	}

	if (InstigatedBy == Self || InstigatedBy.Health <= 0 || Health >= 199)
		return;

	if (DamageType == 'shot' || DamageType == 'zapped')
		bPreventLockdown = true;

	bAlreadyDead = (Health <= 0);

	if (Physics == PHYS_None)
		SetMovementPhysics();
	if (Physics == PHYS_Walking)
		momentum.Z = FMax(momentum.Z, 0.4 * VSize(momentum));
	if ( InstigatedBy == self )
		momentum *= 0.6;
	if (Mass != 0)
		momentum = momentum/Mass;

	actualDamage = Level.Game.ReduceDamage(Damage, DamageType, self, InstigatedBy);
						// ReduceDamage handles HardCore mode (*1.5) and Damage Scaling (Amp, etc)
	ModifiedDamage1 = actualDamage;		// In team games it also handles team scaling.

	if ( bIsPlayer )
	{
		if (ReducedDamageType == 'All') //God mode
			actualDamage = 0;
		else
			actualDamage = Damage;
	}

	ModifiedDamage2 = actualDamage;		// This is post-armor and such.

	if ( Level.Game.DamageMutator != None )
		Level.Game.DamageMutator.MutatorTakeDamage( ActualDamage, Self, InstigatedBy, HitLocation, Momentum, DamageType );

	if (zzStatMut != None)
	{	// Damn epic. Damn Damn. Why is armor handled before mutator gets it? Instead of doing it simple, I now have
		// to do all this magic. :/
		// If epic hadn't done this mess, I could have done this entirely in a mutator. GG epic.
		// Also must limit damage incase player has Health < Damage
		ModifiedDamage1 -= (ModifiedDamage2 - actualDamage);
		zzStatMut.PlayerTakeDamage(Self, InstigatedBy, Min(Health, ModifiedDamage1), damageType);
	}

	if (InstigatedBy != Self)
	{	// Send the hitsound local message.
		RecentDamage = 1;
		for ( Inv = InstigatedBy.Inventory; Inv != None; Inv = Inv.Inventory )
			if (Inv.IsA('UDamage'))
			{
				RecentDamage = 3;
				break;
			}
		RecentDamage = RecentDamage * 1.5 * Damage;

		InstigatedBy.ReceiveLocalizedMessage(Class'PureHitSound', RecentDamage, PlayerReplicationInfo, InstigatedBy.PlayerReplicationInfo);
		for (P = Level.PawnList; P != None; P = P.NextPawn)
		{
			if (P.IsA('bbCHSpectator') && bbCHSpectator(P).ViewTarget == InstigatedBy)
				bbCHSpectator(P).ReceiveLocalizedMessage(Class'PureHitSound', RecentDamage, PlayerReplicationInfo, InstigatedBy.PlayerReplicationInfo);
		}
	}

	if (!bPreventLockdown && InstigatedBy != self && (momentum dot momentum) > 0)	// FIX BY LordHypnos, http://forums.prounreal.com/viewtopic.php?t=34676&postdays=0&postorder=asc&start=0
	{
		if (bNewNet)
			AddVelocity( momentum );
		else
			AddVelocity( momentum );
	}
	if (actualDamage > InstigatedBy.Health)
		actualDamage = InstigatedBy.Health;
	if (Health + actualDamage > 199)
		actualDamage = 199 - Health;
	Health += actualDamage;
	InstigatedBy.Health -= actualDamage;
	if ( HitLocation == vect(0,0,0) )
		HitLocation = Location;
	if (InstigatedBy.Health > 0)
	{
	}
	else if ( !bAlreadyDead )
	{
		InstigatedBy.NextState = '';
		if ( actualDamage > InstigatedBy.mass )
			InstigatedBy.Health = -1 * actualDamage;
		InstigatedBy.Died(InstigatedBy, damageType, HitLocation);
	}
	else
	{
		if ( InstigatedBy.bIsPlayer )
		{
			InstigatedBy.HidePlayer();
			InstigatedBy.GotoState('Dying');
		}
		else
			InstigatedBy.Destroy();
	}
	MakeNoise(1.0);
}

function StealHealth( int Damage, bbPlayer InstigatedBy, Vector HitLocation,
						Vector momentum, name damageType)
{
	local int actualDamage;
	local bool bAlreadyDead;
	local int ModifiedDamage1, ModifiedDamage2, RecentDamage;
	local bool bPreventLockdown;		// Avoid the lockdown effect.
	local Pawn P;
	local Inventory Inv;

	if ( Role < ROLE_Authority )
	{
		Log(Self@"client damage type (StealHealth)"@damageType@"by"@InstigatedBy);
		return;
	}

	if (InstigatedBy == Self)
		return;

	if (DamageType == 'shot' || DamageType == 'zapped')
		bPreventLockdown = true;

	bAlreadyDead = (Health <= 0);

	if (Physics == PHYS_None)
		SetMovementPhysics();
	if (Physics == PHYS_Walking)
		momentum.Z = FMax(momentum.Z, 0.4 * VSize(momentum));
	if ( InstigatedBy == self )
		momentum *= 0.6;
	momentum = momentum/Mass;

	actualDamage = Level.Game.ReduceDamage(Damage, DamageType, self, InstigatedBy);
						// ReduceDamage handles HardCore mode (*1.5) and Damage Scaling (Amp, etc)
	ModifiedDamage1 = actualDamage;		// In team games it also handles team scaling.

	if ( bIsPlayer )
	{
		if (ReducedDamageType == 'All') //God mode
			actualDamage = 0;
		else if (Inventory != None) //then check if carrying armor
			actualDamage = Inventory.ReduceDamage(actualDamage, DamageType, HitLocation);
		else
			actualDamage = Damage;
	}
	else if ( (InstigatedBy != None) &&
				(InstigatedBy.IsA(Class.Name) || self.IsA(InstigatedBy.Class.Name)) )
		ActualDamage = ActualDamage * FMin(1 - ReducedDamagePct, 0.35);
	else if ( (ReducedDamageType == 'All') ||
		((ReducedDamageType != '') && (ReducedDamageType == damageType)) )
		actualDamage = float(actualDamage) * (1 - ReducedDamagePct);

	ModifiedDamage2 = actualDamage;		// This is post-armor and such.

	if ( Level.Game.DamageMutator != None )
		Level.Game.DamageMutator.MutatorTakeDamage( ActualDamage, Self, InstigatedBy, HitLocation, Momentum, DamageType );

	if (zzStatMut != None)
	{	// Damn epic. Damn Damn. Why is armor handled before mutator gets it? Instead of doing it simple, I now have
		// to do all this magic. :/
		// If epic hadn't done this mess, I could have done this entirely in a mutator. GG epic.
		// Also must limit damage incase player has Health < Damage
		ModifiedDamage1 -= (ModifiedDamage2 - actualDamage);
		zzStatMut.PlayerTakeDamage(Self, InstigatedBy, Min(Health, ModifiedDamage1), damageType);
	}

	if (InstigatedBy != Self)
	{	// Send the hitsound local message.
		RecentDamage = 1;
		for ( Inv = InstigatedBy.Inventory; Inv != None; Inv = Inv.Inventory )
			if (Inv.IsA('UDamage'))
			{
				RecentDamage = 3;
				break;
			}
		RecentDamage = RecentDamage * 1.5 * Damage;

		InstigatedBy.ReceiveLocalizedMessage(Class'PureHitSound', RecentDamage, PlayerReplicationInfo, InstigatedBy.PlayerReplicationInfo);
		for (P = Level.PawnList; P != None; P = P.NextPawn)
		{
			if (P.IsA('bbCHSpectator') && bbCHSpectator(P).ViewTarget == InstigatedBy)
				bbCHSpectator(P).ReceiveLocalizedMessage(Class'PureHitSound', RecentDamage, PlayerReplicationInfo, InstigatedBy.PlayerReplicationInfo);
		}
	}

	if (!bPreventLockdown && InstigatedBy != self && (momentum dot momentum) > 0)	// FIX BY LordHypnos, http://forums.prounreal.com/viewtopic.php?t=34676&postdays=0&postorder=asc&start=0
	{
		if (bNewNet)
			AddVelocity( momentum );
		else
			AddVelocity( momentum );
	}
	if (actualDamage > Health)
		actualDamage = Health;
	Health -= actualDamage;
	InstigatedBy.Health += actualDamage;
	if (InstigatedBy.Health > 199)
		InstigatedBy.Health = 199;
	if (CarriedDecoration != None)
		DropDecoration();
	if ( HitLocation == vect(0,0,0) )
		HitLocation = Location;
	if (Health > 0)
	{
		if ( (InstigatedBy != None) && (InstigatedBy != Self) )
			damageAttitudeTo(InstigatedBy);
		PlayHit(actualDamage, HitLocation, damageType, Momentum);
	}
	else if ( !bAlreadyDead )
	{
		NextState = '';
		PlayDeathHit(actualDamage, HitLocation, damageType, Momentum);
		if ( actualDamage > mass )
			Health = -1 * actualDamage;
		if ( (InstigatedBy != None) && (InstigatedBy != Self) )
			damageAttitudeTo(InstigatedBy);
		Died(InstigatedBy, damageType, HitLocation);
	}
	else
	{
		if ( bIsPlayer )
		{
			HidePlayer();
			GotoState('Dying');
		}
		else
			Destroy();
	}
	MakeNoise(1.0);
}

function bool Gibbed(name damageType)
{
	if ( (damageType == 'decapitated') || (damageType == 'shot') )
		return false;
	if ( (Health < -80) || ((Health < -40) && (FRand() < 0.6)) || (damageType == 'Suicided') )
		return true;
	return false;
}

function Died(pawn Killer, name damageType, vector HitLocation)
{
	local pawn OtherPawn;
	local actor A;

	// mutator hook to prevent deaths
	// WARNING - don't prevent bot suicides - they suicide when really needed
	if ( Level.Game.BaseMutator.PreventDeath(self, Killer, damageType, HitLocation) )
	{
		Health = max(Health, 1); //mutator should set this higher
		return;
	}
	if ( bDeleteMe )
		return; //already destroyed
	StopZoom();
	Health = Min(0, Health);

	for ( OtherPawn=Level.PawnList; OtherPawn!=None; OtherPawn=OtherPawn.nextPawn )
		OtherPawn.Killed(Killer, self, damageType);
	if ( CarriedDecoration != None )
		DropDecoration();
	level.game.Killed(Killer, self, damageType);
	if (zzStatMut != None)
		zzStatMut.PlayerKill(Killer, Self);
	if( Event != '' )
		foreach AllActors( class 'Actor', A, Event )
			A.Trigger( Self, Killer );
	if (Weapon.IsA('TournamentWeapon'))
		TournamentWeapon(Weapon).bCanClientFire = false;
	Velocity.Z *= 1.3;
	if ( Gibbed(damageType) )
	{
		SpawnGibbedCarcass();
		if ( bIsPlayer )
			HidePlayer();
		else
			Destroy();
	}
	PlayDying(DamageType, HitLocation);
	if ( Level.Game.bGameEnded )
		return;

	if ( RemoteRole == ROLE_AutonomousProxy )
		ClientDying(DamageType, HitLocation);
	LastKiller = Killer;
	GotoState('Dying');
}

event ServerTick(float DeltaTime) {
	AverageServerDeltaTime = (AverageServerDeltaTime*99 + DeltaTime) * 0.01;
	IGPlus_ProcessRemoteMovement();
	xxRememberPosition();

	if (DelayedNavPoint != none) {
		if (DelayedNavPoint.Class.Name == 'swJumpPad')
			ReplicateSwJumpPad(Teleporter(DelayedNavPoint));

		DelayedNavPoint = DelayedNavPoint.NextNavigationPoint;
	}

	if (bIsCrouching) {
		DuckFraction = FClamp(DuckFraction + DeltaTime/DuckTransitionTime, 0.0, 1.0);
	} else {
		DuckFraction = FClamp(DuckFraction - DeltaTime/DuckTransitionTime, 0.0, 1.0);
	}
}

/** STATES
 * @Author: spect
 * @Date: 2020-02-19 02:13:05
 * @Desc: PlayerPawn States (This is where movement, compensation and position adjustment is controlled)
 */

state FeigningDeath
{
	function xxServerMove
	(
		float TimeStamp,
		float MoveDeltaTime,
		float AccelX,
		float AccelY,
		float AccelZ,
		float ClientLocX,
		float ClientLocY,
		float ClientLocZ,
		vector ClientVel,
		int MiscData,
		int MiscData2,
		int View,
		Actor ClientBase,
		optional int OldMoveData1,
		optional int OldMoveData2
	)
	{
		Global.xxServerMove(
			TimeStamp,
			MoveDeltaTime,
			AccelX,
			AccelY,
			AccelZ,
			ClientLocX,
			ClientLocY,
			ClientLocZ,
			ClientVel,
			MiscData,
			MiscData2,
			((Rotation.Pitch & 0xFFFF) << 16) | (Rotation.Yaw & 0xFFFF),
			ClientBase,
			OldMoveData1,
			OldMoveData2);
	}

	function PlayerMove( float DeltaTime)
	{
		local rotator currentRot;
		local vector NewAccel;

		aLookup  *= 0.24;
		aTurn    *= 0.24;

		// Update acceleration.
		if ( !FeignAnimCheck()  && (aForward != 0) || (aStrafe != 0) )
			NewAccel = vect(0,0,1);
		else
			NewAccel = vect(0,0,0);

		// Update view rotation.
		currentRot = Rotation;
		xxUpdateRotation(DeltaTime, 1);
		SetRotation(currentRot);

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			xxReplicateMove(DeltaTime, NewAccel, DODGE_None, Rot(0,0,0));
		else
			ProcessMove(DeltaTime, NewAccel, DODGE_None, Rot(0,0,0));
		bPressedJump = false;
	}

	event PlayerTick( float DeltaTime )
	{
		xxPlayerTickEvents(DeltaTime);
		zzTick = DeltaTime;
		Super.PlayerTick(DeltaTime);
	}

	function BeginState()
	{
		Super.BeginState();
		// Stop weapon firing
		//UsAaR33: prevent weapon from firing (brought on by missing bchangedweapon checks)
		if (zzbNoMultiWeapon && Weapon != none && (baltfire>0||bfire>0) )
		{ //could only be true on server
			baltfire=0;
			bfire=0;
			//additional hacks to stop weapons:
			if (Weapon.Isa('Minigun2'))
				Minigun2(Weapon).bFiredShot=true;
			if (Weapon.IsA('Chainsaw'))   //Saw uses sleep delays in states.
				Weapon.Finish();
			Weapon.Tick(0);
			Weapon.AnimEnd();
		}
	}

	function EndState()
	{
		zzbForceUpdate = true;
		zzIgnoreUpdateUntil = 0;
		Super.EndState();
	}
}
//==========================================

state PlayerSwimming
{
	function ProcessMove(float DeltaTime, vector NewAccel, eDodgeDir DodgeMove, rotator DeltaRot)
	{
		local vector X,Y,Z, Temp;

		GetAxes(ViewRotation,X,Y,Z);
		Acceleration = NewAccel;

		SwimAnimUpdate( (X Dot Acceleration) <= 0 );

		bUpAndOut = ((X Dot Acceleration) > 0) && ((Acceleration.Z > 0) || (ViewRotation.Pitch > 2048));

		if ( bUpAndOut && !Region.Zone.bWaterZone && CheckWaterJump(Temp) ) //check for waterjump
		{
			velocity.Z = 220 + 2 * CollisionRadius; //set here so physics uses this for remainder of tick
			PlayDuck();
			GotoState('PlayerWalking');
		}
	}

	event PlayerTick( float DeltaTime )
	{
		xxPlayerTickEvents(DeltaTime);
		zzTick = DeltaTime;
		Super.PlayerTick(DeltaTime);
	}

	function PlayerMove(float DeltaTime)
	{
		local rotator oldRotation;
		local vector X,Y,Z, NewAccel;
		local float Speed2D;

		GetAxes(ViewRotation,X,Y,Z);

		aForward *= 0.2;
		aStrafe  *= 0.1;
		aLookup  *= 0.24;
		aTurn    *= 0.24;
		aUp		 *= 0.1;

		NewAccel = aForward*X + aStrafe*Y + aUp*vect(0,0,1);

		//add bobbing when swimming
		if ( !bShowMenu )
		{
			Speed2D = Sqrt(Velocity.X * Velocity.X + Velocity.Y * Velocity.Y);
			WalkBob = Y * Bob *  0.5 * Speed2D * sin(4.0 * Level.TimeSeconds);
			WalkBob.Z = Bob * 1.5 * Speed2D * sin(8.0 * Level.TimeSeconds);
		}

		// Update rotation.
		oldRotation = Rotation;
		xxUpdateRotation(DeltaTime, 2);

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			xxReplicateMove(DeltaTime, NewAccel, DODGE_None, OldRotation - Rotation);
		else
			ProcessMove(DeltaTime, NewAccel, DODGE_None, OldRotation - Rotation);
		bPressedJump = false;
	}

	event ServerTick(float DeltaTime) {
		IGPlus_ProcessRemoteMovement();
		WarpCompensation(DeltaTime);
		global.ServerTick(DeltaTime);
	}

	event UpdateEyeHeight(float DeltaTime)
	{
		Super.UpdateEyeHeight(DeltaTime);
		xxCheckFOV();
	}

	function Timer()
	{
		if ( !Region.Zone.bWaterZone && (Role == ROLE_Authority) )
		{
			GotoState('PlayerWalking');
			AnimEnd();
		}

		Disable('Timer');
	}

	function BeginState()
	{
		Disable('Timer');
		if ( !IsAnimating() )
			TweenToWaiting(0.3);
	}
}

state PlayerFlying
{
	event PlayerTick( float DeltaTime )
	{
		xxPlayerTickEvents(DeltaTime);
		zzTick = DeltaTime;
		Super.PlayerTick(DeltaTime);
	}

	function PlayerMove(float DeltaTime)
	{
		local vector X,Y,Z;

		GetAxes(Rotation,X,Y,Z);

		aForward *= 0.2;
		aStrafe  *= 0.2;
		aLookup  *= 0.24;
		aTurn    *= 0.24;

		Acceleration = aForward*X + aStrafe*Y;
		// Update rotation.
		xxUpdateRotation(DeltaTime, 2);

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			xxReplicateMove(DeltaTime, Acceleration, DODGE_None, rot(0,0,0));
		else
			ProcessMove(DeltaTime, Acceleration, DODGE_None, rot(0,0,0));
	}
}

// ==================================================================

state CheatFlying
{
	event PlayerTick( float DeltaTime )
	{
		xxPlayerTickEvents(DeltaTime);
		zzTick = DeltaTime;
		Super.PlayerTick(DeltaTime);
	}

	function PlayerMove(float DeltaTime)
	{
		local vector X,Y,Z;

		GetAxes(ViewRotation,X,Y,Z);

		aForward *= 0.1;
		aStrafe  *= 0.1;
		aLookup  *= 0.24;
		aTurn    *= 0.24;
		aUp		 *= 0.1;

		Acceleration = aForward*X + aStrafe*Y + aUp*vect(0,0,1);

		xxUpdateRotation(DeltaTime, 1);

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			xxReplicateMove(DeltaTime, Acceleration, DODGE_None, rot(0,0,0));
		else
			ProcessMove(DeltaTime, Acceleration, DODGE_None, rot(0,0,0));
	}
}

state PlayerWalking
{
ignores SeePlayer, HearNoise, Bump;
	event Landed(vector HitNormal)
	{
		local float Vel;

		Global.Landed(HitNormal);

		if (bJumpingPreservesMomentum == false) {
			Velocity *= vect(1,1,0);

			if (bDodging)
				Vel = VSize(Velocity) * DodgeEndVelocity;
			else
				Vel = VSize(Velocity) * JumpEndVelocity;

			Velocity = (Normal(Velocity) + Normal(Acceleration)) * 0.5 * HitNormal.Z * FMin(Vel, GroundSpeed);
		} else if (bDodging) {
			Velocity *= DodgeEndVelocity;
		} else {
			Velocity *= JumpEndVelocity;
		}

		if (bDodging || DodgeDir == DODGE_Done) {
			DodgeDir = DODGE_Done;
			DodgeClickTimer = FMin(DodgeClickTimer, 0.0);
			bDodging = false;
		} else {
			DodgeDir = DODGE_None;
		}

		MultiDodgesRemaining = bbPlayerReplicationInfo(PlayerReplicationInfo).MaxMultiDodges;

		if (Settings.bDebugMovement && Level.NetMode == NM_Client)
			ClientDebugMessage("Landed");
	}

	simulated function Dodge(eDodgeDir DodgeMove)
	{
		local vector X,Y,Z;
		local vector HitLocation;
		local vector HitNormal;
		local Actor  HitActor;
		local vector TraceStart;
		local vector TraceEnd;
		local float VelocityZ;
		local float DodgeXY;
		local float DodgeZ;

		if ( bIsCrouching || (Physics != PHYS_Walking && Physics != PHYS_Falling) )
			return;
		if (Physics == PHYS_Falling && bCanWallDodge == false)
			return;

		GetAxes(Rotation.Yaw*rot(0,1,0),X,Y,Z);

		if (Physics == PHYS_Falling) {
			if (DodgeMove == DODGE_Forward)
				TraceEnd = -X;
			else if (DodgeMove == DODGE_Back)
				TraceEnd = X;
			else if (DodgeMove == DODGE_Left)
				TraceEnd = -Y;
			else if (DodgeMove == DODGE_Right)
				TraceEnd = Y;
			TraceStart = Location - CollisionHeight*vect(0,0,1) + TraceEnd*CollisionRadius;
			TraceEnd = TraceStart + TraceEnd*32.0;
			HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, false, vect(1,1,1));
			if ((HitActor == none) || (HitActor != Level && Mover(HitActor) == none))
				return;

			TakeFallingDamage();
		}

		if (bDodging) {
			DodgeXY = SecondaryDodgeSpeedXY;
			DodgeZ = SecondaryDodgeSpeedZ;
		} else {
			DodgeXY = DodgeSpeedXY;
			DodgeZ = DodgeSpeedZ;
		}

		if (bDodgePreserveZMomentum) {
			VelocityZ = Velocity.Z;
			if (Base != none)
				VelocityZ += Base.Velocity.Z;
		}

		if (DodgeMove == DODGE_Forward)
			Velocity = DodgeXY*X + (Velocity Dot Y)*Y;
		else if (DodgeMove == DODGE_Back)
			Velocity = -DodgeXY*X + (Velocity Dot Y)*Y;
		else if (DodgeMove == DODGE_Left)
			Velocity = DodgeXY*Y + (Velocity Dot X)*X;
		else if (DodgeMove == DODGE_Right)
			Velocity = -DodgeXY*Y + (Velocity Dot X)*X;

		Velocity.Z = FMax(DodgeZ, VelocityZ + DodgeZ);
		PlayOwnedSound(JumpSound, SLOT_Talk, 1.0, bUpdating, 800, 1.0 );
		PlayDodge(DodgeMove);
		DodgeDir = DODGE_Active;
		bDodging = true;
		SetPhysics(PHYS_Falling);
		if (Settings.bDebugMovement && Level.NetMode == NM_Client)
			ClientDebugMessage("Dodged"@DodgeMove);
	}

	function PlayerMove( float DeltaTime )
	{
		local vector X,Y,Z, NewAccel;
		local EDodgeDir OldDodge;
		local eDodgeDir DodgeMove;
		local rotator OldRotation;
		local float Speed2D;
		local bool	bSaveJump;
		local name AnimGroupName;
		local float Now;

		if (Mesh == None)
		{
			SetMesh();
			return;		// WHY???
		}

		GetAxes(Rotation,X,Y,Z);

		aForward *= 0.4;
		aStrafe  *= 0.4;
		aLookup  *= 0.24;
		aTurn    *= 0.24;

		// Update acceleration.
		NewAccel = aForward*X + aStrafe*Y;
		NewAccel.Z = 0;
		// Check for Dodge move
		if ( DodgeDir == DODGE_Active )
			DodgeMove = DODGE_Active;
		else
			DodgeMove = DODGE_None;
		if (DodgeClickTime > 0.0)
		{
			if ( DodgeDir < DODGE_Active )
			{
				Now = Level.TimeSeconds;
				OldDodge = DodgeDir;
				DodgeDir = DODGE_None;

				if (bEdgeForward && bWasForward)
				{
					if (Now - LastTimeForward > Settings.MinDodgeClickTime) {
						DodgeDir = DODGE_Forward;
						LastTimeForward = Now;
					}
				}
				else if (bEdgeBack && bWasBack)
				{
					if (Now - LastTimeBack > Settings.MinDodgeClickTime) {
						DodgeDir = DODGE_Back;
						LastTimeBack = Now;
					}
				}
				else if (bEdgeLeft && bWasLeft)
				{
					if (Now - LastTimeLeft > Settings.MinDodgeClickTime) {
						DodgeDir = DODGE_Left;
						LastTimeLeft = Now;
					}
				}
				else if (bEdgeRight && bWasRight)
				{
					if (Now - LastTimeRight > Settings.MinDodgeClickTime) {
						DodgeDir = DODGE_Right;
						LastTimeRight = Now;
					}
				}

				if ( DodgeDir == DODGE_None)
					DodgeDir = OldDodge;
				else if ( DodgeDir != OldDodge )
					DodgeClickTimer = DodgeClickTime + 0.5 * DeltaTime;
				else
					DodgeMove = DodgeDir;
			}

			if ((DodgeDir != DODGE_None) && (DodgeDir < DODGE_Active))
			{
				DodgeClickTimer -= DeltaTime;
				if (DodgeClickTimer < 0)
				{
					DodgeDir = DODGE_None;
					DodgeClickTimer = DodgeClickTime;
				}
			}
		}

		if (bEnableSingleButtonDodge && bPressedDodge && DodgeDir < DODGE_Active && DodgeMove == DODGE_None) {
			if (aStrafe > 1)
				DodgeMove = DODGE_Left;
			else if (aStrafe < -1)
				DodgeMove = DODGE_Right;
			else if (aForward > 1)
				DodgeMove = DODGE_Forward;
			else if (aForward < -1)
				DodgeMove = DODGE_Back;
		}

		if (DodgeDir == DODGE_Done || (bDodging && (Base != None || Physics == PHYS_Walking)))
		{
			DodgeClickTimer = FMin(-DeltaTime, DodgeClickTimer - DeltaTime);
			if (DodgeClickTimer < -0.35)
			{
				bDodging = false;
				DodgeDir = DODGE_None;
				DodgeClickTimer = DodgeClickTime;
				MultiDodgesRemaining = bbPlayerReplicationInfo(PlayerReplicationInfo).MaxMultiDodges;
			}
		}

		// Fix by DB
		if (AnimSequence != '')
			AnimGroupName = GetAnimGroup(AnimSequence);

		if ( (Physics == PHYS_Walking) && (AnimGroupName != 'Dodge') )
		{
			//if walking, look up/down stairs - unless player is rotating view
			if ( !bKeyboardLook && (bLook == 0) )
			{
				if ( bLookUpStairs )
					ViewRotation.Pitch = FindStairRotation(deltaTime);
				else if ( bCenterView )
				{
					ViewRotation.Pitch = ViewRotation.Pitch & 65535;
					if (ViewRotation.Pitch > 32768)
						ViewRotation.Pitch -= 65536;
					ViewRotation.Pitch = ViewRotation.Pitch * (1 - 12 * FMin(0.0833, deltaTime));
					if ( Abs(ViewRotation.Pitch) < 1000 )
						ViewRotation.Pitch = 0;
				}
			}

			Speed2D = Sqrt(Velocity.X * Velocity.X + Velocity.Y * Velocity.Y);
			//add bobbing when walking
			if ( !bShowMenu )
				CheckBob(DeltaTime, Speed2D, Y);
		}
		else if ( !bShowMenu )
		{
			BobTime = 0;
			WalkBob = WalkBob * (1 - FMin(1, 8 * deltatime));
		}

		// Update rotation.
		OldRotation = Rotation;
		xxUpdateRotation(DeltaTime, 1);

		if ( bPressedJump && (AnimGroupName == 'Dodge') )
		{
			bSaveJump = true;
			bPressedJump = false;
		}
		else
			bSaveJump = false;

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			xxReplicateMove(DeltaTime, NewAccel, DodgeMove, OldRotation - Rotation);
		else
			ProcessMove(DeltaTime, NewAccel, DodgeMove, OldRotation - Rotation);
		bPressedJump = bSaveJump;
	}

	event ServerTick(float DeltaTime) {
		IGPlus_ProcessRemoteMovement();
		WarpCompensation(DeltaTime);
		global.ServerTick(DeltaTime);
	}

	event PlayerTick( float DeltaTime )
	{
		xxPlayerTickEvents(DeltaTime);
		zzTick = DeltaTime;
		Super.PlayerTick(DeltaTime);

		if (bCanWallDodge && DodgeDir == DODGE_Active && MultiDodgesRemaining > 0) {
			MultiDodgesRemaining -= 1;
			DodgeDir = DODGE_None;
		}
	}

	function BeginState()
	{
		if ( Mesh == None )
			SetMesh();
		WalkBob = vect(0,0,0);
		DodgeDir = DODGE_None;
		bIsCrouching = false;
		bIsTurning = false;
		bPressedJump = false;
		bIsAlive = true;
		bExtrapolatedLastUpdate = false;
		if (Physics != PHYS_Falling) SetPhysics(PHYS_Walking);
		if ( !IsAnimating() )
			PlayWaiting();
	}

	function EndState()
	{
		WalkBob = vect(0,0,0);
		bIsCrouching = false;
	}
}

//==========================================

function bool FeignAnimCheck() //for VA compatibility
{
	return IsAnimating();
}

// ==============================================
state PlayerWaiting
{
	event PlayerTick( float DeltaTime )
	{
		xxPlayerTickEvents(DeltaTime);
		zzTick = DeltaTime;
		Super.PlayerTick(DeltaTime);
	}

	function PlayerMove(float DeltaTime)
	{
		local vector X,Y,Z;

		GetAxes(ViewRotation,X,Y,Z);

		aForward *= 0.12; // 0.1
		aStrafe  *= 0.12;
		aLookup  *= 0.24;
		aTurn    *= 0.24;
		aUp		 *= 0.12;

		Acceleration = aForward*X + aStrafe*Y + aUp*vect(0,0,1);

		xxUpdateRotation(DeltaTime, 1);

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			xxReplicateMove(DeltaTime, Acceleration, DODGE_None, rot(0,0,0));
		else
			ProcessMove(DeltaTime, Acceleration, DODGE_None, rot(0,0,0));
	}

	exec function Fire(optional float F)
	{
		if (!bIsFinishedLoading)
			return;
		xxServerSetReadyToPlay();
		bReadyToPlay = Settings.bAutoReady;
	}

	exec function AltFire(optional float F)
	{
		Fire(F);
	}

}

/******************************************
 *				Animations                *
 ******************************************/

simulated function PlayTurning()
{
	BaseEyeHeight = Default.BaseEyeHeight;
	if ( (Weapon == None) || (Weapon.Mass < 20) )
		PlayAnim('TurnSM', 0.3, 0.055);
	else
		PlayAnim('TurnLG', 0.3, 0.055);
}

simulated function TweenToWalking(float tweentime)
{
	BaseEyeHeight = Default.BaseEyeHeight;
	if (Weapon == None)
		LoopAnim('Walk', 1.15, 0.001);
	else if ( Weapon.bPointing || (CarriedDecoration != None) )
	{
		if (Weapon.Mass < 20)
			LoopAnim('WalkSMFR', 1.15, 0.001);
		else
			LoopAnim('WalkLGFR', 1.15, 0.001);
	}
	else
	{
		if (Weapon.Mass < 20)
			LoopAnim('WalkSM', 1.15, 0.001);
		else
			LoopAnim('WalkLG', 1.15, 0.001);
	}
}

simulated function PlayWalking()
{
	BaseEyeHeight = Default.BaseEyeHeight;
	if (Weapon == None)
		LoopAnim('Walk', 1.3, 0.055);
	else if ( Weapon.bPointing || (CarriedDecoration != None) )
	{
		if (Weapon.Mass < 20)
			LoopAnim('WalkSMFR', 1.15, 0.055);
		else
			LoopAnim('WalkLGFR', 1.15, 0.055);
	}
	else
	{
		if (Weapon.Mass < 20)
			LoopAnim('WalkSM', 1.15, 0.055);
		else
			LoopAnim('WalkLG', 1.15, 0.055);
	}
}

simulated function PlayerPawn GetLocalPlayer() {
	local PlayerPawn P;

	if (bDeterminedLocalPlayer) return LocalPlayer;

	foreach AllActors(class'PlayerPawn', P) {
		if (Viewport(P.Player) != none) {
			LocalPlayer = P;
			break;
		}
	}
	bDeterminedLocalPlayer = true;
	return LocalPlayer;
}

simulated function PlayDodge(eDodgeDir DodgeMove)
{
	if ( DodgeMove == DODGE_Left )
		TweenAnim('DodgeL', 0.1);
	else if (DodgeMove == DODGE_Right )
		TweenAnim('DodgeR', 0.1);
	else if (DodgeMove == DODGE_Back )
		TweenAnim('DodgeB', 0.1);
	else if (bUseFlipAnimation == false)
		TweenAnim('DodgeF', 0.1);
	else
		PlayAnim('Flip', 1.35 * FMax(0.35, Region.Zone.ZoneGravity.Z/Region.Zone.Default.ZoneGravity.Z), 0.065);
}

simulated function TweenToRunning(float tweentime)
{
	local vector X,Y,Z, Dir;

	BaseEyeHeight = Default.BaseEyeHeight;
	if (bIsWalking)
	{
		TweenToWalking(0); // 0? yeah, it doesn't matter, check above
		return;
	}

	GetAxes(Rotation, X,Y,Z);
	Dir = Normal(Acceleration);
	if ( (Dir Dot X < 0.75) && (Dir != vect(0,0,0)) )
	{
		// strafing or backing up
		if ( Dir Dot X < -0.75 )
			PlayAnim('BackRun', 1.1, 0.055);
		else if ( Dir Dot Y > 0 )
			PlayAnim('StrafeR', 1.1, 0.055);
		else
			PlayAnim('StrafeL', 1.1, 0.055);
	}
	else if (Weapon == None)
		PlayAnim('RunSM', 1.1, 0.055);
	else if ( Weapon.bPointing )
	{
		if (Weapon.Mass < 20)
			PlayAnim('RunSMFR', 1.1, 0.055);
		else
			PlayAnim('RunLGFR', 1.1, 0.055);
	}
	else
	{
		if (Weapon.Mass < 20)
			PlayAnim('RunSM', 1.1, 0.055);
		else
			PlayAnim('RunLG', 1.1, 0.055);
	}
}

simulated function PlayRunning()
{
	local vector X,Y,Z, Dir;

	BaseEyeHeight = Default.BaseEyeHeight;

	// determine facing direction
	GetAxes(Rotation, X,Y,Z);
	Dir = Normal(Acceleration);
	if ( (Dir Dot X < 0.75) && (Dir != vect(0,0,0)) )
	{
		// strafing or backing up
		if ( Dir Dot X < -0.75 )
			LoopAnim('BackRun', 1.1);
		else if ( Dir Dot Y > 0 )
			LoopAnim('StrafeR', 1.1);
		else
			LoopAnim('StrafeL', 1.1);
	}
	else if (Weapon == None)
		LoopAnim('RunSM', 1.1);
	else if ( Weapon.bPointing )
	{
		if (Weapon.Mass < 20)
			LoopAnim('RunSMFR', 1.1);
		else
			LoopAnim('RunLGFR', 1.1);
	}
	else
	{
		if (Weapon.Mass < 20)
			LoopAnim('RunSM', 1.1);
		else
			LoopAnim('RunLG', 1.1);
	}
}

function xxServerSetReadyToPlay()
{
	if (zzUTPure.zzDMP == None)
		return;

	if (zzUTPure.zzDMP.bTournament && zzUTPure.bWarmup && zzUTPure.zzDMP.bRequireReady && (zzUTPure.zzDMP.CountDown >= 10))
	{
		zzbForceUpdate = true;
		zzIgnoreUpdateUntil = 0;

		PlayerRestartState = 'PlayerWarmup';
		GotoState('PlayerWarmup');
		zzUTPure.zzDMP.ReStartPlayer(Self);
		zzUTPure.zzbWarmupPlayers = True;
	}
}

function GiveMeWeapons()
{
	local Inventory Inv;
	local Weapon w, Best;
	local float Current, Highest;
	local DeathMatchPlus DMP;
	local string WeaponList[32], s;
	local int WeapCnt, x;				// Grr, wish UT had dyn arrays :P
	local bool bAlready;
	local bool bSavedRequireReady;

	DMP = DeathMatchPlus(Level.Game);
	if (DMP == None) return;			// If DMP is none, I would never be here, so darnit really? :P

	bSavedRequireReady = DMP.bRequireReady;
	DMP.bRequireReady = false;
	Level.Game.AddDefaultInventory(self);
	DMP.bRequireReady = bSavedRequireReady;

	ForEach AllActors(Class'Weapon', w)
	{	// Find the rest of the weapons around the map.
		s = string(w.Class);
		bAlready = False;
		for (x = 0; x < WeapCnt; x++)
		{
			if (WeaponList[x] ~= s)
			{
				bAlready = True;
				break;
			}
		}
		if (!bAlready)
			WeaponList[WeapCnt++] = s;
	}

	for (x = 0; x < WeapCnt; x++)
	{	// Distribute weapons.
		DMP.GiveWeapon(Self, WeaponList[x]);
	}

	for ( Inv = Inventory; Inv != None; Inv = Inv.Inventory )
	{	// This gives max ammo.
		w = Weapon(Inv);
		if (w != None)
		{
			w.WeaponSet(Self);
			if ( w.AmmoType != None )
			{
				w.AmmoType.AmmoAmount = w.AmmoType.MaxAmmo;
				if (w.AmmoType != None && w.AmmoType.AmmoAmount <= 0)
					continue;
				w.SetSwitchPriority(self);
				Current = w.AutoSwitchPriority;
				if ( Current > Highest )
				{
					Best = w;
					Highest = Current;
				}
			}
		}
	}

	if (!bNewNet)
		SwitchToBestWeapon();
	else if (Best != None)
	{
		PendingWeapon = Best;
		ChangedWeapon();
	}
}

state PlayerWarmup extends PlayerWalking
{
	function BeginState()
	{
		local float NewJumpZ;

		if (zzUTPure != none && zzUTPure.zzDMP != none && zzUTPure.zzDMP.Role == ROLE_Authority) {
			NewJumpZ = Default.JumpZ * zzUTPure.zzDMP.PlayerJumpZScaling();
			if (NewJumpZ > 0)
				JumpZ = NewJumpZ;
		}

		zzbIsWarmingUp = true;
		GiveMeWeapons();
		Super.BeginState();
	}

	exec function SetProgressMessage( string S, int Index )
	{	// Bugly hack. But why not :/ It's only used during warmup anyway.
		// This also means that admins may not use say # >:|
		if (S == Class'DeathMatchPlus'.Default.ReadyMessage || S == Class'TeamGamePlus'.Default.TeamChangeMessage)
		{
			ClearProgressMessages();
			return;
		}
		Super.SetProgressMessage( S, Index );
	}

	function TakeDamage( int Damage, Pawn InstigatedBy, Vector HitLocation,
							Vector momentum, name damageType)
	{
		Global.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
	}

}



// =======================
state PlayerSpectating
{
	event PlayerTick( float DeltaTime )
	{
		xxPlayerTickEvents(DeltaTime);
		zzTick = DeltaTime;
		Super.PlayerTick(DeltaTime);
	}

	function PlayerMove(float DeltaTime)
	{
		local vector X,Y,Z;

		GetAxes(ViewRotation,X,Y,Z);

		aForward *= 0.1;
		aStrafe  *= 0.1;
		aLookup  *= 0.24;
		aTurn    *= 0.24;
		aUp		 *= 0.1;

		Acceleration = aForward*X + aStrafe*Y + aUp*vect(0,0,1);

		xxUpdateRotation(DeltaTime, 1);

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			xxReplicateMove(DeltaTime, Acceleration, DODGE_None, rot(0,0,0));
		else
			ProcessMove(DeltaTime, Acceleration, DODGE_None, rot(0,0,0));
	}

}
//===============================================================================
state PlayerWaking
{

	event PlayerTick( float DeltaTime )
	{
		xxPlayerTickEvents(DeltaTime);
		zzTick = DeltaTime;
		Super.PlayerTick(DeltaTime);
	}

	function PlayerMove(Float DeltaTime)
	{
		ViewFlash(deltaTime * 0.5);
		if ( TimerRate == 0 )
		{
			ViewRotation.Pitch -= DeltaTime * 12000;
			if ( ViewRotation.Pitch < 0 )
			{
				ViewRotation.Pitch = 0;
				GotoState('PlayerWalking');
			}
		}

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			xxReplicateMove(DeltaTime, vect(0,0,0), DODGE_None, rot(0,0,0));
		else
			ProcessMove(DeltaTime, vect(0,0,0), DODGE_None, rot(0,0,0));
	}

	function BeginState()
	{
		zzbForceUpdate = false;
		if ( bWokeUp )
		{
			ViewRotation.Pitch = 0;
			SetTimer(0, false);
			return;
		}
		BaseEyeHeight = 0;
		EyeHeight = 0;
		SetTimer(3.0, false);
		bWokeUp = true;
	}
}

state Dying
{
	function ServerReStartPlayer()
	{
		if ( Level.NetMode == NM_Client || bFrozen && (TimerRate>0.0) )
			return;

		if ( Level.Game.RestartPlayer(self) )
		{
			ServerTimeStamp = 0;
			TimeMargin = 0;
			Enemy = None;
			Level.Game.StartPlayer(self);
			if ( Mesh != None )
				PlayWaiting();

			xxClientReStart(Physics, Location, Rotation);

			ChangedWeapon();
			zzSpawnedTime = Level.TimeSeconds;
		}
		else
		{
			log("Restartplayer failed");
		}

	}

	event ServerTick(float DeltaTime) {
		RealTimeDead += (DeltaTime / Level.TimeDilation); // counting real time, undo dilation
		if (Level.Pauser == "")
			TimeDead += DeltaTime;

		global.ServerTick(DeltaTime);

		if (RealTimeDead > 2*class'UTPure'.default.MaxTradeTimeMargin && Weapon != none)
			Level.Game.DiscardInventory(self);
	}

	event PlayerTick( float DeltaTime )
	{
		local rotator DeltaRotation;

		RealTimeDead += (DeltaTime / Level.TimeDilation); // counting real time, undo dilation
		if (Level.Pauser == "")
			TimeDead += DeltaTime;

		xxPlayerTickEvents(DeltaTime);
		zzTick = DeltaTime;
		Super.PlayerTick(DeltaTime);

		if ((Settings.bEnableKillCam && LastKiller != none) &&
			(TimeDead >= FMax(KillCamDelay, Settings.KillCamMinDelay) && TimeDead < KillCamDelay + KillCamDuration) &&
			bKillCamWanted
		) {
			if (LastKiller != self) {
				if (FastTrace(LastKiller.Location, Location))
					KillCamTargetRotation = rotator(LastKiller.Location - Location);
				DeltaRotation = Normalize(KillCamTargetRotation - ViewRotation);
				ViewRotation = Normalize(ViewRotation + DeltaRotation * (1 - Exp(-3.0 * DeltaTime)));
			}
		}
	}

	simulated function BeginState() {
		local Carcass C;
		local int i;

		bJumpStatus = false;
		bIsAlive = false;
		zzIgnoreUpdateUntil = 0;
		if (zzClientTTarget != None)
			zzClientTTarget.Destroy();

		// BEGIN PlayerPawn.Dying.BeginState
		BaseEyeheight = Default.BaseEyeHeight;
		EyeHeight = BaseEyeHeight;
		if ( Carcass(ViewTarget) == None )
			bBehindView = true;
		bFrozen = true;
		bPressedJump = false;
		bJustFired = false;
		bJustAltFired = false;
		FindGoodView();
		if ( (Role == ROLE_Authority) && !bHidden ) {
			bHidden = true;
			C = SpawnCarcass();
			if (C != none)
				C.LifeSpan = 30.0;
			if ( bIsPlayer )
				HidePlayer();
			else
				Destroy();
		}
		SetTimer(RespawnDelay, false);

		// clean out saved moves
		while ( SavedMoves != None )
		{
			SavedMoves.Destroy();
			SavedMoves = SavedMoves.NextMove;
		}
		if ( PendingMove != None )
		{
			PendingMove.Destroy();
			PendingMove = None;
		}
		// END PlayerPawn.Dying.BeginState

		TimeDead = 0.0;
		RealTimeDead = 0.0;
		RotationRate = rot(0,0,0);
		bKillCamWanted = true;

		for (i = 0; i < arraycount(AddVelocityCalls); ++i) {
			AddVelocityCalls[i].Momentum = vect(0,0,0);
		}
		LastAddVelocityIndex = 0;
		LastAddVelocityAppliedIndex = 0;
	}

	function PlayerMove(float DeltaTime)
	{
		local vector X,Y,Z;

		if ( TimeDead >= 1.0 )
		{
			if ( bPressedJump )
			{
				Fire(0);
				bPressedJump = false;
			}
			GetAxes(ViewRotation,X,Y,Z);
			// Update view rotation.
			aLookup  *= 0.24;
			aTurn    *= 0.24;
			if (aLookup != 0.0 || aTurn != 0.0)
				bKillCamWanted = false;
			ViewRotation.Yaw += 32.0 * DeltaTime * aTurn;
			ViewRotation.Pitch += 32.0 * DeltaTime * aLookUp;
			ViewRotation.Pitch = ViewRotation.Pitch & 65535;
			If ((ViewRotation.Pitch > 18000) && (ViewRotation.Pitch < 49152))
			{
				If (aLookUp > 0)
					ViewRotation.Pitch = 18000;
				else
					ViewRotation.Pitch = 49152;
			}
		}
		ViewShake(DeltaTime);
		ViewFlash(DeltaTime);

		ClientUpdateTime += DeltaTime;
		if (ClientUpdateTime > TimeBetweenNetUpdates) {
			ClientUpdateTime = 0;
			IGPlus_AdjustLocationAlpha = 0; // avoid adjustments persisting until respawn
			xxServerMoveDead(Level.TimeSeconds, DeltaTime, ((ViewRotation.Pitch << 16) | (ViewRotation.Yaw & 0xFFFF)));
		}
	}

	function xxServerMove
	(
		float TimeStamp,
		float MoveDeltaTime,
		float AccelX,
		float AccelY,
		float AccelZ,
		float ClientLocX,
		float ClientLocY,
		float ClientLocZ,
		vector ClientVel,
		int MiscData,
		int MiscData2,
		int View,
		Actor ClientBase,
		optional int OldMoveData1,
		optional int OldMoveData2
	)
	{
		Global.xxServerMove(
			TimeStamp,
			MoveDeltaTime,
			AccelX,
			AccelY,
			AccelZ,
			ClientLocX,
			ClientLocY,
			ClientLocZ,
			ClientVel,
			MiscData & 0xFFFF,
			MiscData2,
			View,
			ClientBase,
			OldMoveData1,
			OldMoveData2);
	}

	function FindGoodView()
	{
		local vector cameraLoc;
		local rotator cameraRot;
		local actor ViewActor;

		//fixme - try to pick view with killer visible
		//fixme - also try varying starting pitch

		if (Settings.bEnableKillCam == false || KillCamDuration <= 0.0 || KillCamDelay > 0.0) {
			ViewRotation.Pitch = 56000;

			cameraLoc = Location;
			PlayerCalcView(ViewActor, cameraLoc, cameraRot);
		} else {
			KillCamTargetRotation = ViewRotation;
		}

		if (zzInfoThing != None)
			zzInfoThing.zzPlayerCalcViewCalls = 1;
	}

	function EndState()
	{
		RotationRate = default.RotationRate;
		SetPhysics(PHYS_None);
		Super.EndState();
		LastKillTime = 0;
		bJustRespawned = true;
		LastKiller = none;
		ClientUpdateTime = 0;
		bDodging = false;
		MultiDodgesRemaining = bbPlayerReplicationInfo(PlayerReplicationInfo).MaxMultiDodges;
	}

}

state CountdownDying extends Dying
{

	exec function Fire( optional float F ) {}

	function EndState() {
		bBehindView = false;
		if (Player != none)
			ServerReStartPlayer();
		bJustRespawned = true;
		bShowScores = false;
		ClientUpdateTime = 0;
	}

}

state GameEnded
{
ignores SeePlayer, HearNoise, KilledBy, Bump, HitWall, HeadZoneChange, FootZoneChange, ZoneChange, Falling, TakeDamage, PainTimer, Died;

	function ServerReStartGame();

	event PlayerTick( float DeltaTime )
	{
		xxPlayerTickEvents(DeltaTime);
		zzTick = DeltaTime;
		Super.PlayerTick(DeltaTime);
	}

	function PlayerMove(float DeltaTime)
	{
		local vector X,Y,Z;

		GetAxes(ViewRotation,X,Y,Z);
		// Update view rotation.

		if ( !bFixedCamera )
		{
			aLookup  *= 0.24;
			aTurn    *= 0.24;
			ViewRotation.Yaw += 32.0 * DeltaTime * aTurn;
			ViewRotation.Pitch += 32.0 * DeltaTime * aLookUp;
			ViewRotation.Pitch = ViewRotation.Pitch & 65535;
			If ((ViewRotation.Pitch > 18000) && (ViewRotation.Pitch < 49152))
			{
				If (aLookUp > 0)
					ViewRotation.Pitch = 18000;
				else
					ViewRotation.Pitch = 49152;
			}
		}
		else if ( ViewTarget != None )
			ViewRotation = ViewTarget.Rotation;

		ViewShake(DeltaTime);
		ViewFlash(DeltaTime);

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			xxReplicateMove(DeltaTime, vect(0,0,0), DODGE_None, rot(0,0,0));
		else
			ProcessMove(DeltaTime, vect(0,0,0), DODGE_None, rot(0,0,0));
		bPressedJump = false;
	}

	function xxServerMove
	(
		float TimeStamp,
		float MoveDeltaTime,
		float AccelX,
		float AccelY,
		float AccelZ,
		float ClientLocX,
		float ClientLocY,
		float ClientLocZ,
		vector ClientVel,
		int MiscData,
		int MiscData2,
		int View,
		Actor ClientBase,
		optional int OldMoveData1,
		optional int OldMoveData2
	)
	{
		Global.xxServerMove(
			TimeStamp,
			MoveDeltaTime,
			AccelX,
			AccelY,
			AccelZ,
			ClientLocX,
			ClientLocY,
			ClientLocZ,
			ClientVel,
			MiscData,
			MiscData2,
			((ViewRotation.Pitch & 0xFFFF) << 16) | (ViewRotation.Yaw & 0xFFFF),
			ClientBase,
			OldMoveData1,
			OldMoveData2);
	}

	function FindGoodView()
	{
		local vector cameraLoc;
		local rotator cameraRot;
		local int tries, besttry;
		local float bestdist, newdist;
		local int startYaw;
		local actor ViewActor;

		ViewRotation.Pitch = 56000;
		tries = 0;
		besttry = 0;
		bestdist = 0.0;
		startYaw = ViewRotation.Yaw;

		for (tries=0; tries<16; tries++)
		{
			if ( ViewTarget != None )
				cameraLoc = ViewTarget.Location;
			else
				cameraLoc = Location;
			PlayerCalcView(ViewActor, cameraLoc, cameraRot);
			newdist = VSize(cameraLoc - Location);
			if (newdist > bestdist)
			{
				bestdist = newdist;
				besttry = tries;
			}
			ViewRotation.Yaw += 4096;
		}
		if (zzInfoThing != None)
			zzInfoThing.zzPlayerCalcViewCalls = 1;

		ViewRotation.Yaw = startYaw + besttry * 4096;
	}
}

function PlayWaiting()
{
	local name newAnim;
	local int Pitch;

	if ( Mesh == None )
		return;

	if ( bIsTyping )
	{
		PlayChatting();
		return;
	}

	if ( (IsInState('PlayerSwimming')) || (Physics == PHYS_Swimming) )
	{
		BaseEyeHeight = 0.7 * Default.BaseEyeHeight;
		if ( (Weapon == None) || (Weapon.Mass < 20) )
			LoopAnim('TreadSM');
		else
			LoopAnim('TreadLG');
	}
	else
	{
		BaseEyeHeight = Default.BaseEyeHeight;
		Pitch = ViewRotation.Pitch << 16 >> 16;
		if (Pitch > RotationRate.Pitch)
		{
			if ( (Weapon == None) || (Weapon.Mass < 20) )
				TweenAnim('AimUpSm', 0.3);
			else
				TweenAnim('AimUpLg', 0.3);
		}
		else if (Pitch < -RotationRate.Pitch)
		{
			if ( (Weapon == None) || (Weapon.Mass < 20) )
				TweenAnim('AimDnSm', 0.3);
			else
				TweenAnim('AimDnLg', 0.3);
		}
		else if ( (Weapon != None) && Weapon.bPointing )
		{
			if ( Weapon.bRapidFire && ((bFire != 0) || (bAltFire != 0)) )
				LoopAnim('StillFRRP');
			else if ( Weapon.Mass < 20 )
				TweenAnim('StillSMFR', 0.3);
			else
				TweenAnim('StillFRRP', 0.3);
		}
		else
		{
			if ( FRand() < 0.1 )
			{
				if ( (Weapon == None) || (Weapon.Mass < 20) )
					PlayAnim('CockGun', 0.5 + 0.5 * FRand(), 0.3);
				else
					PlayAnim('CockGunL', 0.5 + 0.5 * FRand(), 0.3);
			}
			else
			{
				if ( (Weapon == None) || (Weapon.Mass < 20) )
				{
					if ( (FRand() < 0.75) && ((AnimSequence == 'Breath1') || (AnimSequence == 'Breath2')) )
						newAnim = AnimSequence;
					else if ( FRand() < 0.5 )
						newAnim = 'Breath1';
					else
						newAnim = 'Breath2';
				}
				else
				{
					if ( (FRand() < 0.75) && ((AnimSequence == 'Breath1L') || (AnimSequence == 'Breath2L')) )
						newAnim = AnimSequence;
					else if ( FRand() < 0.5 )
						newAnim = 'Breath1L';
					else
						newAnim = 'Breath2L';
				}

				if ( AnimSequence == newAnim )
					LoopAnim(newAnim, 0.4 + 0.4 * FRand());
				else
					PlayAnim(newAnim, 0.4 + 0.4 * FRand(), 0.25);
			}
		}
	}
}

function PlayHit(float Damage, vector HitLocation, name damageType, vector Momentum)
{
	local float rnd;
	local Bubble1 bub;
	local bool bServerGuessWeapon;
	local vector BloodOffset, Mo;
	local int iDam;

	if ( (Damage <= 0) && (ReducedDamageType != 'All') )
		return;

	if ( ReducedDamageType != 'All' ) //spawn some blood
	{
		if (damageType == 'Drowned')
		{
			bub = spawn(class 'Bubble1',,, Location
				+ 0.7 * CollisionRadius * vector(ViewRotation) + 0.3 * EyeHeight * vect(0,0,1));
			if (bub != None)
				bub.DrawScale = FRand()*0.06+0.04;
		}
		else if ( (damageType != 'Burned') && (damageType != 'Corroded')
					&& (damageType != 'Fell') )
		{
			BloodOffset = 0.2 * CollisionRadius * Normal(HitLocation - Location);
			BloodOffset.Z = BloodOffset.Z * 0.5;
			if ( (DamageType == 'shot') || (DamageType == 'decapitated') || (DamageType == 'shredded') )
			{
				Mo = Momentum;
				if ( Mo.Z > 0 )
					Mo.Z *= 0.5;
				spawn(class 'UT_BloodHit',self,,HitLocation + BloodOffset, rotator(Mo));
			}
			else
				spawn(class 'UT_BloodBurst',self,,HitLocation + BloodOffset);
		}
	}

	rnd = FClamp(Damage, 20, 60);
	if ( damageType == 'Burned' )
		ClientFlash( -0.009375 * rnd, rnd * vect(16.41, 11.719, 4.6875));
	else if ( damageType == 'Corroded' )
		ClientFlash( -0.01171875 * rnd, rnd * vect(9.375, 14.0625, 4.6875));
	else if ( damageType == 'Drowned' )
		ClientFlash(-0.390, vect(312.5,468.75,468.75));
	else
		ClientFlash( -0.019 * rnd, rnd * vect(26.5, 4.5, 4.5));

	ShakeView(0.15 + 0.005 * Damage, Damage * 30, 0.3 * Damage);
	PlayTakeHitSound(Damage, damageType, 1);
	bServerGuessWeapon = ( ((Weapon != None) && Weapon.bPointing) || (GetAnimGroup(AnimSequence) == 'Dodge') );
	iDam = Clamp(Damage,0,200);
	ClientPlayTakeHit(HitLocation - Location, iDam, bServerGuessWeapon );
	if ( !bServerGuessWeapon
		&& ((Level.NetMode == NM_DedicatedServer) || (Level.NetMode == NM_ListenServer)) )
	{
		Enable('AnimEnd');
		BaseEyeHeight = Default.BaseEyeHeight;
		bAnimTransition = true;
		PlayTakeHit(0.1, HitLocation, Damage);
	}
}

simulated function FootStepping()
{
	if (Settings != none && Settings.bNoOwnFootsteps)
		if (Role >= ROLE_AutonomousProxy || GetLocalPlayer().ViewTarget == self)
			return;

	super.FootStepping();
}

function xxShowItems()
{
	local int zzx;

	for (zzx = 0; zzx < zzAntiTimerListCount; zzx++)
	{
		if (zzAntiTimerList[zzx] != None)
			zzAntiTimerList[zzx].bHidden = (zzAntiTimerListState & (1 << zzx)) != zzNull;	// Bitmapped
	}

}

function xxHideItems()
{
	for (zzAntiTimerFlippedCount = 0; zzAntiTimerFlippedCount < zzAntiTimerListCount; zzAntiTimerFlippedCount++)
	{
		if (zzAntiTimerList[zzAntiTimerFlippedCount] != None)
		{
			zzAntiTimerList[zzAntiTimerFlippedCount].bHidden = zzFalse;
		}
	}
}

function xxDoShot()
{
	local string zzS;

	zzS = ConsoleCommand("shot");

	if (zzMagicCode != "")
	{
		xxServerAckScreenshot(zzS, zzMagicCode);
		zzMagicCode = "";
	}
	zzbReportScreenshot = zzFalse;
}

simulated function bool ClientCannotShoot(optional Weapon W, optional byte Mode, optional bool bIgnoreFireTime)
{
	local bool bCant;
	local name WeapState;

	if (Level.TimeSeconds - zzSpawnedTime <= 0.3)
	{
		bCant = true;
	}
	else if (PendingWeapon != None)
	{
		PendingWeapon.bChangeWeapon = false;
		bCant = true;
	}
	else if (Weapon.IsInState('ClientDown'))
	{
		bCant = true;
	}
	else if (Weapon.AnimSequence == 'Down')
	{
		bCant = true;
	}
	else if (!Weapon.bWeaponUp)
	{
		WeapState = Weapon.GetStateName();
		if (WeapState == 'ClientFiring' || WeapState == 'ClientAltFiring' || WeapState == 'Idle' || WeapState == '' || WeapState == Weapon.Class.Name || Weapon.AnimSequence == 'Still')
			Weapon.bWeaponUp = true;
		else
			bCant = true;
	}
	else if (IsInState('Dying'))
	{
		bCant = true;
	}
	else if (Player == None)
	{
		bCant = true;
	}
	else if ((Weapon != None) && Weapon.IsInState('ClientActive'))
	{
		Weapon.GotoState('');
		Weapon.TweenAnim('Still', 0);
	}
	return bCant;
}

function CalcAvgTick()
{
	local float CurrentTime;
	CurrentTime = Level.TimeSeconds;
	if (LastTick > 0)
		AvgTickDiff = CurrentTime - LastTick;
	else
		AvgTickDiff = (AvgTickDiff + CurrentTime - LastTick) / 2;
	LastTick = CurrentTime;
	if (Level.NetMode == NM_Client)
		ClientMessage(AvgTickDiff);
	else
		Log(AvgTickDiff);
}

function xxPlayerTickEvents(float DeltaTime)
{
	local float CurrentTime;

	CurrentTime = Level.TimeSeconds;

	if (Level.NetMode == NM_Client)
	{
		if (ConsoleCommand("get ini:engine.engine.gamerenderdevice SmoothMaskedTextures") ~= "true") {
			// SmoothMaskedTextures makes certain textures see-through
			// --> force it off
			ConsoleCommand("set ini:engine.engine.gamerenderdevice SmoothMaskedTextures False");
		}

		if (Player.CurrentNetSpeed != 0 && CurrentTime - zzLastStuffUpdate > 500.0/Player.CurrentNetSpeed)
		{
			xxGetDemoPlaybackSpec();

			if (zzClientTTarget != None)
				xxServerReceiveStuff( zzClientTTarget.Location, zzClientTTarget.Velocity );
			zzLastStuffUpdate = CurrentTime;
		}
	}

	if (zzbIsWarmingUp)
		ClearProgressMessages();

	if (zzbReportScreenshot)
		xxDoShot();

	xxHideItems();

	zzInfoThing.zzTickOff++;
	zzInfoThing.zzLastTick = 0.0;
	if (zzForceSettingsLevel != zzOldForceSettingsLevel)
	{
		zzOldForceSettingsLevel = zzForceSettingsLevel;
		if (zzForceSettingsLevel > 0)
			zzInfoThing.xxStartupCheck(Self);
		if (zzForceSettingsLevel > 1)
			zzInfoThing.xxInstallSpawnNotify(Self);
	}

	if (PureLevel != None)	// Why would this be None?!
	{
		zzbDemoRecording = PureLevel.zzDemoRecDriver != None;
		if (!zzbDemoRecording && zzbGameStarted && (zzbForceDemo || Settings.bAutoDemo && (DeathMatchPlus(Level.Game) == none || DeathMatchPlus(Level.Game).CountDown < 1)))
			xxClientDemoRec();
	}
}

static function SetForcedSkin(Actor SkinActor, int selectedSkin, bool bTeamGame, int TeamNum) {
	local string suffix;
	local bbPlayer P;
	local bbPlayerReplicationInfo PRI;
	/**
	* @Author: spect
	* @Date: 2020-02-21 01:17:00
	* @Desc: Sets the selected forced skin client side
	*/

	if (selectedSkin > 17)
		selectedSkin = 12;

	suffix = "";
	if (bTeamGame)
		suffix = "t_"$TeamNum;

	P = bbPlayer(SkinActor);

	switch (selectedSkin) {
		case 0: // Female Commando Aphex
			SetSkinElement(SkinActor, 0, "FCommandoSkins.aphe1"$suffix, "FCommandoSkins.aphe");
			SetSkinElement(SkinActor, 1, "FCommandoSkins.aphe2"$suffix, "FCommandoSkins.aphe");
			// Set the face
			SetSkinElement(SkinActor, 3, "FCommandoSkins.aphe4Indina", "FCommandoSkins.aphe");
			// Set the Mesh
			SkinActor.Mesh = class'bbTFemale1'.Default.Mesh;
			break;
		case 1: // Female Commando Anna
			SetSkinElement(SkinActor, 0, "FCommandoSkins.cmdo1"$suffix, "FCommandoSkins.cmdo");
			SetSkinElement(SkinActor, 1, "FCommandoSkins.cmdo2"$suffix, "FCommandoSkins.cmdo");
			// Set the face
			SetSkinElement(SkinActor, 3, "FCommandoSkins.cmdo4Anna", "FCommandoSkins.anna");
			// Set the Mesh
			SkinActor.Mesh = class'bbTFemale1'.Default.Mesh;
			break;
		case 2: // Female Commando Mercenary
			SetSkinElement(SkinActor, 0, "FCommandoSkins.daco1"$suffix, "FCommandoSkins.daco");
			SetSkinElement(SkinActor, 1, "FCommandoSkins.daco2"$suffix, "FCommandoSkins.daco");
			// Set the face
			SetSkinElement(SkinActor, 3, "FCommandoSkins.daco4Jayce", "FCommandoSkins.daco");
			// Set the Mesh
			SkinActor.Mesh = class'bbTFemale1'.Default.Mesh;
			break;
		case 3: // Female Commando Necris
			SetSkinElement(SkinActor, 0, "FCommandoSkins.goth1"$suffix, "FCommandoSkins.goth");
			SetSkinElement(SkinActor, 1, "FCommandoSkins.goth2"$suffix, "FCommandoSkins.goth");
			// Set the face
			SetSkinElement(SkinActor, 3, "FCommandoSkins.goth4Cryss", "FCommandoSkins.goth");
			// Set the Mesh
			SkinActor.Mesh = class'bbTFemale1'.Default.Mesh;
			break;
		case 4: // Female Soldier Marine
			SetSkinElement(SkinActor, 0, "SGirlSkins.fbth1"$suffix, "SGirlSkins.fbth");
			SetSkinElement(SkinActor, 1, "SGirlSkins.fbth2"$suffix, "SGirlSkins.fbth");
			SetSkinElement(SkinActor, 2, "SGirlSkins.fbth3", "SGirkSkins.fbth");
			// Set the face
			SetSkinElement(SkinActor, 3, "SGirlSkins.fbth4Annaka", "SGirlSkins.fbth");
			// Set the Mesh
			SkinActor.Mesh = class'bbTFemale2'.Default.Mesh;
			break;
		case 5: // Female Soldier Metal Guard
			SetSkinElement(SkinActor, 0, "SGirlSkins.Garf1"$suffix, "SGirlSkins.Garf");
			SetSkinElement(SkinActor, 1, "SGirlSkins.Garf2"$suffix, "SGirlSkins.Garf");
			SetSkinElement(SkinActor, 2, "SGirlSkins.Garf3", "SGirlSkins.Garf");
			// Set the face
			SetSkinElement(SkinActor, 3, "SGirlSkins.Garf4Isis", "SGirlSkins.Garf");
			SkinActor.Mesh = class'bbTFemale2'.Default.Mesh;
			break;
		case 6: // Female Soldier Soldier
			SetSkinElement(SkinActor, 0, "SGirlSkins.army1"$suffix, "SGirlSkins.army");
			SetSkinElement(SkinActor, 1, "SGirlSkins.army2"$suffix, "SGirlSkins.army");
			SetSkinElement(SkinActor, 2, "SGirlSkins.army3", "SGirlSkins.army");
			// Set the face
			SetSkinElement(SkinActor, 3, "SGirlSkins.army4Lauren", "SGirlSkins.army");
			SkinActor.Mesh = class'bbTFemale2'.Default.Mesh;
			break;
		case 7: // Female Soldier Venom
			SetSkinElement(SkinActor, 0, "SGirlSkins.Venm1"$suffix, "SGirlSkins.Venm");
			SetSkinElement(SkinActor, 1, "SGirlSkins.Venm2"$suffix, "SGirlSkins.Venm");
			SetSkinElement(SkinActor, 2, "SGirlSkins.Venm3", "SGirlSkins.Venm");
			// Set the face
			SetSkinElement(SkinActor, 3, "SGirlSkins.Venm4Athena", "SGirlSkins.Venm");
			SkinActor.Mesh = class'bbTFemale2'.Default.Mesh;
			break;
		case 8: // Female Soldier War Machine
			SetSkinElement(SkinActor, 0, "SGirlSkins.fwar1"$suffix, "SGirlSkins.fwar");
			SetSkinElement(SkinActor, 1, "SGirlSkins.fwar2"$suffix, "SGirlSkins.fwar");
			SetSkinElement(SkinActor, 2, "SGirlSkins.fwar3", "SGirlSkins.fwar");
			// Set the face
			SetSkinElement(SkinActor, 3, "SGirlSkins.fwar4Cathode", "SGirlSkins.fwar");
			SkinActor.Mesh = class'bbTFemale2'.Default.Mesh;
			break;
		case 9: // Male Commando Commando
			SetSkinElement(SkinActor, 3, "CommandoSkins.cmdo4"$suffix, "CommandoSkins.cmdo");
			SetSkinElement(SkinActor, 2, "CommandoSkins.cmdo3"$suffix, "CommandoSkins.cmdo");
			SetSkinElement(SkinActor, 0, "CommandoSkins.cmdo1", "CommandoSkins.cmdo");
			// Set the face
			SetSkinElement(SkinActor, 1, "CommandoSkins.cmdo2Blake", "CommandoSkins.cmdo");
			SkinActor.Mesh = class'bbTMale1'.Default.Mesh;
			break;
		case 10: // Male Commando Mercenary
			SetSkinElement(SkinActor, 3, "CommandoSkins.daco4"$suffix, "CommandoSkins.daco");
			SetSkinElement(SkinActor, 2, "CommandoSkins.daco3"$suffix, "CommandoSkins.daco");
			SetSkinElement(SkinActor, 0, "CommandoSkins.daco1", "CommandoSkins.daco");
			// Set the face
			SetSkinElement(SkinActor, 1, "CommandoSkins.daco2Boris", "CommandoSkins.daco");
			SkinActor.Mesh = class'bbTMale1'.Default.Mesh;
			break;
		case 11: // Male Commando Necris
			SetSkinElement(SkinActor, 3, "CommandoSkins.goth4"$suffix, "CommandoSkins.goth");
			SetSkinElement(SkinActor, 2, "CommandoSkins.goth3"$suffix, "CommandoSkins.goth");
			SetSkinElement(SkinActor, 0, "CommandoSkins.goth1", "CommandoSkins.goth");
			// Set the face
			SetSkinElement(SkinActor, 1, "CommandoSkins.goth2Grail", "CommandoSkins.goth");
			SkinActor.Mesh = class'bbTMale1'.Default.Mesh;
			break;
		case 12: // Male Soldier Marine
			SetSkinElement(SkinActor, 0, "SoldierSkins.blkt1"$suffix, "SoldierSkins.blkt");
			SetSkinElement(SkinActor, 1, "SoldierSkins.blkt2"$suffix, "SoldierSkins.blkt");
			SetSkinElement(SkinActor, 2, "SoldierSkins.blkt3", "SoldierSkins.blkt");
			// Set the face
			SetSkinElement(SkinActor, 3, "SoldierSkins.blkt4Malcom", "SoldierSkins.blkt");
			SkinActor.Mesh = class'bbTMale2'.Default.Mesh;
			break;
		case 13: // Male Soldier Metal Guard
			SetSkinElement(SkinActor, 0, "SoldierSkins.Gard1"$suffix, "SoldierSkins.Gard");
			SetSkinElement(SkinActor, 1, "SoldierSkins.Gard2"$suffix, "SoldierSkins.Gard");
			SetSkinElement(SkinActor, 2, "SoldierSkins.Gard3", "SoldierSkins.Gard");
			// Set the face
			SetSkinElement(SkinActor, 3, "SoldierSkins.Gard4Drake", "SoldierSkins.Gard");
			SkinActor.Mesh = class'bbTMale2'.Default.Mesh;
			break;
		case 14: // Male Soldier Raw Steel
			SetSkinElement(SkinActor, 0, "SoldierSkins.RawS1"$suffix, "SoldierSkins.RawS");
			SetSkinElement(SkinActor, 1, "SoldierSkins.RawS2"$suffix, "SoldierSkins.RawS");
			SetSkinElement(SkinActor, 2, "SoldierSkins.RawS3", "SoldierSkins.RawS");
			// Set the face
			SetSkinElement(SkinActor, 3, "SoldierSkins.RawS4Arkon", "SoldierSkins.RawS");
			SkinActor.Mesh = class'bbTMale2'.Default.Mesh;
			break;
		case 15: // Male Soldier Soldier
			SetSkinElement(SkinActor, 0, "SoldierSkins.sldr1"$suffix, "SoldierSkins.sldr");
			SetSkinElement(SkinActor, 1, "SoldierSkins.sldr2"$suffix, "SoldierSkins.sldr");
			SetSkinElement(SkinActor, 2, "SoldierSkins.sldr3", "SoldierSkins.sldr");
			// Set the face
			SetSkinElement(SkinActor, 3, "SoldierSkins.sldr4Brock", "SoldierSkins.sldr");
			SkinActor.Mesh = class'bbTMale2'.Default.Mesh;
			break;
		case 16: // Male Soldier War Machine
			SetSkinElement(SkinActor, 0, "SoldierSkins.hkil1"$suffix, "SoldierSkins.hkil");
			SetSkinElement(SkinActor, 1, "SoldierSkins.hkil2"$suffix, "SoldierSkins.hkil");
			SetSkinElement(SkinActor, 2, "SoldierSkins.hkil3", "SoldierSkins.hkil");
			// Set the face
			SetSkinElement(SkinActor, 3, "SoldierSkins.hkil4Matrix", "SoldierSkins.hkil");
			SkinActor.Mesh = class'bbTMale2'.Default.Mesh;
			break;
		case 17: // Boss
			SetSkinElement(SkinActor, 0, "BossSkins.Boss1"$suffix, "BossSkins.Boss");
			SetSkinElement(SkinActor, 1, "BossSkins.Boss2"$suffix, "BossSkins.Boss");
			SetSkinElement(SkinActor, 2, "BossSkins.Boss3"$suffix, "BossSkins.Boss");
			// Set the face (Xan has different head colours? Makes sense, he's a robot.)
			SetSkinElement(SkinActor, 3, "BossSkins.Boss4"$suffix, "BossSkins.Boss");
			SkinActor.Mesh = class'bbTBoss'.Default.Mesh;
			break;
		default:
			if (P.bAppearanceChanged) {
				PRI = bbPlayerReplicationInfo(P.PlayerReplicationInfo);
				SkinActor.Mesh = SkinActor.default.Mesh;
				P.static.SetMultiSkin(SkinActor, PRI.SkinName, PRI.FaceName, TeamNum);
				P.bAppearanceChanged = false;
			}
			return;
	}
	P.bAppearanceChanged = true;
}

function int GetForcedSkinForPlayer(PlayerReplicationInfo PRI) {
	local string Anim;
	local bbPlayerReplicationInfo bbPRI;

	Anim = string(PRI.Owner.AnimSequence);
	if (Left(Anim, 8) ~= "DeathEnd") {
		// Dont force skin when feigning death to match actual death animations
		return -1;
	}

	if (GameReplicationInfo.bTeamGame && PRI.Team == PlayerReplicationInfo.Team) {
		if (Settings.bSkinTeamUseIndexMap) {
			bbPRI = bbPlayerReplicationInfo(PRI);
			if (bbPRI != none && bbPRI.SkinIndex >= 0) {
				return Settings.SkinTeamIndexMap[bbPRI.SkinIndex];
			}
		}
		if (PRI.bIsFemale) {
			return Settings.DesiredTeamSkinFemale;
		} else {
			return Settings.DesiredTeamSkin;
		}
	} else {
		if (Settings.bSkinEnemyUseIndexMap) {
			bbPRI = bbPlayerReplicationInfo(PRI);
			if (bbPRI != none && bbPRI.SkinIndex >= 0) {
				if (GameReplicationInfo.bTeamGame)
					return Settings.SkinEnemyIndexMap[(bbPRI.Team << 4) + bbPRI.SkinIndex];
				else
					return Settings.SkinEnemyIndexMap[bbPRI.SkinIndex];
			}
		}
		if (PRI.bIsFemale) {
			return Settings.DesiredSkinFemale;
		} else {
			return Settings.DesiredSkin;
		}
	}

	return -1;
}

function bool IsForcedSkinFemale(int Skin) {
	return Skin >= 0 && Skin <= 8;
}

function bool IsForcedSkinMale(int Skin) {
	return Skin > 8 && Skin <= 17;
}

function ApplyForcedSkins(PlayerReplicationInfo PRI) {
	local int Skin;

	/**
	 * @Author: spect
	 * @Date: 2020-02-18 02:20:22
	 * @Desc: Applies the forced skin client side if force models is enabled.
	 */

	if (zzbForceModels) {
		Skin = GetForcedSkinForPlayer(PRI);
		SetForcedSkin(PRI.Owner, Skin, GameReplicationInfo.bTeamGame, PRI.Team);
	}
}

function ApplyBrightskins(PlayerReplicationInfo PRI) {
	local string Anim;
	local Pawn P;

	P = Pawn(PRI.Owner);
	if (P == none) return;

	if (BrightskinMode >= 1 && Settings.bUnlitSkins) {
		Anim = string(P.AnimSequence);
		if (Left(Anim, 8) ~= "DeathEnd") {
			//
		} else {
			P.bUnlit = true;
			if (P.Weapon != none)
				P.Weapon.bUnlit = true;
			return;
		}
	}

	P.bUnlit = false;
	if (P.Weapon != none)
		P.Weapon.bUnlit = false;
}

event PreRender( canvas zzCanvas )
{
	local PlayerReplicationInfo zzPRI;

	zzbDemoRecording = PureLevel != None && PureLevel.zzDemoRecDriver != None;

	Super.PreRender(zzCanvas);

	if (GameReplicationInfo != None && PlayerReplicationInfo != None) {
		foreach AllActors(class'PlayerReplicationInfo', zzPRI) {
			if (zzPRI.Owner == none) continue;
			if (zzPRI.bIsSpectator) continue;

			ApplyForcedSkins(zzPRI);
			ApplyBrightskins(zzPRI);
		}
	}

	xxShowItems();
}

event PostRender( canvas zzCanvas )
{
	local int CH;
	local int NetspeedTarget;
	local int Netspeed;

	if (zzbRepVRData)
	{	// Received data through demo replication.
		ViewRotation.Yaw = zzRepVRYaw;
		ViewRotation.Pitch = zzRepVRPitch;
		ViewRotation.Roll = 0;
		EyeHeight = zzRepVREye;
	}

	xxHideItems();

	if ( bBehindView )
	{
		if ( Weapon != None )
			Weapon.RenderOverlays(zzCanvas);
	}

	if (Settings.bUseCrosshairFactory) {
		CH = MyHud.Crosshair;
		MyHud.Crosshair = ChallengeHUD(MyHud).CrosshairCount;
	}
	Super.PostRender(zzCanvas);
	if (Settings.bUseCrosshairFactory) {
		if (ChallengeHUD(MyHud).bShowInfo == false &&
			bShowScores == false &&
			ChallengeHUD(MyHud).bForceScores == false &&
			bBehindView == false &&
			Level.LevelAction == LEVACT_None &&
			Weapon != none &&
			Weapon.bOwnsCrossHair == false
		) {
			PlayerStatics.DrawCrosshair(zzCanvas, Settings);
		}
		MyHud.Crosshair = CH;
	}

	// Render our UTPure Logo
	xxRenderLogo(zzCanvas);
	xxCleanAvars();

	if (Player.CurrentNetspeed != zzNetspeed) {
		Netspeed = int(ConsoleCommand("get ini:Engine.Engine.NetworkDevice MaxClientRate"));
		if (Netspeed < Settings.DesiredNetspeed) {
			ConsoleCommand("set ini:Engine.Engine.NetworkDevice MaxClientRate"@Settings.DesiredNetspeed);
			Netspeed = Settings.DesiredNetspeed;
		}
		if (zzMinimumNetspeed > 0 && Netspeed < zzMinimumNetspeed) {
			xxServerCheater("NS");
			goto netspeed_end;
		}
		if (zzMaximumNetspeed > 0 && Netspeed < zzMaximumNetspeed)
			zzMaximumNetspeed = Netspeed;

		NetspeedTarget = Settings.DesiredNetspeed;
		if (zzMinimumNetspeed != 0 && NetspeedTarget < zzMinimumNetspeed)
			NetspeedTarget = zzMinimumNetspeed;
		if (zzMaximumNetspeed != 0 && NetspeedTarget > zzMaximumNetspeed)
			NetspeedTarget = zzMaximumNetspeed;

		ConsoleCommand("Netspeed"@NetspeedTarget);
		zzNetspeed = Player.CurrentNetspeed;

	netspeed_end:
		//
	}

	if (zzDelayedStartTime != 0.0)
	{
		if (Level.TimeSeconds - zzDelayedStartTime > zzWaitTime)
		{
			if (zzDelayedVoice != None)
			{
				PlayerReplicationInfo.VoiceType = zzDelayedVoice;
				UpdateURL("Voice", string(zzDelayedVoice), True);
				ServerSetVoice(zzDelayedVoice);
				zzDelayedVoice = None;
			}
			zzDelayedStartTime = 0.0;
		}
	}

	if (bDrawDebugData) {
		xxDrawDebugData(zzCanvas, 10, 120);
	}

	PlayerStatics.DrawFPS(zzCanvas, MyHud, Settings, zzTick);
	PlayerStatics.DrawHitMarker(zzCanvas, Settings, zzTick);
	if (HitMarkerTestDamage > 0 && PlayerStatics.default.HitMarkerLifespan == 0) {
		PlayerStatics.PlayHitMarker(self, Settings, HitMarkerTestDamage, PlayerReplicationInfo.Team, HitMarkerTestTeam);
		++HitMarkerTestTeam;
		if (HitMarkerTestTeam >= 4)
			HitMarkerTestTeam = 0;
	}

	FrameCount += 1;
}

exec simulated Function TellConsole()
{
	Log("Console class:"@player.console.class);
}

simulated function xxClientDoScreenshot(string zzMagic)
{
	zzMagicCode = zzMagic;
	zzbDoScreenshot = zzTrue;
}

simulated function xxDrawLogo(canvas zzC, float zzx, float zzY, float zzFadeValue)
{
	if (myHUD == None)
		return;

	zzC.Style = ERenderStyle.STY_Translucent;
	zzC.DrawColor = ChallengeHud(MyHud).WhiteColor * zzFadeValue;
	zzC.SetPos(zzx,zzY);
	zzC.DrawIcon(texture'NewNetLogo',1.0);
	zzC.DrawColor = ChallengeHud(MyHud).CyanColor * zzFadeValue;
	zzC.SetPos(zzx+70,zzY+8);
	zzC.Font = ChallengeHud(MyHud).MyFonts.GetBigFont(zzC.ClipX);
	zzC.DrawText(class'UTPure'.default.VersionStr@class'UTPure'.default.NiceVer);
	zzC.SetPos(zzx+70,zzY+35);
	zzC.Font = ChallengeHud(MyHud).MyFonts.GetBigFont(zzC.ClipX);
	if (zzbDoScreenshot)
		zzC.DrawText(PlayerReplicationInfo.PlayerName@zzMagicCode);
	else
		zzC.DrawText("Type 'PlayerHelp' into console for commands!");
	zzC.Style = ERenderStyle.STY_Normal;
}

simulated function xxRenderLogo(canvas zzC)
{
	local float zzFadeValue, zzTimeUsed;

	if (zzbDoScreenshot)
	{
		if (zzMagicCode != "")
			xxDrawLogo(zzC, 10, zzC.ClipY - 128, 0.75);
		zzbDoScreenshot = zzFalse;
		zzbReportScreenshot = zzTrue;
	}

	if (zzbLogoDone) {
		return;
	}

	zzTimeUsed = Level.TimeSeconds - zzLogoStart;
	if (zzTimeUsed > 5.0)
	{
		zzbLogoDone = True;
		PlaySound(sound'SpeechWindowClick', SLOT_Interact);
	}

	if (zzTimeUsed > 3.0)
	{
		zzFadeValue = (5.0 - zzTimeUsed) / 2.0;
	}
	else
		zzFadeValue = 1.0;

	xxDrawLogo(zzC, 10, zzC.ClipY - 128, zzFadeValue);
}

exec function ShowFPS() {
	Settings.bShowFPS = !Settings.bShowFPS;
	Settings.SaveConfig();
	if (Settings.bShowFPS)
		ClientMessage("FPS shown!", 'IGPlus');
	else
		ClientMessage("FPS hidden!", 'IGPlus');
}

simulated function xxDrawDebugData(canvas zzC, float zzx, float zzY) {
	local Pawn P;
	local int y;

	/**
	 * @Author: spect
	 * @Date: 2020-03-07 19:56:32
	 * @Desc: Draw Debug Data
	 */

	if (MyHUD == None)
		return;

	zzC.Style = ERenderStyle.STY_Translucent;
	zzC.DrawColor = ChallengeHud(MyHud).WhiteColor;
	zzC.SetPos(zzx,zzY);
	zzC.Font = ChallengeHud(MyHud).MyFonts.GetSmallFont(zzC.ClipX);
	zzC.DrawText("ViewRot:"@ViewRotation);
	zzC.SetPos(zzx, zzY + 20);
	zzC.DrawText("NewAccel:"@debugNewAccel);
	zzC.SetPos(zzx, zzY + 40);
	zzC.DrawText("Velocity:"@Velocity);
	zzC.SetPos(zzx, zzY + 60);
	zzC.DrawText("ClientLoc:"@debugPlayerLocation);
	zzC.SetPos(zzx, zzY + 80);
	zzC.DrawText("ServerLoc:"@debugPlayerServerLocation);
	zzC.SetPos(zzx, zzY + 100);
	zzC.DrawText("HitLocation:"@debugClientHitLocation);
	zzC.SetPos(zzx, zzY + 120);
	zzC.DrawText("HitNormal:"@debugClientHitNormal);
	zzC.SetPos(zzx + 20, zzY + 140);
	zzC.DrawText("Pawn?"@bClientPawnHit);
	zzC.SetPos(zzx + 20, zzY + 160);
	zzC.DrawText("HitDiff:"@debugClientHitDiff);
	zzC.SetPos(zzx, zzY + 180);
	zzC.DrawText("Other.Location:"@debugClientEnemyHitLocation);
	zzC.SetPos(zzx, zzY + 200);
	zzC.DrawText("ClientLocErr:"@debugClientLocError);
	zzC.SetPos(zzx, zzY + 220);
	zzC.DrawText("zzbForceUpdate:"@debugClientForceUpdate);
	zzC.SetPos(zzx, zzY + 240);
	zzC.DrawText("ForcedUpdates:"@debugNumOfForcedUpdates@"-"@debugNumOfIgnoredForceUpdates@"="@(debugNumOfForcedUpdates - debugNumOfIgnoredForceUpdates));
	zzC.SetPos(zzx, zzY + 260);
	zzC.DrawText("bMoveSmooth:"@debugClientbMoveSmooth);
	zzC.SetPos(zzx, zzY + 280);
	zzC.DrawText("ClientPing:"@debugClientPing);
	zzC.SetPos(zzx, zzY + 300);
	zzC.DrawText("Is Alive?"@bIsAlive);
	zzC.SetPos(zzx, zzY + 320);
	zzC.DrawText("LastUpdateTime:"@clientLastUpdateTime);
	zzC.SetPos(zzx, zzY + 340);
	zzC.DrawText("MaxTimeMargin:"@MaxTimeMargin);
	zzC.SetPos(zzx, zzY + 360);
	zzC.DrawText("finishedLoading?:"@bIsFinishedLoading);
	zzC.SetPos(zzx, zzY + 380);
	zzC.DrawText("NetUpdateRate:"@Settings.DesiredNetUpdateRate@TimeBetweenNetUpdates);
	zzC.SetPos(zzx, zzY + 400);
	zzC.DrawText("UpdatedPosition:"@clientForcedPosition);
	zzC.SetPos(zzx+20, zzY + 420);
	zzC.DrawText("Physics:"@Physics@"Anim:"@AnimSequence);
	zzC.SetPos(zzx, zzY + 440);
	zzC.DrawText("AnimRate:"@AnimRate@"TweenRate:"@TweenRate);
	zzC.SetPos(zzx+500, zzY);
	zzC.DrawText("Players:");
	y = zzY + 20;
	foreach AllActors(class'Pawn', P) {
		if (P.PlayerReplicationInfo == none) continue;
		if (P.PlayerReplicationInfo.bIsSpectator) continue;
		if (P.PlayerReplicationInfo.bIsABot) continue;
		zzC.SetPos(zzx+500, y);
		zzC.DrawText("Player"$P.PlayerReplicationInfo.PlayerID@"State:"@GetStateName()@"Physics:"@P.Physics@"Anim:"@P.AnimSequence@"DuckFraction:"@bbPlayer(P).DuckFraction);
		y += 20;
	}
	zzC.SetPos(zzx, zzY + 460);
	zzC.DrawText("Base:"@Base);
	zzC.SetPos(zzx+20, zzY + 480);
	if (Base != none)
		zzC.DrawText("Velocity:"@Base.Velocity@"State:"@Base.GetStateName());
	else
		zzC.DrawText("Velocity:"@vect(0,0,0)@"State:");

	zzC.SetPos(zzx, zzY + 500);
	zzC.DrawText("ExtrapolationDelta:"@ExtrapolationDelta);
	zzC.SetPos(zzx, zzY + 520);
	zzC.DrawText("EyeHeight:"@EyeHeight);
	zzC.SetPos(zzx, zzY + 540);
	zzC.DrawText("ServerMove calls"@debugServerMoveCallsSent@debugServerMoveCallsReceived);
	zzC.SetPos(zzx, zzY + 560);
	zzC.DrawText("bDodging"@bDodging@"DodgeDir"@DodgeDir);

	zzC.Style = ERenderStyle.STY_Normal;
}

exec function PureLogo()
{
	zzbLogoDone = False;
	zzLogoStart = Level.TimeSeconds;
}

function xxServerCheater(string zzCode)
{
	local string zzS;
	local Pawn zzP;

	if (zzbBadGuy)
		return;

	if (Len(zzCode) == 2)
	{
		if (zzCode == "BC")
			zzS = "Bad Console!";
		else if (zzCode == "BA")
			zzS = "Bad Canvas!";
		else if (zzCode == "SM")
			zzS = "Should not happen!";
		else if (zzCode == "TF")
			zzS = "Possible heavy ping/packetloss!";
		else if (zzCode == "IC")
			zzS = "Console not responding!";
		else if (zzCode == "HR")
			zzS = "HUD Replaced!";
		else if (zzCode == "FM")
			zzS = "Failed Mutator!";
		else if (zzCode == "AV" || zzCode == "TB" || zzCode == "FF")
			zzS = "Hacked Pure?";
		else if (zzCode == "PT")
			zzS = "Should not happen!";
		else if (zzCode == "AL")
			zzS = "Failed Adminlogin 5 times!";
		else if (zzCode == "NC")
			zzS = "Excess netspeed changes!";
		else if (zzCode == "NS")
			zzS = "MaxClientRate too low!";
		else if (zzCode == "S1" || zzCode == "S2")
			zzS = "Client Tampering!";
		else if (zzCode == "ZD")
			zzS = "Noshadow TCCs!";
		else if (zzCode == "ZE")
			zzS = "Other TCCs!";
		else if (zzCode == "HA")
			zzS = "Bloody not good (Pure messed up??)";
		else if (zzCode == "MT")
			zzS = "Mutator Kick!";
		else if (zzCode == "TD")
			zzS = "Bad TimeDilation!";
		else if (zzCode == "FA")
			zzS = "Bad FireAdjust!";
		else
			zzS = "UNKNOWN!";
		zzCode = zzCode@"-"@zzS;
	}
	xxCheatFound(zzCode);
	zzS = GetPlayerNetworkAddress();
	zzS = Left(zzS, InStr(zzS, ":"));
	zzUTPure.xxLogDate("UTPureCheat:"@PlayerReplicationInfo.PlayerName@"("$zzS$") had an impurity ("$zzCode$")", Level);
	if (zzUTPure.bTellSpectators)
	{
		for (zzP = Level.PawnList; zzP != None; zzP = zzP.NextPawn)
		{
			if (zzP.IsA('MessagingSpectator'))
				zzP.ClientMessage(PlayerReplicationInfo.PlayerName@zzS@"Pure:"@zzCode);
		}
	}
	Destroy();
	zzbBadGuy = True;
}

// ==================================================================================
// CheatFound
// ==================================================================================
simulated function xxCheatFound(string zzCode)
{
	local UTConsole C;

	if (zzbBadGuy)
		return;
	zzbBadGuy = True;

	C = UTConsole(Player.Console);
	C.AddString( "=====================================================================" );
	C.AddString( "  UTPure has detected an impurity hiding in your client!" );
	C.AddString( "  ID:"@zzCode );
	C.AddString( "=====================================================================" );
	C.AddString( "Because of this you have been removed from the" );
	C.AddString( "server.  Fair play is important, remove the impurity" );
	C.AddString( "and you can return!");
	C.AddString( " ");
	C.AddString( "If you feel this was in error, please contact the admin" );
	C.AddString( "at: "$GameReplicationInfo.AdminEmail);
	C.AddString( " ");
	C.AddString( "Please visit http://forums.utpure.com" );
	C.AddString( "You can read info regarding what UTPure is and maybe find a fix there!" );

	if (int(Level.EngineVersion) < 436)
	{
		C.AddString(" ");
		C.AddString("You currently have UT version"@Level.EngineVersion$"!");
		C.AddString("In order to play on this server, you must have version 436 or greater!");
		C.AddString("To download newest patch, go to: http://unreal.epicgames.com/Downloads.htm");
	}

	C.bQuickKeyEnable = True;
	C.LaunchUWindow();
	C.ShowConsole();
}

simulated function String GetItemName( string FullName )	// Originally not Simulated .. wtf!
{
	local int pos;

	pos = InStr(FullName, ".");
	While ( pos != -1 )
	{
		FullName = Right(FullName, Len(FullName) - pos - 1);
		pos = InStr(FullName, ".");
	}

	return FullName;
}

static function bool SetSkinElement(Actor SkinActor, int SkinNo, string SkinName, string DefaultSkinName)
{
local Texture NewSkin;
local bool bProscribed;
local string pkg, SkinItem, MeshName;

	if ( (SkinActor.Level.NetMode != NM_Standalone)	&& (SkinActor.Level.NetMode != NM_Client) && (DefaultSkinName != "") )
	{
		// make sure that an illegal skin package is not used
		// ignore if already have skins set
		if ( SkinActor.Mesh != None )
			MeshName = SkinActor.GetItemName(string(SkinActor.Mesh));
		else
			MeshName = SkinActor.GetItemName(string(SkinActor.Default.Mesh));
		SkinItem = SkinActor.GetItemName(SkinName);
		pkg = Left(SkinName, Len(SkinName) - Len(SkinItem) - 1);
		bProscribed = !xxValidSP(SkinName, MeshName, SkinActor);
		if ( bProscribed )
			log("Attempted to use illegal skin from package "$pkg$" for "$MeshName);
	}

	NewSkin = Texture(DynamicLoadObject(SkinName, class'Texture'));
	if ( !bProscribed && (NewSkin != None) )
	{
		SkinActor.Multiskins[SkinNo] = NewSkin;
		return True;
	}
	else
	{
		log("Failed to load "$SkinName$" so load "$DefaultSkinName);
		if(DefaultSkinName != "")
		{
			NewSkin = Texture(DynamicLoadObject(DefaultSkinName, class'Texture'));
			SkinActor.Multiskins[SkinNo] = NewSkin;
		}
		return False;
	}
}

static function string xxGetClass(string zzClassname)
{
	local string zzcls;
	local int zzP;

	zzcls = Caps(zzClassname);
	zzP = instr(zzcls,".");
	return left(zzcls,zzP);
}

static function bool xxValidSP(string zzSkinName, string zzMeshName, optional Actor SkinActor)
{
	local int XC_Version;
	local string zzPackName;

	zzPackName = xxGetClass(zzSkinName);

	//Attempt to use XC_Engine natives
   if ( bbPlayer(SkinActor) != none && SkinActor.Role == ROLE_Authority )
   {
	  XC_Version = int(SkinActor.ConsoleCommand("get ini:Unreali.SkaarjPlayer XC_Version"));
	  if ( XC_Version >= 13 )
	  {
		 if ( !bbPlayer(SkinActor).IsInPackageMap( zzPackName, true) )
			return false;
		 return (Left(zzPackName, Len(zzMeshName)) ~= zzMeshName && !(Right(zzSkinName,2) ~= "t_"));
	  }
   }
	//Extra pass before potentially crash code
	if ( zzPackName ~= "BOTPACK" || zzPackName ~= "UNREALI" || zzPackName ~= "UNREALSHARE")
		return false;
	if (Default.zzMyPacks == "")
		Default.zzMyPacks = Caps(SkinActor.ConsoleCommand("get ini:engine.engine.gameengine serverpackages")); //Can still crash a server

	if ( Instr(Default.zzMyPacks, Chr(34)$zzPackName$Chr(34)) == -1 )
		return false;
	return (Left(zzPackName, Len(zzMeshName)) ~= zzMeshName && !(Right(zzSkinName,2) ~= "t_"));
}

function xxClientSet(string zzS)
{
	if (!zzbDemoPlayback)
		zzInfoThing.ConsoleCommand(zzS);
}

simulated function xxClientDoEndShot()
{
	if (Settings.bDoEndShot)
	{
		bShowScores = True;
		zzbDoScreenshot = True;
	}
}

// Try to set the pause state; returns success indicator.
function bool SetPause( BOOL bPause )
{	// Added to avoid accessed nones in demos
	if (Level.Game != None)
		return Level.Game.SetPause(bPause, self);
	return false;
}

function SetVoice(class<ChallengeVoicePack> V)
{
	zzDelayedVoice = V;
	zzDelayedStartTime = Level.TimeSeconds;
}

function ServerSetVoice(class<ChallengeVoicePack> V)
{
	if (Level.TimeSeconds - zzDelayedStartTime > 2.5)
	{
		PlayerReplicationInfo.VoiceType = V;
		zzDelayedStartTime = Level.TimeSeconds;
	}
	else
		zzKickReady++;
}

// Send a voice message of a certain type to a certain player.
exec function Speech( int Type, int Index, int Callsign )
{
	local VoicePack V;

	if (Level.TimeSeconds - zzLastSpeech > 1.0)
	{
		V = Spawn( PlayerReplicationInfo.VoiceType, Self );
		if (V != None)
			V.PlayerSpeech( Type, Index, Callsign );
		zzLastSpeech = Level.TimeSeconds;
	}
	else
		zzKickReady++;
}

exec function ViewPlayerNum(optional int num)
{
	if (zzLastView != Level.TimeSeconds)
	{
		DoViewPlayerNum(num);
		zzLastView = Level.TimeSeconds;
	}
}

function DoViewPlayerNum(int num)
{
	local Pawn P;

	if ( !PlayerReplicationInfo.bIsSpectator && !Level.Game.bTeamGame )
		return;
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
			if ( (P.PlayerReplicationInfo != None) && (P.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team)
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
	if (zzLastView != Level.TimeSeconds)
	{
		Super.ViewPlayer(S);
		zzLastView = Level.TimeSeconds;
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

exec function BehindView( Bool B )
{
	if (Class'UTPure'.Default.bAllowBehindView)
		bBehindView = B;
	else if (ViewTarget != None && ViewTarget != Self)
		bBehindView = B;
	else
		bBehindView = False;
}

// Wiped due to lack of unusefulness
exec function ShowPath();

exec function ShowInventory();

exec function ToggleInstantRocket()
{
	bInstantRocket = !bInstantRocket;
	ServerSetInstantRocket(bInstantRocket);
	ClientMessage("Instant Rockets :"@bInstantRocket);
}

exec function ShowStats(optional byte zzType)
{
}

function AttachStats(PureStats zzS, PureStatMutator zzM)
{
	zzStat = zzS;
	zzStatMut = zzM;
}

function PureStats GetStats()
{
	return zzStat;
}

exec function NeverSwitchOnPickup( bool B )
{
	bNeverAutoSwitch = B;
	bNeverSwitchOnPickup = B;
	ServerNeverSwitchOnPickup(B);
}

// Administrator functions
exec function Admin( string CommandLine )
{
	local string Result;
	if( bAdmin )
		Result = ConsoleCommand( CommandLine );

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
		zzUTPure.xxLog("Admin is"@PlayerReplicationInfo.PlayerName);
	}
	else if (zzAdminLoginTries == 5)
		xxServerCheater("AL");
}

exec function AdminLogout()
{
	Level.Game.AdminLogout( Self );
	zzUTPure.xxLog("Admin was"@PlayerReplicationInfo.PlayerName);
}


exec function Sens(float F)
{
	UpdateSensitivity(F);
	ClientMessage("Sensitivity :"@F);
}

exec function ForceModels(bool b)
{

	/**
	 * @Author: spect
	 * @Date: 2020-02-21 02:28:03
	 * @Desc: Console command to force models client side
	 */

	Settings.bForceModels = b;
	xxServerSetForceModels(b);
	Settings.SaveConfig();
	ClientMessage("ForceModels :"@b);
	if (!b) {
		ClientMessage("You will be reconnected in 3 seconds...");
		SetTimer(5, false);
		bReason = 1;
	}
}

simulated function reconnectClient() {
	ConsoleCommand("disconnect");
	ConsoleCommand("reconnect");
}

exec function TeamInfo(bool b)
{
	Settings.bTeamInfo = b;
	xxServerSetTeamInfo(b);
	Settings.SaveConfig();
	ClientMessage("TeamInfo :"@b);
}

exec function mdct( float f )
{
	SetMinDodgeClickTime(f);
}

exec function SetMinDodgeClickTime( float f )
{
	Settings.MinDodgeClickTime = f;
	Settings.SaveConfig();
	ClientMessage("MinDodgeClickTime:"@f);
}

exec function SetMouseSmoothing(bool b)
{
	Settings.bNoSmoothing = !b;
	Settings.SaveConfig();
	if (b) ClientMessage("Mouse Smoothing enabled!");
	else   ClientMessage("Mouse Smoothing disabled!");
}

function xxServerSetForceModels(bool b)
{
	local int zzPureSetting;

	if (zzUTPure != None)
		zzPureSetting = zzUTPure.ForceModels;

	if (zzPureSetting == 2)			// Server Forces all clients
		zzbForceModels = True;
	else if (zzPureSetting == 1)		// Server allows client to select
		zzbForceModels = b;
	else					// Server always disallows
		zzbForceModels = False;
}

function xxServerSetTeamInfo(bool b)
{
	if (zzUTPure != None && zzUTPure.ImprovedHUD > 0)
	{
		if (b)				// Show team info as well if server allows
			HUDInfo = zzUTPure.ImprovedHUD;
		else				// Show improved hud. (Forced by server)
			HUDInfo = 1;
	}
	else
		HUDInfo = 0;
}

function xxServerSetMinDodgeClickTime(float f)
{
	Settings.MinDodgeClickTime = f;
}

exec function SetKillCamEnabled(bool b) {
	Settings.bEnableKillCam = b;
	Settings.SaveConfig();
	if (b)
		ClientMessage("KillCam enabled!", 'IGPlus');
	else
		ClientMessage("KillCam disabled!", 'IGPlus');
}

exec function EndShot(optional bool b)
{
	Settings.bDoEndShot = b;
	ClientMessage("Screenshot at end of match:"@b);
	Settings.SaveConfig();
}

exec function Hold()
{
	if (zzUTPure.zzAutoPauser != None)
		zzUTPure.zzAutoPauser.PlayerHold(PlayerReplicationInfo);
}

exec function Go()
{
	if (zzUTPure.zzAutoPauser != None)
		zzUTPure.zzAutoPauser.PlayerGo(PlayerReplicationInfo);
}

function xxServerAckScreenshot(string zzResult, string zzMagic)
{
	local Pawn zzP;
	local PlayerPawn zzPP;

	for (zzP = Level.PawnList; zzP != None; zzP = zzP.NextPawn)
	{
		zzPP = PlayerPawn(zzP);
		if (zzPP != None && zzPP.bAdmin)
			zzPP.ClientMessage(PlayerReplicationInfo.PlayerName@"successfully took screenshot!");
	}
	zzUTPure.xxLog("Screenshot from"@zzPP.PlayerReplicationInfo.PlayerName@"->"@zzResult@"Text"@zzMagicCode@"Valid"@(zzMagic == zzMagicCode));
}

function xxServerReceiveINT(string zzS)
{
	if (zzS == "")
	{
		bRemValid = True;
		Mutate("pir"@zzRemCmd@zzRemResult);
		bRemValid = False;
		zzRemCmd = zzS;
		zzRemResult = zzS;

	}
	else
		zzRemResult = zzRemResult$"("$zzS$")";
}

simulated function xxClientReadINT(string zzClass)
{
	local int zzx;
	local string zzEntry, zzDesc, zzS;

	if (Level.NetMode == NM_DedicatedServer)
	{
		zzRemCmd = "";	// Oooops, no client to receive
		return;		// Dont run on server (in case of disconnect)
	}

	while (zzx < 50)
	{
		GetNextIntDesc( zzClass, zzx, zzEntry, zzDesc);
		if (zzEntry == "")
			break;
		zzx++;
		zzS = zzEntry$","$zzDesc;
		xxServerReceiveINT(zzS);
		xxClientLogToDemo(zzS);
	}
	xxServerReceiveINT("");
}

function xxServerReceiveConsole(string zzS, bool zzbLast)
{
	if (zzbLast)
	{
		bRemValid = True;
		Mutate("pcr"@zzRemCmd@zzRemResult);
		bRemValid = False;
		zzRemCmd = "";
		zzRemResult = "";
	}
	else
		zzRemResult = zzRemResult$zzS;
}

simulated function xxClientConsole(string zzcon, int zzC)
{	// Does a console command, splits up the result, and sends back to server after splitting up
	local int zzx, zzl;
	local string zzS;
	local string zzRes;

	if (Level.NetMode == NM_DedicatedServer)
	{
		zzRemCmd = "";	// Oooops, no client to receive
		return;		// Dont run on server (in case of disconnect)
	}

	zzRes = zzInfoThing.ConsoleCommand(zzcon);

	zzl = Len(zzRes);
	while (zzl > zzx)
	{
		zzS = Mid(zzRes, zzx, zzC);
		xxServerReceiveConsole(zzS, False);
		xxClientLogToDemo(zzS);
		zzx += zzC;
	}
	xxServerReceiveConsole("", True);
}

function xxServerReceiveKeys(string zzIdent, string zzValue, bool zzbBind, bool zzbLast)
{
	if (zzbLast)
	{
		bRemValid = True;
		Mutate("pkr"@zzRemCmd@zzRemResult);
		bRemValid = False;
		zzRemCmd = "";
		zzRemResult = "";
	}
	else
	{
		if (zzbBind)
		{
			zzRemResult = zzRemResult$"A("$zzIdent$"="$zzValue$")";
		}
		else
		{
			zzRemResult = zzRemResult$"B("$zzIdent$"="$zzValue$")";
		}
	}
}

simulated function xxClientKeys(bool zzbKeysToo, string zzPure, string zzPlayer)
{
	local int zzx;
	local string zzS;
	local PureSystem zzPureInput;

	if (Level.NetMode == NM_DedicatedServer)
	{
		zzRemCmd = "";	// Oooops, no client to receive
		return;		// Dont run on server (in case of disconnect)
	}

	SetPropertyText(zzPure$zzPlayer, GetPropertyText(zzPlayer));
	zzPureInput = PurePlayer.zzInput;

	if (zzPureInput != None)
	{
		for (zzx = 0; zzx < 10; zzx++)
		{
			xxSendKeys(string(zzPureInput.zzAliases1[zzx].zzAlias), zzPureInput.zzAliases1[zzx].zzCommand, True, False);
		}
		for (zzx = 0; zzx < 10; zzx++)
		{
			xxSendKeys(string(zzPureInput.zzAliases2[zzx].zzAlias), zzPureInput.zzAliases2[zzx].zzCommand, True, False);
		}
		for (zzx = 0; zzx < 10; zzx++)
		{
			xxSendKeys(string(zzPureInput.zzAliases3[zzx].zzAlias), zzPureInput.zzAliases3[zzx].zzCommand, True, False);
		}
		for (zzx = 0; zzx < 10; zzx++)
		{
			xxSendKeys(string(zzPureInput.zzAliases4[zzx].zzAlias), zzPureInput.zzAliases4[zzx].zzCommand, True, False);
		}
		if (zzbKeysToo)
		{
			for (zzx = 0; zzx < 255; zzx++)
			{
				zzS = Mid(string(GetEnum(Enum'EInputKey', zzx)), 3);
				xxSendKeys(zzS, zzPureInput.zzKeys[zzx], False, False);
			}
		}
	}
	xxServerReceiveKeys("", "", False, True);
}

simulated function xxSendKeys(string zzIdent, string zzValue, bool zzbBind, bool zzbLast)
{
	xxServerReceiveKeys(zzIdent, zzValue, zzbBind, zzbLast);
	xxClientLogToDemo(zzIdent$"="$zzValue);
}

simulated function xxClientLogToDemo(string zzS)
{
	Log(zzS, 'DevGarbage');
}

function xxClientResetPlayer() {
	GoToState('CountdownDying');
}

function ClientReStart()
{
	zzSpawnedTime = Level.TimeSeconds;

	Super.ClientReStart();

	if (PendingTouch != none) {
		PendingTouch.PendingTouch = none;
		PendingTouch = none;
	}

	IgnoreZChangeTicks = 1;
	MultiDodgesRemaining = bbPlayerReplicationInfo(PlayerReplicationInfo).MaxMultiDodges;
}

exec function GetWeapon(class<Weapon> NewWeaponClass )
{	// Slightly improved GetWeapon
	local Inventory Inv;

	if ( (Inventory == None) || (NewWeaponClass == None)
		|| ((Weapon != None) && Weapon.IsA(NewWeaponClass.Name))
		|| IsInState('Dying') )
		return;

	for ( Inv=Inventory; Inv!=None; Inv=Inv.Inventory )
		if ( Inv.IsA(NewWeaponClass.Name) )
		{
			PendingWeapon = Weapon(Inv);
			if ( PendingWeapon != None && (PendingWeapon.AmmoType != None) && (PendingWeapon.AmmoType.AmmoAmount <= 0) )
			{
				Pawn(Owner).ClientMessage( PendingWeapon.ItemName$PendingWeapon.MessageNoAmmo );
				PendingWeapon = None;
				return;
			}
			if (Weapon != None)
				Weapon.PutDown();
			return;
		}
}

exec function SwitchWeapon(byte F)
{
	local weapon newWeapon;

	if ( bShowMenu || Level.Pauser!="" || IsInState('Dying') )
	{
		if ( myHud != None )
			myHud.InputNumber(F);
		return;
	}
	if ( Inventory == None )
		return;
	if ( (Weapon != None) && (Weapon.Inventory != None) )
		newWeapon = Weapon.Inventory.WeaponChange(F);
	else
		newWeapon = None;
	if ( newWeapon == None )
		newWeapon = Inventory.WeaponChange(F);
	if ( newWeapon == None )
		return;

	if ( Weapon != newWeapon )
	{
		PendingWeapon = newWeapon;
		if ( Weapon != None && !Weapon.PutDown() )
			PendingWeapon = None;
	}
}

exec function PrevWeapon()
{
	local int prevGroup;
	local Inventory inv;
	local Weapon realWeapon, w, Prev;
	local bool bFoundWeapon;

	if( bShowMenu || Level.Pauser!="" || IsInState('Dying') )
		return;
	if ( Weapon == None )
	{
		SwitchToBestWeapon();
		return;
	}
	prevGroup = 0;
	realWeapon = Weapon;
	if ( PendingWeapon != None )
		Weapon = PendingWeapon;
	PendingWeapon = None;

	for (inv=Inventory; inv!=None; inv=inv.Inventory)
	{
		w = Weapon(inv);
		if ( w != None )
		{
			if ( w.InventoryGroup == Weapon.InventoryGroup )
			{
				if ( w == Weapon )
				{
					bFoundWeapon = true;
					if ( Prev != None )
					{
						PendingWeapon = Prev;
						break;
					}
				}
				else if ( !bFoundWeapon && ((w.AmmoType == None) || (w.AmmoType.AmmoAmount>0)) )
					Prev = W;
			}
			else if ( (w.InventoryGroup < Weapon.InventoryGroup)
					&& ((w.AmmoType == None) || (w.AmmoType.AmmoAmount>0))
					&& (w.InventoryGroup >= prevGroup) )
			{
				prevGroup = w.InventoryGroup;
				PendingWeapon = w;
			}
		}
	}
	bFoundWeapon = false;
	prevGroup = Weapon.InventoryGroup;
	if ( PendingWeapon == None )
		for (inv=Inventory; inv!=None; inv=inv.Inventory)
		{
			w = Weapon(inv);
			if ( w != None )
			{
				if ( w.InventoryGroup == Weapon.InventoryGroup )
				{
					if ( w == Weapon )
						bFoundWeapon = true;
					else if ( bFoundWeapon && (PendingWeapon == None) && ((w.AmmoType == None) || (w.AmmoType.AmmoAmount>0)) )
						PendingWeapon = W;
				}
				else if ( (w.InventoryGroup > PrevGroup)
						&& ((w.AmmoType == None) || (w.AmmoType.AmmoAmount>0)) )
				{
					prevGroup = w.InventoryGroup;
					PendingWeapon = w;
				}
			}
		}

	Weapon = realWeapon;
	if ( PendingWeapon == None )
		return;

	Weapon.PutDown();
}

exec function NextWeapon()
{
	local int nextGroup;
	local Inventory inv;
	local Weapon realWeapon, w, Prev;
	local bool bFoundWeapon;

	if( bShowMenu || Level.Pauser!="" || IsInState('Dying') )
		return;
	if ( Weapon == None )
	{
		SwitchToBestWeapon();
		return;
	}
	nextGroup = 100;
	realWeapon = Weapon;
	if ( PendingWeapon != None )
		Weapon = PendingWeapon;
	PendingWeapon = None;

	for (inv=Inventory; inv!=None; inv=inv.Inventory)
	{
		w = Weapon(inv);
		if ( w != None )
		{
			if ( w.InventoryGroup == Weapon.InventoryGroup )
			{
				if ( w == Weapon )
					bFoundWeapon = true;
				else if ( bFoundWeapon && ((w.AmmoType == None) || (w.AmmoType.AmmoAmount>0)) )
				{
					PendingWeapon = W;
					break;
				}
			}
			else if ( (w.InventoryGroup > Weapon.InventoryGroup)
					&& ((w.AmmoType == None) || (w.AmmoType.AmmoAmount>0))
					&& (w.InventoryGroup < nextGroup) )
			{
				nextGroup = w.InventoryGroup;
				PendingWeapon = w;
			}
		}
	}

	bFoundWeapon = false;
	nextGroup = Weapon.InventoryGroup;
	if ( PendingWeapon == None )
		for (inv=Inventory; inv!=None; inv=inv.Inventory)
		{
			w = Weapon(Inv);
			if ( w != None )
			{
				if ( w.InventoryGroup == Weapon.InventoryGroup )
				{
					if ( w == Weapon )
					{
						bFoundWeapon = true;
						if ( Prev != None )
							PendingWeapon = Prev;
					}
					else if ( !bFoundWeapon && (PendingWeapon == None) && ((w.AmmoType == None) || (w.AmmoType.AmmoAmount>0)) )
						Prev = W;
				}
				else if ( (w.InventoryGroup < nextGroup)
					&& ((w.AmmoType == None) || (w.AmmoType.AmmoAmount>0)) )
				{
					nextGroup = w.InventoryGroup;
					PendingWeapon = w;
				}
			}
		}

	Weapon = realWeapon;
	if ( PendingWeapon == None )
		return;

	Weapon.PutDown();
}

exec function bool SwitchToBestWeapon()
{
	local float rating;
	local int usealt;

	if (Inventory == None)
		return false;

	if (PendingWeapon == None)
		PendingWeapon = Inventory.RecommendWeapon(rating, usealt);

	if ( PendingWeapon == Weapon )
		PendingWeapon = None;
	if ( PendingWeapon == None )
		return false;

	if ( Weapon == None )
	{
		ChangedWeapon();
		return false;
	}

	if ( Weapon != PendingWeapon )
		Weapon.PutDown();
	return (usealt > 0);
}

simulated function ChangedWeapon()
{
	if (Weapon != None && bUseFastWeaponSwitch)
	{
		Weapon.GotoState('');
		ClientPutDown(none, PendingWeapon);
	}
	Super.ChangedWeapon();
}

function ClientPutDown(Weapon Current, Weapon Next)
{
	if ( Role == ROLE_Authority )
		return;
	bNeedActivate = false;
	if ( (Current != None) && (Current != Next) )
		Current.ClientPutDown(Next);
	else if ( Weapon != None )
	{
		if ( Weapon != Next )
			Weapon.ClientPutDown(Next);
		else
		{
			bNeedActivate = false;
			ClientPending = None;
			if ( Weapon.IsInState('ClientDown') || !Weapon.IsAnimating() )
			{
				Weapon.GotoState('');
				Weapon.TweenToStill();
			}
		}
	}
}

exec function Say(string Msg) {
	if (Msg ~= "r" ||
		Msg ~= "rdy" ||
		Msg ~= "ready" ||
		Msg ~= "!rdy" ||
		Msg ~= "!ready"
	) {
		Ready();
	}
	super.Say(Msg);
}

//enhanced teamsay:
exec function TeamSay( string Msg )
{
	local string OutMsg;
	local string cmd;
	local int pos, zzi;
	local int ArmorAmount;
	local inventory inv;

	local int x;
	local int zone;  // 0=Offense, 1 = Defense, 2= float
	local flagbase Red_FB, Blue_FB;
	local CTFFlag F,Red_F, Blue_F;
	local float dRed_b, dBlue_b, dRed_f, dBlue_f;

	if (!Class'UTPure'.Default.bAdvancedTeamSay || PlayerReplicationInfo.Team == 255) {
		Super.TeamSay(Msg);
		return;
	}

	pos = InStr(Msg, "%");
	while (pos >= 0) {
		if (pos > 0) {
			OutMsg = OutMsg$Left(Msg,pos);
			Msg = Mid(Msg,pos);
			pos = 0;
		}

		x = len(Msg);
		if (x >= 2) {
			cmd = Left(Msg, 2);
			Msg = Right(Msg,x-2);
		} else {
			OutMsg = OutMsg$Msg;
			Msg = "";
			continue;
		}

		if (cmd == "%H") {
			OutMsg = OutMsg$Health$" Health";
		} else if (cmd == "%h") {
			OutMsg = OutMsg$Health$"%";
		} else if (cmd ~= "%W") {
			if (Weapon == None)
				OutMsg = OutMsg$"Empty hands";
			else
				OutMsg = OutMsg$Weapon.GetHumanName();
		} else if (cmd == "%A") {
			ArmorAmount = 0;
			for( Inv=Inventory; Inv != None; Inv = Inv.Inventory ) {
				if (Inv.bIsAnArmor) {
					if ( Inv.IsA('UT_Shieldbelt') )
						OutMsg = OutMsg$Inv.Charge@"Shieldbelt and ";
					else
						ArmorAmount += Inv.Charge;
				}
			}
			OutMsg = OutMsg$ArmorAmount$" Armor";
		} else if (cmd == "%a") {
			ArmorAmount = 0;
			for( Inv=Inventory; Inv != None; Inv = Inv.Inventory ) {
				if (Inv.bIsAnArmor) {
					if ( Inv.IsA('UT_Shieldbelt') )
						OutMsg = OutMsg$Inv.Charge$"SB ";
					else
						ArmorAmount += Inv.Charge;
				}
			}
			OutMsg = OutMsg$ArmorAmount$"A";
		} else if (cmd ~= "%P" && GameReplicationInfo.IsA('CTFReplicationInfo')) {
			// CTF only
			// Figure out Posture.

			for (zzi=0; zzi < 4; zzi++) {
				f = CTFReplicationInfo(GameReplicationInfo).FlagList[zzi];
				if (f == None)
					break;
				if (F.HomeBase.Team == 0)
					Red_FB = F.HomeBase;
				else if (F.HomeBase.Team == 1)
					Blue_FB = F.HomeBase;
				if (F.Team == 0)
					Red_F = F;
				else if (F.Team == 1)
					Blue_F = F;
			}

			dRed_b = VSize(Location - Red_FB.Location);
			dBlue_b = VSize(Location - Blue_FB.Location);
			dRed_f = VSize(Location - Red_F.Position().Location);
			dBlue_f = VSize(Location - Blue_F.Position().Location);

			if (PlayerReplicationInfo.Team == 0) {
				if (dRed_f < 2048 && Red_F.Holder != None && (Blue_f.Holder == None || dRed_f < dBlue_f))
					zone = 0;
				else if (dBlue_f < 2048 && Blue_F.Holder != None && (Red_f.Holder == None || dRed_f > dBlue_f))
					zone = 1;
				else if (dBlue_b < 2049)
					zone = 2;
				else if (dRed_b < 2048)
					zone = 3;
				else
					zone = 4;
			} else if (PlayerReplicationInfo.Team == 1) {
				if (dBlue_f < 2048 && Blue_f.Holder != None && (Red_f.Holder == None || dRed_f >= dBlue_f))
					zone = 0;
				else if (dRed_f < 2048 && Red_f.Holder != None && (Blue_f.Holder == None || dRed_f < dBlue_f))
					zone = 1;
				else if (dRed_b < 2048)
					zone = 2;
				else if (dBlue_b < 2048)
					zone = 3;
				else
					zone = 4;
			}

			if ( (Blue_f.Holder == Self) || (Red_f.Holder == Self) )
				zone = 5;

			Switch(zone) {
				Case 0:	OutMsg = OutMsg$"Attacking Enemy Flag Carrier";
					break;
				Case 1: OutMsg = OutMsg$"Supporting Our Flag Carrier";
					break;
				Case 2: OutMsg = OutMsg$"Attacking";
					break;
				Case 3: OutMsg = OutMsg$"Defending";
					break;
				Case 4: OutMsg = OutMsg$"Floating";
					break;
				Case 5: OutMsg = OutMsg$"Carrying Flag";
					break;
			}
		} else if (cmd == "%%") {
			OutMsg = OutMsg$"%";
		} else {
			OutMsg = OutMsg$cmd;
		}

		pos = InStr(Msg, "%");
	}

	OutMsg = OutMsg$Msg;

	Super.TeamSay(OutMsg);
}

function Typing( bool bTyping )
{
	bIsTyping = bTyping;
	if (bTyping)
	{
		PlayChatting();
	}
}

////////////////////////////
// Tracebot stopper: By DB
////////////////////////////

function bool xxCanFire()
{
	return true;
}

function xxCleanAvars()
{
	aMouseX = zzNull;
	aMouseY = zzNull;
	aTurn = zzNull;
	aUp = zzNull;
}

simulated function xxGetDemoPlaybackSpec()
{
	local Pawn P;

	if (zzbGotDemoPlaybackSpec)
		return;
	zzbGotDemoPlaybackSpec = true;

	for ( P=Level.PawnList; P!=None; P=P.NextPawn )
		if (Caps(string(P.Class.Name)) == "DEMOPLAYBACKSPEC")
			zzDemoPlaybackSpec = CHSpectator(P);

	if (zzDemoPlaybackSpec != None)
		zzDemoPlaybackSN = zzDemoPlaybackSpec.Spawn(class'bbClientDemoSN', zzDemoPlaybackSpec);

}

simulated function xxClientDemoFix(Actor zzA, class<Actor> C, Vector L, optional Vector V, optional vector A, optional Rotator R, optional float DS, optional Actor S)
{
	xxGetDemoPlaybackSpec();
	if (zzDemoPlaybackSpec == none)
		return;

	if (zzA == None)
	{
		zzDemoPlaybackSN.xxFixActor(C, L, V, A, R, DS, S);
		return;
	}

	zzA.Velocity = V;
	zzA.Acceleration = A;
	zzA.SetRotation(R);
	if(DS != 0)
		zzA.DrawScale = DS;
	if((S != none) && UT_SeekingRocket(zzA) != none)
		UT_SeekingRocket(zzA).Seeking = S;

}

simulated function xxClientDemoBolt(Actor A, optional Vector V, optional Rotator R, optional Vector X, optional float Delta)
{
	xxGetDemoPlaybackSpec();
	if (A == none)
		return;
	A.SetLocation(V);
	A.SetRotation(R);
	PBolt(A).CheckBeam(X, Delta);
}

function string xxFindClanTags() {
	local PlayerReplicationInfo PRI;
	local string PrefixTags[4];
	local string SuffixTags[4];
	local string Tags[4];
	local int TeamSize[4];
	local int MaxTeams;
	local int Team;
	local int MixCount;
	local string Result;

	if (GameReplicationInfo.bTeamGame == false)
		return "FFA";

	foreach AllActors(class'PlayerReplicationInfo', PRI) {
		if (PRI.bIsSpectator == true || PRI.bIsABot == true)
			continue;

		if (TeamSize[PRI.Team] == 0) {
			PrefixTags[PRI.Team] = PRI.PlayerName;
			SuffixTags[PRI.Team] = PRI.PlayerName;
		} else {
			PrefixTags[PRI.Team] = class'StringUtils'.static.CommonPrefix(PrefixTags[PRI.Team], PRI.PlayerName);
			SuffixTags[PRI.Team] = class'StringUtils'.static.CommonSuffix(SuffixTags[PRI.Team], PRI.PlayerName);
		}

		++TeamSize[PRI.Team];
	}

	for (MaxTeams = 0; MaxTeams < 4; ++MaxTeams)
		if (TeamSize[MaxTeams] == 0)
			break;

	for (Team = 0; Team < MaxTeams; ++Team) {
		Tags[Team] = class'StringUtils'.static.MergeAffixes(PrefixTags[Team], SuffixTags[Team]);
		if (Len(Tags[Team]) == 0) {
			Tags[Team] = "Mix";
			++MixCount;
		}
	}

	if (MaxTeams <= 1 || MixCount > 1)
		return "Unknown";

	Result = Tags[0];
	for (Team = 1; Team < MaxTeams; ++Team)
		Result = Result$"_"$Tags[Team];

	return xxFixFileName(Result, Settings.DemoChar);
}


function string xxFixFileName(string zzS, string zzReplaceChar)
{
	local int zzx;
	local string zzs2,zzs3;

	zzs3 = "";
	for (zzx = 0; zzx < Len(zzS); zzx++)
	{
		zzs2 = Mid(zzS,zzx,1);
		if (asc(zzs2) < 32 || asc(zzs2) > 128)
			zzs2 = zzReplaceChar;
		else
		{
			switch(zzs2)
			{
				Case "|":
				Case ".":
				Case ":":
				Case "%":
				Case "\\":
				Case "/":
				Case "*":
				Case "?":
				Case ">":
				Case "<":
				Case "(":	//
				Case ")":	//
				Case "`":	//
				Case "'":	//
				Case "�":	//
				Case "&":	// Weak Linux, Weak
				Case " ":	zzs2 = zzReplaceChar;
						break;
			}
		}
		zzs3 = zzs3$zzs2;
	}
	return zzs3;
}

function string PadNumberToTwoDigits(int Val) {
	if (Val < 10)
		return "0"$string(Val);
	else
		return string(Val);
}

function string xxCreateDemoName(string zzDemoName)
{
	local int zzx;
	local string zzS;
	local string result;

	if (zzDemoName == "")
		zzDemoName = "%l_[%y_%m_%d_%t]_[%c]_%e";	// Incase admin messes up :/

	while(true) {
		zzx = InStr(zzDemoName, "%");
		if (zzx < 0) break;

		zzS = Mid(zzDemoName,zzx+1,1);
		switch(Caps(zzS)) {
			case "E":
				zzS = string(Level);
				zzS = Left(zzS,InStr(zzS,"."));
				break;
			case "F":
				zzS = Level.Title;
				break;
			case "D":
				zzS = PadNumberToTwoDigits(Level.Day);
				break;
			case "M":
				zzS = PadNumberToTwoDigits(Level.Month);
				break;
			case "Y":
				zzS = string(Level.Year);
				break;
			case "H":
				zzS = PadNumberToTwoDigits(Level.Hour);
				break;
			case "N":
				zzS = PadNumberToTwoDigits(Level.Minute);
				break;
			case "T":
				zzS = PadNumberToTwoDigits(Level.Hour) $ PadNumberToTwoDigits(Level.Minute);
				break;
			case "C":	// Try to find 2 unique tags within the 2 teams. If only 2 players exists, add their names.
				zzS = xxFindClanTags();
				break;
			case "L":
				zzS = PlayerReplicationInfo.PlayerName;
				break;
			case "%":
				break;
			default:
				zzS = "%"$zzS;
				break;
		}
		result = result $ Left(zzDemoName, zzx) $ zzS;
		zzDemoName = Mid(zzDemoName, zzx + 2);
	}

	return Settings.DemoPath $ xxFixFileName(result $ zzDemoName, Settings.DemoChar);
}

exec function AutoDemo(bool zzb)
{
	Settings.bAutoDemo = zzb;
	ClientMessage("Record demos automatically after countdown:"@zzb);
	Settings.SaveConfig();
}

exec function ShootDead()
{
	Settings.bShootDead = !Settings.bShootDead;
	if (Settings.bShootDead)
		ClientMessage("Shooting carcasses enabled.");
	else
		ClientMessage("Shooting carcasses disabled.");
	Settings.SaveConfig();
}

exec function SetDemoMask(optional string zzMask)
{
	if (zzMask != "")
	{
		Settings.DemoMask = zzMask;
		Settings.SaveConfig();
	}

	ClientMessage("Current demo mask:"@Settings.DemoMask);
}

exec function DemoStart()
{
	if (zzbDemoRecording)
	{
		ClientMessage("Already recording!");
		return;
	}

	xxClientDemoRec();
}

simulated function xxClientDemoRec()
{
	local string zzS;

	zzS = ConsoleCommand("DemoRec"@xxCreateDemoName(Settings.DemoMask));
	ClientMessage(zzS);
	if (zzbForceDemo)
		xxServerDemoReply(zzS);
}

function xxSetNetUpdateRate(float NewVal, int netspeed) {
	local float max;
	max = FMin(class'UTPure'.default.MaxNetUpdateRate, netspeed/100.0);
	TimeBetweenNetUpdates = 1.0 / FClamp(NewVal, class'UTPure'.default.MinNetUpdateRate, max);
}

exec function SetNetUpdateRate(float NewVal) {
	Settings.DesiredNetUpdateRate = NewVal;
	xxSetNetUpdateRate(NewVal, Player.CurrentNetSpeed);
	Settings.SaveConfig();
}

function xxServerDemoReply(string zzS)
{
	zzUTPure.xxLog("Forced Demo:"@PlayerReplicationInfo.PlayerName@zzS);
}

function xxExplodeOther(Projectile Other)
{
	if (Other != None)
		Other.Explode(Other.Location, Normal(Location-Other.Location));
}

exec function DropFlag() {
	local Decoration Flag;
	if (PlayerReplicationInfo.HasFlag != none) {
		Flag = PlayerReplicationInfo.HasFlag;
		Flag.Drop(Velocity + 10 * VRand());
		Flag.SetLocation(Location + Normal(Velocity) * -60.0);
	}
}

function DoJump( optional float F )
{
	local UT_JumpBoots zzBoots;

	if ( CarriedDecoration != None )
		return;

	if (Level.NetMode == NM_Client)
	{
		zzBoots = UT_JumpBoots(FindInventoryType(class'UT_JumpBoots'));
		if (zzBoots != None && zzBoots.Charge <= 0)
			JumpZ = Default.JumpZ;
	}

	if ( !bIsCrouching && (Physics == PHYS_Walking) )
	{
		if ( !bUpdating )
			PlayOwnedSound(JumpSound, SLOT_None, 1.5, true, 1200, 1.0 );
		if ( (Level.Game != None) && (Level.Game.Difficulty > 0) )
			MakeNoise(0.1 * Level.Game.Difficulty);
		PlayInAir();
		if ( bCountJumps && (Role == ROLE_Authority) && (Inventory != None) )
			Inventory.OwnerJumped();
		if ( bIsWalking )
			Velocity.Z = Default.JumpZ;
		else
			Velocity.Z = JumpZ;
		if ( (Base != Level) && (Base != None) )
			Velocity.Z += Base.Velocity.Z;
		SetPhysics(PHYS_Falling);
	}
}

function PlayInAir() {
	local vector X,Y,Z, Dir;
	local float f, TweenTime;

	if ( (GetAnimGroup(AnimSequence) == 'Landing') && !bLastJumpAlt )
	{
		GetAxes(Rotation, X,Y,Z);
		Dir = Normal(Acceleration);
		f = Dir dot Y;
		if ( f > 0.7 )
			TweenAnim('DodgeL', 0.35);
		else if ( f < -0.7 )
			TweenAnim('DodgeR', 0.35);
		else if ( Dir dot X > 0 )
			TweenAnim('DodgeF', 0.35);
		else
			TweenAnim('DodgeB', 0.35);
		bLastJumpAlt = true;
		return;
	}
	bLastJumpAlt = false;
	if ( GetAnimGroup(AnimSequence) == 'Jumping' )
	{
		if ( (Weapon == None) || (Weapon.Mass < 20) )
			TweenAnim('DuckWlkS', 2);
		else
			TweenAnim('DuckWlkL', 2);
		return;
	}
	else if ( GetAnimGroup(AnimSequence) == 'Ducking' )
		TweenTime = 2;
	else
		TweenTime = 0.7;

	if ( AnimSequence == 'StrafeL' )
		TweenAnim('DodgeR', TweenTime);
	else if ( AnimSequence == 'StrafeR' )
		TweenAnim('DodgeL', TweenTime);
	else if ( AnimSequence == 'BackRun' )
		TweenAnim('DodgeB', TweenTime);
	else if ( (Weapon == None) || (Weapon.Mass < 20) )
		TweenAnim('JumpSMFR', TweenTime);
	else
		TweenAnim('JumpLGFR', TweenTime);
}

exec function ShowOwnBeam() {
	Settings.bHideOwnBeam = !Settings.bHideOwnBeam;
	Settings.SaveConfig();
	if (Settings.bHideOwnBeam)
		ClientMessage("Own beam hidden!", 'IGPlus');
	else
		ClientMessage("Own beam shown!", 'IGPlus');
}

function ClientShake(vector shake) {
	if (Settings.bAllowWeaponShake)
		super.ClientShake(shake);
}

function string GetReadyMessage() {
	if (Level.Game.IsA('DeathMatchPlus'))
		return DeathMatchPlus(Level.Game).ReadyMessage;

	return class'DeathMatchPlus'.default.ReadyMessage;
}

function string GetNotReadyMessage() {
	if (Level.Game.IsA('DeathMatchPlus'))
		return DeathMatchPlus(Level.Game).NotReadyMessage;

	return class'DeathMatchPlus'.default.NotReadyMessage;
}

exec function Ready() {
	bReadyToPlay = !bReadyToPlay;
	if (bReadyToPlay)
		ClientMessage(GetReadyMessage());
	else
		ClientMessage(GetNotReadyMessage());
}

exec function TestHitMarker(optional int Dmg) {
	HitMarkerTestDamage = Dmg;
}

exec function TestHitSound(optional int Dmg) {
	class'bbPlayerStatics'.static.PlayHitSound(self, Settings, Dmg, PlayerReplicationInfo.Team, HitMarkerTestTeam);
	HitMarkerTestTeam += 1;
	if (HitMarkerTestTeam >= 4)
		HitMarkerTestTeam = 0;
}

defaultproperties
{
	bAlwaysRelevant=True
	bNewNet=True
	HUDInfo=1
	TeleRadius=210
	NN_ProjLength=256
	bIsFinishedLoading=False
	bDrawDebugData=False
	TimeBetweenNetUpdates=0.01
	FakeCAPInterval=0.1
	DodgeSpeedXY=600
	DodgeSpeedZ=210
	SecondaryDodgeSpeedXY=500
	SecondaryDodgeSpeedZ=180
	DodgeEndVelocity=0.1
	JumpEndVelocity=1.0
	DuckTransitionTime=0.25
	LastWeaponEffectCreated=-1
	RespawnDelay=1.0
	PlayerReplicationInfoClass=Class'bbPlayerReplicationInfo'
}
