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
