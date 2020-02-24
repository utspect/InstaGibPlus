class NN_AlternateSuperShockBeamImpact extends Effects;

var byte fTeam;
var float fSize;
var float fDuration;
var sound fSound;
var float fPitch;

/* replication
{
	reliable if (Role==ROLE_Authority)
		fTeam, fSize, fDuration, fSound, fPitch;
} */

simulated function PostNetBeginPlay()
{
	local int x;

	local NN_AlternateSuperShockBeamImpact ci;
	if (Role<ROLE_Authority)
	{
		PlaySound(fSound,,12.0,,2200,fPitch);
	}
	Spawn(class'EnergyImpact');
	if (!Level.bDropDetail)
	{
		x = 3+int(FRand()*5);
		while (x-->0)
		{
			Spawn(class'UT_Spark',,,Location+8*Vector(Rotation),Rotation);
		}
	}
	ci = Spawn(class'NN_AlternateSuperShockBeamImpact');
	ci.SetProperties(fTeam,fSize,fDuration);
	if ( Instigator != None )
		MakeNoise(0.5);
}

simulated function SetProperties(int team,float size,float duration,optional sound custsound,optional float pitch)
{
	fTeam = team;
	fSize = size;
	fDuration = duration;
	fSound = custsound;
	fPitch = pitch;
}

defaultproperties
{
    Physics=PHYS_Rotating
    RemoteRole=ROLE_SimulatedProxy
    LifeSpan=0.10
    DrawType=DT_Mesh
    Style=STY_None
}