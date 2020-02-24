class NN_SpawnNotify extends SpawnNotify;

simulated event Actor SpawnNotification(Actor A)
{
	if (A.IsA('CreatureChunks'))
		A.bProjTarget = false;
	else if (A.IsA('UTCreatureChunks'))
		A.bProjTarget = false;
	return A;
}