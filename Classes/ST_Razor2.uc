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
				if ( Other.bIsPawn && STM.CheckHeadshot(Pawn(Other), HitLocation, Normal(Velocity)) 
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
			
			if (Role == ROLE_Authority)
				Destroy();
		}
	}

	simulated function HitWall (vector HitNormal, actor Wall)
	{
		local vector Vel2D, Norm2D;

		bCanHitInstigator = true;
		PlaySound(ImpactSound, SLOT_Misc, 2.0);
		LoopAnim('Spin',1.0);
		if ( (Mover(Wall) != None) && Mover(Wall).bDamageTriggered )
		{
			if ( Role == ROLE_Authority ) {
				Wall.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
				Destroy();
			}
			return;
		}
		NumWallHits++;
		SetTimer(0, False);
		MakeNoise(0.3);
		if ( NumWallHits > 6 && Role == ROLE_Authority )
			Destroy();

		if ( NumWallHits == 1 ) 
		{
			Spawn(class'WallCrack',,,Location, rotator(HitNormal));
			Vel2D = Velocity;
			Vel2D.Z = 0;
			Norm2D = HitNormal;
			Norm2D.Z = 0;
			Norm2D = Normal(Norm2D);
			Vel2D = Normal(Vel2D);
			if ( (Vel2D Dot Norm2D) < -0.999 )
			{
				HitNormal = Normal(HitNormal + 0.6 * Vel2D);
				Norm2D = HitNormal;
				Norm2D.Z = 0;
				Norm2D = Normal(Norm2D);
				if ( (Vel2D Dot Norm2D) < -0.999 )
				{
					if ( Rand(1) == 0 )
						HitNormal = HitNormal + vect(0.05,0,0);
					else
						HitNormal = HitNormal - vect(0.05,0,0);
					if ( Rand(1) == 0 )
						HitNormal = HitNormal + vect(0,0.05,0);
					else
						HitNormal = HitNormal - vect(0,0.05,0);
					HitNormal = Normal(HitNormal);
				}
			}
		}
		Velocity -= 2 * (Velocity dot HitNormal) * HitNormal;  
		SetRoll(Velocity);
	}
}

defaultproperties {
	bNetTemporary=False
}
