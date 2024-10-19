class WeaponSettings extends Object perobjectconfig;

var config bool bReplaceImpactHammer;
var config bool bReplaceTranslocator;
var config bool bReplaceEnforcer;
var config bool bReplaceBioRifle;
var config bool bReplaceShockRifle;
var config bool bReplaceSuperShockRifle;
var config bool bReplacePulseGun;
var config bool bReplaceRipper;
var config bool bReplaceMinigun;
var config bool bReplaceFlakCannon;
var config bool bReplaceRocketLauncher;
var config bool bReplaceSniperRifle;
var config bool bReplaceWarheadLauncher;

var config bool  bEnableEnhancedSplashBio;
var config bool  bEnableEnhancedSplashShockCombo;
var config bool  bEnableEnhancedSplashShockProjectile;
var config bool  bEnableEnhancedSplashRipperSecondary;
var config bool  bEnableEnhancedSplashFlakSlug;
var config bool  bEnableEnhancedSplashRockets;
var config bool  bEnhancedSplashIgnoreStationaryPawns;
var config float SplashMaxDiffraction;
var config float SplashMinDiffractionDistance;

var config float HeadHalfHeight;
var config float HeadRadius;

var config float WarheadSelectTime;
var config float WarheadDownTime;

var config float SniperSelectTime;
var config float SniperDownTime;
var config float SniperDamage;
var config float SniperHeadshotDamage;
var config float SniperMomentum;
var config float SniperHeadshotMomentum;
var config float SniperReloadTime;
var config bool  SniperUseReducedHitbox;

var config float EightballSelectTime;
var config float EightballDownTime;
var config float RocketDamage;
var config float RocketHurtRadius;
var config float RocketMomentum;
var config float RocketSpreadSpacingDegrees;
var config float GrenadeDamage;
var config float GrenadeHurtRadius;
var config float GrenadeMomentum;

var config float FlakSelectTime;
var config float FlakPostSelectTime;
var config float FlakDownTime;
var config float FlakChunkDamage;
var config float FlakChunkMomentum;
var config float FlakChunkLifespan;
var config float FlakChunkDropOffStart;
var config float FlakChunkDropOffEnd;
var config float FlakChunkDropOffDamageRatio;
var config float FlakSlugDamage;
var config float FlakSlugHurtRadius;
var config float FlakSlugMomentum;

var config float RipperSelectTime;
var config float RipperDownTime;
var config float RipperHeadshotDamage;
var config float RipperHeadshotMomentum;
var config float RipperPrimaryDamage;
var config float RipperPrimaryMomentum;
var config float RipperSecondaryHurtRadius;
var config float RipperSecondaryDamage;
var config float RipperSecondaryMomentum;

var config float MinigunSelectTime;
var config float MinigunDownTime;
var config float MinigunSpinUpTime;
var config float MinigunUnwindTime;
var config float MinigunBulletInterval;
var config float MinigunAlternateBulletInterval;
var config float MinigunMinDamage;
var config float MinigunMaxDamage;

var config float PulseSelectTime;
var config float PulseDownTime;
var config float PulseSphereDamage;
var config float PulseSphereMomentum;
var config float PulseSphereSpeed;
var config float PulseSphereFireRate;
var config float PulseBoltDPS;
var config float PulseBoltMomentum;
var config float PulseBoltMaxAccumulate;
var config float PulseBoltGrowthDelay;
var config int   PulseBoltMaxSegments;

var config float ShockSelectTime;
var config float ShockDownTime;
var config float ShockBeamDamage;
var config float ShockBeamMomentum;
var config bool  ShockBeamUseReducedHitbox;
var config float ShockProjectileDamage;
var config float ShockProjectileHurtRadius;
var config float ShockProjectileMomentum;
var config bool  ShockProjectileBlockBullets;
var config bool  ShockProjectileBlockFlakChunk;
var config bool  ShockProjectileBlockFlakSlug;
var config bool  ShockProjectileTakeDamage;
var config bool  ShockProjectileCompensatePing;
var config float ShockProjectileHealth;
var config float ShockComboDamage;
var config float ShockComboMomentum;
var config float ShockComboHurtRadius;

var config float BioSelectTime;
var config float BioDownTime;
var config float BioDamage;
var config float BioMomentum;
var config bool  BioPrimaryInstantExplosion; 
var config float BioAltDamage;
var config float BioAltMomentum;
var config float BioHurtRadiusBase;
var config float BioHurtRadiusMax;

var config float EnforcerSelectTime;
var config float EnforcerDownTime;
var config float EnforcerDamage;
var config float EnforcerMomentum;
var config float EnforcerReloadTime;
var config float EnforcerReloadTimeAlt;
var config float EnforcerReloadTimeRepeat;
var config bool  EnforcerUseReducedHitbox;

var config bool  EnforcerAllowDouble;
var config float EnforcerDamageDouble;
var config float EnforcerMomentumDouble;
var config float EnforcerShotOffsetDouble;
var config float EnforcerReloadTimeDouble;
var config float EnforcerReloadTimeAltDouble;
var config float EnforcerReloadTimeRepeatDouble;

var config float HammerSelectTime;
var config float HammerDownTime;
var config float HammerDamage;
var config float HammerMomentum;
var config float HammerSelfDamage;
var config float HammerSelfMomentum;
var config float HammerAltDamage;
var config float HammerAltMomentum;
var config float HammerAltSelfDamage;
var config float HammerAltSelfMomentum;

var config float TranslocatorSelectTime;
var config float TranslocatorOutSelectTime;
var config float TranslocatorDownTime;
var config float TranslocatorHealth;

