// ===============================================================
// Stats.ST_RocketMk2: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_RocketMk2 extends RocketMk2;

var ST_Mutator STM;
var bool bDirect;

auto state Flying
{
	function ProcessTouch(Actor Other, Vector HitLocation)
	{
		if ( (Other != instigator) && !Other.IsA('Projectile') ) 
		{
			bDirect = Other.IsA('Pawn');
			Explode(HitLocation,Normal(HitLocation-Other.Location));
		}
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if ( (Mover(Wall) != None) && Mover(Wall).bDamageTriggered )
			Wall.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), '');

		MakeNoise(1.0);
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
		if (STM.WeaponSettings.bEnableEnhancedSplashRockets) {
			STM.EnhancedHurtRadius(
				self,
				STM.WeaponSettings.RocketDamage,
				STM.WeaponSettings.RocketHurtRadius,
				MyDamageType,
				STM.WeaponSettings.RocketMomentum * MomentumTransfer,
				HitLocation);
		} else {
			HurtRadius(
				STM.WeaponSettings.RocketDamage,
				STM.WeaponSettings.RocketHurtRadius,
				MyDamageType,
				STM.WeaponSettings.RocketMomentum * MomentumTransfer,
				HitLocation);
		}

		MakeNoise(1.0);
	}
}

defaultproperties {
	bNetTemporary=False
}
