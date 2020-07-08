class NN_Kicker expands Botpack.Kicker;

var Actor Last;
var float LastTimeStamp;

simulated event PostTouch(Actor Other) {
	if ((Other != Last) || (Level.TimeSeconds >= (LastTimeStamp + 0.2))) {
		super.PostTouch(Other);
		Last = Other;
		LastTimeStamp = Level.TimeSeconds;
	}
}

defaultproperties
{
	RemoteRole=ROLE_None
}
