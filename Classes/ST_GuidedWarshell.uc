// ===============================================================
// UTPureStats7A.ST_GuidedWarshell: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_GuidedWarshell extends GuidedWarshell;

var ST_Mutator STM;

simulated function PostBeginPlay()
{
	if (ROLE == ROLE_Authority)
	{
		ForEach AllActors(Class'ST_Mutator', STM)
			break;
		STM.PlayerFire(Instigator, 19);			// 19 = Redeemer.
		STM.PlayerSpecial(Instigator, 19);		// 19 = Redeemer, Guided.
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
		STM.PlayerHit(Instigator, 19, False);		// 19 = Redeemer.
		HurtRadius(Damage,350.0, MyDamageType, MomentumTransfer, HitLocation );
		STM.PlayerClear();
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
		STM.PlayerHit(Instigator, 19, False);		// 19 = Redeemer.
		HurtRadius(Damage,300.0, MyDamageType, MomentumTransfer, HitLocation );	 		 		
		STM.PlayerClear();
 		spawn(class'ST_ShockWave',,,HitLocation+ HitNormal*16);	
		RemoteRole = ROLE_SimulatedProxy;	 		 		
 		Destroy();
	}
}

defaultproperties {
}
