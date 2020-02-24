class Energize extends Effects;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	if ( Level.bDropDetail )
	{
		LightType = LT_None;
		LifeSpan *= 0.7;
	}
}

auto state Explode
{
	simulated function Tick(float DeltaTime)
	{
		if ( Level.NetMode == NM_DedicatedServer )
		{
			Disable('Tick');
			return;
		}
		ScaleGlow = Lifespan;
		LightBrightness = (ScaleGlow) * 210.0;
		DrawScale = LifeSpan/10;
	}
}

defaultproperties
{
     LifeSpan=2.000000
     AnimSequence=All
     Texture=Texture'Botpack.FlareFX.utflare4'
     DrawScale=0.600000
     bParticles=True
     LightBrightness=255
     LightHue=120
     LightSaturation=100
     LightRadius=6
}
