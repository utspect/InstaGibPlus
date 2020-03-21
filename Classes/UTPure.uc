class UTPure extends Mutator config(InstaGibPlus);

#exec Texture Import File=Textures\NewNetLogo.pcx Name=NewNetLogo Mips=Off
#exec Texture Import File=Textures\bootbit.pcx Name=PureBoots Mips=Off
#exec Texture Import File=Textures\hudbgplain.pcx Name=PureTimeBG Mips=Off
#exec Texture Import File=Textures\smallwhitething.pcx Name=PureSWT Mips=Off
#exec Audio Import FILE=Sounds\HitSound.wav Name=HitSound
#exec Audio Import FILE=Sounds\HitSoundFriendly.wav Name=HitSoundFriendly

#exec OBJ LOAD FILE=Pack\ShockRifle.utx PACKAGE=InstaGibPlus.ShockRifle

var ModifyLoginHandler NextMLH;			// Link list of handlers

var localized config float HeadshotDamage;
var localized config float SniperSpeed;
var localized config float SniperDamagePri;

var localized config bool SetPendingWeapon;
var localized config bool NNAnnouncer;
var bool DisablePortals;

// Enable or disable.
var localized config bool bUTPureEnabled;	// Possible to enable/disable UTPure without changing ini's
// Advertising
var localized config byte Advertise;		// Adds [CSHP] to the Server Name
var localized config byte AdvertiseMsg;		// Decides if [CSHP] or [PURE] will be added to server name
// CenterView
var localized config bool bAllowCenterView;	// Allow use of CenterView
var localized config float CenterViewDelay;	// How long before allowing use of CenterView again
// BehindView
var localized config bool bAllowBehindView;	// Allow use of BehindView
// Others
var localized config byte TrackFOV;		// Track the FOV cheats [0 = no, 1 = strict, 2 = loose]
var localized config bool bAllowMultiWeapon;	// if true allows the multiweapon bug to be used on server.
var localized config bool bFastTeams;		// Allow quick teams changes
var localized config bool bUseClickboard;	// Use clickboard in Tournament Mode or not
var localized config int MinClientRate;		// Minimum allowed client rate.
var localized config bool bAdvancedTeamSay;	// Enable or disable Advanced TeamSay.
var localized config byte ForceSettingsLevel;	// 0 = off, 1 = PostNetBeginPlay, 2 = SpawnNotify, 3 = Intervalled
var localized config bool bNoLockdown;		// Enable or disable to have Lockdown when players get hit by mini/pulse
var localized config bool bWarmup;		// Enable or disable warmup. (bTournament only)
var localized config bool bCoaches;		// Enable or disable coaching. (bTournament only)
var localized config bool bAutoPause;		// Enable or disable autopause. (bTournament only)
var localized config byte ForceModels;		// 0 = Disallow, 1 = Client Selectable, 2 = Forced
var localized config byte ImprovedHUD;		// 0 = Disabled, 1 = Boots/Clock, 2 = Enhanced Team Info
var localized config bool bDelayedPickupSpawn;	// Enable or disable delayed first pickup spawn.
//var localized config bool bNoOvertime;		// Set to True to disable overtime.
var localized config bool bTellSpectators;	// Enable or disable telling spectators of reason for kicks.
var localized config string PlayerPacks[8];	// Config list of supported player packs
var localized config int DefaultHitSound, DefaultTeamHitSound;
var localized config bool bForceDefaultHitSounds;
var localized config int TeleRadius;
var localized config int ThrowVelocity;	// How far a player can throw weapons
var localized config bool bForceDemo;		// Forces clients to do demos.
var string MapName;


// Nice variables.
var float zzTeamChangeTime;			// This would be to Prevent Team Change Spamming
var bool zzbWarmupPlayers;			// Do we have any players warming up?
var DeathMatchPlus zzDMP;			// A place to store the Game Object.
var string VersionStr;				// Holds the version code from VUC++
var string LongVersion;				// Holds the version code from VUC++
var string ThisVer;					// Holds the version letters
var string NiceVer;					// Holds the version letters (no underscore)
var string ConsoleName;				// Set console system name
var string BADminText;				// Text to give players that want admin commands without being admin.
var bool bDidEndWarn;				// True if screenshot warning has been sent to players.

// Anti-Timer
var Inventory zzAntiTimerList[32];		// This holds the inventory on the map that should be protected
var int zzAntiTimerListCount;			// How many in the list
var int zzAntiTimerListState;			// The state of the pickups, calculated each tick

// Pause control (for Event PlayerCalcView)
var bool	zzbPaused;			// Game has been paused at one time.
var float	zzPauseCountdown;		// Give 120 seconds of "ignore FT"
var localized config int MinPosError;
var localized config int MaxPosError;
var localized config int MaxHitError;
var localized config bool ShowTouchedPackage;
var name zzDefaultWeapons[8];
var string zzDefaultPackages[8];

// Auto Pause Handler
var PureAutoPause	zzAutoPauser;

// What server info is used
var Class<ServerInfo> zzSI;

// MD5 Stuff
var string zzPurePackageName;
var string zzMD5KeyInit;
var string zzPureMD5;
/*
struct MoverInfo {
	var Mover M;
	var float DelayTime;
};
var MoverInfo zzMoverDelayTimes[256];
var int zzMoverDelayTimesCount;
*/
var bbPlayer PlayerOwner;

//Add the maplist where kickers will work using normal network
var localized config string ExcludeMapsForKickers[128];
var bool bExludeKickers;

replication
{
	unreliable if (Role < ROLE_Authority)
		zzbWarmupPlayers;

	unreliable if (Role == ROLE_Authority)
		MinPosError, MaxPosError, zzAutoPauser;

	reliable if( Role==ROLE_Authority )
		NNAnnouncer, bExludeKickers, getErrorDetails;
}

//XC_Engine interface
native(1718) final function bool AddToPackageMap( optional string PkgName);

