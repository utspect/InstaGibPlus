// ===============================================================
// Stats.NN_ShockRifle: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class NN_ShockRifle extends ShockRifle;

var bool bNewNet;								// Self-explanatory lol
var Rotator GV;
var Vector CDO;
var float yMod;
var float LastFiredTime;

// For Special Shock Beam
var int HitCounter;

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
	if (bbPlayer(Owner) != None && Owner.Role == ROLE_AutonomousProxy)
		GV = bbPlayer(Owner).ViewRotation;

	if (PlayerPawn(Owner) == None)
		return;

	yMod = PlayerPawn(Owner).Handedness;
	if (yMod != 2.0)
		yMod *= Default.FireOffset.Y;
	else
		yMod = 0;

	CDO = class'NN_WeaponFunctions'.static.IGPlus_CalcDrawOffset(PlayerPawn(Owner), self);
}

simulated function bool ClientFire(float Value)
{
	local bbPlayer bbP;

	if (Owner.IsA('Bot'))
		return Super.ClientFire(Value);

	bbP = bbPlayer(Owner);
	if (Role < ROLE_Authority && bbP != None && bNewNet)
	{
		if (bbP.ClientCannotShoot() || bbP.Weapon != Self || Level.TimeSeconds - LastFiredTime < 0.4)
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

simulated function NN_TraceFire()
{
	local vector HitLocation, HitDiff, HitNormal, StartTrace, EndTrace, X,Y,Z;
	local actor Other;
	local bool zzbNN_Combo;
	local bbPlayer bbP;
	local bbPlayer zzbbP;
	local actor zzOther;
	local int oRadius,oHeight;
	local vector zzX,zzY,zzZ,zzStartTrace,zzEndTrace,zzHitLocation,zzHitNormal;

	if (Owner.IsA('Bot'))
		return;

	yModInit();

	bbP = bbPlayer(Owner);
	if (bbP == None)
		return;

//	Owner.MakeNoise(Pawn(Owner).SoundDampening);
	GetAxes(GV,X,Y,Z);
	StartTrace = Owner.Location + CDO + yMod * Y + FireOffset.Z * Z;
	EndTrace = StartTrace + (100000 * vector(GV));

	//for (P = Level.PawnList; P != None; P = P.NextPawn)
	//	P.SetCollisionSize(P.CollisionRadius * ShockRadius / 100, P.CollisionHeight);

	Other = bbP.NN_TraceShot(HitLocation,HitNormal,EndTrace,StartTrace,Pawn(Owner));
	if (Other.IsA('Pawn'))
	{
		HitDiff = HitLocation - Other.Location;

		zzbbP = bbPlayer(Other);
		if (zzbbP != None)
		{
			GetAxes(GV,zzX,zzY,zzZ);
			zzStartTrace = Owner.Location + CDO + yMod * zzY + FireOffset.Z * zzZ;
			zzEndTrace = zzStartTrace + (100000 * vector(GV));
			oRadius = zzbbP.CollisionRadius;
			oHeight = zzbbP.CollisionHeight;
			zzbbP.SetCollisionSize(zzbbP.CollisionRadius * 0.85, zzbbP.CollisionHeight * 0.85);
			zzOther = bbP.NN_TraceShot(zzHitLocation,zzHitNormal,zzEndTrace,zzStartTrace,Pawn(Owner));
			zzbbP.SetCollisionSize(oRadius, oHeight);
			//bbP.xxChecked(Other != zzOther);
		}
	}

	zzbNN_Combo = NN_ProcessTraceHit(Other, HitLocation, HitNormal, vector(GV),Y,Z);
	if (zzbNN_Combo)
		bbP.xxNN_Fire(NN_ShockProj(Other).zzNN_ProjIndex, bbP.Location, bbP.Velocity, bbP.ViewRotation, Other, HitLocation, HitDiff, true);
	else
		bbP.xxNN_Fire(-1, bbP.Location, bbP.Velocity, bbP.ViewRotation, Other, HitLocation, HitDiff, false);
	if (Other == bbP.zzClientTTarget)
		bbP.zzClientTTarget.TakeDamage(0, Pawn(Owner), HitLocation, 60000.0*vector(GV), MyDamageType);

	//for (P = Level.PawnList; P != None; P = P.NextPawn)
	//	P.SetCollisionSize(P.Default.CollisionRadius, P.CollisionHeight);
}

simulated function bool NN_ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	local bool zzbNN_Combo;

	if (Owner.IsA('Bot'))
		return false;

	if (Other==None)
	{
		HitNormal = -X;
		HitLocation = Owner.Location + X*100000.0;
	}

	NN_SpawnEffect(HitLocation, Owner.Location + CDO + (FireOffset.X + 20) * X + Y * yMod + FireOffset.Z * Z, HitNormal);

	if ( NN_ShockProj(Other)!=None )
	{
		NN_ShockProj(Other).NN_SuperExplosion(Pawn(Owner));
		zzbNN_Combo = true;
	}
	else
	{
		Spawn(class'ut_RingExplosion5',,, HitLocation+HitNormal*8,rotator(HitNormal));
		if (bbPlayer(Owner) != None)
			bbPlayer(Owner).xxClientDemoFix(None, class'ut_RingExplosion5',HitLocation+HitNormal*8,,, rotator(HitNormal));
	}
	return zzbNN_Combo;
}

simulated function NN_SpawnEffect(vector HitLocation, vector SmokeLocation, vector HitNormal)
{
	local ShockBeam Smoke;
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

	Smoke = Spawn(class'NN_ShockBeam',Owner,,SmokeLocation,SmokeRotation);
	Smoke.MoveAmount = DVector/NumPoints;
	Smoke.NumPuffs = NumPoints - 1;
	if (bbPlayer(Owner) != None)
		bbPlayer(Owner).xxClientDemoFix(None, class'NN_ShockBeam',SmokeLocation,,,SmokeRotation);
}

function Fire ( float Value )
{
	local bbPlayer bbP;

	if (Owner.IsA('Bot'))
	{
		Super.Fire(Value);
		return;
	}

	bbP = bbPlayer(Owner);
	if (bbP != None && bNewNet && Value < 1)
		return;
	Super.Fire(Value);
}

function AltFire( float Value )
{
	local actor HitActor;
	local vector HitLocation, HitNormal, Start;
	local bbPlayer bbP;
	local NN_ShockProjOwnerHidden NNSP;

	if (Owner.IsA('Bot'))
	{
		Super.AltFire(Value);
		return;
	}

	bbP = bbPlayer(Owner);
	if (bbP != None && bNewNet && Value < 1)
		return;

	if ( Owner == None )
		return;

	if ( Owner.IsA('Bot') ) //make sure won't blow self up
	{
		Start = Owner.Location + CalcDrawOffset() + FireOffset.Z * vect(0,0,1);
		if ( Pawn(Owner).Enemy != None )
			HitActor = Trace(HitLocation, HitNormal, Start + 250 * Normal(Pawn(Owner).Enemy.Location - Start), Start, false, vect(12,12,12));
		else
			HitActor = self;
		if ( HitActor != None )
		{
			Global.Fire(Value);
			return;
		}
	}
	if ( AmmoType != None && AmmoType.UseAmmo(1) )
	{
		GotoState('AltFiring');
		bCanClientFire = true;
		if ( Owner.IsA('Bot') )
		{
			if ( Owner.IsInState('TacticalMove') && (Owner.Target == Pawn(Owner).Enemy)
			 && (Owner.Physics == PHYS_Walking) && !Bot(Owner).bNovice
			 && (FRand() * 6 < Pawn(Owner).Skill) )
				Pawn(Owner).SpecialFire();
		}
		bPointing=True;
		ClientAltFire(value);
		if (bNewNet)
		{
			NNSP = NN_ShockProjOwnerHidden(ProjectileFire(Class'NN_ShockProjOwnerHidden', AltProjectileSpeed, bAltWarnTarget));
			if (NNSP != None)
			{
				NNSP.NN_OwnerPing = float(Owner.ConsoleCommand("GETPING"));
				if (bbP != None)
					NNSP.zzNN_ProjIndex = bbP.xxNN_AddProj(NNSP);
			}
		}
		else
		{
			Pawn(Owner).PlayRecoil(FiringSpeed);
			ProjectileFire(AltProjectileClass, AltProjectileSpeed, bAltWarnTarget);
		}
	}
}

state ClientFiring
{
	simulated function bool ClientFire(float Value)
	{
		local float MinTapTime;

		if (Owner.IsA('Bot'))
			return Super.ClientFire(Value);

		if (bNewNet)
			MinTapTime = 0.4;
		else
			MinTapTime = 0.2;

		if ( Level.TimeSeconds - TapTime < MinTapTime )
			return false;
		bForceFire = bForceFire || ( bCanClientFire && (Pawn(Owner) != None) && (AmmoType.AmmoAmount > 0) );
		return bForceFire;
	}

	simulated function bool ClientAltFire(float Value)
	{
		local float MinTapTime;

		if (Owner.IsA('Bot'))
			return Super.ClientAltFire(Value);

		if (bNewNet)
			MinTapTime = 0.4;
		else
			MinTapTime = 0.2;

		if ( Level.TimeSeconds - TapTime < MinTapTime )
			return false;
		bForceAltFire = bForceAltFire || ( bCanClientFire && (Pawn(Owner) != None) && (AmmoType.AmmoAmount > 0) );
		return bForceAltFire;
	}

	simulated function AnimEnd()
	{
		local bool bForce, bForceAlt;

		if (Owner.IsA('Bot'))
		{
			Super.AnimEnd();
			return;
		}

		bForce = bForceFire;
		bForceAlt = bForceAltFire;
		bForceFire = false;
		bForceAltFire = false;

		if ( bNewNet && Level.NetMode == NM_Client && bCanClientFire && (PlayerPawn(Owner) != None) && (AmmoType.AmmoAmount > 0) )
		{
			if ( bForce || (Pawn(Owner).bFire != 0) )
			{
				Global.ClientFire(1);
				return;
			}
			else if ( bForceAlt || (Pawn(Owner).bAltFire != 0) )
			{
				Global.ClientAltFire(1);
				return;
			}
		}
		Super.AnimEnd();
	}
}

state ClientAltFiring
{
	simulated function AnimEnd()
	{
		Super.AnimEnd();
		if (Owner.IsA('Bot'))
			return;
		if (!bNewNet || Level.NetMode != NM_Client)
			return;
		if ( bForceFire || (PlayerPawn(Owner).bFire != 0) )
			Global.ClientFire(1);
		else if ( bForceAltFire || (PlayerPawn(Owner).bAltFire != 0) )
			Global.ClientAltFire(1);
	}
}

function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn)
{
	local Vector Start, X,Y,Z;
	local PlayerPawn PlayerOwner;
	local bbPlayer bbP;

	if (Owner.IsA('Bot'))
		return Super.ProjectileFire(ProjClass, ProjSpeed, bWarn);

	PlayerOwner = PlayerPawn(Owner);
	bbP = bbPlayer(Owner);

	Owner.MakeNoise(Pawn(Owner).SoundDampening);
	if (bNewNet && bbP != None)
	{
		if (Level.TimeSeconds - LastFiredTime < 0.4)
			return None;
		GetAxes(bbP.zzNN_ViewRot,X,Y,Z);
		if (Mover(bbP.Base) == None)
			Start = bbP.zzNN_ClientLoc + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;
		else
			Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;
	}
	else
	{
		GetAxes(Pawn(Owner).ViewRotation,X,Y,Z);
		Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;
	}
	AdjustedAim = pawn(owner).AdjustAim(ProjSpeed, Start, AimError, True, bWarn);

	LastFiredTime = Level.TimeSeconds;
	return Spawn(ProjClass,Owner,, Start,AdjustedAim);
}

