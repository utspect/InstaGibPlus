// ===============================================================
// Stats.ST_SniperRifle: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_SniperRifle extends SniperRifle;

var ST_Mutator STM;

enum EZoomState {
	ZS_None,
	ZS_Zooming,
	ZS_Zoomed,
	ZS_Reset
};
var EZoomState ZoomState;

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

function PostBeginPlay()
{
	Super.PostBeginPlay();

	ForEach AllActors(Class'ST_Mutator', STM)
		break;		// Find master :D
}

function TraceFire(float Accuracy) {
	local vector HitLocation, HitNormal, StartTrace, EndTrace, X,Y,Z;
	local actor Other;
	local Pawn PawnOwner;

	PawnOwner = Pawn(Owner);

	Owner.MakeNoise(PawnOwner.SoundDampening);
	GetAxes(PawnOwner.ViewRotation,X,Y,Z);
	StartTrace = Owner.Location + PawnOwner.Eyeheight * vect(0,0,1); 
	AdjustedAim = PawnOwner.AdjustAim(1000000, StartTrace, 2*AimError, False, False);	
	X = vector(AdjustedAim);
	EndTrace = StartTrace + 100000 * X;
	if (STM.WeaponSettings.SniperUseReducedHitbox)
		Other = STM.TraceShot(HitLocation, HitNormal, EndTrace, StartTrace, PawnOwner);
	else
		Other = PawnOwner.TraceShot(HitLocation, HitNormal, EndTrace, StartTrace);
	ProcessTraceHit(Other, HitLocation, HitNormal, X,Y,Z);
}

function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	local UT_Shellcase s;
	local Pawn PawnOwner;
	local vector Momentum;

	PawnOwner = Pawn(Owner);

	s = Spawn(class'UT_ShellCase',, '', Owner.Location + CalcDrawOffset() + 30 * X + (2.8 * FireOffset.Y+5.0) * Y - Z * 1);
	if (s != None) {
		s.DrawScale = 2.0;
		s.Eject(((FRand()*0.3+0.4)*X + (FRand()*0.2+0.2)*Y + (FRand()*0.3+1.0) * Z)*160);
	}

	if (Other == Level) {
		Spawn(class'UT_HeavyWallHitEffect',,, HitLocation+HitNormal, Rotator(HitNormal));
	} else if ((Other != self) && (Other != Owner) && (Other != None)) {
		if (Other.bIsPawn && CheckHeadShot(Pawn(Other), HitLocation, X) &&
			(instigator.IsA('PlayerPawn') || (instigator.IsA('Bot') && !Bot(Instigator).bNovice))
		) {
			Other.PlaySound(Sound 'ChunkHit',, 4.0,,100);
			Other.TakeDamage(
				STM.WeaponSettings.SniperHeadshotDamage,
				PawnOwner,
				HitLocation,
				STM.WeaponSettings.SniperHeadshotMomentum * 35000 * X,
				AltDamageType);
		} else {
			if (Other.bIsPawn) {
				Other.PlaySound(Sound 'ChunkHit',, 4.0,,100);
				Momentum = STM.WeaponSettings.SniperMomentum * 30000.0*X;
			} else {
				Momentum = 30000.0*X;
				if (Other.IsA('Carcass') == false)
					Spawn(class'UT_SpriteSmokePuff',,,HitLocation+HitNormal*9);
			}

			Other.TakeDamage(
				STM.WeaponSettings.SniperDamage,
				PawnOwner,
				HitLocation,
				Momentum,
				MyDamageType);
		}
	}
}

function bool CheckHeadShot(Pawn P, vector HitLocation, vector BulletDir) {
	if (STM.WeaponSettings.SniperUseReducedHitbox == false)
		return (HitLocation.Z - P.Location.Z > 0.62 * P.CollisionHeight);

	return STM.CheckHeadShot(P, HitLocation, BulletDir);
}

