class IGPlus_WeaponImplementationBase extends IGPlus_WeaponImplementation;

var ST_HitTestHelper CollChecker;
var ST_HitTestHelper HitTestHelper;

function PostBeginPlay() {
	super.PostBeginPlay();

	HitTestHelper = Spawn(class'ST_HitTestHelper');
	CollChecker = Spawn(class'ST_HitTestHelper');
	CollChecker.SetCollision(true, false, false);
}

function EnhancedHurtRadius(
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
		if (Victim == Source)
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
				
				HitTestHelper.bCollideWorld = true;
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

final simulated function float GetPawnDuckFraction(Pawn P) {
	local bbPlayer bbP;
	bbP = bbPlayer(P);
	if (bbP != none) {
		if (Role < ROLE_Authority)
			return FClamp(bbP.DuckFractionRepl/255.0, 0.0, 1.0);
		else
			return FClamp(bbP.DuckFraction, 0.0, 1.0);
	} else {
		return FClamp(1.0 - (P.EyeHeight / P.default.BaseEyeHeight), 0.0, 1.0);
	}
}

final simulated function float GetPawnBodyHalfHeight(Pawn P, float DuckFrac) {
	return Lerp(DuckFrac,
		P.CollisionHeight - WSettingsRepl.HeadHalfHeight,
		(1.3 * 0.5)*P.CollisionHeight
	);
}

final simulated function float GetPawnBodyOffsetZ(Pawn P, float DuckFrac) {
	return Lerp(DuckFrac,
		-WSettingsRepl.HeadHalfHeight,
		-(0.7 * 0.5)*P.CollisionHeight
	);
}


simulated function bool CheckHeadShot(Pawn P, vector HitLocation, vector Direction) {
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
	}

	DuckFrac = GetPawnDuckFraction(P);
	BodyOffsetZ = GetPawnBodyOffsetZ(P, DuckFrac);
	BodyHalfHeight = GetPawnBodyHalfHeight(P, DuckFrac);
	HeadHalfHeight = Lerp(DuckFrac,
		WSettingsRepl.HeadHalfHeight,
		0
	);

	if (HeadHalfHeight <= 0.0)
		return false;

	CollChecker.SetCollision(true, false, false);
	CollChecker.SetCollisionSize(WSettingsRepl.HeadRadius, WSettingsRepl.HeadHalfHeight);
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

simulated function bool CheckBodyShot(Pawn P, vector HitLocation, vector Direction) {
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

function Actor TraceShot(
	out vector HitLocation,
	out vector HitNormal,
	vector EndTrace,
	vector StartTrace,
	Pawn PawnOwner
) {
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

}
