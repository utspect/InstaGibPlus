// ===============================================================
// Stats.ST_ChallengeBotInfo: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_ChallengeBotInfo extends ChallengeBotInfo;

// Change into our bots, so we get good stats!
function class<bot> CHGetBotClass(int n)
{
	local string BotClassName;
	local Class<Bot> BotClass, BotClassNew;

	BotClassName = GetBotClassName(n);
	BotClass = Class<Bot>(DynamicLoadObject(BotClassName, Class'Class'));

	if (Left(BotClassName, 8) ~= "BotPack.")
	{
		BotClassName = Class'ST_Mutator'.Default.PreFix$Class'UTPure'.Default.ThisVer$".ST_"$Mid(BotClassName, 8);
		BotClassNew = Class<Bot>(DynamicLoadObject(BotClassName, Class'Class'));
		if (BotClassNew != None)
			BotClass = BotClassNew;
	}
	return BotClass;
}

defaultproperties
{
}
