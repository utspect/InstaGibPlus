class ServerSettings extends Object
	config(InstaGibPlus)
	perobjectconfig;

var config float HeadshotDamage;
var config float SniperSpeed;
var config float SniperDamagePri;

var config bool SetPendingWeapon;
var config bool NNAnnouncer;

// Enable or disable.
var config bool bUTPureEnabled;	// Possible to enable/disable UTPure without changing ini's
// Advertising
var config byte Advertise;		// Adds [CSHP] to the Server Name
var config byte AdvertiseMsg;		// Decides if [CSHP] or [PURE] will be added to server name
// CenterView
var config bool bAllowCenterView;	// Allow use of CenterView
var config float CenterViewDelay;	// How long before allowing use of CenterView again
// BehindView
var config bool bAllowBehindView;	// Allow use of BehindView
// Others
var config byte TrackFOV;		// Track the FOV cheats [0 = no, 1 = strict, 2 = loose]
var config bool bAllowMultiWeapon;	// if true allows the multiweapon bug to be used on server.
var config bool bFastTeams;		// Allow quick teams changes
var config bool bUseClickboard;	// Use clickboard in Tournament Mode or not
var config int MinClientRate;		// Minimum allowed client rate.
var config int MaxClientRate;     // Maximum allowed client rate.
var config bool bAdvancedTeamSay;	// Enable or disable Advanced TeamSay.
var config byte ForceSettingsLevel;	// 0 = off, 1 = PostNetBeginPlay, 2 = SpawnNotify, 3 = Intervalled
var config bool bWarmup;		// Enable or disable warmup. (bTournament only)
var config int WarmupTimeLimit; // Warmup lasts at most this long
var config bool bCoaches;		// Enable or disable coaching. (bTournament only)
var config bool bAutoPause;		// Enable or disable autopause. (bTournament only)
var config byte ForceModels;		// 0 = Disallow, 1 = Client Selectable, 2 = Forced
var config byte ImprovedHUD;		// 0 = Disabled, 1 = Boots/Clock, 2 = Enhanced Team Info
var config bool bDelayedPickupSpawn;	// Enable or disable delayed first pickup spawn.
var config bool bUseFastWeaponSwitch;
var config bool bTellSpectators;	// Enable or disable telling spectators of reason for kicks.
var config string PlayerPacks[8];	// Config list of supported player packs
var config int DefaultHitSound, DefaultTeamHitSound;
var config bool bForceDefaultHitSounds;
var config int TeleRadius;
var config int ThrowVelocity;	// How far a player can throw weapons
var config bool  bForceDemo;		// Forces clients to do demos.
var config bool  bRestrictTrading;
var config float MaxTradeTimeMargin; // Only relevant when bRestrictTrading is true
var config float TradePingMargin;
var config float KillCamDelay;
var config float KillCamDuration;
var config bool  bJumpingPreservesMomentum;
var config bool  bOldLandingMomentum;
var config bool  bEnableSingleButtonDodge;
var config bool  bUseFlipAnimation;
var config bool  bEnableWallDodging;
var config bool  bDodgePreserveZMomentum;
var config int   MaxMultiDodges;
var config int   BrightskinMode; //0=None,1=Unlit
var config float PlayerScale;
var config bool  bAlwaysRenderFlagCarrier;
var config bool  bAlwaysRenderDroppedFlags;
var config int   MaxPosError;
var config int   MaxHitError;
var config float MaxJitterTime;
var config float WarpFixDelay;
var config float MinNetUpdateRate;
var config float MaxNetUpdateRate;
var config bool  bEnableServerExtrapolation;
var config bool  bEnableServerPacketReordering;
var config bool  bEnableLoosePositionCheck;
var config bool  bPlayersAlwaysRelevant;
var config bool  bEnablePingCompensatedSpawn;
var config bool  bEnableJitterBounding;
var config bool  bEnableWarpFix;
var config bool  ShowTouchedPackage;

