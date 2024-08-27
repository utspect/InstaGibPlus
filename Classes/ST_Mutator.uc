class ST_Mutator extends Mutator;
// Description="Replaces all normal weapons with their IG+ equivalent"

// Good to have Variables
var string PreFix;

var ST_SpawnNotify SN;
var int DelaySpawnNotifyReplace;
var bool bReplaceWeapons;

var ST_HitTestHelper CollChecker;
var ST_HitTestHelper HitTestHelper;

var WeaponSettings WeaponSettings;
var WeaponSettingsRepl WSettingsRepl;

function bool AlwaysKeep(Actor Other)
{
    if (Level.Game.IsA('NewNetSDOM') && (Other.IsA('NN_Armor2') || Other.IsA('NN_ThighPads')))
        return true;

    return Super.AlwaysKeep(Other);
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
    if (Level.Game.IsA('NewNetSDOM'))
	{
		if ( Other.IsA('Armor2') || Other.IsA('Armor') )
		{
			ReplaceWith( Other, PreFix$"NN_Armor2" );
			return false;
		} else if ( Other.IsA('ThighPads') || Other.IsA('KevlarSuit') )
		{
			ReplaceWith( Other, PreFix$"NN_ThighPads" );
			return false;
		}
	}

	if (bReplaceWeapons && Other.IsA('Weapon'))
		return CheckReplaceWeapon(Other) == false;
		
    return true;
}

function InitializeSettings() {
	class'WeaponSettingsRepl'.static.CreateWeaponSettings(Level, "WeaponSettingsOldNet", WeaponSettings, WSettingsRepl);
}

function PreBeginPlay()
{
	local Mutator M;

	PreFix = class'StringUtils'.static.PackageOfObject(self);
	Log("ST_Mutator determined prefix="$PreFix, 'IGPlus');
 	Level.Game.RegisterMessageMutator(Self);

 	SN = Spawn(class'ST_SpawnNotify');

 	for (M = Level.Game.BaseMutator; M != none; M = M.NextMutator)
 		if (M.IsA('Arena'))
 			bReplaceWeapons = false;

	HitTestHelper = Spawn(class'ST_HitTestHelper');
	CollChecker = Spawn(class'ST_HitTestHelper');
	CollChecker.bCollideWorld = false;
	CollChecker.SetCollision(true, false, false);

	InitializeSettings();

	Super.PreBeginPlay();
}

function Tick(float Delta) {
	DelaySpawnNotifyReplace -= 1;
	if (DelaySpawnNotifyReplace == 0)
		Disable('Tick');
}

function AddMutator(Mutator M)
{
	if (M.IsA('Arena'))
		bReplaceWeapons = false;

	super.AddMutator(M);
}

function bool IsRelevant(Actor Other, out byte bSuperRelevant)
{
	if (DelaySpawnNotifyReplace <= 0 && CheckReplaceWeapon(Other))
		return true; // replaced using ST_SpawnNotify

	if (CheckReplacement(Other, bSuperRelevant)) {
		if (NextMutator != none) {
			return NextMutator.IsRelevant(Other, bSuperRelevant);
		} else {
			return true;
		}
	}

	return false;
}

