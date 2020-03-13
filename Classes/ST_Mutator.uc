// ===============================================================
// Stats.ST_Mutator: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_Mutator extends Mutator;

var string PreFix;
var DeathMatchPlus DMP;
var vector VecNull;
var bool bFixedWeapons, bStarted, bEnded;
var bool bTranslocatorGame;
var int WeaponDisplay;

function string GetReplacementWeapon(Weapon W, bool bDamnEpic)
{
	local string WStr;
	local int BitMap;

	if ((W.IsA('ImpactHammer') && !W.IsA('ST_ImpactHammer')) || W.IsA('DispersionPistol') && !bDamnEPIC)
	{
		WStr = "ST_ImpactHammer";
		BitMap = (1 << 1);							// IH = 01
	}
	else if (W.IsA('Translocator') && !W.IsA('ST_Translocator'))
	{
		/* if (class'UTPure'.default.zzbH4x)
			WStr = "h4x_Xloc";
		else
			WStr = "ST_Translocator";
		BitMap = (1 << 2); */							// TLoc = 02
	}
	else if ((W.IsA('enforcer') && !W.IsA('ST_enforcer')) || W.IsA('AutoMag'))
	{
		WStr = "ST_enforcer";
		BitMap = (1 << 3);							// Enforcer = 03
	}
	else if ((W.IsA('ut_biorifle') && !W.IsA('ST_ut_biorifle')) || W.IsA('GesBioRifle'))
	{
		WStr = "ST_ut_biorifle";
		BitMap = (1 << 4);							// BioRifle = 04
	}
	else if ((W.IsA('ShockRifle') && !W.IsA('SuperShockRifle') && !W.IsA('ST_ShockRifle') && !W.IsA('ST_sgShockRifle')) || W.IsA('ASMD'))
	{
		WStr = "ST_ShockRifle";
		BitMap = (1 << 5) | (1 << 6) | (1 << 7);	// Shock Rifle = 05, 06, 07
	}
	else if (W.IsA('SuperShockRifle') && !W.IsA('ST_SuperShockRifle'))
	{
		WStr = "ST_SuperShockRifle";
		BitMap = (1 << 8);							// Super Shock = 08
	}
	else if ((W.IsA('PulseGun') && !W.IsA('ST_PulseGun')) || W.IsA('Stinger'))
	{
		WStr = "ST_PulseGun";
		BitMap = (1 << 9) | (1 << 10);				// Pulse Gun = 09, 10
	}
	else if ( (W.IsA('ripper') && !W.IsA('ST_ripper')) )
	{
		WStr = "ST_ripper";
		BitMap = (1 << 11) | (1 << 12);				// Ripper = 11, 12
	}
	else if ( (W.IsA('minigun2') && !W.IsA('ST_minigun2')) )
	{
		WStr = "ST_minigun2";
		BitMap = (1 << 13);							// Minigun2 = 13
	}
	else if ( (W.IsA('UT_FlakCannon') && !W.IsA('ST_UT_FlakCannon')) )
	{
		WStr = "ST_UT_FlakCannon";
		BitMap = (1 << 14) | (1 << 15);				// Flak Cannon = 14, 15
	}
	else if ((W.IsA('UT_Eightball') && !W.IsA('ST_UT_Eightball') && !W.IsA('ST_sgUT_Eightball')) || W.IsA('Eightball'))
	{
		WStr = "ST_UT_Eightball";
		BitMap = (1 << 16) | (1 << 17);				// Rocket Launcher = 16, 17
	}
	else if ( (W.IsA('SniperRifle') && !W.IsA('ST_SniperRifle')) )
	{
		WStr = "ST_SniperRifle";
		BitMap = (1 << 18);							// Sniper = 18
	}
	else if (W.IsA('WarheadLauncher') && !W.IsA('ST_WarheadLauncher'))
	{
		WStr = "ST_WarheadLauncher";
		BitMap = (1 << 19);							// Redeemer = 19
	}
	////////////////// Auto replace Unreal Weapons & OldSkool Weapons to NewNet one!
	else if ((W.IsA('OlRazorjack') && !W.IsA('ST_RazorJack')) || W.IsA('Razorjack'))
	{
		WStr = "ST_RazorJack";
	}
	else if ((W.IsA('OlMinigun') && !W.IsA('ST_Minigun')) || W.IsA('Minigun'))
	{
		WStr = "ST_Minigun";
	}
	else if ((W.IsA('OlFlakCannon') && !W.IsA('ST_FlakCannon')) || W.IsA('FlakCannon'))
	{
		WStr = "ST_FlakCannon";
	}
	else if ((W.IsA('OlRifle') && !W.IsA('ST_Rifle')) || W.IsA('Rifle'))
	{
		WStr = "ST_Rifle";
	}
	////////////////// End!
	WeaponDisplay = WeaponDisplay | BitMap;
	return WStr;
}

