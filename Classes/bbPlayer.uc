/**
 * @Author: TimTim
 * @Extended by: spect
 * @Class: bbPlayer
 * @Date: 2020-02-16 01:54:19
 * @Desc: The bread and butter of UT99 NewNet
 */

class bbPlayer extends TournamentPlayer
	config(User) abstract;

var int bReason;
// Client Config
//var globalconfig bool bNewNet;	// if Client wants new or old netcode. (default true)
var bool bNewNet;	// if Client wants new or old netcode. (default true)
var globalconfig bool bNoRevert;	// if Client does not want the Revert to Previous Weapon option on Translocator. (default true)
var globalconfig bool bForceModels;	// if Client wishes models forced to his own. (default false)
var globalconfig int HitSound;	// if Client wishes hitsounds (default 2, must be enabled on server)
var globalconfig int TeamHitSound;	// if Client wishes team hitsounds (default 3, must be enabled on server)
var globalconfig bool bDisableForceHitSounds;
var globalconfig bool bTeamInfo;	// if Client wants extra team info.
var globalconfig bool bDoEndShot;	// if Client wants Screenshot at end of match.
var globalconfig bool bAutoDemo;		// if Client wants demo or not.
var globalconfig bool bShootDead;		// if Client wants demo or not.
var globalconfig bool bNoDeemerToIG;
var globalconfig bool bNoSwitchWeapon4;
var globalconfig string DemoMask;	// The options for creating demo filename.
var globalconfig string DemoPath;	// The path for creating the demo.
var globalconfig string DemoChar;	// Character to use instead of illegal ones.
var globalconfig int desiredSkin;
var globalConfig int desiredTeamSkin;
var globalconfig bool bEnableHitSounds;
var globalconfig int selectedHitSound;
var globalconfig string sHitSound[16];
var globalconfig int cShockBeam;
var globalconfig float BeamScale;
var globalconfig int BeamOriginMode;
var globalconfig float DesiredNetUpdateRate;
var Sound playedHitSound;
var(Sounds) Sound cHitSound[16];

// Replicated settings Client -> Server
var bool	zzbConsoleInvalid;	// Should always be false on server.
var bool	zzbStoppingTraceBot;	// True while stopping Trace Bot
var int		zzNetspeed;		// The netspeed this client is using
var bool	zzbForcedTick;		// True on server if Tick was forced (Called more than once)
var bool	zzbBadCanvas;		// True on server if Canvas is NOT engine.canvas
var bool	zzbVRChanged;		// True on server if client changed viewrotation at wrong time.
var bool	zzbDemoRecording;	// True if client is recording demos.
var bool	zzbBadLighting;		// True if Lighting is not good on client (HAX!)
var float	zzClientTD;		// Client TimeDilation (Should always be same as server or HAX!)
var string defaultSkin;
var string defaultFace;
var bool bIsFinishedLoading;

// Replicated settings Server -> Client
var int		zzTrackFOV;		// Track FOV ?
var bool	zzCVDeny;		// Deny CenterView ?
var float	zzCVDelay;		// Delay for CenterView usage
var int		zzMinimumNetspeed;	// Default 1000, it's the minimum netspeed a client may have.
var float	zzWaitTime;		// Used for diverse waiting.
//var bool	zzbWeaponTracer;	// True if current weapon is a tracer!
var int		zzForceSettingsLevel;	// The Anti-Default/Ini check force.
var bool	zzbForceModels;		// Allow/Enable/Force Models for clients.
var bool	zzbForceDemo;		// Set true by server to force client to do demo.
var bool	zzbGameStarted;	// Set to true when Pawn spawns first time (ModifyPlayer)
var bool	zzbUsingTranslocator;
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

// Control stuff
var byte	zzbFire;		// Retain last fire value
var byte	zzbAltFire;		// Retain last Alt Fire Value
var bool	zzbValidFire;		// Tells when Fire() is valid
var bool	zzShowClick;		// Show Click Status
var bool	zzbDonePreRender;	// True between PreRender & PostRender
var PureInfo	zzInfoThing;	// Registers diverse stuff.
var float	zzTick;			// The Length of Last Tick
var bool	zzbNoMultiWeapon;	// Server-Side only! tells if multiweapon bug can be used.
var int     zzThrowVelocity;
var bool	zzbDemoPlayback;	// Is currently a demo playback (via xxServerMove detection)
var bool	zzbGotDemoPlaybackSpec;
var CHSpectator zzDemoPlaybackSpec;
var bbClientDemoSN zzDemoPlaybackSN;
var bool zzbRestartedPlayer;
var bool bIsAlive;
var bool zzbJustConnected;

// Stuff
var rotator	zzViewRotation;		// Our special View Rotation
var rotator	zzLastVR;		// The rotation after previous input.
var float	zzDesiredFOV;		// Needed ?
var float	zzOrigFOV;		// Original FOV for TrackFOV = 1
var string	FakeClass;		// Class that the model replaces
var string	zzMyPacks;		// Defined only for defaults
var bool	zzbBadGuy;		// BadGuy! (Avoid kick spamming)
var int		zzOldForceSettingsLevel;	// Kept to see if things change.
var bool	zzbNN_ForceFire, zzbNN_ForceAltFire;	// Enable FWS for all weapons.
var float  	zzThrownTime, zzSwitchedTime;
var Weapon  zzThrownWeapon;
var int     zzRecentDmgGiven, zzRecentTeamDmgGiven, TeleRadius, PortalRadius, TriggerRadius;
var name    zzDefaultWeapon;
var float   zzLastHitSound, zzLastTeamHitSound;
var float   zzFRandVals[47]; // Let's use a prime number ;)
var vector  zzVRandVals[17]; // Let's use a prime number ;)
var Projectile zzNN_Projectiles[256];
var vector zzNN_ProjLocations[256];
var int     zzFRVI, zzNN_FRVI, FRVI_length, zzVRVI, zzNN_VRVI, VRVI_length, zzNN_ProjIndex, NN_ProjLength, zzEdgeCount, zzCheckedCount;
var rotator zzNN_ViewRot;
var actor   zzNN_HitActor, zzOldBase;
var Vector  zzNN_HitLoc, zzClientHitNormal, zzClientHitLocation, zzNN_HitDiff, zzNN_HitLocLast, zzNN_HitNormalLast, zzNN_ClientLoc, zzNN_ClientVel;
var bool    zzbIsWarmingUp, zzbFakeUpdate, zzbForceUpdate, zzbOnMover, zzbNN_Special, zzbNN_ReleasedFire, zzbNN_ReleasedAltFire;
var float   zzNN_Accuracy, zzLastStuffUpdate, zzNextTimeTime, zzLastFallVelZ, zzLastClientErr, zzForceUpdateUntil, zzIgnoreUpdateUntil, zzLastLocDiff, zzSpawnedTime;
var Teleporter LastPortal, LastPortalDest;
var Trigger zzLastTrigger;
var float LastPortalTime, zzLastTriggerTime;
var TournamentWeapon zzGrappling;
var float zzGrappleTime;
var Weapon zzKilledWithWeapon;
var Pawn zzLastKilled;
var vector zzLast10Positions[10];	// every 50ms for half a second of backtracking
var int zzPositionIndex;
var float zzNextPositionTime;
var bool zzbInitialized;
var int DefaultHitSound, DefaultTeamHitSound;
var float zzAceCheckedTime;
var bool bForceDefaultHitSounds, zzbAceFinish, zzbAceChecked, zzbNN_Tracing;
var int zzAddVelocityCount;
var vector zzExpectedVelocity;
var PlayerStart zzDisabledPS[64];
var int zzNumDisabledPS, zzDisabledPlayerCollision;
var Weapon zzPendingWeapon;
var NavigationPoint zzNextStartSpot;
var string zzKeys[1024], zzAliases[1024], zzActorNames[2048];
var int zzNumActorNames;
var byte zzPressing[1024];
var bool bIsAlpha;
var bool bNewNetIsDisabled;
var bool bIsPatch469;
var bool bClientIsWalking;
var bool bMustUpdate;
var bool justRespawned;
var vector oldClientLoc;

var globalconfig float MinDodgeClickTime;
var float zzLastTimeForward, zzLastTimeBack, zzLastTimeLeft, zzLastTimeRight;

struct MoveInfo {
	var float Delta;
	var bool bRun;
	var bool bDuck;
	var bool bPressedJump;
	var EDodgeDir DodgeMove;
	var vector Acceleration;
	var rotator DeltaRot;
};

struct BetterVector {
	var int X;
	var int Y;
	var int Z;
};

// HUD stuff
var Mutator	zzHudMutes[50];		// Accepted Hud Mutators
var Mutator	zzWaitMutes[50];	// Hud Mutes waiting to be accepted
var float	zzWMCheck[50];		// Key value
var int		zzFailedMutes;		// How many denied Mutes have been tried to add
var int		zzHMCnt;		// Counts of HudMutes and WaitMutes
var HUD		zzmyHud;		// our own personal hud
var Class<HUD>	zzHUDType;		// The HUD Type
var Scoreboard	zzScoring;		// The scoreboard.
var Class<Scoreboard> zzSBType;		// The Scoreboard Type
var Class<ServerInfo> zzSIType;		// The ServerInfo Type
var int		zzHUDWarnings;		// Counts the # of times the HUD has been changed
var bool	zzbRenderHUD;		// Do not start rendering HUD until logo has been displayed for a while

// Logo Display
var bool	zzbLogoDone;		// Are we done with the logo ?
var float	zzLogoStart;		// Start of logo display

var Teleporter	zzTP;			// Temp Teleporter holder
var name	zzTPE;			// Teleporter previous Event
var int		zzSMCnt;		// ServerMove Count
var bool	bMenuFixed;		// Fixed Menu item
var float	zzCVTO;			// CenterView Time out.
var bool	zzbCanCSL;		// Console sets this to true if they are allowed to CSL

// Consoles & Canvas
var Console	zzOldConsole;
var PureSuperDuperUberConsole	zzMyConsole;
var bool	zzbBadConsole;
var Canvas zzCannibal;			// Old console
var font zzCanOldFont;			// Canvas messing checks
var byte zzCanOldStyle;			// And more

// Anti Timing Variables
var Inventory	zzAntiTimerList[32];
var int		zzAntiTimerListState;
var int		zzAntiTimerListCount;
var int		zzAntiTimerFlippedCount;

// duh:
var bool zzTrue,zzFalse;		// True & False
var int zzNull;				// == 0

// Avoiding spam:
var string zzDelayedName;
var int zzNameChanges;			// How many times has name been changed
var Class<ChallengeVoicePack> zzDelayedVoice;
var float zzDelayedStartTime;
var float zzLastSpeech;
var float zzLastTaunt;
var float zzLastView,zzLastView2;
var int zzKickReady;
var int zzAdminLoginTries;
var int zzOldNetspeed,zzNetspeedChanges;

// MD5 Things
var bool zzbDidMD5;			// True when MD5 checks are completed.
var bool zzbMD5RequestSent;		// Server side, to decide if requests for MD5 has been sent.

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
//var PurexxLinker PureLinker;
var bool bDeterminedLocalPlayer;
var PlayerPawn LocalPlayer;

var TranslocatorTarget zzClientTTarget, TTarget;
var float LastTick, AvgTickDiff;

var bool MMSupport;
var bool DisablePortals;
var bool SetPendingWeapon;

// Net Updates
var float MaxPosErrorFactor;
var float TimeBetweenNetUpdates;

// SSR Beam
var byte BeamFadeCurve;
var float BeamDuration;
var float LastSSRBeamCreated;

//
var int CompressedViewRotation; // Compressed Pitch/Yaw
// 31               16               0
// +----------------+----------------+
// |     Pitch      |      Yaw       |
// +----------------+----------------+

var bool bWasDodging;

replication
{
	//	Client->Demo
	unreliable if ( bClientDemoRecording )
		xxReplicateVRToDemo, xxClientDemoMessage, xxClientLogToDemo, xxDemoSpawnSSRBeam;

    reliable if (bClientDemoRecording && !bClientDemoNetFunc)
        xxClientDemoFix, xxClientDemoBolt;

	reliable if ((Role == ROLE_Authority) && !bClientDemoRecording)
		xxNN_ClientProjExplode;

	// Server->Client
	unreliable if ( bNetOwner && Role == ROLE_Authority )
		zzTrackFOV, zzCVDeny, zzCVDelay, zzShowClick, zzMinimumNetspeed,
		zzWaitTime,zzAntiTimerList,zzAntiTimerListCount,zzAntiTimerListState,
		zzbDidMD5, zzStat;

	// Server->Client
	reliable if ( bNetOwner && Role == ROLE_Authority )
		zzHUDType, zzSBType, zzSIType, xxClientAcceptMutator, /* zzbWeaponTracer, */ zzForceSettingsLevel,
		zzbForceDemo, zzbGameStarted, zzbUsingTranslocator, HUDInfo;

	// Server->Client
	reliable if ( Role == ROLE_Authority )
		zzbForceModels, bIsAlive, bMustUpdate, bClientIsWalking, zzbIsWarmingUp, zzFRandVals, zzVRandVals,
		xxNN_MoveClientTTarget, xxSetPendingWeapon, SetPendingWeapon, //xxReceiveNextStartSpot,
		xxSetTeleRadius, xxSetDefaultWeapon, xxSetSniperSpeed, xxSetHitSounds, xxSetTimes,	// xxReceivePosition,
		xxClientKicker, /*xxClientSetVelocity,*/ TimeBetweenNetUpdates, xxClientSpawnSSRBeam,
		xxClientAddVelocity; //, xxClientTrigger, xxClientActivateMover;

	// Client->Server debug data
	reliable if ( Role == ROLE_AutonomousProxy )
		bDrawDebugData;
	// Server->Client debug data
	reliable if ( Role == ROLE_Authority && bDrawDebugData && RemoteRole == ROLE_AutonomousProxy )
		clientLastUpdateTime, clientForcedPosition, debugClientPing, debugNumOfForcedUpdates,
		debugPlayerServerLocation, debugClientbMoveSmooth, debugClientForceUpdate, debugClientLocError;

	//Server->Client function reliable.. no demo propogate! .. bNetOwner? ...
	reliable if ( bNetOwner && Role == ROLE_Authority && !bDemoRecording )
		xxCheatFound,xxClientMD5,xxClientSet,xxClientDoScreenshot,xxClientDoEndShot,xxClientConsole,
		xxClientKeys,xxClientReadINT;

	// Server->Client function.
	unreliable if (RemoteRole == ROLE_AutonomousProxy)
		xxPureCAP,
		xxCAP,xxCAPLevelBase,						// ClientAdjustPosition (float based)
		xxCAPWalking,
		xxCAPWalkingWalkingLevelBase,xxCAPWalkingWalking,
		xxFakeCAP;

	// Client->Server
	unreliable if ( Role < ROLE_Authority )
		/* xxServerMove, */ bIsFinishedLoading, xxServerCheater,
		zzbConsoleInvalid, zzFalse, zzTrue, zzNetspeed, zzbBadConsole, zzbBadCanvas, zzbVRChanged,
		zzbStoppingTraceBot, zzbForcedTick, zzbDemoRecording, zzbBadLighting, zzClientTD;

	// Client->Server
	reliable if ( Role < ROLE_Authority )
		xxServerCheckMutator, xxServerMove, xxServerTestMD5,xxServerSetNetCode,xxSet, //,xxCmd;
		xxServerReceiveMenuItems,xxServerSetNoRevert,xxServerSetReadyToPlay,Hold,Go,
		xxServerSetForceModels, xxServerSetHitSounds, xxServerSetTeamHitSounds, xxServerDisableForceHitSounds, xxServerSetMinDodgeClickTime, xxServerSetTeamInfo, ShowStats,
		xxServerAckScreenshot, xxServerReceiveConsole, xxServerReceiveKeys, xxServerReceiveINT, xxServerReceiveStuff,
		xxSendHeadshotToSpecs, xxSendDeathMessageToSpecs, xxSendMultiKillToSpecs, xxSendSpreeToSpecs, xxServerDemoReply,
		xxExplodeOther, /*xxServerSetVelocity,*/ xxSetNetUpdateRate; //, xxServerActivateMover;

	reliable if ((Role < ROLE_Authority) && !bClientDemoRecording)
		xxNN_ProjExplode, /* xxNN_ServerTakeDamage, */ /* xxNN_RadiusDamage, */ xxNN_TeleFrag, xxNN_TransFrag,
		xxNN_Fire, xxNN_AltFire, xxNN_ReleaseFire, xxNN_ReleaseAltFire, xxNN_MoveTTarget, ServerPreTeleport;

	// Server->Client
	unreliable if (Role == ROLE_Authority && bViewTarget)
		CompressedViewRotation;
}

//XC_Engine interface
native(1719) final function bool IsInPackageMap( optional string PkgName, optional bool bServerPackagesOnly);

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

simulated function xxSetPortals(bool DP)
{
	DisablePortals = DP;
}

function string ParseDelimited(string Text, string Delimiter, int Count, optional bool bToEndOfLine)
{
	local string Result;
	local int Found, i;
	local string s;

	Result = "";
	Found = 1;

	for(i=0;i<Len(Text);i++)
	{
		s = Mid(Text, i, 1);
		if(InStr(Delimiter, s) != -1)
		{
			if(Found == Count)
			{
				if(bToEndOfLine)
					return Result$Mid(Text, i);
				else
					return Result;
			}

			Found++;
		}
		else
		{
			if(Found >= Count)
				Result = Result $ s;
		}
	}

	return Result;
}

simulated function Touch( actor Other )
{
	local string Package;
	local Kicker K;

	if(Level.NetMode != NM_Client)
	{
		Package = ParseDelimited(string(Other.Class), ".", 1);
		if (Class'UTPure'.Default.ShowTouchedPackage)
		{
			ClientMessage(Package);
		}
		if
			(
				(
						Other.IsA('Kicker') && zzUTPure.bExludeKickers
				)	||	Other.IsA('Teleporter') ||
						Package != "Botpack" &&
						Package != "Engine" &&
						Package != "UnrealShare" &&
						Package != "Unreali"
			)
		{
			//zzForceUpdateUntil = Level.TimeSeconds + 0.15;
		}
    }
    Super.Touch(Other);
}


simulated function bool xxNewSetLocation(vector NewLoc, vector NewVel, optional EPhysics EndPhysics)
{
	if (!SetLocation(NewLoc))
		return false;
	Velocity = NewVel;
	return true;
}

simulated function bool xxNewMoveSmooth(vector NewLoc)
{
	local bool bSuccess;
	bSuccess = MoveSmooth(NewLoc - Location);
	if (bSuccess == false)
		bSuccess = Move(NewLoc - Location);
	return bSuccess;
}

function ServerPreTeleport(Teleporter Other, Teleporter Dest, vector ClientLoc, rotator ClientRot, vector ClientVel)
{
	local bool bUnblocked;

	if (Other == None || Dest == None || VSize(Dest.Location - ClientLoc) > TeleRadius || Level.NetMode == NM_Client || IsInState('Dying') || Mesh == None)
		return;

	if (bBlockPlayers)
	{
		SetCollision(bCollideActors, bBlockActors, false);
		zzDisabledPlayerCollision++;
		bUnblocked = true;
	}

	if (!xxNewSetLocation(ClientLoc, ClientVel))
	{
		if (bUnblocked)
			zzDisabledPlayerCollision--;
		return;
	}

	PlayTeleportEffect(false, true, Other);
	SetRotation(ClientRot);
	ViewRotation = ClientRot;
	zzViewRotation = ClientRot;
	PlayTeleportEffect(true, true, Dest);
}

function PlayTeleportEffect( optional bool bOut, optional bool bSound, optional Teleporter Portal )
{
 	local UTTeleportEffect PTE;
	local DeathMatchPlus DMP;
	local vector nLoc;
	local rotator nRot;

	if (Mesh == None)
		return;

	DMP = DeathMatchPlus(Level.Game);
	if (DMP == None || !bNewNet) {
		Level.Game.PlayTeleportEffect(Self, bOut, bSound);
		return;
	}

	if (Portal == None)
	{
		nLoc = Location;
		nRot = Rotation;
	}
	else
	{
		nLoc = Portal.Location;
		nRot = Portal.Rotation;
	}
	if ( bSound )
	{
		PTE = Spawn(class'UTTeleportEffect',Self,, nLoc, nRot);
		PTE.Initialize(Self, bOut);
		PTE.PlaySound(sound'Resp2A',, 10.0);
	}
}

simulated function xxClientKicker( float KCollisionRadius, float KCollisionHeight, float KLocationX, float KLocationY, float KLocationZ, int KRotationYaw, int KRotationPitch, int KRotationRoll, name KTag, name KEvent, name KAttachTag, vector KKickVelocity, name KKickedClasses, bool KbKillVelocity, bool KbRandomize )
{
	local Actor A;
	local Kicker K;
	local AttachMover AM;
	local vector KLocation;
	local rotator KRotation;

	if(Level.NetMode != NM_Client)
		return;

	KLocation.X = KLocationX;
	KLocation.Y = KLocationY;
	KLocation.Z = KLocationZ;
	KRotation.Yaw = KRotationYaw;
	KRotation.Pitch = KRotationPitch;
	KRotation.Roll = KRotationRoll;

	K = Spawn(class'Kicker', Self, , KLocation, KRotation);
	K.SetCollisionSize(KCollisionRadius, KCollisionHeight);
	K.Tag = KTag;
	K.Event = KEvent;
	K.AttachTag = KAttachTag;
	K.KickVelocity = KKickVelocity;
	K.KickedClasses = KKickedClasses;
	K.bKillVelocity = KbKillVelocity;
	K.bRandomize = KbRandomize;

	if(K.AttachTag != '')
	{
		Foreach AllActors(class'Actor', A, K.AttachTag)
		{
			K.SetBase(A);
			break;
		}
	}
	if(K.Tag != '')
	{
		Foreach AllActors(class'AttachMover', AM)
		{
			if(AM.AttachTag == K.Tag)
			{
				K.SetBase(AM);
				break;
			}
		}
	}
}

