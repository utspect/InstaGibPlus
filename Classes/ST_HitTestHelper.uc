// Intended usage of this class is:
//
//     HitTestHelper.SetLocation(Source.Location);
//     HitTestHelper.FlyTowards(Victim.Location, DamageRadius);
// 
// Afterwards, trace from HitTestHelper to Victim.Location again.

class ST_HitTestHelper extends Actor;

const FLIGHT_TIME_INCREMENT = 0.05;

function FlyTowards(vector Loc, float Vel) {
	local float FlightTime;

	FlightTime = 1.0;
	while (FlightTime > 0.0) {
		if (VSize(Loc - Location) < 3)
			break;
		Velocity = Normal(Loc - Location) * Vel;

		AutonomousPhysics(FMin(FLIGHT_TIME_INCREMENT, FlightTime));

		FlightTime -= FLIGHT_TIME_INCREMENT;
	}

	Velocity = vect(0.0, 0.0, 0.0);
}

event HitWall(vector HitNormal, actor HitWall) {
	MoveSmooth(HitNormal*3); // move away from wall.
}

defaultproperties {
	Physics=PHYS_Projectile;
	bCollideWorld=True
	bCollideActors=False
	bBlockActors=False
	bBlockPlayers=False
	bProjTarget=False
	CollisionRadius=0.0
	CollisionHeight=0.0
	RemoteRole=ROLE_None
	DrawType=DT_None
}
