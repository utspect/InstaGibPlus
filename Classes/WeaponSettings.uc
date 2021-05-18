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

var config float MinigunSpinUpTime;
var config float MinigunBulletInterval;
var config float MinigunAlternateBulletInterval;
var config float MinigunMinDamage;
var config float MinigunMaxDamage;

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

	MinigunSpinUpTime=0.130
	MinigunBulletInterval=0.080
	MinigunAlternateBulletInterval=0.050
	MinigunMinDamage=5
	MinigunMaxDamage=7

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