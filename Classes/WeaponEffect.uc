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

static final function vector GetPlayerLocation(Actor PotentialPlayer) {
	if (PotentialPlayer.IsA('bbPlayer'))
		return bbPlayer(PotentialPlayer).IGPlus_CurrentLocation();
	return PotentialPlayer.Location;
}
