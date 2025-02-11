// ===============================================================
// Stats.ST_ImpactHammer: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_ImpactHammer extends ImpactHammer;

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

function PostBeginPlay()
{
	Super.PostBeginPlay();

	ForEach AllActors(Class'IGPlus_WeaponImplementation', WImp)
		break;		// Find master :D
}

simulated function Tick(float deltaTime)
{	// This fixes the really annoying issue regarding IH sound
	if (Pawn(Owner) == None || Pawn(Owner).Weapon != Self)
		AmbientSound = None;
}

State ClientDown
{
	simulated function AnimEnd()
	{
		local TournamentPlayer T;

		T = TournamentPlayer(Owner);
		if ( T != None )
		{
			if ( (T.ClientPending != None)
				&& (T.ClientPending.Owner == Owner) )
			{
				T.Weapon = T.ClientPending;
				T.Weapon.GotoState('ClientActive');
				T.ClientPending = None;
				GotoState('');
			}
			else
			{
				T.NeedActivate();
			}
		}
	}

	simulated function BeginState();
}

simulated function ClientWeaponEvent(name EventType) {
	if (EventType == 'FireBlast' && GetStateName() != 'ClientFireBlast') {
		PlayFiring();
		GotoState('ClientFireBlast');
	}
}

state ClientFiring {
	simulated function BeginState() {
		ChargeSize = 0.0;
	}

	simulated function Tick(float Delta) {
		global.Tick(Delta);

		if (Owner == none || Owner.IsA('bbPlayer') == false)
			return;

		ChargeSize += 0.75*Delta;

		if (Pawn(Owner).bFire == 0) {
			ClientTraceFire(0);
			PlayFiring();
			GotoState('ClientFireBlast');
		}
	}
}

simulated function ClientTraceFire(float Accuracy) {
	local vector HitLocation, HitNormal, StartTrace, EndTrace, X, Y, Z;
	local actor Other;
	local bbPlayer P;
	local WeaponSettingsRepl WS;
	local vector Momentum;

	P = bbPlayer(Owner);
	WS = GetWeaponSettings();
	if (P == none || WS == none)
		return;

	GetAxes(P.ViewRotation, X, Y, Z);
	StartTrace = Owner.Location + vect(0,0,1)*P.EyeHeight;
	AdjustedAim = P.ViewRotation;
	EndTrace = StartTrace + 120.0 * vector(AdjustedAim);
	Other = P.NN_TraceShot(HitLocation, HitNormal, EndTrace, StartTrace, P);

	if ((Other == Level) || (Other != none && Other.IsA('Mover'))) {
		P.bForcePacketSplit = true;
		Momentum = WS.HammerSelfMomentum * -69000.0 * FClamp(ChargeSize, 1.0, 1.5) * X;
		if (P.Physics == PHYS_Walking)
			Momentum.Z = FMax(Momentum.Z, 0.4 * VSize(Momentum));
		Momentum = Momentum * 0.6 / P.Mass;
		P.AddVelocity(Momentum);
	}
}

function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	local Pawn PawnOwner;
	local vector Momentum;

	PawnOwner = Pawn(Owner);

	if ( (Other == None) || (Other == Owner) || (Other == self) || (Owner == None))
		return;

	ChargeSize = FMin(ChargeSize, 1.5);
	if ( (Other == Level) || Other.IsA('Mover') )
	{
		ChargeSize = FMax(ChargeSize, 1.0);
		if ( VSize(HitLocation - Owner.Location) < 80 )
			Spawn(class'ImpactMark',,, HitLocation+HitNormal, Rotator(HitNormal));
		Owner.TakeDamage(
			WImp.WeaponSettings.HammerSelfDamage,
			PawnOwner,
			HitLocation,
			vect(0,0,0),
			MyDamageType
		);

		// Manually do what PawnOwner.AddVelocity from PawnOwner.TakeDamage would do.
		// Cant use AddVelocity because it takes an additional round trip.
		// Client does the same manual modification of PawnOwner.Velocity in parallel, so it should all work out.
		Momentum = GetWeaponSettings().HammerSelfMomentum * -69000.0 * ChargeSize * X;
		if (PawnOwner.Physics == PHYS_Walking)
			Momentum.Z = FMax(Momentum.Z, 0.4 * VSize(Momentum));
		Momentum = Momentum * 0.6 / PawnOwner.Mass;
		if (PawnOwner.Physics == PHYS_Walking)
			PawnOwner.SetPhysics(PHYS_Falling);
		if ((PawnOwner.Velocity.Z > 380) && (Momentum.Z > 0))
			Momentum.Z *= 0.5;
		PawnOwner.Velocity += Momentum;
	}
	if ( Other != Level )
	{
		if ( Other.bIsPawn && (VSize(HitLocation - Owner.Location) > 90) )
			return;

		Momentum = 66000.0 * ChargeSize * X;
		if (Other.bIsPawn)
			Momentum *= WImp.WeaponSettings.HammerMomentum;

		Other.TakeDamage(
			WImp.WeaponSettings.HammerDamage * ChargeSize,
			PawnOwner,
			HitLocation,
			Momentum,
			MyDamageType
		);
		if ( !Other.bIsPawn && !Other.IsA('Carcass') )
			spawn(class'UT_SpriteSmokePuff',,,HitLocation+HitNormal*9);
	}
}

