class NN_UT_WallHitOwnerHidden extends UT_WallHit;

simulated function SpawnEffects ()
{
	if ( (Owner == None) || (Owner.Role != ROLE_AutonomousProxy) )
	{
		Super.SpawnEffects();
	}
}

defaultproperties
{
     bOwnerNoSee=True
}
