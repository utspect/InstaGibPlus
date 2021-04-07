class WeaponSettings extends Object perobjectconfig;

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

	HammerDamage=60.0
	HammerMomentum=1.0
	HammerSelfDamage=36.0
	HammerSelfMomentum=1.0
	HammerAltDamage=20.0
	HammerAltMomentum=1.0
	HammerAltSelfDamage=24.0
	HammerAltSelfMomentum=1.0

	TranslocatorHealth=65.0
}