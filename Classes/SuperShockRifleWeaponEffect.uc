class SuperShockRifleWeaponEffect extends WeaponEffect
	abstract;

static function Play(
	PlayerPawn Player,
	ClientSettings Settings,
	PlayerReplicationInfo SourcePRI,
	vector SourceLocation,
	vector SourceOffset,
	Actor Target,
	vector TargetLocation,
	vector TargetOffset,
	vector HitNormal
) {
	local vector SmokeLocation;
	local vector HitLocation;

	if (Player.Level.NetMode == NM_DedicatedServer) return;

	if (SourcePRI.Owner != none && Settings.BeamOriginMode == 1) {
		SmokeLocation = SourcePRI.Owner.Location + SourceOffset;
	} else {
		SmokeLocation = SourceLocation;
	}

	if (Target != none && Settings.BeamDestinationMode == 1) {
		HitLocation = Target.Location + TargetOffset;
	} else {
		HitLocation = TargetLocation;
	}

	PlayBeam(Player, Settings, SourcePRI, SmokeLocation, HitLocation, HitNormal);
	PlayRing(Player, Settings, SourcePRI, HitLocation, HitNormal);
}

static function PlayBeam(
	PlayerPawn Player,
	ClientSettings Settings,
	PlayerReplicationInfo SourcePRI,
	vector SmokeLocation,
	vector HitLocation,
	vector HitNormal
) {
	local ClientSuperShockBeam Smoke;
	local Vector DVector;
	local int NumPoints;
	local rotator SmokeRotation;
	local vector MoveAmount;

	DVector = HitLocation - SmokeLocation;
	NumPoints = VSize(DVector) / 135.0;
	if ( NumPoints < 1 )
		return;
	SmokeRotation = rotator(DVector);
	SmokeRotation.roll = Rand(65535);

	if (Settings.cShockBeam == 3) return;
	if (Settings.bHideOwnBeam &&
		(SourcePRI.Owner == Player || SourcePRI.Owner == Player.ViewTarget) &&
		Player.bBehindView == false)
		return;

	Smoke = class'ClientSuperShockBeam'.static.AllocBeam(Player);
	if (Smoke == none) return;
	Smoke.SetLocation(SmokeLocation);
	Smoke.SetRotation(SmokeRotation);
	MoveAmount = DVector / NumPoints;

	if (Settings.cShockBeam == 1) {
		Smoke.SetProperties(
			-1,
			1,
			1,
			0.27,
			MoveAmount,
			NumPoints - 1);

	} else if (Settings.cShockBeam == 2) {
		Smoke.SetProperties(
			SourcePRI.Team,
			Settings.BeamScale,
			Settings.BeamFadeCurve,
			Settings.BeamDuration,
			MoveAmount,
			NumPoints - 1);

	} else if (Settings.cShockBeam == 4) {
		Smoke.SetProperties(
			SourcePRI.Team,
			Settings.BeamScale,
			Settings.BeamFadeCurve,
			Settings.BeamDuration,
			MoveAmount,
			0);

		for (NumPoints = NumPoints - 1; NumPoints > 0; NumPoints--) {
			SmokeLocation += MoveAmount;
			Smoke = class'ClientSuperShockBeam'.static.AllocBeam(Player);
			if (Smoke == None) break;
			Smoke.SetLocation(SmokeLocation);
			Smoke.SetRotation(SmokeRotation);
			Smoke.SetProperties(
				SourcePRI.Team,
				Settings.BeamScale,
				Settings.BeamFadeCurve,
				Settings.BeamDuration,
				MoveAmount,
				0);
		}
	}
}

static function PlayRing(
	PlayerPawn Player,
	ClientSettings Settings,
	PlayerReplicationInfo SourcePRI,
	vector HitLocation,
	vector HitNormal
) {
	local Actor A;

	switch(Settings.SSRRingType) {
		case 0:
			A = Player.Spawn(class'EnergyImpact',,, HitLocation,rotator(HitNormal));
			if (A != none) {
				A.RemoteRole = ROLE_None;
				A.PlayOwnedSound(Sound'UnrealShare.General.Explo1',,12.0,,2200);
			}
			break;
		case 1:
			A = Player.Spawn(class'UT_Superring2',,, HitLocation+HitNormal*8,rotator(HitNormal));
			A.RemoteRole = ROLE_None;
			break;
		case 2:
			if (SourcePRI.Team == 1) {
				A = Player.Spawn(class'NN_UT_RingExplosion',,, HitLocation+HitNormal*8,rotator(HitNormal));
				A.RemoteRole = ROLE_None;
				A = Player.Spawn(class'EnergyImpact',,, HitLocation,rotator(HitNormal));
				if (A != none) A.RemoteRole = ROLE_None;
			} else {
				A = Player.Spawn(class'UT_Superring2',,, HitLocation+HitNormal*8,rotator(HitNormal));
				A.RemoteRole = ROLE_None;
			}
			breaK;
	}
}
