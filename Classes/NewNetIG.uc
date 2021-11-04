class NewNetIG extends Arena;

var Object WeaponSettingsHelper;
var WeaponSettings WeaponSettings;

function PreBeginPlay() {
	super.PreBeginPlay();

	WeaponSettingsHelper = new(none, 'InstaGibPlus') class'Object';
	WeaponSettings = new(WeaponSettingsHelper, 'WeaponSettingsNewNet') class'WeaponSettings';
	WeaponSettings.SaveConfig();
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	if ( Other.IsA('TournamentHealth') || Other.IsA('UT_Shieldbelt')
		|| Other.IsA('Armor2') || Other.IsA('ThighPads')
		|| Other.IsA('UT_Invisibility') || Other.IsA('UDamage') )
		return false;

	return Super.CheckReplacement( Other, bSuperRelevant );

}

defaultproperties
{
     WeaponName=NN_SuperShockRifle
     AmmoName=SuperShockCore
     DefaultWeapon=class'NN_SuperShockRifle'
}
