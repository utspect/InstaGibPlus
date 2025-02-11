class IGPlus_CarcassSpawnNotify extends SpawnNotify;

var bool bEnableCarcassCollision;

replication {
	reliable if (Role == ROLE_Authority)
		bEnableCarcassCollision;
}

simulated event Actor SpawnNotification(Actor A) {
	if (bEnableCarcassCollision == false) {
		A.SetCollision(false, false, false);
		A.bProjTarget = false;
	}
	return A;
}

defaultproperties {
	bEnableCarcassCollision=True
	RemoteRole=ROLE_SimulatedProxy
	ActorClass=class'Carcass'
}
