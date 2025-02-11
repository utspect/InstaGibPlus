class ST_ShockProj extends ShockProj;

var IGPlus_WeaponImplementation WImp;
var WeaponSettingsRepl WSettings;

// For ShockProjectileTakeDamage
var float Health;

var PlayerPawn InstigatingPlayer;
var vector ExtrapolationDelta;

simulated final function WeaponSettingsRepl FindWeaponSettings() {
	local WeaponSettingsRepl S;

	foreach AllActors(class'WeaponSettingsRepl', S)
		return S;

	return none;
}

simulated final function WeaponSettingsRepl GetWeaponSettings() {
	if (WSettings != none)
		return WSettings;

	WSettings = FindWeaponSettings();
	return WSettings;
}

simulated function PostBeginPlay() {
	if (Instigator != none && Instigator.Role == ROLE_Authority) {
		ForEach AllActors(Class'IGPlus_WeaponImplementation', WImp)
			break; // Find master :D

		if (WImp.WeaponSettings.ShockProjectileTakeDamage) {
			Health = WImp.WeaponSettings.ShockProjectileHealth;
		}
	}
	Super.PostBeginPlay();
}

simulated function PostNetBeginPlay() {
	local PlayerPawn In;
	local ST_ShockRifle SR;

	super.PostNetBeginPlay();

	if (GetWeaponSettings().ShockProjectileCompensatePing) {
		In = PlayerPawn(Instigator);
		if (In != none && Viewport(In.Player) != none)
			InstigatingPlayer = In;

		if (InstigatingPlayer != none) {
			SR = ST_ShockRifle(InstigatingPlayer.Weapon);
			if (SR != none && SR.LocalDummy != none && SR.LocalDummy.bDeleteMe == false)
				SR.LocalDummy.Destroy();
		}
	} else {
		Disable('Tick');
	}
}

simulated event Tick(float Delta) {
	local vector NewXPolDelta;
	super.Tick(Delta);

	if (InstigatingPlayer == none)
		return;

	// Catch up to server
	if (OldLocation == Location)
		MoveSmooth(Velocity * (0.0005 * InstigatingPlayer.PlayerReplicationInfo.Ping));

	// Extrapolate locally to compensate for ping
	NewXPolDelta = (Velocity * (0.0005 * InstigatingPlayer.PlayerReplicationInfo.Ping));
	MoveSmooth(NewXPolDelta - ExtrapolationDelta);
	ExtrapolationDelta = NewXPolDelta;
}

function SuperExplosion() {
	if (WImp.WeaponSettings.bEnableEnhancedSplashShockCombo) {
		WImp.EnhancedHurtRadius(
			self,
			WImp.WeaponSettings.ShockComboDamage,
			WImp.WeaponSettings.ShockComboHurtRadius,
			MyDamageType,
			WImp.WeaponSettings.ShockComboMomentum * MomentumTransfer * 2,
			Location);
	} else {
		HurtRadius(
			WImp.WeaponSettings.ShockComboDamage,
			WImp.WeaponSettings.ShockComboHurtRadius,
			MyDamageType,
			WImp.WeaponSettings.ShockComboMomentum * MomentumTransfer * 2,
			Location);
	}
	
	Spawn(Class'ut_ComboRing',,'',Location, Instigator.ViewRotation);
	PlaySound(ExploSound,,20.0,,2000,0.6);	
	
	Destroy(); 
}

function Explode(vector HitLocation,vector HitNormal) {
	PlaySound(ImpactSound, SLOT_Misc, 0.5,,, 0.5+FRand());
	if (WImp.WeaponSettings.bEnableEnhancedSplashShockProjectile) {
		WImp.EnhancedHurtRadius(
			self,
			WImp.WeaponSettings.ShockProjectileDamage,
			WImp.WeaponSettings.ShockProjectileHurtRadius,
			MyDamageType,
			WImp.WeaponSettings.ShockProjectileMomentum * MomentumTransfer,
			Location);
	} else {
		HurtRadius(
			WImp.WeaponSettings.ShockProjectileDamage,
			WImp.WeaponSettings.ShockProjectileHurtRadius,
			MyDamageType,
			WImp.WeaponSettings.ShockProjectileMomentum * MomentumTransfer,
			Location);
	}
	if (WImp.WeaponSettings.ShockProjectileDamage > 60)
		Spawn(class'ut_RingExplosion3',,, HitLocation+HitNormal*8,rotator(HitNormal));
	else
		Spawn(class'ut_RingExplosion',,, HitLocation+HitNormal*8,rotator(Velocity));		

	Destroy();
}

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType) {
	if (WImp.WeaponSettings.ShockProjectileTakeDamage == false)
		return;

	if (DamageType == 'Pulsed'|| DamageType == 'Corroded') {
		Health -= Damage;
		if (Health <= 0) {
			Spawn(class'ut_RingExplosion',,, Location + Momentum * 0.1, rotator(Momentum));
			Destroy();
		}
	}
}

defaultproperties {
}
