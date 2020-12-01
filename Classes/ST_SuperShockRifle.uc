// ===============================================================
// Stats.ST_SuperShockRifle: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_SuperShockRifle extends SuperShockRifle;

var bool bNewNet;				// Self-explanatory lol
var Rotator GV;
var Vector CDO;
var float yMod;
var bool bAltFired;
var float LastFiredTime;
var bool bDebugSuperShockRifle;
var config sound CustImpactSound;
var int BeamLength;
var float BeamPitch,BeamAltPitch;
var byte BeamFadeCurve;
var float BeamDuration;
var float ImpactSize;
var float ImpactDuration;
var float ImpactPitch;
var name ST_MyDamageType;
var int clientDamage;
var bool bHitTimer;
var bbPlayer globalbbP;
var vector zzSmokeOffset;

simulated function RenderOverlays(Canvas Canvas)
{
	local bbPlayer bbP;

	Super.RenderOverlays(Canvas);
	yModInit();

	bbP = bbPlayer(Owner);
	if (bNewNet && Role < ROLE_Authority && bbP != None)
	{
		if (bbP.bFire != 0 && !IsInState('ClientFiring')) {
			ClientFire(1);
		} else if (bbP.bAltFire != 0 && !IsInState('ClientAltFiring')) {
			ClientAltFire(1);
		}
	}
}

simulated function yModInit()
{
	local bbPlayer P;
	P = bbPlayer(Owner);

	if (P != None && Owner.ROLE == ROLE_AutonomousProxy)
		GV = P.ViewRotation;

	if (P == None)
		return;

	yMod = P.Handedness;
	if (yMod != 2.0)
		yMod *= Default.FireOffset.Y;
	else
		yMod = 0;

	CDO = class'NN_WeaponFunctions'.static.IGPlus_CalcDrawOffset(P, self);
}

simulated function bool ClientFire(float Value)
{
	local bbPlayer bbP;

	if (Owner.IsA('Bot'))
		return Super.ClientFire(Value);

	if (AmmoType == None)
		AmmoType = Ammo(Pawn(Owner).FindInventoryType(AmmoName));

	bbP = bbPlayer(Owner);
	if (Role < ROLE_Authority && bbP != None && bNewNet)
	{
		if (bbP.ClientCannotShoot() || bbP.Weapon != Self || Level.TimeSeconds - LastFiredTime < 0.9)
			return false;
		if ( (AmmoType == None) && (AmmoName != None) )
		{
			// ammocheck
			GiveAmmo(Pawn(Owner));
		}
		if ( AmmoType.AmmoAmount > 0 )
		{
			Instigator = Pawn(Owner);
			GotoState('ClientFiring');
			bPointing=True;
			bCanClientFire = true;
			if ( bRapidFire || (FiringSpeed > 0) )
				Pawn(Owner).PlayRecoil(FiringSpeed);
			NN_TraceFire();
			LastFiredTime = Level.TimeSeconds;
		}
	}
	return Super.ClientFire(Value);
}

simulated function bool ClientAltFire(float Value) {

	local bbPlayer bbP;

	if (Owner.IsA('Bot'))
		return Super.ClientFire(Value);

	if (AmmoType == None)
		AmmoType = Ammo(Pawn(Owner).FindInventoryType(AmmoName));

	bbP = bbPlayer(Owner);
	if (Role < ROLE_Authority && bbP != None && bNewNet)
	{
		if (bbP.ClientCannotShoot() || bbP.Weapon != Self || Level.TimeSeconds - LastFiredTime < 0.9)
			return false;
		if ( (AmmoType == None) && (AmmoName != None) )
		{
			// ammocheck
			GiveAmmo(Pawn(Owner));
		}
		if ( AmmoType.AmmoAmount > 0 )
		{
			Instigator = Pawn(Owner);
			GotoState('ClientFiring');
			bPointing=True;
			bCanClientFire = true;
			if ( bRapidFire || (FiringSpeed > 0) )
				Pawn(Owner).PlayRecoil(FiringSpeed);
			NN_TraceFire();
			LastFiredTime = Level.TimeSeconds;
		}
	}
	return Super.ClientFire(Value);
}

function Fire( float Value )
{
	local bbPlayer bbP;

	if (Owner.IsA('Bot'))
	{
		Super.Fire(Value);
		return;
	}

	bbP = bbPlayer(Owner);
	bAltFired = false;
	if (bbP != None && bNewNet && Value < 1)
		return;
	Super.Fire(Value);
}

simulated function PlayFiring()
{
	PlayOwnedSound(FireSound, SLOT_None, Pawn(Owner).SoundDampening*4.0);
	if (Level.NetMode == NM_Client)
		PlayAnim('Fire1', 0.20 + 0.20 * FireAdjust,0.05);
	else
		PlayAnim('Fire1', 0.22 + 0.22 * FireAdjust,0.05);
}

