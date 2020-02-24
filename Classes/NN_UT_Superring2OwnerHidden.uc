class NN_UT_Superring2OwnerHidden extends UT_Superring2;

simulated function SpawnExtraEffects ()
{
	if ( (Owner == None) || (Owner.Role != ROLE_AutonomousProxy) )
	{
		Super.SpawnExtraEffects();
	}
}

defaultproperties
{
     bOwnerNoSee=True
}
