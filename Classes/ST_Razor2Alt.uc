class ST_Razor2Alt extends Razor2Alt;

var IGPlus_WeaponImplementation WImp;

simulated function PostBeginPlay()
{
	if (ROLE == ROLE_Authority)
	{
		ForEach AllActors(Class'IGPlus_WeaponImplementation', WImp)
			break;		// Find master :D
	}

	Super.PostBeginPlay();
}

auto state Flying
{
	function ProcessTouch (Actor Other, Vector HitLocation)
	{
		if ( Other != Instigator ) 
		{
			Other.TakeDamage(
				WImp.WeaponSettings.RipperSecondaryDamage,
				instigator,
				HitLocation,
				WImp.WeaponSettings.RipperSecondaryMomentum * MomentumTransfer * Normal(Velocity),
				MyDamageType
			);
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

		if (WImp.WeaponSettings.bEnableEnhancedSplashRipperSecondary) {
			WImp.EnhancedHurtRadius(
				self,
				WImp.WeaponSettings.RipperSecondaryDamage,
				WImp.WeaponSettings.RipperSecondaryHurtRadius,
				MyDamageType,
				WImp.WeaponSettings.RipperSecondaryMomentum * MomentumTransfer,
				HitLocation,
				True); // special case for Razor2Alt
		} else {
			if( bHurtEntry )
				return;

			bHurtEntry = true;
			foreach VisibleCollidingActors( class 'Actor', Victims, WImp.WeaponSettings.RipperSecondaryHurtRadius, HitLocation )
			{
				if( Victims != self )
				{
					dir = Victims.Location - HitLocation;
					dist = FMax(1,VSize(dir));
					dir = dir/dist;
					dir.Z = FMin(0.45, dir.Z); 
					damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/WImp.WeaponSettings.RipperSecondaryHurtRadius);
					Victims.TakeDamage (
						damageScale * WImp.WeaponSettings.RipperSecondaryDamage,
						Instigator, 
						Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
						WImp.WeaponSettings.RipperSecondaryMomentum * damageScale * MomentumTransfer * dir,
						MyDamageType
					);
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
