class RXPosError extends Mutator config(InstaGibPlus);

var config localized int MaxPosError;

function Tick( float Delta )
{
	local UTPure UTP;

	ForEach AllActors(class'UTPure', UTP)
	{
		UTP.Default.MaxPosError=MaxPosError;
		Log("NewNet compatibility enabled for RX & SLV based mod.");
		Disable('Tick');
	}
	SaveConfig();
}

defaultproperties
{
    MaxPosError=80
}