class NN_UT_LightWallHitEffectOwnerHidden extends UT_LightWallHitEffect;

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