function TraceAltFire()
{
	local vector HitLocation, HitNormal, StartTrace, EndTrace, X, Y, Z;
	local actor Other;
	local Projectile P;
	local Pawn PawnOwner;

	PawnOwner = Pawn(Owner);

	Owner.MakeNoise(PawnOwner.SoundDampening);
	GetAxes(PawnOwner.ViewRotation, X, Y, Z);
	StartTrace = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;
	AdjustedAim = PawnOwner.AdjustAim(1000000, StartTrace, AimError, False, False);
	EndTrace = StartTrace + 180 * vector(AdjustedAim);
	Other = PawnOwner.TraceShot(HitLocation, HitNormal, EndTrace, StartTrace);
	ProcessAltTraceHit(Other, HitLocation, HitNormal, vector(AdjustedAim), Y, Z);

	// push aside projectiles
	ForEach VisibleCollidingActors(class'Projectile', P, 550, Owner.Location)
		if ( ((P.Physics == PHYS_Projectile) || (P.Physics == PHYS_Falling))
			&& (Normal(P.Location - Owner.Location) Dot X) > 0.9 )
		{
			P.speed = VSize(P.Velocity);
			if ( P.Velocity Dot Y > 0 )
				P.Velocity = P.Speed * Normal(P.Velocity + (750 - VSize(P.Location - Owner.Location)) * Y);
			else
				P.Velocity = P.Speed * Normal(P.Velocity - (750 - VSize(P.Location - Owner.Location)) * Y);
		}
}

function ProcessAltTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	local vector realLoc;
	local float scale;
	local Pawn PawnOwner;
	local vector Momentum;

	if ( (Other == None) || (Other == Owner) || (Other == self) || (Owner == None) )
		return;

	PawnOwner = Pawn(Owner);

	realLoc = Owner.Location + CalcDrawOffset();
	scale = VSize(realLoc - HitLocation)/180;
	if ( (Other == Level) || Other.IsA('Mover') )
	{
		Owner.TakeDamage(
			WImp.WeaponSettings.HammerAltSelfDamage * scale,
			Pawn(Owner),
			HitLocation,
			WImp.WeaponSettings.HammerAltSelfMomentum * -40000.0 * X * scale,
			MyDamageType
		);
	}
	else
	{
		Momentum = 30000.0 * X * scale;
		if (Other.bIsPawn)
			Momentum *= WImp.WeaponSettings.HammerAltMomentum;

		Other.TakeDamage(
			WImp.WeaponSettings.HammerAltDamage * scale,
			Pawn(Owner),
			HitLocation,
			Momentum,
			MyDamageType
		);
		if ( !Other.bIsPawn && !Other.IsA('Carcass') )
			spawn(class'UT_SpriteSmokePuff',,,HitLocation+HitNormal*9);
	}
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
		carried = 'ImpactHammer';
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

simulated function PlaySelect() {
	bForceFire = false;
	bForceAltFire = false;
	bCanClientFire = false;
	if ( !IsAnimating() || (AnimSequence != 'Select') )
		PlayAnim('Select',GetWeaponSettings().HammerSelectAnimSpeed(),0.0);
	Owner.PlaySound(SelectSound, SLOT_Misc, Pawn(Owner).SoundDampening);	
}

simulated function TweenDown() {
	local float TweenTime;

	TweenTime = 0.05;
	if (Owner != none && Owner.IsA('bbPlayer') && bbPlayer(Owner).IGPlus_UseFastWeaponSwitch)
		TweenTime = 0.00;

	if ( IsAnimating() && (AnimSequence != '') && (GetAnimGroup(AnimSequence) == 'Select') )
		TweenAnim( AnimSequence, AnimFrame * GetWeaponSettings().HammerDownTime );
	else
		PlayAnim('Down', GetWeaponSettings().HammerDownAnimSpeed(), TweenTime);
}

defaultproperties {
}
