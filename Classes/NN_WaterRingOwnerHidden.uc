class NN_WaterRingOwnerHidden extends WaterRing;

var bool bAlreadyHidden;

simulated function Tick(float DeltaTime) {
	
	if ( Owner == None )
		return;
	
	if (Level.NetMode == NM_Client && !bAlreadyHidden && Owner.IsA('bbPlayer') && bbPlayer(Owner).Player != None) {
		Skin = None;
		ExploSound = None;
		DrawType = DT_None;
		Mesh = None;
		bAlreadyHidden = True;
	}
}

simulated function PostBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer && !bNetOwner )
	{
		PlayAnim( 'Explosion', 0.25 );
		SpawnEffects();
	}	
	if ( Instigator != None )
		MakeNoise(0.5);
}

defaultproperties
{
     bOwnerNoSee=True
}
