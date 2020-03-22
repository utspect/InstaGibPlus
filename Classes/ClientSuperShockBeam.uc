class ClientSuperShockBeam extends Effects;

var int Team;
var float Size;
var byte Curve;
var float Duration;
var vector MoveAmount;
var int NumPuffs;

simulated function Tick(float DeltaTime) {
    local byte x;
    local float d;

    if (Level.NetMode != NM_DedicatedServer) {
        d = Lifespan / Duration;

        ScaleGlow = 1;
        for (x = 0; x < Curve; x++)
            ScaleGlow *= d;

        AmbientGlow = ScaleGlow * 210;
        if (Team >= 0)
            LightBrightness = ScaleGlow * 128;
    }
}

simulated function PostBeginPlay() {
    if (Level.NetMode != NM_DedicatedServer)
        SetTimer(0.05, false);
}

simulated function SetProperties(int pTeam, float pSize, float pCurve, float pDuration, vector pMoveAmount, int pNumPuffs) {
    Team = pTeam;
    Size = pSize;
    Duration = pDuration;
    Curve = Clamp(pCurve, 1, 6);
    MoveAmount = pMoveAmount;
    NumPuffs = pNumPuffs;

    if (Team >= 0) {
        Mesh = LodMesh'Botpack.Shockbm';
        if (Level.bHighDetailMode)
            LightType = LT_Steady;
        else
            LightType = LT_None;
        LightEffect = LE_NonIncidence;
        LightBrightness = 192;
        LightSaturation = 64;
        LightRadius = 6;
    }

    switch (Team) {
        case -1:
            // Dont
            break;

        case 0:
            Texture = Texture'BotPack.Translocator.Tranglow';
            LightHue = 0;
            breaK;

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
    DrawScale = 0.44 * Size;
    LifeSpan = Duration;
}

simulated function Timer() {
    local ClientSuperShockBeam r;

    if (NumPuffs > 0) {
        r = Spawn(Class, Owner, , Location + MoveAmount);
        r.SetProperties(Team,Size,Curve,Duration,MoveAmount, NumPuffs - 1);
    }
}

defaultproperties
{
     Physics=PHYS_Rotating
     RemoteRole=ROLE_None
     LifeSpan=0.270000
     Rotation=(Roll=20000)
     DrawType=DT_Mesh
     Style=STY_Translucent
     Texture=Texture'Botpack.Effects.jenergy3'
     Mesh=LodMesh'Botpack.SShockbm'
     DrawScale=0.440000
     bUnlit=True
     bParticles=True
     bFixedRotationDir=True
     RotationRate=(Roll=1000000)
     DesiredRotation=(Roll=20000)
}