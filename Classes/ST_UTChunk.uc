// ===============================================================
// Stats.ST_UTChunk: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_UTChunk extends UTChunk;

var ST_UTChunkInfo Chunkie;
var int ChunkIndex;

function ProcessTouch (Actor Other, vector HitLocation)
{
	// Physics for chunks is split into 3 phases:
	// PHYS_Projectile -- immediately after being fired, default physics
	// PHYS_Falling -- after hitting surface while in PHYS_Projectile
	// PHYS_None -- after touching standable ground while in PHYS_Falling

	if (Physics == PHYS_None)
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
					Chunkie.STM.WeaponSettings.FlakChunkDamage,
					instigator,
					HitLocation,
					Chunkie.STM.WeaponSettings.FlakChunkMomentum * (MomentumTransfer * Velocity/speed),
					MyDamageType);
				Chunkie.EndHit();
			}
			if ( FRand() < 0.5 )
				PlaySound(Sound 'ChunkHit',, 4.0,,200);
		}
		Destroy();
	}
}


defaultproperties {
	bNetTemporary=False
}
