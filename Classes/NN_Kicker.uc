class NN_Kicker expands Botpack.Kicker;

var Actor Last;
var float LastTimeStamp;

simulated event Touch(Actor Other) {
	if (Other.IsA('bbPlayer'))
		bbPlayer(Other).ClientDebugMessage("["$bbPlayer(Other).FrameCount@Level.TimeSeconds$"] Kicker Touched");

	super.Touch(Other);
}

simulated event PostTouch(Actor Other) {
	if ((Other != Last) || (Level.TimeSeconds >= (LastTimeStamp + 0.2))) {
		if (Other.IsA('bbPlayer'))
			bbPlayer(Other).ClientDebugMessage("["$bbPlayer(Other).FrameCount@Level.TimeSeconds$"] Kick");
		super.PostTouch(Other);
		Last = Other;
		LastTimeStamp = Level.TimeSeconds;
	} else if (Other.IsA('bbPlayer')) {
		bbPlayer(Other).ClientDebugMessage("["$bbPlayer(Other).FrameCount@Level.TimeSeconds$"] Kick discarded");
	}
}

defaultproperties
{
	RemoteRole=ROLE_None
}
