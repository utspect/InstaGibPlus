// ===============================================================
// UTPureStats7A.ST_PBolt: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_PBolt extends PBolt;

var ST_Mutator STM;
var float GrowthAccumulator;
var float GrowthDelay;
var int MaxSegments;

replication
{
	// Things the server should send to the client.
	unreliable if( Role==ROLE_Authority )
		GrowthDelay,
		MaxSegments;
}

simulated function CheckBeam(vector X, float DeltaTime)
{
	if ( Position < MaxSegments-1 ) {
		if ( PlasmaBeam == None ) {
			// Originally, it spawned a new segment every tick, meaning higher tickrate = faster growth of beam
			// This also meant it was incorrectly simulated on clients, since clients usually have a much higher framerate.
			// This should fix both issues. Tickrate 20 is assumed.
			GrowthAccumulator += DeltaTime;
			if (GrowthAccumulator >= GrowthDelay)		// 1 / 20 (Tickrate 20) = 0.050
			{
				PlasmaBeam = Spawn(class'ST_PBolt',,, Location + BeamSize * X);
				PlasmaBeam.Position = Position + 1;
				ST_PBolt(PlasmaBeam).GrowthAccumulator = GrowthAccumulator - 0.050;		// This causing extra damage?
				ST_PBolt(PlasmaBeam).STM = STM;
				ST_PBolt(PlasmaBeam).GrowthDelay = GrowthDelay;
				ST_PBolt(PlasmaBeam).MaxSegments = MaxSegments;
				GrowthAccumulator = 0.0;

				if (GrowthDelay < 0.0)
					PlasmaBeam.UpdateBeam(self, X, DeltaTime);
			}
		} else {
			PlasmaBeam.UpdateBeam(self, X, DeltaTime);
		}
	}
}

defaultproperties {
	GrowthDelay=0.050
}
