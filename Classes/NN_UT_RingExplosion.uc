class NN_UT_RingExplosion extends UT_RingExplosion;

simulated function SpawnEffects()
{
	local Actor A;
	A = Spawn(class'NN_ShockExplo');
	A.RemoteRole = ROLE_None;
}