var config string DefaultWeaponClass;

defaultproperties
{
	bReplaceImpactHammer=True
	bReplaceTranslocator=True
	bReplaceEnforcer=True
	bReplaceBioRifle=True
	bReplaceShockRifle=True
	bReplaceSuperShockRifle=True
	bReplacePulseGun=True
	bReplaceRipper=True
	bReplaceMinigun=True
	bReplaceFlakCannon=True
	bReplaceRocketLauncher=True
	bReplaceSniperRifle=True
	bReplaceWarheadLauncher=True

	bEnableEnhancedSplashBio=False
	bEnableEnhancedSplashShockCombo=False
	bEnableEnhancedSplashShockProjectile=False
	bEnableEnhancedSplashRipperSecondary=True
	bEnableEnhancedSplashFlakSlug=True
	bEnableEnhancedSplashRockets=True
	SplashMaxDiffraction=0.5
	SplashMinDiffractionDistance=50.0

	HeadHalfHeight=7.5
	HeadRadius=10.0

	WarheadSelectTime=0.5
	WarheadDownTime=0.233333

	SniperSelectTime=0.607143
	SniperDownTime=0.233333
	SniperDamage=45
	SniperHeadshotDamage=100
	SniperMomentum=1.0
	SniperHeadshotMomentum=1.0
	SniperReloadTime=0.6666666666
	SniperUseReducedHitbox=False

	EightballSelectTime=0.606061
	EightballDownTime=0.366667
	RocketDamage=75
	RocketHurtRadius=220
	RocketMomentum=1.0
	RocketSpreadSpacingDegrees=3.6
	GrenadeDamage=80
	GrenadeHurtRadius=200
	GrenadeMomentum=1.0

	FlakSelectTime=0.625
	FlakPostSelectTime=0.384615
	FlakDownTime=0.333333
	FlakChunkDamage=16
	FlakChunkMomentum=1.0
	FlakChunkLifespan=2.9
	FlakChunkDropOffStart=0.0
	FlakChunkDropOffEnd=0.0
	FlakChunkDropOffDamageRatio=1.0
	FlakSlugDamage=70
	FlakSlugHurtRadius=150
	FlakSlugMomentum=1.0

	RipperSelectTime=0.75
	RipperDownTime=0.2
	RipperHeadshotDamage=105
	RipperHeadshotMomentum=1.0
	RipperPrimaryDamage=30
	RipperPrimaryMomentum=1.0
	RipperSecondaryHurtRadius=180
	RipperSecondaryDamage=34
	RipperSecondaryMomentum=1.0

	MinigunSelectTime=0.555556
	MinigunDownTime=0.333333
	MinigunSpinUpTime=0.130
	MinigunUnwindTime=0.866666
	MinigunBulletInterval=0.080
	MinigunAlternateBulletInterval=0.050
	MinigunMinDamage=5
	MinigunMaxDamage=7

	PulseSelectTime=0.444444
	PulseDownTime=0.26
	PulseSphereDamage=20
	PulseSphereMomentum=1.0
	PulseSphereSpeed=1450.000000
	PulseSphereFireRate=0.18
	PulseBoltDPS=72
	PulseBoltMomentum=1.0
	PulseBoltMaxAccumulate=0.08
	PulseBoltGrowthDelay=0.05
	PulseBoltMaxSegments=10

	ShockSelectTime=0.5
	ShockDownTime=0.259259
	ShockBeamDamage=40
	ShockBeamMomentum=1.0
	ShockBeamUseReducedHitbox=False
	ShockProjectileDamage=55
	ShockProjectileHurtRadius=70
	ShockProjectileMomentum=1.0
	ShockProjectileBlockBullets=True
	ShockProjectileBlockFlakChunk=True
	ShockProjectileBlockFlakSlug=True
	ShockProjectileTakeDamage=False
	ShockProjectileCompensatePing=False
	ShockProjectileHealth=30
	ShockComboDamage=165
	ShockComboHurtRadius=250
	ShockComboMomentum=1.0

	BioSelectTime=0.488889
	BioDownTime=0.333333
	BioDamage=20
	BioMomentum=1.0
	BioPrimaryInstantExplosion=False
	BioAltDamage=75
	BioAltMomentum=1.0
	BioHurtRadiusBase=75
	BioHurtRadiusMax=250

	EnforcerSelectTime=0.777778
	EnforcerDownTime=0.266667
	EnforcerDamage=17
	EnforcerMomentum=1.0
	EnforcerReloadTime=0.27
	EnforcerReloadTimeAlt=0.26
	EnforcerReloadTimeRepeat=0.266667
	EnforcerUseReducedHitbox=False

	EnforcerAllowDouble=True
	EnforcerDamageDouble=17
	EnforcerMomentumDouble=1.0
	EnforcerShotOffsetDouble=0.2
	EnforcerReloadTimeDouble=0.27
	EnforcerReloadTimeAltDouble=0.26
	EnforcerReloadTimeRepeatDouble=0.266667

	HammerSelectTime=0.566667
	HammerDownTime=0.166667
	HammerDamage=60
	HammerMomentum=1.0
	HammerSelfDamage=36
	HammerSelfMomentum=1.0
	HammerAltDamage=20
	HammerAltMomentum=1.0
	HammerAltSelfDamage=24
	HammerAltSelfMomentum=1.0

	TranslocatorSelectTime=0.363636
	TranslocatorOutSelectTime=0.27
	TranslocatorDownTime=0.212121
	TranslocatorHealth=65.0

	DefaultWeaponClass=""
}