simulated function Projectile NN_ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn)
{
	local Vector Start, X,Y,Z;
	local PlayerPawn PlayerOwner;
	local Projectile Proj;
	local NN_ShockProj ST_Proj;
	local int ProjIndex;
	local bbPlayer bbP;

	if (Owner.IsA('Bot'))
		return None;

	yModInit();

	bbP = bbPlayer(Owner);
	if (bbP == None || (Level.TimeSeconds - LastFiredTime) < 0.4)
		return None;

	GetAxes(GV,X,Y,Z);
	Start = Owner.Location + CDO + FireOffset.X * X + yMod * Y + FireOffset.Z * Z;
	if ( PlayerOwner != None )
		PlayerOwner.ClientInstantFlash( -0.4, vect(450, 190, 650));

	LastFiredTime = Level.TimeSeconds;
	Proj = Spawn(ProjClass,Owner,, Start,GV);
	ST_Proj = NN_ShockProj(Proj);
	ProjIndex = bbP.xxNN_AddProj(Proj);
	if (ST_Proj != None)
		ST_Proj.zzNN_ProjIndex = ProjIndex;
	bbP.xxNN_AltFire(ProjIndex, bbP.Location, bbP.Velocity, bbP.ViewRotation);
	bbP.xxClientDemoFix(ST_Proj, Class'ShockProj', Start, ST_Proj.Velocity, Proj.Acceleration, GV);
}

