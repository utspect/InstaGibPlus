// ============================================================================
//  swJumpPad.
//
//  Improved JumpPad/Kicker Actor that calculates jump force automatically.
//  Does not require additional Trigger/LiftExit/LiftCenter actors.
//  Familiar placing procedure - just like Teleporters.
//  Path links visible in UnrealEd.
//  Bot support.
//  Can be disabled/enabled with Triggers.
//  Support for on-jump special effects.
//  Allows jump angle and destination randomisation.
//  Supports custom vertical gravity, ie: LowGrav mutator.
//
// ============================================================================
//  Copyright 2005 Roman Switch` Dzieciol, neai o2.pl
//  http://wiki.beyondunreal.com/wiki/Switch
// ============================================================================
//  One-way JumpPad Tutorial:
//  - swJumpPads are placed like Teleporters:
//  - TWO swJumpPad actors are required: Source and Destination.
//  - In Source swJumpPad set "URL" to some name.
//  - In Destination swJumpPad set "Tag" to that name.
//  - Adjust JumpAngle if neccessary.
//  - Congratulations, you have set up a one-way bot-friendly JumpPad.
//
// ============================================================================
//  Tips:
//
//  - JumpAngle will be limited to 1-89 degrees.
//
//  - If the JumpAngle is too low, a theoretically valid one will be calculated
//    ingame and warning message will be broadcasted every time someone jumps.
//
//  - For testing precision, doublejump into JumpPad from distance, this way
//    you won't accidentially disrupt your jump with movement keys.
//
//  - Ignore other Teleporter properties other than URL, it's not a teleporter.
//
//  - If you want to change jump parameters, change them in the Source JumpPad,
//    not the Destination one.
//
//  - bTraceGround requires that there are no holes under the center of
//    Destination JumpPad. If there is one, ie if the JumpPad is placed on edge
//    of a cliff, players will be launched at the ground level in the hole, ie
//    bottom of the cliff. To fix this move Destination JumpPad away from the
//    edge or disable bTraceGround.
//
// ============================================================================
//  Angle random modes:
//
//  AM_Random
//      Uses random value from range ( JumpAngle, JumpAngle+AngleRand )
//
//  AM_Extremes
//      Uses JumpAngle then JumpAngle+AngleRand then repeat. Lets suppose that
//      two players walk into JumpPad one after another. Player who jumped
//      first may arrive at target location *later* than player who jumped
//      second if the jump angle of second player was significatly flatter.
//
//  AM_Owned
//      Team==TeamNumber uses JumpAngle, other teams use JumpAngle+AngleRand
//
// ============================================================================
//  bLogParams acronyms:
//
//  A   = Angle
//  IV  = Impact velocity in Z plane
//  IS  = Impact velocity in XY plane
//  IH  = Impact height
//  T   = Time in ms
//  P   = Peak height
//  V   = Jump velocity
//  G   = Gravity
//  U   = URL
//  PN  = Player Name
//  N   = Source JumpPad name
//  D   = Destination JumpPad name
//
// ============================================================================
class NN_swJumpPad expands Teleporter;


enum EAngleMode
{
    AM_Random,
    AM_Extremes,
    AM_Owned
};


// ============================================================================
// Source JumpPad Properties
// ============================================================================

var(JumpPad) float          JumpAngle;          // Jump angle

var(JumpPad) byte           TeamNumber;         // Team number
var(JumpPad) bool           bTeamOnly;          // Other teams can't use it

var(JumpPad) float          TargetZOffset;      // Target location height offset
var(JumpPad) vector         TargetRand;         // Target location random range
var(JumpPad) bool           bTraceGround;       // Find ground below JumpPad and use it as target location

var(JumpPad) float          AngleRand;          // Jump angle random range
var(JumpPad) EAngleMode     AngleRandMode;      // Jump angle random range mode

var(JumpPad) bool           bDisabled;          // Disable, triggering JumpPad toggles this

var(JumpPadFX) class<Actor> JumpEffect;         // Spawn this actor at JumpPad when someone jumps
var(JumpPadFX) class<Actor> JumpPlayerEffect;   // Spawn this actor at jumping player
var(JumpPadFX) name         JumpEvent;          // Trigger this event when someone jumps
var(JumpPadFX) sound        JumpSound;          // Play this sound when someone jumps
var(JumpPadFX) bool         bClientSideEffects; // Spawn effects only on clients

var(JumpPadDebug) float     JumpWait;           // Disable JumpPad for JumpWait seconds after jump
var(JumpPadDebug) bool      bLogParams;         // Display jump parameters in log and ingame


// ============================================================================
// Internal
// ============================================================================

var Actor JumpTarget;
var Actor JumpActor;
var bool bSwitchAngle;
var float MinAngleCurve;
var float MinAngleFinder;
var float MinAngle;
var float MaxAngle;

Const RadianToDegree    = 57.2957795131;
Const DegreeToRadian    = 0.01745329252;
Const RadianToURot      = 10430.3783505;
Const URotToRadian      = 0.000095873799;
Const DegreeToURot      = 182.04444444;
Const URotToDegree      = 0.00549316;

