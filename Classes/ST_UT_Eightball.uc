// ===============================================================
// Stats.ST_UT_Eightball: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_UT_Eightball extends UT_Eightball;

var ST_Mutator STM;

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

///////////////////////////////////////////////////////
state FireRockets
{
	function Fire(float F) {}
	function AltFire(float F) {}

	function ForceFire()
	{
		bForceFire = true;
	}

	function ForceAltFire()
	{
		bForceAltFire = true;
	}

	function bool SplashJump()
	{
		return false;
	}

	function BeginState()
	{
		local vector FireLocation, StartLoc, X,Y,Z;
		local rotator FireRot, RandRot;
		local ST_rocketmk2 r;
		local ST_UT_SeekingRocket s;
		local ST_ut_grenade g;
		local float Angle, RocketRad;
		local pawn BestTarget, PawnOwner;
		local PlayerPawn PlayerOwner;
		local int DupRockets;
		local bool bMultiRockets;

		PawnOwner = Pawn(Owner);
		if ( PawnOwner == None )
			return;
		PawnOwner.PlayRecoil(FiringSpeed);
		PlayerOwner = PlayerPawn(Owner);
		Angle = 0;
		DupRockets = RocketsLoaded - 1;
		if (DupRockets < 0) DupRockets = 0;
		if ( PlayerOwner == None )
			bTightWad = ( FRand() * 4 < PawnOwner.skill );

		GetAxes(PawnOwner.ViewRotation,X,Y,Z);
		StartLoc = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z; 

		if ( bFireLoad ) 		
			AdjustedAim = PawnOwner.AdjustAim(ProjectileSpeed, StartLoc, AimError, True, bWarnTarget);
		else 
			AdjustedAim = PawnOwner.AdjustToss(AltProjectileSpeed, StartLoc, AimError, True, bAltWarnTarget);	
			
		if ( PlayerOwner != None )
			AdjustedAim = PawnOwner.ViewRotation;
		
		PlayRFiring(RocketsLoaded-1);		
		Owner.MakeNoise(PawnOwner.SoundDampening);
		if ( !bFireLoad )
		{
			LockedTarget = None;
			bLockedOn = false;
		}
		else if ( LockedTarget != None )
		{
			BestTarget = Pawn(CheckTarget());
			if ( (LockedTarget!=None) && (LockedTarget != BestTarget) ) 
			{
				LockedTarget = None;
				bLockedOn=False;
			}
		}
		else 
			BestTarget = None;
		bPendingLock = false;
		bPointing = true;
		FireRot = AdjustedAim;
		RocketRad = 4;
		if (bTightWad || !bFireLoad) RocketRad=7;
		bMultiRockets = ( RocketsLoaded > 1 );

		While ( RocketsLoaded > 0 )
		{
			
			if ( bMultiRockets )
				Firelocation = StartLoc - (Sin(Angle)*RocketRad - 7.5)*Y + (Cos(Angle)*RocketRad - 7)*Z - X * 4 * FRand();
			else
				FireLocation = StartLoc;
			if (bFireLoad)
			{
				if ( Angle > 0 )
				{
					if ( Angle < 3 && !bTightWad)
						FireRot.Yaw = AdjustedAim.Yaw - Angle * 600;
					else if ( Angle > 3.5 && !bTightWad)
						FireRot.Yaw = AdjustedAim.Yaw + (Angle - 3)  * 600;
					else
						FireRot.Yaw = AdjustedAim.Yaw;
				}
				STM.PlayerFire(PawnOwner, 16);		// 16 = Rockets
				if ( LockedTarget != None )
				{
					s = Spawn( class 'ST_ut_SeekingRocket',, '', FireLocation,FireRot);
					s.STM = STM;
					s.Seeking = LockedTarget;
					s.NumExtraRockets = DupRockets;					
					if ( Angle > 0 )
						s.Velocity *= (0.9 + 0.2 * FRand());			
				}
				else 
				{
					r = Spawn( class'ST_rocketmk2',, '', FireLocation,FireRot);
					r.STM = STM;
					r.NumExtraRockets = DupRockets;
					if (RocketsLoaded>4 && bTightWad) r.bRing=True;
					if ( Angle > 0 )
						r.Velocity *= (0.9 + 0.2 * FRand());			
				}
			}
			else 
			{
				STM.PlayerFire(PawnOwner, 17);		// 17 = Grenades
				g = Spawn( class 'ST_ut_Grenade',, '', FireLocation,AdjustedAim);
				g.STM = STM;
				g.NumExtraGrenades = DupRockets;
				if ( DupRockets > 0 )
				{
					RandRot.Pitch = FRand() * 1500 - 750;
					RandRot.Yaw = FRand() * 1500 - 750;
					RandRot.Roll = FRand() * 1500 - 750;
					g.Velocity = g.Velocity >> RandRot;
				}
			}

			Angle += 1.0484; //2*3.1415/6;
			RocketsLoaded--;
		}
		bTightWad=False;
		bRotated = false;
	}

	function AnimEnd()
	{
		if ( !bRotated && (AmmoType.AmmoAmount > 0) ) 
		{	
			PlayLoading(1.5,0);
			RocketsLoaded = 1;
			bRotated = true;
			return;
		}
		LockedTarget = None;
		Finish();
	}
Begin:	
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
		carried = 'UT_Eightball';
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
		PlayAnim('Select',GetWeaponSettings().EightballSelectAnimSpeed(),0.0);
	Owner.PlaySound(SelectSound, SLOT_Misc, Pawn(Owner).SoundDampening);	
}

simulated function TweenDown() {
	if ( IsAnimating() && (AnimSequence != '') && (GetAnimGroup(AnimSequence) == 'Select') )
		TweenAnim( AnimSequence, AnimFrame * GetWeaponSettings().EightballDownAnimSpeed() );
	else
		PlayAnim('Down', GetWeaponSettings().EightballDownAnimSpeed(), 0.05);
}

defaultproperties {
}
