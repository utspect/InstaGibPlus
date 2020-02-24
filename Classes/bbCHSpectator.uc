// ============================================================
// Created by UClasses - (C) 2000 by meltdown@thirdtower.com
// ============================================================

class bbCHSpectator expands CHSpectator;

// TNSe
// RC5p:
// Added: Ignore Speech & ShowInventory, to avoid server CPU Spike
// Added: ViewRotation.Roll = 0 to avoid problems with headshot when viewing in-eyes.
// RC5T:
// Added: Antispam for ViewClass/ViewPlayer/ViewPlayerNum
// Added: ShowPath to the ignores list in CheatFlying
// Fixed: exec function Jump accessed None
// Added: GotoState('CheatFlying') in PlayerWalking & PlayerSwimming
// RC5v:
// Added: Profile() to the ignoring.
// Added: New DoViewPlayerNum/DoViewClass to avoid server crashes.
// RC5y:
// Fixed: Teleport code to use ProcessMove instead of PlayerTick.
// RC54:
// Added: Anti-adminlogin bruteforce.
// RC55:
// Added: Spec leaves server notifies. (Destroyed())
// Added: Pause bug fix (Scoreboard/Time/HUD)
// RC7A:
// Changed: Removed the Destroyed() part, seems to crash clients on mapswitch (?)
// Added: Specfix into pure. (PlayerCalcView) - IN PROGRESS
// Fixed: 'FindFlag' should now work with some ascii names on linux too.

// AntiSpam
var float zzLastView1,zzLastView2;
var int zzAdminLoginTries;

// Nice to have
var UTPure zzUTPure;

// Stats
var PureStats Stat;		// For player stats
var Class<PureStats> cStat;	// The class to use

// HitSounds
var globalconfig int HitSound;	// if Client wishes hitsounds (default 2, must be enabled on server)
var globalconfig int TeamHitSound;	// if Client wishes team hitsounds (default 3, must be enabled on server)
var globalconfig bool bDisableForceHitSounds;
var int   zzRecentDmgGiven, zzRecentTeamDmgGiven;
var float   zzLastHitSound, zzLastTeamHitSound, zzNextTimeTime;
var int DefaultHitSound, DefaultTeamHitSound;
var bool bForceDefaultHitSounds;
var bool zzbInitialized;

var PureSuperDuperUberConsole	zzMyConsole;
var bool	zzbBadConsole;
var bool zzTrue,zzFalse;		// True & False
/*
struct MoverTimeout {
	var bool bClear;
	var Mover M;
	var float EndTime;
	var name For;
	var name Which;
};

var MoverTimeout zzMoverTimeouts[256];
var int zzNumMoverTimeouts;

var Mover zzMoverTriggerDisabled[256];
var int zzMoverTriggerDisabledLength;
var Mover zzMoverBumpDisabled[256];
var int zzMoverBumpDisabledLength;
var Mover zzMoverAttachDisabled[256];
var int zzMoverAttachDisabledLength;
var float zzMoverEncroachedTime;
var float zzMoverAttachedTime;
*/

