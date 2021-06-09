class NN_SniperArenaRifle extends NN_SniperRifle;

simulated function PlayFiring()
{
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