function SetSwitchPriority(pawn Other)
{	// Make sure "old" priorities are kept.
	local int i;
	local name temp, carried;

	if ( PlayerPawn(Other) != None )
	{
		for ( i=0; i<ArrayCount(PlayerPawn(Other).WeaponPriority); i++)
			if ( IsA(PlayerPawn(Other).WeaponPriority[i]) )		// <- The fix...
			{
				AutoSwitchPriority = i;
				return;
			}
		// else, register this weapon
		carried = 'SniperRifle';
		for ( i=AutoSwitchPriority; i<ArrayCount(PlayerPawn(Other).WeaponPriority); i++ )
		{
			if ( PlayerPawn(Other).WeaponPriority[i] == '' )
			{
				PlayerPawn(Other).WeaponPriority[i] = carried;
				return;
			}
			else if ( i<ArrayCount(PlayerPawn(Other).WeaponPriority)-1 )
			{
				temp = PlayerPawn(Other).WeaponPriority[i];
				PlayerPawn(Other).WeaponPriority[i] = carried;
				carried = temp;
			}
		}
	}
}

simulated function PlayFiring() {
	PlayOwnedSound(FireSound, SLOT_None, Pawn(Owner).SoundDampening*3.0);
	PlayAnim(FireAnims[Rand(5)], GetWeaponSettings().SniperReloadAnimSpeed(), 0.05);

	if ( (PlayerPawn(Owner) != None)
		&& (PlayerPawn(Owner).DesiredFOV == PlayerPawn(Owner).DefaultFOV) )
		bMuzzleFlash++;
}

simulated function PlaySelect() {
	bForceFire = false;
	bForceAltFire = false;
	bCanClientFire = false;
	if ( !IsAnimating() || (AnimSequence != 'Select') )
		PlayAnim('Select',GetWeaponSettings().SniperSelectAnimSpeed(),0.0);
	Owner.PlaySound(SelectSound, SLOT_Misc, Pawn(Owner).SoundDampening);	
}

simulated function TweenDown() {
	local float TweenTime;

	TweenTime = 0.05;
	if (Owner != none && Owner.IsA('bbPlayer') && bbPlayer(Owner).IGPlus_UseFastWeaponSwitch)
		TweenTime = 0.00;

	if ( IsAnimating() && (AnimSequence != '') && (GetAnimGroup(AnimSequence) == 'Select') )
		TweenAnim( AnimSequence, AnimFrame * GetWeaponSettings().SniperDownTime );
	else
		PlayAnim('Down', GetWeaponSettings().SniperDownAnimSpeed(), TweenTime);

	if (Owner.IsA('PlayerPawn') && PlayerPawn(Owner).Player.IsA('ViewPort')) {
		ZoomState = ZS_None;
		PlayerPawn(Owner).EndZoom();
	}
}

simulated function bool ClientAltFire(float Value) {
	if (Owner.IsA('PlayerPawn') == false) {
		Pawn(Owner).bFire = 1;
		Pawn(Owner).bAltFire = 0;
		Global.Fire(0);
	} else {
		GotoState('Idle');
	}

	return true;
}

simulated function Tick(float DeltaTime) {
	local PlayerPawn P;

	P = PlayerPawn(Owner);
	if (P != none &&
		P.Weapon == self &&
		bCanClientFire
	) {
		switch (ZoomState) {
		case ZS_None:
			if (P.bAltFire != 0) {
				if (P.Player.IsA('ViewPort'))
					P.StartZoom();
				SetTimer(0.2, true);
				ZoomState = ZS_Zooming;
			}
			break;
		case ZS_Zooming:
			if (P.bAltFire == 0) {
				if (P.Player.IsA('ViewPort'))
					P.StopZoom();
				ZoomState = ZS_Zoomed;
			}
			break;
		case ZS_Zoomed:
			if (P.bAltFire != 0) {
				if (P.Player.IsA('ViewPort'))
					P.EndZoom();
				SetTimer(0.0, false);
				ZoomState = ZS_Reset;
			}
			break;
		case ZS_Reset:
			if (P.bAltFire == 0) {
				ZoomState = ZS_None;
			}
			break;
		}
	}
}

defaultproperties {
}
