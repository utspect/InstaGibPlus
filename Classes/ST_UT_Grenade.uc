// ===============================================================
// Stats.ST_UT_Grenade: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_UT_Grenade extends UT_Grenade;

var ST_Mutator STM;

function Explosion(vector HitLocation)
{
	BlowUp(HitLocation);
	Spawn(class'UT_SpriteBallExplosion',,,HitLocation);
	class'WeaponEffect'.static.Send(
		Level,
		class'ST_RocketBlastDecal',
		Instigator.PlayerReplicationInfo,
		vect(0,0,0),
		vect(0,0,0),
		none,
		Location,
		vect(0,0,0),
		vect(0,0,1)
	);
 	Destroy();
}

function BlowUp(vector HitLocation)
{
	if (STM.WeaponSettings.bEnableEnhancedSplashRockets) {
		STM.EnhancedHurtRadius(
			self,
			STM.WeaponSettings.GrenadeDamage,
			STM.WeaponSettings.GrenadeHurtRadius,
			MyDamageType,
			STM.WeaponSettings.GrenadeMomentum * MomentumTransfer,
			HitLocation);
	} else {
		HurtRadius(
			STM.WeaponSettings.GrenadeDamage,
			STM.WeaponSettings.GrenadeHurtRadius,
			MyDamageType,
			STM.WeaponSettings.GrenadeMomentum * MomentumTransfer,
			HitLocation);
	}
	MakeNoise(1.0);
}

defaultproperties {
	bNetTemporary=False
}
