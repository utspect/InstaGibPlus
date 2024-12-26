// ===============================================================
// UTPureStats7A.ST_StarterBolt: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_StarterBolt extends ST_PBolt;

var float OldError, NewError, StartError, AimError; //used for bot aiming
var rotator AimRotation;
var float AnimTime;

// Count "shots" using this.
var float ShootAccum;

var float DamageCarry;
var float DecalInterval;
var float DecalMinInterval;

replication
{
	// Things the server should send to the client.
	unreliable if( Role==ROLE_Authority )
		AimError,
		NewError,
		AimRotation;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if ( instigator == None )
		return;
	if ( Instigator.IsA('Bot') && Bot(Instigator).bNovice )
		aimerror = 2200 + (3 - instigator.skill) * 300;
	else
		aimerror = 1000 + (3 - instigator.skill) * 400;

	if ( FRand() < 0.5 )
		aimerror *= -1;

	if (ROLE == ROLE_Authority)
		ForEach AllActors(Class'IGPlus_WeaponImplementation', WImp)
			break;		// Find master :D

	GrowthDelay = WImp.WeaponSettings.PulseBoltGrowthDelay;
	MaxSegments = WImp.WeaponSettings.PulseBoltMaxSegments;
}

simulated function Tick(float DeltaTime)
{
	local vector X,Y,Z, AimSpot, DrawOffset, AimStart;
	local int YawErr;
	local float dAdjust;
	local Bot MyBot;
	local vector Origin;

	if (ROLE == ROLE_Authority)
	{
		ShootAccum -= DeltaTime;
		while (ShootAccum <= 0.0)
		{	// Handle stats this way.
			ShootAccum += 0.05;		// TR 20 = 0.05s
		}
	}

	AnimTime += DeltaTime;
	if ( AnimTime > 0.05 )
	{
		AnimTime -= 0.05;
		SpriteFrame++;
		if ( SpriteFrame == ArrayCount(SpriteAnim) )
			SpriteFrame = 0;
		Skin = SpriteAnim[SpriteFrame];
	}

	// orient with respect to instigator
	if ( Instigator != None )
	{
		if ( (Level.NetMode == NM_Client) && (!Instigator.IsA('PlayerPawn') || (PlayerPawn(Instigator).Player == None)) )
		{
			SetRotation(AimRotation); 
			Instigator.ViewRotation = AimRotation;
			DrawOffset = ((0.01 * class'PulseGun'.Default.PlayerViewOffset) >> Rotation);
			DrawOffset += (Instigator.EyeHeight * vect(0,0,1));
		}
		else 
		{
			MyBot = Bot(instigator);
			if ( MyBot != None  )
			{
				if ( Instigator.Target == None )
					Instigator.Target = Instigator.Enemy;
				if ( Instigator.Target == Instigator.Enemy )
				{
					if (MyBot.bNovice )
						dAdjust = DeltaTime * (4 + instigator.Skill) * 0.075;
					else
						dAdjust = DeltaTime * (4 + instigator.Skill) * 0.12;
					if ( OldError > NewError )
						OldError = FMax(OldError - dAdjust, NewError);
					else
						OldError = FMin(OldError + dAdjust, NewError);

					if ( OldError == NewError )
						NewError = FRand() - 0.5;
					if ( StartError > 0 )
						StartError -= DeltaTime;
					else if ( MyBot.bNovice && (Level.TimeSeconds - MyBot.LastPainTime < 0.2) )
						StartError = MyBot.LastPainTime;
					else
						StartError = 0;
					AimSpot = 1.25 * Instigator.Target.Velocity + 0.75 * Instigator.Velocity;
					if ( Abs(AimSpot.Z) < 120 )
						AimSpot.Z *= 0.25;
					else
						AimSpot.Z *= 0.5;
					if ( Instigator.Target.Physics == PHYS_Falling )
						AimSpot = Instigator.Target.Location - 0.0007 * AimError * OldError * AimSpot;
					else
						AimSpot = Instigator.Target.Location - 0.0005 * AimError * OldError * AimSpot;
					if ( (Instigator.Physics == PHYS_Falling) && (Instigator.Velocity.Z > 0) )
						AimSpot = AimSpot - 0.0003 * AimError * OldError * AimSpot;

					AimStart = Instigator.Location + FireOffset.X * X + FireOffset.Y * Y + (1.2 * FireOffset.Z - 2) * Z; 
					if ( FastTrace(AimSpot - vect(0,0,10), AimStart) )
						AimSpot	= AimSpot - vect(0,0,10);
					GetAxes(Instigator.Rotation,X,Y,Z);
					AimRotation = Rotator(AimSpot - AimStart);
					AimRotation.Yaw = AimRotation.Yaw + (OldError + StartError) * 0.75 * aimerror;
					YawErr = (AimRotation.Yaw - (Instigator.Rotation.Yaw & 65535)) & 65535;
					if ( (YawErr > 3000) && (YawErr < 62535) )
					{
						if ( YawErr < 32768 )
							AimRotation.Yaw = Instigator.Rotation.Yaw + 3000;
						else
							AimRotation.Yaw = Instigator.Rotation.Yaw - 3000;
					}
				}
				else if ( Instigator.Target != None )
					AimRotation = Rotator(Instigator.Target.Location - Instigator.Location);
				else
					AimRotation = Instigator.ViewRotation;
				Instigator.ViewRotation = AimRotation;
				SetRotation(AimRotation);
			}
			else
			{
				AimRotation = Instigator.ViewRotation;
				SetRotation(AimRotation);
			}
			Drawoffset = Instigator.Weapon.CalcDrawOffset();
		}
		GetAxes(Instigator.ViewRotation,X,Y,Z);

		if ( bCenter )
		{
			FireOffset.Z = Default.FireOffset.Z * 1.5;
			FireOffset.Y = 0;
		}
		else 
		{
			FireOffset.Z = Default.FireOffset.Z;
			if ( bRight )
				FireOffset.Y = Default.FireOffset.Y;
			else
				FireOffset.Y = -1 * Default.FireOffset.Y;
		}
		Origin = Instigator.Location + DrawOffset;
		SetLocation(Origin + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z);
	}
	else {
		GetAxes(Rotation,X,Y,Z);
		Origin = Location;
	}

	TraceBeam(Origin, X, DeltaTime);
}

