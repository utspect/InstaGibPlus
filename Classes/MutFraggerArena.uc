class MutFraggerArena extends Arena;
// Description="Sniper+Translocator camping combat"

////////////////////////////////////////////////////////////////////////////////
//   CustomArena
//
//   Replaces all game weapons/ammo with custom weapon/ammo, and changes the
//   default weapon from the impact hammer to the translocator.
//
//   This code combines elements of the standard Arena mutator with common
//   weapon swapper code found in most zark and clan sniper rifles, which (to my
//   knowledge) was created by SpawnKiller/SkullKrusher.
//
//   Authored by :[lol]:Mhor of www.teamlol.com
//
////////////////////////////////////////////////////////////////////////////////

//Begin No Telefragging addition
var config bool NoTeleFrag;

var IGPlus_WeaponImplementation WImpl;

function InitializeSettings() {
	WImpl = Spawn(class'IGPlus_WeaponImplementationBase');
	WImpl.InitWeaponSettings("WeaponSettingsFraggerArena");
}

function PreBeginPlay() {
	super.PreBeginPlay();

	InitializeSettings();
	if (WImpl.WeaponSettings.DefaultWeaponClass != "") {
		DefaultWeapon = class<Weapon>(DynamicLoadObject(WImpl.WeaponSettings.DefaultWeaponClass, class'Class', true));
		if (DefaultWeapon == none)
			DefaultWeapon = default.DefaultWeapon;
	}
}

function ModifyPlayer(Pawn Other)
{
   DeathMatchPlus(Level.Game).GiveWeapon(Other, string(class'NN_FraggerRifle'));
   if(NextMutator != None)
	  NextMutator.ModifyPlayer(Other);
}

function bool AlwaysKeep(Actor Other)
{
	if(Other.IsA('Enforcer') || Other.IsA('ImpactHammer'))
		return false;

	if(Other.IsA(WeaponName))
	{
		Weapon(Other).PickupAmmoCount=Weapon(Other).default.PickUpAmmoCount;
		return true;
	}

	if(Other.IsA(AmmoName))
	{
		Ammo(Other).AmmoAmount=Ammo(Other).AmmoAmount;
		return true;
	}

	if(NextMutator != None)
		return(NextMutator.AlwaysKeep(Other));
	return false;
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	if (Other.IsA('Weapon'))
	{
		if (Other.IsA('Enforcer') || Other.IsA('ImpactHammer')) {
			return false;
		} else if(Other.IsA('Translocator')) {
			return true;
		} else {
			if (!Other.IsA(WeaponName)) {
				ReplaceWith(Other, string(class'NN_FraggerRifle'));
				return false;
			}
			bSuperRelevant=0;
			return false;

		}
	}
	if(Other.IsA('Ammo') && !Other.IsA(AmmoName)) {
		ReplaceWith(Other, string(class'NN_FraggerAmmo'));
		return false;
	}
	return true;
}
///////////////////////////////////////////////////////////
function bool DisruptedKill(Pawn Killer, Pawn Killed)
{
	local TranslocatorTarget T, KillerTarget, KilledTarget;
	local bool bKillerTargetDisrupted;
	local bool bKilledTargetDisrupted;

	ForEach AllActors(class'TranslocatorTarget', T) {
		if ( T.Instigator == Killer )
			KillerTarget = T;
		else if ( T.Instigator == Killed )
			KilledTarget = T;
		if ( KilledTarget != None && KillerTarget != None )
			break;
	}

	bKillerTargetDisrupted = KillerTarget != None && KillerTarget.Disrupted();
	bKilledTargetDisrupted = KilledTarget != None && KilledTarget.Disrupted();

	return bKilledTargetDisrupted && (bKillerTargetDisrupted || KillerTarget == None);
}


///////////////////////////////////////////////////////////////////////////////////////
function bool PreventDeath(Pawn Killed, Pawn Killer, name damageType, vector HitLocation)
{
	local bool bDisruptedKill;

	if ( NoTeleFrag )
	{
		bDisruptedKill =  DisruptedKill(Killer, Killed);
		if ( !bDisruptedKill  && DamageType == 'Gibbed' && Killed != None && Killer != None && Killed != Killer ) {
			SetTimer(0.01, False);
			Killed.Health = Killed.default.Health;
			Super.PreventDeath(Killed, Killer, DamageType, HitLocation);
			PunishTelefragger(Killer, Killed);
			return true;
		}
	}
	return Super.PreventDeath(Killed, Killer, DamageType, HitLocation);
}


///////////////////////////////////////////////////////////////////
function Timer()
{
//PunishTelefragger(LastKiller, LastVictim);
}

function PunishTelefragger(Pawn Llama, Pawn Victim)
{
	BroadcastLocalizedMessage(class'LlamaMessage', 0, Llama.PlayerReplicationInfo, Victim.PlayerReplicationInfo);
	DoPunishment(Llama);
}

function DoPunishment(Pawn Llama)
{
	//test dont do anything;
	Llama.Health = -1000;
	Llama.Died(Llama, 'Suicided', Llama.Location);
}
//End No Telefragging addition

defaultproperties
{
	DefaultWeapon=class'ST_FraggerTranslocator'
	NoTeleFrag=True
	WeaponName=NN_FraggerRifle
	AmmoName=NN_FraggerAmmo
}
