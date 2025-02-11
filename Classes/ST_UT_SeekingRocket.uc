// ===============================================================
// Stats.ST_UT_SeekingRocket: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_UT_SeekingRocket extends UT_SeekingRocket;

var IGPlus_WeaponImplementation WImp;

auto state Flying
{
	function HitWall (vector HitNormal, actor Wall)
	{
		if ( (Mover(Wall) != None) && Mover(Wall).bDamageTriggered )
			Wall.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), '');

		Explode(Location + ExploWallOut * HitNormal, HitNormal);

		class'WeaponEffect'.static.Send(
			Level,
			class'ST_RocketBlastDecal',
			Instigator.PlayerReplicationInfo,
			vect(0,0,0),
			vect(0,0,0),
			none,
			Location,
			vect(0,0,0),
			HitNormal
		);
	}

	function Explode(vector HitLocation, vector HitNormal)
	{
		Spawn(class'UT_SpriteBallExplosion',,,HitLocation + HitNormal*16);	

		BlowUp(HitLocation);

 		Destroy();
	}

	function BlowUp(vector HitLocation)
	{
		if (WImp.WeaponSettings.bEnableEnhancedSplashRockets) {
			WImp.EnhancedHurtRadius(
				self,
				WImp.WeaponSettings.RocketDamage,
				WImp.WeaponSettings.RocketHurtRadius,
				MyDamageType,
				WImp.WeaponSettings.RocketMomentum * MomentumTransfer,
				HitLocation);
		} else {
			HurtRadius(
				WImp.WeaponSettings.RocketDamage,
				WImp.WeaponSettings.RocketHurtRadius,
				MyDamageType,
				WImp.WeaponSettings.RocketMomentum * MomentumTransfer,
				HitLocation);
		}

		MakeNoise(1.0);
	}
}

defaultproperties {
	bNetTemporary=False
}