function PreBeginPlay()
{
	local string AbsTime;
	local GameInfo GI;
	local string n;
	local int XC_Version;
	local Kicker K;

	XC_Version = int(ConsoleCommand("get ini:engine.engine.gameengine XC_Version"));
	if ( XC_Version >= 11 )
	{
		AddToPackageMap();
	}

	zzDMP = DeathMatchPlus(Level.Game);
	if (zzDMP == None)
		return;

	Spawn(class'NN_SpawnNotify');

	if (NNAnnouncer)
		Spawn(class'NNAnnouncerSA');

	Spawn(class'VTFix');
	//DisableMovers();

	ForEach AllActors (class'Kicker', K)
	{
		if ( K.GetPropertyText("NoLC") != "" )
			continue;
		if ( (K.KickedClasses == 'Actor') || (K.KickedClasses == 'Pawn') || (K.KickedClasses == 'PlayerPawn') || (K.KickedClasses == 'Projectile') )
			Spawn(class'NN_Kicker').ServerSetup( K);
	}

	//Custom game types
  	/* if(Level.Game.IsA('MMGame') || Level.Game.IsA('MonsterMatch'))
	{
		MM = Spawn(MMData);
		MM.NextMutator = Level.Game.BaseMutator;
		Level.Game.BaseMutator = MM;
		Log("NewNet compatibility enabled for Monster Match.", 'StartMutator');
	}
	if(Level.Game.IsA('SiegeGI') || Level.Game.IsA('SiegeUltimate'))
	{
		AM = Spawn(SGData);
		AM.NextMutator = Level.Game.BaseMutator;
		Level.Game.BaseMutator = AM;
		Log("NewNet compatibility enabled for Siege.", 'StartMutator');
	}
  	if(Level.Game.IsA('LeagueAssault'))
	{
		AS = Spawn(ASData);
		AS.NextMutator = Level.Game.BaseMutator;
		Level.Game.BaseMutator = AS;
		Log("NewNet compatibility enabled for League Assault.", 'StartMutator');
	} */

	class'bbPlayer'.Default.HitSound = DefaultHitSound;
	class'bbPlayer'.Default.TeamHitSound = DefaultTeamHitSound;
	class'bbCHSpectator'.Default.HitSound = DefaultHitSound;
	class'bbCHSpectator'.Default.TeamHitSound = DefaultTeamHitSound;

 	if (zzDMP.HUDType == Class'ChallengeDominationHUD')
		zzDMP.HUDType = Class'PureDOMHUD';
	else if (zzDMP.HUDType == Class'ChallengeCTFHUD')
		zzDMP.HUDType = Class'PureCTFHUD';
	/* else if (zzDMP.HUDType == Class'newCTF.newChallengeCTFHUD')
		zzDMP.HUDType = Class'PureCTFHUD'; */
	else if (zzDMP.HUDType == Class'AssaultHUD')
		zzDMP.HUDType = Class'PureAssaultHUD';
	else if (zzDMP.HUDType == Class'ChallengeTeamHUD')
		zzDMP.HUDType = Class'PureTDMHUD';
	else if (zzDMP.HUDType == Class'ChallengeHUD')
		zzDMP.HUDType = Class'PureDMHUD';

	zzSI = Class<ChallengeHUD>(zzDMP.HUDType).Default.ServerInfoClass;

}

function PostBeginPlay()
{
	local int i;
	local class<ModifyLoginHandler> MLHClass;
	local ModifyLoginHandler        MLH;
	local int	ppCnt;
	local string	ServPacks, curMLHPack, sTag, fullpack;
	local string zzMD5Values;
	local int XC_Version;

	Super.PostBeginPlay();

	xxLog("");
	xxLog("###############################");
	xxLog("#        "$VersionStr$"       #");
	if (zzDMP == None)
	{
		xxLog("#          ERROR!             #");
		xxLog("#    Game is not based on     #");
		xxLog("#      DeathMatchPlus!        #");
		xxLog("###############################");
		bUTPureEnabled = False;
		Disable('Tick');
		return;
	}
	else
	{
		sTag = "#           "$LongVersion$NiceVer;
		while (Len(sTag) < 30)
			sTag = sTag$" ";
		sTag = sTag$"#";
		xxLog(sTag);
		xxLog("###############################");
	}
	xxLog("");

	if (AdvertiseMsg == 0)
		sTag = "[CSHP]";
	else if (AdvertiseMsg == 1)
		sTag = "[IG+]";
	else
		sTag = "[PWND]";

	// Setup name advertising
	if ( (Advertise>0)  && (Level != None && Level.NetMode != NM_Standalone) && (zzDMP.GameReplicationInfo != None && instr(zzDMP.GameReplicationInfo.ServerName,sTag)==-1) )
	{
		if (Advertise==1)
			zzDMP.GameReplicationInfo.ServerName = sTag@zzDMP.GameReplicationInfo.ServerName;
		else if (Advertise==2)
			zzDMP.GameReplicationInfo.ServerName = zzDMP.GameReplicationInfo.ServerName@sTag;
	}

	for (i = 0; PlayerPacks[i] != ""; i++);
	ppCnt = i;

	XC_Version = int(ConsoleCommand("get ini:engine.engine.gameengine XC_Version"));

	if ( XC_Version >= 11 )
	{
		ServPacks = Caps(ConsoleCommand("get xc_engine.xc_gameengine serverpackages"));
	}
	else
	{
		ServPacks = Caps(ConsoleCommand("get engine.gameengine serverpackages"));
	}
	// Create the ModifyLoginHandler chain list
	for (i = 0; PlayerPacks[i] != ""; i++)
	{

		// Verify that the PlayerPack Package is in ServerPackages
		curMLHPack = PlayerPacks[i]$"H"$ThisVer;
		fullpack = curMLHPack$"."$PlayerPacks[i]$"LoginHandler";
		if (Instr(CAPS(ServPacks), Caps(Chr(34)$curMLHPack$Chr(34))) != -1)
		{
			MLHClass = class<ModifyLoginHandler>(DynamicLoadObject(fullpack, class'Class'));
			if (MLHClass != None)
			{
				MLH = Spawn(MLHClass, self);
				if (MLH != None && MLH.CanAdd(ServPacks, ppCnt))
				{
					xxLog(" "$MLH.LogLine);
					if (NextMLH == None)
					{
						NextMLH = MLH;
						MLH.NextMLH = None;
					}
					else
						NextMLH.Add(MLH);
				}
			}
			else
				xxLog("Unable to load PlayerPack '"$fullpack$"' (File not found ?)");
		}
		else
			xxLog("You need to add 'ServerPackages="$curMLHPack$"' for PlayerPack["$i$"] to load");
	}
	zzDMP.RegisterMessageMutator(self);
	xxLog("");
	xxLog(" Protection is Active!");
	xxLog("");
	xxLog("###############################");

	// Tell each ModifyLoginHandler They've been accepted
	for (MLH = NextMLH; MLH != None; MLH = MLH.NextMLH)
		MLH.Accepted();

	xxBuildAntiTimerList();

	zzMD5Values = "0123456789abcdef";
	//for (i = 0; i < 32; i++)
	//{
		//zzMD5KeyInit $= mid(zzMD5Values, rand(16), 1);
	//}
	zzPurePackageName = Default.VersionStr$Default.ThisVer;
//	Log("Trying to get MD5 of"@zzPurePackageName@"with key"@zzMD5KeyInit);
//	zzPureMD5 = PackageMD5(zzPurePackageName, zzMD5KeyInit);
//	Log("MD5 Result"@zzPureMD5);

	//Log("bAutoPause:"@bAutoPause@"bTeamGame:"@zzDMP.bTeamGame@"bTournament:"@zzDMP.bTournament);
	if (bAutoPause && zzDMP.bTeamGame && zzDMP.bTournament)
		zzAutoPauser = Spawn(Class'PureAutoPause');

	if (bUseClickboard && zzDMP.bTournament)
		SetupClickBoard();

	if (ImprovedHUD == 2 && zzDMP.bTeamGame)
		xxReplaceTeamInfo();						// Do really nasty replacement of TeamInfo with Pures own.

	if (bDelayedPickupSpawn)
		Spawn(Class'PureDPS');

// Necessary functions to let the "bExludeKickers" list work	
/////////////////////////////////////////////////////////////////////////
	if(GetCurrentMapName(MapName))
		if(IsMapExcluded(MapName))
			bExludeKickers = true;
/////////////////////////////////////////////////////////////////////////
	SaveConfig();
}

// Necessary functions to let the "bExludeKickers" list work
/////////////////////////////////////////////////////////////////////////
function bool GetCurrentMapName (out string MapName)
{
	local int i;

	MapName=string(self);
	i=InStr(MapName,".");
	if ( i != -1 )
	{
		MapName=Left(MapName,i);
		return True;
	}
	return False;
}

