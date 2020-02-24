// ===============================================================
// UTPureRC7A.PureHitSound: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class PureHitSound extends LocalMessagePlus;

static function string GetString(
	optional int Sw,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	return "";
}

static function ClientReceive( 
	PlayerPawn P,
	optional int Sw,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	if (Sw < 0)
	{
		if (bbPlayer(P) != None)
		{
			bbPlayer(P).zzRecentTeamDmgGiven = -1*Sw;
			bbPlayer(P).PlayTeamHitSound(0);
		}
		else if (bbCHSpectator(P) != None)
		{
			bbCHSpectator(P).zzRecentTeamDmgGiven = -1*Sw;
			bbCHSpectator(P).PlayTeamHitSound(0);
		}
	}
	else
	{
		if (bbPlayer(P) != None)
			bbPlayer(P).PlayHitSound(Sw);
		else if (bbCHSpectator(P) != None)
			bbCHSpectator(P).PlayHitSound(Sw);
	}

	Super.ClientReceive(P, Sw, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

defaultproperties
{
}
