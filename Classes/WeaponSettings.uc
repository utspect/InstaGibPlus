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
}