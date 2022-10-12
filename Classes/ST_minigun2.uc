// ===============================================================
// Stats.ST_minigun2: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_minigun2 extends minigun2;

// Tickrate independant minigun. (Info below is very inaccurate after many revisions of Stats minigun)
//
// The orginal minigun used a loop where Sleep() decided when to fire next shot.
// The problem with Sleep() is that it will NOT trigger accurately enough, and also
// it changes accuracy when tickrate of server.
//
// Assuming a tickrate of 20, you have 1000/20 = 50ms (0.05 seconds) between each update.
// (complex: actually, the formula is 1000/20 * Level.TimeDilation, and UT's timedilation is 1.1,
//           which means the time between ticks is 0.055s, but in most my tests it is 0.054s,
//           which means (...) that UT triggers tick just before it overflows. I need to get someone to check UT source.)
//
// Here is some more proof of the "bad" performance of Sleep()
// Ratio 1.00 = "perfect", <1.0 = "reacts too slow", >1.0 = "reacts too fast"
//	Tickrate 20		delta
//	Sleep	Actual	Ratio	Tick
//	0.010	0.054	0.184	0.054	(Notice how deltaTick is 0.054, if I change Level.TimeDilation to 1.0, it gives me 0.049 instead)
//	0.020	0.054	0.369	0.054
//	0.030	0.054	0.554	0.054
//	0.040	0.054	0.739	0.054
//	0.050	0.054	0.924	0.054
//	0.060	0.054	1.109	0.054
//	0.070	0.054	1.294	0.054
//	0.080	0.054	1.479	0.054	<-- !!! 1.5 as many sleep will be performed. Meaning 0.08 is not 12.5/sec, but really 18.48!!!
//	0.090	0.108	0.832	0.054
//	0.100	0.108	0.924	0.054
//	0.110	0.108	1.017	0.054
//	0.120	0.108	1.109	0.054
//	0.130	0.108	1.202	0.054
//	0.140	0.162	0.863	0.054
//	0.150	0.162	0.924	0.054
//	0.160	0.162	0.986	0.054
//	0.170	0.162	1.047	0.054
//	0.180	0.162	0.109	0.054
//	0.190	0.216	0.878	0.054
//
// In order to try to fix this, I implement the bullet generation in Tick() instead of a Sleep() loop.
// To get correct values, I made a little util which simply checked how many shots/sec minigun fired when
// using Sleep() and different Tickrates.
//

var ST_Mutator STM;
var float FireInterval, NextFireInterval;

// For Special minigun
var int HitCounter;

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

function Fire( float Value )
{
	if ( AmmoType == None )
	{
		// ammocheck
		GiveAmmo(Pawn(Owner));
	}
	if ( AmmoType.UseAmmo(1) )
	{
		SoundVolume = 255*Pawn(Owner).SoundDampening;
		Pawn(Owner).PlayRecoil(FiringSpeed);
		bCanClientFire = true;
		bPointing=True;
		ShotAccuracy = 0.2;
		FireInterval = STM.WeaponSettings.MinigunSpinUpTime;		// Spinup
		NextFireInterval = STM.WeaponSettings.MinigunBulletInterval;	// 12.5 shots/sec
		ClientFire(value);
		GotoState('NormalFire');
	}
	else GoToState('Idle');
}

function AltFire( float Value )
{
	if ( AmmoType == None )
	{
		// ammocheck
		GiveAmmo(Pawn(Owner));
	}
	if ( AmmoType.UseAmmo(1) )
	{
		bPointing=True;
		bCanClientFire = true;
		ShotAccuracy = 0.95;
		FireInterval = STM.WeaponSettings.MinigunSpinUpTime;		// Spinup
		NextFireInterval = STM.WeaponSettings.MinigunBulletInterval;	// Use Primary fire speed until completely spun up
		Pawn(Owner).PlayRecoil(FiringSpeed);
		SoundVolume = 255*Pawn(Owner).SoundDampening;
		ClientAltFire(value);
		GoToState('AltFiring');
	}
	else GoToState('Idle');
}

simulated function Tick(float deltaTime)
{	// This fixes the really annoying issue regarding minigun sound
	if (Pawn(Owner) == None || Pawn(Owner).Weapon != Self)
		AmbientSound = None;
}

// Original code did: Sleep(0.13)
// This would (depending on tickrate) get called on irregular intervals.
// According to a 20 tickrate server, this would result in about 6.667 shots/sec,
// 1/6.667 = 0.15s between, therefore...
// Due to excessive whining, shots/sec is increased to 7.5
// 1/7.5 = 0.13s between.
// Due to more testing, I have now set fireinterval up to 8.0
// 1/8.0 = 0.125s between
// And now, finally, I messed mini up totally, by increasing ROF by 50%, and reducing damage in half.
// 1/12.5 = 0.08s between
state NormalFire
{
	function Tick( float DeltaTime )
	{
		local Pawn P;

		P = Pawn(Owner);

		if (P == None)
			return;

		if (P.Weapon != Self)
			AmbientSound = None;

		FireInterval -= DeltaTime;
		while (FireInterval < 0.0)
		{
//			Log("FireInterval"@FireInterval@"Next"@NextFireInterval);
			FireInterval += NextFireInterval;
//			if (P.bAltFire == 0)
			GenerateBullet();
		}

		if	( bFiredShot && ((P.bFire==0) || bOutOfAmmo) )
			GoToState('FinishFire');
	}

	function AnimEnd()
	{
		if ( AmbientSound == None )
			AmbientSound = FireSound;
		if ( Affector != None )
			Affector.FireEffect();
	}

Begin:
}

