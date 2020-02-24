class NN_ImpactMarkOwnerHidden extends ImpactMark;

simulated function SpawnEffects()
{
	if (!bNetOwner)
		Super.SpawnEffects();
}

defaultproperties
{
     bOwnerNoSee=True
}