simulated function PlayAltFiring()
{
	PlayOwnedSound(FireSound, SLOT_None, Pawn(Owner).SoundDampening*4.0);
	if (Level.NetMode == NM_Client)
		PlayAnim('Fire1', 0.20 + 0.20 * FireAdjust,0.05);
	else
		PlayAnim('Fire1', 0.22 + 0.22 * FireAdjust,0.05);
}

function AltFire( float Value )
{
	local bbPlayer bbP;

	if (Owner.IsA('Bot'))
	{
		Super.Fire(Value);
		return;
	}

	bbP = bbPlayer(Owner);
	bAltFired = false;
	if (bbP != None && bNewNet && Value < 1)
		return;
	Super.Fire(Value);
}

state ClientFiring
{
	simulated function bool ClientFire(float Value) {
		if (Owner.IsA('Bot'))
			return Super.ClientFire(Value);

		return false;
	}

	simulated function bool ClientAltFire(float Value) {
		if (Owner.IsA('Bot'))
			return Super.ClientAltFire(Value);

		return false;
	}

	simulated function AnimEnd() {
		local bbPlayer O;
		O = bbPlayer(Owner);
		if (O != none)
			O.ClientDebugMessage("SSR AnimEnd"@O.ViewRotation.Yaw@O.ViewRotation.Pitch);
		super.AnimEnd();
	}
}

State ClientActive
{
	simulated function bool ClientFire(float Value)
	{
		if (Owner.IsA('Bot'))
			return Super.ClientFire(Value);
		bForceFire = bbPlayer(Owner) == None || !bbPlayer(Owner).ClientCannotShoot();
		return bForceFire;
	}

	simulated function bool ClientAltFire(float Value)
	{
		if (Owner.IsA('Bot'))
			return Super.ClientAltFire(Value);
		bForceAltFire = bbPlayer(Owner) == None || !bbPlayer(Owner).ClientCannotShoot();
		return bForceAltFire;
	}

	simulated function AnimEnd()
	{
		if ( Owner == None )
		{
			Global.AnimEnd();
			GotoState('');
		}
		else if ( Owner.IsA('TournamentPlayer')
			&& (TournamentPlayer(Owner).PendingWeapon != None || TournamentPlayer(Owner).ClientPending != None) )
			GotoState('ClientDown');
		else if ( bWeaponUp )
		{
			if ( (bForceFire || (PlayerPawn(Owner).bFire != 0)) && Global.ClientFire(1) )
				return;
			else if ( (bForceAltFire || (PlayerPawn(Owner).bAltFire != 0)) && Global.ClientAltFire(1) )
				return;
			PlayIdleAnim();
			GotoState('');
		}
		else
		{
			PlayPostSelect();
			bWeaponUp = true;
		}
	}
}

simulated function NN_TraceFire()
{
	local vector HitLocation, HitDiff, HitNormal, StartTrace, EndTrace, X,Y,Z;
	local actor Other;
	local bbPlayer bbP;

	if (Owner.IsA('Bot'))
		return;

	yModInit();

	bbP = bbPlayer(Owner);
	if (bbP == None)
		return;

	GetAxes(GV,X,Y,Z);
	StartTrace = Owner.Location + CDO;
	EndTrace = StartTrace + (100000 * vector(GV));

	Other = bbP.NN_TraceShot(HitLocation,HitNormal,EndTrace,StartTrace,Pawn(Owner));

	if (bbP.bDrawDebugData) {
		bbP.debugClientHitLocation = HitLocation;
		bbP.debugClientHitNormal = HitNormal;
		bbP.bClientPawnHit = False;
	}

	if (Other.IsA('Pawn'))
	{
		HitDiff = HitLocation - Other.Location;
		if (bbP.bDrawDebugData) {
			bbP.debugClientHitDiff = HitDiff;
			bbP.debugClientEnemyHitLocation = Other.Location;
			bbP.bClientPawnHit = True;
		}
	}

	NN_ProcessTraceHit(Other, HitLocation, HitNormal, vector(GV),Y,Z);
	bbP.xxNN_Fire(-1, bbP.Location, bbP.Velocity, bbP.ViewRotation, Other, HitLocation, HitDiff, false);
	if (Other == bbP.zzClientTTarget)
		bbP.zzClientTTarget.TakeDamage(0, Pawn(Owner), HitLocation, 60000.0*vector(GV), ST_MyDamageType);
}

