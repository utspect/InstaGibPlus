class IGPlus_CarcassSpawnNotify extends SpawnNotify;

var ServerSettings Settings;

simulated event Actor SpawnNotification(Actor A) {
	if (Settings.bEnableCarcassCollision == false) {
		A.SetCollision(false, false, false);
		A.bProjTarget = false;
	}
	return A;
}

defaultproperties {
	RemoteRole=ROLE_SimulatedProxy
	ActorClass=class'Carcass'
}
