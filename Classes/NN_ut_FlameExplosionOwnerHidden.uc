class NN_ut_FlameExplosionOwnerHidden extends ut_FlameExplosion;

var bool bAlreadyHidden;

simulated function Tick(float DeltaTime) {
	
	if ( Owner == None )
		return;
	
	if (Level.NetMode == NM_Client && !bAlreadyHidden && Owner.IsA('bbPlayer') && bbPlayer(Owner).Player != None) {
		LightType = LT_None;
		Texture = None;
		Skin = None;
		bAlreadyHidden = True;
	}
}

simulated function PostBeginPlay()
{
	local actor a;

	Super.PostBeginPlay();
	if ( Level.NetMode != NM_DedicatedServer )
	{
		if (!Level.bHighDetailMode) 
			Drawscale = 1.4;
		else if (!bNetOwner)
			Spawn(class'UT_ShortSmokeGen');
	}
	MakeSound();
}

function MakeSound()
{
	PlayOwnedSound (EffectSound1,,3.0);	
}

defaultproperties
{
     bOwnerNoSee=True
}
