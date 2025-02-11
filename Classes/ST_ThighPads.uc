class ST_ThighPads extends ThighPads;

function bool HandlePickupQuery(Inventory Item) {
	local inventory S;

	if (Item.Class == Class) {
		S = Pawn(Owner).FindInventoryType(class'ST_ShieldBelt');
		if (S == none)
			Charge = Item.Charge;
		else
			Charge = Clamp(S.default.Charge - S.Charge, Charge, Item.Charge);
		if (Level.Game.LocalLog != none)
			Level.Game.LocalLog.LogPickup(Item, Pawn(Owner));
		if (Level.Game.WorldLog != none)
			Level.Game.WorldLog.LogPickup(Item, Pawn(Owner));
		if ( PickupMessageClass == none )
			Pawn(Owner).ClientMessage(PickupMessage, 'Pickup');
		else
			Pawn(Owner).ReceiveLocalizedMessage(PickupMessageClass, 0, none, none, self.Class);
		Item.PlaySound(PickupSound,,2.0);
		Item.SetReSpawn();
		return true;
	}

	if (Inventory == none)
		return false;
	return Inventory.HandlePickupQuery(Item);
}

function inventory SpawnCopy(Pawn Other) {
	local Inventory Copy, S;
	local int Armor;

	Copy = super(TournamentPickup).SpawnCopy(Other);
	for (S = Other.Inventory; S != none; S = S.Inventory)
		if (S != Copy && S.bIsAnArmor)
			Armor += S.Charge;

	Copy.Charge = Min(Copy.Charge, class'UT_ShieldBelt'.default.Charge - Armor);
	if (Copy.Charge <= 0)
		Copy.Destroy();

	return Copy;
}
