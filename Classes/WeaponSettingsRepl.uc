class WeaponSettingsRepl extends Actor;

var float WarheadSelectTime;
var float WarheadDownTime;

var float SniperSelectTime;
var float SniperDownTime;
var float SniperDamage;
var float SniperHeadshotDamage;
var float SniperMomentum;
var float SniperHeadshotMomentum;
var float SniperReloadTime;

var float EightballSelectTime;
var float EightballDownTime;
var float RocketDamage;
var float RocketHurtRadius;
var float RocketMomentum;
var float RocketSpreadSpacingDegrees;
var float GrenadeDamage;
var float GrenadeHurtRadius;
var float GrenadeMomentum;

var float FlakSelectTime;
var float FlakPostSelectTime;
var float FlakDownTime;
var float FlakChunkDamage;
var float FlakChunkMomentum;
var float FlakSlugDamage;
var float FlakSlugHurtRadius;
var float FlakSlugMomentum;

var float RipperSelectTime;
var float RipperDownTime;
var float RipperHeadshotDamage;
var float RipperHeadshotMomentum;
var float RipperPrimaryDamage;
var float RipperPrimaryMomentum;
var float RipperSecondaryHurtRadius;
var float RipperSecondaryDamage;
var float RipperSecondaryMomentum;

var float MinigunSelectTime;
var float MinigunDownTime;
var float MinigunSpinUpTime;
var float MinigunUnwindTime;
var float MinigunBulletInterval;
var float MinigunAlternateBulletInterval;
var float MinigunMinDamage;
var float MinigunMaxDamage;

var float PulseSelectTime;
var float PulseDownTime;
var float PulseSphereDamage;
var float PulseSphereMomentum;
var float PulseBoltDPS;
var float PulseBoltMomentum;
var float PulseBoltMaxAccumulate;
var float PulseBoltGrowthDelay;
var int   PulseBoltMaxSegments;

var float ShockSelectTime;
var float ShockDownTime;
var float ShockBeamDamage;
var float ShockBeamMomentum;
var float ShockProjectileDamage;
var float ShockProjectileHurtRadius;
var float ShockProjectileMomentum;
var float ShockComboDamage;
var float ShockComboMomentum;
var float ShockComboHurtRadius;

var float BioSelectTime;
var float BioDownTime;
var float BioDamage;
var float BioMomentum;
var float BioAltDamage;
var float BioAltMomentum;
var float BioHurtRadiusBase;
var float BioHurtRadiusMax;

var float EnforcerSelectTime;
var float EnforcerDownTime;
var float EnforcerDamage;
var float EnforcerMomentum;
var float EnforcerReloadTime;
var float EnforcerReloadTimeAlt;
var float EnforcerReloadTimeRepeat;

var bool  EnforcerAllowDouble;
var float EnforcerDamageDouble;
var float EnforcerMomentumDouble;
var float EnforcerShotOffsetDouble;
var float EnforcerReloadTimeDouble;
var float EnforcerReloadTimeAltDouble;
var float EnforcerReloadTimeRepeatDouble;

var float HammerSelectTime;
var float HammerDownTime;
var float HammerDamage;
var float HammerMomentum;
var float HammerSelfDamage;
var float HammerSelfMomentum;
var float HammerAltDamage;
var float HammerAltMomentum;
var float HammerAltSelfDamage;
var float HammerAltSelfMomentum;

var float TranslocatorSelectTime;
var float TranslocatorOutSelectTime;
var float TranslocatorDownTime;
var float TranslocatorHealth;

