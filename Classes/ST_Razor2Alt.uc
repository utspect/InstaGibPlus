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
	simulated function ProcessTouch (Actor Other, Vector HitLocation)
	{
		local RipperPulse s;

		if ( Other != Instigator ) 
		{
			if ( Role == ROLE_Authority )
			{
				STM.PlayerHit(Instigator, 12, Other.IsA('Pawn'));	// 12 = Ripper Secondary, Direct if Pawn
				Other.TakeDamage(damage, instigator,HitLocation,
					(MomentumTransfer * Normal(Velocity)), MyDamageType );
				STM.PlayerClear();
			}
			s = spawn(class'RipperPulse',,,HitLocation);	
 			s.RemoteRole = ROLE_None;
			MakeNoise(1.0);
 			Destroy();
		}
	}

	function BlowUp(vector HitLocation)
	{
		local actor Victims;
		local float damageScale, dist;
		local vector dir;

		if( bHurtEntry )
			return;

		bHurtEntry = true;
		foreach VisibleCollidingActors( class 'Actor', Victims, 180, HitLocation )
		{
			// Comment:
			// Ripper secondary makes no sense. All other Splash weapons use HurtRadius. Why this difference?
			// The clue is the dir.Z = FMin(0.45, dir.Z), which ensures a nasty boost in speed in the Z direction!
			if( Victims != self )
			{
				dir = Victims.Location - HitLocation;
				dist = FMax(1,VSize(dir));
				dir = dir/dist;
				dir.Z = FMin(0.45, dir.Z); 
				damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/180);
				STM.PlayerHit(Instigator, 12, False);		// 12 = Ripper Secondary
				Victims.TakeDamage
				(
					damageScale * Damage,
					Instigator, 
					Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
					damageScale * MomentumTransfer * dir,
					MyDamageType
				);
				STM.PlayerClear();
			} 
		}
		bHurtEntry = false;
		MakeNoise(1.0);
	}
}


defaultproperties {
}
