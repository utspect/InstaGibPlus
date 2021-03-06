class bbPlayerReplicationInfo extends PlayerReplicationInfo;

var string SkinName;
var string FaceName;
var string OriginalName;
var int MaxMultiDodges;
var int SkinIndex;

replication {
    reliable if (Role == ROLE_Authority)
        SkinName, FaceName, MaxMultiDodges;
}

function PostBeginPlay()
{
    StartTime = Level.TimeSeconds;
    Timer();
    SetTimer(1.0, true);
    bIsFemale = Pawn(Owner).bIsFemale;
    MaxMultiDodges = class'UTPure'.default.MaxMultiDodges;
}

function Timer()
{
    local float MinDist, Dist;
    local LocationID L;

    MinDist = 1000000;
    PlayerLocation = None;
    if ( PlayerZone != None )
        for ( L=PlayerZone.LocationID; L!=None; L=L.NextLocation )
        {
            Dist = VSize(Owner.Location - L.Location);
            if ( (Dist < L.Radius) && (Dist < MinDist) )
            {
                PlayerLocation = L;
                MinDist = Dist;
            }
        }

    if (bbPlayer(Owner) != None)
        Ping = bbPlayer(Owner).PingAverage;
    else if (PlayerPawn(Owner) != none)
        Ping = int(PlayerPawn(Owner).ConsoleCommand("GETPING"));

    if (PlayerPawn(Owner) != None)
        PacketLoss = int(PlayerPawn(Owner).ConsoleCommand("GETLOSS"));
}

defaultproperties
{
    SkinIndex=-1
    NetUpdateFrequency=10.000000
}