replication {
	reliable if (Role == ROLE_Authority)
		WarheadSelectTime,
		WarheadDownTime,

		SniperSelectTime,
		SniperDownTime,
		SniperDamage,
		SniperHeadshotDamage,
		SniperMomentum,
		SniperHeadshotMomentum,
		SniperReloadTime,

		EightballSelectTime,
		EightballDownTime,
		RocketDamage,
		RocketHurtRadius,
		RocketMomentum,
		GrenadeDamage,
		GrenadeHurtRadius,
		GrenadeMomentum,

		FlakSelectTime,
		FlakPostSelectTime,
		FlakDownTime,
		FlakChunkDamage,
		FlakChunkMomentum,
		FlakSlugDamage,
		FlakSlugHurtRadius,
		FlakSlugMomentum,

		RipperSelectTime,
		RipperDownTime,
		RipperHeadshotDamage,
		RipperHeadshotMomentum,
		RipperPrimaryDamage,
		RipperPrimaryMomentum,
		RipperSecondaryHurtRadius,
		RipperSecondaryDamage,
		RipperSecondaryMomentum,

		MinigunSelectTime,
		MinigunDownTime,
		MinigunSpinUpTime,
		MinigunUnwindTime,
		MinigunBulletInterval,
		MinigunAlternateBulletInterval,
		MinigunMinDamage,
		MinigunMaxDamage,

		PulseSelectTime,
		PulseDownTime,
		PulseSphereDamage,
		PulseSphereMomentum,
		PulseBoltDPS,
		PulseBoltMomentum,
		PulseBoltMaxAccumulate,
		PulseBoltGrowthDelay,
		PulseBoltMaxSegments,

		ShockSelectTime,
		ShockDownTime,
		ShockBeamDamage,
		ShockBeamMomentum,
		ShockProjectileDamage,
		ShockProjectileHurtRadius,
		ShockProjectileMomentum,
		ShockComboDamage,
		ShockComboMomentum,
		ShockComboHurtRadius,

		BioSelectTime,
		BioDownTime,
		BioDamage,
		BioMomentum,
		BioAltDamage,
		BioAltMomentum,
		BioHurtRadiusBase,
		BioHurtRadiusMax,

		EnforcerSelectTime,
		EnforcerDownTime,
		EnforcerDamage,
		EnforcerMomentum,
		EnforcerReloadTime,
		EnforcerReloadTimeAlt,
		EnforcerReloadTimeRepeat,

		EnforcerAllowDouble,
		EnforcerDamageDouble,
		EnforcerMomentumDouble,
		EnforcerShotOffsetDouble,
		EnforcerReloadTimeDouble,
		EnforcerReloadTimeAltDouble,
		EnforcerReloadTimeRepeatDouble,

		HammerSelectTime,
		HammerDownTime,
		HammerDamage,
		HammerMomentum,
		HammerSelfDamage,
		HammerSelfMomentum,
		HammerAltDamage,
		HammerAltMomentum,
		HammerAltSelfDamage,
		HammerAltSelfMomentum,

		TranslocatorSelectTime,
		TranslocatorOutSelectTime,
		TranslocatorDownTime,
		TranslocatorHealth;
}

simulated final function float WarheadSelectAnimSpeed() {
	if (WarheadSelectTime > 0.0)
		return FMin(100.0, default.WarheadSelectTime / WarheadSelectTime);
	return 100.0;
}

simulated final function float WarheadDownAnimSpeed() {
	if (WarheadDownTime > 0.0)
		return FMin(100.0, default.WarheadDownTime / WarheadDownTime);
	return 100.0;
}

simulated final function float SniperSelectAnimSpeed() {
	if (SniperSelectTime > 0.0)
		return FMin(100.0, default.SniperSelectTime / SniperSelectTime);
	return 100.0;
}

simulated final function float SniperDownAnimSpeed() {
	if (SniperDownTime > 0.0)
		return FMin(100.0, default.SniperDownTime / SniperDownTime);
	return 100.0;
}

simulated final function float SniperReloadAnimSpeed() {
	if (SniperReloadTime > 0.0)
		return FMin(100.0, default.SniperReloadTime / SniperReloadTime);
	return 100.0;
}

simulated final function float EightballSelectAnimSpeed() {
	if (EightballSelectTime > 0.0)
		return FMin(100.0, default.EightballSelectTime / EightballSelectTime);
	return 100.0;
}

simulated final function float EightballDownAnimSpeed() {
	if (EightballDownTime > 0.0)
		return FMin(100.0, default.EightballDownTime / EightballDownTime);
	return 100.0;
}

simulated final function float FlakSelectAnimSpeed() {
	if (FlakSelectTime > 0.0)
		return FMin(100.0, default.FlakSelectTime / FlakSelectTime);
	return 100.0;
}

