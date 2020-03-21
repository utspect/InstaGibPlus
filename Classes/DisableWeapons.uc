class DisableWeapons extends Mutator;

function bool AlwaysKeep(Actor Other)
{
	local NewNetServer NNS;
	local bbPlayer bbP;

	ForEach AllActors(class'NewNetServer', NNS)
	{
		NNS.bEnabled = false;
	}
	return Super.AlwaysKeep(Other);
}