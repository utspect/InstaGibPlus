// ===============================================================
// Stats.ST_SpecialMessage: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_SpecialMessage extends DecapitationMessage;

var localized string SpecialMessage[32];
var localized string SpecialMessage2[32];

static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	// This gets called from ClientReceive
	if (Switch >= 100)
		return Default.SpecialMessage2[Switch - 100];
	else
		return Default.SpecialMessage[Switch];
}

static simulated function ClientReceive( 
	PlayerPawn P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	if (ST_PureStats(OptionalObject) == None || !ST_PureStats(OptionalObject).bNewMessages)
		return;
	
	Super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

	if (Switch >= 100 && Default.SpecialMessage2[Switch - 100] != "")	// überspecial!!1
		P.PlaySound(Sound'SpreeSound',, 4.0);
	else	
		if (Default.SpecialMessage[Switch] != "")
			P.PlaySound(sound'SpreeSound',, 4.0);
}


defaultproperties {
	bBeep=False
	DrawColor=(R=255,G=255,B=255)
	SpecialMessage(0)=""
	SpecialMessage(1)="Deflect!"
	SpecialMessage(2)=""
	SpecialMessage(3)=""
	SpecialMessage(4)="Direct Hit Bio!"
	SpecialMessage(5)="Excellent!"
	SpecialMessage(6)="Block!"
	SpecialMessage(7)="Standstill Combo!"
	SpecialMessage(8)="Dual Midair!"
	SpecialMessage(9)=""
	SpecialMessage(10)=""
	SpecialMessage(11)=""
	SpecialMessage(12)="Direct Hit Ripper!"
	SpecialMessage(13)="8 Hit Streak!"
	SpecialMessage(14)="Perfect Flak +8!"
	SpecialMessage(15)="Direct Hit Slug!"
	SpecialMessage(16)="Direct Hit Rocket!"
	SpecialMessage(17)="Non-bouncey Pipe!"
	SpecialMessage(18)=""
	SpecialMessage(19)=""
	SpecialMessage2(0)="Capture Assist!"
	SpecialMessage2(1)="Solo Capture!"
	SpecialMessage2(2)="Close Call!"
}