function FixBitMap(name WeaponName, bool bDamnEpic)
{
	local int BitMap;
	
	if (WeaponName == 'ST_ImpactHammer' && !bDamnEPIC)
		BitMap = (1 << 1);							// IH = 01
	else if (WeaponName == 'ST_Translocator' || WeaponName == 'Grappling')
		BitMap = (1 << 2);							// TLoc = 02
	else if (WeaponName == 'ST_enforcer')
		BitMap = (1 << 3);							// Enforcer = 03
	else if (WeaponName == 'ST_ut_biorifle')
		BitMap = (1 << 4);							// BioRifle = 04
	else if (WeaponName == 'ST_ShockRifle')
		BitMap = (1 << 5) | (1 << 6) | (1 << 7);	// Shock Rifle = 05, 06, 07
	else if (WeaponName == 'ST_SuperShockRifle')
		BitMap = (1 << 8);							// Super Shock = 08
	else if (WeaponName == 'ST_PulseGun')
		BitMap = (1 << 9) | (1 << 10);				// Pulse Gun = 09, 10
	else if (WeaponName == 'ST_ripper')
		BitMap = (1 << 11) | (1 << 12);				// Ripper = 11, 12
	else if (WeaponName == 'ST_minigun2')
		BitMap = (1 << 13);							// Minigun2 = 13
	else if (WeaponName == 'ST_UT_FlakCannon')
		BitMap = (1 << 14) | (1 << 15);				// Flak Cannon = 14, 15
	else if (WeaponName == 'ST_UT_Eightball')
		BitMap = (1 << 16) | (1 << 17);				// Rocket Launcher = 16, 17
	else if (WeaponName == 'ST_SniperRifle')
		BitMap = (1 << 18);							// Sniper = 18
	else if (WeaponName == 'ST_WarheadLauncher')
		BitMap = (1 << 19);							// Redeemer = 19

	WeaponDisplay = WeaponDisplay | BitMap;
}

function ReplaceWeapons()
{
	local string NewClassName;
	local Weapon W;
	local Arena ArenaMutator;
	local NewNetArena PA;
	local int i;
	local ScriptedPawn SP;

	WeaponDisplay = 1;

	W = Spawn(Level.Game.BaseMutator.MutatedDefaultWeapon());
	GetReplacementWeapon(W, False);
	W.Destroy();				
	ForEach AllActors(Class'Arena', ArenaMutator)
	{
		PA = NewNetArena(ArenaMutator);
		if (PA != None)
			break;
	}
	if (ArenaMutator != None && PA == None)
		return;

	if (bTranslocatorGame)
		WeaponDisplay = WeaponDisplay | (1 << 2);
	
	if (PA == None)
	{
		WeaponDisplay = WeaponDisplay | (1 << 3);

		ForEach AllActors(Class'Weapon', W)
		{
			if (W.Location != VecNull && !W.Owner.IsA('ScriptedPawn'))
			{
				NewClassName = GetReplacementWeapon(W, True);
				if (NewClassName != "")
				{
					ReplaceWith(W, PreFix$NewClassName);
					W.GotoState('');
					W.Destroy();
				}
			}
		}
	}
	else
	{
		for (i = 0; i < 8; i++)
			FixBitMap(PA.WeaponNames[i], False);
	}
}

