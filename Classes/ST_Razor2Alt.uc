// ===============================================================
// UTPureStats7A.ST_Razor2Alt: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_Razor2Alt extends Razor2Alt;

var ST_Mutator STM;

simulated function PostBeginPlay()
{
	if (ROLE == ROLE_Authority)
	{
		ForEach AllActors(Class'ST_Mutator', STM)
			break;		// Find master :D
		STM.PlayerFire(Instigator, 12);		// 12 = Ripper Secondary
	}

	Super.PostBeginPlay();
}

auto state Flying
{
	function ProcessTouch (Actor Other, Vector HitLocation)
	{
		if ( Other != Instigator ) 
		{
			STM.PlayerHit(Instigator, 12, Other.IsA('Pawn'));	// 12 = Ripper Secondary, Direct if Pawn
			Other.TakeDamage(
				STM.WeaponSettings.RipperSecondaryDamage,
				instigator,
				HitLocation,
				STM.WeaponSettings.RipperSecondaryMomentum * MomentumTransfer * Normal(Velocity),
				MyDamageType
			);
			STM.PlayerClear();
			Spawn(class'RipperPulse',,,HitLocation);
			MakeNoise(1.0);
 			Destroy();
		}
	}

	function Explode(vector HitLocation, vector HitNormal)
	{
		Spawn(class'RipperPulse',,,HitLocation + HitNormal*16);

		BlowUp(HitLocation);

 		Destroy();
	}

	function BlowUp(vector HitLocation)
	{
		local actor Victims;
		local float damageScale, dist;
		local vector dir;

		if (STM.WeaponSettings.bEnableEnhancedSplash) {
			STM.PlayerHit(Instigator, 12, False);		// 12 = Ripper Secondary
			STM.EnhancedHurtRadius(
				self,
				STM.WeaponSettings.RipperSecondaryDamage,
				STM.WeaponSettings.RipperSecondaryHurtRadius,
				MyDamageType,
				STM.WeaponSettings.RipperSecondaryMomentum * MomentumTransfer,
				HitLocation,
				True); // special case for Razor2Alt
			STM.PlayerClear();
		} else {
			if( bHurtEntry )
				return;

			bHurtEntry = true;
			foreach VisibleCollidingActors( class 'Actor', Victims, STM.WeaponSettings.RipperSecondaryHurtRadius, HitLocation )
			{
				if( Victims != self )
				{
					dir = Victims.Location - HitLocation;
					dist = FMax(1,VSize(dir));
					dir = dir/dist;
					dir.Z = FMin(0.45, dir.Z); 
					damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/STM.WeaponSettings.RipperSecondaryHurtRadius);
					STM.PlayerHit(Instigator, 12, False);		// 12 = Ripper Secondary
					Victims.TakeDamage (
						damageScale * STM.WeaponSettings.RipperSecondaryDamage,
						Instigator, 
						Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
						STM.WeaponSettings.RipperSecondaryMomentum * damageScale * MomentumTransfer * dir,
						MyDamageType
					);
					STM.PlayerClear();
				} 
			}
			bHurtEntry = false;
		}
		MakeNoise(1.0);
	}
}


defaultproperties {
	bNetTemporary=False
}
