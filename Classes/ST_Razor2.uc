// ===============================================================
// UTPureStats7A.ST_Razor2: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_Razor2 extends Razor2;

var ST_Mutator STM;

simulated function PostBeginPlay()
{
	if (ROLE == ROLE_Authority)
	{
		ForEach AllActors(Class'ST_Mutator', STM)
			break;		// Find master :D
		STM.PlayerFire(Instigator, 11);		// 11 = Ripper Primary
	}

	Super.PostBeginPlay();
}

auto state Flying
{
	simulated function ProcessTouch (Actor Other, Vector HitLocation)
	{
		if ( bCanHitInstigator || (Other != Instigator) ) 
		{
			if ( Role == ROLE_Authority )
			{
				if ( Other.bIsPawn && (HitLocation.Z - Other.Location.Z > 0.62 * Other.CollisionHeight) 
					&& (!Instigator.IsA('Bot') || !Bot(Instigator).bNovice) )
				{
					STM.PlayerHit(Instigator, 11, True);		// 11 = Ripper Primary Headshot
					Other.TakeDamage(
						STM.WeaponSettings.RipperHeadshotDamage,
						Instigator,
						HitLocation,
						STM.WeaponSettings.RipperHeadshotMomentum * MomentumTransfer * Normal(Velocity),
						'decapitated'
					);
					STM.PlayerClear();
				}
				else			 
				{
					STM.PlayerHit(Instigator, 11, False);		// 11 = Ripper Primary
					Other.TakeDamage(
						STM.WeaponSettings.RipperPrimaryDamage,
						instigator,
						HitLocation,
						STM.WeaponSettings.RipperPrimaryMomentum * MomentumTransfer * Normal(Velocity),
						'shredded'
					);
					STM.PlayerClear();
				}
			}
			if ( Other.bIsPawn )
				PlaySound(MiscSound, SLOT_Misc, 2.0);
			else
				PlaySound(ImpactSound, SLOT_Misc, 2.0);
			destroy();
		}
	}
}

defaultproperties {
}
