// ===============================================================
// UTPureStats7A.ST_PlasmaSphere: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_PlasmaSphere extends PlasmaSphere;

var ST_Mutator STM;

simulated function PostBeginPlay()
{
	if (ROLE == ROLE_Authority)
	{
		ForEach AllActors(Class'ST_Mutator', STM)
			break;
		STM.PlayerFire(Instigator, 9);			// 9 = Plasma Sphere
	}
	Super.PostBeginPlay();
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	If ( Other!=Instigator  && PlasmaSphere(Other)==None )
	{
		if ( Other.bIsPawn )
		{
			bHitPawn = true;
			bExploded = !Level.bHighDetailMode || Level.bDropDetail;
		}
		if ( Role == ROLE_Authority )
		{
			STM.PlayerHit(Instigator, 9, False);	// 9 = Plasma Sphere
			Other.TakeDamage(
				STM.WeaponSettings.PulseSphereDamage,
				instigator,
				HitLocation,
				STM.WeaponSettings.PulseSphereMomentum * MomentumTransfer * Vector(Rotation),
				MyDamageType);
			STM.PlayerClear();
		}
		Explode(HitLocation, vect(0,0,1));
	}
}


defaultproperties {
}