function GiveGoodWeapon(Pawn PlayerPawn, string aClassName, Weapon OldWeapon )
{
	local class<Weapon> WeaponClass;
	local Weapon NewWeapon;

	WeaponClass = class<Weapon>(DynamicLoadObject(aClassName, class'Class'));

	if( PlayerPawn.FindInventoryType(WeaponClass) != None || WeaponClass == None)
		return;
	newWeapon = Spawn(WeaponClass);
	if (OldWeapon == None)
		OldWeapon = newWeapon;
	if( newWeapon != None )
	{
		newWeapon.RespawnTime = 0.0;
		newWeapon.GiveTo(PlayerPawn);
		newWeapon.bHeldItem = true;
		newWeapon.GiveAmmo(PlayerPawn);
		newWeapon.SetSwitchPriority(PlayerPawn);
		if (newWeapon.Class == Level.Game.BaseMutator.MutatedDefaultWeapon())
			newWeapon.WeaponSet(PlayerPawn);
		newWeapon.AmbientGlow = 0;
		newWeapon.bCanThrow = OldWeapon.bCanThrow && OldWeapon.Class != Level.Game.BaseMutator.MutatedDefaultWeapon();
		PlayerPawn.PendingWeapon = None;
		if ( PlayerPawn.IsA('PlayerPawn') )
			newWeapon.SetHand(PlayerPawn(PlayerPawn).Handedness);
		else
			newWeapon.GotoState('Idle');
	}
}

function SwitchWeaponsInventory(Pawn Other)
{
	local Weapon W, Best;
	local Inventory Inv;
	local float Current, Highest;
	local string NewName[32];
	local Weapon OldWeap[32];
	local int NewCount, x;
	local name n;
	local UTPure UTP;
	local Weapon NewWeapon;

	if (Other.Weapon != None)
		n = Other.Weapon.Class.Name;
	else if (Other.PendingWeapon != None)
		n = Other.PendingWeapon.Class.Name;
	Other.Weapon = None;
	Other.PendingWeapon = None;

	for (Inv = Other.Inventory; Inv != None; Inv = Inv.Inventory)
	{
		W = Weapon(Inv);
		if (W != None)
		{
			NewName[NewCount] = GetReplacementWeapon(W, False);
			if (NewName[NewCount] != "")
			{
				NewName[NewCount] = PreFix$NewName[NewCount];
				OldWeap[NewCount] = W;
				NewCount++;
			}
		}
	}

	for (x = NewCount -1; x >= 0; x--)
	{
		GiveGoodWeapon(Other, NewName[x], OldWeap[x]);
		OldWeap[x].GotoState('');
		Other.DeleteInventory(OldWeap[x]);
	}

	if (bTranslocatorGame)
	{
		//GiveGoodWeapon(Other, PreFix$"ST_Translocator", None);
		DMP.bUseTranslocator = False;
	}
	
	ForEach AllActors(class'UTPure', UTP)
		break;
	
	for (x = 0; x < 8; x++)
		if (UTP.zzDefaultWeapons[x] != '')
		{
			if (UTP.zzDefaultPackages[x] != "")
				GiveGoodWeapon(Other, UTP.zzDefaultPackages[x]$"."$string(UTP.zzDefaultWeapons[x]), None);
			else
				GiveGoodWeapon(Other, PreFix$string(UTP.zzDefaultWeapons[x]), None);
		}

	Other.Weapon = None;
	for (Inv=Inventory; Inv!=None; Inv=Inv.Inventory)
	{
		if (Inv.IsA(n))
		{
			Best = Weapon(Inv);
			break;
		}
		w = Weapon(Inv);
		if (w == None || (w.AmmoType != None && w.AmmoType.AmmoAmount <= 0))
			continue;
		w.SetSwitchPriority(Other);
		Current = w.AutoSwitchPriority;
		if ( Current > Highest )
		{
			Best = w;
			Highest = Current;
		}
	}
	
	if (Best == None)
		Other.SwitchToBestWeapon();
	else
	{
		Other.PendingWeapon = Best;
		Other.ChangedWeapon();
	}
}