function bool CheckReplaceWeapon(Actor A) {
	local Weapon W;
	local WeaponSettings WS;

	W = Weapon(A);
	WS = WeaponSettings;
	if (W == none) return false;
	else if (W.Class == class'Translocator')     { if (WS.bReplaceTranslocator)    return DoReplace(W, class'ST_Translocator'); }
	else if (W.Class == class'ImpactHammer')     { if (WS.bReplaceImpactHammer)    return DoReplace(W, class'ST_ImpactHammer'); }
	else if (W.Class == class'DispersionPistol') { if (WS.bReplaceImpactHammer)    return DoReplace(W, class'ST_ImpactHammer'); }
	else if (W.Class == class'Enforcer')         { if (WS.bReplaceEnforcer)        return DoReplace(W, class'ST_enforcer'); }
	else if (W.Class == class'AutoMag')          { if (WS.bReplaceEnforcer)        return DoReplace(W, class'ST_enforcer'); }
	else if (W.Class == class'UT_BioRifle')      { if (WS.bReplaceBioRifle)        return DoReplace(W, class'ST_ut_biorifle'); }
	else if (W.Class == class'GesBioRifle')      { if (WS.bReplaceBioRifle)        return DoReplace(W, class'ST_ut_biorifle'); }
	else if (W.Class == class'ShockRifle')       { if (WS.bReplaceShockRifle)      return DoReplace(W, class'ST_ShockRifle'); }
	else if (W.Class == class'ASMD')             { if (WS.bReplaceShockRifle)      return DoReplace(W, class'ST_ShockRifle'); }
	else if (W.Class == class'SuperShockRifle')  { if (WS.bReplaceSuperShockRifle) return DoReplace(W, class'ST_SuperShockRifle'); }
	else if (W.Class == class'PulseGun')         { if (WS.bReplacePulseGun)        return DoReplace(W, class'ST_PulseGun'); }
	else if (W.Class == class'Stinger')          { if (WS.bReplacePulseGun)        return DoReplace(W, class'ST_PulseGun'); }
	else if (W.Class == class'Ripper')           { if (WS.bReplaceRipper)          return DoReplace(W, class'ST_ripper'); }
	else if (W.Class == class'Razorjack')        { if (WS.bReplaceRipper)          return DoReplace(W, class'ST_ripper'); }
	else if (W.Class == class'Minigun')          { if (WS.bReplaceMinigun)         return DoReplace(W, class'ST_minigun2'); }
	else if (W.Class == class'Minigun2')         { if (WS.bReplaceMinigun)         return DoReplace(W, class'ST_minigun2'); }
	else if (W.Class == class'UT_FlakCannon')    { if (WS.bReplaceFlakCannon)      return DoReplace(W, class'ST_UT_FlakCannon'); }
	else if (W.Class == class'FlakCannon')       { if (WS.bReplaceFlakCannon)      return DoReplace(W, class'ST_UT_FlakCannon'); }
	else if (W.Class == class'UT_Eightball')     { if (WS.bReplaceRocketLauncher)  return DoReplace(W, class'ST_UT_Eightball'); }
	else if (W.Class == class'Eightball')        { if (WS.bReplaceRocketLauncher)  return DoReplace(W, class'ST_UT_Eightball'); }
	else if (W.Class == class'SniperRifle')      { if (WS.bReplaceSniperRifle)     return DoReplace(W, class'ST_SniperRifle'); }
	else if (W.Class == class'Rifle')            { if (WS.bReplaceSniperRifle)     return DoReplace(W, class'ST_SniperRifle'); }
	else if (W.Class == class'WarheadLauncher')  { if (WS.bReplaceWarheadLauncher) return DoReplace(W, class'ST_WarheadLauncher'); }

	return false;
}

function bool DoReplace(Weapon Other, class<Weapon> ReplacementClass) {
	local Weapon W;
	
	W = Other.Spawn(ReplacementClass, Other.Owner, Other.Tag);
	if (W != none) {
		W.SetCollisionSize(Other.CollisionRadius, Other.CollisionHeight);
		W.Tag = Other.Tag;
		W.Event = Other.Event;
		if (Other.MyMarker != none) {
			W.MyMarker = Other.MyMarker;
			W.MyMarker.markedItem = W;
		}
		W.bHeldItem = Other.bHeldItem;
		W.RespawnTime = Other.RespawnTime;
		W.PickupAmmoCount = Other.PickupAmmoCount;
		W.bRotatingPickup = Other.bRotatingPickup;
		if (DelaySpawnNotifyReplace <= 0)
			SN.SetReplace(Other, W);
		return true;
	}
	return false;
}

