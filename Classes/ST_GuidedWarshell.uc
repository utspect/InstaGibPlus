// ===============================================================
// UTPureStats7A.ST_GuidedWarshell: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_GuidedWarshell extends GuidedWarshell;

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

simulated function Destroyed()
{
	local WarheadLauncher W;

	bDestroyed = true;
	if ( (PlayerPawn(Guider) != None) )
		PlayerPawn(Guider).ViewTarget = None;

	While ( FreeMoves != None )
	{
		FreeMoves.Destroy();
		FreeMoves = FreeMoves.NextMove;
	}

	While ( SavedMoves != None )
	{
		SavedMoves.Destroy();
		SavedMoves = SavedMoves.NextMove;
	}

	if ( (Guider != None) && (Level.NetMode != NM_Client) )
	{
		W = WarheadLauncher(Guider.FindInventoryType(class'ST_WarheadLauncher'));	// Have to do all this Destroyed() part just to change this :/
		if ( W != None )
		{
			W.GuidedShell = None;
			W.GotoState('Finishing');
		}
	}
	Super(Warshell).Destroyed();
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
 		Spawn(class'ST_ShockWave',,,HitLocation+ HitNormal*16);	
		RemoteRole = ROLE_SimulatedProxy;	 		 		
 		Destroy();
	}
}

defaultproperties {
}
