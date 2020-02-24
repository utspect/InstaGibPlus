class bbClientDemoSN extends SpawnNotify;

struct zzActorInfo
{
	var bool zzbActive;
	var class<Actor> zzActorC;
	var vector zzActorL;
	var vector zzActorV;
	var vector zzActorA;
	var rotator zzActorR;
	var float zzActorDS;
	var Actor zzActorS;
};
var zzActorInfo zzActors[20];
var int zzActorIndex;
var int zzActorCount;

simulated event Actor SpawnNotification(Actor A)
{
	local string zzName;
	local int zzi;
	local float zzVSize;
	local float zzClosestVSize;
	local int zzClosestActorIndex;
	
	if (A.Owner != None && A.Owner != Owner)
		return A;
	
	zzName = Caps(String(A.Class.Name));
	if (Left(zzName, 3) == "NN_" && Mid(zzName, Len(zzName) - 11) == "OWNERHIDDEN")
	{
		A.bHidden = true;
		A.DrawScale = 0;
	}
	else if (zzActorCount > 0)
	{
		zzClosestVSize = 100;
		zzClosestActorIndex = -1;
		for (zzi = 0; zzi < 20; zzi++)
		{
			if (!zzActors[zzi].zzbActive || !A.IsA(zzActors[zzi].zzActorC.name))
				continue;
			zzVSize = VSize(zzActors[zzi].zzActorL - A.Location);
			if (zzVSize < zzClosestVSize)
			{
				zzClosestVSize = zzVSize;
				zzClosestActorIndex = zzi;
			}
		}
		if (zzClosestActorIndex > -1)
		{
			
			zzActors[zzClosestActorIndex].zzbActive = false;
			
			if (VSize(zzActors[zzClosestActorIndex].zzActorL) > 0)
				A.SetLocation(zzActors[zzClosestActorIndex].zzActorL);
				
			if (VSize(zzActors[zzClosestActorIndex].zzActorV) > 0)
				A.Velocity = zzActors[zzClosestActorIndex].zzActorV;
			
			if (VSize(zzActors[zzClosestActorIndex].zzActorA) > 0)
				A.Acceleration = zzActors[zzClosestActorIndex].zzActorA;
			
			if (VSize(Vector(zzActors[zzClosestActorIndex].zzActorR)) > 0)
				A.SetRotation(zzActors[zzClosestActorIndex].zzActorR);
			
			if (A.IsA('UT_WallHit'))
				UT_WallHit(A).RealRotation = zzActors[zzClosestActorIndex].zzActorR;
			
			if(zzActors[zzClosestActorIndex].zzActorDS != 0)
				A.DrawScale = zzActors[zzClosestActorIndex].zzActorDS;
			
			if((zzActors[zzClosestActorIndex].zzActorS != none) && UT_SeekingRocket(A) != none)
				UT_SeekingRocket(A).Seeking = zzActors[zzClosestActorIndex].zzActorS;
			
			zzActorCount--;
			
		}
	}
	return A;
}

simulated function xxFixActor(class<Actor> C, Vector L, Vector V, Vector A, Rotator R, optional float DS, optional Actor S)
{
	zzActors[zzActorIndex].zzbActive = true;
	zzActors[zzActorIndex].zzActorC = C;
	zzActors[zzActorIndex].zzActorL = L;
	zzActors[zzActorIndex].zzActorV = V;
	zzActors[zzActorIndex].zzActorA = A;
	zzActors[zzActorIndex].zzActorR = R;
	zzActors[zzActorIndex].zzActorDS = DS;
	zzActors[zzActorIndex].zzActorS = S;
	zzActorIndex++;
	if (zzActorIndex == 20)
		zzActorIndex = 0;
	zzActorCount++;
}

defaultproperties
{
}