simulated function TraceBeam(vector Origin, vector X, float DeltaTime)
{
	local actor HitActor;
	local vector HitLocation, HitNormal, Momentum;
	local int BeamLen;
	local vector BeamDir;

	CheckBeam(X, DeltaTime); // potentially lengthens the beam

	BeamLen = BeamLength();

	// check to see if hits something
	HitActor = Trace(HitLocation, HitNormal, Origin + BeamLen * BeamSize * X, Origin, true);
	if ( (HitActor != None)	&& (HitActor != Instigator)
		&& (HitActor.bProjTarget || (HitActor == Level) || (HitActor.bBlockActors && HitActor.bBlockPlayers))
		&& ((Pawn(HitActor) == None) || Pawn(HitActor).AdjustHitLocation(HitLocation, Velocity)) )
	{
		if ( Level.Netmode != NM_Client )
		{
			if ( DamagedActor == None )
			{
				AccumulatedDamage = FMin(
					0.5 * (Level.TimeSeconds - LastHitTime),
					WImp.WeaponSettings.PulseBoltMaxAccumulate
				);
				if (Level.Game.GetPropertyText("NoLockdown") == "1")
					Momentum = vect(0,0,0);
				else
					Momentum = MomentumTransfer * X * AccumulatedDamage;
				HitActor.TakeDamage(
					CalcDamage(WImp.WeaponSettings.PulseBoltDPS * AccumulatedDamage),
					instigator,
					HitLocation,
					WImp.WeaponSettings.PulseBoltMomentum * Momentum,
					MyDamageType);
				AccumulatedDamage = 0;
			}
			else if ( DamagedActor != HitActor )
			{
				if (Level.Game.GetPropertyText("NoLockdown") == "1")
					Momentum = vect(0,0,0);
				else
					Momentum = MomentumTransfer * X * AccumulatedDamage;
				DamagedActor.TakeDamage(
					CalcDamage(WImp.WeaponSettings.PulseBoltDPS * AccumulatedDamage),
					instigator,
					HitLocation,
					WImp.WeaponSettings.PulseBoltMomentum * Momentum,
					MyDamageType);
				AccumulatedDamage = 0;
			}
			LastHitTime = Level.TimeSeconds;
			DamagedActor = HitActor;
			AccumulatedDamage += DeltaTime;
			if ( AccumulatedDamage > 0.22 )
			{
				if ( DamagedActor.IsA('Carcass') && (FRand() < 0.09) )
					AccumulatedDamage = 35/damage;
				if (int(Level.Game.GetPropertyText("NoLockdown")) > 0)
					Momentum = vect(0,0,0);
				else
					Momentum = MomentumTransfer * X * AccumulatedDamage;
				DamagedActor.TakeDamage(
					CalcDamage(WImp.WeaponSettings.PulseBoltDPS * AccumulatedDamage),
					instigator,
					HitLocation,
					WImp.WeaponSettings.PulseBoltMomentum * Momentum,
					MyDamageType);
				AccumulatedDamage = 0;
			}
		}
		if ( HitActor.bIsPawn && Pawn(HitActor).bIsPlayer )
		{
			if ( WallEffect != None )
				WallEffect.Destroy();
		}
		else if ( (WallEffect == None) || WallEffect.bDeleteMe )
			WallEffect = Spawn(class'PlasmaHit',,, HitLocation - 5 * X);
		else if ( !WallEffect.IsA('PlasmaHit') )
		{
			WallEffect.Destroy();
			WallEffect = Spawn(class'PlasmaHit',,, HitLocation - 5 * X);
		}
		else
			WallEffect.SetLocation(HitLocation - 5 * X);

		if ( (WallEffect != None) && (Level.NetMode != NM_DedicatedServer) ) {
			DecalInterval -= DeltaTime;
			if (DecalInterval <= 0) {
				Spawn(ExplosionDecal,,,HitLocation,rotator(HitNormal));
				DecalInterval = FClamp(DecalInterval + DecalMinInterval, -DecalMinInterval, DecalMinInterval);
			}
		}

		CutDownBeam(HitLocation); // potentially shortens beam
	} else {
		HitLocation = Location + BeamLen * BeamSize * X;

		if (DamagedActor != None && Level.Netmode != NM_Client) {
			if (Level.Game.GetPropertyText("NoLockdown") == "1")
				Momentum = vect(0,0,0);
			else
				Momentum = MomentumTransfer * X * AccumulatedDamage;

			DamagedActor.TakeDamage(
				CalcDamage(WImp.WeaponSettings.PulseBoltDPS * AccumulatedDamage),
				instigator,
				DamagedActor.Location - X * 1.2 * DamagedActor.CollisionRadius,
				WImp.WeaponSettings.PulseBoltMomentum * Momentum,
				MyDamageType);
			AccumulatedDamage = 0;
			DamagedActor = None;
		}

		if (BeamLen == MaxSegments) {
			if ( (WallEffect == None) || WallEffect.bDeleteMe )
				WallEffect = Spawn(class'PlasmaCap',,, HitLocation - 4 * X);
			else if ( WallEffect.IsA('PlasmaHit') )
			{
				WallEffect.Destroy();
				WallEffect = Spawn(class'PlasmaCap',,, HitLocation - 4 * X);
			}
			else
				WallEffect.SetLocation(HitLocation - 4 * X);
		}
	}

	// reposition beam
	BeamDir = Normal(HitLocation - Location);
	SetRotation(rotator(BeamDir));
	if (PlasmaBeam != none)
		PlasmaBeam.UpdateBeam(self, BeamDir, 0.0);
}

