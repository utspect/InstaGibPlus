// ===============================================================
// UTPureStats7A.ST_PulseGun: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_PulseGun extends PulseGun;

var ST_Mutator STM;

var WeaponSettingsRepl WSettings;

// For the PulseSphereFireRate setting
var float RateOfFire;

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
	
	RateOfFire = STM.WeaponSettings.PulseSphereFireRate;
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
		carried = 'PulseGun';
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

state NormalFire
{
	ignores AnimEnd;

	function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn)
	{
		local Vector Start, X,Y,Z;
		Owner.MakeNoise(Pawn(Owner).SoundDampening);
		GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
		Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;
		AdjustedAim = pawn(owner).AdjustAim(ProjSpeed, Start, AimError, True, bWarn);	
		Start = Start - Sin(Angle)*Y*4 + (Cos(Angle)*4 - 10.78)*Z;
		if (!Owner.FastTrace(Start))
			Start = Owner.Location + Normal(Start - Owner.Location) * Owner.CollisionRadius*0.9;
		Angle += 1.8;
		return Spawn(ProjClass,,, Start,AdjustedAim);	
	}

	function Tick( float DeltaTime )
	{
		if ( Owner==None ) 
			GotoState('Pickup');
	}

	function BeginState()
	{
		Super.BeginState();
		Angle = 0;
		AmbientGlow = 200;
	}

	function EndState()
	{
		PlaySpinDown();
		AmbientSound = None;
		AmbientGlow = 0;	
		OldFlashCount = FlashCount;	
		Super.EndState();
	}

Begin:
	Sleep(RateOfFire);  // Added rate of fire setting
	Finish();
}

simulated state ClientFiring
{
	simulated event BeginState()
	{
		Super.BeginState();
		AmbientGlow = 200;
	}
	
	simulated event EndState()
	{
		Super.EndState();
		AmbientSound = None;
		AmbientGlow = 0;
	}

	simulated event Tick( float DeltaTime )
	{
		if ( (Pawn(Owner) != None) && (Pawn(Owner).bFire != 0) )
			AmbientSound = FireSound;
		else
			AmbientSound = None;
	}

	simulated event AnimEnd()
	{
		if ( (AmmoType != None) && (AmmoType.AmmoAmount <= 0) )
		{
			PlaySpinDown();
			GotoState('');
		}
		else if ( !bCanClientFire )
			GotoState('');
		else if ( Pawn(Owner) == None )
		{
			PlaySpinDown();
			GotoState('');
		}
		else if ( Pawn(Owner).bFire != 0 )
			Global.ClientFire(0);
		else if ( Pawn(Owner).bAltFire != 0 )
			Global.ClientAltFire(0);
		else
		{
			PlaySpinDown();
			GotoState('');
		}
	}
Begin:
	Sleep(RateOfFire);  // Added rate of fire setting
	if ( (Pawn(Owner) != None) && (Pawn(Owner).bFire != 0) )
		Goto('Begin');
	AnimEnd();
}

simulated function PlaySelect() {
	bForceFire = false;
	bForceAltFire = false;
	bCanClientFire = false;
	if ( !IsAnimating() || (AnimSequence != 'Select') )
		PlayAnim('Select',GetWeaponSettings().PulseSelectAnimSpeed(),0.0);
	Owner.PlaySound(SelectSound, SLOT_Misc, Pawn(Owner).SoundDampening);
	
	AmbientSound = none;
}

simulated function TweenDown() {
	if ( IsAnimating() && (AnimSequence != '') && (GetAnimGroup(AnimSequence) == 'Select') )
		TweenAnim( AnimSequence, AnimFrame * GetWeaponSettings().PulseDownTime );
	else
		TweenAnim('Down', GetWeaponSettings().PulseDownTime);
}

defaultproperties {
	ProjectileClass=Class'ST_PlasmaSphere'
	AltProjectileClass=Class'ST_StarterBolt'
}
