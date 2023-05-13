class NewNetIG extends Arena;

var WeaponSettings WeaponSettings;
var WeaponSettingsRepl WSettingsRepl;

function InitializeSettings() {
	class'WeaponSettingsRepl'.static.CreateWeaponSettings(Level, "WeaponSettingsNewNet", WeaponSettings, WSettingsRepl);
}

function PreBeginPlay() {
	super.PreBeginPlay();

	InitializeSettings();
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