function bool ReplaceWith(actor Other, string aClassName)
{
	local Actor A;
	local class<Actor> aClass;

	if ( Other.IsA('Inventory') && (Other.Location == vect(0,0,0)) )
		return false;
	aClass = class<Actor>(DynamicLoadObject(aClassName, class'Class'));
	if ( aClass != None )
		A = Spawn(aClass, Other.Owner, Other.tag, Other.Location, Other.Rotation);
	if ( Other.IsA('Inventory') )
	{
		if ( Inventory(Other).MyMarker != None )
		{
			Inventory(Other).MyMarker.markedItem = Inventory(A);
			if ( Inventory(A) != None )
			{
				Inventory(A).MyMarker = Inventory(Other).MyMarker;
				A.SetCollisionSize( Other.CollisionRadius, Other.CollisionHeight);
			}
			Inventory(Other).MyMarker = None;
		}
		else if ( A.IsA('Inventory') )
		{
			Inventory(A).bHeldItem = true;
			Inventory(A).Respawntime = 0.0;
		}
	}
	if ( A != None )
	{
		A.event = Other.event;
		A.tag = Other.tag;

		Inventory(A).Multiskins[0] = Inventory(Other).Multiskins[0];
		Inventory(A).Multiskins[1] = Inventory(Other).Multiskins[1];
		Inventory(A).Multiskins[2] = Inventory(Other).Multiskins[2];
		Inventory(A).Multiskins[3] = Inventory(Other).Multiskins[3];
		Inventory(A).Multiskins[4] = Inventory(Other).Multiskins[4];
		Inventory(A).Multiskins[5] = Inventory(Other).Multiskins[5];
		Inventory(A).Multiskins[6] = Inventory(Other).Multiskins[6];
		Inventory(A).Multiskins[7] = Inventory(Other).Multiskins[7];
		Inventory(A).Skin = Inventory(Other).Skin;
		Inventory(A).Style = Inventory(Other).Style;
		Inventory(A).bMeshEnviroMap = Inventory(Other).bMeshEnviroMap;
		Inventory(A).bAmbientGlow = Inventory(Other).bAmbientGlow;
		Inventory(A).ScaleGlow = Inventory(Other).ScaleGlow;
		Inventory(A).AmbientGlow = Inventory(Other).AmbientGlow;
		Inventory(A).PickupSound = Inventory(Other).PickupSound;
		Inventory(A).MaxDesireability = Inventory(Other).MaxDesireability;
		Inventory(A).ActivateSound = Inventory(Other).ActivateSound;
		Inventory(A).DeActivateSound = Inventory(Other).DeActivateSound;
		Inventory(A).DrawScale = Inventory(Other).DrawScale;
		Inventory(A).AutoSwitchPriority = Inventory(Other).AutoSwitchPriority;
		Inventory(A).InventoryGroup = Inventory(Other).InventoryGroup;
		Inventory(A).PlayerViewOffset = Inventory(Other).PlayerViewOffset;
		Inventory(A).PlayerViewMesh = Inventory(Other).PlayerViewMesh;
		Inventory(A).PlayerViewScale = Inventory(Other).PlayerViewScale;
		Inventory(A).BobDamping = Inventory(Other).BobDamping;
		Inventory(A).PickupViewMesh = Inventory(Other).PickupViewMesh;
		Inventory(A).PickupViewScale = Inventory(Other).PickupViewScale;
		Inventory(A).ThirdPersonMesh = Inventory(Other).ThirdPersonMesh;
		Inventory(A).ThirdPersonScale = Inventory(Other).ThirdPersonScale;
		Inventory(A).StatusIcon = Inventory(Other).StatusIcon;
		Inventory(A).Icon = Inventory(Other).Icon;
		Inventory(A).PickupSound = Inventory(Other).PickupSound;
		Inventory(A).RespawnSound = Inventory(Other).RespawnSound;
		Inventory(A).PickupMessageClass = Inventory(Other).PickupMessageClass;
		Inventory(A).ItemMessageClass = Inventory(Other).ItemMessageClass;
		Inventory(A).RespawnTime = Inventory(Other).RespawnTime;
		Inventory(A).bRotatingPickup = Inventory(Other).bRotatingPickup;
		Inventory(A).AttachTag = Inventory(Other).AttachTag;
		Inventory(A).bBounce = Inventory(Other).bBounce;
		Inventory(A).bFixedRotationDir = Inventory(Other).bFixedRotationDir;
		Inventory(A).bRotateToDesired = Inventory(Other).bRotateToDesired;
		Inventory(A).Buoyancy = Inventory(Other).Buoyancy;
		Inventory(A).DesiredRotation = Inventory(Other).DesiredRotation;
		Inventory(A).Mass = Inventory(Other).Mass;
		Inventory(A).RotationRate = Inventory(Other).RotationRate;
		Inventory(A).Velocity = Inventory(Other).Velocity;
		Inventory(A).SetPhysics(Inventory(Other).Physics);
		return true;
	}
	return false;
}