simulated final function float FlakPostSelectAnimSpeed() {
	if (FlakPostSelectTime > 0.0)
		return FMin(100.0, 1.3 * default.FlakPostSelectTime / FlakPostSelectTime);
	return 100.0;
}

simulated final function float FlakDownAnimSpeed() {
	if (FlakDownTime > 0.0)
		return FMin(100.0, default.FlakDownTime / FlakDownTime);
	return 100.0;
}

simulated final function float RipperSelectAnimSpeed() {
	if (RipperSelectTime > 0.0)
		return FMin(100.0, default.RipperSelectTime / RipperSelectTime);
	return 100.0;
}

simulated final function float RipperDownAnimSpeed() {
	if (RipperDownTime > 0.0)
		return FMin(100.0, default.RipperDownTime / RipperDownTime);
	return 100.0;
}

simulated final function float MinigunSelectAnimSpeed() {
	if (MinigunSelectTime > 0.0)
		return FMin(100.0, default.MinigunSelectTime / MinigunSelectTime);
	return 100.0;
}

simulated final function float MinigunDownAnimSpeed() {
	if (MinigunDownTime > 0.0)
		return FMin(100.0, default.MinigunDownTime / MinigunDownTime);
	return 100.0;
}

simulated final function float MinigunUnwindAnimSpeed() {
	if (MinigunUnwindTime > 0.0)
		return FMin(100.0, 1.5 * default.MinigunUnwindTime / MinigunUnwindTime);
	return 100.0;
}

simulated final function float PulseSelectAnimSpeed() {
	if (PulseSelectTime > 0.0)
		return FMin(100.0, default.PulseSelectTime / PulseSelectTime);
	return 100.0;
}

simulated final function float ShockSelectAnimSpeed() {
	if (ShockSelectTime > 0.0)
		return FMin(100.0, default.ShockSelectTime / ShockSelectTime);
	return 100.0;
}

simulated final function float ShockDownAnimSpeed() {
	if (ShockDownTime > 0.0)
		return FMin(100.0, default.ShockDownTime / ShockDownTime);
	return 100.0;
}

simulated final function float BioSelectAnimSpeed() {
	if (BioSelectTime > 0.0)
		return FMin(100.0, default.BioSelectTime / BioSelectTime);
	return 100.0;
}

simulated final function float BioDownAnimSpeed() {
	if (BioDownTime > 0.0)
		return FMin(100.0, default.BioDownTime / BioDownTime);
	return 100.0;
}

simulated final function float EnforcerSelectAnimSpeed() {
	if (EnforcerSelectTime > 0.0)
		return FMin(100.0, default.EnforcerSelectTime / EnforcerSelectTime);
	return 100.0;
}

simulated final function float EnforcerDownAnimSpeed() {
	if (EnforcerDownTime > 0.0)
		return FMin(100.0, default.EnforcerDownTime / EnforcerDownTime);
	return 100.0;
}

simulated final function float EnforcerReloadAnimSpeed() {
	if (EnforcerReloadTime > 0.0)
		return FMin(100.0, default.EnforcerReloadTime / EnforcerReloadTime);
	return 100.0;
}

simulated final function float EnforcerReloadAltAnimSpeed() {
	if (EnforcerReloadTimeAlt > 0.0)
		return FMin(100.0, default.EnforcerReloadTimeAlt / EnforcerReloadTimeAlt);
	return 100.0;
}

simulated final function float EnforcerReloadRepeatAnimSpeed() {
	if (EnforcerReloadTimeRepeat > 0.0)
		return FMin(100.0, default.EnforcerReloadTimeRepeat / EnforcerReloadTimeRepeat);
	return 100.0;
}

simulated final function float EnforcerReloadDoubleAnimSpeed() {
	if (EnforcerReloadTimeDouble > 0.0)
		return FMin(100.0, default.EnforcerReloadTimeDouble / EnforcerReloadTimeDouble);
	return 100.0;
}

simulated final function float EnforcerReloadAltDoubleAnimSpeed() {
	if (EnforcerReloadTimeAltDouble > 0.0)
		return FMin(100.0, default.EnforcerReloadTimeAltDouble / EnforcerReloadTimeAltDouble);
	return 100.0;
}

