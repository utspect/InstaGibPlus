class NN_Kicker extends Botpack.Kicker;

simulated event Touch(Actor Other) {
	local Actor A;
	local vector D;

	if (!Other.IsA(KickedClasses))
		return;

	if ((Level.NetMode == NM_Client) && !IGPlus_SimulateKick(Other))
		return;

	D = Other.Location - Location;
	if (VSize(D * vect(1,1,0)) > Other.CollisionRadius + CollisionRadius)
		return;
	if (Abs(D.Z) > Other.CollisionHeight + CollisionHeight)
		return;

	if (Other.IsA('bbPlayer')) {
		if (Level.NetMode == NM_Client)
			bbPlayer(Other).ClientDebugMessage("Kicker Touched (client)");
		else
			bbPlayer(Other).ClientDebugMessage("Kicker Touched (server)");
	}

	PendingTouch = Other.PendingTouch;
	Other.PendingTouch = self;
	if (Event != '')
		foreach AllActors( class 'Actor', A, Event )
			A.Trigger( Other, Other.Instigator );
}

simulated event PostTouch(Actor Other) {
	if (Other.IsA('bbPlayer'))
		bbPlayer(Other).ClientDebugMessage("Kick");
	super.PostTouch(Other);
}

static function bool IGPlus_SimulateKick( Actor Other)
{
	//Location is updated by server
	if (Other.Role == ROLE_DumbProxy)
		return false;

	//Local Player (Viewport may be detached during DemoPlay!!)
	if ((PlayerPawn(Other) != None) && (Other.Role == ROLE_AutonomousProxy))
		return Other.bCanTeleport;

	//Simulated pawn receive Location updates
	if (Other.bIsPawn)
		return false;

	return Other.Physics != PHYS_None;
}


defaultproperties
{
	RemoteRole=ROLE_None
}