simulated function bool ClientAltFire(float Value)
{
	local bbPlayer bbP;

	if (Owner.IsA('Bot'))
		return Super.ClientAltFire(Value);

	bbP = bbPlayer(Owner);
	if (Role < ROLE_Authority && bbP != None && bNewNet)
	{
		if (bbP.ClientCannotShoot() || bbP.Weapon != Self || Level.TimeSeconds - LastFiredTime < 0.4)
			return false;
		if ( AmmoType.AmmoAmount > 0 )
		{
			Instigator = Pawn(Owner);
			GotoState('AltFiring');
			bCanClientFire = true;
			Pawn(Owner).PlayRecoil(FiringSpeed);
			bPointing=True;
			NN_ProjectileFire(AltProjectileClass, AltProjectileSpeed, bAltWarnTarget);
			LastFiredTime = Level.TimeSeconds;
		}
	}
	return Super.ClientAltFire(Value);
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
	if (bbP == None || !bNewNet)
	{
		Super.TraceFire(Accuracy);
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
		NN_HitLoc = bbP.zzNN_HitActor.Location + bbP.zzNN_HitDiff;
		bbP.TraceShot(HitLocation,HitNormal,NN_HitLoc,StartTrace);
	}
	else
	{
		bbP.zzNN_HitActor = bbP.TraceShot(HitLocation,HitNormal,EndTrace,StartTrace);
		NN_HitLoc = bbP.zzNN_HitLoc;
	}

	ProcessTraceHit(bbP.zzNN_HitActor, NN_HitLoc, HitNormal, vector(AdjustedAim),Y,Z);
	bbP.zzNN_HitActor = None;
	Tracked = None;
	bBotSpecialMove = false;
}

