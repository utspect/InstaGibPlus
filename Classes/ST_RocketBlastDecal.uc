class ST_RocketBlastDecal extends WeaponEffect;

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
	Player.Spawn(class'Botpack.BlastMark',,,TargetLocation, rotator(HitNormal));
}

