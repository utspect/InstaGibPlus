class ST_ShieldBelt extends UT_ShieldBelt;

function PickupFunction(Pawn Other) {
	local Inventory I;

	MyEffect = Spawn(class'ST_ShieldBeltEffect', Other,,Other.Location, Other.Rotation); 
	MyEffect.Mesh = Owner.Mesh;
	MyEffect.DrawScale = Owner.Drawscale;

	if (Level.Game.bTeamGame && (Other.PlayerReplicationInfo != none))
		TeamNum = Other.PlayerReplicationInfo.Team;
	else
		TeamNum = 3;
	SetEffectTexture();

	I = Pawn(Owner).FindInventoryType(class'ST_Invisibility');
	if (I != none)
		MyEffect.bHidden = true;
	
	// remove other armors
	for (I = Owner.Inventory; I != None; I = I.Inventory)
		if (I.bIsAnArmor && (I != self))
			I.Destroy();
}
