// ============================================================
// UTPureRC54.PureSN: put your comment here

// Created by UClasses - (C) 2000 by meltdown@thirdtower.com
// ============================================================

class PureSN expands SpawnNotify;

event PostBeginPlay();	// Ignore

simulated event Actor SpawnNotification(Actor A)
{
	if (Next != None && bbPlayer(Owner) != None)
		bbPlayer(Owner).xxServerCheater("S2");
	Class'PureInfo'.Static.xxSetClass(A);
	return A;
}

defaultproperties
{
}
