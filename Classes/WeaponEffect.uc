class WeaponEffect extends Object
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
);
