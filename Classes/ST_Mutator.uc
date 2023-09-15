// ===============================================================
// Stats.ST_Mutator: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_Mutator extends PureStatMutator;

// Good to have Variables
var name ST_Log;
var string PreFix;
var string WelcomeMessage;
var DeathMatchPlus DMP;
var vector VecNull;
var bool bFixedWeapons, bStarted, bEnded;
var bool bTranslocatorGame;
var int WeaponDisplay;

// Variables handling dealing of damage:
var Pawn Shooter;
var ST_PureStats fSTW;
var int WIndex;
var bool bSpecial;

// Variables for tracking flags
const MaxAss = 16;
var Pawn Asses[64];			// Team*16, Who assisted in a cap
var int AssCount[4];			// How many assisted.
var Pawn NextCTFVictim;			// The Guy that just got killed who had flag

var ST_HitTestHelper CollChecker;
var ST_HitTestHelper HitTestHelper;

var WeaponSettings WeaponSettings;
var WeaponSettingsRepl WSettingsRepl;

function ST_PureStats GetStats(Pawn P)
{
	local ST_PureStats Result;

	if (P == None)
		return None;

	if (P.IsA('bbPlayer'))
		Result =  ST_PureStats(bbPlayer(P).GetStats());
	else if (P.IsA('ST_HumanBotPlus'))
		Result =  ST_PureStats(ST_HumanBotPlus(P).GetStats());

	if (Result == None || Result.Owner != P)
		return None;

	return Result;
}

function PlayerFire(Pawn P, int Index)
{	// Player produces a shot. Called for every time something that can deal damage is produced (projectile, beam, fart, whatever)
	local ST_PureStats STW;

	STW = GetStats(P);
	if (STW != None)
		STW.RegisterShot(Index);
}

function PlayerUnfire(Pawn P, int Index)
{	// Player "cancels" a shot, like Combo, which reduces a shock pri/sec
	local ST_PureStats STW;

	STW = GetStats(P);
	if (STW != None)
		STW.UnregisterShot(Index);
}

function PlayerSpecial(Pawn P, int Index)
{	// This would be funny to let you guess what is.
	local ST_PureStats STW;

	STW = GetStats(P);
	if (STW != None)
		STW.RegisterSpecial(Index);
}


function PlayerHit(Pawn P, int Index, bool bIsSpecial)
{	// Player scores a hit. (This must be ended by PlayerClear(), to handle splash damage weapons)
	// This is called just before dealing damage via TakeDamage() or HurtRadius()
	fSTW = GetStats(P);
	bSpecial = bIsSpecial;
	Shooter = P;
	WIndex = Index;
}

function PlayerClear()
{	// This is called just after TakeDamage() or HurtRadius()
	Shooter = None;
	fSTW = None;
	WIndex = 0;
	bSpecial = False;
}

function PlayerTakeDamage(Pawn Victim, Pawn Instigator, int Damage, name DamageType)
{	// Player deals damage to Victim
	local ST_PureStats STW;


	if (Damage <= 0)		// See no reason to register 0 damage or negative damage hits really.
		return;

	if (fSTW != None)
	{
		fSTW.RegisterGivenDamage(WIndex, Damage);
		if (bSpecial)
		{
			fSTW.RegisterSpecial(WIndex);
			bSpecial = False;
		}
	}

	if (Victim == None)
	{
		Log("Victim is NONE in PlayerTakeDamage!", ST_Log);
		return;
	}

	STW = GetStats(Victim);
	if (STW != None)
	{
		STW.RegisterTakenDamage(WIndex, Damage);
		if (DamageType == 'Fell')
			STW.RegisterSpecial(0);
	}
}

function bool HandlePickupQuery(Pawn Other, Inventory item, out byte bAllowPickup)
{
	local bool b;
	local ST_PureStats STW;

	b = Super.HandlePickupQuery(Other, item, bAllowPickup);
	if (b && bAllowPickup != 1)
		return b;

	STW = GetStats(Other);
	if (STW != None)
		STW.RegisterPickup(item);

	return b;
}