simulated function bool NN_ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{

	local bbPlayer bbP;
	local float is, f;
	local actor a;
	local vector Offset;

	if (Owner.IsA('Bot'))
		return false;

	if (Other==None)
	{
		HitNormal = -X;
		HitLocation = Owner.Location + X*100000.0;
	}

	Offset = CDO + (FireOffset.X + 20) * X + Y * yMod + FireOffset.Z * Z;
	NN_SpawnEffect(HitLocation, Owner.Location + Offset, Offset, HitNormal);

	is = ImpactSize;
	f = 60000.0;

	bbP = bbPlayer(Owner);

	if (Other.isA('Pawn')) {
		if (bbP.Settings.bEnableHitSounds) {
			if (!bbP.GameReplicationInfo.bTeamGame || bbPlayer(Other).PlayerReplicationInfo.Team != bbP.PlayerReplicationInfo.Team) {
				//Log("Hitsound:"@bbP.playedHitSound);
				bbP.ClientPlaySound(bbP.playedHitSound);
			}
		}
	}

	if (bbPlayer(Owner).Settings.cShockBeam == 2) {
		if (bbPlayer(Owner).PlayerReplicationInfo.Team == 1) {
			Spawn(class'ut_RingExplosion',,, HitLocation+HitNormal*8,rotator(HitNormal));
			a = Spawn(class'EnergyImpact');
			a.RemoteRole = ROLE_None;
		} else
			Spawn(class'ut_SuperRing2',,, HitLocation+HitNormal*8,rotator(HitNormal));
	} else
		Spawn(class'ut_SuperRing2',,, HitLocation+HitNormal*8,rotator(HitNormal));

	if (bbPlayer(Owner) != None)
		bbPlayer(Owner).xxClientDemoFix(None, class'ut_SuperRing2',HitLocation+HitNormal*8,,, rotator(HitNormal));

	return false;
}

simulated function NN_SpawnEffect(vector HitLocation, vector SmokeLocation, vector SmokeOffset, vector HitNormal)
{
	if (Owner.IsA('Bot'))
		return;

	bbPlayer(Owner).xxClientSpawnSSRBeamInternal(HitLocation, SmokeLocation, SmokeOffset, Owner);
	bbPlayer(Owner).xxDemoSpawnSSRBeam(HitLocation, SmokeLocation, SmokeOffset, Owner);
}

function TraceFire( float Accuracy )
{
	local bbPlayer bbP;
	local actor NN_Other;
	local vector NN_HitLoc, HitLocation, HitNormal, StartTrace, EndTrace, X,Y,Z;

	if (Owner.IsA('Bot'))
	{
		Super.TraceFire(Accuracy);
		return;
	}

	bbP = bbPlayer(Owner);
	if (bbP == None || !bNewNet || bAltFired)
	{
		Super.TraceFire(Accuracy);
		bAltFired = false;
		return;
	}

	if (bbP.zzNN_HitActor != None && bbP.zzNN_HitActor.IsA('bbPlayer') && !bbPlayer(bbP.zzNN_HitActor).xxCloseEnough(bbP.zzNN_HitLoc))
		bbP.zzNN_HitActor = None;

	NN_Other = bbP.zzNN_HitActor;

	Owner.MakeNoise(bbP.SoundDampening);
	GetAxes(bbP.zzNN_ViewRot,X,Y,Z);

	StartTrace = Owner.Location + CalcDrawOffset() + FireOffset.Y * Y + FireOffset.Z * Z;
	EndTrace = StartTrace + Accuracy * (FRand() - 0.5 )* Y * 1000
		+ Accuracy * (FRand() - 0.5 ) * Z * 1000 ;

	if ( bBotSpecialMove && (Tracked != None)
		&& (((Owner.Acceleration == vect(0,0,0)) && (VSize(Owner.Velocity) < 40)) ||
			(Normal(Owner.Velocity) Dot Normal(Tracked.Velocity) > 0.95)) )
		EndTrace += 100000 * Normal(Tracked.Location - StartTrace);
	else
	{
		AdjustedAim = bbP.AdjustAim(1000000, StartTrace, 2.75*AimError, False, False);
		EndTrace += (100000 * vector(AdjustedAim));
	}

	if (bbP.zzNN_HitActor != None && VSize(bbP.zzNN_HitDiff) > bbP.zzNN_HitActor.CollisionRadius + bbP.zzNN_HitActor.CollisionHeight)
		bbP.zzNN_HitDiff = vect(0,0,0);

	if (bbP.zzNN_HitActor != None && (bbP.zzNN_HitActor.IsA('Pawn') || bbP.zzNN_HitActor.IsA('Projectile')) && FastTrace(bbP.zzNN_HitActor.Location + bbP.zzNN_HitDiff, StartTrace))
	{
		NN_HitLoc = bbP.zzNN_HitActor.Location + bbP.zzNN_HitDiff;
	}
	else
	{
		bbP.TraceShot(HitLocation,HitNormal,EndTrace,StartTrace);
		NN_HitLoc = bbP.zzNN_HitLoc;
	}
	ProcessTraceHit(bbP.zzNN_HitActor, NN_HitLoc, HitNormal, vector(AdjustedAim), Y, Z);
	bbP.zzNN_HitActor = None;
	Tracked = None;
	bBotSpecialMove = false;
}

