// ===============================================================
// Stats.ST_ShockProj: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_ShockProj extends ShockProj;

var ST_Mutator STM;

// For Standstill combo Special
var vector StartLocation;

simulated function PostBeginPlay()
{
	if (ROLE == ROLE_Authority)
	{
		StartLocation = Instigator.Location;
		ForEach AllActors(Class'ST_Mutator', STM)
			break;		// Find master :D
	}

	Super.PostBeginPlay();
}

function SuperExplosion()	// aka, combo.
{
	if (STM.WeaponSettings.bEnableEnhancedSplashCombo) {
		STM.EnhancedHurtRadius(
			self,
			STM.WeaponSettings.ShockComboDamage,
			STM.WeaponSettings.ShockComboHurtRadius,
			MyDamageType,
			STM.WeaponSettings.ShockComboMomentum * MomentumTransfer * 2,
			Location);
	} else {
		HurtRadius(
			STM.WeaponSettings.ShockComboDamage,
			STM.WeaponSettings.ShockComboHurtRadius,
			MyDamageType,
			STM.WeaponSettings.ShockComboMomentum * MomentumTransfer * 2,
			Location);
	}
	
	Spawn(Class'ut_ComboRing',,'',Location, Instigator.ViewRotation);
	PlaySound(ExploSound,,20.0,,2000,0.6);	
	
	Destroy(); 
}

function Explode(vector HitLocation,vector HitNormal)
{
	PlaySound(ImpactSound, SLOT_Misc, 0.5,,, 0.5+FRand());
	if (STM.WeaponSettings.bEnableEnhancedSplash) {
		STM.EnhancedHurtRadius(
			self,
			STM.WeaponSettings.ShockProjectileDamage,
			STM.WeaponSettings.ShockProjectileHurtRadius,
			MyDamageType,
			STM.WeaponSettings.ShockProjectileMomentum * MomentumTransfer,
			Location);
	} else {
		HurtRadius(
			STM.WeaponSettings.ShockProjectileDamage,
			STM.WeaponSettings.ShockProjectileHurtRadius,
			MyDamageType,
			STM.WeaponSettings.ShockProjectileMomentum * MomentumTransfer,
			Location);
	}
	if (STM.WeaponSettings.ShockProjectileDamage > 60)
		Spawn(class'ut_RingExplosion3',,, HitLocation+HitNormal*8,rotator(HitNormal));
	else
		Spawn(class'ut_RingExplosion',,, HitLocation+HitNormal*8,rotator(Velocity));		

	Destroy();
}

defaultproperties {
}
