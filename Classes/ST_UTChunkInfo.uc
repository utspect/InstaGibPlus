class ST_UTChunkInfo extends Info;

var Actor Victim[8];
var int HitCount;
var int ChunkCount;

var IGPlus_WeaponImplementation WImp;

function AddChunk(ST_UTChunk Chunk)
{
	if (Chunk == None)
		return;				// If it for some reason failed to spawn.
	Chunk.Chunkie = Self;
	Chunk.ChunkIndex = ChunkCount++;
	Chunk.LifeSpan = WImp.WeaponSettings.FlakChunkLifespan;
}

// The chunks have a lifespan of 2.9-3.1 seconds, so this is sufficient.
defaultproperties {
	LifeSpan=3.5
}
