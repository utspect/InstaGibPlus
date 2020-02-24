class ST_SniperArenaRifle extends ST_SniperRifle;

simulated function PlayFiring()
{
	local int r;

	PlayOwnedSound(FireSound, SLOT_None, Pawn(Owner).SoundDampening*3.0);
	PlayAnim(FireAnims[Rand(5)], 0.5 + 0.5 * FireAdjust, 0.05);

	if ( (PlayerPawn(Owner) != None) 
		&& (PlayerPawn(Owner).DesiredFOV == PlayerPawn(Owner).DefaultFOV) )
		bMuzzleFlash++;
}

defaultproperties
{
     hitdamage=45.000000
     HeadDamage=100.000000
     BodyHeight=0.620000
     SniperSpeed=1.000000
}
