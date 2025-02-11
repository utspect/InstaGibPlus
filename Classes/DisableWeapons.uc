class DisableWeapons extends Mutator;
// Description=""

function bool AlwaysKeep(Actor Other)
{
	local NewNetServer NNS;

	ForEach AllActors(class'NewNetServer', NNS)
	{
		NNS.bEnabled = false;
	}
	return Super.AlwaysKeep(Other);
}