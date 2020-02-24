//=============================================================================
// ST_ShellBox.
//=============================================================================
class ST_ShellBox extends ST_Ammos;

defaultproperties
{
    AmmoAmount=50
    MaxAmmo=200
    UsedInWeaponSlot(6)=1
    PickupMessage="You picked up 50 bullets"
    PickupViewMesh=LodMesh'ShellBoxMesh'
    Icon=Texture'Icons.I_ShellAmmo'
    Mesh=LodMesh'ShellBoxMesh'
    CollisionRadius=22.00
    CollisionHeight=11.00
}
