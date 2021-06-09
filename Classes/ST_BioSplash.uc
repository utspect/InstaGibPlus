// ===============================================================
// UTPureStats7A.ST_BioSplash: put your comment here

// Created by UClasses - (C) 2000-2001 by meltdown@thirdtower.com
// ===============================================================

class ST_BioSplash extends ST_UT_BioGel;

auto state Flying
{
	function ProcessTouch (Actor Other, vector HitLocation) 
	{ 
		if ( Other.IsA('ST_UT_BioGel') && (LifeSpan > Default.LifeSpan - 0.2) )
			return;
		if ( Pawn(Other)!=Instigator || bOnGround) 
			Global.Timer(); 
	}
}

defaultproperties
{
     speed=300.000000
}
