//=============================================================================
// ST_RifleAmmo.
//=============================================================================
class ST_RifleAmmo extends ST_Ammos;

defaultproperties
{
	AmmoAmount=8
	MaxAmmo=50
	UsedInWeaponSlot(9)=1
	PickupMessage="You got 8 Rifle rounds."
	PickupViewMesh=LodMesh'UnrealI.RifleBullets'
	MaxDesireability=0.240000
	Icon=Texture'UnrealI.I_RIFLEAmmo'
	Mesh=LodMesh'UnrealI.RifleBullets'
	CollisionRadius=15.000000
	CollisionHeight=20.000000
}