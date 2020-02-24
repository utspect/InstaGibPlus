class NN_UT_HeavyWallHitEffectOwnerHidden extends UT_HeavyWallHitEffect;

simulated function SpawnEffects()
{
	if (!bNetOwner)
		Super.SpawnEffects();
}

defaultproperties
{
     bOwnerNoSee=True
}
