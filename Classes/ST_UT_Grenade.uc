// ===============================================================
// Stats.ST_UT_Grenade: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_UT_Grenade extends UT_Grenade;

var ST_Mutator STM;

function BlowUp(vector HitLocation)
{
	STM.PlayerHit(Instigator, 17, !bCanHitOwner);	// bCanHitOwner is set to True after the Grenade has bounced once. Neat hax
	HurtRadius(damage, 200, MyDamageType, MomentumTransfer, HitLocation);
	STM.PlayerClear();
	MakeNoise(1.0);
}

defaultproperties {
}
