class bbPlayerReplicationInfo extends PlayerReplicationInfo;

var UTPure zzUTPure;

var string SkinName;
var string FaceName;
var string OriginalName;
var int MaxMultiDodges;
var int SkinIndex;
var int Armor;

replication {
    reliable if (Role == ROLE_Authority)
        Armor,
        FaceName,
        MaxMultiDodges,
        SkinIndex,
        SkinName;
}

function PostBeginPlay()
{
    foreach AllActors(class'UTPure', zzUTPure)
        break;

    StartTime = Level.TimeSeconds;
    Timer();
    SetTimer(1.0, true);
    bIsFemale = Pawn(Owner).bIsFemale;
    MaxMultiDodges = zzUTPure.Settings.MaxMultiDodges;
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

    UpdateArmor();
}

function UpdateArmor() {
    local Inventory Inv;
    local int ArmorAmount;

    for (Inv = Owner.Inventory; Inv != none; Inv = Inv.Inventory)
        if (Inv.bIsAnArmor)
            ArmorAmount += Inv.Charge;

    Armor = ArmorAmount;
}

defaultproperties
{
    SkinIndex=-1
    NetUpdateFrequency=10.000000
}