simulated function PostBeginPlay()
{
    Super(NavigationPoint).PostBeginPlay();
    if( URL == "" )
        ExtraCost = 0;
}

simulated function bool Accept( actor Incoming, Actor Source )
{
    return false;
}

simulated function Trigger( Actor Other, Pawn EventInstigator )
{
    local int i;

    bEnabled = !bEnabled;
    if( bEnabled ) // launch any pawns already in my radius
        for( i=0; i<4; i++)
            if( Touching[i] != None )
                Touch(Touching[i]);
}

simulated function ShowMessage( coerce string s, optional Actor A, optional bool bID )
{
    if( bID )
        s = s $ GetIdentifier(A);

    if( Role == ROLE_Authority )
        BroadcastMessage( s, true );

    Log( s, name );
}

simulated function float GetAngle( Actor Other )
{
    switch( AngleRandMode )
    {
        case AM_Random:
            return RandRange( JumpAngle, JumpAngle+AngleRand );

        case AM_Extremes:
            bSwitchAngle = !bSwitchAngle;
            return JumpAngle + AngleRand*float(bSwitchAngle);

        case AM_Owned:
            if( Pawn(Other) != None && Pawn(Other).PlayerReplicationInfo.Team != TeamNumber )
                    return JumpAngle+AngleRand;
            else    return JumpAngle;
    }
}

simulated function string GetIdentifier( Actor A )
{
    local string S;
    local Pawn P;

    S = S @ "U=[" $URL$ "]";

    P = Pawn(A);
    if( P != None )
    {
        S = S @ "PN=[";
        if( P.PlayerReplicationInfo != None
        &&  P.PlayerReplicationInfo.PlayerName != "" )
                S = S $P.PlayerReplicationInfo.PlayerName;
        else    S = S $P.Name;
        S = S $ "]";
    }
    S = S @ "N=[" $Name$ "]";
    S = S @ "D=[" $JumpTarget.GetPropertyText("Name")$ "]";

    return S;
}

simulated function vector TraceGround( vector Origin )
{
    local Actor A;
    local vector HL,HN;

    A = Trace( HL, HN, Origin+vect(0,0,-32768), Origin, false );
    if( A != None )
    {
        return HL;
    }

    ShowMessage( "ERROR: Ground level not found below destination",, true );
    return JumpTarget.Location + vect(0,0,-1)*JumpTarget.CollisionHeight;
}

simulated function vector CalcVelocity( Pawn Other )
{
    local vector vel;
    local vector origin;
    local vector targetloc, targetdelta, targetrange;
    local rotator jumpdir, targetdir;
    local float targetdist, targetz;
    local float grav;
    local float angler, angled, pitch, angledmin, minalpha, angledtry;
    local float tanr, sinr, cosr;
    local float speed, speedxy, speedz;
    local float peak;
    local float time;
    local float impactheight, impactspeedz;
    local vector impactspeedxy;
    local Bot B;


    // Player location
    origin = Other.Location + vect(0,0,-1)*Other.CollisionHeight;

    // Target Location
    if( bTraceGround )
    {
        targetloc = TraceGround(JumpTarget.Location);
    }
    else
    {
        targetloc = JumpTarget.Location + vect(0,0,-1)*JumpTarget.CollisionHeight;
    }
    targetloc += VRand()*TargetRand;
    targetloc.Z += TargetZOffset;

    // Target vars
    targetdelta = targetloc - origin;
    targetrange = targetdelta * vect(1,1,0);
    targetdist = VSize(targetrange);
    targetz = targetdelta.Z;
    targetdir = rotator(targetdelta);

    // Get gravity
    grav = -Region.Zone.ZoneGravity.Z;

    // Get Angle
    //JumpAngle=10;
    angled = FClamp(GetAngle(Other),MinAngle,MaxAngle);

    // Check minimum angle
    angledmin = FClamp(int(targetdir.Pitch * URotToDegree)+1,MinAngle,MaxAngle);
    if( angledmin > angled )
    {
        minalpha = (1-(1-(angledmin / MaxAngle))**MinAngleCurve);
        angledtry = FClamp(angledmin+(MaxAngle-angledmin)*MinAngleFinder*minalpha,MinAngle,MaxAngle);
        ShowMessage( "WARNING: Minimum theoretical jump angle is" @int(angledmin)$ ". JumpAngle=" $int(angled)$ ". Trying angle=" $int(angledtry), Other, true );
        angled = angledtry;
    }

    // Convert angle
    angler = angled * DegreeToRadian; // radians
    pitch = angled * DegreeToURot; // ru

    // Target direction
    jumpdir = targetdir;
    jumpdir.Pitch = pitch;

    // Speed
    tanr = tan(angler);
    speed = targetdist * Sqrt( (grav*((tanr*tanr) + 1)) / (2*(targetdist*tanr-targetz)) );
    if( speed == 0 )
    {
        ShowMessage( "ERROR: Could not calculate JumpSpeed", Other, true );
        speed = Other.JumpZ;
    }

    // Velocity
    vel = speed * vector(jumpdir);

    // Velocity components
    speedxy = VSize(vel*vect(1,1,0));
    speedz = vel.Z;

    // Flight time
    time = (speedz / grav) + sqrt((speedz*speedz)/(grav*grav)-(2*targetz)/grav);


    if( bLogParams )
    {
        sinr = sin(angler);
        cosr = cos(angler);

        peak = ( (speed*speed*sinr*sinr) / (2*grav));

        impactheight = peak - targetz;
        impactspeedxy = Normal(targetrange) * speedxy;
        impactspeedz = ( speedz ) - ( grav * time );

        ShowMessage(
         "A=" $int(angled)
        @"IV=" $int(impactspeedz)
        @"IS=" $int(VSize(impactspeedxy))
        @"IH=" $int(impactheight)
        @"T=" $int(time*1000)
        @"P=" $int(peak)
        @"V=" $int(speed)
        @"G=" $int(grav)
        , Other, true );
    }

    // AI hints
    B = Bot(Other);
    if( B != None )
    {
        B.Focus = JumpTarget.Location;
        B.MoveTarget = JumpTarget;
        B.MoveTimer = time-0.1;
        B.Destination = JumpTarget.Location;
    }

    // Update player's physics
    if( Other.Physics == PHYS_Walking )
    {
        Other.SetPhysics(PHYS_Falling);
    }
    Other.Velocity = vel;
    Other.Acceleration = vect(0,0,0);

    // AI hints
    if( B != None )
    {
        B.bJumpOffPawn = true;
        B.SetFall();
        B.DesiredRotation = rotator(targetrange);
    }

    return vel;
}

