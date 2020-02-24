class NN_ShockBeam extends ShockBeam;

var vector BaseLocation;

simulated function Timer()
{
	local ShockBeam r;

	if (NumPuffs>0)
	{
		r = Spawn(Class,Owner,,Location+MoveAmount);
		r.RemoteRole = ROLE_None;
		r.NumPuffs = NumPuffs -1;
		r.MoveAmount = MoveAmount;
	}
}

simulated function PostBeginPlay()
{
/*	local vector V;
	local float f;

	BaseLocation = Location;

	f = NumPuffs/10*PI;

	V.x = cos(f)*50;
	V.y = sin(f)*50;

	SetLocation(Location + V);
*/
	if ( Level.NetMode != NM_DedicatedServer )
		SetTimer(0.05, false);
}

defaultproperties
{
}
