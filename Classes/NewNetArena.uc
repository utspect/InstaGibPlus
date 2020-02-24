class NewNetArena expands Arena;

var name WeaponNames[8], AmmoNames[8];
var string WeaponPackages[8], WeaponStrings[8], AmmoStrings[8];

function PreBeginPlay()
{
	local int i;
	local UTPure UTP;
	
	ForEach AllActors(class'UTPure', UTP)
		break;
	
	for (i = 0; i < 8; i++)
	{
		UTP.zzDefaultPackages[i] = WeaponPackages[i];
		UTP.zzDefaultWeapons[i] = WeaponNames[i];
	}
	
	Super.PreBeginPlay();
	
}

function AddMutator(Mutator M)
{
	if ( M.IsA('Arena') )
	{
		log(M$" not allowed (already have an Arena mutator)");
		return; //only allow one arena mutator
	}
	Super.AddMutator(M);
}

function bool IsWeapon(actor Other)
{
	local int i;
	
	if (Other.IsA(DefaultWeapon.Name))
		return true;
	
	for (i = 0; i < 8; i++)
		if (Other.Class.Name == WeaponNames[i])
			return true;
			
	return false;
}

function bool IsAmmo(actor Other)
{
	local int i;
	
	for (i = 0; i < 8; i++)
		if (Other.IsA(AmmoNames[i]))
			return true;
			
	return false;
}

function bool AlwaysKeep(Actor Other)
{
	if ( Other.IsA('Weapon') && IsWeapon(Other) )
		return true;
		
	if ( Other.IsA('Ammo') && IsAmmo(Other) )
		return true;

	if ( NextMutator != None )
		return ( NextMutator.AlwaysKeep(Other) );
	return false;
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	if ( Other.IsA('Weapon') && !IsWeapon(Other) )
		return false;

	if ( Other.IsA('Ammo') && !IsAmmo(Other) )
		return false;

	return Super.CheckReplacement( Other, bSuperRelevant );
}

function ScoreKill(Pawn Killer, Pawn Other)
{
	if (IsWeapon(Other.Weapon))
		Other.Weapon = None;
}

defaultproperties
{
}
