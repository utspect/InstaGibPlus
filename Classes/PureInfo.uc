// ============================================================
// UTPureRC5w.PureInfo: put your comment here

// Created by UClasses - (C) 2000 by meltdown@thirdtower.com
// ============================================================

class PureInfo expands Info;

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
//			Log("ISN: Already In");
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
//	Log("ISN: Installed");
}

function xxStartupCheck(PlayerPawn zzPP)
{
	local actor zzA;

//	Log("Level.AllActors");
	ForEach zzPP.Level.AllActors(Class'Actor',zzA)
	{
		xxSetClassDefault(zzA.Class);
		xxSetClass(zzA);
	}
//	Log("EntryLevel.AllActors");
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

//	Log("SCD:"@zzA);
/* 
	if (ClassIsChildOf(zzA,Class'Pickup'))
	{
		zzA.default.bUnlit = False;
		zzA.Default.DrawScale = 1.0;
		if (ClassIsChildOf(zzA, Class'UDamage'))
			zzA.Default.Texture = Texture'Botpack.GoldSkin2';
	}
	else if (ClassIsChildOf(zzA,Class'Effects'))
	{
		zzA.default.bHidden = False;
		if (ClassIsChildOf(zzA, Class'UTSmokeTrail'))
			zzA.Default.DrawScale = 2.0;
		else if (ClassIsChildOf(zzA, Class'UTTeleportEffect'))
			zzA.Default.LightRadius = 9.0;
		else if (ClassIsChildOf(zzA, Class'ShockBeam') || ClassIsChildOf(zzA, Class'SuperShockBeam'))
		{
			zzA.Default.LifeSpan = 0.27;
			zzA.Default.DrawScale = 0.44;
		}
		else if (ClassIsChildOf(zzA, Class'UT_ComboRing'))
		{
			zzA.Default.Skin = Texture'Botpack.Effects.pPurpleRing';
			zzA.Default.DrawScale = 4.0;
		}	
		else if (ClassIsChildOf(zzA, Class'UT_ShieldBeltEffect'))
			zzA.Default.Texture = FireTexture'UnrealShare.Belt_fx.ShieldBelt.N_Shield';
		else if (ClassIsChildOf(zzA, Class'ChunkTrail'))
			zzA.Default.Texture = Texture'Botpack.FlakGlow.fglow_a00';
		else if (ClassIsChildOf(zzA, Class'RocketTrail'))
			zzA.Default.Texture = Texture'Botpack.JRFlare';
	} */
	if (ClassIsChildOf(zzA,Class'Weapon'))
	{
//		Log(zzA@"is a weapon");
		zzcW = Class<Weapon>(zzA);
		zzcW.Default.bUnlit = False;
		for (zzx = 0; zzx < 10; zzx++)
		{
			if (ClassIsChildOf(zzcW,Default.WeaponFixes[zzx].zzWeaponClass))
			{
//				log("dFixing"@zzcW@zzcW.Default.ShakeMag@zzcW.Default.ShakeTime@zzcW.Default.ShakeVert);
				zzcW.Default.ShakeMag = Default.WeaponFixes[zzx].zzShakeMag;
				zzcW.Default.ShakeTime = Default.WeaponFixes[zzx].zzShakeTime;
				zzcW.Default.ShakeVert = Default.WeaponFixes[zzx].zzShakeVert;
				zzcW.Default.MuzzleFlashScale = Default.WeaponFixes[zzx].zzMuzzleFlashScale;
				zzcW.Default.MuzzleFlashMesh = Default.WeaponFixes[zzx].zzMuzzleFlashMesh;
//				log("dPost Fixing"@zzcW@zzcW.Default.ShakeMag@zzcW.Default.ShakeTime@zzcW.Default.ShakeVert);
			}
		}
	}
/* 	else if (ClassIsChildOf(zzA,Class'Projectile'))
	{
		if (ClassIsChildOf(zzA,Class'RocketMk2'))
		{
			zzA.Default.DrawScale = 0.02;
			zzA.Default.Mesh = LodMesh'Botpack.UTRocket';
		}
		else if (ClassIsChildOf(zzA,Class'UTChunk'))
		{
			zzA.Default.bHidden = False;
			zzA.Default.Texture = Texture'Botpack.ChunkGlow.Chunk_a00';
		}
		else if (ClassIsChildOf(zzA,Class'ShockProj'))
		{
			zzA.Default.DrawScale = 0.4;
			zzA.Default.Texture = Texture'Botpack.ASMDAlt.ASMDAlt_a00';
		}
		else if (ClassIsChildOf(zzA,Class'PBolt'))
			zzA.Default.DrawScale = 1.0;
	}
	else if (ClassIsChildOf(zzA,Class'Carcass'))
	{
		zzA.default.bHidden = False;
	}
	else if (ClassIsChildOf(zzA, Class'CTFFlag'))
	{
		zzA.Default.bUnlit = False;
		zzA.Default.DrawScale = 0.6;
		zzA.Default.LightRadius = 6.0;
	}
	else if (ClassIsChildOf(zzA,Class'PlayerStart'))
	{
		zzA.default.bHidden = True;
	}
 */
}

