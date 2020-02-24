// ===============================================================
// UTPureRC7A.PureDPS: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class PureDPS extends Info;

var Inventory MessedInv[32];
var float OrgReSpawnTime[32];

function Tick(float deltaTime)
{
	local DeathMatchPlus DMP;
	local Inventory Inv;
	local bool bMessWith;
	local int c;

	DMP = DeathMatchPlus(Level.Game);

	if (DMP.bRequireReady && DMP.CountDown == 0 || !DMP.bRequireReady)
	{
		ForEach AllActors(Class'Inventory', Inv)
		{
			Switch(Inv.Class.Name)	// Use name to allow classes which are not in editpackages to be recognized
			{
				Case 'HealthPack':
				Case 'UT_invisibility':
				Case 'UT_Shieldbelt':
				Case 'UDamage':		bMessWith = True;
							break;
				Default:		bMessWith = False;
							break;
			}
			if (bMessWith)
			{
				MessedInv[c] = Inv;
				OrgReSpawnTime[c] = Inv.ReSpawnTime;
				Inv.ReSpawnTime = fMax(8.0, frand() * Inv.ReSpawnTime * 0.5);	// Wait minimum 8 seconds (really 7.27 seconds :P)
				Inv.GotoState('Sleeping');
				c++;
				if (c == 32)
					break;			// Only place for 32.
			}
		}
		SetTimer(1.0, False);
		Disable('Tick');	// Our job here is done for now.
	}
}

function Timer()
{
	// Since entering a state is delayed (the Sleep() happens after Begin: in the 'Sleeping' state), we need to reset to
	// the real respawn rate here.

	local int x;
	for (x = 0; x < 32; x++)
	{
		if (MessedInv[x] != None)
			MessedInv[x].ReSpawnTime = OrgReSpawnTime[x];
	}

	Destroy();			// Now our job is completely done.
}

defaultproperties
{
}