function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	local Pawn PawnOwner;
	local bbPlayer bbP;

	if (Owner.IsA('Bot'))
	{
		Super.ProcessTraceHit(Other, HitLocation, HitNormal, X, Y, Z);
		return;
	}

	yModInit();

	PawnOwner = Pawn(Owner);
	bbP = bbPlayer(Owner);

	if (Other==None)
	{
		HitNormal = -X;
		HitLocation = Owner.Location + X*10000.0;
	}

	zzSmokeOffset = CalcDrawOffset() + (FireOffset.X + 20) * X + FireOffset.Y * Y + FireOffset.Z * Z;
	SpawnEffect(HitLocation, Owner.Location + zzSmokeOffset);

	Spawn(class'NN_UT_Superring2OwnerHidden',Owner,, HitLocation+HitNormal*8,rotator(HitNormal));

	if ( (Other != self) && (Other != Owner) && (Other != None) )
	{
		Other.TakeDamage(HitDamage, PawnOwner, HitLocation, 60000.0*X, ST_MyDamageType);
	}
}

function SpawnEffect(vector HitLocation, vector SmokeLocation)
{
	local Pawn P;
	local SuperShockBeam SSB;

	if (Owner.IsA('Bot'))
	{
		Super.SpawnEffect(HitLocation, SmokeLocation);
		return;
	}

	// This is only done to fix stats, because stats count the number of
	// SuperShockBeams that were spawned
	if (Role == ROLE_Authority) {
		SSB = Spawn(class'SuperShockBeam');
		// Dont show locally
		SSB.bHidden = true;
		// Dont replicate to clients
		SSB.RemoteRole = ROLE_None;
	}

	for (P = Level.PawnList; P != none; P = P.NextPawn) {
		if (P == Owner) continue;
		if (bbPlayer(P) != none)
			bbPlayer(P).xxClientSpawnSSRBeam(HitLocation, SmokeLocation, zzSmokeOffset, Owner);
		else if (bbCHSpectator(P) != none)
			bbCHSpectator(P).xxClientSpawnSSRBeam(HitLocation, SmokeLocation, zzSmokeOffset, Owner);
	}
}

function SetSwitchPriority(pawn Other)
{
	Class'NN_WeaponFunctions'.static.SetSwitchPriority( Other, self, 'SuperShockRifle');
}

simulated function PlaySelect ()
{
	Class'NN_WeaponFunctions'.static.PlaySelect( self);
}

simulated function TweenDown ()
{
	Class'NN_WeaponFunctions'.static.TweenDown( self);
}

simulated function AnimEnd ()
{
	Class'NN_WeaponFunctions'.static.AnimEnd( self);
}

state NormalFire
{
	function Fire(float F)
	{
		if (Owner.IsA('Bot'))
		{
			Super.Fire(F);
			return;
		}
		if (F > 0 && bbPlayer(Owner) != None)
			Global.Fire(F);
	}
}

state AltFiring
{
	function Fire(float F)
	{
		if (Owner.IsA('Bot'))
		{
			Super.AltFire(F);
			return;
		}
		if (F > 0 && bbPlayer(Owner) != None)
			Global.Fire(F);
	}
}

state Active
{
	function Fire(float F)
	{
		if (Owner.IsA('Bot'))
		{
			Super.Fire(F);
			return;
		}
		if (F > 0 && bbPlayer(Owner) != None)
			Global.Fire(F);
	}
}

auto state Pickup
{
	ignores AnimEnd;

	simulated function Landed(Vector HitNormal)
	{
		Super(Inventory).Landed(HitNormal);
	}
}

defaultproperties
{
     bAlwaysRelevant=True
     bNewNet=True
     PickupViewMesh=LodMesh'Botpack.SASMD2hand'
     PickupViewScale=1.750000
	 bDebugSuperShockRifle=False
	 BeamLength=135
	 clientDamage=1000
     BeamPitch=1.25
     BeamAltPitch=1.50
     BeamFadeCurve=4
     BeamDuration=0.75
	 ImpactSize=1.00
     ImpactDuration=1.20
     ImpactPitch=1.25
	 CustImpactSound=Sound'UnrealShare.General.Expla02'
	 ST_MyDamageType=jolted
	 bHitTimer=False
}
