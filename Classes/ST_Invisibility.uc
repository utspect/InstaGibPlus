class ST_Invisibility extends UT_Invisibility;

state Activated {
	function BeginState() {
		local ST_ShieldBelt S;

		bActive = true;
		PlaySound(ActivateSound,,4.0);

		Owner.SetDisplayProperties(
			ERenderStyle.STY_Translucent,
			FireTexture'unrealshare.Belt_fx.Invis',
			false,
			true
		);
		SetTimer(0.5, true);
		S = ST_ShieldBelt(Pawn(Owner).FindInventoryType(class'ST_ShieldBelt'));
		if ((S != none) && (S.MyEffect != none)) {
			S.MyEffect.bHidden = true;
		}
	}

	function EndState() {
		local ST_ShieldBelt S;

		bActive = false;
		PlaySound(DeactivateSound);

		Owner.SetDefaultDisplayProperties();
		Pawn(Owner).Visibility = Pawn(Owner).default.Visibility;
		S = ST_ShieldBelt(Pawn(Owner).FindInventoryType(class'ST_ShieldBelt'));
		if ((S != none) && (S.MyEffect != none))
			S.MyEffect.bHidden = false;
	}

	function SetOwnerDisplay() {
		//Prevent SetOwnerDisplay being run twice (and infinite if coupled with UT_Stealth)
		if (bActive && Pawn(Owner) != none && !Pawn(Owner).bUpdatingDisplay) {
			Pawn(Owner).bUpdatingDisplay = true;
			Owner.SetDisplayProperties(
				ERenderStyle.STY_Translucent,
				FireTexture'unrealshare.Belt_fx.Invis',
				true,
				true
			);
		}

		if (Inventory != none)
			Inventory.SetOwnerDisplay();
	}

	function ChangedWeapon() {
		if (Inventory != none)
			Inventory.ChangedWeapon();

		// Make new weapon invisible.
		if (bActive && Pawn(Owner).Weapon != none)
			Pawn(Owner).Weapon.SetDisplayProperties(
				ERenderStyle.STY_Translucent, 
				FireTexture'Unrealshare.Belt_fx.Invis',
				true,
				true
			);
	}
}
