class ST_PlasmaSphere extends PlasmaSphere;

var IGPlus_WeaponImplementation WImp;

simulated function PostBeginPlay()
{
	if (ROLE == ROLE_Authority)
	{
		ForEach AllActors(Class'IGPlus_WeaponImplementation', WImp)
			break;
		Speed = WImp.WeaponSettings.PulseSphereSpeed;
	}
	DrawScale = 0.12;
	Super.PostBeginPlay();
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	if ( !bExplosionEffect )
	{
		if ( Role == ROLE_Authority )
			BlowUp(HitLocation);
		bExplosionEffect = true;
		if ( !Level.bHighDetailMode || bHitPawn || Level.bDropDetail )
		{
			if ( bExploded )
			{
				Destroy();
				return;
			}
			else
				DrawScale = 0.2;
		}
		else
			DrawScale = 0.2;

	    LightType = LT_Steady;
		LightRadius = 5;
		SetCollision(false,false,false);
		LifeSpan = 0.5;
		Texture = ExpType;
		DrawType = DT_SpriteAnimOnce;
		Style = STY_Translucent;
		if ( Region.Zone.bMoveProjectiles && (Region.Zone.ZoneVelocity != vect(0,0,0)) )
		{
			bBounce = true;
			Velocity = Region.Zone.ZoneVelocity;
		}
		else
			SetPhysics(PHYS_None);
	}
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
			Other.TakeDamage(
				WImp.WeaponSettings.PulseSphereDamage,
				instigator,
				HitLocation,
				WImp.WeaponSettings.PulseSphereMomentum * MomentumTransfer * Vector(Rotation),
				MyDamageType);
		}
		Explode(HitLocation, vect(0,0,1));
	}
}


defaultproperties {
}
