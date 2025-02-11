// ===============================================================
// Stats.NN_SniperRifle: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class NN_SniperRifle extends SniperRifle;

var bool bNewNet;		// Self-explanatory lol
var Rotator GV;
var Vector CDO;
var float yMod;
var float BodyHeight;
var int zzWin;

enum EZoomState {
	ZS_None,
	ZS_Zooming,
	ZS_Zoomed,
	ZS_Reset
};
var EZoomState ZoomState;

var IGPlus_WeaponImplementation WImp;
var WeaponSettingsRepl WSettings;


simulated final function WeaponSettingsRepl FindWeaponSettings() {
	local WeaponSettingsRepl S;

	foreach AllActors(class'WeaponSettingsRepl', S)
		return S;

	return none;
}

simulated final function WeaponSettingsRepl GetWeaponSettings() {
	if (WSettings != none)
		return WSettings;

	WSettings = FindWeaponSettings();
	return WSettings;
}

simulated function PostBeginPlay() {
	super(SniperRifle).PostBeginPlay();

	foreach AllActors(class'IGPlus_WeaponImplementation', WImp)
		break;
}

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
	local bool Result;

	if (Owner.IsA('Bot'))
		return Super.ClientFire(Value);

	class'NN_WeaponFunctions'.static.IGPlus_BeforeClientFire(self);
	
	bbP = bbPlayer(Owner);
	if (Role < ROLE_Authority && bbP != None && bNewNet)
	{
		if (bbP.ClientCannotShoot() || bbP.Weapon != Self) {
			class'NN_WeaponFunctions'.static.IGPlus_AfterClientFire(self);
			return false;
		}
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
		}
	}
	Result = Super.ClientFire(Value);

	class'NN_WeaponFunctions'.static.IGPlus_AfterClientFire(self);

	return Result;
}

simulated function bool ClientAltFire( float Value ) {
	if (Owner.IsA('PlayerPawn') == false) {
		Pawn(Owner).bFire = 1;
		Pawn(Owner).bAltFire = 0;
		Global.Fire(0);
	} else {
		if (Level.NetMode != NM_Client)
			GotoState('Idle');
	}

	return true;
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

state ClientFiring
{
	simulated function AnimEnd() {
		local bbPlayer O;
		O = bbPlayer(Owner);
		if (O != none)
			O.ClientDebugMessage("Sniper AnimEnd"@O.ViewRotation.Yaw@O.ViewRotation.Pitch@O.bAltFire);

		if ( (Pawn(Owner) == None)
			|| ((AmmoType != None) && (AmmoType.AmmoAmount <= 0)) )
		{
			PlayIdleAnim();
			GotoState('');
		}
		else if ( !bCanClientFire )
			GotoState('');
		else if ( Pawn(Owner).bFire != 0 )
			Global.ClientFire(0);
		// else if ( Pawn(Owner).bAltFire != 0 ) // SniperRifle has no AltFire
		// 	Global.ClientAltFire(0);
		else
		{
			PlayIdleAnim();
			GotoState('');
		}
	}
}

simulated function NN_TraceFire(optional float Accuracy)
{
	local vector HitLocation, HitDiff, HitNormal, StartTrace, EndTrace, X,Y,Z;
	local actor Other;
	local bbPlayer bbP;
	local bool bHeadshot;

	if (Owner.IsA('Bot'))
		return;

	yModInit();

	bbP = bbPlayer(Owner);
	if (bbP == None)
		return;

	GetAxes(GV,X,Y,Z);
	StartTrace = Owner.Location + bbP.EyeHeight * vect(0,0,1);
	EndTrace = StartTrace + (100000 * X) + Accuracy * (FRand() - 0.5)* Y * 1000 + Accuracy * (FRand() - 0.5) * Z * 1000;

	Other = bbP.NN_TraceShot(HitLocation,HitNormal,EndTrace,StartTrace,bbP);
	if (Other.IsA('Pawn'))
		HitDiff = HitLocation - Other.Location;

	bHeadshot = NN_ProcessTraceHit(Other, HitLocation, HitNormal, X,Y,Z);
	bbP.xxNN_Fire(Level.TimeSeconds, -1, bbP.Location, bbP.Velocity, bbP.ViewRotation, Other, HitLocation, HitDiff, bHeadshot);
}

simulated function bool NN_ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	if (Owner.IsA('Bot'))
		return false;

	NN_DoShellCase(PlayerPawn(Owner), Owner.Location + CDO + 30 * X + (2.8 * yMod+5.0) * Y - Z * 1, X, Y, Z);

	if (Other == Level || Other.IsA('Mover')) {
		Spawn(class'UT_HeavyWallHitEffect',,, HitLocation+HitNormal, Rotator(HitNormal));
		if (bbPlayer(Owner) != None)
			bbPlayer(Owner).xxClientDemoFix(None, class'UT_HeavyWallHitEffect', HitLocation+HitNormal,,, Rotator(HitNormal));
	} else if ((Other != self) && (Other != Owner) && (Other != None)) {
		if (Other.bIsPawn && CheckHeadShot(Pawn(Other), HitLocation, X)) {
			class'bbPlayerStatics'.static.PlayClientHitResponse(Pawn(Owner), Other, GetWeaponSettings().SniperHeadshotDamage, AltDamageType);
			return true;
		}

		if ( !Other.bIsPawn && !Other.IsA('Carcass') )
			spawn(class'UT_SpriteSmokePuff',,,HitLocation+HitNormal*9);
	}
	class'bbPlayerStatics'.static.PlayClientHitResponse(Pawn(Owner), Other, GetWeaponSettings().SniperDamage, MyDamageType);
	return false;
}

