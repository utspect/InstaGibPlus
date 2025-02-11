class DisableNewNet extends Mutator;
// Description=""

function bool AlwaysKeep(Actor Other)
{
	local NewNetServer NNS;

	ForEach AllActors(class'NewNetServer', NNS)
	{
		NNS.bUTPureEnabled = false;
	}
	return Super.AlwaysKeep(Other);
}