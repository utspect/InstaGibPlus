//================================================================================
// VisibleTeleporterFixRI.
//================================================================================
class VisibleTeleporterFixRI extends ReplicationInfo;

var VisibleTeleporter Tele[64];
var name TeleTag[64];
var int TeleCount;

replication
{
	unreliable if ( Role == ROLE_Authority )
		Tele,TeleTag,TeleCount;
}

function PreBeginPlay ()
{
	local VisibleTeleporter t;
	local rotator newRot;

	foreach AllActors(Class'VisibleTeleporter',t)
	{
		t.bAlwaysRelevant = True;
		t.bChangesYaw = False;
		Tele[TeleCount] = t;
		TeleTag[TeleCount] = t.Tag;
		TeleCount++;
		if ( TeleCount == 64 )
			break;
	}
}

function AddTele (VisibleTeleporter t)
{
	if ( TeleCount >= 64 )
		return;
	Tele[TeleCount] = t;
	TeleTag[TeleCount] = t.Tag;
	TeleCount++;
}

simulated function Tick (float F)
{
	local int i;

	if ( Level.NetMode == NM_Client )
	{
		for (i = 0; i < TeleCount; i++)
		{
			if ( (Tele[i] == None) || (Tele[i].Tag == TeleTag[i]) )
				return;
			Tele[i].Tag = TeleTag[i];
		}
		return;
	}
	
	for (i = 0; i < TeleCount; i++)
	{
		if ( (Tele[i] == None) && (TeleCount > 0) )
		{
			Tele[i] = Tele[TeleCount - 1];
			TeleTag[i] = TeleTag[TeleCount - 1];
			TeleCount--;
		}
		if ( (Tele[i] != None) && (TeleTag[i] != Tele[i].Tag) )
			TeleTag[i] = Tele[i].Tag;
	}
	return;
}

defaultproperties
{
	RemoteRole=ROLE_SimulatedProxy
	NetUpdateFrequency=2.00
}