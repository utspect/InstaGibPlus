Class NN_AlternateSuperShockBeam extends Effects;

var int iTeam;
var float fSize;
var byte iCurve;
var float fDuration;

var config float BeamInterval;
var vector MoveAmount;
var int NumPuffs;

replication
{
    // Things the server should send to the client.
    unreliable if( Role==ROLE_Authority )
        MoveAmount, NumPuffs;
}

simulated function SetProperties(int team,float size,float curve,float duration)
{
	if (!Level.bHighDetailMode)
	{
		LightType = LT_None;
//		BeamInterval *= 2;
	}
	iTeam = team;
	fSize = size;
	iCurve = curve;
	fDuration = duration;
	if (iCurve<1) iCurve = 1;
	else if (iCurve>6) iCurve = 6;
	switch (team){
	case 1:
		Texture = Texture'BotPack.Translocator.Tranglowb';
		LightHue = 150;
		LightBrightness = 224;
		break;
	case 2:
		Texture = Texture'BotPack.Translocator.Tranglowg';
		LightHue = 75;
		break;
	case 3:
		Texture = Texture'BotPack.Translocator.Tranglowy';
		LightHue = 40;
		break;
	}
	DrawScale = 0.440000*size;
	default.LifeSpan = fDuration;
	LifeSpan = fDuration;
}

simulated function Tick( float DeltaTime )
{
    local byte x;
    local float d;

    if ( Level.NetMode  != NM_DedicatedServer )
    {
        d = Lifespan/fDuration;
		ScaleGlow = 1;
		for (x=0;x<iCurve;x++) ScaleGlow = ScaleGlow*d;
		AmbientGlow = ScaleGlow * 210;
		LightBrightness = ScaleGlow * 128;
    }
}


simulated function PostBeginPlay()
{
    if ( Level.NetMode != NM_DedicatedServer )
        SetTimer(0.05, false);
}

simulated function Timer()
{
    local NN_AlternateSuperShockBeam r;
    
    if (NumPuffs>0)
    {
        r = Spawn(class'NN_AlternateSuperShockBeam',,,Location+MoveAmount);
        r.SetProperties(iTeam,fSize,iCurve,fDuration);
        r.BeamInterval = BeamInterval;
        r.RemoteRole = ROLE_None;
        r.NumPuffs = NumPuffs -1;
        r.MoveAmount = MoveAmount;
    }
}

defaultproperties
{
     Physics=PHYS_Rotating
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=0.270000
     Rotation=(Roll=20000)
     DrawType=DT_Mesh
     Style=STY_Translucent
     Texture=Texture'BotPack.Translocator.Tranglow'
     Mesh=LodMesh'Botpack.Shockbm'
     DrawScale=0.440000
     bUnlit=True
     bParticles=True
     bFixedRotationDir=True
     RotationRate=(Roll=1000000)
     DesiredRotation=(Roll=20000)
     LightType=1
     LightEffect=13
     LightBrightness=192
     LightSaturation=64
     LightRadius=6
}