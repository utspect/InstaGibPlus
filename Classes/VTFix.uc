class VTFix expands Mutator;

CONST IC=class'VisibleTeleporterFixRI';

function Tick(float dt)
{
	spawn(class'VisibleTeleporterFixRI');
	DelSelf();
	Disable('Tick');
}	

function DelSelf()
{
	local Mutator M, PrevM;
	local bool bFound;
	
	
	for(M=Level.Game.BaseMutator; M!=None; M=M.NextMutator )
	{
		if( M == Self )
		{
			bFound = True;
			break;
		}
		PrevM = M;
	}
	if( bFound )
	{
		if( PrevM != None )
			PrevM.NextMutator = NextMutator;
		else
			Level.Game.BaseMutator = NextMutator;
	}
	destroy();
	return;
}

defaultproperties
{
    RemoteRole=None
}