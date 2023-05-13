class NN_SniperArenaRifle extends NN_SniperRifle;

simulated function PlayFiring()
{
	PlayOwnedSound(FireSound, SLOT_None, Pawn(Owner).SoundDampening*3.0);
	PlayAnim(FireAnims[Rand(5)], 0.66666666 / GetWeaponSettings().SniperReloadTime, 0.05);

	if ( (PlayerPawn(Owner) != None)
		&& (PlayerPawn(Owner).DesiredFOV == PlayerPawn(Owner).DefaultFOV) )
		bMuzzleFlash++;
}

defaultproperties
{
     BodyHeight=0.620000
}