function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	local PlayerPawn PlayerOwner;
	local Pawn PawnOwner;

	if (Owner.IsA('Bot'))
	{
		Super.ProcessTraceHit(Other, HitLocation, HitNormal, X, Y, Z);
		return;
	}

	PawnOwner = Pawn(Owner);

	if (Other==None)
	{
		HitNormal = -X;
		HitLocation = Owner.Location + X*10000.0;
	}

	PlayerOwner = PlayerPawn(Owner);

	SpawnEffect(HitLocation, Owner.Location + CalcDrawOffset() + (FireOffset.X + 20) * X + FireOffset.Y * Y + FireOffset.Z * Z);

	if ( NN_ShockProjOwnerHidden(Other)!=None )
	{
		AmmoType.UseAmmo(1);
		Other.SetOwner(Owner);
		NN_ShockProjOwnerHidden(Other).SuperExplosion();
		return;
	}
	else if ( NN_ShockProj(Other)!=None )
	{
		AmmoType.UseAmmo(1);
		NN_ShockProj(Other).SuperExplosion();
		return;
	}
	else if (bNewNet)
	{
		DoRingExplosion5(PlayerPawn(Owner), HitLocation, HitNormal);
	}
	else
	{
		Spawn(class'ut_RingExplosion5',,, HitLocation+HitNormal*8,rotator(HitNormal));
	}

	/* if ( (Other != self) && (Other != Owner) && (Other != None) )
	{
		Other.TakeDamage(class'UTPure'.default.ShockDamagePri, PawnOwner, HitLocation, 60000.0*X, MyDamageType);
	} */

	if (Pawn(Other) != None && Other != Owner && Pawn(Other).Health > 0)
	{	// We hit a pawn that wasn't the owner or dead. (How can you hit yourself? :P)
		HitCounter++;						// +1 hit
		if (HitCounter == 3)
		{	// Wowsers!
			HitCounter = 0;
		}
	}
	else
		HitCounter = 0;
}

simulated function DoRingExplosion5(PlayerPawn Pwner, vector HitLocation, vector HitNormal)
{
	local PlayerPawn P;
	local Actor CR;

	if (Owner.IsA('Bot'))
		return;

	if (RemoteRole < ROLE_Authority) {
		//for (P = Level.PawnList; P != None; P = P.NextPawn)
		ForEach AllActors(class'PlayerPawn', P)
			if (P != Pwner) {
				CR = P.Spawn(class'ut_RingExplosion5',P,, HitLocation+HitNormal*8,rotator(HitNormal));
				CR.bOnlyOwnerSee = True;
			}
	}
}

function SpawnEffect(vector HitLocation, vector SmokeLocation)
{
	local ShockBeam Smoke;
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

	if (bNewNet)
		Smoke = Spawn(class'NN_ShockBeamOwnerHidden',Owner,,SmokeLocation,SmokeRotation);
	else
		Smoke = Spawn(class'ShockBeam',,,SmokeLocation,SmokeRotation);
	Smoke.MoveAmount = DVector/NumPoints;
	Smoke.NumPuffs = NumPoints - 1;
}

function SetSwitchPriority(pawn Other)
{
	Class'NN_WeaponFunctions'.static.SetSwitchPriority( Other, self, 'ShockRifle');
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
	function AltFire(float F)
	{
		if (Owner.IsA('Bot'))
		{
			Super.AltFire(F);
			return;
		}
		if (F > 0 && bbPlayer(Owner) != None)
			Global.AltFire(F);
	}
}

state AltFiring
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
	function AltFire(float F)
	{
		if (Owner.IsA('Bot'))
		{
			Super.AltFire(F);
			return;
		}
		if (F > 0 && bbPlayer(Owner) != None)
			Global.AltFire(F);
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
	function AltFire(float F)
	{
		if (Owner.IsA('Bot'))
		{
			Super.AltFire(F);
			return;
		}
		if (F > 0 && bbPlayer(Owner) != None)
			Global.AltFire(F);
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
	AltProjectileClass=Class'NN_ShockProj'
	bNewNet=True
}