function bool IsMapExcluded (string MapName)
{
    local int index;
    local string MapNameUNR;

    MapNameUNR = MapName$".unr";

	while (index < arrayCount(ExcludeMapsForKickers))
        {
        if ((trim(ExcludeMapsForKickers[index]) ~= MapName) || (trim(ExcludeMapsForKickers[index]) ~= MapNameUNR))
            return true;
        ++index;
	}
	return false;
}

function string trim(string source)
{
	local int index;
	local string result;

	// Remove leading spaces.
	result = source;
	while (index < len(result) && mid(result, index, 1) == " ")
        {
		index++;
	}
	result = mid(result, index);

	// Remove trailing spaces.
	index = len(result) - 1;
	while (index >= 0 && mid(result, index, 1) == " ")
        {
		index--;
	}
	result = left(result, index + 1);

	// Return new string.
	return result;
}

/////////////////////////////////////////////////////////////////////////

function int getErrorDetails() {
	return MinPosError;
}

function SetupClickBoard()
{
	local PureClickBoard PCB;

	foreach AllActors(class'PureClickBoard', PCB)
		return;

	PCB = Level.Spawn(Class'PureClickBoard');
	Log("Clickboard loaded!", 'UTPure');
	if (PCB != None)
	{
		Log("Clickboard is not none!", 'UTPure');
		PCB.NextMutator = Level.Game.BaseMutator;
		Level.Game.BaseMutator = PCB;
	}
}

function xxReplaceTeamInfo()
{
	local TeamGamePlus zzTGP;
	local int zzi;

	zzTGP = TeamGamePlus(zzDMP);
	if (zzTGP == None)
		return;

	// Copied directly from TeamGamePlus.PostBeginPlay.
	for (zzi = 0; zzi < 4; zzi++)
	{
		if (zzTGP.Teams[zzi] != None)		// Remove old and replace with Pures
			zzTGP.Teams[zzi].Destroy();
		zzTGP.Teams[zzi] = Spawn(class'PureTeamInfo');
		zzTGP.Teams[zzi].Size = 0;
		zzTGP.Teams[zzi].Score = 0;
		zzTGP.Teams[zzi].TeamName = zzTGP.TeamColor[zzi];
		zzTGP.Teams[zzi].TeamIndex = zzi;
		TournamentGameReplicationInfo(zzTGP.GameReplicationInfo).Teams[zzi] = zzTGP.Teams[zzi];
	}
}
/*
function ReplaceTeleporters()
{
	local Teleporter B;
	local NN_Teleporter T;
	local vector Loc;
	local int Count;

	ForEach AllActors(class'Teleporter', B)
	{
		if (B.Class.Name != 'Teleporter' && B.Class.Name != 'FavoritesTeleporter' && B.Class.Name != 'VisibleTeleporter')
			continue;
		Loc = B.Location;	// for dumb ass mappers who put the fucking portal in the wall
		T = Spawn(class'NN_Teleporter', B.Owner, B.Tag, Loc, B.Rotation);
		if (T == None) {
			Loc.X += 18;
			T = Spawn(class'NN_Teleporter', B.Owner, B.Tag, Loc, B.Rotation);
		}
		if (T == None) {
			Loc.X -= 36;
			T = Spawn(class'NN_Teleporter', B.Owner, B.Tag, Loc, B.Rotation);
		}
		if (T == None) {
			Loc.X += 18;
			Loc.Y += 18;
			T = Spawn(class'NN_Teleporter', B.Owner, B.Tag, Loc, B.Rotation);
		}
		if (T == None) {
			Loc.Y -= 36;
			T = Spawn(class'NN_Teleporter', B.Owner, B.Tag, Loc, B.Rotation);
		}
		if (T == None) {
			Loc.Y += 18;
			Loc.Z += 18;
			T = Spawn(class'NN_Teleporter', B.Owner, B.Tag, Loc, B.Rotation);
		}
		if (T == None) {
			Loc.Z -= 36;
			T = Spawn(class'NN_Teleporter', B.Owner, B.Tag, Loc, B.Rotation);
		}
		if (T == None) {
			xxLog("!!!!!!! A PORTAL HAS BEEN PLACED INSIDE A WALL !!!!!!!");
			xxLog("!!!!!!! UNABLE TO MAKE IT A NEWNET PORTAL !!!!!!!");
			xxLog("!!!!!!! EDIT THE MAP TO FIX THIS !!!!!!!");
			continue;
		}
		T.Tag = 'SomeNewNetTeleporterTag';
		T.bEnabled = false;
		T.zzRotation = B.Rotation;
		T.zzURL = B.URL;
		T.zzbChangesVelocity = B.bChangesVelocity; // Set velocity to TargetVelocity.
		T.zzbChangesYaw = B.bChangesYaw;      // Sets yaw to teleporter's Rotation.Yaw
		T.zzbReversesX = B.bReversesX;       // Reverses X-component of velocity.
		T.zzbReversesY = B.bReversesY;       // Reverses Y-component of velocity.
		T.zzbReversesZ = B.bReversesZ;       // Reverses Z-component of velocity.
		T.zzbEnabled = B.bEnabled;			// Teleporter is turned on;
		T.zzTargetVelocity = B.TargetVelocity;   // If bChangesVelocity, set target's velocity to this.
		T.zzTag = B.Tag;
		T.zzEvent = B.Event;
		T.zzAttachTag = B.AttachTag;
		T.zzProductRequired = B.ProductRequired;
		B.SetCollision(false, false, false);
	}
}

function DisableMovers()
{
	local Mover M;
	local MoverInfo MI;

	ForEach AllActors(class'Mover', M)
	{
		MI.M = M;
		MI.DelayTime = M.DelayTime;
		zzMoverDelayTimes[zzMoverDelayTimesCount++] = MI;
		M.DelayTime = 99999999;

		// ridiculous hack here rofl
		M.MainScale.Scale.X = 0;
		M.MainScale.Scale.Y = 0;
		M.MainScale.Scale.Z = 0;
		M.PostScale.Scale.X = 0;
		M.PostScale.Scale.Y = 0;
		M.PostScale.Scale.Z = 0;
		M.TempScale.Scale.X = 0;
		M.TempScale.Scale.Y = 0;
		M.TempScale.Scale.Z = 0;
	}
}

function float xxMover_DelayTime(Mover M)
{
	local int i;

	for (i = 0; i < zzMoverDelayTimesCount; i++)
		if (zzMoverDelayTimes[i].M == M)
			return zzMoverDelayTimes[i].DelayTime;

	return 0;
}
*/

// Helpfunction
static final function string xxGetPackage(string str)
{
	local int pos;

	pos = Instr(str, ".");
	if (pos == -1)
		return str;
	return Left(str, pos);
}

