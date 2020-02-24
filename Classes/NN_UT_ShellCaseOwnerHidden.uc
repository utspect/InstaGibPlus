class NN_UT_ShellCaseOwnerHidden extends UT_ShellCase;

var bool bAlreadyHidden;

simulated function Tick(float DeltaTime) {
	
	if ( Owner == None )
		return;
	
	if (Level.NetMode == NM_Client && !bAlreadyHidden && Owner.IsA('bbPlayer') && bbPlayer(Owner).Player != None) {
		LightType = LT_None;
		bAlreadyHidden = True;
	}
}

defaultproperties
{
     bOwnerNoSee=True
}