// Original code did: Sleep(0.08)
// This would (depending on tickrate) get called on irregular intervals.
// According to a 20 tickrate server, this would result in about 10.000 shots/sec,
// 1/10.000 = 0.10s between, therefore...
// Due to excessive whining, shots/sec increased to 11
// 1/11 = 0.091s between
// Due to more testing, I have now increased shots/sec to 12.5
// 1/12.5 = 0.08s (look in AnimEnd)
// And now, finally, I messed mini up totally, by increasing ROF by 50%, and reducing damage in half.
// 1/20 = 0.05s between
state AltFiring
{
	function Tick( float DeltaTime )
	{
		local Pawn P;

		P = Pawn(Owner);

		if (P == None)
			return;

		if (P.Weapon != Self)
			AmbientSound = None;

		FireInterval -= DeltaTime;
		while (FireInterval < 0.0)
		{
//			Log("FireInterval"@FireInterval@"Next"@NextFireInterval);
			FireInterval += NextFireInterval;
//			if (P.bFire == 0)
			GenerateBullet();
		}

		if	( bFiredShot && ((P.bAltFire==0) || bOutOfAmmo) )
			GoToState('FinishFire');
	}

	function AnimEnd()
	{
		if ( (AnimSequence != 'Shoot2') || !bAnimLoop )
		{
			AmbientSound = AltFireSound;
			SoundVolume = 255*Pawn(Owner).SoundDampening;
			LoopAnim('Shoot2',1.9);
			NextFireInterval = STM.WeaponSettings.MinigunAlternateBulletInterval;	// 20.0 shots/sec ..12.5 shots/sec
		}
		else if ( AmbientSound == None )
			AmbientSound = FireSound;
		if ( Affector != None )
			Affector.FireEffect();
	}
Begin:
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
	local int rndDam;
	local Pawn PawnOwner;


	PawnOwner = Pawn(Owner);

	STM.PlayerFire(PawnOwner, 13);				// 13 = Minigun

	if (Other == Level)
		Spawn(class'UT_LightWallHitEffect',,, HitLocation+HitNormal, Rotator(HitNormal));
	else if ( (Other!=self) && (Other!=Owner) && (Other != None) )
	{

		if ( !Other.bIsPawn && !Other.IsA('Carcass') )
			spawn(class'UT_SpriteSmokePuff',,,HitLocation+HitNormal*9);
		else
			Other.PlaySound(Sound 'ChunkHit',, 4.0,,100);

		if ( Other.IsA('Bot') && (FRand() < 0.2) )
			Pawn(Other).WarnTarget(PawnOwner, 500, X);
		rndDam = STM.WeaponSettings.MinigunMinDamage + Rand(STM.WeaponSettings.MinigunMaxDamage - STM.WeaponSettings.MinigunMinDamage + 1);
		if ( Level.Game.GetPropertyText("NoLockdown") == "1" || FRand() >= 0.2 )
			X = vect(0, 0, 0);
		else
			X *= 2.5;
		STM.PlayerHit(PawnOwner, 13, False);			// 13 = Minigun
		Other.TakeDamage(rndDam, PawnOwner, HitLocation, rndDam*500.0*X, MyDamageType);
		STM.PlayerClear();
	}

	if (Pawn(Other) != None && Other != Owner && Pawn(Other).Health > 0)
	{	// We hit a pawn that wasn't the owner or dead.
		HitCounter++;						// +1 hit
		if (HitCounter == 8)
		{	// Wowsers!
			HitCounter = 0;
			STM.PlayerSpecial(PawnOwner, 13);		// 13 = Minigun
		}
	}
	else
		HitCounter = 0;
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
		carried = 'minigun2';
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
		PlayAnim('Select',GetWeaponSettings().MinigunSelectAnimSpeed(),0.0);
	Owner.PlaySound(SelectSound, SLOT_Misc, Pawn(Owner).SoundDampening);	
}

simulated function TweenDown() {
	if ( IsAnimating() && (AnimSequence != '') && (GetAnimGroup(AnimSequence) == 'Select') )
		TweenAnim( AnimSequence, AnimFrame * GetWeaponSettings().MinigunDownTime );
	else
		PlayAnim('Down', GetWeaponSettings().MinigunDownAnimSpeed(), 0.05);
}

defaultproperties {
	FireInterval=0.130
	NextFireInterval=0.08
}