//Add the maplist where kickers will work using normal network
var config array<string> ExcludeMapsForKickers;

struct ForceSettingsEntry{
	var string Key;
	var string Value;
	var int Mode;
};
var config array<ForceSettingsEntry> ForcedSettings;

function DumpSetting(PlayerPawn P, string S) {
	P.ClientMessage(S$"="$GetPropertyText(S));
}

function DumpServerSettings(PlayerPawn P) {
	P.ClientMessage("SettingsObject="$self);
	DumpSetting(P, "bForceDemo");
	DumpSetting(P, "bRestrictTrading");
	DumpSetting(P, "MaxTradeTimeMargin");
	DumpSetting(P, "TradePingMargin");
	DumpSetting(P, "KillCamDelay");
	DumpSetting(P, "KillCamDuration");
	DumpSetting(P, "bJumpingPreservesMomentum");
	DumpSetting(P, "bOldLandingMomentum");
	DumpSetting(P, "bEnableSingleButtonDodge");
	DumpSetting(P, "bUseFlipAnimation");
	DumpSetting(P, "bEnableWallDodging");
	DumpSetting(P, "bDodgePreserveZMomentum");
	DumpSetting(P, "MaxMultiDodges");
	DumpSetting(P, "BrightskinMode");
	DumpSetting(P, "PlayerScale");
	DumpSetting(P, "bAlwaysRenderFlagCarrier");
	DumpSetting(P, "bAlwaysRenderDroppedFlags");
	DumpSetting(P, "MaxPosError");
	DumpSetting(P, "MaxHitError");
	DumpSetting(P, "MaxJitterTime");
	DumpSetting(P, "WarpFixDelay");
	DumpSetting(P, "MinNetUpdateRate");
	DumpSetting(P, "MaxNetUpdateRate");
	DumpSetting(P, "bEnableServerExtrapolation");
	DumpSetting(P, "bEnableServerPacketReordering");
	DumpSetting(P, "bEnableLoosePositionCheck");
	DumpSetting(P, "bPlayersAlwaysRelevant");
	DumpSetting(P, "bEnablePingCompensatedSpawn");
	DumpSetting(P, "bEnableJitterBounding");
	DumpSetting(P, "bEnableWarpFix");
	DumpSetting(P, "ShowTouchedPackage");
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
	MinClientRate=10000
	MaxClientRate=25000
	bAdvancedTeamSay=True
	ForceSettingsLevel=2
	bWarmup=True
	ForceModels=1
	ImprovedHUD=1
	bDelayedPickupSpawn=False
	bUseFastWeaponSwitch=False
	DefaultHitSound=2
	DefaultTeamHitSound=3
	TeleRadius=210
	ThrowVelocity=750
	NNAnnouncer=True
	MaxPosError=1000
	MaxHitError=10000
	MaxJitterTime=0.1
	WarpFixDelay=0.25
	MinNetUpdateRate=60.0
	MaxNetUpdateRate=200.0
	ShowTouchedPackage=False
	bRestrictTrading=True
	MaxTradeTimeMargin=0.1
	TradePingMargin=0.5
	KillCamDelay=0.0
	KillCamDuration=2.0
	bJumpingPreservesMomentum=False
	bOldLandingMomentum=True
	bEnableSingleButtonDodge=True
	bUseFlipAnimation=True
	bEnableWallDodging=False
	bDodgePreserveZMomentum=False
	MaxMultiDodges=1
	BrightskinMode=1
	PlayerScale=1.0
	bAlwaysRenderFlagCarrier=False
	bAlwaysRenderDroppedFlags=False
	bEnableServerExtrapolation=False
	bEnableServerPacketReordering=False
	bEnableLoosePositionCheck=False
	bPlayersAlwaysRelevant=True
	bEnablePingCompensatedSpawn=True
	bEnableJitterBounding=False
	bEnableWarpFix=True
}