simulated function int BeamLength() {
	local int Result;
	local PBolt Beam;

	Result = 1;
	Beam = PlasmaBeam;

	while(Beam != none) {
		Result++;
		Beam = Beam.PlasmaBeam;
	}

	return Result;
}

// This function makes sure only even amounts of damage are applied
// Level.Game.ReduceDamage multiplies damage by 1.5
// The problem is that damage is applied on potentially every Tick, and rounding
// losses become significant at that frequency.
simulated function int CalcDamage(float Damage) {
	local float Temp;
	local int Result;

	Temp = Damage + DamageCarry;
	Result = int(Temp) & ~1;
	DamageCarry = Temp - float(Result);

	return Result;
}

simulated function CutDownBeam(vector HitLocation) {
	local PBolt Beam;
	local float Length;

	Length = VSize(HitLocation - Location);
	Beam = self;

	while (Beam.PlasmaBeam != none && Length >= BeamSize) {
		Length -= BeamSize;
		Beam = Beam.PlasmaBeam;
	}
	ST_PBolt(Beam).GrowthAccumulator = 0.0;

	if (Beam.PlasmaBeam != none) {
		Beam.PlasmaBeam.Destroy();
		Beam.PlasmaBeam = none;
	}
}

defaultproperties
{
     StartError=0.500000
     SpriteAnim(0)=Texture'Botpack.Skins.sbolt0'
     SpriteAnim(1)=Texture'Botpack.Skins.sbolt1'
     SpriteAnim(2)=Texture'Botpack.Skins.sbolt2'
     SpriteAnim(3)=Texture'Botpack.Skins.sbolt3'
     SpriteAnim(4)=Texture'Botpack.Skins.sbolt4'
     RemoteRole=ROLE_SimulatedProxy
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=255
     LightHue=83
     LightSaturation=50
     LightRadius=5
     DecalMinInterval=0.02
}
