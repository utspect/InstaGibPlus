// ===============================================================
// Stats.ST_UTChunk: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_UTChunk extends UTChunk;

var ST_UTChunkInfo Chunkie;
var int ChunkIndex;

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	if ( (Chunk(Other) == None) && ((Physics == PHYS_Falling) || (Other != Instigator)) )
	{
		speed = VSize(Velocity);
		If ( speed > 200 )
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
}
