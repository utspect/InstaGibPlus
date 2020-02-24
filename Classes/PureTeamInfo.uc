// ===============================================================
// UTPureRC7A.PureTeamInfo: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class PureTeamInfo extends TeamInfo;

// Pure Enhanced Team Info

struct sPlayerData
{
	var PlayerReplicationInfo PRI;	// Owner.
	var byte Health;		// Health (0-199)
	var class<Weapon> cWeapon;	// Weapon
	var byte AmmoLeft;		// And ammo to weapon. (0-250)
	var byte Armor, Pads, Shield;	// Has if >0
	var byte Other;			// Bitmapped, 1 = Boots, 2 = Amp, 4 = Invis
};

var sPlayerData zzPlayerData[32];

replication
{
	reliable if (ROLE == ROLE_Authority)
		zzPlayerData;
}

function PostBeginPlay()
{
	SetTimer(Level.TimeDilation, True);	// Update every once pr second.
}

function Timer()
{
	local Pawn P;
	local int num, ammo, armor, pads, shield;
	local PlayerReplicationInfo PRI;
	local Inventory Inv;
	local byte Other;

	for (P = Level.PawnList; P != None; P = P.NextPawn)
	{
		PRI = P.PlayerReplicationInfo;
		if (PRI == None || PRI.bIsSpectator || PRI.Team > 3)
			continue;
		zzPlayerData[num].PRI = PRI;
		zzPlayerData[num].Health = Clamp(P.Health, 0, 199);
		ammo = 0;
		if (P.Weapon != None)
		{
			zzPlayerData[num].cWeapon = P.Weapon.Class;
			if (P.Weapon.AmmoType != None)
				ammo = P.Weapon.AmmoType.AmmoAmount;
		}
		else
			zzPlayerData[num].cWeapon = None;
		zzPlayerData[num].AmmoLeft = Min(250, ammo);
		armor = 0;
		pads = 0;
		shield = 0;
		Other = 0;
		for (Inv = P.Inventory; Inv != None; Inv = Inv.Inventory)
		{
			if (Inv.IsA('Armor2'))
				armor = Inv.Charge;
			else if (Inv.IsA('ThighPads'))
				pads = Inv.Charge;
			else if (Inv.IsA('UT_ShieldBelt'))
				shield = Inv.Charge;
			else if (Inv.IsA('UT_JumpBoots'))
				Other = Other | 1;
			else if (Inv.IsA('UDamage'))
				Other = Other | 2;
			else if (Inv.IsA('UT_Invisibility'))
				Other = Other | 4;
		}
		zzPlayerData[num].Armor = armor;
		zzPlayerData[num].Pads = pads;
		zzPlayerData[num].Shield = shield;
		zzPlayerData[num].Other = Other;
		num++;
		if (num == 32)
			break;
	}

	while (num < 32)
	{
		zzPlayerData[num++].PRI = None;
	}
}

simulated function xxGetData(int Index, PlayerReplicationInfo AskingPRI,
					out PlayerReplicationInfo PRI, out int Health, out class<Weapon> cWeapon,
					out int Ammo, out int Armor, out int Pads, out int Shield,
					out int Other)
{
	PRI = zzPlayerData[Index].PRI;
	if (PRI == None || PRI == AskingPRI || AskingPRI.Team != zzPlayerData[Index].PRI.Team)
	{	// If not existing, your self, or wrong team ignore.
		PRI = None;
		return;
	}
	
	PRI = zzPlayerData[Index].PRI;
	Health = zzPlayerData[Index].Health;
	cWeapon = zzPlayerData[Index].cWeapon;
	Ammo = zzPlayerData[Index].AmmoLeft;
	Armor = zzPlayerData[Index].Armor;
	Pads = zzPlayerData[Index].Pads;
	Shield = zzPlayerData[Index].Shield;
	Other = zzPlayerData[Index].Other;
}

defaultproperties
{
}
