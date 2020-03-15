// ===============================================================
// Stats.ST_SuperShockRifle: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_SuperShockRifle extends SuperShockRifle;

var bool bNewNet;				// Self-explanatory lol
var Rotator GV;
var Vector CDO, clientHitNormal, clientHitLoc, clientX;
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
var name MyDamageType;
var int clientDamage;
var bool bHitTimer;
var bbPlayer globalbbP;

simulated function RenderOverlays(Canvas Canvas)
{
	local bbPlayer bbP;

	Super.RenderOverlays(Canvas);
	yModInit();

	bbP = bbPlayer(Owner);
	if (bNewNet && Role < ROLE_Authority && bbP != None)
	{
		if (bbP.bFire != 0 && !IsInState('ClientFiring'))
			ClientFire(1);
		else if (bbP.bAltFire != 0 && !IsInState('ClientAltFiring'))
			ClientAltFire(1);
	}
}

simulated function yModInit()
{
	if (bbPlayer(Owner) != None && Owner.ROLE == ROLE_AutonomousProxy)
		GV = bbPlayer(Owner).zzViewRotation;

	if (PlayerPawn(Owner) == None)
		return;

	yMod = PlayerPawn(Owner).Handedness;
	if (yMod != 2.0)
		yMod *= Default.FireOffset.Y;
	else
		yMod = 0;

	CDO = CalcDrawOffset();
}

simulated function bool ClientFire(float Value)
{
	local bbPlayer bbP;

	if (Owner.IsA('Bot'))
		return Super.ClientFire(Value);

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

/* simulated function bool ClientAltFire(float Value)
{
	local bbPlayer bbP;

	if (Owner.IsA('Bot'))
		return Super.ClientAltFire(Value);

	bbP = bbPlayer(Owner);
	if (bbP != None)
	{
		LastFiredTime = Level.TimeSeconds;
	}
	bCanClientFire = true;
	Instigator = Pawn(Owner);
	if (bbP != None)
	{
		bbP.xxNN_AltFire(-1, bbP.Location, bbP.Velocity, bbP.zzViewRotation);
	}
	return Super.ClientAltFire(Value);
} */

simulated function bool ClientAltFire(float Value) {

	local bbPlayer bbP;

	if (Owner.IsA('Bot'))
		return Super.ClientFire(Value);

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
		LoopAnim('Fire1', 0.20 + 0.20 * FireAdjust,0.05);
	else
		LoopAnim('Fire1', 0.22 + 0.22 * FireAdjust,0.05);
}

simulated function PlayAltFiring()
{
	PlayOwnedSound(FireSound, SLOT_None, Pawn(Owner).SoundDampening*4.0);
	LoopAnim('Fire1', 0.20 + 0.20 * FireAdjust,0.05);
}

/* function AltFire( float Value )
{
	bAltFired = true;
	Super.AltFire(Value);
} */

function AltFire( float Value ) {
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
	local bool zzbNN_Combo;
	local bbPlayer bbP;
	local Pawn P;
	local bbPlayer zzbbP;
	local actor zzOther;
	local int oRadius,oHeight;
	local vector zzX,zzY,zzZ,zzStartTrace,zzEndTrace,zzHitLocation,zzHitNormal, HitOffset;

	if (Owner.IsA('Bot'))
		return;

	yModInit();

	bbP = bbPlayer(Owner);
	if (bbP == None)
		return;

//	Owner.MakeNoise(Pawn(Owner).SoundDampening);

	GetAxes(GV,X,Y,Z);
	//StartTrace = Owner.Location + CDO + yMod * Y + FireOffset.Z * Z;
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

		/*

		What is all this for? It works just fine without this, seriously, this actually makes it worse. Don't try to fix what's not broken.

		zzbbP = bbPlayer(Other);
		if (zzbbP != None)
		{
			GetAxes(GV,zzX,zzY,zzZ);
			zzStartTrace = Owner.Location + CDO + yMod * zzY + FireOffset.Z * zzZ;
			zzEndTrace = zzStartTrace + (100000 * vector(GV));
			oRadius = zzbbP.CollisionRadius;
			oHeight = zzbbP.CollisionHeight;
			zzbbP.SetCollisionSize(zzbbP.CollisionRadius * 1, zzbbP.CollisionHeight * 1);
			zzOther = bbP.NN_TraceShot(zzHitLocation,zzHitNormal,zzEndTrace,zzStartTrace,Pawn(Owner));
			zzbbP.SetCollisionSize(oRadius, oHeight);
			//bbP.xxChecked(Other != zzOther);
		}

		*/
	}

	clientHitNormal = HitNormal;
	clientHitLoc = HitLocation;
	NN_ProcessTraceHit(Other, HitLocation, HitNormal, vector(GV),Y,Z);
	bbP.xxNN_Fire(-1, bbP.Location, bbP.Velocity, bbP.zzViewRotation, Other, HitLocation, HitDiff, false);
	if (Other == bbP.zzClientTTarget)
		bbP.zzClientTTarget.TakeDamage(0, Pawn(Owner), HitLocation, 60000.0*vector(GV), MyDamageType);
}

