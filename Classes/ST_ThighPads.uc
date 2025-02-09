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

	Copy = super(TournamentPickup).SpawnCopy(Other);
	S = Other.FindInventoryType(class'ST_ShieldBelt');
	if (S != none) {
		Copy.Charge = Min(Copy.Charge, S.default.Charge - S.Charge);
		if (Copy.Charge <= 0) {
			S.Charge -= 1;
			Copy.Charge = 1;
		}
	}
	return Copy;
}