//function ScoreKill(Pawn Killer, Pawn Other)
//{	// This is called from GameInfo.Killed(), which is killed from Pawn.Died.
	// Pawn.Died is called from TakeDamage, FellOutOfWorld (Killer==None) and gibbedBy (Telefragged/Fake dead LMS) and PlayerTimeOut(Killer==None)
	// So we know the weapon from WIndex already, as this is called during TakeDamage/HurtRadius. (Before PlayerClear()), unless above
	// Other should never be none. Translocator should set appropriate WIndex before calling gibbedBy.
	// OMFG SCOREKILL DOES NOT RECEIVE TEAMKILLS!
function PlayerKill(Pawn Killer, Pawn Other)
{
	local ST_PureStats STWk, STWv;

	STWk = GetStats(Killer);
	STWv = GetStats(Other);

	if (Killer == None || Other == Killer)	// Suicide!
	{
		if (STWv != None)
			STWv.RegisterKillSelf(WIndex);
	}
	else
	{
		if (STWv != None)
			STWv.RegisterDeath(WIndex);	// Victim got killed by this weapon.
		if (STWk != None)
		{
			if (Level.Game.bTeamGame && Killer.PlayerReplicationInfo.Team == Other.PlayerReplicationInfo.Team)
				STWk.RegisterKillTeam(WIndex);
			else
				STWk.RegisterKill(WIndex);
		}
	}
}

function PlayerFlagPickup(Pawn TargetPractice, bool bFirst)
{
	local ST_PureStats STW;

	STW = GetStats(TargetPractice);

	if (STW != None)
		STW.RegisterFlagPickup(bFirst);
}

function PlayerFlagCapture(Pawn Forrest, bool bSolo)
{
	local ST_PureStats STW;

	STW = GetStats(Forrest);	// RUN RUN

	if (STW != None)
		STW.RegisterFlagCap(bSolo);
}

function PlayerFlagDrop(Pawn BitsNPieces, bool bByDeath)
{
	local ST_PureStats STW;

	STW = GetStats(BitsNPieces);

	if (STW != None)
		STW.RegisterFlagDrop(bByDeath);
}

function PlayerFlagReturn(Pawn HERO, FlagBase Base)
{	// Base is the base of the other team.
	local ST_PureStats STW;

	STW = GetStats(HERO);

	if (STW != None)
		STW.RegisterFlagReturn(VSize(Base.Location - HERO.Location));
}

function PlayerFlagKill(Pawn FlagCamper)
{
	local ST_PureStats STW;

	STW = GetStats(FlagCamper);

	if (STW != None)
		STW.RegisterFlagKill();
}

function PlayerFlagAssist(Pawn FragBait)
{
	local ST_PureStats STW;

	STW = GetStats(FragBait);

	if (STW != None)
		STW.RegisterFlagAssist();
}

function FlagPickup(Pawn TargetPractice, int Team)
{
	local int x, y;

	PlayerFlagPickup(TargetPractice, AssCount[Team] == 0);

	// Add this player to the assist list
	y = Team * MaxAss;

	// See if already exists
	for (x = y; x < (AssCount[Team] + y); x++)
	{
		if (Asses[x] == TargetPractice)
			return;			// Already there, ignore
	}

	if (AssCount[Team] == MaxAss)
	{
		Log("The Ass List is FULL!", ST_Log);
		return;
	}

	// Doesn't exist, so add
	Asses[y + AssCount[Team]] = TargetPractice;
	AssCount[Team]++;

}

function FlagCap(Pawn Wonderboy, int Team)
{
	local int x, y;

	PlayerFlagCapture(Wonderboy, AssCount[Team] == 1);
	y = Team * MaxAss;
	for (x = y; x < (AssCount[Team] + y); x++)
	{
		if (Asses[x] == None || Asses[x] == Wonderboy)
			continue;		// Ignore yourself/players that left
		PlayerFlagAssist(Asses[x]);
	}
	AssCount[Team] = 0;		// Clear Assist list.
}

