// ============================================================
// UTPureRC5w.PureInfo: put your comment here

// Created by UClasses - (C) 2000 by meltdown@thirdtower.com
// ============================================================

class PureInfo extends Info;

var float zzLastTick;
var int zzTickOff;
var int zzPlayerCalcViewCalls;

struct xxWeaponShakeFix {
	var class<Weapon> zzWeaponClass;
	var float zzShakeMag,zzShakeTime,zzShakeVert;
	var float zzMuzzleFlashScale;
	var Mesh zzMuzzleFlashMesh;
};

var private xxWeaponShakeFix WeaponFixes[10];

event Tick(float zzdelta)
{
	if (zzdelta <= 0.0)
		return;
	zzLastTick += zzdelta;
	zzTickOff--;
	zzPlayerCalcViewCalls = 1;
}

function xxInstallSpawnNotify(PlayerPawn zzPP)
{
	local PureSN zzPSN;
	local SpawnNotify zzSN,zzSNLast;

	for (zzSN = zzPP.Level.SpawnNotify; zzSN != None; zzSN = zzSN.Next)
	{
		if (zzSN.IsA('PureSN'))
		{
			if (zzSN.Next != None && bbPlayer(zzPP) != None)
				bbPlayer(zzPP).xxServerCheater("S1");
			return;
		}
		zzSNLast = zzSN;
	}

	zzSN = zzPP.Level.SpawnNotify;
	Level.SpawnNotify = None;
	zzPSN = zzPP.Level.Spawn(Class'PureSN',zzPP);
	zzPSN.Next = None;
	if (zzSNLast == None)
		zzPP.Level.SpawnNotify = zzPSN;
	else
	{
		zzSNLast.Next = zzPSN;
		zzPP.Level.SpawnNotify = zzSN;
	}
}

function xxStartupCheck(PlayerPawn zzPP)
{
	local actor zzA;

	ForEach zzPP.Level.AllActors(Class'Actor',zzA)
	{
		xxSetClassDefault(zzA.Class);
		xxSetClass(zzA);
	}
	ForEach zzPP.GetEntryLevel().AllActors(Class'Actor',zzA)
	{
		xxSetClassDefault(zzA.Class);
		xxSetClass(zzA);
	}
}

static function xxSetClassDefault(Class<Actor> zzA)
{
	local int zzx;
	local Class<Weapon> zzcW;

	if (ClassIsChildOf(zzA,Class'Weapon'))
	{
		zzcW = Class<Weapon>(zzA);
		zzcW.Default.bUnlit = False;
		for (zzx = 0; zzx < 10; zzx++)
		{
			if (ClassIsChildOf(zzcW,Default.WeaponFixes[zzx].zzWeaponClass))
			{
				zzcW.Default.ShakeMag = Default.WeaponFixes[zzx].zzShakeMag;
				zzcW.Default.ShakeTime = Default.WeaponFixes[zzx].zzShakeTime;
				zzcW.Default.ShakeVert = Default.WeaponFixes[zzx].zzShakeVert;
				zzcW.Default.MuzzleFlashScale = Default.WeaponFixes[zzx].zzMuzzleFlashScale;
				zzcW.Default.MuzzleFlashMesh = Default.WeaponFixes[zzx].zzMuzzleFlashMesh;
			}
		}
	}
}

static function xxSetClass(Actor zzA)
{
	local int zzx;
	local Weapon zzW;
	if (ClassIsChildOf(zzA.Class,Class'Weapon'))
	{
		zzW = Weapon(zzA);
		zzW.bUnlit = False;
		for (zzx = 0; zzx < 10; zzx++)
		{
			if (ClassIsChildOf(zzW.Class,Default.WeaponFixes[zzx].zzWeaponClass))
			{
				zzW.ShakeMag = Default.WeaponFixes[zzx].zzShakeMag;
				zzW.ShakeTime = Default.WeaponFixes[zzx].zzShakeTime;
				zzW.ShakeVert = Default.WeaponFixes[zzx].zzShakeVert;
				zzW.MuzzleFlashScale = Default.WeaponFixes[zzx].zzMuzzleFlashScale;
				zzW.MuzzleFlashMesh = Default.WeaponFixes[zzx].zzMuzzleFlashMesh;
			}
		}
	}
}

defaultproperties
{
     WeaponFixes(0)=(zzWeaponClass=Class'Botpack.minigun2',zzShakeMag=135.000000,zzShakeTime=0.100000,zzShakeVert=8.000000,zzMuzzleFlashScale=0.250000,zzMuzzleFlashMesh=LodMesh'Botpack.MuzzFlash3')
     WeaponFixes(1)=(zzWeaponClass=Class'Botpack.enforcer',zzShakeMag=200.000000,zzShakeTime=0.100000,zzShakeVert=4.000000,zzMuzzleFlashScale=0.080000,zzMuzzleFlashMesh=LodMesh'Botpack.muzzEF3')
     WeaponFixes(2)=(zzWeaponClass=Class'Botpack.PulseGun',zzShakeMag=135.000000,zzShakeTime=0.100000,zzShakeVert=8.000000,zzMuzzleFlashScale=0.400000,zzMuzzleFlashMesh=LodMesh'Botpack.muzzPF3')
     WeaponFixes(3)=(zzWeaponClass=Class'Botpack.ripper',zzShakeMag=120.000000,zzShakeTime=0.100000,zzShakeVert=5.000000)
     WeaponFixes(4)=(zzWeaponClass=Class'Botpack.ShockRifle',zzShakeMag=300.000000,zzShakeTime=0.100000,zzShakeVert=5.000000)
     WeaponFixes(5)=(zzWeaponClass=Class'Botpack.SniperRifle',zzShakeMag=500.000000,zzShakeTime=0.150000,zzShakeVert=8.000000,zzMuzzleFlashScale=0.100000,zzMuzzleFlashMesh=LodMesh'Botpack.muzzsr3')
     WeaponFixes(6)=(zzWeaponClass=Class'Botpack.ut_biorifle',zzShakeMag=300.000000,zzShakeTime=0.100000,zzShakeVert=5.000000)
     WeaponFixes(7)=(zzWeaponClass=Class'Botpack.UT_Eightball',zzShakeMag=350.000000,zzShakeTime=0.200000,zzShakeVert=7.500000)
     WeaponFixes(8)=(zzWeaponClass=Class'Botpack.UT_FlakCannon',zzShakeMag=350.000000,zzShakeTime=0.150000,zzShakeVert=8.500000,zzMuzzleFlashScale=0.400000,zzMuzzleFlashMesh=LodMesh'Botpack.muzzFF3')
     WeaponFixes(9)=(zzWeaponClass=Class'Botpack.ImpactHammer',zzShakeMag=300.000000,zzShakeTime=0.100000,zzShakeVert=5.000000)
}
