class NewNetIG expands Arena;

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
     WeaponName=ST_SuperShockRifle
     AmmoName=SuperShockCore
     DefaultWeapon=class'ST_SuperShockRifle'
}