simulated function bool CheckHeadShot(Pawn P, vector HitLocation, vector BulletDir) {
	if (GetWeaponSettings().SniperUseReducedHitbox == false) {
		HitLocation += (BulletDir * (P.CollisionRadius * 0.5));
		return (HitLocation.Z - P.Location.Z > GetMinHeadshotZ(P));
	}

	return WImp.CheckHeadShot(P, HitLocation, BulletDir);
}

simulated function float GetMinHeadshotZ(Pawn Other) {
	local bbPlayer P;

	P = bbPlayer(Other);
	if (P != none) {
		if (P.Role < ROLE_Authority)
			return (BodyHeight - 0.70 * P.DuckFractionRepl/255.0) * P.CollisionHeight;
		else
			return (BodyHeight - 0.70 * P.DuckFraction) * P.CollisionHeight;
	}


	return BodyHeight * Other.CollisionHeight;
}

function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	local vector realLoc;
	local Pawn PawnOwner, POther;
	local PlayerPawn PPOther;
	local bbPlayer bbP;
	local vector Momentum;

	if (Owner.IsA('Bot'))
	{
		Super.ProcessTraceHit(Other, HitLocation, HitNormal, X, Y, Z);
		return;
	}

	bbP = bbPlayer(Owner);
	if (bbP == None || !bNewNet)
	{
		Super.ProcessTraceHit(Other, HitLocation, HitNormal, X,Y,Z);
		return;
	}

	PawnOwner = Pawn(Owner);
	POther = Pawn(Other);
	PPOther = PlayerPawn(Other);

	realLoc = Owner.Location + CalcDrawOffset();
	DoShellCase(PlayerPawn(Owner), realLoc + 20 * X + FireOffset.Y * Y + Z, X,Y,Z);

	if (Other == Level)
	{
		if (bNewNet)
			Spawn(class'NN_UT_HeavyWallHitEffectOwnerHidden',Owner,, HitLocation+HitNormal, Rotator(HitNormal));
		else
			Spawn(class'UT_HeavyWallHitEffect',,, HitLocation+HitNormal, Rotator(HitNormal));
	}
	else if ( (Other != self) && (Other != Owner) && (Other != None) )
	{
		if ( Other.bIsPawn )
			Other.PlaySound(Sound 'ChunkHit',, 4.0,,100);

		if ((bbP.zzbNN_Special || !bNewNet &&
			Other.bIsPawn && (HitLocation.Z - Other.Location.Z > BodyHeight * Other.CollisionHeight)
			&& (instigator.IsA('PlayerPawn') || (instigator.IsA('Bot') && !Bot(Instigator).bNovice))))
		{
			Other.TakeDamage(
				GetWeaponSettings().SniperHeadshotDamage,
				PawnOwner,
				HitLocation,
				GetWeaponSettings().SniperHeadshotMomentum * 35000 * X,
				AltDamageType);
		}
		else
		{
			if (Other.bIsPawn)
				Momentum = GetWeaponSettings().SniperMomentum * 30000 * X;
			else
				Momentum = 30000 * X;

			Other.TakeDamage(
				GetWeaponSettings().SniperDamage,
				PawnOwner,
				HitLocation,
				Momentum,
				MyDamageType);
		}
		if ( !Other.bIsPawn && !Other.IsA('Carcass') )
		{
			if (bNewNet)
				spawn(class'NN_UT_SpriteSmokePuffOwnerHidden',Owner,,HitLocation+HitNormal*9);
			else
				spawn(class'UT_SpriteSmokePuff',,,HitLocation+HitNormal*9);
		}
	}
}

