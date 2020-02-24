// ====================================================================
//  Class:  BotBGone.ModifyLoginHandler
//  Parent: Engine.Actor
//
//  <Enter a description here>
// ====================================================================

class ModifyLoginHandler extends Actor;

var ModifyLoginHandler NextMLH;		// Link list of handlers
var string	LogLine, NeededPack;	// Required player pack to accept this one

final function Add(ModifyLoginHandler MLH)
{
	if (NextMLH == None)
	{
		NextMLH = MLH;
		MLH.NextMLH = None;
	}
	else
		NextMLH.Add(MLH);
}

function bool CanAdd(string spacks, int ppCnt)
{
	return false;
}

final function bool HasPack(string spacks, string NeededPack)
{
	if (Instr(CAPS(spacks), Caps(Chr(34)$NeededPack$Chr(34))) == -1)
	{
		Log("'"$GetPackName()$"' requires module '"$NeededPack$"' to load properly");
		return false;
	}
	return true;
}

final function string GetPackName()
{
local string str;
local int p;

	str = ""$class;
	p = Instr(str, ".");
	if (p == -1)
		return str;
	return Left(str, p);
}

// Called once the 
function Accepted();

function ModifyLogin(out class<playerpawn> SpawnClass, out string Portal, out string Options)
{	
	If (NextMLH != None)
		NextMLH.ModifyLogin(SpawnClass, Portal, Options);
}

defaultproperties
{
     bHidden=True
}