static function xxSetClass(Actor zzA)
{
	local int zzx;
	local Weapon zzW;
/* 
//	Log("SC:"@zzA);
	if (ClassIsChildOf(zzA.Class,Class'Pickup'))
	{
		zzA.bUnlit = False;
		zzA.DrawScale = 1.0;
		if (ClassIsChildOf(zzA.Class, Class'UDamage'))
			zzA.Texture = Texture'Botpack.GoldSkin2';
	}
	else if (ClassIsChildOf(zzA.Class,Class'Effects'))
	{
		zzA.bHidden = False;
		if (ClassIsChildOf(zzA.Class, Class'UTSmokeTrail'))
			zzA.DrawScale = 2.0;
		else if (ClassIsChildOf(zzA.Class, Class'UTTeleportEffect'))
			zzA.LightRadius = 9.0;
		else if (ClassIsChildOf(zzA.Class, Class'ShockBeam') || ClassIsChildOf(zzA.Class, Class'SuperShockBeam'))
		{
			zzA.LifeSpan = 0.27;
			zzA.DrawScale = 0.44;
		}
		else if (ClassIsChildOf(zzA.Class, Class'UT_ComboRing'))
		{
			zzA.Skin = Texture'Botpack.Effects.pPurpleRing';
			zzA.DrawScale = 4.0;
		}
		else if (ClassIsChildOf(zzA.Class, Class'UT_ShieldBeltEffect'))
			zzA.Texture = FireTexture'UnrealShare.Belt_fx.ShieldBelt.N_Shield';
		else if (ClassIsChildOf(zzA.Class, Class'ChunkTrail'))
			zzA.Texture = Texture'Botpack.FlakGlow.fglow_a00';
		else if (ClassIsChildOf(zzA.Class, Class'RocketTrail'))
			zzA.Texture = Texture'Botpack.JRFlare';
	} */
	if (ClassIsChildOf(zzA.Class,Class'Weapon'))
	{
//		Log(zzA@"is a weapon");
		zzW = Weapon(zzA);
		zzW.bUnlit = False;
		for (zzx = 0; zzx < 10; zzx++)
		{
			if (ClassIsChildOf(zzW.Class,Default.WeaponFixes[zzx].zzWeaponClass))
			{
//				log("Fixing"@zzW.Class@zzW.ShakeMag@zzW.ShakeTime@zzW.ShakeVert);
				zzW.ShakeMag = Default.WeaponFixes[zzx].zzShakeMag;
				zzW.ShakeTime = Default.WeaponFixes[zzx].zzShakeTime;
				zzW.ShakeVert = Default.WeaponFixes[zzx].zzShakeVert;
				zzW.MuzzleFlashScale = Default.WeaponFixes[zzx].zzMuzzleFlashScale;
				zzW.MuzzleFlashMesh = Default.WeaponFixes[zzx].zzMuzzleFlashMesh;
//				log("Post Fixing"@zzW.Class@zzW.ShakeMag@zzW.ShakeTime@zzW.ShakeVert@zzW.MuzzleFlashScale@zzW.MuzzleFlashMesh);
/* 				if (zzx == 2)
				{	// Pulse
					zzW.FireSound = Sound'Botpack.PulseGun.PulseFire';
					zzW.AltFireSound = Sound'Botpack.PulseGun.PulseBolt';
				}
				else if (zzx == 0)
				{	// Minigun
					zzW.FireSound = Sound'Botpack.minigun2.M2RegFire';
					zzW.AltFireSound = Sound'Botpack.minigun2.M2AltFire';
					zzW.Misc1Sound = Sound'Botpack.minigun2.M2WindDown';
				} */
			}
		}
	}
/* 	else if (ClassIsChildOf(zzA.Class,Class'Projectile'))
	{
		if (ClassIsChildOf(zzA.Class,Class'RocketMk2'))
		{
			zzA.DrawScale = 0.02;
			zzA.Mesh = LodMesh'Botpack.UTRocket';
		}
		else if (ClassIsChildOf(zzA.Class,Class'UTChunk'))
		{
			zzA.bHidden = False;
			zzA.Texture = Texture'Botpack.ChunkGlow.Chunk_a00';
		}
		else if (ClassIsChildOf(zzA.Class,Class'ShockProj'))
		{
			zzA.DrawScale = 0.4;
			zzA.Texture = Texture'Botpack.ASMDAlt.ASMDAlt_a00';
		}
		else if (ClassIsChildOf(zzA.Class,Class'PBolt'))
			zzA.DrawScale = 1.0;
	}
	else if (ClassIsChildOf(zzA.Class,Class'Carcass'))
	{
		zzA.bHidden = False;
	}
	else if (ClassIsChildOf(zzA.Class,Class'CTFFlag'))
	{
		zzA.bUnlit = False;
		zzA.DrawScale = 0.6;
		zzA.LightRadius = 6.0;
	}
	else if (ClassIsChildOf(zzA.Class,Class'PlayerStart'))
	{
		zzA.bHidden = True;
	} */
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
