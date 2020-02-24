class NewNetServer extends Info config(InstaGibPlus);

var Mutator AceMut;
var class<ST_Mutator> cM;
var globalconfig bool bEnabled;
var globalconfig bool bUTPureEnabled;

function PostBeginPlay()
{
	SpawnUTPure();
	Log("NewNetServer Post Begin Play");
	Super.PostBeginPlay();
}

function Mutator GetAceMut()
{
	if (AceMut == None)
		ForEach AllActors(class'Mutator', AceMut)
			if (Caps(String(AceMut.Class.Name)) == "ACEMUTATOR")
				break;
	return AceMut;
}

function SpawnUTPure()
{
	local UTPure UTP;
	
	foreach AllActors(class'UTPure',UTP)
		return;

	if (!bUTPureEnabled)
	{
		Log("NewNet is disabled!");
		return;
	}
	UTP = Level.Spawn(Class'UTPure');

	SpawnNewNetWeapons();
	if (UTP == None)
	{
		Log("Failed to start NewNet!");
		return;
	}
	if (UTP != None)
	{
		UTP.NextMutator = Level.Game.BaseMutator;
		Level.Game.BaseMutator = UTP;
	}
	class'playerpawn'.default.maxtimemargin = 1;
	class'playerpawn'.staticsaveconfig();
}

function SpawnNewNetWeapons()
{
	local ST_Mutator STM;

	if (!bEnabled)
	{
		Log("NewNet Weapons is disabled!");
		return;
	}
	STM = Spawn(cM);
	if (STM == None)
	{
		Log("Failed to start NewNet Weapons!");
		return;
	}
	STM.NextMutator = Level.Game.BaseMutator;
	Level.Game.BaseMutator = STM;
	Destroy();
}

defaultproperties
{
    cm=Class'ST_Mutator'
    bEnabled=True
	bUTPureEnabled=True
}