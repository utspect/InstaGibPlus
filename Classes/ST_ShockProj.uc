class ST_ShockProj extends ShockProj;

var ST_Mutator STM;

// For ShockProjectileTakeDamage
var float Health;

simulated function PostBeginPlay() {
	if (ROLE == ROLE_Authority) {
		ForEach AllActors(Class'ST_Mutator', STM)
			break; // Find master :D
	}
	if (STM.WeaponSettings.ShockProjectileTakeDamage) {
		Health = STM.WeaponSettings.ShockProjectileHealth;
	}
	Super.PostBeginPlay();
}

function SuperExplosion() {
	if (STM.WeaponSettings.bEnableEnhancedSplashShockCombo) {
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

function Explode(vector HitLocation,vector HitNormal) {
	PlaySound(ImpactSound, SLOT_Misc, 0.5,,, 0.5+FRand());
	if (STM.WeaponSettings.bEnableEnhancedSplashShockProjectile) {
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

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType) {
	if (STM.WeaponSettings.ShockProjectileTakeDamage == false)
		return;

	if (DamageType == 'Pulsed'|| DamageType == 'Corroded') {
		Health -= Damage;
		if (Health <= 0) {
			Spawn(class'ut_RingExplosion',,, Location + Momentum * 0.1, rotator(Momentum));
			Destroy();
		}
	}
}

defaultproperties {
}
