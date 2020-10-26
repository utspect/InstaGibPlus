class bbOldMovementInfo extends Object;

var vector Loc, Vel;
var float TimeStamp;

var bbOldMovementInfo Next;

function Save(bbPlayer P) {
	TimeStamp = P.Level.TimeSeconds;
	Loc = P.Location;
	Vel = P.Velocity;
}

defaultproperties
{
	RemoteRole=ROLE_None
}