// TICK!!! And it's not the bug kind. Sorta :/
event Tick(float zzdelta)
{
	local int zzx;
	local bool zzb, zzbDoShot;
	local Pawn zzP;
	local bbPlayer zzbP;
	local bbCHSpectator zzbS;

	// Build visible/hidden list for pickups.
	zzAntiTimerListState = 0;
	for (zzx = 0; zzx < zzAntiTimerListCount; zzx++)
	{
		if (zzAntiTimerList[zzx] != None && zzAntiTimerList[zzx].bHidden)
			zzAntiTimerListState = zzAntiTimerListState | (1 << zzx);
	}

	if (Level.Pauser != "")		// This code is to avoid players being kicked when paused.
	{
		zzbPaused = True;
		zzPauseCountdown = 45.0; // Give it 45 seconds to wear off
		zzDMP.SentText = Max(zzDMP.SentText - 100, 0);	// Fix to avoid the "Pause text freeze bug"
	}
	else
	{
		if (zzPauseCountdown > 0.0)
			zzPauseCountdown -= zzdelta;
		else
			zzbPaused = False;
	}


	// Prepare players that are warming up for a game that is about to start.
	if (zzbWarmupPlayers)
	{
		if (Level.Game.IsA('newCTF'))
			xxHideFlags();
		if (Level.Game.IsA('CTFGame'))
			xxHideFlags();
		if (Level.Game.IsA('Domination'))
			xxHideControlPoints();
		if (Level.Game.IsA('Assault'))
			xxHideFortStandards();
		if (zzDMP.CountDown < 10)
			xxResetGame();
	}

	// Cause clients to force an actor check.
	if (ForceSettingsLevel > 2 && rand(5000) == 0)
		zzb = True;

	if (!bDidEndWarn && zzDMP.bGameEnded)
	{
		bDidEndWarn = True;
		zzbDoShot = True;
	}

	for (zzP = Level.PawnList; zzP != None; zzP = zzP.NextPawn)
	{
		zzbP = bbPlayer(zzP);
		if (zzbP != None)
		{
			zzbP.zzAntiTimerListState = zzAntiTimerListState;	// Copy the visible/hidden list for pickups.
			if (zzbP.zzOldNetspeed != zzbP.zzNetspeed)
			{
				zzbP.zzNetspeedChanges++;			// Detect changed netspeed
				zzbP.zzOldNetspeed = zzbP.zzNetspeed;
				if (zzbP.zzNetspeedChanges > 5)			// Netspeed change protection
					zzbP.xxServerCheater("NC");
			}
			if (zzb)
				zzbP.zzForceSettingsLevel++;
			if (zzbP.zzKickReady > 100)				// Spam protection
				zzbP.xxServerCheater("SK");
			if (zzbDoShot)
				zzbP.xxClientDoEndShot();

			//zzbP.CheckAddVelocity();
			//zzbP.xxMover_CheckTimeouts();
			//zzbP.xxCollisionTick();
		}
		else
		{
			zzbS = bbCHSpectator(zzP);
			if (zzbS != None)
			{
				if (Level.TimeSeconds > zzbS.zzNextTimeTime)
				{
					zzbS.zzNextTimeTime = Level.TimeSeconds + 10;
					zzbS.GameReplicationInfo.RemainingTime = DeathMatchPlus(Level.Game).RemainingTime;
					zzbS.GameReplicationInfo.ElapsedTime = DeathMatchPlus(Level.Game).ElapsedTime;
					zzbS.xxSetTimes(zzbS.GameReplicationInfo.RemainingTime, zzbS.GameReplicationInfo.ElapsedTime);
				}
			}
		}
	}
/*
	if (bNoOvertime && zzDMP.bOvertime && !zzDMP.bGameEnded)
	{
		Level.Game.EndGame("timelimit");
	}*/
}

function xxHideFlags()
{	// Makes flags untouchable
	local CTFFlag Flag;

	ForEach AllActors(Class'CTFFlag', Flag)
		Flag.SetCollision(False, False, False);
}

function xxHideControlPoints()
{	// Makes control points untouchable
	local ControlPoint CtrlPt;

	ForEach AllActors(Class'ControlPoint', CtrlPt)
		CtrlPt.Disable('Touch');
}

function xxHideFortStandards()
{	// Makes fort standards untouchable
	local FortStandard FS;

	ForEach AllActors(Class'FortStandard', FS)
	{
		FS.Disable('Touch');
		FS.Disable('Trigger');
		FS.SetCollision(false, false, false);
	}
}

function bool xxAntiTimeThis(Inventory zzInv)	// These thing should be hidden from timer.
{
	Switch(zzInv.Class.Name)
	{
		Case 'Armor2':
		Case 'ThighPads':
		Case 'HealthPack':
		Case 'UDamage':
		Case 'UT_Invisibility':
		case 'UT_ShieldBelt':
		Case 'WarheadLauncher':		return True;
	}
	return False;
}

function xxBuildAntiTimerList()
{
	local Inventory zzInv;

	ForEach Level.AllActors(Class'Inventory',zzInv)
	{
		if (zzInv != None && xxAntiTimeThis(zzInv))
		{
			zzAntiTimerList[zzAntiTimerListCount++] = zzInv;
		}
		if (zzAntiTimerListCount == 32) break;
	}
}

function xxResetPlayer(bbPlayer zzP)
{
	local PlayerReplicationInfo zzPRI;

	zzP.zzbIsWarmingUp = false;
	//zzP.PlayerRestartState = 'PlayerWaiting';
	zzP.PlayerRestartState = 'CountdownDying';
	zzP.GoToState('CountdownDying');
	zzP.Died(None, 'Suicided', Location);	// Nuke teh sukar!

	zzP.DieCount = 0; zzP.ItemCount = 0; zzP.KillCount = 0; zzP.SecretCount = 0; zzP.Spree = 0;
	zzPRI = zzP.PlayerReplicationInfo;
	if (!(Left(zzDMP.BeaconName,3) ~= "LMS"))
		zzPRI.Score = 0;
	zzPRI.Deaths = 0;
	zzP.zzAddVelocityCount = 0;
	//zzP.GoToState('Dying');
}

function xxResetGame()			// Resets the current game to make sure nothing bad happens after warmup.
{
	local Pawn zzP;
	local Inventory zzInv;
	local Projectile zzProj;
	local Carcass zzCar;
	local CTFFlag zzFlag;
	local ControlPoint zzCtrlPt;
	local FortStandard zzFS;
	local TeamInfo zzTI;

	for (zzP = Level.PawnList; zzP != None; zzP = zzP.NextPawn)
	{
		if (zzP.IsA('bbPlayer'))
			xxResetPlayer(bbPlayer(zzP));
	}

	ForEach Level.AllActors(Class'Inventory', zzInv)
	{
		if (zzInv.bTossedOut || zzInv.bHeldItem)
			zzInv.Destroy();
		else if (zzInv.IsInState('Sleeping'))
			zzInv.GotoState('Pickup');
	}

	ForEach Level.AllActors(Class'Projectile', zzProj)
	{
		if (!zzProj.bStatic && !zzProj.bNoDelete)
			zzProj.Destroy();
	}

	ForEach Level.AllActors(Class'Carcass', zzCar)
	{
		if (!zzCar.bStatic && !zzCar.bNoDelete)
			zzCar.Destroy();
	}

	ForEach Level.AllActors(Class'CTFFlag', zzFlag)
	{
		zzFlag.SendHome();
	}

	ForEach Level.AllActors(Class'ControlPoint', zzCtrlPt)
	{
		zzCtrlPt.Enable('Touch');
	}

	ForEach Level.AllActors(Class'FortStandard', zzFS)
	{
		zzFS.Enable('Touch');
		zzFS.Enable('Trigger');
		zzFS.SetCollision(true, false, false);
	}

	ForEach Level.AllActors(Class'TeamInfo', zzTI)
	{
		zzTI.Score = 0;
	}

	zzbWarmupPlayers = False;
}

