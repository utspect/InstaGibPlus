//=============================================================================
// Ringexplosion5.
//=============================================================================
class RingExplosion5 extends RingExplosion;

var bool bExtraEffectsSpawned;

simulated function Tick( float DeltaTime )
{
	if ( Level.NetMode != NM_DedicatedServer )
	{
		if ( !bExtraEffectsSpawned )
			SpawnExtraEffects();
		ScaleGlow = (Lifespan/Default.Lifespan)*0.7;
		AmbientGlow = ScaleGlow * 255;		
	}
}

simulated function SpawnExtraEffects()
{
	Spawn(class'EnergyImpact');
	bExtraEffectsSpawned = true;
}

defaultproperties
{
	DrawScale=0.5
}