class DisablePortals extends Mutator;

function Tick( float Delta )
{
	local UTPure UTP;

	ForEach AllActors(class'UTPure', UTP)
	{
		Log("NewNet Portals is Disabled!");
		UTP.DisablePortals = true;
		UTP.default.DisablePortals = true;
		Disable('Tick');
	}
}