function bool MutatorBroadcastLocalizedMessage( Actor Sender, Pawn Receiver, out class<LocalMessage> Message, out optional int Switch, out optional PlayerReplicationInfo RelatedPRI_1, out optional PlayerReplicationInfo RelatedPRI_2, out optional Object OptionalObject )
{	// Handle CTF stats here.
	local int Team;

	if (NextCTFVictim != None && Message == Class'DeathMessagePlus' && RelatedPRI_1 != None && RelatedPRI_1.Owner == Receiver)
	{
		if ((Switch == 0 || Switch == 8) && RelatedPRI_2 != None && RelatedPRI_2.Owner == NextCTFVictim)
		{	// Kill		Telefrag	Is a victim		and is the right one.
			PlayerFlagKill(Pawn(RelatedPRI_1.Owner));
		}
		NextCTFVictim = None;
	}

	if (Message == Class'CTFMessage')
	{
		switch(Switch)
		{
			// Switch 0: Capture Message
			//	RelatedPRI_1 is the scorer.
			//	OptionalObject is the flag.
			Case 0:		if (RelatedPRI_1.Owner == Receiver)
						FlagCap(Pawn(RelatedPRI_1.Owner), CTFFlag(OptionalObject).Team);
					break;
			// Switch 1: Return Message
			//	RelatedPRI_1 is the scorer.
			//	OptionalObject is the flag.
			Case 1:		if (RelatedPRI_1.Owner == Receiver)
					{
						Team = CTFFlag(OptionalObject).Team;
						PlayerFlagReturn(Pawn(RelatedPRI_1.Owner), CTFReplicationInfo(Level.Game.GameReplicationInfo).FlagList[1 - Team].HomeBase);
						AssCount[Team] = 0;
					}
					break;
			// Switch 2: Dropped Message
			//	RelatedPRI_1 is the holder.
			//	OptionalObject is the flag's team teaminfo.
			Case 2:		if (RelatedPRI_1.Owner == Receiver)
					{
						NextCTFVictim = Pawn(RelatedPRI_1.Owner);
						PlayerFlagDrop(NextCTFVictim, NextCTFVictim.Health <= 0);
						if (NextCTFVictim.Health > 0)
							NextCTFVictim = None;		// Dropped flag on purpose.
					}
					break;
			// Switch 3: Was Returned Message
			//	OptionalObject is the flag's team teaminfo.
			Case 3:		AssCount[TeamInfo(OptionalObject).TeamIndex] = 0;
					break;
			// Switch 4: Has the flag.
			//	RelatedPRI_1 is the holder.
			//	OptionalObject is the flag's team teaminfo.
			Case 4:		if (RelatedPRI_1.Owner == Receiver)
						FlagPickup(Pawn(RelatedPRI_1.Owner), TeamInfo(OptionalObject).TeamIndex);
					break;
			// Switch 5: Auto Send Home.
			//	OptionalObject is the flag's team teaminfo.
			Case 5:		AssCount[TeamInfo(OptionalObject).TeamIndex] = 0;
					break;
			// Switch 6: Pickup stray.
			//	RelatedPRI_1 is the holder.
			//	OptionalObject is the flag's team teaminfo.
			Case 6:		if (RelatedPRI_1.Owner == Receiver)
						FlagPickup(Pawn(RelatedPRI_1.Owner), TeamInfo(OptionalObject).TeamIndex);
					break;

		}
	}

	return Super.MutatorBroadcastLocalizedMessage(Sender, Receiver, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

// END OF STAT CODE, BELOW IS SETUP CODE

// Returns empty string if no replacement is possible or desired
function string GetReplacementWeapon(Weapon W, bool bDamnEpic)
{	// Damn EPIC is because EPIC for some reason, spawns DefaultWeapon (ImpactHammer) AT THE LOCATION OF THE PLAYER
	// UNLIKE EVERYTHING ELSE THAT WILL BE GIVEN TO THE PLAYER. YES. EPIC ROX! (And don't get me started on translocator!)
	local string WStr;
	local int BitMap;

	if ((W.IsA('ImpactHammer') && !W.IsA('ST_ImpactHammer')) || W.IsA('DispersionPistol') && !bDamnEPIC)
	{
		if (WeaponSettings.bReplaceImpactHammer)
			WStr = "ST_ImpactHammer";
		BitMap = (1 << 1);				// IH = 01
	}
	else if (W.IsA('Translocator') && !W.IsA('ST_Translocator'))
	{
		if (WeaponSettings.bReplaceTranslocator)
			WStr = "ST_Translocator";
		BitMap = (1 << 2);				// TLoc = 02
	}
	else if ((W.IsA('enforcer') && !W.IsA('ST_enforcer')) || W.IsA('AutoMag'))
	{
		if (WeaponSettings.bReplaceEnforcer)
			WStr = "ST_enforcer";
		BitMap = (1 << 3);				// Enforcer = 03
	}
	else if ((W.IsA('ut_biorifle') && !W.IsA('ST_ut_biorifle')) || W.IsA('GesBioRifle'))
	{
		if (WeaponSettings.bReplaceBioRifle)
			WStr = "ST_ut_biorifle";
		BitMap = (1 << 4);				// BioRifle = 04
	}
	else if ((W.IsA('ShockRifle') && !W.IsA('SuperShockRifle') && !W.IsA('ST_ShockRifle')) || W.IsA('ASMD'))
	{
		if (WeaponSettings.bReplaceShockRifle)
			WStr = "ST_ShockRifle";
		BitMap = (1 << 5) | (1 << 6) | (1 << 7);	// Shock Rifle = 05, 06, 07
	}
	else if (W.IsA('SuperShockRifle') && !W.IsA('ST_SuperShockRifle') && !W.IsA('NN_SuperShockRifle'))
	{
		if (WeaponSettings.bReplaceSuperShockRifle)
			WStr = "ST_SuperShockRifle";
		BitMap = (1 << 8);				// Super Shock = 08
	}
	else if ((W.IsA('PulseGun') && !W.IsA('ST_PulseGun')) || W.IsA('Stinger'))
	{
		if (WeaponSettings.bReplacePulseGun)
			WStr = "ST_PulseGun";
		BitMap = (1 << 9) | (1 << 10);			// Pulse Gun = 09, 10
	}
	else if ((W.IsA('ripper') && !W.IsA('ST_ripper')) || W.IsA('Razorjack'))
	{
		if (WeaponSettings.bReplaceRipper)
			WStr = "ST_ripper";
		BitMap = (1 << 11) | (1 << 12);			// Ripper = 11, 12
	}
	else if ((W.IsA('minigun2') && !W.IsA('ST_minigun2')) || W.IsA('Minigun'))
	{
		if (WeaponSettings.bReplaceMinigun)
			WStr = "ST_minigun2";
		BitMap = (1 << 13);				// Minigun2 = 13
	}
	else if ((W.IsA('UT_FlakCannon') && !W.IsA('ST_UT_FlakCannon')) || W.IsA('FlakCannon'))
	{
		if (WeaponSettings.bReplaceFlakCannon)
			WStr = "ST_UT_FlakCannon";
		BitMap = (1 << 14) | (1 << 15);			// Flak Cannon = 14, 15
	}
	else if ((W.IsA('UT_Eightball') && !W.IsA('ST_UT_Eightball')) || W.IsA('Eightball'))
	{
		if (WeaponSettings.bReplaceRocketLauncher)
			WStr = "ST_UT_Eightball";
		BitMap = (1 << 16) | (1 << 17);			// Rocket Launcher = 16, 17
	}
	else if ((W.IsA('SniperRifle') && !W.IsA('ST_SniperRifle') && !W.IsA('NN_SniperRifle')) || W.IsA('Rifle'))
	{
		if (WeaponSettings.bReplaceSniperRifle)
			WStr = "ST_SniperRifle";
		BitMap = (1 << 18);				// Sniper = 18
	}
	else if (W.IsA('WarheadLauncher') && !W.IsA('ST_WarheadLauncher'))
	{
		if (WeaponSettings.bReplaceWarheadLauncher)
			WStr = "ST_WarheadLauncher";
		BitMap = (1 << 19);				// Redeemer = 19
	}

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
// ARFm, THIS DOESNT WORK IF A WEAPON IS REPLACED MULTIPLE TIMES >:|
//function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
function ReplaceWeapons()
{
	local string NewClassName;
	local Weapon W;
	local Arena ArenaMutator;
	local NewNetArena PA;
	local int i;

	WeaponDisplay = 1;		// Always show Other/Special

	W = Spawn(Level.Game.BaseMutator.MutatedDefaultWeapon());
	GetReplacementWeapon(W, False);		// This adds the default weapon to DisplayList
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
			if (W.Location != VecNull && (W.Owner == none || !W.Owner.IsA('ScriptedPawn')))
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

// Gives a better weapon to a player (from DeathMatchPlus)
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
{	// Change "bad" weapons that have already come into players inventory somehow (like respawn weapons, and LastManLaming)
	local Weapon W, Best;
	local Inventory Inv;
	local string NewName[32];
	local Weapon OldWeap[32];
	local class<Ammo> AmmoCls[32];
	local Ammo AmmoTyp[32];
	local int NewCount, x;
	local name n;
	local UTPure UTP;
	local byte Current, Highest;

	if (Other.Weapon != None)
		n = Other.Weapon.Class.Name;
	else if (Other.PendingWeapon != None)
		n = Other.PendingWeapon.Class.Name;
	Other.Weapon = None;
	Other.PendingWeapon = None;

	for (Inv = Other.Inventory; Inv != None; Inv = Inv.Inventory)
	{	// Make list of original inventory
		W = Weapon(Inv);
		if (W != None)
		{
			NewName[NewCount] = GetReplacementWeapon(W, False);
			if (NewName[NewCount] != "")
			{
				NewName[NewCount] = PreFix$NewName[NewCount];
				OldWeap[NewCount] = W;
				AmmoCls[NewCount] = W.AmmoName;
				AmmoTyp[NewCount] = W.AmmoType;
				NewCount++;
			}
		}
	}

	for (x = NewCount -1; x >= 0; x--)
	{	// Now replace
		if (AmmoTyp[x] == none)
			AmmoTyp[x] = Ammo(Other.FindInventoryType(AmmoCls[x]));
		if (AmmoTyp[x] != none)
			AmmoTyp[x].UseAmmo(OldWeap[x].PickupAmmoCount);

		GiveGoodWeapon(Other, NewName[x], OldWeap[x]);
		OldWeap[x].GotoState('');
		Other.DeleteInventory(OldWeap[x]);
	}

	if (bTranslocatorGame)
	{	// EPIC adds Translocator *AFTER* ModifyPlayer! NUMBNUTS! This adds the translocator first to avoid issues. DMP.bUseTranslocator is forced false :/
		GiveGoodWeapon(Other, PreFix$"ST_Translocator", None);
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
	local ST_PureStats STW;
	local bool bFound;

	STW = GetStats(Other);
	if (STW == None)
	{	// Don't add stats if not bbPlayer or ST_HumanBotPlus
		if (Other.IsA('bbPlayer'))
		{
			ForEach AllActors(Class'ST_PureStats', STW)
			{
				if (STW.PlayerName ~= Other.PlayerReplicationInfo.PlayerName)
				{
					STW.SetOwner(Other);
					bFound = True;
					break;
				}
			}
			if (!bFound)
			{
				STW = Spawn(Class'ST_PureStats', Other);
				STW.PlayerName = Other.PlayerReplicationInfo.PlayerName;
			}
			bbPlayer(Other).AttachStats(STW, Self);
			bbPlayer(Other).ClientMessage(WelcomeMessage);
		}
		else if (Other.IsA('ST_HumanBotPlus'))
		{
			STW = Spawn(Class'ST_PureStats', Other);
			ST_HumanBotPlus(Other).AttachStats(STW, Self);
		}
	}
	if (STW != None)
		STW.WeaponDisplay = WeaponDisplay;

	Super.ModifyPlayer(Other);

	SwitchWeaponsInventory(Other);
}

// Handles Clearing (Start of game) and Flushing (Save on client) of stats.
function ClearStats()
{
	local ST_PureStats STW;

	ForEach AllActors(Class'ST_PureStats', STW)
	{
		STW.ClearStats();
	}
}

function FlushStats()
{
	local ST_PureStats STW;

	ForEach AllActors(Class'ST_PureStats', STW)
	{
		if (STW.Owner != None && STW.Owner.IsA('bbPlayer'))	// ONLY SAVE FOR PLAYERS :P
		{
			STW.NetPriority = 10.0;				// Increase priority bigtime.
			STW.bLastData = True;
			STW.bReplicateStats = True;			// Force replication.
			STW.SaveStats();
		}
	}
}

function bool AlwaysKeep(Actor Other)
{
    if (Level.Game.IsA('NewNetSDOM') && (Other.IsA('NN_Armor2') || Other.IsA('NN_ThighPads')))
        return true;

    return Super.AlwaysKeep(Other);
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
    if (Level.Game.IsA('NewNetSDOM'))
	{
		if ( Other.IsA('Armor2') || Other.IsA('Armor') )
		{
			ReplaceWith( Other, PreFix$"NN_Armor2" );
			return false;
		} else if ( Other.IsA('ThighPads') || Other.IsA('KevlarSuit') )
		{
			ReplaceWith( Other, PreFix$"NN_ThighPads" );
			return false;
		}
	}
    return true;
}

function Tick(float deltaTime)
{	// Make sure stats get cleaned when match starts, and make sure client saves it when match ends.
	DMP.bUseTranslocator = bTranslocatorGame;	// Man what a hack I had to do to fix this translocator dealio :((

	if (!bStarted)
	{
		if (!bFixedWeapons)
		{
			ReplaceWeapons();
			bFixedWeapons = True;
		}
		if (DMP.bRequireReady && DMP.CountDown > 0)
			return;
		ClearStats();
		bStarted = True;
	}

	if (!bEnded)
	{
		if (!DMP.bGameEnded && Level.NextURL == "")
			return;
		FlushStats();
		bEnded = True;
	}
}

function InitializeSettings() {
	class'WeaponSettingsRepl'.static.CreateWeaponSettings(Level, "WeaponSettingsOldNet", WeaponSettings, WSettingsRepl);
}

function PreBeginPlay()
{
	local string SelfName;

	DMP = DeathMatchPlus(Level.Game);
	DMP.BotConfigType = Class'ST_ChallengeBotInfo';		// Make sure game uses our übersuperior bots.
	if (DMP.BotConfig != None)
	{	// Replace if already exists.
		DMP.BotConfig.Destroy();
		DMP.BotConfig = Spawn(DMP.BotConfigType);
	}
	bTranslocatorGame = DMP.bUseTranslocator;

	SelfName = string(self.Class);
	PreFix = Left(SelfName, InStr(SelfName, ".") + 1);
	Log("ST_Mutator determined prefix="$PreFix, 'IGPlus');
 	Level.Game.RegisterMessageMutator(Self);

	Class'bbCHSpectator'.Default.cStat = Class'ST_PureStatsSpec';
	HitTestHelper = Spawn(class'ST_HitTestHelper');
	CollChecker = Spawn(class'ST_HitTestHelper');
	CollChecker.bCollideWorld = false;
	CollChecker.SetCollision(true, false, false);

	InitializeSettings();

	Super.PreBeginPlay();
}

function Mutate(string MutateString, PlayerPawn Sender)
{
	if (MutateString ~= "PurePlayerHelp")
	{
		Sender.ClientMessage("UTPure Stats Extended commands:");
		Sender.ClientMessage("- ShowStats x (0 = Current Game, 1 = Current Month, 2 = All Time, Default = 0)");
		Sender.ClientMessage("- NoRevert x (0 = Off, 1 = On, Default = 0)");
	}
	else if (MutateString ~= "CheatInfo")
	{
		Sender.ClientMessage(WelcomeMessage);
	}
	if ( NextMutator != None )
		NextMutator.Mutate(MutateString, Sender);
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
		return true;
	}
	return false;
}

final function EnhancedHurtRadius(
	Actor  Source,
	float  DamageAmount,
	float  DamageRadius,
	name   DamageName,
	float  Momentum,
	vector HitLocation,
	optional bool bIsRazor2Alt
) {
	local actor Victim;
	local float damageScale, dist;
	local float DamageDiffraction;
	local float MomentumScale;
	local vector MomentumDelta, MomentumDir;
	local vector Delta, DeltaXY;
	local vector Closest;
	local vector dir;

	local vector SourceGeoLocation, SourceGeoNormal;
	local vector VictimGeoLocation, VictimGeoNormal;

	if (Source.bHurtEntry)
		return;

	Source.bHurtEntry = true;

	if (CollChecker == none || CollChecker.bDeleteMe) {
		CollChecker = Spawn(class'ST_HitTestHelper',self, , Source.Location);
		CollChecker.bCollideWorld = false;
	}

	CollChecker.SetCollision(true, false, false);
	CollChecker.SetCollisionSize(DamageRadius, DamageRadius);
	CollChecker.SetLocation(HitLocation);

	foreach CollChecker.TouchingActors(class'Actor', Victim) {
		if (Victim == self)
			continue;

		Delta = Victim.Location - HitLocation;
		DeltaXY = Delta * vect(1.0, 1.0, 0.0);
		dist = VSize(Delta);
		dir = Normal(Delta);

		if (Abs(Delta.Z) <= Victim.CollisionHeight) {
			Closest = HitLocation + Normal(DeltaXY) * (VSize(DeltaXY) - Victim.CollisionRadius);
		} else if (VSize(DeltaXY) <= Victim.CollisionRadius) {
			if (Delta.Z > 0.0)
				Closest = HitLocation + FMax(Delta.Z - Victim.CollisionHeight, 0.0) * vect(0.0, 0.0, 1.0);
			else
				Closest = HitLocation + FMin(Delta.Z + Victim.CollisionHeight, 0.0) * vect(0.0, 0.0, 1.0);
		} else {
			// Closest point must be on the cylinder rims, find out where
			Closest = Victim.Location + dir * (Source.CollisionRadius / VSize(dir * vect(1.0, 1.0, 0.0)));
			if (Delta.Z > 0.0)
				Closest.Z = Victim.Location.Z - Victim.CollisionHeight;
			else
				Closest.Z = Victim.Location.Z + Victim.CollisionHeight;
		}

		Delta = Closest - HitLocation;
		if (VSize(Delta) > CollChecker.CollisionRadius)
			continue;

		dist = VSize(Delta);
		dir = Normal(Delta);

		if (FastTrace(Victim.Location, Source.Location) == false) {
			if (Victim.IsA('Pawn') == false)
				continue;

			// give Pawns a second chance to be hit
			if (HitTestHelper == none || HitTestHelper.bDeleteMe)
				HitTestHelper = Spawn(class'ST_HitTestHelper', self, , Source.Location);
			else
				HitTestHelper.SetLocation(Source.Location);

			HitTestHelper.FlyTowards(Victim.Location, DamageRadius);
			if (FastTrace(Victim.Location, HitTestHelper.Location) == false)
				continue;

			Trace(SourceGeoLocation, SourceGeoNormal, Closest, HitLocation, false);
			Trace(VictimGeoLocation, VictimGeoNormal, HitLocation, Closest, false);

			DamageDiffraction =
				FClamp(WeaponSettings.SplashMaxDiffraction, 0.0, 1.0) *
				FClamp((VSize(VictimGeoLocation - SourceGeoLocation) - WeaponSettings.SplashMinDiffractionDistance) / dist, 0.0, 1.0);
		}

		MomentumDelta = Victim.Location - HitLocation;
		MomentumDir = Normal(MomentumDelta);

		if (bIsRazor2Alt)
			MomentumDir.Z = FMin(0.45, MomentumDir.Z);

		damageScale = FMin(1.0 - dist/DamageRadius, 1.0); // apply upper bound to damage
		damageScale *= (1.0 - DamageDiffraction);
		MomentumScale = FClamp(1.0 - (VSize(MomentumDelta) - Victim.CollisionRadius)/DamageRadius, 0.0, 1.0);
		MomentumScale *= (1.0 - DamageDiffraction);

		if (damageScale <= 0.0)
			continue;

		Victim.TakeDamage(
			damageScale * DamageAmount,
			Source.Instigator,
			Victim.Location - 0.5 * (Victim.CollisionRadius + Victim.CollisionHeight) * dir,
			(MomentumScale * Momentum * MomentumDir),
			DamageName
		);
	}

	CollChecker.SetCollision(false, false, false);

	Source.bHurtEntry = false;
}

defaultproperties {
	DefaultWeapon=Class'ST_ImpactHammer'
	ST_Log=PureStats
	WelcomeMessage="This server is using Pure Stats! Type 'showstats' into console to view!"
}
