class ST_SpawnNotify extends SpawnNotify;

var Actor ReplaceThis;
var Actor ReplaceWithThis;

simulated event Actor SpawnNotification(Actor A) {
	if (A == ReplaceThis) {
		A.Destroy();
		A = ReplaceWithThis;
		SetReplace(none, none);
	}
	return A;
}

function SetReplace(Actor Which, Actor Replacement) {
	ReplaceThis = Which;
	ReplaceWithThis = Replacement;

	if (Which != none) {
		ActorClass = Which.Class;
	} else {
		ActorClass = class'ST_Dummy';
	}
}

defaultproperties {
	ActorClass=class'ST_Dummy'
	RemoteRole=ROLE_None
}
