class NN_MTracerOwnerHidden extends MTracer;

var bool bAlreadyHidden;

simulated function Tick(float DeltaTime) {
	
	if ( Owner == None )
		return;
	
	if (Level.NetMode == NM_Client && !bAlreadyHidden && Owner.IsA('bbPlayer') && bbPlayer(Owner).Player != None) {
		LightType = LT_None;
		SetCollisionSize(0, 0);
		bAlreadyHidden = True;
	}
}

defaultproperties
{
     bOwnerNoSee=True
}