event PostBeginPlay()
{
	local int i;
	local Arena NewNetIG;

	for (i = 0; i < FRVI_length; i++)
		zzFRandVals[i] = FRand();

	for (i = 0; i < VRVI_length; i++)
		zzVRandVals[i] = VRand()*10000;

	if (DeathMatchPlus(Level.Game) != None)
		zzShowClick =  DeathMatchPlus(Level.Game).bTournament;


	Super.PostBeginPlay();

	if ( Level.NetMode != NM_Client )
	{
		zzHUDType = HUDType;
		zzSBType  = ScoringType;
		zzSIType  = zzUTPure.zzSI;
		zzbCanCSL = True;
		zzMinimumNetspeed = Class'UTPure'.Default.MinClientRate;
		zzWaitTime = 5.0;
	}
	SetPendingWeapon = class'UTPure'.Default.SetPendingWeapon;

	MaxPosErrorFactor = class'UTPure'.default.MaxJitterTime * class'UTPure'.default.MaxJitterTime;
	PlayerReplicationInfo.NetUpdateFrequency = 10;
}

// called after PostBeginPlay on net client
simulated event PostNetBeginPlay()
{

	if ( Role != ROLE_SimulatedProxy )	// Other players are Simulated, local player is Autonomous or Authority (if listen server which pure doesn't support anyway :P)
	{
		return;
	}

	zzbValidFire = zzTrue;

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

event Possess()
{
	local Mover M;
	local Kicker K;
	local Trigger T;
	local int TimeLimitSeconds, clientFPS;
	local bbPlayer zzPP;
//	local int zzx;

	if ( Level.Netmode == NM_Client )
	{	// Only do this for clients.
		zzbJustConnected = true;
		SetTimer(3, false);
		Log("Possessed PlayerPawn (bbPlayer) by InstaGib Plus");
		if (!bIsPatch469) {
			clientFPS = int(ConsoleCommand("get ini:engine.engine.gamerenderdevice frameratelimit"));
			//setClientNetspeed();
		}
		if (clientFPS > 200) {
			ConsoleCommand("set ini:engine.engine.gamerenderdevice frameratelimit 200");
			reconnectClient();
		}
		zzTrue = !zzFalse;
		zzInfoThing = Spawn(Class'PureInfo');
		//xxServerSetNetCode(bNewNet);
		playedHitSound = loadHitSound(selectedHitSound);
		SetNetUpdateRate(DesiredNetUpdateRate);
		xxServerSetNoRevert(bNoRevert);
		xxServerSetForceModels(bForceModels);
		xxServerSetHitSounds(HitSound);
		xxServerSetTeamHitSounds(TeamHitSound);
		if (bDisableForceHitSounds)
			xxServerDisableForceHitSounds();
		xxServerSetTeamInfo(bTeamInfo);
		xxServerSetMinDodgeClickTime(MinDodgeClickTime);
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
	}
	else
	{
		TeleRadius = zzUTPure.Default.TeleRadius;
		xxSetTeleRadius(TeleRadius);

		xxSetPortals(DisablePortals);
		DisablePortals = zzUTPure.Default.DisablePortals;

		DefaultHitSound = zzUTPure.Default.DefaultHitSound;
		DefaultTeamHitSound = zzUTPure.Default.DefaultTeamHitSound;
		bForceDefaultHitSounds = zzUTPure.Default.bForceDefaultHitSounds;
		xxSetHitSounds(DefaultHitSound, DefaultTeamHitSound, bForceDefaultHitSounds);


		xxSetSniperSpeed(class'UTPure'.default.SniperSpeed);
		xxSetDefaultWeapon(Level.Game.BaseMutator.MutatedDefaultWeapon().name);

		GameReplicationInfo.RemainingTime = DeathMatchPlus(Level.Game).RemainingTime;
		GameReplicationInfo.ElapsedTime = DeathMatchPlus(Level.Game).ElapsedTime;
		xxSetTimes(GameReplicationInfo.RemainingTime, GameReplicationInfo.ElapsedTime);

		if(!zzUTPure.bExludeKickers)
		{
			ForEach AllActors(class'Kicker', K)
			{
				if (K.Class.Name != 'Kicker')
					continue;
				xxClientKicker(K.CollisionRadius, K.CollisionHeight, K.Location.X, K.Location.Y, K.Location.Z, K.Rotation.Yaw, K.Rotation.Pitch, K.Rotation.Roll, K.Tag, K.Event, K.AttachTag, K.KickVelocity, K.KickedClasses, K.bKillVelocity, K.bRandomize );
			}
		}
	}
	Super.Possess();
}

function Timer() {

	if (bReason == 1) {
		bReason = 0;
		reconnectClient();
		return;
	}

	bIsFinishedLoading = true;
	zzbRenderHUD = True;
	Self.ClientMessage("[IG+] To view available commands type 'mutate playerhelp' in the console");
}

function ClientSetLocation( vector zzNewLocation, rotator zzNewRotation )
{
	local SavedMove M;
	if (zzbCanCSL ||
	     (zzNewRotation.Roll == 0 && zzNewRotation == ViewRotation &&
	      (WarpZoneInfo(Region.Zone) != None || WarpZoneInfo(HeadRegion.Zone) != None || WarpZoneInfo(FootRegion.Zone) != None)))
	{
		zzViewRotation      = zzNewRotation; // mm..
		ViewRotation		= zzNewRotation; // mm.. even more !
		If ( (zzViewRotation.Pitch > RotationRate.Pitch) && (zzViewRotation.Pitch < 65536 - RotationRate.Pitch) )
		{
			If (zzViewRotation.Pitch < 32768)
				zzNewRotation.Pitch = RotationRate.Pitch;
			else
				zzNewRotation.Pitch = 65536 - RotationRate.Pitch;
		}
		zzNewRotation.Roll  = 0;
		SetRotation( zzNewRotation );
		SetLocation( zzNewLocation );

		// Clean up moves
		if (PendingMove != none) {
			PendingMove.NextMove = FreeMoves;
			PendingMove.Clear();
			FreeMoves = PendingMove;
			PendingMove = none;
		}

		while(SavedMoves != none) {
			M = SavedMoves;
			SavedMoves = M.NextMove;
			M.NextMove = FreeMoves;
			M.Clear();
			FreeMoves = M;
		}
	}
}


event ReceiveLocalizedMessage( class<LocalMessage> Message, optional int Sw, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
	local Pawn P;

	if (Message == class'CTFMessage2' && PureFlag(PlayerReplicationInfo.HasFlag) != None)
		return;

	// Handle hitsounds properly here before huds get it. Remove damage except if demoplayback :P
	if (Message == class'PureHitSound')
	{
		if (RelatedPRI_1 == None)
			return;

		if (GameReplicationInfo.bTeamGame && RelatedPRI_1.Team == RelatedPRI_2.Team)
		{
			if (TeamHitSound > 0)
				Sw = -1*Sw;
			else
				return;
		}
		else if (HitSound == 0)
			return;
	}
	else if (Message == class'DecapitationMessage')
	{
		xxSendHeadshotToSpecs(Sw, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	}
	else if (RelatedPRI_1 == PlayerReplicationInfo || RelatedPRI_2 == PlayerReplicationInfo)
	{
		if (Message == class'DeathMessagePlus' || Message == class'DDeathMessagePlus')
		{
			xxSendDeathMessageToSpecs(Sw, RelatedPRI_1, RelatedPRI_2, OptionalObject);
		}
		else if (Message == class'MultiKillMessage' || Message == class'MMultiKillMessage')
		{
			xxSendMultiKillToSpecs(Sw, RelatedPRI_1, RelatedPRI_2, OptionalObject);
		}
		else if (Message == class'KillingSpreeMessage')
		{
			xxSendSpreeToSpecs(Sw, RelatedPRI_1, RelatedPRI_2, OptionalObject);
		}
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
			//P.ReceiveLocalizedMessage( class'MMultiKillMessage', Sw, RelatedPRI_1, RelatedPRI_2, OptionalObject );
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
	zzbCanCSL = zzFalse;
	xxPlayerTickEvents();
	zzTick = Time;
}

function ClientSetRotation( rotator zzNewRotation )
{
	if (zzbCanCSL)
	{
		ViewRotation		= zzNewRotation;
		zzViewRotation  	= zzNewRotation;
		zzNewRotation.Pitch = 0;
		zzNewRotation.Roll  = 0;
		SetRotation( zzNewRotation );
	}
}

simulated function xxClientDemoMessage(string zzS)
{
	if (zzS == zzPrevClientMessage)
		return;
	ClientMessage(zzS);
}

event ClientMessage( coerce string zzS, optional Name zzType, optional bool zzbBeep )
{
	zzPrevClientMessage = zzS;
	xxClientDemoMessage(zzS);
	Super.ClientMessage(zzS, zzType, zzbBeep);
	zzPrevClientMessage = "";

	//xxFinishAce(zzS);
}

simulated function xxCheckAce()
{
	local float Now;
	local Actor A;

	Now = Level.TimeSeconds;
	if (zzbAceChecked || Now - zzAceCheckedTime < 15 || Level.NetMode != NM_Client)
		return;

	if (Now < 60)
	{
		ForEach AllActors(class'Actor', A)
		{
			if (Caps(string(A.Class.Name)) == "ACEREPLICATIONINFO")
			{
				zzAceCheckedTime = Now;
				zzbAceFinish = true;
				ConsoleCommand("mutate ace highperftoggle");
			}
		}
	}
	else
	{
		zzbAceChecked = true;
	}
}

simulated function xxFinishAce( string zzS )
{
	if (!zzbAceFinish || Level.NetMode != NM_Client)
		return;

	zzbAceFinish = false;
	zzS = Caps(zzS);
	if (zzS == "ACE PERFORMANCE MODE IS NOW TOGGLED ON.")
	{
		ConsoleCommand("disconnect");
		ConsoleCommand("reconnect");
		zzbAceChecked = true;
	}
	else if (zzS == "ACE PERFORMANCE MODE IS NOW TOGGLED OFF.")
	{
		ConsoleCommand("mutate ace highperftoggle");
		zzbAceChecked = true;
	}
}

simulated event bool PreTeleport( Teleporter zzInTeleporter )
{
	local Teleporter Dest;

	if (Level.NetMode == NM_Client && zzInTeleporter != LastPortal)
	{
		LastPortal = zzInTeleporter;
		LastPortalTime = Level.TimeSeconds + 0.2;
		Dest = TeleporterTouch(zzInTeleporter);
		if (Dest != None)
			ServerPreTeleport(zzInTeleporter, Dest, Location, Rotation, Velocity);
		return true;
	}
	zzTP = zzInTeleporter;
	zzTPE = zzTP.Event;
	zzTP.Event = 'UTPure';
	Tag = 'UTPure';
	return True;
}

event Trigger( Actor zzOther, Pawn zzEventInstigator )
{
	local Actor zzA;

	// Only way we get triggered is from Teleport
	if (zzTP != None)
	{
		zzTP.Event = zzTPE;
		zzTP = None;
		Tag = '';
		// Be nice and call std event
		zzViewRotation = Rotation;
		ViewRotation = Rotation;
		if (zzTPE != '')
			foreach AllActors( class 'Actor', zzA, zzTPE )
				zzA.Trigger( zzOther, zzEventInstigator );
	}
}

// Teleporter was touched by an actor.
simulated function Teleporter TeleporterTouch( Teleporter T )
{
	local Teleporter Dest;
	local int i;
	local Actor A;

	if ( !T.bEnabled )
		return Dest;

	if( (InStr( T.URL, "/" ) >= 0) || (InStr( T.URL, "#" ) >= 0) )
	{
		// Teleport to a level on the net.
		Level.Game.SendPlayer(Self, T.URL);
	}
	else
	{
		// Teleport to a random teleporter in this local level, if more than one pick random.

		foreach AllActors( class 'Teleporter', Dest )
			if( string(Dest.tag)~=T.URL && Dest!=T )
				i++;
		i = rand(i);
		foreach AllActors( class 'Teleporter', Dest )
			if( string(Dest.tag)~=T.URL && Dest!=T && i-- == 0 )
				break;
		if( Dest != None )
		{
			// Teleport the actor into the other teleporter.
			T.PlayTeleportEffect( Self, false);
			TeleporterAccept( Dest, T );
			if (T.Event != '')
				foreach AllActors( class 'Actor', A, T.Event )
					A.Trigger( Self, Self.Instigator );
		}
	}
	return Dest;
}

// Accept an actor that has teleported in.
simulated function bool TeleporterAccept( Teleporter T, Actor Source )
{
	local rotator newRot, oldRot;
	local int oldYaw;
	local float mag;
	local vector oldDir;
	local pawn P;
	local VisibleTeleporter VT;

	T.Disable('Touch');
	newRot = Rotation;
	if (T.bChangesYaw)
	{
		oldRot = Rotation;
		newRot.Yaw = T.Rotation.Yaw;
		if ( Source != None )
			newRot.Yaw += (32768 + Rotation.Yaw - Source.Rotation.Yaw);
	}
	SetLocation(T.Location);
	SetRotation(newRot);
	ViewRotation = newRot;
	zzViewRotation = newRot;

	T.LastFired = Level.TimeSeconds;
	MoveTimer = -1.0;
	MoveTarget = T;
	T.PlayTeleportEffect( Self, false);
	T.Enable('Touch');

	if (T.bChangesVelocity)
		Velocity = T.TargetVelocity;
	else
	{
		if ( T.bChangesYaw )
		{
			if ( Physics == PHYS_Walking )
				OldRot.Pitch = 0;
			oldDir = vector(OldRot);
			mag = Velocity Dot oldDir;
			Velocity = Velocity - mag * oldDir + mag * vector(Rotation);
		}
		if ( T.bReversesX )
			Velocity.X *= -1.0;
		if ( T.bReversesY )
			Velocity.Y *= -1.0;
		if ( T.bReversesZ )
			Velocity.Z *= -1.0;
	}
	foreach VisibleCollidingActors( class 'Pawn', P, CollisionRadius * TeleRadius / 100, Location )
		if ( P != Self && (!GameReplicationInfo.bTeamGame || PlayerReplicationInfo.Team != P.PlayerReplicationInfo.Team) && ((VSize(P.Location - Location)) < ((P.CollisionRadius + CollisionRadius) * CollisionHeight)) )
			xxNN_TeleFrag(T, P);
	return true;
}

function rotator GR()
{
	return zzViewRotation;
}

event UpdateEyeHeight(float DeltaTime)
{
	Super.UpdateEyeHeight(DeltaTime);
	xxCheckFOV();
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

	if ( bShowMenu && (zzmyHud != None) )
	{
		// clear inputs
		bEdgeForward = false;
		bEdgeBack = false;
		bEdgeLeft = false;
		bEdgeRight = false;
		bWasForward = false;
		bWasBack = false;
		bWasLeft = false;
		bWasRight = false;
		zzLastTimeForward = 0;
		zzLastTimeBack = 0;
		zzLastTimeLeft = 0;
		zzLastTimeRight = 0;
		aStrafe = 0;
		aTurn = 0;
		aForward = 0;
		aLookUp = 0;
		return;
	}

	Now = Level.TimeSeconds;

	// Check for Dodge move
	// flag transitions
	bOldWasForward = bWasForward;
	bOldWasBack = bWasBack;
	bOldWasLeft = bWasLeft;
	bOldWasRight = bWasRight;
	bWasForward = (aBaseY > 0);
	bWasBack = (aBaseY < 0);
	bWasLeft = (aStrafe > 0);
	bWasRight = (aStrafe < 0);
	bEdgeForward = bOldWasForward != bWasForward;
	bEdgeBack = bOldWasBack != bWasBack;
	bEdgeLeft = bOldWasLeft != bWasLeft;
	bEdgeRight = bOldWasRight != bWasRight;

	if (bOldWasForward && !bWasForward)
		zzLastTimeForward = Now;
	if (bOldWasBack && !bWasBack)
		zzLastTimeBack = Now;
	if (bOldWasLeft && !bWasLeft)
		zzLastTimeLeft = Now;
	if (bOldWasRight && !bWasRight)
		zzLastTimeRight = Now;

	// Smooth and amplify mouse movement
	SmoothTime = FMin(0.2, 3 * DeltaTime * Level.TimeDilation);
	FOVScale = DesiredFOV * 0.01111;
	MouseScale = MouseSensitivity * FOVScale;

	aMouseX *= MouseScale;
	aMouseY *= MouseScale;

//************************************************************************

	//log("X "$aMouseX$" Smooth "$SmoothMouseX$" Borrowed "$BorrowedMouseX$" zero time "$(Level.TimeSeconds - MouseZeroTime)$" vs "$MouseSmoothThreshold);
	AbsSmoothX = SmoothMouseX;
	AbsSmoothY = SmoothMouseY;
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
/*
	local Decoration Carried;
	local vector OldLoc, NewLocation;

	if ( CurrentTimeStamp > TimeStamp )
		return;
	CurrentTimeStamp = TimeStamp;

	NewLocation.X = NewLocX;
	NewLocation.Y = NewLocY;
	NewLocation.Z = NewLocZ;
	Velocity.X = NewVelX;
	Velocity.Y = NewVelY;
	Velocity.Z = NewVelZ;

	SetBase(NewBase);
	if ( Mover(NewBase) != None )
		NewLocation += NewBase.Location;

	//log("Client "$Role$" adjust "$self$" stamp "$TimeStamp$" location "$Location);
	Carried = CarriedDecoration;
	OldLoc = Location;
	bCanTeleport = false;
	SetLocation(NewLocation);
	bCanTeleport = true;
	if ( Carried != None )
	{
		CarriedDecoration = Carried;
		CarriedDecoration.SetLocation(NewLocation + CarriedDecoration.Location - OldLoc);
		CarriedDecoration.SetPhysics(PHYS_None);
		CarriedDecoration.SetBase(self);
	}
	SetPhysics(newPhysics);

	if ( !IsInState(newState) )
		GotoState(newState);

	bUpdatePosition = true;
*/
//	Log("Hmm, shouldn't be here should we...");
}

// OLD STYLE (3xfloat) CAP

function xxCAP(float TimeStamp, name newState, EPhysics newPhysics,
			float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase)
{
	local vector Loc,Vel;
	Loc.X = NewLocX; Loc.Y = NewLocY; Loc.Z = NewLocZ;
	Vel.X = NewVelX; Vel.Y = NewVelY; Vel.Z = NewVelZ;
	xxPureCAP(TimeStamp, newState, newPhysics,Loc,Vel,NewBase);
}

function xxCAPLevelBase(float TimeStamp, name newState, EPhysics newPhysics,
			float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ)
{
	local vector Loc,Vel;
	Loc.X = NewLocX; Loc.Y = NewLocY; Loc.Z = NewLocZ;
	Vel.X = NewVelX; Vel.Y = NewVelY; Vel.Z = NewVelZ;
	xxPureCAP(TimeStamp,newState,newPhysics,Loc,Vel,Level);
}

function xxCAPWalking(float TimeStamp, EPhysics newPhysics,
			float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase)
{
	local vector Loc,Vel;
	Loc.X = NewLocX; Loc.Y = NewLocY; Loc.Z = NewLocZ;
	Vel.X = NewVelX; Vel.Y = NewVelY; Vel.Z = NewVelZ;
	xxPureCAP(TimeStamp,'PlayerWalking',newPhysics,Loc,Vel,NewBase);
}

function xxCAPWalkingWalkingLevelBase(float TimeStamp,
			float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ)
{
	local vector Loc,Vel;
	Loc.X = NewLocX; Loc.Y = NewLocY; Loc.Z = NewLocZ;
	Vel.X = NewVelX; Vel.Y = NewVelY; Vel.Z = NewVelZ;
	xxPureCAP(TimeStamp,'PlayerWalking',PHYS_Walking,Loc,Vel,Level);
}

function xxCAPWalkingWalking(float TimeStamp,
			float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase)
{
	local vector Loc,Vel;
	Loc.X = NewLocX; Loc.Y = NewLocY; Loc.Z = NewLocZ;
	Vel.X = NewVelX; Vel.Y = NewVelY; Vel.Z = NewVelZ;
	xxPureCAP(TimeStamp,'PlayerWalking',PHYS_Walking,Loc,Vel,NewBase);
}

simulated function xxPureCAP(float TimeStamp, name newState, EPhysics newPhysics, vector NewLoc, vector NewVel, Actor NewBase)
{
	local Decoration Carried;
	local vector OldLoc, DeltaLoc;
	local bbPlayer bbP;
	local bbSavedMove CurrentMove;

	if ( CurrentTimeStamp > TimeStamp )
		return;
	CurrentTimeStamp = TimeStamp;

	SetPhysics(newPhysics);

	// stijn: Backported hugely influential fix from UE2 here
	// Remove acknowledged moves from the savedmoves list
	CurrentMove = bbSavedMove(SavedMoves);
	while (CurrentMove != None)
	{
		if (CurrentMove.TimeStamp <= CurrentTimeStamp)
		{
			SavedMoves = bbSavedMove(CurrentMove.NextMove);
			CurrentMove.NextMove = FreeMoves;
			FreeMoves = CurrentMove;
			if (CurrentMove.TimeStamp == CurrentTimeStamp)
			{
				// log("> Server NACK "@CurrentMove.ToString());
				// log("> Position Error"@VSize(CurrentMove.SavedLocation - NewLocation));
				// log("> Velocity Error"@VSize(CurrentMove.SavedVelocity - NewVelocity));

				// if this is a small adjustment that does not
				// change our state, then reject it. This way
				// we can ensure that movement remains smooth
				DeltaLoc = CurrentMove.SavedLocation - NewLoc;
				DeltaLoc.Z = FMax(Abs(DeltaLoc.Z) - MaxStepHeight, 0);
				if ((DeltaLoc dot DeltaLoc) < 9 &&
				    // VSize(CurrentMove.SavedVelocity - NewVelocity) < 3 &&  // stijn: UE2 also checked velocity but honestly there isn't really any point in doing that...
				    IsInState(newState))
				{
					// log("> ClientAdjustPosition REJECT");
					debugNumOfIgnoredForceUpdates += 1;
					FreeMoves.Clear();
					return;
				}
				// log("> ClientAdjustPosition ACCEPT");
				// ok, this is a serious adjustment. Proceed
				FreeMoves.Clear();
				break;
		    }
			// log("> Server ACK "@CurrentMove.ToString());
			FreeMoves.Clear();
			CurrentMove = bbSavedMove(SavedMoves);
		}
		else
		{
			// not yet acknowledged. break out of the loop
			break;
		}
	}
	// stijn: End of fix

	SetBase(NewBase);
	if ( Mover(NewBase) != None )
		NewLoc += NewBase.Location;

	//log("Client "$Role$" adjust "$self$" stamp "$TimeStamp$" location "$Location);
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

	if ( !IsInState(newState) )
		GotoState(newState);

	zzbFakeUpdate = false;
	bUpdatePosition = true;
}

function xxFakeCAP(float TimeStamp)
{
	if ( CurrentTimeStamp > TimeStamp )
		return;
	CurrentTimeStamp = TimeStamp;

	zzbFakeUpdate = true;
	bUpdatePosition = true;
}

function ClientUpdatePosition()
{
	local bbSavedMove CurrentMove, PendMove;
	local int realbRun, realbDuck;
	local bool bRealJump;
	local rotator RealViewRotation, RealRotation;

	local float TotalTime;
	local Pawn P;
	local vector Dir;

	bUpdatePosition = false;
	realbRun= bRun;
	realbDuck = bDuck;
	bRealJump = bPressedJump;
	RealRotation = Rotation;
	RealViewRotation = ViewRotation;
	CurrentMove = bbSavedMove(SavedMoves);
	bUpdating = true;
	while ( CurrentMove != None )
	{
		if ( CurrentMove.TimeStamp <= CurrentTimeStamp )
		{
			SavedMoves = CurrentMove.NextMove;
			CurrentMove.NextMove = FreeMoves;
			FreeMoves = CurrentMove;
			FreeMoves.Clear();
			CurrentMove = bbSavedMove(SavedMoves);
		}
		else
		{
			TotalTime += CurrentMove.Delta;
			if (!zzbFakeUpdate) {
				SetRotation( CurrentMove.Rotation);
				ViewRotation = CurrentMove.SavedViewRotation;
				MoveAutonomous(CurrentMove.Delta, CurrentMove.bRun, CurrentMove.bDuck, CurrentMove.bPressedJump, CurrentMove.DodgeMove, CurrentMove.Acceleration, rot(0,0,0));
				CurrentMove.SavedLocation = Location;
				CurrentMove.SavedVelocity = Velocity;
			}
			CurrentMove = bbSavedMove(CurrentMove.NextMove);
		}
	}
	// stijn: The original code was not replaying the pending move
	// here. This was a huge oversight and caused non-stop resynchronizations
	// because the playerpawn position would be off constantly until the player
	// stopped moving!
	if (!zzbFakeUpdate && PendingMove != none)
	{
		PendMove = bbSavedMove(PendingMove);
		SetRotation(PendingMove.Rotation);
		ViewRotation = PendMove.SavedViewRotation;
		MoveAutonomous(PendingMove.Delta, PendingMove.bRun, PendingMove.bDuck, PendingMove.bPressedJump, PendingMove.DodgeMove, PendingMove.Acceleration, rot(0,0,0));
		PendMove.SavedLocation = Location;
		PendMove.SavedVelocity = Velocity;
	}
	bUpdating = false;
	bDuck = realbDuck;
	bRun = realbRun;
	bPressedJump = bRealJump;
	SetRotation( RealRotation);
	ViewRotation = RealViewRotation;
	zzbFakeUpdate = false;
	//log("Client adjusted "$self$" stamp "$CurrentTimeStamp$" location "$Location$" dodge "$DodgeDir);
}

function xxServerReceiveStuff( float VelX, float VelY, float VelZ, bool bOnMover, optional vector TeleLoc, optional vector TeleVel )
{
	local Inventory inv;
	local Translocator TLoc;

	if (Level.NetMode == NM_Client || IsInState('Dying'))
		return;

	if (VelZ < 0)
		zzLastFallVelZ = VelZ;

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

function xxServerMove(
	float TimeStamp,
	float FrameTime,
	float AccelX,
	float AccelY,
	float AccelZ,
	float ClientLocX,
	float ClientLocY,
	float ClientLocZ,
	vector ClientVel,
	int MiscData,
	int View,
	Actor ClientBase,
	optional byte OldTimeDelta,
	optional int OldAccel
) {
	local float DeltaTime, ClientLocErr, OldTimeStamp, MinPosError, MaxPosError;
	local rotator DeltaRot, Rot;
	local vector Accel, LocDiff, Dir;
	local int maxPitch, ViewPitch, ViewYaw, i, NumPktsLost;
	local bool NewbPressedJump, OldbRun, OldbDuck, bTooLong, bMoveSmooth, bOnMover;
	local eDodgeDir OldDodgeMove;
	local name zzMyState;
	local Pawn P;
	local PlayerPawn zzPP;
	local PlayerStart PS;
	local NavigationPoint NP;
	local Teleporter T;
	local Decoration Carried;
	local vector OldLoc;
	local Carcass Carc;
	local vector ClientLocAbs;
	local vector ClientVelCalc;
	local bool bCanTraceNewLoc, bMovedToNewLoc;
	local float PosErrFactor;
	local float PosErr;

	local vector InAccel;
	local vector ClientLoc;

	local bool NewbRun;
	local bool NewbDuck;
	local bool NewbJumpStatus;
	local eDodgeDir DodgeMove;
	local byte ClientRoll;

	if (bDeleteMe)
		return;

	if (Role < ROLE_Authority)
	{
		zzbDidMD5 = True;
		zzbLogoDone = True;
		zzTrackFOV = 0;
		zzbDemoPlayback = True;
		return;
	}

	if (!zzbMD5RequestSent)
	{
		xxClientMD5(zzUTPure.zzPurePackageName, zzUTPure.zzMD5KeyInit);
		zzbMD5RequestSent = True;
	}
	if (!zzbDidMD5)
	{
		CurrentTimeStamp = TimeStamp;
		ServerTimeStamp = Level.TimeSeconds;
		Acceleration = vect(0,0,0);
		return;
	}

	if (zzbBadConsole)
		xxServerCheater("BC");
	if (zzbBadCanvas)
		xxServerCheater("BA");
	if (TimeStamp > 20.0)
	{
		if (zzFalse || !zzTrue)
			xxServerCheater("TF");
		if (zzClientTD != Level.TimeDilation)
			xxServerCheater("TD");
	}
	if (zzbConsoleInvalid)
		xxServerCheater("IC");
	if (zzbForcedTick && !zzUTPure.zzbPaused)
		xxServerCheater("FT");

	if (zzbVRChanged)
		xxServerCheater("VR");

	zzKickReady = Max(zzKickReady - 1,0);

	if (TimeStamp > Level.TimeSeconds)
		TimeStamp = Level.TimeSeconds;

	if ( CurrentTimeStamp >= TimeStamp )
		return;

	InAccel.X = AccelX;
	InAccel.Y = AccelY;
	InAccel.Z = AccelZ;
	ClientLoc.X = ClientLocX;
	ClientLoc.Y = ClientLocY;
	ClientLoc.Z = ClientLocZ;

	NewbRun = (MiscData & 0x40000) != 0;
	NewbDuck = (MiscData & 0x20000) != 0;
	NewbJumpStatus = (MiscData & 0x10000) != 0;
	DodgeMove = GetDodgeDir((MiscData >> 8) & 0xFF);
	ClientRoll = (MiscData & 0xFF);

	if (ClientBase == none)
		ClientLocAbs = ClientLoc;
	else
		ClientLocAbs = ClientLoc + ClientBase.Location;

	// if OldTimeDelta corresponds to a lost packet, process it first
	if (  OldTimeDelta != 0 )
	{
		OldTimeStamp = TimeStamp - float(OldTimeDelta)/500 - 0.001;
		if ( CurrentTimeStamp < OldTimeStamp - 0.001 )
		{
			Accel.X = OldAccel >>> 23;
			if ( Accel.X > 127 )
				Accel.X = -1 * (Accel.X - 128);
			Accel.Y = (OldAccel >>> 15) & 255;
			if ( Accel.Y > 127 )
				Accel.Y = -1 * (Accel.Y - 128);
			Accel.Z = (OldAccel >>> 7) & 255;
			if ( Accel.Z > 127 )
				Accel.Z = -1 * (Accel.Z - 128);
			Accel *= 20;

			OldbRun = ( (OldAccel & 64) != 0 );
			OldbDuck = ( (OldAccel & 32) != 0 );
			NewbPressedJump = ( (OldAccel & 16) != 0 );
			if ( NewbPressedJump )
				bJumpStatus = NewbJumpStatus;

			switch (OldAccel & 7)
			{
				case 0:
					OldDodgeMove = DODGE_None;
					break;
				case 1:
					OldDodgeMove = DODGE_Left;
					break;
				case 2:
					OldDodgeMove = DODGE_Right;
					break;
				case 3:
					OldDodgeMove = DODGE_Forward;
					break;
				case 4:
					OldDodgeMove = DODGE_Back;
					break;
			}
			MoveAutonomous(OldTimeStamp - CurrentTimeStamp, OldbRun, OldbDuck, NewbPressedJump, OldDodgeMove, Accel, rot(0,0,0));
			CurrentTimeStamp = OldTimeStamp;
		}
	}

	// View components
	CompressedViewRotation = View;
	ViewPitch = (View >>> 16);
	ViewYaw = (View & 0xFFFF);
	// Make acceleration.
	Accel = InAccel/10;

	NewbPressedJump = (bJumpStatus != NewbJumpStatus);
	bJumpStatus = NewbJumpStatus;

	DeltaTime = TimeStamp - CurrentTimeStamp;
	if (DeltaTime > 0.5)
		DeltaTime = FMin(DeltaTime, FrameTime);

	if ( ServerTimeStamp > 0 )
	{
		// allow 1% error
		TimeMargin += DeltaTime - 1.01 * (Level.TimeSeconds - ServerTimeStamp);
		if ( TimeMargin > MaxTimeMargin )
		{
			// player is too far ahead
			TimeMargin -= DeltaTime;
			if ( TimeMargin < 0.5 )
				MaxTimeMargin = Default.MaxTimeMargin;
			else
				MaxTimeMargin = 0.5;
			DeltaTime = 0;
		}
	}

	CurrentTimeStamp = TimeStamp;
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
	zzViewRotation = ViewRotation;
	SetRotation(Rot);

	// Maximum of old and new velocity
	// Ensures we dont force updates when slowing down or speeding up
	ClientVelCalc.X = FMax(ClientVel.X, Velocity.X);
	ClientVelCalc.Y = FMax(ClientVel.Y, Velocity.Y);
	ClientVelCalc.Z = FMax(ClientVel.Z, Velocity.Z);

	// Predict new position
	if ((Level.Pauser == "") && (DeltaTime > 0)) {
		//Log("["$Level.TimeSeconds$"]"@self$": xxServerMove: before MoveAutonomous"@Physics@DodgeMove@AnimSequence, 'Debug');
		MoveAutonomous(DeltaTime, NewbRun, NewbDuck, NewbPressedJump, DodgeMove, Accel, DeltaRot);
		//Log("["$Level.TimeSeconds$"]"@self$": xxServerMove: after MoveAutonomous"@Physics@DodgeDir@AnimSequence, 'Debug');
	}

	// HACK
	// This fixes players skating around. I can't explain why they start doing
	// that. Maybe because we're dodging in a place where we can't dodge?
	// Symptoms of skating around are:
	//  a) Tweening between DuckWlkL and JumpLGFR at 0.25Hz (see PlayInAir)
	//  b) DodgeMove is DODGE_None, Physics are still PHYS_Falling
	// This hack uses the second set of symptoms to getect when were about to
	// start skating around and forces the Pawn to land. No idea about side-
	// effects yet.
	if (Physics != PHYS_Falling) {
		bWasDodging = false;
	} else {
		bWasDodging = bWasDodging || DodgeDir == DODGE_Active;
		if (bWasDodging && DodgeMove == DODGE_None) {
			SetPhysics(PHYS_Walking);
			Landed(vect(0,0,1));
		}
	}

	// Calculate how far off we allow the client to be from the predicted position
	MaxPosError = 3.0;
	if (bNewNet) {
		PosErrFactor = FMin(DeltaTime, class'UTPure'.default.MaxJitterTime);
		PosErr =
			3 // constant part
			+ PosErrFactor * VSize(ClientVelCalc) // velocity
			+ FMin(1.0, FMax(0, GroundSpeed - VSize(ClientVelCalc)) / (AccelRate * PosErrFactor)) // bound acceleration by how much we can still speed up
				* 0.5 * AccelRate * PosErrFactor * PosErrFactor; // acceleration

		MaxPosError = PosErr * PosErr;
	}

	LocDiff = Location - ClientLocAbs;
	ClientLocErr = LocDiff Dot LocDiff;
	debugClientLocError = ClientLocErr;

	if (ClientLocErr > MaxPosError) {
		// fix for stairs
		LocDiff.Z = FMax(Abs(LocDiff.Z) - MaxStepHeight, 0);
		ClientLocErr = LocDiff Dot LocDiff;
	}

	debugClientForceUpdate = false;

	PlayerReplicationInfo.Ping = int(ConsoleCommand("GETPING"));
	if (SetPendingWeapon)
    {
        xxSetPendingWeapon(PendingWeapon);
        zzPendingWeapon = PendingWeapon;
    }
    else
    {
        if (MMSupport)
        {
            xxSetPendingWeapon(PendingWeapon);
            zzPendingWeapon = PendingWeapon;
        }
        else
        {
            if (zzPendingWeapon != PendingWeapon)
            {
                xxSetPendingWeapon(PendingWeapon);
                zzPendingWeapon = PendingWeapon;
                if (PendingWeapon != None && PendingWeapon.Owner == Self && Weapon != None && !Weapon.IsInState('DownWeapon'))
                    Weapon.GotoState('DownWeapon');
            }
        }
    }

	if (zzDisabledPlayerCollision > 0) {
		zzDisabledPlayerCollision--;
		if (zzDisabledPlayerCollision == 0)
			SetCollision(bCollideActors, bBlockActors, true);
	}

	bOnMover = Mover(Base) != None;
	zzbOnMover = Mover(ClientBase) != none;
	if (bOnMover && zzbOnMover && ClientLocErr < MaxPosError * 10)
	{
		zzIgnoreUpdateUntil = ServerTimeStamp + 0.15;
	}
	else if (zzIgnoreUpdateUntil > 0)
	{
		if (zzIgnoreUpdateUntil > ServerTimeStamp && (Base == None || Mover(Base) == None || bOnMover != zzbOnMover) && Physics != PHYS_Falling)
			zzIgnoreUpdateUntil = 0;
		zzbForceUpdate = false;
	}

	zzMyState = GetStateName();
	LastUpdateTime = ServerTimeStamp;
	clientLastUpdateTime = LastUpdateTime;

	if (zzForceUpdateUntil > 0 || (zzIgnoreUpdateUntil == 0 && (ClientLocErr > MaxPosError))) {
		zzbForceUpdate = true;
		if (ServerTimeStamp > zzForceUpdateUntil)
			zzForceUpdateUntil = 0;
	}

	if (zzbForceUpdate)
	{
		debugClientForceUpdate = zzbForceUpdate;
		debugNumOfForcedUpdates++;
		zzAddVelocityCount = 0;
		zzbForceUpdate = false;

		if ( Mover(Base) != None )
			ClientLoc = Location - Base.Location;
		else
			ClientLoc = Location;

		if (zzMyState == 'PlayerWalking') {
			if (Physics == PHYS_Walking) {
				if (Base == Level) {
					xxCAPWalkingWalkingLevelBase(TimeStamp, ClientLoc.X, ClientLoc.Y, ClientLoc.Z, Velocity.X, Velocity.Y, Velocity.Z);
				} else {
					xxCAPWalkingWalking(TimeStamp, ClientLoc.X, ClientLoc.Y, ClientLoc.Z, Velocity.X, Velocity.Y, Velocity.Z, Base);
				}
			} else {
				xxCAPWalking(TimeStamp, Physics, ClientLoc.X, ClientLoc.Y, ClientLoc.Z, Velocity.X, Velocity.Y, Velocity.Z, Base);
			}
		} else if (Base == Level)
			xxCAPLevelBase(TimeStamp, zzMyState, Physics, ClientLoc.X, ClientLoc.Y, ClientLoc.Z, Velocity.X, Velocity.Y, Velocity.Z);
		else
			xxCAP(TimeStamp, zzMyState, Physics, ClientLoc.X, ClientLoc.Y, ClientLoc.Z, Velocity.X, Velocity.Y, Velocity.Z, Base);


		zzLastClientErr = 0;
		xxRememberPosition();
		return;
	}

	if (zzLastClientErr == 0 || ClientLocErr < zzLastClientErr)
		zzLastClientErr = ClientLocErr;

	bCanTraceNewLoc = FastTrace(ClientLocAbs);
	if (bCanTraceNewLoc) {
		clientForcedPosition = ClientLocAbs;
		zzLastClientErr = 0;
		bMovedToNewLoc = xxNewMoveSmooth(ClientLocAbs);
		if (bMovedToNewLoc)
			Velocity = ClientVel;
	}
	if (bCanTraceNewLoc == false) {
		Carried = CarriedDecoration;
		OldLoc = Location;

		bCanTeleport = false;
		xxNewSetLocation(ClientLocAbs, ClientVel);
		bCanTeleport = true;

		if (Carried != None) {
			CarriedDecoration = Carried;
			CarriedDecoration.SetLocation(ClientLocAbs + CarriedDecoration.Location - OldLoc);
			CarriedDecoration.SetPhysics(PHYS_None);
			CarriedDecoration.SetBase(self);
		}

		zzLastClientErr = 0;
	}
	xxFakeCAP(TimeStamp);
	xxRememberPosition();
}

function bool OtherPawnAtLocation(vector Loc) {
	local Pawn P;
	local vector RadiusDelta;
	local float HeightDelta;

	for (P = Level.PawnList; P != none; P = P.NextPawn) {
		if (P == self) continue;

		RadiusDelta = vect(1,1,0) * (P.Location - Loc);
		if ((RadiusDelta dot RadiusDelta) > CollisionRadius * CollisionRadius) continue;

		HeightDelta = P.Location.Z - Loc.Z;
		if (Abs(HeightDelta) > CollisionHeight) continue;

		return true;
	}

	return false;
}

function xxRememberPosition()
{
	local float Now;

	Now = Level.TimeSeconds;
	if (Now < zzNextPositionTime)
		return;

	zzLast10Positions[zzPositionIndex] = Location;
	zzPositionIndex++;
	if (zzPositionIndex > 9)
		zzPositionIndex = 0;
	zzNextPositionTime = Now + 0.05;

}

function bool xxCloseEnough(vector HitLoc, optional int HitRadius)
{
	local int i, MaxHitError;
	local vector Loc;

	MaxHitError = zzUTPure.default.MaxHitError + HitRadius;

	if (VSize(HitLoc - Location) < MaxHitError)
		return true;

	for (i = 0; i < 10; i++)
	{
		Loc = zzLast10Positions[i];
		if (VSize(HitLoc - Loc) < MaxHitError)
			return true;
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

	return ( Weapon.IsA('ST_ImpactHammer') // UT weapons
		|| Weapon.IsA('ST_Translocator')
		//|| Weapon.IsA('ST_enforcer')
		|| Weapon.IsA('ST_ut_biorifle')
		|| Weapon.IsA('ST_ShockRifle')
		|| Weapon.IsA('ST_SuperShockRifle')
		|| Weapon.IsA('ST_PulseGun') && !bAlt
		|| Weapon.IsA('ST_ripper')
		//|| Weapon.IsA('ST_minigun2')
		|| Weapon.IsA('ST_UT_FlakCannon')
		|| Weapon.IsA('ST_UT_Eightball')
		|| Weapon.IsA('ST_SniperRifle')

		|| Weapon.IsA('ST_DispersionPistol') // Unreal weapons
		|| Weapon.IsA('ST_AutoMag')
		|| Weapon.IsA('ST_GESBioRifle')
		|| Weapon.IsA('ST_QuadShot')
		|| Weapon.IsA('ST_ASMD')
		|| Weapon.IsA('ST_Stinger')
		|| Weapon.IsA('ST_RazorJack')
		//|| Weapon.IsA('ST_Minigun')
		|| Weapon.IsA('ST_FlakCannon')
		|| Weapon.IsA('ST_Eightball')
		|| Weapon.IsA('ST_Rifle')

		|| Weapon.GetPropertyText("Allow55") == "TRUE"

		// For custom weapons
		|| Weapon.IsA('TOWeapons')
		|| Weapon.IsA('AXWeapons')
		|| Weapon.IsA('ST_WildcardsWeapons')
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

	if (!bShootDead)
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

	if (!bShootDead)
		return;

	ForEach AllActors(class'Carcass', C)
		if (C.Physics != PHYS_Falling)
			C.SetCollision(false, false, false);

}

exec function Fire( optional float F )
{
	local bbPlayer bbP;

	xxEnableCarcasses();
	if (!bNewNet || !xxWeaponIsNewNet())
	{
		if (xxCanFire())
			Super.Fire(F);
	}
	else if (Role < ROLE_Authority)
	{
		Weapon.ClientFire(1);
	}
	xxDisableCarcasses();
}

function xxNN_Fire( int ProjIndex, vector ClientLoc, vector ClientVel, rotator ViewRot, optional actor HitActor, optional vector HitLoc, optional vector HitDiff, optional bool bSpecial, optional int ClientFRVI, optional float ClientAccuracy )
{
	local ImpactHammer IH;
	local bbPlayer bbP;

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
		Super.Fire(1);
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

simulated function BetterVector GetBetterVector( vector SomeVector )
{
	local BetterVector Vec;
	Vec.X = SomeVector.X;
	Vec.Y = SomeVector.Y;
	Vec.Z = SomeVector.Z;
	return Vec;
}

simulated function vector GetVector( BetterVector SomeVector )
{
	local vector Vec;
	Vec.X = SomeVector.X;
	Vec.Y = SomeVector.Y;
	Vec.Z = SomeVector.Z;
	return Vec;
}

// Think about what you're doing.  Look at the bigger picture of it all, if you're able to.  This is a 15+ year old video game.
// Is this really the legacy you want to leave behind?  You'll never amount to anything if you keep this up.
// Seriously.  Do something good with your time.  Build something that improves lives.
// I understand that you are bitter, but you'll feel better if you listen to me.
// Doing good things will make you feel good.

function xxNN_TeleFrag( Teleporter Tele, Pawn Other )
{
	if (!IsInState('Dying') && !Other.IsInState('Dying') && !xxGarbageLocation(Other) && (!Other.IsA('bbPlayer') || VSize(Other.Location - Tele.Location) < TeleRadius))
		Other.GibbedBy(Self);
}

function xxNN_TransFrag( Pawn Other )
{
	if (!IsInState('Dying') && !Other.IsInState('Dying') && !xxGarbageLocation(Other) && (!Other.IsA('bbPlayer') || VSize(Other.Location - TTarget.Location) < TeleRadius))
		Other.GibbedBy(Self);
}

function xxNN_MoveTTarget( vector NewLoc, optional int Damage, optional Pawn EventInstigator, optional vector HitLocation, optional vector Momentum, optional name DamageType)
{
	local vector OldLoc;
	if (Role < ROLE_Authority || TTarget == None || xxGarbageLocation(TTarget) || VSize(NewLoc - TTarget.Location) > Class'UTPure'.Default.MaxPosError)
		return;

	OldLoc = TTarget.Location;
	if (!TTarget.SetLocation(NewLoc))
		TTarget.SetLocation(OldLoc);
	if (Damage >= 0)
		TTarget.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
}

simulated function xxNN_MoveClientTTarget( vector NewLoc, optional int Damage, optional Pawn EventInstigator, optional vector HitLocation, optional vector Momentum, optional name DamageType)
{
	local vector OldLoc;
	if (Role == ROLE_Authority || zzClientTTarget == None || xxGarbageLocation(zzClientTTarget))
		return;

	OldLoc = zzClientTTarget.Location;
	if (!zzClientTTarget.SetLocation(NewLoc))
		zzClientTTarget.SetLocation(OldLoc);
	if (Damage >= 0)
		zzClientTTarget.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
}

simulated function xxSetTeleRadius(int newRadius)
{
	TeleRadius = newRadius;
}

simulated function xxSetHitSounds(int DHS, int DTHS, bool bFDHS)
{
	DefaultHitSound = DHS;
	DefaultTeamHitSound = DTHS;
	bForceDefaultHitSounds = bFDHS;
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
		return s;
	}
}

function xxReplicateMove(
	float DeltaTime,
	vector NewAccel,
	eDodgeDir DodgeMove,
	rotator DeltaRot
) {
	local bbSavedMove NewMove, OldMove, LastMove;
	local byte ClientRoll;
	local float OldTimeDelta, TotalTime, NetMoveDelta;
	local int OldAccel;
	local vector BuildAccel, AccelNorm, Dir, RelLoc;
	local Pawn P;
	local vector Accel;
	local int MiscData;

	if (bDrawDebugData) {
		debugNewAccel = Normal(NewAccel);
		debugPlayerLocation = Location;
	}

	// Get a SavedMove actor to store the movement in.
	if ( PendingMove != None )
	{
		//add this move to the pending move
		PendingMove.TimeStamp = Level.TimeSeconds;
		if ( VSize(NewAccel) > 3072)
			NewAccel = 3072 * Normal(NewAccel);

		TotalTime = PendingMove.Delta + DeltaTime;
		if (TotalTime != 0)
			PendingMove.Acceleration = (DeltaTime * NewAccel + PendingMove.Delta * PendingMove.Acceleration)/TotalTime;

		// Set this move's data.
		if ( PendingMove.DodgeMove == DODGE_None )
			PendingMove.DodgeMove = DodgeMove;
		PendingMove.bRun = (bRun > 0);
		PendingMove.bDuck = (bDuck > 0);
		PendingMove.bPressedJump = bPressedJump || PendingMove.bPressedJump;
		PendingMove.Delta = TotalTime;
	}
	if ( SavedMoves != None )
	{
		NewMove = bbSavedMove(SavedMoves);
		AccelNorm = Normal(NewAccel);
		while ( NewMove.NextMove != None )
		{
			// find most recent interesting move to send redundantly
			if ( NewMove.bPressedJump || ((NewMove.DodgeMove != Dodge_NONE) && (NewMove.DodgeMove < 5))
				|| ((NewMove.Acceleration != NewAccel) && ((normal(NewMove.Acceleration) Dot AccelNorm) < 0.95)) ) // default value is 0.95
				OldMove = NewMove;
			NewMove = bbSavedMove(NewMove.NextMove);
		}
		if ( NewMove.bPressedJump || ((NewMove.DodgeMove != Dodge_NONE) && (NewMove.DodgeMove < 5))
			|| ((NewMove.Acceleration != NewAccel) && ((normal(NewMove.Acceleration) Dot AccelNorm) < 0.95)) )
			OldMove = NewMove;
	}

	LastMove = NewMove;
	NewMove = xxGetFreeMove();
	NewMove.Delta = DeltaTime;
	if ( VSize(NewAccel) > 3072 )
		NewAccel = 3072 * Normal(NewAccel);
	NewMove.Acceleration = NewAccel;

	// Set this move's data.
	NewMove.DodgeMove = DodgeMove;
	NewMove.TimeStamp = Level.TimeSeconds;
	NewMove.bRun = (bRun > 0);
	NewMove.bDuck = (bDuck > 0);
	NewMove.bPressedJump = bPressedJump;
	if ( Weapon != None ) // approximate pointing so don't have to replicate
		Weapon.bPointing = ((bFire != 0) || (bAltFire != 0));
	bJustFired = false;
	bJustAltFired = false;

	// Simulate the movement locally.
	ProcessMove(NewMove.Delta, NewMove.Acceleration, NewMove.DodgeMove, DeltaRot);
	AutonomousPhysics(NewMove.Delta);
	if (Role < ROLE_Authority)
	{
		zzbValidFire = false;
		zzbFire = bFire;
		zzbAltFire = bAltFire;
	}
	//log("Role "$Role$" repmove at "$Level.TimeSeconds$" Move time "$100 * DeltaTime$" ("$Level.TimeDilation$")");

	// Decide whether to hold off on move
	// send if dodge, jump, or fire unless really too soon, or if newmove.delta big enough
	// on client side, save extra buffered time in LastUpdateTime
	if ( PendingMove == None )
		PendingMove = NewMove;
	else
	{
		NewMove.NextMove = FreeMoves;
		FreeMoves = NewMove;
		FreeMoves.Clear();
		NewMove = bbSavedMove(PendingMove);
	}
	NewMove.SetRotation( Rotation );
	NewMove.SavedViewRotation = ViewRotation;
	NewMove.SavedLocation = Location;
	NewMove.SavedVelocity = Velocity;

	if (Player.CurrentNetSpeed != 0) {
		NetMoveDelta = TimeBetweenNetUpdates;
	}

	if ( !PendingMove.bForceFire && !PendingMove.bForceAltFire && !PendingMove.bPressedJump
		&& (PendingMove.Delta < NetMoveDelta - ClientUpdateTime) )
	{
		// save as pending move
		return;
	}
	else if ( (ClientUpdateTime < 0) && (PendingMove.Delta < NetMoveDelta - ClientUpdateTime) )
		return;
	else
	{
		ClientUpdateTime = PendingMove.Delta - NetMoveDelta;
		if ( SavedMoves == None )
			SavedMoves = PendingMove;
		else
			LastMove.NextMove = PendingMove;
		PendingMove = None;
	}

	// check if need to redundantly send previous move
	if ( OldMove != None )
	{
		// log("Redundant send timestamp "$OldMove.TimeStamp$" accel "$OldMove.Acceleration$" at "$Level.Timeseconds$" New accel "$NewAccel);
		// old move important to replicate redundantly
		OldTimeDelta = FMin(255, (Level.TimeSeconds - OldMove.TimeStamp) * 500);
		BuildAccel = 0.05 * OldMove.Acceleration + vect(0.5, 0.5, 0.5);
		OldAccel = (CompressAccel(BuildAccel.X) << 23)
					+ (CompressAccel(BuildAccel.Y) << 15)
					+ (CompressAccel(BuildAccel.Z) << 7);
		if ( OldMove.bRun )
			OldAccel += 64; // 64
		if ( OldMove.bDuck )
			OldAccel += 32; // 32
		if ( OldMove.bPressedJump )
			OldAccel += 16; // 16
		OldAccel += OldMove.DodgeMove;
	}
	//else
	//	log("No redundant timestamp at "$Level.TimeSeconds$" with accel "$NewAccel);

	// Send to the server
	if ( NewMove.bPressedJump )
		bJumpStatus = !bJumpStatus;

	Accel = NewMove.Acceleration * 10;

	if (Base == none)
		RelLoc = Location;
	else
		RelLoc = Location - Base.Location;

	if (NewMove.bRun) MiscData = MiscData | 0x40000;
	if (NewMove.bDuck) MiscData = MiscData | 0x20000;
	if (bJumpStatus) MiscData = MiscData | 0x10000;
	MiscData = MiscData | (int(NewMove.DodgeMove) << 8);
	MiscData = MiscData | ((Rotation.Roll >> 8) & 0xFF);

	xxServerMove(
		NewMove.TimeStamp,
		NewMove.Delta,
		Accel.X,
		Accel.Y,
		Accel.Z,
		RelLoc.X,
		RelLoc.Y,
		RelLoc.Z,
		Velocity,
		MiscData,
		((zzViewRotation.Pitch & 0xFFFF) << 16) | (zzViewRotation.Yaw & 0xFFFF),
		Base,
		OldTimeDelta,
		OldAccel
	);
	//log("Replicated "$self$" stamp "$NewMove.TimeStamp$" location "$Location$" dodge "$NewMove.DodgeMove$" to "$DodgeDir);
	if ( (Weapon != None) && !Weapon.IsAnimating() )
	{
		if ( (Weapon == ClientPending) || (Weapon != OldClientWeapon) )
		{
			if ( Weapon.IsInState('ClientActive') )
				AnimEnd();
			else
				Weapon.GotoState('ClientActive');
			if ( (Weapon != ClientPending) && (zzmyHud != None) && zzmyHud.IsA('ChallengeHUD') )
				ChallengeHUD(zzmyHud).WeaponNameFade = 1.3;
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
	local vector ThrowVelocity;

	if( Weapon==None || (Weapon.Class==Level.Game.BaseMutator.MutatedDefaultWeapon())
		|| !Weapon.bCanThrow )
		return;

	zzThrownWeapon = Weapon;
	zzThrownTime = Level.TimeSeconds;
	ThrowVelocity.X = zzThrowVelocity;
	ThrowVelocity.Y = zzThrowVelocity;
	ThrowVelocity.Z = 500;
	Weapon.Velocity = Vector(ViewRotation) * ThrowVelocity + vect(0,0,220);
	Weapon.bTossedOut = true;
	TossWeapon();
	if ( Weapon == None )
		SwitchToBestWeapon();
}

simulated function Sound loadHitSound(int c) {
	cHitSound[c] = Sound(DynamicLoadObject(sHitSound[c], class'Sound'));
	return cHitSound[c];
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

function string forcedTeamModelToString(int fm) {
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

simulated function setClientNetspeed() {

/**
 * @Author: spect
 * @Date: 2020-02-23 15:05:21
 * @Desc: Force client netspeed, gets set on every connect request, for now it remains at 20000
 */

	ConsoleCommand("netspeed 20000");
}

exec function enableDebugData(bool b) {
	bDrawDebugData = b;
	SaveConfig();
	if (b) {
		ClientMessage("Debug data: on");
	} else {
		ClientMessage("Debug data: off");
	}
}

exec function enableHitSounds(bool b) {
	bEnableHitSounds = b;
	SaveConfig();
	if (b) {
		ClientMessage("Hitsounds: on");
		reconnectClient();
	} else {
		ClientMessage("Hitsounds: off");
		reconnectClient();
	}
}

exec function setForcedSkins(int fs) {
	if (fs >= 0 && fs <= 17) {
		desiredSkin = fs;
		SaveConfig();
		ClientMessage("Forced enemy skin set!");
	} else
		ClientMessage("Please input a value between 0 and 17, e.g. setforcedskins 4");
}

exec function setForcedTeamSkins(int fs) {
	if (fs >= 0 && fs <= 17) {
		desiredTeamSkin = fs;
		SaveConfig();
		ClientMessage("Forced team skin set!");
	} else
		ClientMessage("Please input a value between 0 and 17, e.g. setforcedteamskins 4");
}

exec function setHitSound(int hs) {
	if (hs >= 0 && hs <= 16) {
		selectedHitSound = hs;
		SaveConfig();
		ClientMessage("Hitsound set!");
		reconnectClient();
	} else {
		ClientMessage("Please input a value between 0 and 16");
	}

}

exec function setShockBeam(int sb) {
	if (sb > 0 && sb <= 4) {
		cShockBeam = sb;
		SaveConfig();
		ClientMessage("Shock beam set!");
	} else
		ClientMessage("Please input a value between 1 and 4");
}

exec function setBeamScale(float bs) {
	if (bs >= 0.1 && bs <= 1.0) {
		BeamScale = bs;
		SaveConfig();
		ClientMessage("Beam scale set!");
	} else
		ClientMessage("Please input a value between 0.1 and 1.0");
}

exec function listSkins() {
	ClientMessage("Skin List:");
	ClientMessage("Input the desired number with the SetForcedSkins command");
	ClientMessage("0 - Class: Female Commando, Skin: Aphex, Face: Idina");
	ClientMessage("1 - Class: Female Commando, Skin: Commando, Face: Anna");
	ClientMessage("2 - Class: Female Commando, Skin: Mercenary, Face: Jayce");
	ClientMessage("3 - Class: Female Commando, Skin: Necris, Face: Cryss");
	ClientMessage("4 - Class: Female Soldier, Skin: Marine, Face: Annaka");
	ClientMessage("5 - Class: Female Soldier, Skin: Metal Guard, Face: Isis");
	ClientMessage("6 - Class: Female Soldier, Skin: Soldier, Face: Lauren");
	ClientMessage("7 - Class: Female Soldier, Skin: Venom, Face: Athena");
	ClientMessage("8 - Class: Female Soldier, Skin: War Machine, Face: Cathode");
	ClientMessage("9 - Class: Male Commando, Skin: Commando, Face: Blake");
	ClientMessage("10 - Class: Male Commando, Skin: Mercenary, Face: Boris");
	ClientMessage("11 - Class: Male Commando, Skin: Necris, Face: Grail");
	ClientMessage("12 - Class: Male Soldier, Skin: Marine, Face: Malcolm");
	ClientMessage("13 - Class: Male Soldier, Skin: Metal Guard, Face: Drake");
	ClientMessage("14 - Class: Male Soldier, Skin: RawSteel, Face: Arkon");
	ClientMessage("15 - Class: Male Soldier, Skin: Soldier, Face: Brock");
	ClientMessage("16 - Class: Male Soldier, Skin: War Machine, Face: Matrix");
	ClientMessage("17 - Class: Boss, Skin: Boss, Face: Xan");
}

exec function myIgSettings() {
	ClientMessage("Your IG+ client settings:");
	ClientMessage("Hitsounds:"@bEnableHitSounds);
	ClientMessage("Forced Models:"@zzbForceModels);
	ClientMessage("Current Enemy Forced Model:"@forcedModelToString(desiredSkin));
	ClientMessage("Current Team Forced Model:"@forcedTeamModelToString(desiredTeamSkin));
	ClientMessage("Current selected hit sound:"@playedHitSound);
	ClientMessage("Current Shock Beam:"@cShockBeam);
	ClientMessage("Current Beam Scale:"@BeamScale);
}

function xxCalcBehindView(out vector CameraLocation, out rotator CameraRotation, float Dist)
{
	local vector View,HitLocation,HitNormal;
	local float ViewDist;

	CameraRotation = zzViewRotation;
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
	local bbPlayer bbTarg;

//	Log("PlayerCalcView");

	if (zzInfoThing != None)
			zzInfoThing.zzPlayerCalcViewCalls--;

	if ( ViewTarget != None )
	{
		ViewActor = ViewTarget;
		CameraLocation = ViewTarget.Location;
		CameraRotation = ViewTarget.Rotation;
		PTarget = Pawn(ViewTarget);
		bbTarg = bbPlayer(ViewTarget);
		if ( PTarget != None )
		{
			if ( Level.NetMode == NM_Client )
			{
				if ( PTarget.bIsPlayer )
				{
					if (bbTarg != None)
						bbTarg.zzViewRotation = TargetViewRotation;
					PTarget.ViewRotation = TargetViewRotation;
				}
				PTarget.EyeHeight = TargetEyeHeight;
				if ( PTarget.Weapon != None )
					PTarget.Weapon.PlayerViewOffset = TargetWeaponViewOffset;
			}
			if ( PTarget.bIsPlayer )
				CameraRotation = PTarget.ViewRotation;
			if ( !bBehindView )
				CameraLocation.Z += PTarget.EyeHeight;
		}
		if ( bBehindView )
			xxCalcBehindView(CameraLocation, CameraRotation, 180);
		return;
	}

	ViewActor = Self;
	CameraLocation = Location;

	if( bBehindView ) //up and behind
		xxCalcBehindView(CameraLocation, CameraRotation, 150);
	else
	{
		if (zzbRepVRData)
		{	// Received data through demo replication.
			CameraRotation.Yaw = zzRepVRYaw;
			CameraRotation.Pitch = zzRepVRPitch;
			CameraRotation.Roll = 0;
			EyeHeight = zzRepVREye;
		}
		else if (zzInfoThing != None && zzInfoThing.zzPlayerCalcViewCalls == zzNull)
			CameraRotation = zzViewRotation;
		else
			CameraRotation = ViewRotation;
		CameraLocation.Z += EyeHeight;
		CameraLocation += WalkBob;
	}
}

function ViewShake(float DeltaTime)
{
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
		zzViewRotation.Roll = zzViewRotation.Roll & 65535;
		if (bShakeDir)
		{
			zzViewRotation.Roll += Int( 10 * shakemag * FMin(0.1, DeltaTime));
			bShakeDir = (zzViewRotation.Roll > 32768) || (zzViewRotation.Roll < (0.5 + FRand()) * shakemag);
			if ( (zzViewRotation.Roll < 32768) && (zzViewRotation.Roll > 1.3 * shakemag) )
			{
				zzViewRotation.Roll = 1.3 * shakemag;
				bShakeDir = false;
			}
			else if (FRand() < 3 * DeltaTime)
				bShakeDir = !bShakeDir;
		}
		else
		{
			zzViewRotation.Roll -= Int( 10 * shakemag * FMin(0.1, DeltaTime));
			bShakeDir = (zzViewRotation.Roll > 32768) && (zzViewRotation.Roll < 65535 - (0.5 + FRand()) * shakemag);
			if ( (zzViewRotation.Roll > 32768) && (zzViewRotation.Roll < 65535 - 1.3 * shakemag) )
			{
				zzViewRotation.Roll = 65535 - 1.3 * shakemag;
				bShakeDir = true;
			}
			else if (FRand() < 3 * DeltaTime)
				bShakeDir = !bShakeDir;
		}
	}
	else
	{
		ShakeVert = 0;
		zzViewRotation.Roll = zzViewRotation.Roll & 65535;
		if (zzViewRotation.Roll < 32768)
		{
			if ( zzViewRotation.Roll > 0 )
				zzViewRotation.Roll = Max(0, zzViewRotation.Roll - (Max(zzViewRotation.Roll,500) * 10 * FMin(0.1,DeltaTime)));
		}
		else
		{
			zzViewRotation.Roll += ((65536 - Max(500,zzViewRotation.Roll)) * 10 * FMin(0.1,DeltaTime));
			if ( zzViewRotation.Roll > 65534 )
				zzViewRotation.Roll = 0;
		}
	}
	ViewRotation = RotRand(False);
//	ViewRotation.Yaw = -32768;
//	ViewRotation.Pitch = Rand(65536)-32768;
	ViewRotation.Roll = zzViewRotation.Roll;
}

function UpdateRotation(float DeltaTime, float maxPitch);

function xxUpdateRotation(float DeltaTime, float maxPitch)
{
	local rotator newRotation;

	DesiredRotation = zzViewRotation; //save old rotation
	zzViewRotation.Pitch += 32.0 * DeltaTime * aLookUp;
	zzViewRotation.Pitch = zzViewRotation.Pitch & 65535;
	If ((zzViewRotation.Pitch > 18000) && (zzViewRotation.Pitch < 49152))
	{
		If (aLookUp > 0)
			zzViewRotation.Pitch = 18000;
		else
			zzViewRotation.Pitch = 49152;
	}
	zzViewRotation.Yaw += 32.0 * DeltaTime * aTurn;

	ViewShake(deltaTime);		// ViewRotation is fuked in here.
	ViewFlash(deltaTime);

	newRotation = Rotation;
	newRotation.Yaw = zzViewRotation.Yaw;
	newRotation.Pitch = zzViewRotation.Pitch;
	If ( (newRotation.Pitch > maxPitch * RotationRate.Pitch) && (newRotation.Pitch < 65536 - maxPitch * RotationRate.Pitch) )
	{
		If (zzViewRotation.Pitch < 32768)
			newRotation.Pitch = maxPitch * RotationRate.Pitch;
		else
			newRotation.Pitch = 65536 - maxPitch * RotationRate.Pitch;
	}
	setRotation(newRotation);

	if (!zzbRepVRData)
	{
		xxReplicateVRToDemo(zzViewRotation.Yaw, zzViewRotation.Pitch, EyeHeight);
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

	TraceDir = Normal(TraceDir);
	HitLocation = HitLocation + 0.33 * CollisionRadius * TraceDir; // default value is 0.4

	if ( (GetAnimGroup(AnimSequence) == 'Ducking') && (AnimFrame > -0.03) )
	{
		maxZ = Location.Z + 0.3 * CollisionHeight; // default value is 0.3
		if ( HitLocation.Z > maxZ )
		{
			if ( TraceDir.Z >= 0 )
				return false;
			adjZ = (maxZ - HitLocation.Z)/TraceDir.Z;
			HitLocation.Z = maxZ;
			HitLocation.X = HitLocation.X + TraceDir.X * adjZ;
			HitLocation.Y = HitLocation.Y + TraceDir.Y * adjZ;
			/* if ( VSize(HitLocation - Location) > CollisionRadius )
				return false; */
			delta = (HitLocation - Location) * vect(1,1,0);
			if (delta dot delta > CollisionRadius * CollisionRadius)
				return false;
		}
	}
	return true;
}

simulated function AddVelocity( vector NewVelocity )
{
	if (!bNewNet || Level.NetMode == NM_Client)
	{
		Super.AddVelocity(NewVelocity);
		return;
	}

	if (zzAddVelocityCount > 0)
	{
		if ( (zzExpectedVelocity.Z > 380) && (NewVelocity.Z > 0) )
			NewVelocity.Z *= 0.5;
		zzExpectedVelocity += NewVelocity;
	}
	else
	{
		if ( (Velocity.Z > 380) && (NewVelocity.Z > 0) )
			NewVelocity.Z *= 0.5;
		zzExpectedVelocity = Velocity + NewVelocity;
		zzAddVelocityCount = 0;
	}

	zzAddVelocityCount++;
	xxClientAddVelocity(NewVelocity);
}

simulated function xxClientAddVelocity(vector Velocity) {
	super.AddVelocity(Velocity);
}

simulated function NN_Momentum( Vector momentum, name DamageType )
{
	local bool bPreventLockdown;		// Avoid the lockdown effect.

//	Log("DamageType"@DamageType);

	if (DamageType == 'shot' || DamageType == 'zapped')
		bPreventLockdown = true; //zzUTPure.bNoLockdown;

	//log(self@"take damage in state"@GetStateName());

	if (Base != None)
		momentum.Z = FMax(momentum.Z, 0.4 * VSize(momentum));
	//if ( InstigatedBy == self )
	//	momentum *= 0.6;
	if (Mass != 0)
		momentum = momentum/Mass;

//	Log("PL"@!bPreventLockdown);
	if (!bPreventLockdown)	// FIX BY LordHypnos, http://forums.prounreal.com/viewtopic.php?t=34676&postdays=0&postorder=asc&start=0
		AddVelocity( momentum );
}

function TakeDamage( int Damage, Pawn InstigatedBy, Vector HitLocation,
						Vector momentum, name damageType)
{
	local int actualDamage;
	local bool bAlreadyDead;
	local int ModifiedDamage1, ModifiedDamage2, RecentDamage;
	local bool bPreventLockdown;		// Avoid the lockdown effect.
	local Pawn P;
	local Inventory Inv;
	local Weapon W;

	if ( Role < ROLE_Authority )
	{
		Log(Self@"client damage type"@damageType@"by"@InstigatedBy);
		return;
	}
//	Log("DamageType"@DamageType);

	//log(self@"take damage in state"@GetStateName());
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

	if (InstigatedBy != self && (momentum dot momentum) > 0)	// FIX BY LordHypnos, http://forums.prounreal.com/viewtopic.php?t=34676&postdays=0&postorder=asc&start=0
	{
		AddVelocity( momentum );
	}

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
		//log(self$" died");
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
		//Warn(self$" took regular damage "$damagetype$" from "$instigator$" while already dead");
		// SpawnGibbedCarcass();
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
//	Log("DamageType"@DamageType);

	if (InstigatedBy == Self || InstigatedBy.Health <= 0 || Health >= 199)
		return;

	if (DamageType == 'shot' || DamageType == 'zapped')
		bPreventLockdown = true; //zzUTPure.bNoLockdown;

	//log(self@"take damage in state"@GetStateName());
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

//	Log("PL"@!bPreventLockdown);
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
	//if (CarriedDecoration != None)
	//	DropDecoration();
	if ( HitLocation == vect(0,0,0) )
		HitLocation = Location;
	if (InstigatedBy.Health > 0)
	{
		//if ( (InstigatedBy != None) && (InstigatedBy != Self) )
		//	damageAttitudeTo(InstigatedBy);
		//PlayHit(actualDamage, HitLocation, damageType, Momentum);
	}
	else if ( !bAlreadyDead )
	{
		//log(self$" died");
		InstigatedBy.NextState = '';
		//PlayDeathHit(actualDamage, HitLocation, damageType, Momentum);
		if ( actualDamage > InstigatedBy.mass )
			InstigatedBy.Health = -1 * actualDamage;
		//if ( (InstigatedBy != None) && (InstigatedBy != Self) )
		//	damageAttitudeTo(InstigatedBy);
		InstigatedBy.Died(InstigatedBy, damageType, HitLocation);
	}
	else
	{
		//Warn(self$" took regular damage "$damagetype$" from "$instigator$" while already dead");
		// SpawnGibbedCarcass();
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
//	Log("DamageType"@DamageType);

	if (InstigatedBy == Self)
		return;

	if (DamageType == 'shot' || DamageType == 'zapped')
		bPreventLockdown = true; //zzUTPure.bNoLockdown;

	//log(self@"take damage in state"@GetStateName());
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

//	Log("PL"@!bPreventLockdown);
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
		//log(self$" died");
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
		//Warn(self$" took regular damage "$damagetype$" from "$instigator$" while already dead");
		// SpawnGibbedCarcass();
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
	local carcass carc;
	local Weapon W;
	local bbPlayer bbK;

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
	//log(class$" dying");
	if( Event != '' )
		foreach AllActors( class 'Actor', A, Event )
			A.Trigger( Self, Killer );

	//Level.Game.DiscardInventory(self);

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
	GotoState('Dying');
}

simulated function PlayHitSound(int Dmg)
{
	local Actor SoundPlayer;
	local float Pitch;
	local int HS;

	local PlayerPawn PP;

	if (Dmg > 0) {

		zzRecentDmgGiven += Dmg;

	} else if (zzRecentDmgGiven > 0) {

		LastPlaySound = Level.TimeSeconds;	// so voice messages won't overlap

		if ( ViewTarget != None )
			SoundPlayer = ViewTarget;
		else
			SoundPlayer = Self;

		Pitch = FClamp(42/zzRecentDmgGiven, 0.22, 3.2);
		zzRecentDmgGiven = 0;

		if (bForceDefaultHitSounds && !bDisableForceHitSounds)
			HS = DefaultHitSound;
		else
			HS = HitSound;

		if (HS == 1)
			SoundPlayer.PlaySound(Sound'UnrealShare.StingerFire', SLOT_None, 255.0, True);
		else if (HS == 2)
			SoundPlayer.PlaySound(Sound'HitSound', SLOT_None, 255.0, True,, Pitch);
		else if (HS == 3)
			SoundPlayer.PlaySound(Sound'HitSoundFriendly', SLOT_None, 255.0, True);

		zzLastHitSound = LastPlaySound;

	}
}

simulated function PlayTeamHitSound(int Dmg)
{
	local Actor SoundPlayer;
	local float Pitch;
	local int HS;

	if (Dmg > 0) {

		zzRecentTeamDmgGiven += Dmg;

	} else if (zzRecentTeamDmgGiven > 0) {

		LastPlaySound = Level.TimeSeconds;	// so voice messages won't overlap

		if ( ViewTarget != None )
			SoundPlayer = ViewTarget;
		else
			SoundPlayer = Self;

		Pitch = FClamp(42/zzRecentTeamDmgGiven, 0.22, 3.2);
		zzRecentTeamDmgGiven = 0;

		if (bForceDefaultHitSounds && !bDisableForceHitSounds)
			HS = DefaultTeamHitSound;
		else
			HS = TeamHitSound;

		if (HS == 1)
			SoundPlayer.PlaySound(Sound'UnrealShare.StingerFire', SLOT_None, 255.0, True);
		else if (HS == 2)
			SoundPlayer.PlaySound(Sound'HitSound', SLOT_None, 255.0, True,, Pitch);
		else if (HS == 3)
			SoundPlayer.PlaySound(Sound'HitSoundFriendly', SLOT_None, 255.0, True);

		zzLastTeamHitSound = LastPlaySound;

	}
}

simulated function CheckHitSound()
{
	if (zzRecentDmgGiven > 0 && Level.TimeSeconds - zzLastHitSound > 0.1)
		PlayHitSound(0);

	if (zzRecentTeamDmgGiven > 0 && Level.TimeSeconds - zzLastTeamHitSound > 0.1)
		PlayTeamHitSound(0);
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
		float FrameTime,
		float AccelX,
		float AccelY,
		float AccelZ,
		float ClientLocX,
		float ClientLocY,
		float ClientLocZ,
		vector ClientVel,
		int MiscData,
		int View,
		Actor ClientBase,
		optional byte OldTimeDelta,
		optional int OldAccel
	)
	{
		Global.xxServerMove(
			TimeStamp,
			FrameTime,
			AccelX,
			AccelY,
			AccelZ,
			ClientLocX,
			ClientLocY,
			ClientLocZ,
			ClientVel,
			MiscData,
			((Rotation.Pitch & 0xFFFF) << 16) | (Rotation.Yaw & 0xFFFF),
			ClientBase,
			OldTimeDelta,
			OldAccel);
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

		//if (!zzbWeaponTracer)
			ViewRotation = zzViewRotation;

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			xxReplicateMove(DeltaTime, NewAccel, DODGE_None, Rot(0,0,0));
		else
			ProcessMove(DeltaTime, NewAccel, DODGE_None, Rot(0,0,0));
		bPressedJump = false;
	}

	event PlayerTick( float DeltaTime )
	{
		zzbCanCSL = zzFalse;
		xxPlayerTickEvents();
		zzTick = DeltaTime;
		Super.PlayerTick(DeltaTime);
	}

	function BeginState()
	{
		local byte zzOldbfire, zzOldbAlt;

		Super.BeginState();
		// Stop weapon firing
 		//UsAaR33: prevent weapon from firing (brought on by missing bchangedweapon checks)
		if (zzbNoMultiWeapon && Weapon != none && (baltfire>0||bfire>0) )
		{ //could only be true on server
			zzOldbfire=bfire;
			zzOldbAlt=baltfire;
			baltfire=0;
			bfire=0;
			//additional hacks to stop weapons:
			if (Weapon.Isa('Minigun2'))
				Minigun2(Weapon).bFiredShot=true;
			if (Weapon.IsA('Chainsaw'))   //Saw uses sleep delays in states.
				Weapon.Finish();
			Weapon.Tick(0);
			Weapon.AnimEnd();
			zzbFire=zzOldbfire;
			zzbAltFire=zzOldbAlt;
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
	/*
	simulated function Bump( actor Other )
	{
		if (Other.IsA('Mover'))
			xxMover_DoBump(Mover(Other));
	}
	*/
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
		zzbCanCSL = zzFalse;
		xxPlayerTickEvents();
		zzTick = DeltaTime;
		Super.PlayerTick(DeltaTime);
	}

	function PlayerMove(float DeltaTime)
	{
		local rotator oldRotation;
		local vector X,Y,Z, NewAccel;
		local float Speed2D;

		GetAxes(zzViewRotation,X,Y,Z);

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

		//if (!zzbWeaponTracer)
			ViewRotation = zzViewRotation;

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			xxReplicateMove(DeltaTime, NewAccel, DODGE_None, OldRotation - Rotation);
		else
			ProcessMove(DeltaTime, NewAccel, DODGE_None, OldRotation - Rotation);
		bPressedJump = false;
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
			//log("timer out of water");
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
//		log("BeginState: PlayerSwimming");
	}
}

state PlayerFlying
{
	/*
	simulated function Bump( actor Other )
	{
		if (Other.IsA('Mover'))
			xxMover_DoBump(Mover(Other));
	}
	*/
	event PlayerTick( float DeltaTime )
	{
		zzbCanCSL = zzFalse;
		xxPlayerTickEvents();
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

		//if (!zzbWeaponTracer)
			ViewRotation = zzViewRotation;

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			xxReplicateMove(DeltaTime, Acceleration, DODGE_None, rot(0,0,0));
		else
			ProcessMove(DeltaTime, Acceleration, DODGE_None, rot(0,0,0));
	}
}

// ==================================================================

state CheatFlying
{
	/*
	simulated function Bump( actor Other )
	{
		if (Other.IsA('Mover'))
			xxMover_DoBump(Mover(Other));
	}
	*/
	event PlayerTick( float DeltaTime )
	{
		zzbCanCSL = zzFalse;
		xxPlayerTickEvents();
		zzTick = DeltaTime;
		Super.PlayerTick(DeltaTime);
	}

	function PlayerMove(float DeltaTime)
	{
		local vector X,Y,Z;

		GetAxes(zzViewRotation,X,Y,Z);

		aForward *= 0.1;
		aStrafe  *= 0.1;
		aLookup  *= 0.24;
		aTurn    *= 0.24;
		aUp		 *= 0.1;

		Acceleration = aForward*X + aStrafe*Y + aUp*vect(0,0,1);

		xxUpdateRotation(DeltaTime, 1);

		//if (!zzbWeaponTracer)
			ViewRotation = zzViewRotation;

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			xxReplicateMove(DeltaTime, Acceleration, DODGE_None, rot(0,0,0));
		else
			ProcessMove(DeltaTime, Acceleration, DODGE_None, rot(0,0,0));
	}
}

state PlayerWalking
{
ignores SeePlayer, HearNoise, Bump;

	/*
	simulated function Bump( actor Other )
	{
		if (Other.IsA('Mover'))
			xxMover_DoBump(Mover(Other));
	}
	*/

	function Landed(vector HitNormal)
	{
		if (DodgeDir == DODGE_Active)
		{
			DodgeDir = DODGE_Done;
			DodgeClickTimer = 0.0;
			Velocity.X *= 0.1; // 0.1
			Velocity.Y *= 0.1;
		}
		else
			DodgeDir = DODGE_None;
		Global.Landed(HitNormal);
	}

	simulated function Dodge(eDodgeDir DodgeMove)
    {
        local vector X,Y,Z;

        if ( bIsCrouching || (Physics != PHYS_Walking) )
            return;

        GetAxes(Rotation,X,Y,Z);
        if (DodgeMove == DODGE_Forward)
            Velocity = 1.5*GroundSpeed*X + (Velocity Dot Y)*Y;
        else if (DodgeMove == DODGE_Back)
            Velocity = -1.5*GroundSpeed*X + (Velocity Dot Y)*Y;
        else if (DodgeMove == DODGE_Left)
            Velocity = 1.5*GroundSpeed*Y + (Velocity Dot X)*X;
        else if (DodgeMove == DODGE_Right)
            Velocity = -1.5*GroundSpeed*Y + (Velocity Dot X)*X;

        Velocity.Z = 160;
        PlayOwnedSound(JumpSound, SLOT_Talk, 1.0, true, 800, 1.0 );
        PlayDodge(DodgeMove);
        DodgeDir = DODGE_Active;
        SetPhysics(PHYS_Falling);
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
		local bool bIgnoreDodge;

		if (Mesh == None)
		{
//			Log("PlayerMove->Mesh"@Mesh);
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
					if (MinDodgeClickTime == 0 || Now - zzLastTimeForward > MinDodgeClickTime)
						DodgeDir = DODGE_Forward;
					else
						bIgnoreDodge = true;
				}
				else if (bEdgeBack && bWasBack)
				{
					if (MinDodgeClickTime == 0 || Now - zzLastTimeBack > MinDodgeClickTime)
						DodgeDir = DODGE_Back;
					else
						bIgnoreDodge = true;
				}
				else if (bEdgeLeft && bWasLeft)
				{
					if (MinDodgeClickTime == 0 || Now - zzLastTimeLeft > MinDodgeClickTime)
						DodgeDir = DODGE_Left;
					else
						bIgnoreDodge = true;
				}
				else if (bEdgeRight && bWasRight)
				{
					if (MinDodgeClickTime == 0 || Now - zzLastTimeRight > MinDodgeClickTime)
						DodgeDir = DODGE_Right;
					else
						bIgnoreDodge = true;
				}

				if ( DodgeDir == DODGE_None)
					DodgeDir = OldDodge;
				else if ( DodgeDir != OldDodge )
					DodgeClickTimer = DodgeClickTime + 0.5 * DeltaTime;
				else
					DodgeMove = DodgeDir;
			}

			if (DodgeDir == DODGE_Done || DodgeDir == DODGE_Active && Base != None)
			{
				DodgeClickTimer -= DeltaTime;
				if (DodgeClickTimer < -0.35 || bIgnoreDodge)
				{
					DodgeDir = DODGE_None;
					DodgeClickTimer = DodgeClickTime;
				}
			}
			else if ((DodgeDir != DODGE_None) && (DodgeDir != DODGE_Active))
			{
				DodgeClickTimer -= DeltaTime;
				if (DodgeClickTimer < 0 || bIgnoreDodge)
				{
					DodgeDir = DODGE_None;
					DodgeClickTimer = DodgeClickTime;
				}
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
					zzViewRotation.Pitch = FindStairRotation(deltaTime);
				else if ( bCenterView )
				{
					zzViewRotation.Pitch = zzViewRotation.Pitch & 65535;
					if (zzViewRotation.Pitch > 32768)
						zzViewRotation.Pitch -= 65536;
					zzViewRotation.Pitch = zzViewRotation.Pitch * (1 - 12 * FMin(0.0833, deltaTime));
					if ( Abs(zzViewRotation.Pitch) < 1000 )
						zzViewRotation.Pitch = 0;
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

		//if (!zzbWeaponTracer)
			ViewRotation = zzViewRotation;

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			xxReplicateMove(DeltaTime, NewAccel, DodgeMove, OldRotation - Rotation);
		else
			ProcessMove(DeltaTime, NewAccel, DodgeMove, OldRotation - Rotation);
		bPressedJump = bSaveJump;
	}

	event PlayerTick( float DeltaTime )
	{
		zzbCanCSL = zzFalse;
		xxPlayerTickEvents();
		zzTick = DeltaTime;
		Super.PlayerTick(DeltaTime);
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
		if (Physics != PHYS_Falling) SetPhysics(PHYS_Walking);
		if ( !IsAnimating() )
			PlayWaiting();
//		Log("BeginState: PlayerWalking");
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
		zzbCanCSL = zzFalse;
		xxPlayerTickEvents();
		zzTick = DeltaTime;
		Super.PlayerTick(DeltaTime);
	}

	function PlayerMove(float DeltaTime)
	{
		local vector X,Y,Z;

		GetAxes(zzViewRotation,X,Y,Z);

		aForward *= 0.12; // 0.1
		aStrafe  *= 0.12;
		aLookup  *= 0.24;
		aTurn    *= 0.24;
		aUp		 *= 0.12;

		Acceleration = aForward*X + aStrafe*Y + aUp*vect(0,0,1);

		xxUpdateRotation(DeltaTime, 1);

		//if (!zzbWeaponTracer)
			ViewRotation = zzViewRotation;

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			xxReplicateMove(DeltaTime, Acceleration, DODGE_None, rot(0,0,0));
		else
			ProcessMove(DeltaTime, Acceleration, DODGE_None, rot(0,0,0));
	}

	exec function Fire(optional float F)
	{
		if (!bIsFinishedLoading) {
			GoToState('PlayerWaiting');
			return;
		}
		bReadyToPlay = true;
		xxServerSetReadyToPlay();
	}

	exec function AltFire(optional float F)
	{
		if (!bIsFinishedLoading) {
			GoToState('PlayerWaiting');
			return;
		}
		bReadyToPlay = true;
		xxServerSetReadyToPlay();
	}

}

/******************************************
 *				Animations
 ******************************************
*/

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
	local bbPlayer P;

	if (bDeterminedLocalPlayer) return LocalPlayer;

	foreach AllActors(class'bbPlayer', P) {
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
	Velocity.Z = 210;
	if ( DodgeMove == DODGE_Left )
		TweenAnim('DodgeL', 0.1);
	else if ( DodgeMove == DODGE_Right )
		TweenAnim('DodgeR', 0.1);
	else if ( DodgeMove == DODGE_Back )
		TweenAnim('DodgeB', 0.1);
	else {
		PlayAnim('Flip', 1.35 * FMax(0.35, Region.Zone.ZoneGravity.Z/Region.Zone.Default.ZoneGravity.Z), 0.065);
	}
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
//	Log("moo:"@DMP.bRequireReady@DMP.CountDown);
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
	local PureStatMutator PSM;
	local string WeaponList[32], s;
	local int WeapCnt, x;				// Grr, wish UT had dyn arrays :P
	local bool bAlready;
	local string PreFix;

	DMP = DeathMatchPlus(Level.Game);
	if (DMP == None) return;			// If DMP is none, I would never be here, so darnit really? :P

	if (DMP.BaseMutator != None)			// Add the default weapon
		WeaponList[WeapCnt++] = string(DMP.BaseMutator.MutatedDefaultWeapon());

	/* if (bNewNet)
	{
		PreFix = "UN"$class'UTPure'.default.ThisVer$".";

		WeaponList[WeapCnt++] = PreFix$"ST_enforcer";	// If it is instagib/other the enforcer will be removed upon spawn

		if (DMP.bUseTranslocator)			// Sneak in translocator
			WeaponList[WeapCnt++] = PreFix$"ST_Translocator";
	}
	else
	{
		PreFix = "Botpack.";

		WeaponList[WeapCnt++] = "Botpack.Enforcer";	// If it is instagib/other the enforcer will be removed upon spawn

		if (DMP.bUseTranslocator)			// Sneak in translocator
			WeaponList[WeapCnt++] = "Botpack.Translocator";
	}

	for (x = 0; x < 8; x++)
		if (zzUTPure.zzDefaultWeapons[x] != '')
		{
			if (zzUTPure.zzDefaultPackages[x] == "")
				WeaponList[WeapCnt++] = PreFix$string(zzUTPure.zzDefaultWeapons[x]);
			else
				WeaponList[WeapCnt++] = zzUTPure.zzDefaultPackages[x]$"."$string(zzUTPure.zzDefaultWeapons[x]);
		} */

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

		NewJumpZ = Default.JumpZ * 1.1;
		if (NewJumpZ > 0)
			JumpZ = NewJumpZ;

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
		//if (Self == InstigatedBy)
		//{
		//	Damage = 0;		// No self damage in warmup.
		//	momentum *= 2;		// And 2x momentum.
		//}
		Global.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
	}

}



// =======================
state PlayerSpectating
{
	event PlayerTick( float DeltaTime )
	{
		zzbCanCSL = zzFalse;
		xxPlayerTickEvents();
		zzTick = DeltaTime;
		Super.PlayerTick(DeltaTime);
	}

	function PlayerMove(float DeltaTime)
	{
		local vector X,Y,Z;

		GetAxes(zzViewRotation,X,Y,Z);

		aForward *= 0.1;
		aStrafe  *= 0.1;
		aLookup  *= 0.24;
		aTurn    *= 0.24;
		aUp		 *= 0.1;

		Acceleration = aForward*X + aStrafe*Y + aUp*vect(0,0,1);

		xxUpdateRotation(DeltaTime, 1);

		//if (!zzbWeaponTracer)
			ViewRotation = zzViewRotation;

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
		zzbCanCSL = zzFalse;
		xxPlayerTickEvents();
		zzTick = DeltaTime;
		Super.PlayerTick(DeltaTime);
	}

	function PlayerMove(Float DeltaTime)
	{
		ViewFlash(deltaTime * 0.5);
		if ( TimerRate == 0 )
		{
			zzViewRotation.Pitch -= DeltaTime * 12000;
			if ( zzViewRotation.Pitch < 0 )
			{
				zzViewRotation.Pitch = 0;
				GotoState('PlayerWalking');
			}
			ViewRotation.Pitch = zzViewRotation.Pitch;
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
			zzViewRotation.Pitch = 0;
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
    exec function Fire( optional float F )
    {
        if (Level.NetMode == NM_DedicatedServer && Role == ROLE_Authority) {
            bJustFired = true;
            if( bShowMenu || (Level.Pauser != "") )
            {
                if ( !bShowMenu && (Level.Pauser == PlayerReplicationInfo.PlayerName)  )
                    SetPause(False);
                return;
            }
            if( Weapon != None )
            {
                Weapon.bPointing = true;
                //PlayFiring();
                Weapon.Fire(F);
            }
        } else {
            super.Fire(F);
        }
    }

	function ServerReStartPlayer()
	{
		//log("calling restartplayer in dying with netmode "$Level.NetMode);
		if ( Level.NetMode == NM_Client || bFrozen && (TimerRate>0.0) )
			return;

		Level.Game.DiscardInventory(self);

		if ( /* xxRestartPlayer() || */ Level.Game.RestartPlayer(self) )
		{
			//Log("Calling ServerReStartPlayer()");
			ServerTimeStamp = 0;
			TimeMargin = 0;
			Enemy = None;
			Level.Game.StartPlayer(self);
			if ( Mesh != None )
				PlayWaiting();

			ClientReStart();

			ChangedWeapon();
			zzSpawnedTime = Level.TimeSeconds;
		}
		else
		{
			log("Restartplayer failed");
		}

	}

	event PlayerTick( float DeltaTime )
	{
		zzbCanCSL = zzFalse;
		xxPlayerTickEvents();
		zzTick = DeltaTime;
		Super.PlayerTick(DeltaTime);
	}

	simulated function BeginState()
	{
		local bbPlayer bbP;
    	local float LKT;

    	/* xxSendNextStartSpot(); */
		bMustUpdate = true;
		bClientIsWalking = false;
    	bJumpStatus = false;
		bIsAlive = false;
    	zzIgnoreUpdateUntil = 0;
    	if (zzClientTTarget != None)
        	zzClientTTarget.Destroy();

    	LKT = LastKillTime;
    	Super.BeginState();
    	LastKillTime = LKT;
	}

	function PlayerMove(float DeltaTime)
	{
		local vector X,Y,Z;

		if ( !bFrozen )
		{
			if ( bPressedJump )
			{
				Fire(0);
				bPressedJump = false;
			}
			GetAxes(zzViewRotation,X,Y,Z);
			// Update view rotation.
			aLookup  *= 0.24;
			aTurn    *= 0.24;
			zzViewRotation.Yaw += 32.0 * DeltaTime * aTurn;
			zzViewRotation.Pitch += 32.0 * DeltaTime * aLookUp;
			zzViewRotation.Pitch = zzViewRotation.Pitch & 65535;
			If ((zzViewRotation.Pitch > 18000) && (zzViewRotation.Pitch < 49152))
			{
				If (aLookUp > 0)
					zzViewRotation.Pitch = 18000;
				else
					zzViewRotation.Pitch = 49152;
			}
			ViewRotation = zzViewRotation;
		}
		ViewShake(DeltaTime);
		ViewFlash(DeltaTime);
		ViewRotation = zzViewRotation;
	}

	function xxServerMove
	(
		float TimeStamp,
		float FrameTime,
		float AccelX,
		float AccelY,
		float AccelZ,
		float ClientLocX,
		float ClientLocY,
		float ClientLocZ,
		vector ClientVel,
		int MiscData,
		int View,
		Actor ClientBase,
		optional byte OldTimeDelta,
		optional int OldAccel
	)
	{
		Global.xxServerMove(
			TimeStamp,
			FrameTime,
			AccelX,
			AccelY,
			AccelZ,
			ClientLocX,
			ClientLocY,
			ClientLocZ,
			ClientVel,
			MiscData & 0xFFFF,
			View,
			ClientBase,
			OldTimeDelta,
			OldAccel);
	}

	function FindGoodView()
	{
		local vector cameraLoc;
		local rotator cameraRot;
		local int tries, besttry;
		local float bestdist, newdist;
		local int startYaw;
		local actor ViewActor;

		//fixme - try to pick view with killer visible
		//fixme - also try varying starting pitch
		////log("Find good death scene view");

		zzViewRotation.Pitch = 56000;
		tries = 0;
		besttry = 0;
		bestdist = 0.0;
		startYaw = zzViewRotation.Yaw;

		for (tries=0; tries<16; tries++)
		{
			cameraLoc = Location;
			PlayerCalcView(ViewActor, cameraLoc, cameraRot);
			newdist = VSize(cameraLoc - Location);
			if (newdist > bestdist)
			{
				bestdist = newdist;
				besttry = tries;
			}
			zzViewRotation.Yaw += 4096;
		}
		if (zzInfoThing != None)
			zzInfoThing.zzPlayerCalcViewCalls = 1;

		zzViewRotation.Yaw = startYaw + besttry * 4096;
		ViewRotation.Yaw = zzViewRotation.Yaw;
	}

	function EndState()
	{
		Super.EndState();
		LastKillTime = 0;
	}

}

state CountdownDying extends Dying
{

	exec function Fire( optional float F ) {}

	function EndState() {
		Self.bBehindView = false;
		ServerReStartPlayer();
	}

}

state GameEnded
{
ignores SeePlayer, HearNoise, KilledBy, Bump, HitWall, HeadZoneChange, FootZoneChange, ZoneChange, Falling, TakeDamage, PainTimer, Died;

	function ServerReStartGame();

	event PlayerTick( float DeltaTime )
	{
		zzbCanCSL = zzFalse;
		xxPlayerTickEvents();
		zzTick = DeltaTime;
		Super.PlayerTick(DeltaTime);
	}

	function PlayerMove(float DeltaTime)
	{
		local vector X,Y,Z;

		GetAxes(zzViewRotation,X,Y,Z);
		// Update view rotation.

		if ( !bFixedCamera )
		{
			aLookup  *= 0.24;
			aTurn    *= 0.24;
			zzViewRotation.Yaw += 32.0 * DeltaTime * aTurn;
			zzViewRotation.Pitch += 32.0 * DeltaTime * aLookUp;
			zzViewRotation.Pitch = zzViewRotation.Pitch & 65535;
			If ((zzViewRotation.Pitch > 18000) && (zzViewRotation.Pitch < 49152))
			{
				If (aLookUp > 0)
					zzViewRotation.Pitch = 18000;
				else
					zzViewRotation.Pitch = 49152;
			}
		}
		else if ( ViewTarget != None )
			zzViewRotation = ViewTarget.Rotation;

		ViewRotation = zzViewRotation;
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
		float FrameTime,
		float AccelX,
		float AccelY,
		float AccelZ,
		float ClientLocX,
		float ClientLocY,
		float ClientLocZ,
		vector ClientVel,
		int MiscData,
		int View,
		Actor ClientBase,
		optional byte OldTimeDelta,
		optional int OldAccel
	)
	{
		Global.xxServerMove(
			TimeStamp,
			FrameTime,
			AccelX,
			AccelY,
			AccelZ,
			ClientLocX,
			ClientLocY,
			ClientLocZ,
			ClientVel,
			MiscData,
			((zzViewRotation.Pitch & 0xFFFF) << 16) | (zzViewRotation.Yaw & 0xFFFF),
			ClientBase,
			OldTimeDelta,
			OldAccel);
	}

	function FindGoodView()
	{
		local vector cameraLoc;
		local rotator cameraRot;
		local int tries, besttry;
		local float bestdist, newdist;
		local int startYaw;
		local actor ViewActor;

		zzViewRotation.Pitch = 56000;
		tries = 0;
		besttry = 0;
		bestdist = 0.0;
		startYaw = zzViewRotation.Yaw;

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
			zzViewRotation.Yaw += 4096;
		}
		if (zzInfoThing != None)
			zzInfoThing.zzPlayerCalcViewCalls = 1;

		zzViewRotation.Yaw = startYaw + besttry * 4096;
	}
}

function PlayWaiting()
{
	local name newAnim;

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
		zzViewRotation.Pitch = zzViewRotation.Pitch & 65535;
		If ( (zzViewRotation.Pitch > RotationRate.Pitch)
			&& (zzViewRotation.Pitch < 65536 - RotationRate.Pitch) )
		{
			If (zzViewRotation.Pitch < 32768)
			{
				if ( (Weapon == None) || (Weapon.Mass < 20) ) {
					TweenAnim('AimUpSm', 0.3);
				} else {
					TweenAnim('AimUpLg', 0.3);
				}
			}
			else
			{
				if ( (Weapon == None) || (Weapon.Mass < 20) )
					TweenAnim('AimDnSm', 0.3);
				else
					TweenAnim('AimDnLg', 0.3);
			}
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

	//DamageClass = class(damageType);
	if ( ReducedDamageType != 'All' ) //spawn some blood
	{
		if (damageType == 'Drowned')
		{
			bub = spawn(class 'Bubble1',,, Location
				+ 0.7 * CollisionRadius * vector(zzViewRotation) + 0.3 * EyeHeight * vect(0,0,1));
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

////////////////////////////
// CRC Checks on UTPure Itself
////////////////////////////

//Server asks Client for a CRC check (unreliable... called each servermove) <-- usaar = funney, reliable, called once
simulated function xxClientMD5(string zzPackage, string zzInit)
{
//	Log("Init"@zzInit);
	xxServerTestMD5(""); //PackageMD5(zzPackage, zzInit));
}

function xxServerTestMD5(string zzClientMD5)
{
//	Log("Client"@zzClientMD5);
//	if (zzClientMD5 != zzUTPure.zzPureMD5)
//		xxServerCheater("MD5");
	zzbDidMD5 = True;
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
	local float Diff;
	local name WeapState;

	if (zzSwitchedTime > 0)
	{
		Weapon.bChangeWeapon = true;
		bCant = true;
	}
	Diff = Level.TimeSeconds - zzSpawnedTime;
	if (Diff < 1)
	{
		if (Diff > 0.3)
			return false;
		else
			return true;
	}
	if (PendingWeapon != None)
	{
		PendingWeapon.bChangeWeapon = false;
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
  	else if (Weapon.IsInState('ClientDown'))
	{
		bCant = true;
	}
	else if (Weapon.AnimSequence == 'Down')
	{
		bCant = true;
	}
	if (!Weapon.bWeaponUp)
	{
		WeapState = Weapon.GetStateName();
		if (WeapState == 'ClientFiring' || WeapState == 'ClientAltFiring' || WeapState == 'Idle' || WeapState == '' || WeapState == Weapon.Class.Name || Weapon.AnimSequence == 'Still')
			Weapon.bWeaponUp = true;
		else
			bCant = true;
	}
 	if (IsInState('Dying'))
	{
		bCant = true;
	}
	else if (!bCant)
	{
		bCant = (Player == None) || (PureSuperDuperConsole(Player.Console) == None);
	}
	else if (!bCant && (Weapon != None) && Weapon.IsInState('ClientActive'))
	{
		Weapon.GotoState('');
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

function xxPlayerTickEvents()
{
	local float CurrentTime, ClosestDist, Dist;

	CurrentTime = Level.TimeSeconds;

	CheckHitSound();

	if (Level.NetMode == NM_Client)
	{
		if (!zzbInitialized)
		{
			//xxInitMovers();
			zzbInitialized = true;
		}

		if (zzSwitchedTime > 0 && CurrentTime - zzSwitchedTime > float(PlayerReplicationInfo.Ping)/499)
			zzSwitchedTime = 0;

		if (Player.CurrentNetSpeed != 0 && CurrentTime - zzLastStuffUpdate > 500.0/Player.CurrentNetSpeed)
		{
			xxGetDemoPlaybackSpec();

			xxCheckForKickers();
			xxCheckForPortals();
			//xxCheckForTriggers();

			if (zzClientTTarget == None)
				xxServerReceiveStuff( Velocity.X, Velocity.Y, Velocity.Z, Mover(Base) != None );
			else
				xxServerReceiveStuff( Velocity.X, Velocity.Y, Velocity.Z, Mover(Base) != None, zzClientTTarget.Location, zzClientTTarget.Velocity );
			zzLastStuffUpdate = CurrentTime;
			//xxCheckAce();
		}

		//xxMover_CheckTimeouts();
	}

	if (zzbIsWarmingUp)
		ClearProgressMessages();

	if (zzCannibal != None)
	{
		if ((zzCannibal.Font != zzCanOldFont) || (zzCannibal.Style != zzCanOldStyle))
		{
			xxServerCheater("HA");
		}
	}
	if (zzbReportScreenshot)
		xxDoShot();

	xxHideItems();

	zzbForcedTick = (zzInfoThing.zzTickOff != zzNull) || (zzInfoThing.zzLastTick != zzTick);

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
	zzClientTD = Level.TimeDilation;

	if (PureLevel != None)	// Why would this be None?!
	{
		zzbDemoRecording = PureLevel.zzDemoRecDriver != None;
		if (!zzbDemoRecording && zzbGameStarted && (zzbForceDemo || bAutoDemo && zzUTPure.zzDMP.CountDown < 1))
			xxClientDemoRec();
	}
}

simulated function xxCheckForPortals()
{
	local Teleporter T, Closest;
	local float CurrentTime, ClosestDist, Dist;

	if (IsInState('Dying') || Mesh == None)
		return;

	CurrentTime = Level.TimeSeconds;
	ClosestDist = 2048;
	ForEach RadiusActors(class'Teleporter', T, PortalRadius)
	{
		Dist = VSize(T.Location - Location);
		if (Dist > 0 && Dist < ClosestDist)
		{
			ClosestDist = Dist;
			Closest = T;
		}
	}
	if (Closest == None)
	{
		LastPortal = None;
		LastPortalDest = None;
	}
	else if (LastPortal == None && LastPortalDest == None && CurrentTime - LastPortalTime > 0.2)
	{
		PreTeleport(Closest);
	}
}

simulated function xxCheckForKickers()
{
	local Kicker K;

	ForEach AllActors(class'Kicker', K)
		if (K.Owner != Self)
			K.SetCollision(false, true);
		return;
}


static function setForcedSkin(Actor SkinActor, int selectedSkin, bool bTeamGame, int TeamNum) {
	local string suffix;
	/**
 	* @Author: spect
 	* @Date: 2020-02-21 01:17:00
 	* @Desc: Sets the selected forced skin client side
	* @TODO: Set green and yellow colors. Shit is gonna hit the fan when this is used in xtdm.
 	*/

	if (selectedSkin > 17)
		selectedSkin = 12;

	suffix = "";
	if (bTeamGame)
		suffix = "t_"$TeamNum;

	switch (selectedSkin) {
		case 0: // Female Commando Aphex
			SetSkinElement(SkinActor, 0, "FCommandoSkins.aphe1"$suffix, "FCommandoSkins.aphe");
			SetSkinElement(SkinActor, 1, "FCommandoSkins.aphe2"$suffix, "FCommandoSkins.aphe");
			SetSkinElement(SkinActor, 2, "FCommandoSkins.aphe2"$suffix, "FCommandoSkins.aphe");
			// Set the face
			SetSkinElement(SkinActor, 3, "FCommandoSkins.aphe4Indina", "FCommandoSkins.aphe");
			// Set the Mesh
			bbPlayer(SkinActor).Mesh = class'bbTFemale1'.Default.Mesh;
			break;
		case 1: // Female Commando Anna
			SetSkinElement(SkinActor, 0, "FCommandoSkins.cmdo1"$suffix, "FCommandoSkins.cmdo");
			SetSkinElement(SkinActor, 1, "FCommandoSkins.cmdo2"$suffix, "FCommandoSkins.cmdo");
			SetSkinElement(SkinActor, 2, "FCommandoSkins.cmdo2"$suffix, "FCommandoSkins.cmdo");
			// Set the face
			SetSkinElement(SkinActor, 3, "FCommandoSkins.cmdo4Anna", "FCommandoSkins.anna");
			// Set the Mesh
			bbPlayer(SkinActor).Mesh = class'bbTFemale1'.Default.Mesh;
			break;
		case 2: // Female Commando Mercenary
			SetSkinElement(SkinActor, 0, "FCommandoSkins.daco1"$suffix, "FCommandoSkins.daco");
			SetSkinElement(SkinActor, 1, "FCommandoSkins.daco2"$suffix, "FCommandoSkins.daco");
			SetSkinElement(SkinActor, 2, "FCommandoSkins.daco2"$suffix, "FCommandoSkins.daco");
			// Set the face
			SetSkinElement(SkinActor, 3, "FCommandoSkins.daco4Jayce", "FCommandoSkins.daco");
			// Set the Mesh
			bbPlayer(SkinActor).Mesh = class'bbTFemale1'.Default.Mesh;
			break;
		case 3: // Female Commando Necris
			SetSkinElement(SkinActor, 0, "FCommandoSkins.goth1"$suffix, "FCommandoSkins.goth");
			SetSkinElement(SkinActor, 1, "FCommandoSkins.goth2"$suffix, "FCommandoSkins.goth");
			SetSkinElement(SkinActor, 2, "FCommandoSkins.goth2"$suffix, "FCommandoSkins.goth");
			// Set the face
			SetSkinElement(SkinActor, 3, "FCommandoSkins.goth4Cryss", "FCommandoSkins.goth");
			// Set the Mesh
			bbPlayer(SkinActor).Mesh = class'bbTFemale1'.Default.Mesh;
			break;
		case 4: // Female Soldier Marine
			SetSkinElement(SkinActor, 0, "SGirlSkins.fbth1"$suffix, "SGirlSkins.fbth");
			SetSkinElement(SkinActor, 1, "SGirlSkins.fbth2"$suffix, "SGirlSkins.fbth");
			SetSkinElement(SkinActor, 2, "SGirlSkins.fbth2"$suffix, "SGirkSkins.fbth");
			// Set the face
			SetSkinElement(SkinActor, 3, "SGirlSkins.fbth4Annaka", "SGirlSkins.fbth");
			// Set the Mesh
			bbPlayer(SkinActor).Mesh = class'bbTFemale2'.Default.Mesh;
			break;
		case 5: // Female Soldier Metal Guard
			SetSkinElement(SkinActor, 0, "SGirlSkins.Garf1"$suffix, "SGirlSkins.Garf");
			SetSkinElement(SkinActor, 1, "SGirlSkins.Garf2"$suffix, "SGirlSkins.Garf");
			SetSkinElement(SkinActor, 2, "SGirlSkins.Garf2"$suffix, "SGirlSkins.Garf");
			// Set the face
			SetSkinElement(SkinActor, 3, "SGirlSkins.Garf4Isis", "SGirlSkins.Garf");
			bbPlayer(SkinActor).Mesh = class'bbTFemale2'.Default.Mesh;
			break;
		case 6: // Female Soldier Soldier
			SetSkinElement(SkinActor, 0, "SGirlSkins.army1"$suffix, "SGirlSkins.army");
			SetSkinElement(SkinActor, 1, "SGirlSkins.army2"$suffix, "SGirlSkins.army");
			SetSkinElement(SkinActor, 2, "SGirlSkins.army2"$suffix, "SGirlSkins.army");
			// Set the face
			SetSkinElement(SkinActor, 3, "SGirlSkins.army4Lauren", "SGirlSkins.army");
			bbPlayer(SkinActor).Mesh = class'bbTFemale2'.Default.Mesh;
			break;
		case 7: // Female Soldier Venom
			SetSkinElement(SkinActor, 0, "SGirlSkins.Venm1"$suffix, "SGirlSkins.Venm");
			SetSkinElement(SkinActor, 1, "SGirlSkins.Venm2"$suffix, "SGirlSkins.Venm");
			SetSkinElement(SkinActor, 2, "SGirlSkins.Venm2"$suffix, "SGirlSkins.Venm");
			// Set the face
			SetSkinElement(SkinActor, 3, "SGirlSkins.Venm4Athena", "SGirlSkins.Venm");
			bbPlayer(SkinActor).Mesh = class'bbTFemale2'.Default.Mesh;
			break;
		case 8: // Female Soldier War Machine
			SetSkinElement(SkinActor, 0, "SGirlSkins.fwar1"$suffix, "SGirlSkins.fwar");
			SetSkinElement(SkinActor, 1, "SGirlSkins.fwar2"$suffix, "SGirlSkins.fwar");
			SetSkinElement(SkinActor, 2, "SGirlSkins.fwar2"$suffix, "SGirlSkins.fwar");
			// Set the face
			SetSkinElement(SkinActor, 3, "SGirlSkins.fwar4Cathode", "SGirlSkins.fwar");
			bbPlayer(SkinActor).Mesh = class'bbTFemale2'.Default.Mesh;
			break;
		case 9: // Male Commando Commando
			SetSkinElement(SkinActor, 3, "CommandoSkins.cmdo4"$suffix, "CommandoSkins.cmdo");
			SetSkinElement(SkinActor, 2, "CommandoSkins.cmdo3"$suffix, "CommandoSkins.cmdo");
			SetSkinElement(SkinActor, 0, "CommandoSkins.cmdo1", "CommandoSkins.cmdo");
			// Set the face
			SetSkinElement(SkinActor, 1, "CommandoSkins.cmdo2Blake", "CommandoSkins.cmdo");
			bbPlayer(SkinActor).Mesh = class'bbTMale1'.Default.Mesh;
			break;
		case 10: // Male Commando Mercenary
			SetSkinElement(SkinActor, 3, "CommandoSkins.daco4"$suffix, "CommandoSkins.daco");
			SetSkinElement(SkinActor, 2, "CommandoSkins.daco3"$suffix, "CommandoSkins.daco");
			SetSkinElement(SkinActor, 0, "CommandoSkins.daco1", "CommandoSkins.daco");
			// Set the face
			SetSkinElement(SkinActor, 1, "CommandoSkins.daco2Boris", "CommandoSkins.daco");
			bbPlayer(SkinActor).Mesh = class'bbTMale1'.Default.Mesh;
			break;
		case 11: // Male Commando Necris
			SetSkinElement(SkinActor, 3, "CommandoSkins.goth4"$suffix, "CommandoSkins.goth");
			SetSkinElement(SkinActor, 2, "CommandoSkins.goth3"$suffix, "CommandoSkins.goth");
			SetSkinElement(SkinActor, 0, "CommandoSkins.goth1", "CommandoSkins.goth");
			// Set the face
			SetSkinElement(SkinActor, 1, "CommandoSkins.goth2Grail", "CommandoSkins.goth");
			bbPlayer(SkinActor).Mesh = class'bbTMale1'.Default.Mesh;
			break;
		case 12: // Male Soldier Marine
			SetSkinElement(SkinActor, 0, "SoldierSkins.blkt1"$suffix, "SoldierSkins.blkt");
			SetSkinElement(SkinActor, 1, "SoldierSkins.blkt2"$suffix, "SoldierSkins.blkt");
			SetSkinElement(SkinActor, 2, "SoldierSkins.blkt2"$suffix, "SoldierSkins.blkt");
			// Set the face
			SetSkinElement(SkinActor, 3, "SoldierSkins.blkt4Malcom", "SoldierSkins.blkt");
			bbPlayer(SkinActor).Mesh = class'bbTMale2'.Default.Mesh;
			break;
		case 13: // Male Soldier Metal Guard
			SetSkinElement(SkinActor, 0, "SoldierSkins.Gard1"$suffix, "SoldierSkins.Gard");
			SetSkinElement(SkinActor, 1, "SoldierSkins.Gard2"$suffix, "SoldierSkins.Gard");
			SetSkinElement(SkinActor, 2, "SoldierSkins.Gard2"$suffix, "SoldierSkins.Gard");
			// Set the face
			SetSkinElement(SkinActor, 3, "SoldierSkins.Gard4Drake", "SoldierSkins.Gard");
			bbPlayer(SkinActor).Mesh = class'bbTMale2'.Default.Mesh;
			break;
		case 14: // Male Soldier Raw Steel
			SetSkinElement(SkinActor, 0, "SoldierSkins.RawS1"$suffix, "SoldierSkins.RawS");
			SetSkinElement(SkinActor, 1, "SoldierSkins.RawS2"$suffix, "SoldierSkins.RawS");
			SetSkinElement(SkinActor, 2, "SoldierSkins.RawS2"$suffix, "SoldierSkins.RawS");
			// Set the face
			SetSkinElement(SkinActor, 3, "SoldierSkins.RawS4Arkon", "SoldierSkins.RawS");
			bbPlayer(SkinActor).Mesh = class'bbTMale2'.Default.Mesh;
			break;
		case 15: // Male Soldier Soldier
			SetSkinElement(SkinActor, 0, "SoldierSkins.sldr1"$suffix, "SoldierSkins.sldr");
			SetSkinElement(SkinActor, 1, "SoldierSkins.sldr2"$suffix, "SoldierSkins.sldr");
			SetSkinElement(SkinActor, 2, "SoldierSkins.sldr2"$suffix, "SoldierSkins.sldr");
			// Set the face
			SetSkinElement(SkinActor, 3, "SoldierSkins.sldr4Brock", "SoldierSkins.sldr");
			bbPlayer(SkinActor).Mesh = class'bbTMale2'.Default.Mesh;
			break;
		case 16: // Male Soldier War Machine
			SetSkinElement(SkinActor, 0, "SoldierSkins.hkil1"$suffix, "SoldierSkins.hkil");
			SetSkinElement(SkinActor, 1, "SoldierSkins.hkil2"$suffix, "SoldierSkins.hkil");
			SetSkinElement(SkinActor, 2, "SoldierSkins.hkil2"$suffix, "SoldierSkins.hkil");
			// Set the face
			SetSkinElement(SkinActor, 3, "SoldierSkins.hkil4Matrix", "SoldierSkins.hkil");
			bbPlayer(SkinActor).Mesh = class'bbTMale2'.Default.Mesh;
			break;
		case 17: // Boss
			SetSkinElement(SkinActor, 0, "BossSkins.Boss1"$suffix, "BossSkins.Boss");
			SetSkinElement(SkinActor, 1, "BossSkins.Boss2"$suffix, "BossSkins.Boss");
			SetSkinElement(SkinActor, 2, "BossSkins.Boss2"$suffix, "BossSkins.Boss");
			// Set the face (Xan has different head colours? Makes sense, he's a robot.)
			SetSkinElement(SkinActor, 3, "BossSkins.Boss4"$suffix, "BossSkins.Boss");
			bbPlayer(SkinActor).Mesh = class'bbTBoss'.Default.Mesh;
			break;
	}
}

event PreRender( canvas zzCanvas )
{
	local SpawnNotify zzOldSN;
	local int zzx;
	local PlayerReplicationInfo zzPRI;
	local bbPlayer bbP;
	local PlayerPawn zzPPOwner;
	local bbPlayer zzPP;
	local canvas lmaoCanvas;
	local string stringTest;

//	Log("PlayerPawn.PreRender");
	zzbDemoRecording = PureLevel != None && PureLevel.zzDemoRecDriver != None;

	zzbConsoleInvalid = zzTrue;

	zzbBadCanvas = zzbBadCanvas || (zzCanvas != None && zzCanvas.Class != Class'Canvas');

	zzLastVR = zzViewRotation;

	if (Role < ROLE_Authority)
		xxAttachConsole();

	if (Role < ROLE_Authority)
		if (!zzbRenderHUD)
			Super.PreRender(lmaoCanvas);

	if (zzbRenderHUD)
	{
		lmaoCanvas = None;
		Super.PreRender(zzCanvas);
	}

	// Set all other players' health to 0 (unless it's a teamgame and he's on your team)
	// also set location to something dumb ;)
	if (GameReplicationInfo != None && PlayerReplicationInfo != None) {
		for (zzx = 0; zzx < 32; zzx++) {
			zzPRI = GameReplicationInfo.PRIArray[zzx];
			if (zzPRI == None) continue;

			if (zzPRI != PlayerReplicationInfo &&
			    (!GameReplicationInfo.bTeamGame || zzPRI.Team != PlayerReplicationInfo.Team)
		    ) {
				zzPRI.PlayerLocation = PlayerReplicationInfo.PlayerLocation;
				zzPRI.PlayerZone = None;
			}

			/**
			 * @Author: spect
			 * @Date: 2020-02-18 02:20:22
			 * @Desc: Applies the forced skin client side if force models is enabled.
			 */

			if (   zzbForceModels
				&& zzPRI.bIsSpectator == false
				&& zzPRI.Owner != None
				&& zzPRI.Owner != Self
			) {
				// Set the skin
				if (zzPRI.Team == Self.PlayerReplicationInfo.Team) {
					setForcedSkin(zzPRI.Owner, desiredTeamSkin, GameReplicationInfo.bTeamGame, zzPRI.Team);
				} else {
					setForcedSkin(zzPRI.Owner, desiredSkin, GameReplicationInfo.bTeamGame, zzPRI.Team);
				}
			}

			if (AnimSequence == 'Flip') {
				bbP = bbPlayer(GetLocalPlayer());
				if (bbP != none) {
					if (GameReplicationInfo.bTeamGame && bbP.PlayerReplicationInfo.Team == PlayerReplicationInfo.Team) {
						if (bbP.DesiredTeamSkin > 8 && PlayerReplicationInfo.bIsFemale)
							AnimRate = 1.35*1.55 * FMax(0.35, Region.Zone.ZoneGravity.Z/Region.Zone.Default.ZoneGravity.Z);
						else if (bbP.DesiredTeamSkin <= 8 && PlayerReplicationInfo.bIsFemale == false)
							AnimRate = 1.35/1.55 * FMax(0.35, Region.Zone.ZoneGravity.Z/Region.Zone.Default.ZoneGravity.Z);
					} else {
						if (bbP.DesiredSkin > 8 && PlayerReplicationInfo.bIsFemale)
							AnimRate = 1.35*1.55 * FMax(0.35, Region.Zone.ZoneGravity.Z/Region.Zone.Default.ZoneGravity.Z);
						else if (bbP.DesiredSkin <= 8 && PlayerReplicationInfo.bIsFemale == false)
							AnimRate = 1.35/1.55 * FMax(0.35, Region.Zone.ZoneGravity.Z/Region.Zone.Default.ZoneGravity.Z);
					}
				}
			}
		}
	}

	xxShowItems();

	zzbDonePreRender = zzTrue;
}

event PostRender( canvas zzCanvas )
{
	local SpawnNotify zzOldSN;
//	Log("PlayerPawn.PostRender");
	zzbDonePreRender = zzFalse;

	zzbBadCanvas = zzbBadCanvas || (zzCanvas.Class != Class'Canvas');
	if (zzbRenderHUD)
	{
		if (zzbRepVRData)
		{	// Received data through demo replication.
			ViewRotation.Yaw = zzRepVRYaw;
			ViewRotation.Pitch = zzRepVRPitch;
			ViewRotation.Roll = 0;
			EyeHeight = zzRepVREye;
		}
		else
			ViewRotation = zzViewRotation;

		xxHideItems();

		if ( bBehindView )
		{
			if ( Weapon != None )
				Weapon.RenderOverlays(zzCanvas);
		}
		Super.PostRender(zzCanvas);
	}

	// Render our UTPure Logo
	xxRenderLogo(zzCanvas);
	xxCleanAvars();

	zzNetspeed = Player.CurrentNetspeed;
	if (zzMinimumNetspeed != 0 && zzNetspeed < zzMinimumNetspeed) {
		ConsoleCommand("Netspeed"@zzMinimumNetspeed);
	}

	if (zzDelayedStartTime != 0.0)
	{
		if (Level.TimeSeconds - zzDelayedStartTime > zzWaitTime)
		{
			if (zzDelayedName != "")
			{
				ChangeName(zzDelayedName);
				UpdateURL("Name", zzDelayedName, true);
				SaveConfig();
				zzDelayedName = "";
			}
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

	zzbVRChanged = zzbVRChanged || (zzViewRotation != zzLastVR);

	if (bDrawDebugData) {
		xxDrawDebugData(zzCanvas, 10, zzCanvas.ClipY - 512);
	}
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

function xxServerCheckMutator(string zzClass, float zzv)
{
	local class<Mutator> zzAc;

//	Log("Received request for"@zzClass);
	zzAc = class<Mutator>(DynamicLoadObject(zzClass, class'Class'));
	if (zzAc == None)
	{
		zzv = -zzv;	// - = it's a naughty naughty boy (client side only)
		if (++zzFailedMutes == 50)
			xxServerCheater("FM");
	}

	xxClientAcceptMutator(zzClass, zzv);
}

simulated function xxClientAcceptMutator(string zzClass, float zzv)
{
	local int zzi,zzi2;

//	Log("Got acceptance for"@zzClass);

	if (zzHMCnt == 50)
		return;

	for (zzi = 0; zzi<50; zzi++)
	{
		if (zzWaitMutes[zzi] != None && string(zzWaitMutes[zzi].class) == zzClass)
		{
			if (zzv == zzWMCheck[zzi])
			{
				for (zzi2 = 0; zzi2 < zzHMCnt; zzi2++)	// Check if HUDMut is already in
				{
					if (zzHudMutes[zzi2] != None &&
					    string(zzHudMutes[zzi2].Class) == zzClass)
					{
//						Log(zzClass@"already present, replacing!");
						zzHudMutes[zzi2].Destroy();
						break;
					}
				}
//				Log("Hudmut accepted!"@zzWaitMutes[zzi]);
				zzHudMutes[zzi2] = zzWaitMutes[zzi];
				zzHMCnt++;
				zzWaitMutes[zzi] = None;
				zzWMCheck[zzi] = 0.0;
			}
			else if (zzv < 0 && -zzv == zzWMCheck[zzi])
			{
//				Log("hudmut destroyed");
				zzWaitMutes[zzi].Destroy();
				zzWaitMutes[zzi] = None;
				zzWMCheck[zzi] = 0.0;
				break;
			}
		}
	}
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
	zzC.DrawText("InstaGib+");
	zzC.SetPos(zzx+70,zzY+35);
	//zzC.Font = ChallengeHud(MyHud).MyFonts.GetSmallestFont(zzC.ClipX);
	zzC.Font = ChallengeHud(MyHud).MyFonts.GetBigFont(zzC.ClipX);
	zzC.DrawText(class'UTPure'.default.LongVersion$class'UTPure'.default.NiceVer);
	zzC.SetPos(zzx+70,zzY+62);
	if (zzbDoScreenshot)
		zzC.DrawText(PlayerReplicationInfo.PlayerName@zzMagicCode);
	//else if (!zzbDidMD5)
	//	zzC.DrawText("Validating...");
	//else
	//	zzC.DrawText("Type 'PureHelp' into console for extra Pure commands!");
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
		if (bIsAlpha) {
			xxDrawAlphaWarning(zzC, 10, zzC.ClipY - 128);
		}
		return;
	}

	if (!zzbDidMD5)
		zzLogoStart = Level.TimeSeconds;

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


simulated function xxDrawAlphaWarning(canvas zzC, float zzx, float zzY) {

	/**
	 * @Author: spect
	 * @Date: 2020-02-18 02:23:10
	 * @Desc: Draw a big and visible ALPHA WARNING text in the left hand corner so people complain less. It didn't work, they complained anyway.
	 */

	if (MyHUD == None)
		return;

	zzC.Style = ERenderStyle.STY_Translucent;
	zzC.DrawColor = ChallengeHud(MyHud).WhiteColor;
	zzC.SetPos(zzx,zzY);
	zzC.Font = ChallengeHud(MyHud).MyFonts.GetBigFont(zzC.ClipX);
	zzC.DrawText("ALPHA VERSION");
	zzC.setPos(zzx, zzY + 20);
	zzC.DrawText("FOR TESTING ONLY!");
	zzC.Style = ERenderStyle.STY_Normal;
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
	zzC.DrawText("NewAccel:"@debugNewAccel);
	zzC.SetPos(zzx, zzY + 20);
	zzC.DrawText("ClientLoc:"@debugPlayerLocation);
	zzC.SetPos(zzx, zzY + 40);
	zzC.DrawText("ServerLoc:"@debugPlayerServerLocation);
	zzC.SetPos(zzx, zzY + 60);
	zzC.DrawText("HitLocation:"@debugClientHitLocation);
	zzC.SetPos(zzx, zzY + 80);
	zzC.DrawText("HitNormal:"@debugClientHitNormal);
	zzC.SetPos(zzx, zzY + 100);
	zzC.DrawText("Pawn?"@bClientPawnHit);
	zzC.SetPos(zzx + 20, zzY + 120);
	zzC.DrawText("HitDiff:"@debugClientHitDiff);
	zzC.SetPos(zzx + 20, zzY + 140);
	zzC.DrawText("Other.Location:"@debugClientEnemyHitLocation);
	zzC.SetPos(zzx, zzY + 160);
	zzC.DrawText("ClientLocErr:"@debugClientLocError);
	zzC.SetPos(zzx, zzY + 180);
	zzC.DrawText("zzbForceUpdate:"@debugClientForceUpdate);
	zzC.SetPos(zzx, zzY + 200);
	zzC.DrawText("ForcedUpdates:"@debugNumOfForcedUpdates@"-"@debugNumOfIgnoredForceUpdates@"="@(debugNumOfForcedUpdates - debugNumOfIgnoredForceUpdates));
	zzC.SetPos(zzx, zzY + 220);
	zzC.DrawText("bMoveSmooth:"@debugClientbMoveSmooth);
	zzC.SetPos(zzx, zzY + 240);
	zzC.DrawText("ClientPing:"@debugClientPing);
	zzC.SetPos(zzx, zzY + 260);
	zzC.DrawText("Is Alive?"@bIsAlive);
	zzC.SetPos(zzx, zzY + 280);
	zzC.DrawText("LastUpdateTime:"@clientLastUpdateTime);
	zzC.SetPos(zzx, zzY + 300);
	zzC.DrawText("MaxTimeMargin:"@MaxTimeMargin);
	zzC.SetPos(zzx, zzY + 320);
	zzC.DrawText("finishedLoading?:"@bIsFinishedLoading);
	zzC.SetPos(zzx, zzY + 340);
	zzC.DrawText("NetUpdateRate:"@DesiredNetUpdateRate);
	zzC.SetPos(zzx, zzY + 360);
	zzC.DrawText("UpdatedPosition:"@clientForcedPosition);
	zzC.SetPos(zzx, zzY + 380);
	zzC.DrawText("Physics:"@Physics@"Anim:"@AnimSequence);
	zzC.SetPos(zzx+20, zzY + 400);
	zzC.DrawText("AnimRate:"@AnimRate@"TweenRate:"@TweenRate);
	zzC.SetPos(zzx+500, zzY);
	zzC.DrawText("Players:");
	y = zzY + 20;
	foreach AllActors(class'Pawn', P) {
		zzC.SetPos(zzx+500, y);
		zzC.DrawText("Player"$P.PlayerReplicationInfo.PlayerID@"Physics:"@P.Physics@"Anim:"@P.AnimSequence);
		y += 20;
	}
	zzC.SetPos(zzx, zzY + 420);
	zzC.DrawText("Base:"@Base);
	zzC.SetPos(zzx+20, zzY + 440);
	if (Base != none)
		zzC.DrawText("Velocity:"@Base.Velocity@"State:"@Base.GetStateName());
	else
		zzC.DrawText("Velocity:"@vect(0,0,0)@"State:");

	zzC.Style = ERenderStyle.STY_Normal;
}

exec function PureLogo()
{
	zzbLogoDone = False;
	zzLogoStart = Level.TimeSeconds;
}

// ==================================================================================
// AttachConsole - Adds our console
// ==================================================================================
simulated function xxAttachConsole()
{
	local PureSuperDuperUberConsole c;
	local UTConsole oldc;

	if (Player.Actor != Self)
		xxServerCheater("VA");

	if (zzMyConsole == None)
	{
		zzMyConsole = PureSuperDuperUberConsole(Player.Console);
		if (zzMyConsole == None)
		{
			// Initialize Logo Display
			zzbLogoDone = False;
//			zzLogoStart = Level.TimeSeconds;
			//
			Player.Console.Disable('Tick');
			c = New(None) class'PureSuperDuperUberConsole';
			if (c != None)
			{
				oldc = UTConsole(Player.Console);
				c.zzOldConsole = oldc;
				Player.Console = c;
				zzMyConsole = c;
				zzMyConsole.xxGetValues(); //copy all values from old console to new
			}
			else
			{
            			zzbBadConsole = zzTrue;
			}
		}
	}
	// Do not use ELSE or it wont work correctly

	zzbBadConsole = (Player.Console.Class != Class'PureSuperDuperUberConsole');
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
/* 		else if (zzCode == "BL")
			zzS = "Bad Lighting!"; */
		else if (zzCode == "TD")
			zzS = "Bad TimeDilation!";
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
	local UTConsole zzcon;

	if (zzbBadGuy)
		return;
	zzbBadGuy = True;

	if (zzMyConsole == None || zzcon == None)
		return;

	zzMyConsole.xxRevert();
	zzcon = zzMyConsole.zzOldConsole;
	zzcon.AddString( "=====================================================================" );
	zzcon.AddString( "  UTPure has detected an impurity hiding in your client!" );
	zzcon.AddString( "  ID:"@zzCode );
	zzcon.AddString( "=====================================================================" );

/*	if (zzSecurityLevel==1)
	{*/
			zzcon.AddString( "Because of this you have been removed from the" );
			zzcon.AddString( "server.  Fair play is important, remove the impurity" );
			zzcon.AddString( "and you can return!");
/*	}
	else if (zzSecurityLevel==2)
	{
			zzcon.AddString( "Because of this you have been banned on this server!" );
	}
*/
	zzcon.AddString( " ");
	zzcon.AddString( "If you feel this was in error, please contact the admin" );
	zzcon.AddString( "at: "$GameReplicationInfo.AdminEmail);
	zzcon.AddString( " ");
	zzcon.AddString( "Please visit http://forums.utpure.com" );
	zzcon.AddString( "You can read info regarding what UTPure is and maybe find a fix there!" );

	if (int(Level.EngineVersion) < 436)
	{
		zzcon.AddString(" ");
		zzcon.AddString("You currently have UT version"@Level.EngineVersion$"!");
		zzcon.AddString("In order to play on this server, you must have version 436 or greater!");
		zzcon.AddString("To download newest patch, go to: http://unreal.epicgames.com/Downloads.htm");
	}
/*
	if (zzCode == 70945)
	{
		zzcon.AddString(" ");
		zzcon.AddString("UTPure has been unable to validate your client.");
		zzcon.AddString("Download the UTPureRC"$Class'UTPure'.Default.ThisVer@" file,");
		zzcon.AddString("from http://www.clanvikings.org/download/cshp/");
		zzcon.AddString("and try manually installing it. (Check readme inside)");
		zzcon.AddString("You may also try going to the UTPure forums, http://forums.utpure.com");
		zzcon.AddString("There you can often find a thread with a solution to your problem!");
	}
	else if (zzCode == 89287)
	{
		zzcon.AddString(" ");
		zzcon.AddString("Your system files are either missing or incorrect version!");
		zzcon.AddString("This could be because the server is not allowing your versions");
		zzcon.AddString("of the system files, or your system files are modified.");
	}
*/
	zzcon.bQuickKeyEnable = True;
	zzcon.LaunchUWindow();
	zzcon.ShowConsole();
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

//	Log("SSE: Begin :"@SkinNo@SkinName@DefaultSkinName);

/* 	if (Default.zzMyPacks == "")
		Default.zzMyPacks = Caps(SkinActor.ConsoleCommand("get engine.gameengine serverpackages"));
 */
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
			log("Attempted to use illegal skin from package "$pkg$" for "$Meshname);
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
	if ( zzPackName ~= "BOTPACK" || zzPackName ~= "UNREALI" || zzPackName ~= "UNREALSHARE" || zzPackName ~= "INSTAGIBPLUS")
    	return false;
	if (Default.zzMyPacks == "")
		Default.zzMyPacks = Caps(SkinActor.ConsoleCommand("get ini:engine.engine.gameengine serverpackages")); //Can still crash a server

	if ( Instr(Default.zzMyPacks, Chr(34)$zzPackName$Chr(34)) == -1 )
		return false;
  	return (Left(zzPackName, Len(zzMeshName)) ~= zzMeshName && !(Right(zzSkinName,2) ~= "t_"));
}

function xxSet(string zzS, byte zzNetMode)
{
	if (zzNetMode != 3)
		zzUTPure.ConsoleCommand("set"@zzS);
	else
	{
		if (Left(zzS, 6) ~= "input " && InStr(zzS, "mouse") < 0)
			xxClientSet("set"@zzS);
		Mutate("ps"@zzS);
	}
}

function xxClientSet(string zzS)
{
	if (!zzbDemoPlayback)
		zzInfoThing.ConsoleCommand(zzS);
}

simulated function xxClientDoEndShot()
{
	if (bDoEndShot)
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

exec function SetName( coerce string S )
{
	if ( Len(S) > 28 )
		S = left(S,28);
	ReplaceText(S, " ", "_");
	zzDelayedName = S;
	zzDelayedStartTime = Level.TimeSeconds;
}

function ChangeName( coerce string S )
{
	if (Level.TimeSeconds - zzDelayedStartTime > 2.5)
	{
		if (zzNameChanges < 3)
		{
			Level.Game.ChangeName( self, S, false );
			zzNameChanges++;
		}
	}
	zzDelayedStartTime = Level.TimeSeconds;
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
	//if (zzStat != None)
	//	zzStat.SetState(zzType);
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
//	SaveConfig();
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

exec function NewNetCode(bool bUseIt)
{
	//bNewNet = bUseIt;
	//xxServerSetNetCode(bNewNet);
	//SaveConfig();
	//ClientMessage("NewNetCode :"@bNewNet);
}

exec function NoRevert(bool b)
{
	bNoRevert = b;
	xxServerSetNoRevert(b);
	SaveConfig();
	ClientMessage("NoRevert :"@bNoRevert);
}

exec function ForceModels(bool b)
{

	/**
	 * @Author: spect
	 * @Date: 2020-02-21 02:28:03
	 * @Desc: Console command to force models client side
	 */

	bForceModels = b;
	xxServerSetForceModels(b);
	SaveConfig();
	ClientMessage("ForceModels :"@bForceModels);
	if (!bForceModels) {
		ClientMessage("You will be reconnected in 3 seconds...");
		SetTimer(5, false);
		bReason = 1;
	}
}

simulated function reconnectClient() {
	ConsoleCommand("disconnect");
	ConsoleCommand("reconnect");
}

exec function HitSounds(int b)
{
	HitSound = b;
	xxServerSetHitSounds(b);
	SaveConfig();
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
	TeamHitSound = b;
	xxServerSetTeamHitSounds(b);
	SaveConfig();
	if (b == 0)
		ClientMessage("TeamHitSounds: Off");
	else if (b == 1)
		ClientMessage("TeamHitSounds: Classic Stinger");
	else if (b == 2)
		ClientMessage("TeamHitSounds: Dynamic Cowbell (BWOOM BWOOM BWANG BWANG)");
	else if (b == 3)
		ClientMessage("TeamHitSounds: Ouchies!");
}

exec function DisableForceHitSounds()
{
	bDisableForceHitSounds = true;
	xxServerDisableForceHitSounds();
	SaveConfig();
	ClientMessage("bDisableForceHitSounds:"@bDisableForceHitSounds);
}

exec function MyHitsounds()
{
	bDisableForceHitSounds = true;
	xxServerDisableForceHitSounds();
	SaveConfig();
	ClientMessage("bDisableForceHitSounds:"@bDisableForceHitSounds);
}

exec function TeamInfo(bool b)
{
	bTeamInfo = b;
	xxServerSetTeamInfo(b);
	SaveConfig();
	ClientMessage("TeamInfo :"@bTeamInfo);
}

exec function mdct( float f )
{
	MinDodgeClickTime = f;
	xxServerSetMinDodgeClickTime(MinDodgeClickTime);
	SaveConfig();
	ClientMessage("MinDodgeClickTime:"@MinDodgeClickTime);
}

exec function SetMinDodgeClickTime( float f )
{
	MinDodgeClickTime = f;
	xxServerSetMinDodgeClickTime(MinDodgeClickTime);
	SaveConfig();
	ClientMessage("MinDodgeClickTime:"@MinDodgeClickTime);
}

exec function NoDeemerToIG(bool b)
{
	bNoDeemerToIG = b;
	SaveConfig();
	ClientMessage("GetWeapon WarheadLauncher doesn't get IG rifle:"@bNoDeemerToIG);
}

exec function NoSwitchWeapon4(bool b)
{
	bNoSwitchWeapon4 = b;
	SaveConfig();
	ClientMessage("GetWeapon ShockRifle doesn't trigger SwitchWeapon 4:"@bNoSwitchWeapon4);
}

simulated function xxClientSpawnSSRBeamInternal(vector HitLocation, vector SmokeLocation, vector SmokeOffset, actor O) {
	local ClientSuperShockBeam Smoke;
	local Vector DVector;
	local int NumPoints;
	local rotator SmokeRotation;
	local vector MoveAmount;
	local vector OriginLocation;

	LastSSRBeamCreated = Level.TimeSeconds;

	if (Level.NetMode == NM_DedicatedServer) return;

	if (BeamOriginMode == 1) {
		// Show beam originating from its Owner
		OriginLocation = Owner.Location + SmokeOffset;
	} else {
		// Show beam originating from where it was shot
		OriginLocation = SmokeLocation;
	}
	DVector = HitLocation - OriginLocation;
	NumPoints = VSize(DVector) / 135.0;
	if ( NumPoints < 1 )
		return;
	SmokeRotation = rotator(DVector);
	SmokeRotation.roll = Rand(65535);

	if (cShockBeam == 3) return;

	Smoke = Spawn(class'ClientSuperShockBeam',O,, OriginLocation, SmokeRotation);
	if (Smoke == none) return;
	MoveAmount = DVector / NumPoints;

	if (cShockBeam == 1) {
		Smoke.SetProperties(
			-1,
			1,
			1,
			0.27,
			MoveAmount,
			NumPoints - 1);

	} else if (cShockBeam == 2) {
		Smoke.SetProperties(
			PlayerPawn(O).PlayerReplicationInfo.Team,
			BeamScale,
			BeamFadeCurve,
			BeamDuration,
			MoveAmount,
			NumPoints - 1);

	} else if (cShockBeam == 4) {
		Smoke.SetProperties(
			PlayerPawn(O).PlayerReplicationInfo.Team,
			BeamScale,
			BeamFadeCurve,
			BeamDuration,
			MoveAmount,
			0);

		for (NumPoints = NumPoints - 1; NumPoints > 0; NumPoints--) {
			OriginLocation += MoveAmount;
			Smoke = Spawn(class'ClientSuperShockBeam',O,, OriginLocation, SmokeRotation);
			if (Smoke == None) break;
			Smoke.SetProperties(
				PlayerPawn(O).PlayerReplicationInfo.Team,
				BeamScale,
				BeamFadeCurve,
				BeamDuration,
				MoveAmount,
				0);
		}
	}
}

simulated function xxClientSpawnSSRBeam(vector HitLocation, vector SmokeLocation, vector SmokeOffset, actor O) {
	xxClientSpawnSSRBeamInternal(HitLocation, SmokeLocation, SmokeOffset, O);
	LastSSRBeamCreated = -1.0;
}

simulated function xxDemoSpawnSSRBeam(vector HitLocation, vector SmokeLocation, vector SmokeOffset, actor O) {
	if (LastSSRBeamCreated == Level.TimeSeconds) {
		LastSSRBeamCreated = -1.0;
		return;
	}
	xxClientSpawnSSRBeamInternal(HitLocation, SmokeLocation, SmokeOffset, O);
}

function xxServerSetNetCode(bool bNewCode)
{
	//bNewNet = bNewCode;
}

function xxServerSetNoRevert(bool b)
{
	bNoRevert = b;
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

function xxServerSetHitSounds(int b)
{
	HitSound = b;
}

function xxServerSetTeamHitSounds(int b)
{
	TeamHitSound = b;
}

function xxServerDisableForceHitSounds()
{
	bDisableForceHitSounds = true;
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
	MinDodgeClickTime = f;
}

exec function EndShot(optional bool b)
{
	bDoEndShot = b;
	ClientMessage("Screenshot at end of match:"@b);
	SaveConfig();
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
	//Log("Received"@zzS@zzbLast);
	if (zzbLast)
	{
		//Log("xSRC"@ConCmd@ConResult);
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

	//Log("xxCC");

	if (Level.NetMode == NM_DedicatedServer)
	{
		zzRemCmd = "";	// Oooops, no client to receive
		return;		// Dont run on server (in case of disconnect)
	}

	//Log("xxCC:"@zzcon);

	zzRes = zzInfoThing.ConsoleCommand(zzcon);

	//Log("xCC"@ConCmd@ConResult);

	zzl = Len(zzRes);
	while (zzl > zzx)
	{
		zzS = Mid(zzRes, zzx, zzC);
		//Log("Sending"@zzS);
		xxServerReceiveConsole(zzS, False);
		xxClientLogToDemo(zzS);
		zzx += zzC;
	}
	xxServerReceiveConsole("", True);
	//Log("xCC done");
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
//			if (zzIdent != "None" && zzValue != "")
			zzRemResult = zzRemResult$"A("$zzIdent$"="$zzValue$")";
		}
		else
		{
//			if (zzValue != "")
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

function ClientReStart()
{
	zzSpawnedTime = Level.TimeSeconds;
	Super.ClientReStart();
}

exec function GetWeapon(class<Weapon> NewWeaponClass )
{	// Slightly improved GetWeapon
	local Inventory Inv;

	if ( (Inventory == None) || (NewWeaponClass == None)
		|| ((Weapon != None) && Weapon.IsA(NewWeaponClass.Name)) )
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

	if ( bShowMenu || Level.Pauser!="" )
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

	if( bShowMenu || Level.Pauser!="" )
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

	if( bShowMenu || Level.Pauser!="" )
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
	local Inventory inv;

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
	zzbNN_ForceFire = false;
	zzbNN_ForceAltFire = false;
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
/*
// Drop flag if got flag.
simulated event Destroyed()
{
	Log("Destroyed");
	if (Role == ROLE_Authority)
	{
		Log("Auth!"@Level.Game.IsA('CTFGame')@CarriedDecoration);
		if (Level.Game.IsA('CTFGame') && CTFFlag(CarriedDecoration) != None)
			DropDecoration();
	}
	Super.Destroyed();
}
*/
//enhanced teamsay:
exec function TeamSay( string Msg )
{
	local string OutMsg;
	local string cmd;
	local int pos,i, zzi;
	local int ArmorAmount;
	local inventory inv;

	local int x;
	local int zone;  // 0=Offense, 1 = Defense, 2= float
	local flagbase Red_FB, Blue_FB;
	local CTFFlag F,Red_F, Blue_F;
	local float dRed_b, dBlue_b, dRed_f, dBlue_f;

	if (!Class'UTPure'.Default.bAdvancedTeamSay || PlayerReplicationInfo.Team == 255)
	{
		Super.TeamSay(Msg);
		return;
	}

	pos = InStr(Msg,"%");

	if (pos>-1)
	{
		for (i=0; i < 100; i = 1)
		{
			if (pos > 0)
			{
				OutMsg = OutMsg$Left(Msg,pos);
				Msg = Mid(Msg,pos);
				pos = 0;
			}

			x = len(Msg);
			cmd = Mid(Msg,pos,2);
			if (x-2 > 0)
				Msg = Right(Msg,x-2);
			else
				Msg = "";

			if (cmd == "%H")
			{
				OutMsg = OutMsg$Health$" Health";
			}
			else if (cmd == "%h")
			{
				OutMsg = OutMsg$Health$"%";
			}
			else if (cmd ~= "%W")
			{
				if (Weapon == None)
					OutMsg = OutMsg$"Empty hands";
				else
					OutMsg = OutMsg$Weapon.GetHumanName();
			}
			else if (cmd == "%A")
			{
				ArmorAmount = 0;
				for( Inv=Inventory; Inv != None; Inv = Inv.Inventory )
				{
					if (Inv.bIsAnArmor)
					{
						if ( Inv.IsA('UT_Shieldbelt') )
							OutMsg = OutMsg$Inv.Charge@"Shieldbelt and ";
						else
							ArmorAmount += Inv.Charge;
					}
				}
				OutMsg = OutMsg$ArmorAmount$" Armor";
			}
			else if (cmd == "%a")
			{
				ArmorAmount = 0;
				for( Inv=Inventory; Inv != None; Inv = Inv.Inventory )
				{
					if (Inv.bIsAnArmor)
					{
						if ( Inv.IsA('UT_Shieldbelt') )
							OutMsg = OutMsg$Inv.Charge$"SB ";
						else
							ArmorAmount += Inv.Charge;
					}
				}
				OutMsg = OutMsg$ArmorAmount$"A";
			}
			else if (cmd ~= "%P" && GameReplicationInfo.IsA('CTFReplicationInfo')) //CTF only
			{
			        // Figure out Posture.

				//ForEach AllActors(class'CTFFlag', F)
				for (zzi=0; zzi < 4; zzi++)
				{
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

				if (PlayerReplicationInfo.Team == 0)
				{
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
				}
				else if (PlayerReplicationInfo.Team == 1)
				{
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

				Switch(zone)
				{
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
			}
			else if (cmd == "%%")
			{
				OutMsg = OutMsg$"%";
			}
			else
			{
				OutMsg = OutMsg$cmd;
			}

			Pos = InStr(Msg,"%");

			if (Pos == -1)
				break;
		}

		if (Len(Msg) > 0)
		OutMsg = OutMsg$Msg;
	}
	else
		OutMsg = Msg;

	Super.TeamSay(OutMsg);
}

function Typing( bool bTyping )
{
	bIsTyping = bTyping;
	if (bTyping)
	{
//		if (Level.Game.WorldLog != None)
//			Level.Game.WorldLog.LogTypingEvent(True, Self);
//		if (Level.Game.LocalLog != None)
//			Level.Game.LocalLog.LogTypingEvent(True, Self);
		PlayChatting();
	}
//	else
//	{
//		if (Level.Game.WorldLog != None)
//			Level.Game.WorldLog.LogTypingEvent(False, Self);
//		if (Level.Game.LocalLog != None)
//			Level.Game.LocalLog.LogTypingEvent(False, Self);
//	}
}

////////////////////////////
// Tracebot stopper: By DB
////////////////////////////

function bool xxCanFire()
{
	return (Role==ROLE_Authority || (Role<ROLE_Authority && zzbValidFire));
}

function xxStopTracebot()
{
	if (!zzbValidFire)
	{
		zzbValidFire = zzTrue;
		bFire = zzbFire;
		bAltFire = zzbAltFire;
		bJustFired = zzFalse;
		bJustAltFired = zzFalse;
	}
	zzbStoppingTraceBot = !zzbValidFire;
}

function xxCleanAvars()
{
	aMouseX = zzNull;
	aMouseY = zzNull;
	aTurn = zzNull;
	aUp = zzNull;
}

function float GetFRV(int Index)
{
	return zzFRandVals[Index];
}

function vector GetVRV(int Index)
{
	return zzVRandVals[Index];
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

// AUTODEMO CODE
function string xxExtractTag(string zzNicks[32], int zzCount)
{
	local int zzShortNickSize,zzPartSize;
	local string zzShortNick,zzPart;
	local int zzx, zzY, zzLoc, zzFound;
	local string zzParts[256];
	local int zzPartFound[256],zzPartCount;
	local string zzBestPart;
	local int zzBestFindNumber;
	local bool zzbAlready;

	zzShortNickSize = 999;
	for (zzx = 0; zzx < zzCount; zzx++)		// Find Shortest nick
	{
		if (Len(zzNicks[zzx]) < zzShortNickSize)
		{
			zzShortNickSize = Len(zzNicks[zzx]);
			zzShortNick = zzNicks[zzx];
		}
//		log(Nicks[x]);
	}

//	Log("ShortNick"@ShortNick@ShortNickSize);

	for (zzY = 0; zzY < zzCount; zzY++)		// Go through all nicks to find a potential tag.
	{
		zzPartSize = zzShortNickSize;	// Use the shortest nick as base for search.

		while (zzPartSize > 1)			// Ignore clantags less than 2 letters...
		{
			for (zzLoc = 0; zzLoc < (Len(zzNicks[zzY]) - zzPartSize + 1); zzLoc++)	// Go through all the parts of a nick..
			{
				zzPart = Mid(zzNicks[zzY],zzLoc,zzPartSize);
//				Log("Searching for"@Part);
				zzFound = 0;
				for (zzx = 0; zzx < zzCount ; zzx++)	// Go through all nicks
				{
					if (InStr(zzNicks[zzx],zzPart) >= 0)
						zzFound++;
				}
				if (zzFound == zzCount)		// All nicks had this, so stop search (Gold nugget man!)
					return xxFixFileName(zzPart,"");
				if (zzFound > (zzCount / 2) && zzPartCount < 256)	// if more than half of the nicks had it, store it to the list
				{
//					Log("Storing"@Part@Found);
					zzbAlready = False;
					for (zzx = 0; zzx < zzPartCount; zzx++)
					{
						if (zzParts[zzx] ~= zzPart)
						{
							zzbAlready = True;
							break;
						}
					}
					if (!zzbAlready)		// Don't readd if already in list.
					{
						zzPartFound[zzPartCount] = zzFound;
						zzParts[zzPartCount] = zzPart;
						zzPartCount++;
					}
				}
			}
			zzPartSize--;
		}
	}

	for (zzx = 0; zzx < zzPartCount; zzx++)	// Check through parts, see if we found one that all agrees on!
	{
//		Log(x@PartFound[x]@Parts[x]);
		if (zzPartFound[zzx] > zzBestFindNumber)	// One that matches better
		{
			zzBestFindNumber = zzPartFound[zzx];
			zzBestPart = zzParts[zzx];
		}
	}

	if (zzBestPart == "")
		zzBestPart = "Unknown";

	return xxFixFileName(zzBestPart,"");
}

function string xxFindClanTags()
{
	local PlayerReplicationInfo zzPRI;
	local string zzTeamNames[32],zzFinalTags[2];
	local int zzTeamCount,zzTeamNr;
	local GameReplicationInfo zzGRI;

	ForEach Level.AllActors(Class'GameReplicationInfo',zzGRI)
		if (!zzGRI.bTeamGame)
		{
			return "FFA";
		}

	zzTeamNr = 0;
	while (zzTeamNr < 2)
	{
		zzTeamCount = 0;
		ForEach Level.AllActors(Class'PlayerReplicationInfo',zzPRI)
			if (zzPRI.Team == zzTeamNr)
				zzTeamNames[zzTeamCount++] = zzPRI.PlayerName;

		zzFinalTags[zzTeamNr] = xxExtractTag(zzTeamNames,zzTeamCount);
		zzTeamNr++;
	}

	return zzFinalTags[0]$"_"$zzFinalTags[1];
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
				//Case "\"":	//
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

function string xxCreateDemoName(string zzDemoName)
{
	local int zzx;
	local string zzS;

	if (zzDemoName == "")
		zzDemoName = "%l_[%y_%m_%d_%t]_[%c]_%e";	// Incase admin messes up :/

	while (True)
	{
		zzx = InStr(zzDemoName,"%");
		if (zzx < 0)
			break;
		zzS = Mid(zzDemoName,zzx+1,1);
		Switch(Caps(zzS))
		{
			Case "E":	zzS = string(Level);
					zzS = Left(zzS,InStr(zzS,"."));
					break;
			Case "F":	zzS = Level.Title;		// Level.Title
					break;
			Case "D":	if (Level.Day < 10)		// Day
						zzS = "0"$string(Level.Day);
					else
						zzS = string(Level.Day);
					break;
			Case "M":	if (Level.Month < 10)		// Month
						zzS = "0"$string(Level.Month);
					else
						zzS = string(Level.Month);
					break;
			Case "Y":	zzS = string(Level.Year);	// Year
					break;
			Case "H":	if (Level.Hour < 10)		// Hour
						zzS = "0"$string(Level.Hour);
					else
						zzS = string(Level.Hour);
					break;
			Case "N":	if (Level.Minute < 10)		// Minute
						zzS = zzS$"0"$string(Level.Minute);
					else
						zzS = string(Level.Minute);
					break;
			Case "T":	if (Level.Hour < 10)		// Time (HourMinute)
						zzS = "0"$string(Level.Hour);
					else
						zzS = string(Level.Hour);
					if (Level.Minute < 10)		// Minute
						zzS = zzS$"0"$string(Level.Minute);
					else
						zzS = zzS$string(Level.Minute);
					break;
			Case "C":	// Try to find 2 unique tags within the 2 teams. If only 2 players exists, add their names.
					zzS = xxFindClanTags();
					break;
			Case "L":	// Find the name of the local player
					zzS = PlayerReplicationInfo.PlayerName;
					break;
			Case "%":	break;
			Default:	zzS = "%"$zzS;
					break;
		}
		zzDemoName = Left(zzDemoName,zzx)$zzS$Mid(zzDemoName,zzx+2);
	}
	zzDemoName = DemoPath$xxFixFileName(zzDemoName,DemoChar);
	return zzDemoName;
}

exec function AutoDemo(bool zzb)
{
	bAutoDemo = zzb;
	ClientMessage("Record demos automatically after countdown:"@zzb);
	SaveConfig();
}

exec function ShootDead()
{
	bShootDead = !bShootDead;
	if (bShootDead)
		ClientMessage("Shooting carcasses enabled.");
	else
		ClientMessage("Shooting carcasses disabled.");
	SaveConfig();
}

exec function SetDemoMask(optional string zzMask)
{
	local string zzS;

	if (zzMask != "")
	{
		DemoMask = zzMask;
		SaveConfig();
	}

	ClientMessage("Current demo mask:"@DemoMask);
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

	zzS = ConsoleCommand("DemoRec"@xxCreateDemoName(DemoMask));
	ClientMessage(zzS);
	if (zzbForceDemo)
		xxServerDemoReply(zzS);
}

function xxSetNetUpdateRate(float NewVal) {
	TimeBetweenNetUpdates = 1.0 / FClamp(NewVal, class'UTPure'.default.MinNetUpdateRate, class'UTPure'.default.MaxNetUpdateRate);
}

exec function SetNetUpdateRate(float NewVal) {
	DesiredNetUpdateRate = NewVal;
	xxSetNetUpdateRate(NewVal);
	SaveConfig();
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

function Landed(vector HitNormal)
{
	Super.Landed(HitNormal);
}

defaultproperties
{
	bAlwaysRelevant=True
	bNewNet=True
	bNoRevert=True
	HitSound=2
	TeamHitSound=3
	bTeamInfo=True
	DemoMask="%l_[%y_%m_%d_%t]_[%c]_%e"
	HUDInfo=1
	TeleRadius=210
	PortalRadius=50
	TriggerRadius=50
	FRVI_length=47
	VRVI_length=17
	NN_ProjLength=256
	bIsAlpha=False
	bNewNetIsDisabled=False
	desiredSkin=1
	desiredTeamSkin=1
	bEnableHitSounds=True
	selectedHitSound=0
	bIsPatch469=False
	sHitSound(0)="InstaGibPlus.UTPure.HitSound"
	sHitSound(1)="UnrealShare.StingerFire"
	cShockBeam=1
	BeamScale=0.45
    BeamFadeCurve=4
 	BeamDuration=0.75
	bIsFinishedLoading=False
	bDrawDebugData=False
	DesiredNetUpdateRate=100.0
	TimeBetweenNetUpdates=0.01
}
