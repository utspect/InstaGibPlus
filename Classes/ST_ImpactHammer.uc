// ===============================================================
// Stats.ST_ImpactHammer: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_ImpactHammer extends ImpactHammer;

var ST_Mutator STM;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	ForEach AllActors(Class'ST_Mutator', STM)
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

function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	local Pawn PawnOwner;

	PawnOwner = Pawn(Owner);
	STM.PlayerFire(PawnOwner, 1);			// 1 = Impact Hammer.

	if ( (Other == None) || (Other == Owner) || (Other == self) || (Owner == None))
		return;

	ChargeSize = FMin(ChargeSize, 1.5);
	if ( (Other == Level) || Other.IsA('Mover') )
	{
		ChargeSize = FMax(ChargeSize, 1.0);
		if ( VSize(HitLocation - Owner.Location) < 80 )
			Spawn(class'ImpactMark',,, HitLocation+HitNormal, Rotator(HitNormal));
		STM.PlayerHit(PawnOwner, 1, False);	// 1 = Impact Hammer
		Owner.TakeDamage(
			STM.WeaponSettings.HammerSelfDamage,
			PawnOwner,
			HitLocation,
			STM.WeaponSettings.HammerSelfMomentum * -69000.0 * ChargeSize * X,
			MyDamageType
		);
		STM.PlayerClear();
	}
	if ( Other != Level )
	{
		if ( Other.bIsPawn && (VSize(HitLocation - Owner.Location) > 90) )
			return;
		STM.PlayerHit(PawnOwner, 1, False);	// 1 = Impact Hammer
		Other.TakeDamage(
			STM.WeaponSettings.HammerDamage * ChargeSize,
			PawnOwner,
			HitLocation,
			STM.WeaponSettings.HammerMomentum * 66000.0 * ChargeSize * X,
			MyDamageType
		);
		STM.PlayerClear();
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
	STM.PlayerFire(PawnOwner, 1);			// 1 = Impact Hammer.

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
			STM.PlayerSpecial(PawnOwner, 1);		// Deflect/Push aside projectiles.
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

	if ( (Other == None) || (Other == Owner) || (Other == self) || (Owner == None) )
		return;

	PawnOwner = Pawn(Owner);

	realLoc = Owner.Location + CalcDrawOffset();
	scale = VSize(realLoc - HitLocation)/180;
	if ( (Other == Level) || Other.IsA('Mover') )
	{
		STM.PlayerHit(PawnOwner, 1, False);	// 1 = IH!
		Owner.TakeDamage(
			STM.WeaponSettings.HammerAltSelfDamage * scale,
			Pawn(Owner),
			HitLocation,
			STM.WeaponSettings.HammerAltSelfMomentum * -40000.0 * X * scale,
			MyDamageType
		);
		STM.PlayerClear();
	}
	else
	{
		STM.PlayerHit(PawnOwner, 1, False);	// 1 = IH!
		Other.TakeDamage(
			STM.WeaponSettings.HammerAltDamage * scale,
			Pawn(Owner),
			HitLocation,
			STM.WeaponSettings.HammerAltMomentum * 30000.0 * X * scale,
			MyDamageType
		);
		STM.PlayerClear();
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

simulated function TweenDown()
{
	PlayAnim('Down', 100.0, 0.0);
}

defaultproperties {
}
