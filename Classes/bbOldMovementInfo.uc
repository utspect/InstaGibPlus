class bbOldMovementInfo extends Object;

var vector Loc, Vel, Acc;
var float TimeStamp;

var bbOldMovementInfo Next;

function Save(bbPlayer P) {
	TimeStamp = P.Level.TimeSeconds;
	Loc = P.Location;
	Vel = P.Velocity;
	Acc = P.Acceleration;
}
