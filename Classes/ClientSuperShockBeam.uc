class ClientSuperShockBeam extends Effects;

// Settings
var int Team;
var float Size;
var float Curve;
var float Duration;
var vector MoveAmount;
var int NumPuffs;

//
var float TimeLeft;

var ClientSuperShockBeam Next;
var ClientSuperShockBeam Free;

simulated function Tick(float DeltaTime) {
    if (Level.NetMode != NM_DedicatedServer) {
        ScaleGlow = (TimeLeft / Duration) ** Curve;

        AmbientGlow = ScaleGlow * 210;
        if (Team >= 0)
            LightBrightness = ScaleGlow * 128;

        TimeLeft -= DeltaTime;
        if (TimeLeft <= 0.0) {
            FreeBeam(self);
        }
    }
}

simulated function SetProperties(int pTeam, float pSize, float pCurve, float pDuration, vector pMoveAmount, int pNumPuffs) {
    Team = pTeam;
    Size = pSize;
    Duration = pDuration;
    Curve = pCurve;
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
    TimeLeft = Duration;

    if (Level.NetMode != NM_DedicatedServer)
        SetTimer(0.05, false);
}

simulated function Timer() {
    local ClientSuperShockBeam r;

    if (NumPuffs > 0) {
        r = AllocBeam(PlayerPawn(Owner));
        r.SetLocation(Location + MoveAmount);
        r.SetRotation(Rotation);
        r.SetProperties(Team,Size,Curve,Duration,MoveAmount, NumPuffs - 1);
    }
}

static final function ResetBeam(ClientSuperShockBeam Beam) {
    Beam.Texture = default.Texture;
    Beam.Mesh = default.Mesh;
    Beam.LightType = default.LightType;
    Beam.LightEffect = default.LightEffect;
    Beam.LightBrightness = default.LightBrightness;
    Beam.LightSaturation = default.LightSaturation;
    Beam.LightRadius = default.LightRadius;
    Beam.LightHue = default.LightHue;
}

static final function ClientSuperShockBeam AllocBeam(PlayerPawn P) {
    local ClientSuperShockBeam Beam;

    if (default.Free != none) {
        Beam = default.Free;
        default.Free = Beam.Next;
        Beam.Next = none;

        Beam.bHidden = false;
        Beam.Enable('Tick');
    } else {
        Beam = P.Spawn(class'ClientSuperShockBeam', P);
    }

    ResetBeam(Beam);
    return Beam;
}

static final function FreeBeam(ClientSuperShockBeam Beam) {
    Beam.bHidden = true;
    Beam.Disable('Tick');

    Beam.Next = default.Free;
    default.Free = Beam;
}

static final function Cleanup() {
    default.Free = none;
}

defaultproperties
{
     Physics=PHYS_Rotating
     RemoteRole=ROLE_None
     LifeSpan=0.000000
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