function ModifyPlayer(Pawn Other)
{
	Super.ModifyPlayer(Other);
	SwitchWeaponsInventory(Other);
}

function bool AlwaysKeep(Actor Other)
{
    if (((Level.Game.IsA('NewNetIG') || Level.Game.IsA('NewNetTG')
									 || Level.Game.IsA('NewNetSDOM')) && Other.IsA('NN_Armor2')
									 || Other.IsA('NN_ThighPads')))
        return true;
	
    return Super.AlwaysKeep(Other);
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
    if (Level.Game.IsA('NewNetIG') ||
		Level.Game.IsA('NewNetTG') ||
		Level.Game.IsA('NewNetSDOM'))
	{
		if ( Other.IsA('Armor2') || Other.IsA('Armor') )
		{
			ReplaceWith( Other, Prefix$"NN_Armor2" );
			return false;
		} else if ( Other.IsA('ThighPads') || Other.IsA('KevlarSuit') )
		{
			ReplaceWith( Other, Prefix$"NN_ThighPads" );
			return false;
		}
	}
    return true;
}

function Tick(float deltaTime)
{
	DMP.bUseTranslocator = bTranslocatorGame;

	if (!bStarted)
	{
		if (!bFixedWeapons)
		{
			ReplaceWeapons();
			bFixedWeapons = True;
		}
		if (DMP.bRequireReady && DMP.CountDown > 0)
			return;
		bStarted = True;
	}

	if (!bEnded)
	{
		if (!DMP.bGameEnded && Level.NextURL == "")
			return;
		bEnded = True;
	}
}

function PreBeginPlay()
{
	DMP = DeathMatchPlus(Level.Game);
	DMP.BotConfigType = Class'ST_ChallengeBotInfo';		// Make sure game uses our �bersuperior bots.
	if (DMP.BotConfig != None)
	{	// Replace if already exists.
		DMP.BotConfig.Destroy();
		DMP.BotConfig = Spawn(DMP.BotConfigType);
	}
	bTranslocatorGame = DMP.bUseTranslocator;
	PreFix = Default.PreFix$Class'UTPure'.Default.ThisVer$".";
/* 	Level.Game.RegisterMessageMutator(Self);
	Class'bbCHSpectator'.Default.cStat = Class'ST_PureStatsSpec'; */
	Super.PreBeginPlay();
}