final function EnhancedHurtRadius(
	Actor  Source,
	float  DamageAmount,
	float  DamageRadius,
	name   DamageName,
	float  Momentum,
	vector HitLocation,
	optional bool bIsRazor2Alt
) {
	local actor Victim;
	local float damageScale, dist;
	local float DamageDiffraction;
	local float MomentumScale;
	local vector MomentumDelta, MomentumDir;
	local vector Delta, DeltaXY;
	local vector Closest;
	local vector dir;

	local vector SourceGeoLocation, SourceGeoNormal;
	local vector VictimGeoLocation, VictimGeoNormal;

	if (Source.bHurtEntry)
		return;

	Source.bHurtEntry = true;

	if (CollChecker == none || CollChecker.bDeleteMe) {
		CollChecker = Spawn(class'ST_HitTestHelper',self, , Source.Location);
		CollChecker.bCollideWorld = false;
	}

	CollChecker.SetCollision(true, false, false);
	CollChecker.SetCollisionSize(DamageRadius, DamageRadius);
	CollChecker.SetLocation(HitLocation);

	foreach Source.VisibleCollidingActors(class'Actor', Victim, DamageRadius, HitLocation, , true) {
		if (Victim.IsA('Brush') == false)
			continue;

		dir = Victim.Location - HitLocation;
		dist = FMax(1,VSize(dir));
		dir = dir / dist; 
		damageScale = 1 - FMax(0, (dist - Victim.CollisionRadius) / DamageRadius);
		Victim.TakeDamage(
			damageScale * DamageAmount,
			Instigator, 
			Victim.Location - 0.5 * (Victim.CollisionHeight + Victim.CollisionRadius) * dir,
			(damageScale * Momentum * dir),
			DamageName
		);
	}

	foreach CollChecker.TouchingActors(class'Actor', Victim) {
		if (Victim == self)
			continue;

		if (Victim.IsA('StationaryPawn') && WeaponSettings.bEnhancedSplashIgnoreStationaryPawns) {
			// Revert to legacy handling
			dir = Victim.Location - HitLocation;
			dist = FMax(1,VSize(dir));
			dir = dir/dist; 
			damageScale = 1 - FMax(0,(dist - Victim.CollisionRadius)/DamageRadius);
		} else {
			Delta = Victim.Location - HitLocation;
			DeltaXY = Delta * vect(1.0, 1.0, 0.0);
			dist = VSize(Delta);
			dir = Normal(Delta);

			if (Abs(Delta.Z) <= Victim.CollisionHeight) {
				Closest = HitLocation + Normal(DeltaXY) * (VSize(DeltaXY) - Victim.CollisionRadius);
			} else if (VSize(DeltaXY) <= Victim.CollisionRadius) {
				if (Delta.Z > 0.0)
					Closest = HitLocation + FMax(Delta.Z - Victim.CollisionHeight, 0.0) * vect(0.0, 0.0, 1.0);
				else
					Closest = HitLocation + FMin(Delta.Z + Victim.CollisionHeight, 0.0) * vect(0.0, 0.0, 1.0);
			} else {
				// Closest point must be on the cylinder rims, find out where
				Closest = Victim.Location + dir * (Source.CollisionRadius / VSize(dir * vect(1.0, 1.0, 0.0)));
				if (Delta.Z > 0.0)
					Closest.Z = Victim.Location.Z - Victim.CollisionHeight;
				else
					Closest.Z = Victim.Location.Z + Victim.CollisionHeight;
			}

			Delta = Closest - HitLocation;
			if (VSize(Delta) > CollChecker.CollisionRadius)
				continue;

			dist = VSize(Delta);
			dir = Normal(Delta);

			if (FastTrace(Victim.Location, Source.Location) == false) {
				if (Victim.IsA('Pawn') == false)
					continue;

				// give Pawns a second chance to be hit
				if (HitTestHelper == none || HitTestHelper.bDeleteMe)
					HitTestHelper = Spawn(class'ST_HitTestHelper', self, , Source.Location);
				else
					HitTestHelper.SetLocation(Source.Location);

				HitTestHelper.FlyTowards(Victim.Location, DamageRadius);
				if (FastTrace(Victim.Location, HitTestHelper.Location) == false)
					continue;

				Trace(SourceGeoLocation, SourceGeoNormal, Closest, HitLocation, false);
				Trace(VictimGeoLocation, VictimGeoNormal, HitLocation, Closest, false);

				DamageDiffraction =
					FClamp(WeaponSettings.SplashMaxDiffraction, 0.0, 1.0) *
					FClamp((VSize(VictimGeoLocation - SourceGeoLocation) - WeaponSettings.SplashMinDiffractionDistance) / dist, 0.0, 1.0);
			}

			MomentumDelta = Victim.Location - HitLocation;
			MomentumDir = Normal(MomentumDelta);

			if (bIsRazor2Alt)
				MomentumDir.Z = FMin(0.45, MomentumDir.Z);

			damageScale = FMin(1.0 - dist/DamageRadius, 1.0); // apply upper bound to damage
			damageScale *= (1.0 - DamageDiffraction);
			MomentumScale = FClamp(1.0 - (VSize(MomentumDelta) - Victim.CollisionRadius)/DamageRadius, 0.0, 1.0);
			MomentumScale *= (1.0 - DamageDiffraction);
		}
		
		if (damageScale <= 0.0)
			continue;

		Victim.TakeDamage(
			damageScale * DamageAmount,
			Source.Instigator,
			Victim.Location - 0.5 * (Victim.CollisionRadius + Victim.CollisionHeight) * dir,
			(MomentumScale * Momentum * MomentumDir),
			DamageName
		);
	}

	CollChecker.SetCollision(false, false, false);

	Source.bHurtEntry = false;
}

