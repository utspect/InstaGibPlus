// ===============================================================
// UTPureStats7A.ST_WarShell: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_WarShell extends WarShell;

var IGPlus_WeaponImplementation WImp;

simulated function PostBeginPlay()
{
	if (ROLE == ROLE_Authority)
	{
		ForEach AllActors(Class'IGPlus_WeaponImplementation', WImp)
			break;
	}
	Super.PostBeginPlay();
}

singular function TakeDamage( int NDamage, Pawn instigatedBy, Vector hitlocation, 
						vector momentum, name damageType )
{
	if ( NDamage > 5 )
	{
		PlaySound(Sound'Expl03',,6.0);
		spawn(class'WarExplosion',,,Location);
		HurtRadius(Damage,350.0, MyDamageType, MomentumTransfer, HitLocation );
		RemoteRole = ROLE_SimulatedProxy;	 		 		
 		Destroy();
	}
}


auto state Flying
{
	function Explode(vector HitLocation, vector HitNormal)
	{
		if ( Role < ROLE_Authority )
			return;
		HurtRadius(Damage,300.0, MyDamageType, MomentumTransfer, HitLocation );	 		 		
 		spawn(class'ST_ShockWave',,,HitLocation+ HitNormal*16);	
		RemoteRole = ROLE_SimulatedProxy;	 		 		
 		Destroy();
	}
}


defaultproperties {
}