simulated function NN_DoShellCase(PlayerPawn Pwner, vector HitLoc, Vector X, Vector Y, Vector Z) {
	local UT_ShellCase s;

	s = Spawn(class'UT_ShellCase', Pwner,, HitLoc);
	if ( s != None )
	{
		s.DrawScale = 2.0;
		s.Eject(((FRand()*0.3+0.4)*X + (FRand()*0.2+0.2)*Y + (FRand()*0.3+1.0) * Z)*160);
		s.RemoteRole = ROLE_None;
	}
}

simulated function DoShellCase(PlayerPawn Pwner, vector HitLoc, Vector X, Vector Y, Vector Z)
{
	local UT_Shellcase s;

	if (Owner.IsA('Bot'))
		return;

	if (RemoteRole < ROLE_Authority) {
		s = Spawn(class'NN_UT_ShellCaseOwnerHidden', Pwner,, HitLoc);
		if ( s != None ) {
			s.DrawScale = 2.0;
			s.Eject(((FRand()*0.3+0.4)*X + (FRand()*0.2+0.2)*Y + (FRand()*0.3+1.0) * Z)*160);
		}
	}
}

function TraceFire( float Accuracy )
{
	local bbPlayer bbP;
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

	Owner.MakeNoise(bbP.SoundDampening);
	GetAxes(bbP.zzNN_ViewRot,X,Y,Z);
	StartTrace = Owner.Location + bbP.EyeHeight * vect(0,0,1);
	AdjustedAim = bbP.AdjustAim(1000000, StartTrace, 2*AimError, False, False);
	X = vector(AdjustedAim);
	EndTrace = StartTrace + 100000 * X + Accuracy * (FRand() - 0.5)* Y * 1000 + Accuracy * (FRand() - 0.5) * Z * 1000;

	NN_HitLoc = bbP.zzNN_HitLoc;
	if (bbP.zzNN_HitActor != None && (bbP.zzNN_HitActor.IsA('Pawn') || bbP.zzNN_HitActor.IsA('Projectile')) )
	{
		NN_HitLoc = bbP.zzNN_HitActor.Location + bbP.zzNN_HitDiff;
	}
	
	// determine HitNormal
	bbP.TraceShot(HitLocation,HitNormal,EndTrace,StartTrace);

	// apply damage
	ProcessTraceHit(bbP.zzNN_HitActor, NN_HitLoc, HitNormal, X,Y,Z);
	bbP.zzNN_HitActor = None;
}

function SetSwitchPriority(pawn Other)
{
	Class'NN_WeaponFunctions'.static.SetSwitchPriority( Other, self, 'SniperRifle');
}

simulated function PlaySelect ()
{
	Class'NN_WeaponFunctions'.static.PlaySelect( self);
}

simulated function TweenDown ()
{
	Class'NN_WeaponFunctions'.static.TweenDown( self);

	if (Owner.IsA('PlayerPawn') && PlayerPawn(Owner).Player.IsA('ViewPort')) {
		ZoomState = ZS_None;
		PlayerPawn(Owner).EndZoom();
	}
}

simulated function AnimEnd ()
{
	Class'NN_WeaponFunctions'.static.AnimEnd( self);
}

