class NN_DirectionalBlastOwnerHidden extends DirectionalBlast;

var bool bAlreadyHidden;

simulated function Tick(float DeltaTime) {
	
	if ( Owner == None )
		return;
	
	if (Level.NetMode == NM_Client && !bAlreadyHidden && Owner.IsA('bbPlayer') && bbPlayer(Owner).Player != None) {
		Texture = None;
		bAlreadyHidden = True;
	}
}

defaultproperties
{
     bOwnerNoSee=True
}
