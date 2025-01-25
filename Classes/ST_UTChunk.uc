// ===============================================================
// Stats.ST_UTChunk: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_UTChunk extends UTChunk;

var ST_UTChunkInfo Chunkie;
var int ChunkIndex;

simulated function PostBeginPlay() {
	local rotator RandRot;

	if (Level.NetMode != NM_DedicatedServer) {
		if (!Region.Zone.bWaterZone)
			Trail = Spawn(class'ChunkTrail',self);
		SetTimer(0.1, true);
	}

	if (Role == ROLE_Authority) {
		Chunkie = ST_UTChunkInfo(Owner);

		if (Chunkie == none || Chunkie.WImp.WeaponSettings.FlakChunkRandomSpread) {
			RandRot = Rotation;
			RandRot.Pitch += FRand() * 2000 - 1000;
			RandRot.Yaw += FRand() * 2000 - 1000;
			RandRot.Roll += FRand() * 2000 - 1000;
			Velocity = Vector(RandRot) * (Speed + (FRand() * 200 - 100));
		} else {
			Velocity = vector(Rotation) * Speed;
			RandRot = Rotation;
			RandRot.Roll = Rand(65536);
			SetRotation(RandRot);
		}
		if (Region.zone.bWaterZone)
			Velocity *= 0.65;
	}

	super(Projectile).PostBeginPlay();
}

function ProcessTouch (Actor Other, vector HitLocation)
{
	// Physics for chunks is split into 3 phases:
	// PHYS_Projectile -- immediately after being fired, default physics
	// PHYS_Falling -- after hitting surface while in PHYS_Projectile
	// PHYS_None -- after touching standable ground while in PHYS_Falling

	if (Physics == PHYS_None)
		return;
	
	// For ShockProjectileBlockFlakChunk
    if (ShockProj(Other) != None && !Chunkie.WImp.WeaponSettings.ShockProjectileBlockFlakChunk)
        return;

	if ( (Chunk(Other) == None) && ((Physics == PHYS_Falling) || (Other != Instigator)) )
	{
		speed = VSize(Velocity);
		if ( speed > 200 )
		{
			if ( Role == ROLE_Authority )
			{
				Chunkie.HitSomething(Self, Other);
				Other.TakeDamage(
					CalcDamage(),
					instigator,
					HitLocation,
					Chunkie.WImp.WeaponSettings.FlakChunkMomentum * (MomentumTransfer * Velocity/speed),
					MyDamageType);
				Chunkie.EndHit();
			}
			if ( FRand() < 0.5 )
				PlaySound(Sound 'ChunkHit',, 4.0,,200);
		}
		Destroy();
	}
}

function float CalcDamage() {
	local float Base, Reduced;
	local float T1, T2;
	local float Time;

	Base = Chunkie.WImp.WeaponSettings.FlakChunkDamage;
	Reduced = Base * Chunkie.WImp.WeaponSettings.FlakChunkDropOffDamageRatio;
	T1 = Chunkie.WImp.WeaponSettings.FlakChunkDropOffStart;
	T2 = Chunkie.WImp.WeaponSettings.FlakChunkDropOffEnd;
	Time = Chunkie.WImp.WeaponSettings.FlakChunkLifespan - Lifespan;

	if (Time <= T1)
		return Base;

	if (Time >= T2)
		return Reduced;

	return Lerp((Time - T1) / (T2 - T1), Base, Reduced);
}


defaultproperties {
	bNetTemporary=False
}
