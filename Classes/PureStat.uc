// ===============================================================
// PureStat7A.Stats: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class PureStat extends Info;

// Installs this mutator class.
var class<ST_Mutator> cM;

var globalconfig bool bEnabled;
var globalconfig bool bUseFWS;

function PostBeginPlay()
{
	local ST_Mutator STM;

	SaveConfig();

	if (!bEnabled)
	{
		Log("* PureStats disabled!");
		return;
	}

	STM = Spawn(cM);

	if (STM == None)
	{
		Log("* Failed to start PureStats!");
		return;
	}

	STM.NextMutator = Level.Game.BaseMutator;
	Level.Game.BaseMutator = STM;

	Destroy();
}

defaultproperties {
	cM=Class'ST_Mutator'
	bEnabled=True
	bUseFWS=False
}