// Modify the login classes to our classes.
function ModifyLogin(out class<playerpawn> SpawnClass, out string Portal, out string Options)
{
	local class<playerpawn> origSC;
	local class<Spectator>  specCls;
	local bbPlayer PP;

//	Log("SpawnClass:"@SpawnClass);		// Someone claims that Engine.Pawn makes it here.

	if (SpawnClass == None)
		SpawnClass = Class'TMale1';

	// Quick Fix: Turn Commanders into our Spectator class.
	if (SpawnClass == class'Commander' || SpawnClass == class'Spectator' || SpawnClass == class'CHSpectator')
	{
		if (zzDMP.bTeamGame && zzDMP.bTournament && bCoaches)	// Only allow coaches in bTournament Team games.
			SpawnClass = class'bbCHCoach';
		else
			SpawnClass = class'bbCHSpectator';
	}

	origSC = SpawnClass;

	if ( NextMutator != None )
		NextMutator.ModifyLogin(SpawnClass, Portal, Options);

	if (!bUTPureEnabled)
		return;

	// Let VAPure handle login first !
	if (NextMLH != None)
		NextMLH.ModifyLogin(SpawnClass, Portal, Options);

	if (SpawnClass == class'TBoss')
		SpawnClass = class'bbTBoss';
	else if (SpawnClass == class'TMale2')
		SpawnClass = class'bbTMale2';
	else if (SpawnClass == class'TFemale1')
		SpawnClass = class'bbTFemale1';
	else if (SpawnClass == class'TFemale2')
		SpawnClass = class'bbTFemale2';
	else if (SpawnClass == class'TMale1')
		SpawnClass = class'bbTMale1';

	specCls = class<Spectator>(SpawnClass);
	if (origSC == SpawnClass && SpecCls == None)
		SpawnClass = class'bbTMale1';
}

function ModifyPlayer(Pawn Other)
{
	local bbPlayer zzP;
	local PlayerPawn zzPP;

	if (Other.IsA('TournamentPlayer') && bUTPureEnabled)
	{
		zzP = bbPlayer(Other);
		if (zzP == None && Spectator(Other) == None)
		{
			xxLog("Destroying bad player - Pure might be incompatible with some mod!");
			Other.Destroy();
			return;
		}
		else if (zzP != None)
		{
			zzP.zzViewRotation = Other.ViewRotation;
			zzP.zzTrackFOV = TrackFOV;
			zzP.zzCVDelay = CenterViewDelay;
			zzP.zzCVDeny = !bAllowCenterView;
       		zzP.zzbNoMultiWeapon = !bAllowMultiWeapon;
			zzP.zzShowClick = false;
			zzP.zzForceSettingsLevel = ForceSettingsLevel;
			zzP.zzbForceDemo = bForceDemo;
			zzP.zzbGameStarted = True;
			zzP.zzbUsingTranslocator = DeathMatchPlus(Level.Game).bUseTranslocator;
		}
	}
	Super.ModifyPlayer(Other);
}

//"Hack" for variables that only need to be set once.
function bool AlwaysKeep(Actor Other)
{
	local int zzx;
	local UTPlayerChunks PC;

	ForEach AllActors(class'UTPlayerChunks', PC)
	{
		PC.RemoteRole = ROLE_SimulatedProxy;
	}

	if ( bbPlayer(Other) != None )
	{
		for (zzx = 0; zzx < zzAntiTimerListCount; zzx++)
		{
			bbPlayer(Other).zzAntiTimerList[zzx] = zzAntiTimerList[zzx];
		}
		bbPlayer(Other).zzAntiTimerListCount = zzAntiTimerListCount;
		bbPlayer(Other).zzUTPure = Self;
		bbPlayer(Other).zzThrowVelocity = ThrowVelocity;
	}
	return Super.AlwaysKeep(Other);
}

// ==================================================================================
// MutatorBroadcastMessage - Stop Message Hacks
// ==================================================================================

function bool MutatorBroadcastMessage( Actor Sender,Pawn Receiver, out coerce string Msg, optional bool bBeep, out optional name Type )
{
	local Actor A;
	local bool legalspec;
	A = Sender;

	// Check for a cheater
	if (Receiver.IsA('bbPlayer') && bbPlayer(Receiver).zzbBadGuy)
	{
		// TODO: Use full reporting system as defined by DrSiN
		xxLogDate("Player Tried Cheating :"@Receiver.PlayerReplicationInfo.PlayerName,Level);
		Receiver.Destroy();
		return false;
	}

	// Hack ... for AdminLogout() going in PHYS_Walking while state is 'PlayerWaiting'
	If (A.IsA('GameInfo') && Receiver != None && Receiver.PlayerReplicationInfo != None
			&& (Receiver.PlayerReplicationInfo.PlayerName@"gave up administrator abilities.") == Msg
			&& (Receiver.GetStateName() == 'PlayerWaiting' || Receiver.PlayerReplicationInfo.bIsSpectator))
	{
		Receiver.GotoState('');
		Receiver.GotoState('PlayerWaiting');
	}

	while (!A.isa('Pawn') && A.Owner != None)
		A=A.Owner;

	if (A.isa('spectator'))
		legalspec=((left(msg,len(spectator(A).playerreplicationinfo.playername)+1))==(spectator(A).playerreplicationinfo.playername$":") || A.IsA('MessagingSpectator'));

	if (legalspec)
		 legalspec=(type=='Event');

	if (A.isa('Pawn') && !legalspec)
		return false;

	return Super.MutatorBroadcastMessage( Sender,Receiver, Msg, bBeep );
}

// ==================================================================================
// MutatorBroadcastLocalizedMessage - Stop Message Hacks
// ==================================================================================
function bool MutatorBroadcastLocalizedMessage( Actor Sender, Pawn Receiver, out class<LocalMessage> Message, out optional int Switch, out optional PlayerReplicationInfo RelatedPRI_1, out optional PlayerReplicationInfo RelatedPRI_2, out optional Object OptionalObject )
{
	local Actor A;
	A = Sender;
	while (!A.isa('Pawn') && A.Owner != None)
	  A=A.Owner;

	if (A.isa('Pawn'))
		return false;

	return Super.MutatorBroadcastLocalizedMessage( Sender, Receiver, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject );

} // MutatorBroadcastLocalizedMessage