simulated final function float EnforcerReloadRepeatDoubleAnimSpeed() {
	if (EnforcerReloadTimeRepeatDouble > 0.0)
		return FMin(100.0, default.EnforcerReloadTimeRepeatDouble / EnforcerReloadTimeRepeatDouble);
	return 100.0;
}

simulated final function float HammerSelectAnimSpeed() {
	if (HammerSelectTime > 0.0)
		return FMin(100.0, default.HammerSelectTime / HammerSelectTime);
	return 100.0;
}

simulated final function float HammerDownAnimSpeed() {
	if (HammerDownTime > 0.0)
		return FMin(100.0, default.HammerDownTime / HammerDownTime);
	return 100.0;
}

simulated final function float TranslocatorSelectAnimSpeed() {
	if (TranslocatorSelectTime > 0.0)
		return FMin(100.0, 1.1 * default.TranslocatorSelectTime / TranslocatorSelectTime);
	return 100.0;
}

simulated final function float TranslocatorDownAnimSpeed() {
	if (TranslocatorDownTime > 0.0)
		return FMin(100.0, 1.1 * default.TranslocatorDownTime / TranslocatorDownTime);
	return 100.0;
}

function InitFromWeaponSettings(WeaponSettings S) {
	WarheadSelectTime = S.WarheadSelectTime;
	WarheadDownTime = S.WarheadDownTime;

	SniperSelectTime = S.SniperSelectTime;
	SniperDownTime = S.SniperDownTime;
	SniperDamage = S.SniperDamage;
	SniperHeadshotDamage = S.SniperHeadshotDamage;
	SniperMomentum = S.SniperMomentum;
	SniperHeadshotMomentum = S.SniperHeadshotMomentum;
	SniperReloadTime = S.SniperReloadTime;

	EightballSelectTime = S.EightballSelectTime;
	EightballDownTime = S.EightballDownTime;
	RocketDamage = S.RocketDamage;
	RocketHurtRadius = S.RocketHurtRadius;
	RocketMomentum = S.RocketMomentum;
	RocketSpreadSpacingDegrees = S.RocketSpreadSpacingDegrees;
	GrenadeDamage = S.GrenadeDamage;
	GrenadeHurtRadius = S.GrenadeHurtRadius;
	GrenadeMomentum = S.GrenadeMomentum;

	FlakSelectTime = S.FlakSelectTime;
	FlakPostSelectTime = S.FlakPostSelectTime;
	FlakDownTime = S.FlakDownTime;
	FlakChunkDamage = S.FlakChunkDamage;
	FlakChunkMomentum = S.FlakChunkMomentum;
	FlakSlugDamage = S.FlakSlugDamage;
	FlakSlugHurtRadius = S.FlakSlugHurtRadius;
	FlakSlugMomentum = S.FlakSlugMomentum;

	RipperSelectTime = S.RipperSelectTime;
	RipperDownTime = S.RipperDownTime;
	RipperHeadshotDamage = S.RipperHeadshotDamage;
	RipperHeadshotMomentum = S.RipperHeadshotMomentum;
	RipperPrimaryDamage = S.RipperPrimaryDamage;
	RipperPrimaryMomentum = S.RipperPrimaryMomentum;
	RipperSecondaryHurtRadius = S.RipperSecondaryHurtRadius;
	RipperSecondaryDamage = S.RipperSecondaryDamage;
	RipperSecondaryMomentum = S.RipperSecondaryMomentum;

	MinigunSelectTime = S.MinigunSelectTime;
	MinigunDownTime = S.MinigunDownTime;
	MinigunSpinUpTime = S.MinigunSpinUpTime;
	MinigunUnwindTime = S.MinigunUnwindTime;
	MinigunBulletInterval = S.MinigunBulletInterval;
	MinigunAlternateBulletInterval = S.MinigunAlternateBulletInterval;
	MinigunMinDamage = S.MinigunMinDamage;
	MinigunMaxDamage = S.MinigunMaxDamage;

	PulseSelectTime = S.PulseSelectTime;
	PulseDownTime = S.PulseDownTime;
	PulseSphereDamage = S.PulseSphereDamage;
	PulseSphereMomentum = S.PulseSphereMomentum;
	PulseBoltDPS = S.PulseBoltDPS;
	PulseBoltMomentum = S.PulseBoltMomentum;
	PulseBoltMaxAccumulate = S.PulseBoltMaxAccumulate;
	PulseBoltGrowthDelay = S.PulseBoltGrowthDelay;
	PulseBoltMaxSegments = S.PulseBoltMaxSegments;

	ShockSelectTime = S.ShockSelectTime;
	ShockDownTime = S.ShockDownTime;
	ShockBeamDamage = S.ShockBeamDamage;
	ShockBeamMomentum = S.ShockBeamMomentum;
	ShockProjectileDamage = S.ShockProjectileDamage;
	ShockProjectileHurtRadius = S.ShockProjectileHurtRadius;
	ShockProjectileMomentum = S.ShockProjectileMomentum;
	ShockComboDamage = S.ShockComboDamage;
	ShockComboMomentum = S.ShockComboMomentum;
	ShockComboHurtRadius = S.ShockComboHurtRadius;

	BioSelectTime = S.BioSelectTime;
	BioDownTime = S.BioDownTime;
	BioDamage = S.BioDamage;
	BioMomentum = S.BioMomentum;
	BioAltDamage = S.BioAltDamage;
	BioAltMomentum = S.BioAltMomentum;
	BioHurtRadiusBase = S.BioHurtRadiusBase;
	BioHurtRadiusMax = S.BioHurtRadiusMax;

	EnforcerSelectTime = S.EnforcerSelectTime;
	EnforcerDownTime = S.EnforcerDownTime;
	EnforcerDamage = S.EnforcerDamage;
	EnforcerMomentum = S.EnforcerMomentum;
	EnforcerReloadTime = S.EnforcerReloadTime;
	EnforcerReloadTimeAlt = S.EnforcerReloadTimeAlt;
	EnforcerReloadTimeRepeat = S.EnforcerReloadTimeRepeat;

	EnforcerAllowDouble = S.EnforcerAllowDouble;
	EnforcerDamageDouble = S.EnforcerDamageDouble;
	EnforcerMomentumDouble = S.EnforcerMomentumDouble;
	EnforcerShotOffsetDouble = S.EnforcerShotOffsetDouble;
	EnforcerReloadTimeDouble = S.EnforcerReloadTimeDouble;
	EnforcerReloadTimeAltDouble = S.EnforcerReloadTimeAltDouble;
	EnforcerReloadTimeRepeatDouble = S.EnforcerReloadTimeRepeatDouble;

	HammerSelectTime = S.HammerSelectTime;
	HammerDownTime = S.HammerDownTime;
	HammerDamage = S.HammerDamage;
	HammerMomentum = S.HammerMomentum;
	HammerSelfDamage = S.HammerSelfDamage;
	HammerSelfMomentum = S.HammerSelfMomentum;
	HammerAltDamage = S.HammerAltDamage;
	HammerAltMomentum = S.HammerAltMomentum;
	HammerAltSelfDamage = S.HammerAltSelfDamage;
	HammerAltSelfMomentum = S.HammerAltSelfMomentum;

	TranslocatorSelectTime = S.TranslocatorSelectTime;
	TranslocatorOutSelectTime = S.TranslocatorOutSelectTime;
	TranslocatorDownTime = S.TranslocatorDownTime;
	TranslocatorHealth = S.TranslocatorHealth;
}