simulated function bool NN_ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{

	local bbPlayer bbP;
	local NN_AlternateSuperShockBeamImpact impact;
	local float is, f;
	local actor a;

	if (Owner.IsA('Bot'))
		return false;

	if (Other==None)
	{
		HitNormal = -X;
		HitLocation = Owner.Location + X*100000.0;
	}


	NN_SpawnEffect(HitLocation, Owner.Location + CDO + (FireOffset.X + 20) * X + Y * yMod + FireOffset.Z * Z, HitNormal);

	is = ImpactSize;
	f = 60000.0;

	bbP = bbPlayer(Owner);

	if (Other.isA('Pawn')) {
		if (bbP.bEnableHitSounds) {
			if (bbPlayer(Other).PlayerReplicationInfo.Team != bbP.PlayerReplicationInfo.Team) {
				//Log("Hitsound:"@bbP.playedHitSound);
				bbP.ClientPlaySound(bbP.playedHitSound);
			}
		}
	}

	/* if ( ST_ShockProj(Other)!=None )
	{
		ST_ShockProj(Other).NN_SuperDuperExplosion(Pawn(Owner));
		zzbNN_Combo = true;
	}
	else
	{ */
	if (bbPlayer(Owner).cShockBeam == 2) {
		if (bbPlayer(Owner).PlayerReplicationInfo.Team == 1) {
			Spawn(class'ut_RingExplosion',,, HitLocation+HitNormal*8,rotator(HitNormal));
			a = Spawn(class'EnergyImpact');
			a.RemoteRole = ROLE_None;
		} else
			Spawn(class'ut_SuperRing2',,, HitLocation+HitNormal*8,rotator(HitNormal));
	} else
		Spawn(class'ut_SuperRing2',,, HitLocation+HitNormal*8,rotator(HitNormal));
	//Spawn(class'NN_AlternateSuperShockBeamImpact',,, HitLocation+HitNormal,rotator(HitNormal));
	//impact.SetProperties(Pawn(Owner).PlayerReplicationInfo.Team,is,ImpactDuration,CustImpactSound,ImpactPitch);

	if (bbPlayer(Owner) != None)
		bbPlayer(Owner).xxClientDemoFix(None, class'ut_SuperRing2',HitLocation+HitNormal*8,,, rotator(HitNormal));
	//}

	//if ( (Other != self) && (Other != Owner) && (bbPlayer(Other) != None) )
	//	bbPlayer(Other).NN_Momentum( 60000.0*X );
	//return zzbNN_Combo;
}

simulated function NN_SpawnEffect(vector HitLocation, vector SmokeLocation, vector HitNormal)
{
	local NN_AlternateSuperShockBeam Smoke;
	local NN_SuperShockBeam Smoke2;
	local Vector DVector;
	local int NumPoints;
	local rotator SmokeRotation;

	if (Owner.IsA('Bot'))
		return;

	DVector = HitLocation - SmokeLocation;
	NumPoints = VSize(DVector)/135.0;
	if ( NumPoints < 1 )
		return;
	SmokeRotation = rotator(DVector);
	SmokeRotation.roll = Rand(65535);

	if (bbPlayer(Owner).cShockBeam == 1) {
		Smoke2 = Spawn(class'NN_SuperShockBeam',Owner,,SmokeLocation,SmokeRotation);
		Smoke2.MoveAmount = DVector/NumPoints;
		Smoke2.NumPuffs = NumPoints - 1;
	}
	else if (bbPlayer(Owner).cShockBeam == 2) {
		Smoke = Spawn(class'NN_AlternateSuperShockBeam',Owner,,SmokeLocation,SmokeRotation);
		Smoke.SetProperties(Pawn(Owner).PlayerReplicationInfo.Team,bbPlayer(Owner).BeamScale,BeamFadeCurve,BeamDuration);
		Smoke.MoveAmount = DVector/NumPoints;
		Smoke.NumPuffs = NumPoints - 1;
	}
	//Smoke2 = Spawn(class'NN_SuperShockBeam',Owner,,SmokeLocation,SmokeRotation);
	if (bbPlayer(Owner) != None)
		bbPlayer(Owner).xxClientDemoFix(None, class'NN_AlternateSuperShockBeam',SmokeLocation,,,SmokeRotation);
}

