class NN_UT_SpriteBallExplosionOwnerHidden extends UT_SpriteBallExplosion;

var bool bAlreadyHidden;

simulated function Tick(float DeltaTime) {
	
	if ( Owner == None )
		return;
	
	if (Level.NetMode == NM_Client && !bAlreadyHidden && Owner.IsA('bbPlayer') && bbPlayer(Owner).Player != None) {
		NumFrames = 0;
		EffectSound1 = None;
		DrawType = DT_None;
		Texture = None;
		Skin = None;
		LightType = LT_None;
		bAlreadyHidden = True;
	}
}

simulated Function Timer()
{
	if (!bNetOwner)
		Super.Timer();
	
}

simulated function PostBeginPlay()
{
	if (!bNetOwner)
		Super.PostBeginPlay();
}

function MakeSound()
{
	PlayOwnedSound(EffectSound1,,12.0,,2200);
}

defaultproperties
{
     bOwnerNoSee=True
}