replication
{
	// Server -> Client
	reliable if (bNetOwner && ROLE == ROLE_Authority)
		Stat;
	// Client -> Server
	reliable if (ROLE < ROLE_Authority)
		ShowStats, xxServerSetHitSounds, xxServerSetTeamHitSounds; //, xxServerActivateMover;
	// Server->Client
	reliable if ( Role == ROLE_Authority )
		xxSetHitSounds, xxSetTimes, xxReceivePosition; //, xxClientActivateMover;
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

function xxPlayerTickEvents()
{
	CheckHitSound();
	/*
	if (Level.NetMode == NM_Client)
	{
		if (!zzbInitialized)
		{
			xxInitMovers();
			zzbInitialized = true;
		}
		
		xxMover_CheckTimeouts();
	}*/
}

function xxServerSetHitSounds(int b)
{
	HitSound = b;
}

function xxServerSetTeamHitSounds(int b)
{
	TeamHitSound = b;
}

simulated function xxSetHitSounds(int DHS, int DTHS, bool bFDHS)
{
	DefaultHitSound = DHS;
	DefaultTeamHitSound = DTHS;
	bForceDefaultHitSounds = bFDHS;
}

simulated function xxSetTimes(int RemainingTime, int ElapsedTime)
{
	if (GameReplicationInfo == None)
		return;
	GameReplicationInfo.RemainingTime = RemainingTime;
	GameReplicationInfo.ElapsedTime = ElapsedTime;
}

event Possess()
{
	local Mover M;
	
	if ( Level.Netmode == NM_Client )
	{	// Only do this for clients.
		xxServerSetHitSounds(HitSound);
		xxServerSetTeamHitSounds(TeamHitSound);
	}
	else
	{
		DefaultHitSound = zzUTPure.Default.DefaultHitSound;
		DefaultTeamHitSound = zzUTPure.Default.DefaultTeamHitSound;
		bForceDefaultHitSounds = zzUTPure.Default.bForceDefaultHitSounds;
		//xxSetHitSounds(DefaultHitSound, DefaultTeamHitSound, bForceDefaultHitSounds);
		
		GameReplicationInfo.RemainingTime = DeathMatchPlus(Level.Game).RemainingTime;
		GameReplicationInfo.ElapsedTime = DeathMatchPlus(Level.Game).ElapsedTime;
		//xxSetTimes(GameReplicationInfo.RemainingTime, GameReplicationInfo.ElapsedTime);
	}
	Super.Possess();
}

event PreRender( canvas zzCanvas )
{
	if (Role < ROLE_Authority)
		xxAttachConsole();
	
	Super.PreRender(zzCanvas);
}

// ==================================================================================
// AttachConsole - Adds our console
// ==================================================================================
simulated function xxAttachConsole()
{
	local PureSuperDuperUberConsole c;
	local UTConsole oldc;

	if (zzMyConsole == None)
	{
		zzMyConsole = PureSuperDuperUberConsole(Player.Console);
		if (zzMyConsole == None)
		{
			//zzbLogoDone = False;
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
	zzbBadConsole = (Player.Console.Class != Class'PureSuperDuperUberConsole');
}

auto state InvalidState
{
	event PlayerTick( float DeltaTime )
	{
		xxPlayerTickEvents();
		Super.PlayerTick(DeltaTime);
	}
}

state FeigningDeath
{
	event PlayerTick( float DeltaTime )
	{
		xxPlayerTickEvents();
		Super.PlayerTick(DeltaTime);
	}
}

state PlayerFlying
{
	event PlayerTick( float DeltaTime )
	{
		xxPlayerTickEvents();
		Super.PlayerTick(DeltaTime);
	}
}

state PlayerWaiting
{
	event PlayerTick( float DeltaTime )
	{
		xxPlayerTickEvents();
		Super.PlayerTick(DeltaTime);
	}
}

state PlayerSpectating
{
	event PlayerTick( float DeltaTime )
	{
		xxPlayerTickEvents();
		Super.PlayerTick(DeltaTime);
	}
}

state PlayerWaking
{
	event PlayerTick( float DeltaTime )
	{
		xxPlayerTickEvents();
		Super.PlayerTick(DeltaTime);
	}
}

state Dying
{
	event PlayerTick( float DeltaTime )
	{
		xxPlayerTickEvents();
		Super.PlayerTick(DeltaTime);
	}
}

state GameEnded
{
	event PlayerTick( float DeltaTime )
	{
		xxPlayerTickEvents();
		Super.PlayerTick(DeltaTime);
	}
}

event PlayerTick( float Time )
{
	xxPlayerTickEvents();
}

event PostBeginPlay()
{
	ForEach AllActors(Class'UTPure', zzUTPure)
		break;

	if (cStat != None)
		Stat = Spawn(cStat, Self);
	
	Super.PostBeginPlay();
}

event PostRender( canvas Canvas )
{
	local GameReplicationInfo GRI;
	
	if (Level.Pauser != "")				// Pause Fix/Hack.
		ForEach AllActors(Class'GameReplicationInfo',GRI)
		{
			if (GRI != None)
			{
				GRI.SecondCount = Level.TimeSeconds;
			}
		}

	if ( myHud != None )	
		myHUD.PostRender(Canvas);
	else if ( (Viewport(Player) != None) && (HUDType != None) )
	{
//		HUDType.Default.bAlwaysTick = True;
		myHUD = spawn(HUDType, self);
	}

	if (Stat != None && Stat.bShowStats)
	{
		Stat.PostRender( Canvas );
		return;
	}
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
				if ( PTarget.bIsPlayer )
					PTarget.ViewRotation = TargetViewRotation;
				PTarget.EyeHeight = TargetEyeHeight;
				if ( PTarget.Weapon != None )
					PTarget.Weapon.PlayerViewOffset = TargetWeaponViewOffset;
			}
			if ( PTarget.bIsPlayer )
				CameraRotation = PTarget.ViewRotation;
			if ( !bBehindView )
				CameraLocation.Z += PTarget.EyeHeight;
		}
		CameraRotation.Roll = 0;

		if ( bBehindView )
			CalcBehindView(CameraLocation, CameraRotation, 180);
		return;
	}

	ViewActor = Self;
	CameraLocation = Location;

	if( bBehindView ) //up and behind
		CalcBehindView(CameraLocation, CameraRotation, 150);
	else
	{
		// First-person view.
		CameraRotation = ViewRotation;
		CameraLocation.Z += EyeHeight;
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

auto state CheatFlying
{
	ignores Speech,ShowInventory,ShowPath,Profile,ServerTaunt;
	
	event PlayerTick( float DeltaTime )
	{
		xxPlayerTickEvents();
		Super.PlayerTick(DeltaTime);
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
		xxPlayerTickEvents();
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
		xxPlayerTickEvents();
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

/* Causes client crashes on mapswitch?
simulated event Destroyed()
{
	Super.Destroyed();

	if( Level.NetMode==NM_DedicatedServer || Level.NetMode==NM_ListenServer )
		BroadcastMessage( PlayerReplicationInfo.PlayerName$Class'GameInfo'.Default.LeftMessage, false );
}
*/

simulated function PlayHitSound(int Dmg)
{	
	local Actor SoundPlayer;
	local float Pitch;
	local int HS;
	
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

event ReceiveLocalizedMessage( class<LocalMessage> Message, optional int Sw, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
	if (Message == class'CTFMessage2' && RelatedPRI_1 != None && PureFlag(RelatedPRI_1.HasFlag) != None)
		return;

	// Handle hitsounds properly here before huds get it. Remove damage except if demoplayback :P
	if (Message == class'PureHitSound')
	{
		if (RelatedPRI_1 == None)
			return;
			
		if (GameReplicationInfo != None && GameReplicationInfo.bTeamGame && RelatedPRI_2 != None && RelatedPRI_1.Team == RelatedPRI_2.Team)
		{
			if (TeamHitSound > 0)
				Sw = -1*Sw;
			else
				return;
		}
		else if (HitSound == 0)
			return;
	}

	Super.ReceiveLocalizedMessage(Message, Sw, RelatedPRI_1, RelatedPRI_2, OptionalObject);
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
	//if (Stat != None)
	//	Stat.SetState(0);
}

defaultproperties
{
     HitSound=2
     TeamHitSound=3
}