// ==================================================================================
// Mutate - Accepts commands from the users
// ==================================================================================
function Mutate(string MutateString, PlayerPawn Sender)
{
	local PlayerPawn zzPP;
	local bbPlayer zzbbPP;
	local Pawn zzP;
	local int zzi;
	local float zzf;
	local bool zzb;
	local string zzS;
	local PlayerReplicationInfo zzPRI;
	local bbPlayer bbP;

	if (MutateString ~= "CheatInfo")
	{
		Sender.ClientMessage("This server is running "$VersionStr$NiceVer);
		if (bUTPureEnabled)
		{
			Sender.ClientMessage("UTPure settings:");
			Sender.ClientMessage("- FOV Tracking:"@TrackFOV@"(0 = off, 1 = strict, 2 = loose)");
			Sender.ClientMessage("- Forced Settings:"@ForceSettingsLevel@"(0 = off, 1 = simple, 2 = passive, 3 = active)");
			Sender.ClientMessage("- Minimum Clientrate:"@MinClientRate);
			Sender.ClientMessage("- Advanced TeamSay:"@bAdvancedTeamSay);
			Sender.ClientMessage("- Allow CenterView:"@bAllowCenterView);
			if (bAllowCenterView)
				Sender.ClientMessage("- CenterView Delay:"@CenterViewDelay);
			Sender.ClientMessage("- Allow BehindView:"@bAllowBehindView);
			Sender.ClientMessage("- No Lockdown:"@bNoLockdown);
			Sender.ClientMessage("- Delayed First Pickup Spawn:"@bDelayedPickupSpawn);
			Sender.ClientMessage("- Improved HUD:"@ImprovedHUD@"(0 = off, 1 = clock/boots, 2 = team)");
			Sender.ClientMessage("- Forced Models:"@ForceModels@"(0 = off, 1 = allowed, 2 = forced)");
			zzbbPP = bbPlayer(Sender);
			if (zzbbPP != None)
			{
				Sender.ClientMessage("Your settings:");
				if (ImprovedHUD > 0)
					Sender.ClientMessage("- Improved HUD:"@zzbbPP.HUDInfo@"(0 = off, 1 = clock/boots, 2 = team)");
				if (ForceModels > 0)
					Sender.ClientMessage("- Forced Models:"@zzbbPP.zzbForceModels);
				Sender.ClientMessage("- Using New Net Code:"@zzbbPP.bNewNet);
			}
		}
		else
			Sender.ClientMessage("UTPure is Disabled!");
		Sender.ClientMessage("Fast Teams:"@bFastTeams);
	}
	else if (MutateString ~= "PlayerHelp")
	{
		Sender.ClientMessage("InstaGib Plus Client Commands: (Type directly into console)");
		if (ForceModels > 0)
			Sender.ClientMessage("- ForceModels x (0 = Off, 1 = On. Default = 0) - The models will be forced to the model you select.");
		if (ImprovedHUD == 2)
			Sender.ClientMessage("- TeamInfo x (0 = Off, 1 = On, Default = 1)");
		Sender.ClientMessage("- MyIGSettings (Displays your current IG+ settings)");
		Sender.ClientMessage("- ShowNetSpeeds (Shows the netspeeds other players currently have)");
		Sender.ClientMessage("- ShowTickrate (Shows the tickrate server is running on)");
		Sender.ClientMessage("- SetForcedTeamSkins x (Set forced skins for your team mates. Range: 0-16, Default: 0)");
		Sender.ClientMessage("- SetForcedSkins x (Set forced skins for your enemies. Range: 0-16, Default: 0)");
		Sender.ClientMessage("- EnableHitSounds x (Enables or disables hitsounds, 0 is disabled, 1 is enabled. Default: 1)");
		Sender.ClientMessage("- SetHitSound x (Sets your current hitsound. Range: 0-16, Default: 0)"); 
		Sender.ClientMessage("- ListSkins (Lists the available skins that can be forced)");
		Sender.ClientMessage("- SetShockBeam (1 = Default, 2 = smithY's beam, 3 = No beam) - Sets your Shock Rifle beam type.");
		Sender.ClientMessage("- SetBeamScale (Sets your Shock Rifle beam scale. Range: 0.1-1, Default 0.45)");
		if (Sender.PlayerReplicationInfo.bAdmin)
		{
			Sender.ClientMessage("InstaGib Plus Admin Commands:");
			Sender.ClientMessage("- ShowIPs (Shows the IP of players)");
			Sender.ClientMessage("- ShowID (Shows the ID of players - can be used for:)");
			Sender.ClientMessage("- KickID x (Will Kick player with ID x)");
			Sender.ClientMessage("- BanID x (Will Ban & Kick player with ID x)");
			Sender.ClientMessage("- EnablePure/DisablePure");
			Sender.ClientMessage("- ShowDemos (Will show who is recording demos)");
		}
		if (CHSpectator(Sender) != None)
			Sender.ClientMessage("As spectator, you may need to add 'mutate pure' + command (mutate pureshowtickrate)");
	}
	else if (MutateString ~= "EnablePure")
	{
		if (Sender.bAdmin)
		{
			Default.bUTPureEnabled = True;
			StaticSaveConfig();
			Sender.ClientMessage("UTPure will be ENABLED after next map change!");
		}
		else
			Sender.ClientMessage(BADminText);
	}
	else if (MutateString ~= "DisablePure")
	{
		if (Sender.bAdmin)
		{
			Default.bUTPureEnabled = False;
			StaticSaveConfig();
			Sender.ClientMessage("UTPure will be DISABLED after next map change!");
		}
		else
			Sender.ClientMessage(BADminText);
	}
	else if (MutateString ~= "PureShowIPs")
	{
		if (Sender.bAdmin)
		{
			Sender.ClientMessage("------- IP List -------");
			for (zzP = Level.PawnList; zzP != None; zzP = zzP.NextPawn)
			{
				zzPP = PlayerPawn(zzP);
				if (zzPP != None)
				{
					zzS = zzPP.GetPlayerNetworkAddress();
					zzS = Left(zzS,InStr(zzS,":"));
					Sender.ClientMessage(zzPP.PlayerReplicationInfo.PlayerName@"-"@zzS);
				}
			}
			Sender.ClientMessage("-----------------------");
		}
		else
			Sender.ClientMessage(BADminText);
	}
	else if (MutateString ~= "PureShowDemos")
	{
		if (Sender.bAdmin)
		{
			Sender.ClientMessage("------- Demo List -------");
			for (zzP = Level.PawnList; zzP != None; zzP = zzP.NextPawn)
			{
				zzbbPP = bbPlayer(zzP);
				if (zzbbPP != None)
				{
					Sender.ClientMessage(zzbbPP.PlayerReplicationInfo.PlayerName@"-"@zzbbPP.zzbDemoRecording);
				}
			}
			Sender.ClientMessage("-------------------------");
		}
		else
			Sender.ClientMessage(BADminText);
	}
	else if (MutateString ~= "PureShowTickrate")
	{
		Sender.ClientMessage("Server Tickrate is set at"@Sender.ConsoleCommand("get IpDrv.TcpNetDriver NetServerMaxTickRate")$".");
	}
	else if (MutateString ~= "PureShowNetspeeds")
	{
		for (zzP = Level.PawnList; zzP != None; zzP = zzP.NextPawn)
		{
			zzbbPP = bbPlayer(zzP);
			if (zzbbPP != None)
			{
				Sender.ClientMessage(zzbbPP.PlayerReplicationInfo.PlayerName@"-"@zzbbPP.zzNetspeed);
			}
		}

	}
	else if (MutateString ~= "ShowID")
	{
		if (Sender.bAdmin)
		{
			Sender.ClientMessage("------- ID List -------");
			for (zzP = Level.PawnList; zzP != None; zzP = zzP.NextPawn)
			{
				zzPP = PlayerPawn(zzP);
				if (zzPP != None && zzPP.bIsPlayer && NetConnection(zzPP.Player) != None)
				{
					zzPRI = zzPP.PlayerReplicationInfo;
					Sender.ClientMessage("ID:"$zzPRI.PlayerID@":"@zzPRI.PlayerName);
				}
			}
			Sender.ClientMessage("-----------------------");
		}
		else
			Sender.ClientMessage(BADminText);
	}
	else if (MutateString ~= "geterrordata") {
		Sender.ClientMessage("MinPosError:"@MinPosError@"MaxPosError:"@MaxPosError);
	}
	else if (Left(MutateString,7) ~= "KICKID ")
	{
		zzi = int(Mid(MutateString,7));
		if (Sender.bAdmin)
		{
			for (zzP = Level.PawnList; zzP != None; zzP = zzP.NextPawn)
			{
				if (zzP.PlayerReplicationInfo.PlayerID == zzi)
				{
					Sender.ClientMessage(zzP.PlayerReplicationInfo.PlayerName@"has been removed from the server!");
					Sender.Kick(zzP.PlayerReplicationInfo.PlayerName);
					zzb = True;
					break;
				}
			}
			if (!zzb)
			{
				Sender.ClientMessage("Failed to find Player with ID"@zzi);
			}

		}
		else
			Sender.ClientMessage(BADminText);
	}
	else if (Left(MutateString,6) ~= "BANID ")
	{
		zzi = int(Mid(MutateString,6));
		if (Sender.bAdmin)
		{
			for (zzP = Level.PawnList; zzP != None; zzP = zzP.NextPawn)
			{
				if (zzP.PlayerReplicationInfo.PlayerID == zzi)
				{
					Sender.ClientMessage(zzP.PlayerReplicationInfo.PlayerName@"has been banned and removed from the server!");
					Sender.KickBan(zzP.PlayerReplicationInfo.PlayerName);
					zzb = True;
					break;
				}
			}
			if (!zzb)
			{
				Sender.ClientMessage("Failed to find Player with ID"@zzi);
			}

		}
		else
			Sender.ClientMessage(BADminText);
	}
	else if (Left(MutateString,9) ~= "PURESHOT ")
	{
		zzi = int(Mid(MutateString,9));
		if (Sender.bAdmin)
		{
			zzS = rand(10)$rand(10)$rand(10)$rand(10)$"-"$Level.TimeSeconds;
			for (zzP = Level.PawnList; zzP != None; zzP = zzP.NextPawn)
			{
				if (bbPlayer(zzP) != None && (zzi < 0 || zzP.PlayerReplicationInfo.PlayerID == zzi))
				{
					bbPlayer(zzP).zzMagicCode = zzS;
					bbPlayer(zzP).xxClientDoScreenshot(zzS);
					Sender.ClientMessage("Screenshots requested from:"@zzP.PlayerReplicationInfo.PlayerName@"Text:"@zzS);
				}
			}
		}
		else
			Sender.ClientMessage(BADminText);
	}
	else if (Left(MutateString,4) ~= "PCK ")
	{	// Pure Client Kill (Kick)
		zzbbPP = bbPlayer(Sender);
		if (zzbbPP != None)
			zzbbPP.xxServerCheater("MT"@Mid(MutateString,4));
	}
	else if (Left(MutateString,4) ~= "PCD ")
	{	// Perform Remote Console Command on this player
		zzbbPP = bbPlayer(Sender);
		if (zzbbPP != None)
		{
			zzS = Mid(MutateString,4);
			zzi = InStr(zzS, " ");
			//Log("PCD"@Left(zzS,zzi)$"|"$Mid(zzS,zzi+1));
			if (zzbbPP.zzRemCmd != "")
			{
//				Log("PCD Failed!"@Left(zzS,zzi));
				zzbbPP.Mutate("pcf"@Left(zzS,zzi)@zzbbPP.zzRemCmd);
			}
			else
			{
				//Log("Remote="$zzbbPP.RemoteROLE@zzbbPP.PlayerReplicationInfo);
				zzbbPP.zzRemCmd = Left(zzS, zzi);
//				Log("PCD Sent!"@zzbbPP.zzRemCmd@Mid(zzS, zzi+1));
				zzbbPP.xxClientConsole(Mid(zzS, zzi+1), 200);
			}
		}
	}
	else if (Left(MutateString,4) ~= "PID ")
	{	// Perform Remote .INT reading on this player
		zzbbPP = bbPlayer(Sender);
		if (zzbbPP != None)
		{
			zzS = Mid(MutateString,4);
			zzi = InStr(zzS, " ");
			//Log("PCD"@Left(zzS,zzi)$"|"$Mid(zzS,zzi+1));
			if (zzbbPP.zzRemCmd != "")
			{
				zzbbPP.Mutate("pif"@Left(zzS,zzi)@zzbbPP.zzRemCmd);
			}
			else
			{
				//Log("Remote="$zzbbPP.RemoteROLE@zzbbPP.PlayerReplicationInfo);
				zzbbPP.zzRemCmd = Left(zzS, zzi);
				zzbbPP.xxClientReadINT(Mid(zzS, zzi+1));
			}
		}
	}
	else if (Left(MutateString,4) ~= "PKD ")
	{	// Perform Remote Alias/Key reading on this player
		zzbbPP = bbPlayer(Sender);
		if (zzbbPP != None)
		{
			zzS = Mid(MutateString,4);
			zzi = InStr(zzS, " ");
			if (zzbbPP.zzRemCmd != "")
			{
				zzbbPP.Mutate("pkf"@Left(zzS,zzi)@zzbbPP.zzRemCmd);
			}
			else
			{
				//Log("Remote="$zzbbPP.RemoteROLE@zzbbPP.PlayerReplicationInfo);
				zzbbPP.zzRemCmd = Left(zzS, zzi);
				zzbbPP.xxClientKeys((Mid(zzS, zzi+1) == "1"), "Pure", "Player");
			}
		}
	}

	if (bFastTeams)
	{
		if (MutateString ~= "FixTeams")
			MakeTeamsEven(Sender);
		else if (MutateString ~= "NextTeam")
			NextTeam(Sender);
		else if (Left(MutateString, 11) ~= "ChangeTeam")
			SetTeam(Sender, Mid(MutateString, 12));
	}

/*
	else if (MutateString ~= "ForceClickReady")
	{
		if (Sender.bAdmin)
		{
			for (zzP = Level.PawnList; zzP != None; zzP = zzP.NextPawn)
			{
				if (zzP.IsA('PlayerPawn'))
					PlayerPawn(zzP).bReadyToPlay = True;
			}
		}
		else
			Sender.ClientMessage(BADminText);
	}
*/
/*
	else if (Left(MutateString,3) == "ps ")
	{
		zzS = Mid(MutateString,3);

		xxLog(Sender.PlayerReplicationInfo.PlayerName@"used Set:"@zzS);
	}
*/
/*
	else if (Left(MutateString,3) == "cm ")
	{
		zzS = Mid(MutateString,3);
		xxLog(Sender.PlayerReplicationInfo.PlayerName@"used ConsoleCommand:"@zzS);
	}
*/

	if ( NextMutator != None )
		NextMutator.Mutate(MutateString, Sender);

} // Process the mutate commands

