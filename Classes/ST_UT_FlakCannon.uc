// ===============================================================
// Stats.ST_UT_FlakCannon: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_UT_FlakCannon extends UT_FlakCannon;

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

// Fire chunks
function Fire( float Value )
{
	local Vector Start, X,Y,Z;
	local Bot B;
	local ST_UTChunkInfo CI;
	local Pawn PawnOwner;

	PawnOwner = Pawn(Owner);

	if ( AmmoType == None )
	{
		// ammocheck
		GiveAmmo(PawnOwner);
	}
	if (AmmoType.UseAmmo(1))
	{
		bCanClientFire = true;
		bPointing=True;
		Start = PawnOwner.Location + CalcDrawOffset();
		B = Bot(PawnOwner);
		PawnOwner.PlayRecoil(FiringSpeed);
		PawnOwner.MakeNoise(2.0 * PawnOwner.SoundDampening);
		AdjustedAim = PawnOwner.AdjustAim(AltProjectileSpeed, Start, AimError, True, bWarnTarget);
		GetAxes(AdjustedAim,X,Y,Z);
		Spawn(class'WeaponLight',,'',Start+X*20,rot(0,0,0));		
		Start = Start + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;	
		CI = Spawn(class'ST_UTChunkInfo', PawnOwner);
		CI.STM = STM;
		// My comment
		// I am not sure why EPIC has decided to do flak (or rockets) this way, as they could
		// Have created a masterchunk on client that spawned the rest of the chunks according to
		// The below rules, creating less network traffic. Of course it would pose a problem
		// When you run into a chunk that wasn't relevant when the original shot was fired. Oh well :/
		CI.AddChunk(Spawn( class 'ST_UTChunk1',, '', Start, AdjustedAim));
		CI.AddChunk(Spawn( class 'ST_UTChunk2',, '', Start - Z, AdjustedAim));
		CI.AddChunk(Spawn( class 'ST_UTChunk3',, '', Start + 2 * Y + Z, AdjustedAim));
		CI.AddChunk(Spawn( class 'ST_UTChunk4',, '', Start - Y, AdjustedAim));
		CI.AddChunk(Spawn( class 'ST_UTChunk1',, '', Start + 2 * Y - Z, AdjustedAim));
		CI.AddChunk(Spawn( class 'ST_UTChunk2',, '', Start, AdjustedAim));

		// lower skill bots fire less flak chunks
		if ( (B == None) || !B.bNovice || ((B.Enemy != None) && (B.Enemy.Weapon != None) && B.Enemy.Weapon.bMeleeWeapon) )
		{
			CI.AddChunk(Spawn( class 'ST_UTChunk3',, '', Start + Y - Z, AdjustedAim));
			CI.AddChunk(Spawn( class 'ST_UTChunk4',, '', Start + 2 * Y + Z, AdjustedAim));
		}
		else if ( B.Skill > 1 )
			CI.AddChunk(Spawn( class 'ST_UTChunk3',, '', Start + Y - Z, AdjustedAim));

		ClientFire(Value);
		GoToState('NormalFire');
	}
}

function AltFire( float Value )
{
	local Vector Start, X,Y,Z;
	local ST_FlakSlug Slug;
	local Pawn PawnOwner;

	PawnOwner = Pawn(Owner);

	if ( AmmoType == None )
	{
		// ammocheck
		GiveAmmo(PawnOwner);
	}
	if (AmmoType.UseAmmo(1))
	{
		PawnOwner.PlayRecoil(FiringSpeed);
		bPointing=True;
		bCanClientFire = true;
		PawnOwner.MakeNoise(PawnOwner.SoundDampening);
		GetAxes(PawnOwner.ViewRotation,X,Y,Z);
		Start = PawnOwner.Location + CalcDrawOffset();
		Spawn(class'WeaponLight',,'',Start+X*20,rot(0,0,0));		
		Start = Start + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z; 
		AdjustedAim = PawnOwner.AdjustToss(AltProjectileSpeed, Start, AimError, True, bAltWarnTarget);	
		Slug = Spawn(class'ST_FlakSlug',,, Start,AdjustedAim);
		Slug.STM = STM;
		STM.PlayerFire(PawnOwner, 15);				// 15 = Flak Slug
		ClientAltFire(Value);	
		GoToState('AltFiring');
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
		carried = 'UT_FlakCannon';
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

simulated function TweenDown() {
	if ( IsAnimating() && (AnimSequence != '') && (GetAnimGroup(AnimSequence) == 'Select') )
		TweenAnim( AnimSequence, AnimFrame * GetWeaponSettings().FlakDownTime );
	else if ( AmmoType.AmmoAmount < 1 )
		TweenAnim('Select', GetWeaponSettings().FlakDownTime + 0.05);
	else
		PlayAnim('Down',GetWeaponSettings().FlakDownAnimSpeed(), 0.05);
}

simulated function PlaySelect() {
	bForceFire = false;
	bForceAltFire = false;
	bCanClientFire = false;
	if ( !IsAnimating() || (AnimSequence != 'Select') )
		PlayAnim('Select',GetWeaponSettings().FlakSelectAnimSpeed(),0.0);
	Owner.PlaySound(SelectSound, SLOT_Misc, Pawn(Owner).SoundDampening);	
}

simulated function PlayPostSelect() {
	PlayAnim('Loading', GetWeaponSettings().FlakPostSelectAnimSpeed(), 0.05);
	Owner.PlayOwnedSound(Misc2Sound, SLOT_None,1.3*Pawn(Owner).SoundDampening);
}

defaultproperties {
}