simulated function PlayFiring()
{
	PlayOwnedSound(FireSound, SLOT_None, Pawn(Owner).SoundDampening*3.0);
	PlayAnim(FireAnims[Rand(5)], 0.66666666 / GetWeaponSettings().SniperReloadTime, 0.05);

	if ( (PlayerPawn(Owner) != None)
		&& (PlayerPawn(Owner).DesiredFOV == PlayerPawn(Owner).DefaultFOV) )
		bMuzzleFlash++;
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

simulated function Tick(float DeltaTime) {
	if (Owner != none &&
		Owner.IsA('PlayerPawn') &&
		bCanClientFire
	) {
		switch (ZoomState) {
		case ZS_None:
			if (Pawn(Owner).bAltFire != 0) {
				if (PlayerPawn(Owner).Player.IsA('ViewPort'))
					PlayerPawn(Owner).StartZoom();
				SetTimer(0.2, true);
				ZoomState = ZS_Zooming;
			}
			break;
		case ZS_Zooming:
			if (Pawn(Owner).bAltFire == 0) {
				if (PlayerPawn(Owner).Player.IsA('ViewPort'))
					PlayerPawn(Owner).StopZoom();
				ZoomState = ZS_Zoomed;
			}
			break;
		case ZS_Zoomed:
			if (Pawn(Owner).bAltFire != 0) {
				if (PlayerPawn(Owner).Player.IsA('ViewPort'))
					PlayerPawn(Owner).EndZoom();
				SetTimer(0.0, false);
				ZoomState = ZS_Reset;
			}
			break;
		case ZS_Reset:
			if (Pawn(Owner).bAltFire == 0) {
				ZoomState = ZS_None;
			}
			break;
		}
	}
}

state Idle
{
Begin:
	bPointing=False;
	if ( (AmmoType != None) && (AmmoType.AmmoAmount<=0) ) 
		Pawn(Owner).SwitchToBestWeapon();  //Goto Weapon that has Ammo
	// if ( Pawn(Owner).bFire!=0 ) Fire(0.0);
	// if ( Pawn(Owner).bAltFire!=0 ) AltFire(0.0);	
	Disable('AnimEnd');
	PlayIdleAnim();
}

// NOTE: this entire function was copied from Botpack.TournamentWeapon
// comments within are IG+ specific and prevent the weapon from getting stuck.
// Finish a firing sequence
function Finish()
{
	local Pawn PawnOwner;
	local bool bForce, bForceAlt;


	if ( (Pawn(Owner).bFire!=0) && (FRand() < 0.6) )
		Timer();

	bForce = bForceFire;
	bForceAlt = bForceAltFire;
	bForceFire = false;
	bForceAltFire = false;

	if ( bChangeWeapon )
	{
		GotoState('DownWeapon');
		return;
	}

	PawnOwner = Pawn(Owner);
	if ( PawnOwner == None )
		return;
	if ( PlayerPawn(Owner) == None )
	{
		if ( (AmmoType != None) && (AmmoType.AmmoAmount<=0) )
		{
			PawnOwner.StopFiring();
			PawnOwner.SwitchToBestWeapon();
			if ( bChangeWeapon )
				GotoState('DownWeapon');
		}
		else if ( (PawnOwner.bFire != 0) && (FRand() < RefireRate) )
			Global.Fire(0);
		else if ( (PawnOwner.bAltFire != 0) && (FRand() < AltRefireRate) )
			Global.AltFire(0);	
		else 
		{
			PawnOwner.StopFiring();
			GotoState('Idle');
		}
		return;
	}
	// if ( ((AmmoType != None) && (AmmoType.AmmoAmount<=0)) || (PawnOwner.Weapon != self) )
	// 	GotoState('Idle');
	// else if ( (PawnOwner.bFire!=0) || bForce )
	// 	Global.Fire(0);
	// else if ( (PawnOwner.bAltFire!=0) || bForceAlt ) // SniperRifle has no AltFire
	// 	Global.AltFire(0);
	// else
		GotoState('Idle');
}

defaultproperties
{
    bNewNet=True
    BodyHeight=0.66
    zzWin=24
}
