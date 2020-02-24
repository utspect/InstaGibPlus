class NN_UTSmokeTrailOwnerHidden extends UTSmokeTrail;

var bool bAlreadyHidden;

simulated function Tick(float DeltaTime) {
	
	if ( Owner == None )
		return;
	
	if (Level.NetMode == NM_Client && !bAlreadyHidden && Owner.IsA('bbPlayer') && bbPlayer(Owner).Player != None) {
		Curr = -1;
		DrawType = DT_None;
		Texture = None;
		Mesh = None;
		bAlreadyHidden = True;
	}
}

defaultproperties
{
     bOwnerNoSee=True
}
