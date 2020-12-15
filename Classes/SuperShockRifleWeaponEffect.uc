class SuperShockRifleWeaponEffect extends WeaponEffect
	abstract;

static function Play(
	PlayerPawn Player,
	ClientSettings Settings,
	Actor Source,
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

	if (Settings.BeamOriginMode == 1) {
		SmokeLocation = Source.Location + SourceOffset;
	} else {
		SmokeLocation = SourceLocation;
	}

	if (Target != none && Settings.BeamDestinationMode == 1) {
		HitLocation = Target.Location + TargetOffset;
	} else {
		HitLocation = TargetLocation;
	}

	PlayBeam(Player, Settings, Source, SmokeLocation, HitLocation, HitNormal);
	PlayRing(Player, Settings, Source, HitLocation, HitNormal);
}

static function PlayBeam(
	PlayerPawn Player,
	ClientSettings Settings,
	Actor Source,
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
		(Source == Player || Source == Player.ViewTarget) &&
		Player.bBehindView == false)
		return;

	Smoke = Player.Spawn(class'ClientSuperShockBeam',Source,, SmokeLocation, SmokeRotation);
	if (Smoke == none) return;
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
			PlayerPawn(Source).PlayerReplicationInfo.Team,
			Settings.BeamScale,
			Settings.BeamFadeCurve,
			Settings.BeamDuration,
			MoveAmount,
			NumPoints - 1);

	} else if (Settings.cShockBeam == 4) {
		Smoke.SetProperties(
			PlayerPawn(Source).PlayerReplicationInfo.Team,
			Settings.BeamScale,
			Settings.BeamFadeCurve,
			Settings.BeamDuration,
			MoveAmount,
			0);

		for (NumPoints = NumPoints - 1; NumPoints > 0; NumPoints--) {
			SmokeLocation += MoveAmount;
			Smoke = Player.Spawn(class'ClientSuperShockBeam',Source,, SmokeLocation, SmokeRotation);
			if (Smoke == None) break;
			Smoke.SetProperties(
				PlayerPawn(Source).PlayerReplicationInfo.Team,
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
	Actor Source,
	vector HitLocation,
	vector HitNormal
) {
	local Actor A;
	if (Settings.cShockBeam >= 2 && PlayerPawn(Source).PlayerReplicationInfo.Team == 1) {
		A = Player.Spawn(class'NN_UT_RingExplosion',,, HitLocation+HitNormal*8,rotator(HitNormal));
		A.RemoteRole = ROLE_None;
		A = Player.Spawn(class'EnergyImpact');
		if (A != none) A.RemoteRole = ROLE_None;
	} else {
		A = Player.Spawn(class'UT_Superring2',,, HitLocation+HitNormal*8,rotator(HitNormal));
		A.RemoteRole = ROLE_None;
	}
}