// ==================================================================================
// NextTeam - Allow a player to switch team (DB Request)
// ==================================================================================
// This is where i would like to put my personal contribution to the project. See
// it as the big brother of EZTeams.

function NextTeam(PlayerPawn zzP)
{
	local int nWantedTeam;
	local TeamGamePlus tgp;
	local float zzOldTeam;

	if (zzDMP.bTeamGame && zzDMP.IsA('TeamGamePlus')
			 && (((Level.TimeSeconds - zzTeamChangeTime) > 60) || (!xxGameIsPlaying() && (Level.TimeSeconds - zzTeamChangeTime) > 5)))
	{
		tgp = TeamGamePlus(zzDMP);
		zzOldTeam = zzP.PlayerReplicationInfo.Team;
		nWantedTeam = zzOldTeam + 1;

		if (nWantedTeam >= tgp.MaxTeams)
			nWantedTeam = 0;

		zzP.ChangeTeam(nWantedTeam);
		if (zzP.PlayerReplicationInfo.Team != zzOldTeam)
		{
			// View from self if changing team is valid
			if (zzP.ViewTarget != None)
			{
				zzP.bBehindView = false;
				zzP.ViewTarget = None;
			}
			zzTeamChangeTime = Level.TimeSeconds;
		}
	}
}