simulated event Touch( Actor Other )
{
    // Accept only pawns
    if( !bEnabled || Pawn(Other) == None || Other.Physics == PHYS_None  )
        return;

    // Setup PostTouch
    PendingTouch = Other.PendingTouch;
    Other.PendingTouch = self;
}

simulated event PostTouch( Actor Other )
{
    local Pawn P;
    local Actor A;

    // Accept only pawns
    P = Pawn(Other);
    if( !bEnabled || P == None || P.Physics == PHYS_None )
        return;

    if( Role == ROLE_Authority )
    {
        // Find JumpTarget
        foreach AllActors( class 'Actor', A )
            if( string(A.tag) ~= URL && A != Self )
                JumpTarget = A;

        if( JumpTarget == None )
        {
            if( URL != "" )
                ShowMessage( "ERROR: Could not find destination", Other, true );
            return;
        }

        // If team only, enforce it
        if( bTeamOnly && P.PlayerReplicationInfo.Team != TeamNumber )
            return;

        // Do not launch again a launched player.
        if( Other != JumpActor || Level.TimeSeconds-JumpWait > default.JumpWait )
        {
            JumpActor = Other;
            JumpWait = Level.TimeSeconds;
        }
        else return;

        // Launch player
        CalcVelocity( P );

        // Broadcast event
        Instigator = P;
        if( JumpEvent != '' )
            foreach AllActors( class'Actor', A, JumpEvent )
                A.Trigger( self, Instigator );

        // Play Sounds
        JumpSounds(P);
    }

    // Show effects
    JumpEffects(P);
}

simulated function JumpEffects( Pawn Other )
{
    if((bClientSideEffects && Level.NetMode != NM_DedicatedServer)
    ||(!bClientSideEffects && Role == ROLE_Authority))
    {
        // Spawn JumpPad effect
        if( JumpEffect != None )
            Spawn( JumpEffect, self,, Location, rotator(Other.Velocity) );

        // Spawn Player effect
        if( JumpPlayerEffect != None )
            Spawn( JumpPlayerEffect, Other,, Other.Location, rotator(Other.Velocity) );
    }
}

function JumpSounds( Pawn Other )
{
    // Make noise
    if( JumpSound != None && Level.NetMode != NM_Client )
    {
        PlaySound(JumpSound);
        MakeNoise(1.0);
    }
}

/* SpecialHandling is called by the navigation code when the next path has been found.
It gives that path an opportunity to modify the result based on any special considerations
*/

function Actor SpecialHandling( Pawn Other )
{
    //ShowMessage( "FOUND!",, true );
    return self;
}


// ============================================================================
//  Copyright 2005 Roman Switch` Dzieciol, neai o2.pl
//  http://wiki.beyondunreal.com/wiki/Switch
// ============================================================================
defaultproperties
{
    JumpAngle=45.00
    bTraceGround=True
    JumpEvent=JumpPad
    JumpSound=Sound'UnrealI.Pickups.BootJmp'
    JumpWait=1.00
    MinAngleCurve=3.00
    MinAngleFinder=0.75
    MinAngle=1.00
    MaxAngle=89.00
    ExtraCost=400
    bStatic=False
    bDirectional=False
    CollisionRadius=64.00
    CollisionHeight=24.00
    RemoteRole=ROLE_None
}