function float GetPawnDuckFraction(Pawn P) {
	local bbPlayer bbP;
	bbP = bbPlayer(P);
	if (bbP != none) {
		return FClamp(bbP.DuckFraction, 0.0, 1.0);
	} else {
		return FClamp(1.0 - (P.EyeHeight / P.default.BaseEyeHeight), 0.0, 1.0);
	}
}

function float GetPawnBodyHalfHeight(Pawn P, float DuckFrac) {
	return Lerp(DuckFrac,
		P.CollisionHeight - WeaponSettings.HeadHalfHeight,
		(1.3 * 0.5)*P.CollisionHeight
	);
}

function float GetPawnBodyOffsetZ(Pawn P, float DuckFrac) {
	return Lerp(DuckFrac,
		-WeaponSettings.HeadHalfHeight,
		-(0.7 * 0.5)*P.CollisionHeight
	);
}

function bool CheckHeadShot(Pawn P, vector HitLocation, vector Direction) {
	local float DuckFrac;
	local float BodyOffsetZ;
	local float BodyHalfHeight, HeadHalfHeight;

	local ST_HitTestHelper HitActor;
	local vector HitLoc, HitNorm;
	local bool Result;

	if (P == none)
		return false;

	if (HitLocation.Z - P.Location.Z <= 0.3 * P.CollisionHeight)
		return false;

	if (CollChecker == none || CollChecker.bDeleteMe) {
		CollChecker = Spawn(class'ST_HitTestHelper',self, , P.Location);
		CollChecker.bCollideWorld = false;
	}

	DuckFrac = GetPawnDuckFraction(P);
	BodyOffsetZ = GetPawnBodyOffsetZ(P, DuckFrac);
	BodyHalfHeight = GetPawnBodyHalfHeight(P, DuckFrac);
	HeadHalfHeight = Lerp(DuckFrac,
		WeaponSettings.HeadHalfHeight,
		0
	);

	if (HeadHalfHeight <= 0.0)
		return false;

	CollChecker.SetCollision(true, false, false);
	CollChecker.SetCollisionSize(WeaponSettings.HeadRadius, WeaponSettings.HeadHalfHeight);
	CollChecker.SetLocation(P.Location + vect(0,0,1)*(BodyOffsetZ + BodyHalfHeight + HeadHalfHeight));

	Result = false;

	foreach TraceActors(
		class'ST_HitTestHelper',
		HitActor, HitLoc, HitNorm,
		HitLocation + Direction * (P.CollisionRadius + P.CollisionHeight),
		HitLocation - Direction * (P.CollisionRadius + P.CollisionHeight)
	) {
		if (HitActor == CollChecker) {
			Result = true;
			break;
		}
	}

	CollChecker.SetCollision(false, false, false);

	return Result;
}