final static function CreateWeaponSettings(
	LevelInfo L,
	string DefaultName,
	out WeaponSettings WS,
	out WeaponSettingsRepl WSR
) {
	local Object Helper;
	local string Options;
	local int Pos;
	local string SettingsName;
	local StringUtils SU;

	Options = L.GetLocalURL();
	Pos = InStr(Options, "?");
	if (Pos < 0)
		Options = "";
	else
		Options = Mid(Options, Pos);

	SU = class'StringUtils'.static.Instance();

	SettingsName = L.Game.ParseOption(Options, "IGPlusWeaponSettings");
	if (SettingsName == "")
		SettingsName = DefaultName;

	Helper = new(none, 'InstaGibPlus') class'Object';
	WS = new(Helper, SU.StringToName(SettingsName)) class'WeaponSettings';
	WS.SaveConfig();
	WSR = L.Spawn(class'WeaponSettingsRepl');
	WSR.InitFromWeaponSettings(WS);
}

defaultproperties
{
	RemoteRole=ROLE_DumbProxy
	bHidden=True
	bAlwaysRelevant=True
	DrawType=DT_None

	WarheadSelectTime=0.5
	WarheadDownTime=0.233333

	SniperSelectTime=0.607143
	SniperDownTime=0.233333
	SniperDamage=45
	SniperHeadshotDamage=100
	SniperMomentum=1.0
	SniperHeadshotMomentum=1.0
	SniperReloadTime=0.6666666666

	EightballSelectTime=0.606061
	EightballDownTime=0.366667
	RocketDamage=75
	RocketHurtRadius=220
	RocketMomentum=1.0
	RocketSpreadSpacingDegrees=3.6
	GrenadeDamage=80
	GrenadeHurtRadius=200
	GrenadeMomentum=1.0

	FlakSelectTime=0.625
	FlakPostSelectTime=0.384615
	FlakDownTime=0.333333
	FlakChunkDamage=16
	FlakChunkMomentum=1.0
	FlakSlugDamage=70
	FlakSlugHurtRadius=150
	FlakSlugMomentum=1.0

	RipperSelectTime=0.75
	RipperDownTime=0.2
	RipperHeadshotDamage=105
	RipperHeadshotMomentum=1.0
	RipperPrimaryDamage=30
	RipperPrimaryMomentum=1.0
	RipperSecondaryHurtRadius=180
	RipperSecondaryDamage=34
	RipperSecondaryMomentum=1.0

	MinigunSelectTime=0.555556
	MinigunDownTime=0.333333
	MinigunSpinUpTime=0.130
	MinigunUnwindTime=0.866666
	MinigunBulletInterval=0.080
	MinigunAlternateBulletInterval=0.050
	MinigunMinDamage=5
	MinigunMaxDamage=7

	PulseSelectTime=0.444444
	PulseDownTime=0.26
	PulseSphereDamage=20
	PulseSphereMomentum=1.0
	PulseBoltDPS=72
	PulseBoltMomentum=1.0
	PulseBoltMaxAccumulate=0.08
	PulseBoltGrowthDelay=0.05
	PulseBoltMaxSegments=10

	ShockSelectTime=0.5
	ShockDownTime=0.259259
	ShockBeamDamage=40
	ShockBeamMomentum=1.0
	ShockProjectileDamage=55
	ShockProjectileHurtRadius=70
	ShockProjectileMomentum=1.0
	ShockComboDamage=165
	ShockComboHurtRadius=250
	ShockComboMomentum=1.0

	BioSelectTime=0.488889
	BioDownTime=0.333333
	BioDamage=20
	BioMomentum=1.0
	BioAltDamage=75
	BioAltMomentum=1.0
	BioHurtRadiusBase=75
	BioHurtRadiusMax=250

	EnforcerSelectTime=0.777778
	EnforcerDownTime=0.266667
	EnforcerDamage=17
	EnforcerMomentum=1.0
	EnforcerReloadTime=0.27
	EnforcerReloadTimeAlt=0.26
	EnforcerReloadTimeRepeat=0.266667

	EnforcerAllowDouble=True
	EnforcerDamageDouble=17
	EnforcerMomentumDouble=1.0
	EnforcerShotOffsetDouble=0.2
	EnforcerReloadTimeDouble=0.27
	EnforcerReloadTimeAltDouble=0.26
	EnforcerReloadTimeRepeatDouble=0.266667

	HammerSelectTime=0.566667
	HammerDownTime=0.166667
	HammerDamage=60
	HammerMomentum=1.0
	HammerSelfDamage=36
	HammerSelfMomentum=1.0
	HammerAltDamage=20
	HammerAltMomentum=1.0
	HammerAltSelfDamage=24
	HammerAltSelfMomentum=1.0

	TranslocatorSelectTime=0.363636
	TranslocatorOutSelectTime=0.27
	TranslocatorDownTime=0.212121
	TranslocatorHealth=65.0
}