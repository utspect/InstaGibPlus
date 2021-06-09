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

var config float SniperDamage;
var config float SniperHeadshotDamage;
var config float SniperMomentum;
var config float SniperHeadshotMomentum;
var config float SniperReloadTime;

var config float RocketDamage;
var config float RocketHurtRadius;
var config float RocketMomentum;
var config float GrenadeDamage;
var config float GrenadeHurtRadius;
var config float GrenadeMomentum;

var config float FlakChunkDamage;
var config float FlakChunkMomentum;
var config float FlakSlugDamage;
var config float FlakSlugHurtRadius;
var config float FlakSlugMomentum;

var config float MinigunSpinUpTime;
var config float MinigunBulletInterval;
var config float MinigunAlternateBulletInterval;
var config float MinigunMinDamage;
var config float MinigunMaxDamage;

var config float PulseSphereDamage;
var config float PulseSphereMomentum;
var config float PulseBoltDPS;
var config float PulseBoltMomentum;
var config float PulseBoltMaxAccumulate;
var config float PulseBoltGrowthDelay;
var config int   PulseBoltMaxSegments;

var config float ShockBeamDamage;
var config float ShockBeamMomentum;
var config float ShockProjectileDamage;
var config float ShockProjectileHurtRadius;
var config float ShockProjectileMomentum;
var config float ShockComboDamage;
var config float ShockComboMomentum;
var config float ShockComboHurtRadius;

var config float BioDamage;
var config float BioMomentum;
var config float BioAltDamage;
var config float BioAltMomentum;
var config float BioHurtRadiusBase;
var config float BioHurtRadiusMax;

var config float EnforcerDamage;
var config float EnforcerMomentum;

var config float HammerDamage;
var config float HammerMomentum;
var config float HammerSelfDamage;
var config float HammerSelfMomentum;
var config float HammerAltDamage;
var config float HammerAltMomentum;
var config float HammerAltSelfDamage;
var config float HammerAltSelfMomentum;

var config float TranslocatorHealth;

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

	SniperDamage=45
	SniperHeadshotDamage=100
	SniperMomentum=1.0
	SniperHeadshotMomentum=1.0
	SniperReloadTime=0.6666666666

	RocketDamage=75
	RocketHurtRadius=220
	RocketMomentum=1.0
	GrenadeDamage=80
	GrenadeHurtRadius=200
	GrenadeMomentum=1.0

	FlakChunkDamage=16
	FlakChunkMomentum=1.0
	FlakSlugDamage=70
	FlakSlugHurtRadius=150
	FlakSlugMomentum=1.0

	MinigunSpinUpTime=0.130
	MinigunBulletInterval=0.080
	MinigunAlternateBulletInterval=0.050
	MinigunMinDamage=5
	MinigunMaxDamage=7

	PulseSphereDamage=20
	PulseSphereMomentum=1.0
	PulseBoltDPS=72
	PulseBoltMomentum=1.0
	PulseBoltMaxAccumulate=0.08
	PulseBoltGrowthDelay=0.05
	PulseBoltMaxSegments=10

	ShockBeamDamage=40
	ShockBeamMomentum=1.0
	ShockProjectileDamage=55
	ShockProjectileHurtRadius=70
	ShockProjectileMomentum=1.0
	ShockComboDamage=165
	ShockComboHurtRadius=250
	ShockComboMomentum=1.0

	BioDamage=20
	BioMomentum=1.0
	BioAltDamage=75
	BioAltMomentum=1.0
	BioHurtRadiusBase=75
	BioHurtRadiusMax=250

	EnforcerDamage=17
	EnforcerMomentum=1.0

	HammerDamage=60
	HammerMomentum=1.0
	HammerSelfDamage=36
	HammerSelfMomentum=1.0
	HammerAltDamage=20
	HammerAltMomentum=1.0
	HammerAltSelfDamage=24
	HammerAltSelfMomentum=1.0

	TranslocatorHealth=65.0
}