function bool CheckBodyShot(Pawn P, vector HitLocation, vector Direction) {
	local float DuckFrac;
	local float HalfHeight;
	local float OffsetZ;

	local ST_HitTestHelper HitActor;
	local vector HitLoc, HitNorm;
	local bool Result;

	if (P == none)
		return false;

	if (CollChecker == none || CollChecker.bDeleteMe) {
		CollChecker = Spawn(class'ST_HitTestHelper',self, , P.Location);
		CollChecker.bCollideWorld = false;
	}

	DuckFrac = GetPawnDuckFraction(P);
	HalfHeight = GetPawnBodyHalfHeight(P, DuckFrac);
	OffsetZ = GetPawnBodyOffsetZ(P, DuckFrac);

	CollChecker.SetCollision(true, false, false);
	CollChecker.SetCollisionSize(P.CollisionRadius, HalfHeight);
	CollChecker.SetLocation(P.Location + vect(0,0,1)*OffsetZ);

	Result = false;

	foreach TraceActors(
		class'ST_HitTestHelper',
		HitActor, HitLoc, HitNorm,
		HitLocation + Direction * (P.CollisionRadius + P.CollisionHeight),
		HitLocation - Direction * (P.CollisionRadius + P.CollisionHeight)
	) {
		if (HitActor == CollChecker) {
			Result = true;
			break;
		}
	}

	CollChecker.SetCollision(false, false, false);

	return Result;
}

function Actor TraceShot(out vector HitLocation, out vector HitNormal, vector EndTrace, vector StartTrace, Pawn PawnOwner) {
	local Actor A, Other;
	local Pawn P;
	local bool bSProjBlocks;
	local bool bWeaponShock;
	local vector Dir;

	bSProjBlocks = WeaponSettings.ShockProjectileBlockBullets;
	bWeaponShock = (PawnOwner.Weapon != none && PawnOwner.Weapon.IsA('ShockRifle'));
	Dir = Normal(EndTrace - StartTrace);
	
	foreach TraceActors(class'Actor', A, HitLocation, HitNormal, EndTrace, StartTrace) {
		P = Pawn(A);
		if (P != none) {
			if (P == PawnOwner)
				continue;
			if (P.AdjustHitLocation(HitLocation, EndTrace - StartTrace) == false)
				continue;
			if (CheckBodyShot(P, HitLocation, Dir) == false && CheckHeadShot(P, HitLocation, Dir) == false)
				continue;

			Other = A;
		} else if ((A == Level) || (Mover(A) != None) || A.bProjTarget || (A.bBlockPlayers && A.bBlockActors)) {
			if (bSProjBlocks || A.IsA('ShockProj') == false || bWeaponShock)
				Other = A;
		}

		if (Other != none)
			break;
	}
	return Other;
}

defaultproperties {
	DefaultWeapon=Class'ST_ImpactHammer'

	DelaySpawnNotifyReplace=2
	bReplaceWeapons=True
}
