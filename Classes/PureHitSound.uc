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
	Super.ClientReceive(P, Sw, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

defaultproperties
{
}