function TraceFire( float Accuracy )
{
	local bbPlayer bbP;
	local actor NN_Other;
	local bool bShockCombo;
	local NN_ShockProjOwnerHidden NNSP;
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
	bShockCombo = bbP.zzbNN_Special && (NN_Other == None || NN_ShockProjOwnerHidden(NN_Other) != None && NN_Other.Owner != Owner);

	if (bShockCombo && NN_Other == None)
	{
		ForEach AllActors(class'NN_ShockProjOwnerHidden', NNSP)
			if (NNSP.zzNN_ProjIndex == bbP.zzNN_ProjIndex)
				NN_Other = NNSP;

		if (NN_Other == None)
			NN_Other = Spawn(class'NN_ShockProjOwnerHidden', Owner,, bbP.zzNN_HitLoc);
		else
			NN_Other.SetLocation(bbP.zzNN_HitLoc);

		bbP.zzNN_HitActor = NN_Other;
	}

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
		/* NN_HitLoc = bbP.zzNN_HitActor.Location + bbP.zzNN_HitDiff;
		bbP.TraceShot(HitLocation,HitNormal,NN_HitLoc,StartTrace); */
		NN_HitLoc = bbP.zzNN_HitLoc;
		//bbP.zzNN_HitActor.SetLocation(NN_HitLoc - bbP.zzNN_HitDiff);
	}
	else
	{
		bbP.TraceShot(HitLocation,HitNormal,EndTrace,StartTrace);
		//bbP.zzNN_HitActor = bbP.TraceShot(HitLocation,HitNormal,EndTrace,StartTrace);
		//bbP.zzNN_HitActor.SetLocation(NN_HitLoc - bbP.zzNN_HitDiff);
		NN_HitLoc = bbP.zzNN_HitLoc;
	}

	//ProcessTraceHit(bbP.zzNN_HitActor, clientHitLoc, clientHitNormal, vector(AdjustedAim), Y, Z);
	clientHitLoc = NN_HitLoc;
	//clientX = vector(AdjustedAim);
	//bbP.zzNN_LastHitActor = bbP.zzNN_HitActor;
	/* if (!bbP.zzNN_LastHitActor.IsA('bbPlayer'))
		bbP.zzNN_LastHitActor = None; */
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

	SpawnEffect(HitLocation, Owner.Location + CalcDrawOffset() + (FireOffset.X + 20) * X + FireOffset.Y * Y + FireOffset.Z * Z);

	if ( NN_ShockProjOwnerHidden(Other)!=None )
	{
		Other.SetOwner(Owner);
		NN_ShockProjOwnerHidden(Other).SuperDuperExplosion();
		return;
	}
	else if ( ST_ShockProj(Other)!=None )
	{
		ST_ShockProj(Other).SuperDuperExplosion();
		return;
	}
	else if (bNewNet && !bAltFired)
	{
		DoSuperRing2(PlayerPawn(Owner), HitLocation, HitNormal);
	}
	else
	{
		Spawn(class'ut_SuperRing2',,, HitLocation+HitNormal*8,rotator(HitNormal));
	}

	if ( (Other != self) && (Other != Owner) && (Other != None) )
	{
		if (Other.IsA('bbPlayer') && bbPlayer(Other).PlayerReplicationInfo.Team == bbP.PlayerReplicationInfo.Team) {
			//Log("Same team player boosting player");
			Other.TakeDamage(HitDamage, PawnOwner, HitLocation, 60000.0*X, MyDamageType);
			bbP.zzNN_LastHitActor = None;
		}
		ClientX = X;
	}
}

event Tick(float DeltaTime) {
	local bbPlayer bbPC;
	// If they both hit, they both die
	ForEach AllActors(class'bbPlayer', bbPC) {
		if (bbPC.zzNN_LastHitActor != None) {
			bbPC.zzNN_LastHitActor.TakeDamage(clientDamage, bbPC, clientHitLoc, 60000.0*ClientX, MyDamageType);
			//Log("Got a client hit! Killing:"@bbPC.zzNN_LastHitActor);
			bbPC.zzNN_LastHitActor = None;
			clientHitLoc = vect(0,0,0);
		}
	}
	Super.Tick(DeltaTime);
}

simulated function DoSuperRing2(PlayerPawn Pwner, vector HitLocation, vector HitNormal)
{
	local PlayerPawn P;
	local Actor CR;

	if (Owner.IsA('Bot'))
		return;

	if (RemoteRole < ROLE_Authority) {
		//for (P = Level.PawnList; P != None; P = P.NextPawn)
		ForEach AllActors(class'PlayerPawn', P)
			if (P != Pwner) {
				CR = P.Spawn(class'ut_SuperRing2',P,, HitLocation+HitNormal*8,rotator(HitNormal));
				CR.bOnlyOwnerSee = True;
			}
	}
}

function SpawnEffect(vector HitLocation, vector SmokeLocation)
{
	local NN_SuperShockBeam Smoke,shock;
	local Vector DVector;
	local int NumPoints;
	local rotator SmokeRotation;

	if (Owner.IsA('Bot'))
	{
		Super.SpawnEffect(HitLocation, SmokeLocation);
		return;
	}

	DVector = HitLocation - SmokeLocation;
	NumPoints = VSize(DVector)/135.0;
	if ( NumPoints < 1 )
		return;
	SmokeRotation = rotator(DVector);
	SmokeRotation.roll = Rand(65535);

	if (bNewNet && !bAltFired)
		Smoke = Spawn(class'NN_SuperShockBeamOwnerHidden',Owner,,SmokeLocation,SmokeRotation);
	else
		Smoke = Spawn(class'NN_SuperShockBeam',,,SmokeLocation,SmokeRotation);
	Smoke.MoveAmount = DVector/NumPoints;
	Smoke.NumPuffs = NumPoints - 1;
//	Log("MoveAmount="$Smoke.MoveAmount);
//	Log("NumPuffs="$Smoke.NumPuffs);
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
	 MyDamageType=jolted
	 bHitTimer=False
}