function bool ReplaceWith(actor Other, string aClassName)
{
	local Actor A;
	local class<Actor> aClass;

	if ( Other.IsA('Inventory') && (Other.Location == vect(0,0,0)) )
		return false;
	aClass = class<Actor>(DynamicLoadObject(aClassName, class'Class'));
	if ( aClass != None )
		A = Spawn(aClass, Other.Owner, Other.tag, Other.Location, Other.Rotation);
	if ( Other.IsA('Inventory') )
	{
		if ( Inventory(Other).MyMarker != None )
		{
			Inventory(Other).MyMarker.markedItem = Inventory(A);
			if ( Inventory(A) != None )
			{
				Inventory(A).MyMarker = Inventory(Other).MyMarker;
				A.SetCollisionSize( Other.CollisionRadius, Other.CollisionHeight);
			}
			Inventory(Other).MyMarker = None;
		}
		else if ( A.IsA('Inventory') )
		{
			Inventory(A).bHeldItem = true;
			Inventory(A).Respawntime = 0.0;
		}
	}
	if ( A != None )
	{
		A.event = Other.event;
		A.tag = Other.tag;

		Inventory(A).Multiskins[0] = Inventory(Other).Multiskins[0];
		Inventory(A).Multiskins[1] = Inventory(Other).Multiskins[1];
		Inventory(A).Multiskins[2] = Inventory(Other).Multiskins[2];
		Inventory(A).Multiskins[3] = Inventory(Other).Multiskins[3];
		Inventory(A).Multiskins[4] = Inventory(Other).Multiskins[4];
		Inventory(A).Multiskins[5] = Inventory(Other).Multiskins[5];
		Inventory(A).Multiskins[6] = Inventory(Other).Multiskins[6];
		Inventory(A).Multiskins[7] = Inventory(Other).Multiskins[7];
		Inventory(A).Skin = Inventory(Other).Skin;
		Inventory(A).Style = Inventory(Other).Style;
		Inventory(A).bMeshEnviroMap = Inventory(Other).bMeshEnviroMap;
		Inventory(A).bAmbientGlow = Inventory(Other).bAmbientGlow;
		Inventory(A).ScaleGlow = Inventory(Other).ScaleGlow;
		Inventory(A).AmbientGlow = Inventory(Other).AmbientGlow;
		Inventory(A).PickupSound = Inventory(Other).PickupSound;
		Inventory(A).MaxDesireability = Inventory(Other).MaxDesireability;
		Inventory(A).ActivateSound = Inventory(Other).ActivateSound;
		Inventory(A).DeActivateSound = Inventory(Other).DeActivateSound;
		Inventory(A).DrawScale = Inventory(Other).DrawScale;
		Inventory(A).AutoSwitchPriority = Inventory(Other).AutoSwitchPriority;
		Inventory(A).InventoryGroup = Inventory(Other).InventoryGroup;
		Inventory(A).PlayerViewOffset = Inventory(Other).PlayerViewOffset;
		Inventory(A).PlayerViewMesh = Inventory(Other).PlayerViewMesh;
		Inventory(A).PlayerViewScale = Inventory(Other).PlayerViewScale;
		Inventory(A).BobDamping = Inventory(Other).BobDamping;
		Inventory(A).PickupViewMesh = Inventory(Other).PickupViewMesh;
		Inventory(A).PickupViewScale = Inventory(Other).PickupViewScale;
		Inventory(A).ThirdPersonMesh = Inventory(Other).ThirdPersonMesh;
		Inventory(A).ThirdPersonScale = Inventory(Other).ThirdPersonScale;
		Inventory(A).StatusIcon = Inventory(Other).StatusIcon;
		Inventory(A).Icon = Inventory(Other).Icon;
		Inventory(A).PickupSound = Inventory(Other).PickupSound;
		Inventory(A).RespawnSound = Inventory(Other).RespawnSound;
		Inventory(A).PickupMessageClass = Inventory(Other).PickupMessageClass;
		Inventory(A).ItemMessageClass = Inventory(Other).ItemMessageClass;
		Inventory(A).RespawnTime = Inventory(Other).RespawnTime;
		Inventory(A).bRotatingPickup = Inventory(Other).bRotatingPickup;
		Inventory(A).AttachTag = Inventory(Other).AttachTag;
		Inventory(A).bBounce = Inventory(Other).bBounce;
		Inventory(A).bFixedRotationDir = Inventory(Other).bFixedRotationDir;
		Inventory(A).bRotateToDesired = Inventory(Other).bRotateToDesired;
		Inventory(A).Buoyancy = Inventory(Other).Buoyancy;
		Inventory(A).DesiredRotation = Inventory(Other).DesiredRotation;
		Inventory(A).Mass = Inventory(Other).Mass;
		Inventory(A).RotationRate = Inventory(Other).RotationRate;
		Inventory(A).Velocity = Inventory(Other).Velocity;
		Inventory(A).SetPhysics(Inventory(Other).Physics);
		//Inventory(A).bActivatable = Inventory(Other).bActivatable;
		//Inventory(A).bDisplayableInv = Inventory(Other).bDisplayableInv;
		//Inventory(A).M_Activated = Inventory(Other).M_Activated;
		//Inventory(A).M_Selected = Inventory(Other).M_Selected;
		//Inventory(A).M_Deactivated = Inventory(Other).M_Deactivated;
		return true;
	}
	return false;
}

defaultproperties
{
	Prefix="UN"
	DefaultWeapon=Class'ST_ImpactHammer'
}