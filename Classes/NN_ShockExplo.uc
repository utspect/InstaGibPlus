class NN_ShockExplo extends ShockExplo;

function MakeSound() {
	PlaySound(EffectSound1,,12.0,,2000);
}

simulated function PostBeginPlay()
{
	if (Role == ROLE_Authority)
		MakeSound();
	Super(AnimSpriteEffect).PostBeginPlay();
}

defaultproperties
{
	EffectSound1=Sound'UnrealShare.General.Explo1'
}