// ==================================================================================
// MakeTeamsEven - Switch player from team if teams are uneven. (DB Request)
// ==================================================================================
// This is where i would like to put my personal contribution to the project. See
// it as the big brother of EZTeams. I will put code if allowed to.
//
function MakeTeamsEven(PlayerPawn zzP)
{
	local int zzOldTeam, lowTeam, i, lowTeamSize;
	local TeamGamePlus tgp;

	// Start by checking if fix is needed base on gametype
	if (zzDMP.IsA('TeamGamePlus') && zzDMP.bTeamGame)
	{
		tgp = TeamGamePlus(zzDMP);

		lowTeamSize = 128;
		for (i = 0; i<tgp.MaxTeams; i++)
		{
			if (tgp.Teams[i].Size < lowTeamSize)
			{
				lowTeamSize = tgp.Teams[i].Size;
				lowTeam = i;
			}
		}

		zzOldTeam = zzP.PlayerReplicationInfo.Team;
		if ((tgp.Teams[zzOldTeam].Size - lowTeamSize) < 2)
			return;

		Level.Game.ChangeTeam(zzP, lowTeam);
		if (zzP.PlayerReplicationInfo.Team != zzOldTeam )
		{
			// @@TODO : Handling of warshell ?
			if (zzP.ViewTarget != None)
			{
				zzP.bBehindView = false;
				zzP.ViewTarget = None;
			}
			// Use our own implementation of died
			xxDied(zzP);
			zzTeamChangeTime = Level.TimeSeconds;
		}
	}
}

function SetTeam(PlayerPawn zzP, string zzsteam)
{
	local bool zzbvalid;
	local int zzOldTeam, zzteam;

	if (zzDMP.bTeamGame && zzDMP.IsA('TeamGamePlus')
			 && (((Level.TimeSeconds - zzTeamChangeTime) > 60) || (!xxGameIsPlaying() && (Level.TimeSeconds - zzTeamChangeTime) > 5)))
	{
		zzbvalid = true;
		if (zzsteam ~= "red" || zzsteam ~= "0")
			zzteam = 0;
		else if (zzsteam ~="blue" || zzsteam ~= "1")
			zzteam = 1;
		else if (zzsteam ~="green" || zzsteam ~= "2")
			zzteam = 2;
		else if (zzsteam ~="gold" || zzsteam ~= "3")
			zzteam = 3;
		else
			zzbvalid = false;

		if (!zzbvalid && zzteam >= TeamGamePlus(zzDMP).MaxTeams)
			zzbvalid = false;

		if (!zzbvalid)
		{
			zzP.ClientMessage("Wrong team selected : "$zzsteam);
			return;
		}

		// Ok .. chosen a good team
		zzOldTeam = zzP.PlayerReplicationInfo.Team;
		zzP.ChangeTeam(zzteam);
		if (zzP.PlayerReplicationInfo.Team != zzOldTeam)
		{
			// View from self if changing team is valid
			if (zzP.ViewTarget != None)
			{
				zzP.bBehindView = false;
				zzP.ViewTarget = None;
			}
			zzTeamChangeTime = Level.TimeSeconds;
		}
	}
}

// This is my own version of Died used when player makes teams even,
// Using xxDies() will just report a team change but no suicide to ngStats.
function xxDied(pawn zzP)
{
	local pawn zzOtherPawn;
	local actor zzA;

	if (xxGameIsPlaying())
	{
		zzP.Health = Min(0, zzP.Health);
		for ( zzOtherPawn=Level.PawnList; zzOtherPawn!=None; zzOtherPawn=zzOtherPawn.nextPawn )
			zzOtherPawn.Killed(zzP, zzP, '');

		if( zzP.Event != '' )
			foreach AllActors( class 'Actor', zzA, zzP.Event )
				zzA.Trigger( zzP, None );

		// Stop any spree's players had
		zzP.Spree = 0;

		// Make sure flag is dropped
		if (zzP.PlayerReplicationInfo.HasFlag != None)
			CTFFlag(zzP.PlayerReplicationInfo.HasFlag).Drop(0.5 * zzP.Velocity);

		// Discard all inventory
		Level.Game.DiscardInventory(zzP);

		Velocity.Z *= 1.3;
		if ( zzP.Gibbed('Suicided') )
		{
			zzP.SpawnGibbedCarcass();
			zzP.HidePlayer();
		}
		zzP.PlayDying('Suicided', zzP.Location);

		if ( zzP.RemoteRole == ROLE_AutonomousProxy )
			zzP.ClientDying('Suicided', zzP.Location);

		zzP.GotoState('Dying');
	}
}

// ==================================================================================
// GameIsPlaying - Tells if game is currently in progress
// ==================================================================================
function bool xxGameIsPlaying()
{
	if (zzDMP.bGameEnded || (zzDMP.bRequireReady && (zzDMP.CountDown > 0)))
			return false;
	return true;
}

// ==================================================================================
// WaitingForTournament - Tells when game hasnt started yet
// ==================================================================================
function bool xxWaitingForTournament()
{
	// Determine if match has started or ended (server side only)
	if (zzDMP.bRequireReady && (zzDMP.CountDown > 0))
			return true;
	return false;
}

static function xxLogDate(coerce string zzS, LevelInfo zzLevel)
{
	local string zzDate, zzTime;

	zzDate = zzLevel.Year$"-"$xxPrePad(zzLevel.Month,"0",2)$"-"$xxPrePad(zzLevel.Day,"0",2);
	zzTime = xxPrePad(zzLevel.Hour,"0",2)$":"$xxPrePad(zzLevel.Minute,"0",2)$"."$xxPrePad(zzLevel.Second,"0",2);

	xxLog(zzDate@zzTime@zzS);
}

static function xxLog(coerce string zzS)
{
	Log(zzS, 'UTPure');
}

static function string xxPrePad(coerce string zzS, string zzPad, int zzCount)
{
	while (Len(zzS) < zzCount)
	{
		zzS = zzPad$zzS;
	}
	return zzS;
}

event Destroyed()	// Make sure config is stored. (Don't think this is ever called?)
{
	SaveConfig();
	Super.Destroyed();
}

defaultproperties
{
	SniperDamagePri=60
	HeadshotDamage=100
	SniperSpeed=1.0
	bUTPureEnabled=True
	Advertise=1
	AdvertiseMsg=1
	CenterViewDelay=1.000000
	bAllowBehindView=False
	TrackFOV=0
	bAutoPause=True
	bFastTeams=True
	bUseClickboard=True
	MinClientRate=20000
	bAdvancedTeamSay=True
	ForceSettingsLevel=2
	bNoLockdown=True
	bWarmup=True
	ForceModels=1
	ImprovedHUD=1
	PlayerPacks(0)=""
	DefaultHitSound=2
	DefaultTeamHitSound=3
	TeleRadius=210
	ThrowVelocity=750
	ConsoleName="InstaGib+ Console"
	VersionStr="InstaGib+ Final"
	LongVersion="RC "
	ThisVer="3"
	NiceVer="3"
	BADminText="Not allowed - Log in as admin!"
	bAlwaysTick=True
	NNAnnouncer=True
	MinPosError=100
	MaxPosError=3000
	MaxHitError=10000
	ShowTouchedPackage=False
}
