class bbOldMovementInfo extends Object;

var vector Loc, Vel, Acc;
var float ServerTimeStamp;
var float ClientTimeStamp

var bbOldMovementInfo Next;

function Save(bbPlayer P) {
	ServerTimeStamp = P.Level.TimeSeconds;
	ClientTimeStamp = P.CurrentTimeStamp;
	Loc = P.Location;
	Vel = P.Velocity;
	Acc = P.Acceleration;
}
