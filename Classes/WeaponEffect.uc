class WeaponEffect extends Object
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
);

static function Send(
	LevelInfo Level,
	class<WeaponEffect> Effect,
	PlayerReplicationInfo SourcePRI,
	vector SourceLocation,
	vector SourceOffset,
	Actor Target,
	vector TargetLocation,
	vector TargetOffset,
	vector HitNormal,
	optional Pawn Exclude
) {
	local Pawn P;

	for (P = Level.PawnList; P != none; P = P.NextPawn) {
		if (P == Exclude) continue;
		if (bbPlayer(P) != none)
			bbPlayer(P).SendWeaponEffect(
				Effect,
				SourcePRI,
				SourceLocation,
				SourceOffset,
				Target,
				TargetLocation,
				TargetOffset,
				HitNormal);
		else if (bbCHSpectator(P) != none)
			bbCHSpectator(P).SendWeaponEffect(
				Effect,
				SourcePRI,
				SourceLocation,
				SourceOffset,
				Target,
				TargetLocation,
				TargetOffset,
				HitNormal);
	}
}

static final function vector GetPlayerLocation(Actor PotentialPlayer) {
	if (PotentialPlayer.IsA('bbPlayer'))
		return bbPlayer(PotentialPlayer).IGPlus_CurrentLocation();
	return PotentialPlayer.Location;
}
