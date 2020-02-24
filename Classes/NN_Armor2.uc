class NN_Armor2 extends Armor2;

function PickupFunction(Pawn Other)
{
	local Inventory I;
	local int ArmorAmount, Reduction;
	
	ArmorAmount = Charge;
	
	for ( I=Owner.Inventory; I!=None; I=I.Inventory )
		if ( I.bIsAnArmor && (I != self) )
			ArmorAmount += I.Charge;
	
	if (ArmorAmount > 150)
	{
		Reduction = ArmorAmount - 150;
		if (Reduction < Charge)
			Charge -= Reduction;
		else
			Destroy();
	}
}

defaultproperties
{
}
